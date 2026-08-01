--===========================================================================
-- Hover Rot Tester Player 4a — Teleport + EnableTransformUpdates + Euler Alternates
--
-- Based on Player 4 with key changes:
--   - PSMImpulse removed entirely — Teleport handles both position AND orientation
--   - Toggle for EnableTransformUpdates(false) — the #1 untested approach from Player 3
--   - Toggle for EulerAngles constructor order alternates
--   - Toggle for FPPCameraComponent SetLocalOrientation (camera rotation fallback)
--   - Comprehensive logging of all active options on activation, toggle, and diagnostics
--
-- Toggles work both BEFORE and AFTER activation:
--   - If toggled while IDLE: stored, applied on next activation
--   - If toggled while ACTIVE: applied immediately
--
-- Prior testers confirmed:
--   - SetWorldTransform is a no-op on player (testers 1-3)
--   - Player has no ragdoll, CanRagdoll()=false (tester 3)
--   - Teleport(EulerAngles) sets yaw + position but roll/pitch clamped to 0 by locomotion (tester 4)
--   - EnableTransformUpdates(false) exists in reflection dump but was NEVER tested (tester 3)
--
-- Install: Copy to bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player4a
-- Bind hotkeys in: Settings > Key Bindings > HoverRotTesterPlayer4a
--===========================================================================

local ModName       = "HoverRotTesterPlayer4a"
local HOVER_HEIGHT  = 3.0   -- meters above ground
local ROT_STEP      = 30    -- degrees per rotation press
local NUM_DIAG      = 3     -- frames of debug output after a change

--===========================================================================
-- EulerAngles constructor order alternates
--
-- The quaternion math computes roll (X), pitch (Y), yaw (Z) independently.
-- The question is which positional arg of EulerAngles.new(a, b, c) maps to
-- which axis. Player 4 used EulerAngles.new(roll, pitch, yaw) — confirmed for
-- vehicles but never verified for PlayerPuppet.
--===========================================================================

local EULER_ORDERS = {
    { "roll",  "pitch", "yaw"   },  -- 1: original — EulerAngles(roll, pitch, yaw)
    { "pitch", "roll",  "yaw"   },  -- 2: swap roll/pitch — EulerAngles(pitch, roll, yaw)
    { "yaw",   "pitch", "roll"  },  -- 3: reversed — EulerAngles(yaw, pitch, roll)
    { "roll",  "yaw",   "pitch" },  -- 4: swap pitch/yaw — EulerAngles(roll, yaw, pitch)
}

local EULER_ORDER_NAMES = {
    "EulerAngles(roll, pitch, yaw)",
    "EulerAngles(pitch, roll, yaw)",
    "EulerAngles(yaw, pitch, roll)",
    "EulerAngles(roll, yaw, pitch)",
}

--===========================================================================
-- State
--===========================================================================

local state = {
    phase     = "IDLE",   -- IDLE | ACTIVE
    hoverX    = 0,
    hoverY    = 0,
    hoverZ    = 0,
    quat      = nil,       -- {w, x, y, z} current orientation
    -- Toggles (set BEFORE or AFTER activation — both work)
    transformUpdatesEnabled = true,   -- false = EnableTransformUpdates(false)
    eulerOrderIdx  = 1,                -- index into EULER_ORDERS
    cameraRotate   = false,             -- true = also call cam:SetLocalOrientation(gameQuat)
    -- Saved camera settings
    savedSensX      = nil,
    savedSensY      = nil,
    savedHeading    = nil,
    savedPitchMin   = nil,
    savedPitchMax   = nil,
    savedYawMaxLeft  = nil,
    savedYawMaxRight = nil,
    -- Diagnostic print throttle
    diagCounter = 0,
}

--===========================================================================
-- Quaternion Math (pure Lua)
--===========================================================================

local Quat = {}

function Quat.identity()
    return { w = 1, x = 0, y = 0, z = 0 }
end

function Quat.fromAxisAngle(ax, ay, az, deg)
    local rad = math.rad(deg)
    local half = rad * 0.5
    local s = math.sin(half)
    return {
        w = math.cos(half),
        x = ax * s,
        y = ay * s,
        z = az * s,
    }
end

function Quat.mul(q1, q2)
    return {
        w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z,
        x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y,
        y = q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x,
        z = q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w,
    }
end

function Quat.normalize(q)
    local len = math.sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z)
    if len < 0.0001 then return Quat.identity() end
    return { w = q.w / len, x = q.x / len, y = q.y / len, z = q.z / len }
end

-- Returns raw roll, pitch, yaw in degrees (NOT wrapped in EulerAngles)
function Quat.toEulerRaw(q)
    q = Quat.normalize(q)
    local w, x, y, z = q.w, q.x, q.y, q.z

    -- Roll (x-axis rotation)
    local sinr_cosp = 2 * (w * x + y * z)
    local cosr_cosp = 1 - 2 * (x * x + y * y)
    local roll = math.atan2(sinr_cosp, cosr_cosp)

    -- Pitch (y-axis rotation)
    local sinp = 2 * (w * y - z * x)
    if math.abs(sinp) >= 1 then
        sinp = sinp > 0 and 1 or -1
    end
    local pitch = math.asin(sinp)

    -- Yaw (z-axis rotation)
    local siny_cosp = 2 * (w * z + x * y)
    local cosy_cosp = 1 - 2 * (y * y + z * z)
    local yaw = math.atan2(siny_cosp, cosy_cosp)

    return math.deg(roll), math.deg(pitch), math.deg(yaw)
end

function Quat.toGameQuat(q)
    q = Quat.normalize(q)
    -- Quaternion.new(x, y, z, w) — args are (x, y, z, w), NOT (w, x, y, z)
    return Quaternion.new(q.x, q.y, q.z, q.w)
end

--===========================================================================
-- Helpers
--===========================================================================

local function getGroundZ(x, y, z)
    local origin = Vector4.new(x, y, z + 1.0, 1)
    local dir    = Vector4.new(0, 0, -1, 0)
    local maxDist = 50.0
    local hit, hitPos
    pcall(function()
        local result = Game.GetSpatialQueriesSystem():SyncRaycastByQueryPreset(
            origin, dir, maxDist, "Bullet logic", false, false
        )
        if result then
            hit = true
            hitPos = result
        end
    end)
    if hit and hitPos then
        return hitPos.z
    end
    return z
end

-- Build EulerAngles in the currently selected constructor order
local function makeEuler(roll, pitch, yaw)
    local order = EULER_ORDERS[state.eulerOrderIdx]
    local vals = { roll = roll, pitch = pitch, yaw = yaw }
    return EulerAngles.new(vals[order[1]], vals[order[2]], vals[order[3]])
end

-- Print all toggle states
local function printOptions()
    print(string.format("[%s] === ACTIVE OPTIONS ===", ModName))
    print(string.format("[%s]   Hover:            %s", ModName,
        state.phase == "ACTIVE" and "ACTIVE" or "IDLE"))
    print(string.format("[%s]   TransformUpdates:  %s", ModName,
        state.transformUpdatesEnabled and "ENABLED (normal)" or "DISABLED (EnableTransformUpdates(false))"))
    print(string.format("[%s]   EulerOrder:        %d/%d = %s", ModName,
        state.eulerOrderIdx, #EULER_ORDERS, EULER_ORDER_NAMES[state.eulerOrderIdx]))
    print(string.format("[%s]   CameraRotate:      %s", ModName,
        state.cameraRotate and "ON (cam:SetLocalOrientation)" or "OFF"))
    print(string.format("[%s] =========================", ModName))
end

--===========================================================================
-- Activation / Deactivation
--===========================================================================

local function activate()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        print(string.format("[%s] ERROR: Player not found", ModName))
        return
    end

    local pos = player:GetWorldPosition()
    local rot = player:GetWorldOrientation():ToEulerAngles()
    local groundZ = getGroundZ(pos.x, pos.y, pos.z)

    state.hoverX = pos.x
    state.hoverY = pos.y
    state.hoverZ = groundZ + HOVER_HEIGHT

    -- Initialize quaternion from current yaw so player doesn't snap
    state.quat = Quat.fromAxisAngle(0, 0, 1, rot.yaw)

    -- Lock the player's FPPCameraComponent to stop mouse override
    local camFound = false
    pcall(function()
        local cam = player:GetFPPCameraComponent()
        if cam then
            camFound = true
            state.savedSensX      = cam.sensitivityMultX
            state.savedSensY      = cam.sensitivityMultY
            state.savedHeading    = cam.headingLocked
            state.savedPitchMin   = cam.pitchMin
            state.savedPitchMax   = cam.pitchMax
            state.savedYawMaxLeft  = cam.yawMaxLeft
            state.savedYawMaxRight = cam.yawMaxRight

            cam.sensitivityMultX = 0
            cam.sensitivityMultY = 0
            cam.pitchMin = -180
            cam.pitchMax = 180
            cam.yawMaxLeft = 360
            cam.yawMaxRight = 360
            print(string.format("[%s] FPPCameraComponent locked (sensitivity=0, pitch/yaw limits expanded)", ModName))
        end
    end)

    -- Apply NoJump status effect
    pcall(function()
        Game.GetStatusEffectSystem():ApplyStatusEffect(
            player:GetEntityID(),
            "GameplayRestriction.NoJump",
            player:GetRecordID(),
            player:GetEntityID()
        )
    end)

    -- Apply EnableTransformUpdates state (if disabled, stops locomotion override)
    if not state.transformUpdatesEnabled then
        local tuOk = pcall(function()
            player:EnableTransformUpdates(false)
        end)
        print(string.format("[%s] EnableTransformUpdates(false) applied on activate (ok=%s)", ModName, tostring(tuOk)))
    else
        pcall(function()
            player:EnableTransformUpdates(true)
        end)
        print(string.format("[%s] EnableTransformUpdates(true) — normal mode", ModName))
    end

    state.phase = "ACTIVE"
    print(string.format("[%s] Active -- hovering at (%.1f, %.1f, %.1f) groundZ=%.1f height=%.1f (camFound=%s)",
        ModName, state.hoverX, state.hoverY, state.hoverZ, groundZ, HOVER_HEIGHT, tostring(camFound)))
    print(string.format("[%s] Starting yaw=%.1f roll=%.1f pitch=%.1f", ModName, rot.yaw, rot.roll, rot.pitch))
    printOptions()

    state.diagCounter = NUM_DIAG
end

local function deactivate()
    print(string.format("[%s] Deactivating...", ModName))

    local player = Game.GetPlayer()
    if player then
        -- Restore FPPCameraComponent settings
        pcall(function()
            local cam = player:GetFPPCameraComponent()
            if cam then
                if state.savedSensX      then cam.sensitivityMultX = state.savedSensX end
                if state.savedSensY      then cam.sensitivityMultY = state.savedSensY end
                if state.savedHeading    then cam.headingLocked = state.savedHeading end
                if state.savedPitchMin   then cam.pitchMin = state.savedPitchMin end
                if state.savedPitchMax   then cam.pitchMax = state.savedPitchMax end
                if state.savedYawMaxLeft  then cam.yawMaxLeft = state.savedYawMaxLeft end
                if state.savedYawMaxRight then cam.yawMaxRight = state.savedYawMaxRight end
            end
        end)

        -- Re-enable transform updates (always restore to safe state)
        pcall(function()
            player:EnableTransformUpdates(true)
        end)

        -- Remove NoJump status effect
        pcall(function()
            StatusEffectHelper.RemoveStatusEffect(player, "GameplayRestriction.NoJump")
        end)
    end

    state.phase       = "IDLE"
    state.quat        = nil
    state.savedSensX  = nil
    state.savedSensY  = nil
    state.savedHeading = nil
    state.savedPitchMin = nil
    state.savedPitchMax = nil
    state.savedYawMaxLeft = nil
    state.savedYawMaxRight = nil
    state.diagCounter = 0

    print(string.format("[%s] Deactivated (transform updates re-enabled)", ModName))
end

local function applyRotation(ax, ay, az, deg)
    if state.phase ~= "ACTIVE" or not state.quat then return end
    local rot = Quat.fromAxisAngle(ax, ay, az, deg)
    state.quat = Quat.mul(state.quat, rot)
    state.diagCounter = NUM_DIAG
    local roll, pitch, yaw = Quat.toEulerRaw(state.quat)
    print(string.format("[%s] Rot -> roll=%.0f pitch=%.0f yaw=%.0f", ModName, roll, pitch, yaw))
end

--===========================================================================
-- Hotkeys (root level — CET discovers these before onInit)
--===========================================================================

registerHotkey("HRTP4A_Toggle", "Toggle Hover (Player4a)", function()
    if state.phase == "IDLE" then
        activate()
    else
        deactivate()
    end
end)

registerHotkey("HRTP4A_YawPos", "Yaw +30 (Player4a)", function()
    applyRotation(0, 0, 1, ROT_STEP)
end)

registerHotkey("HRTP4A_YawNeg", "Yaw -30 (Player4a)", function()
    applyRotation(0, 0, 1, -ROT_STEP)
end)

registerHotkey("HRTP4A_PitchPos", "Pitch +30 (Player4a)", function()
    applyRotation(1, 0, 0, ROT_STEP)
end)

registerHotkey("HRTP4A_PitchNeg", "Pitch -30 (Player4a)", function()
    applyRotation(1, 0, 0, -ROT_STEP)
end)

registerHotkey("HRTP4A_RollPos", "Roll +30 (Player4a)", function()
    applyRotation(0, 1, 0, ROT_STEP)
end)

registerHotkey("HRTP4A_RollNeg", "Roll -30 (Player4a)", function()
    applyRotation(0, 1, 0, -ROT_STEP)
end)

-- Toggle EnableTransformUpdates
-- When OFF: calls player:EnableTransformUpdates(false) — may stop locomotion from overriding roll/pitch
-- When ON: calls player:EnableTransformUpdates(true) — normal behavior (locomotion clamps roll/pitch to 0)
registerHotkey("HRTP4A_ToggleTransform", "Toggle TransformUpdates (Player4a)", function()
    state.transformUpdatesEnabled = not state.transformUpdatesEnabled
    -- Apply immediately if active
    if state.phase == "ACTIVE" then
        local player = Game.GetPlayer()
        if player then
            local ok = pcall(function()
                player:EnableTransformUpdates(state.transformUpdatesEnabled)
            end)
            print(string.format("[%s] TransformUpdates: %s (applied now, ok=%s)", ModName,
                state.transformUpdatesEnabled and "ENABLED (normal)" or "DISABLED (EnableTransformUpdates(false))",
                tostring(ok)))
        end
    else
        print(string.format("[%s] TransformUpdates: %s (will apply on next activate)", ModName,
            state.transformUpdatesEnabled and "ENABLED (normal)" or "DISABLED (EnableTransformUpdates(false))"))
    end
    state.diagCounter = NUM_DIAG
end)

-- Cycle EulerAngles constructor order
-- Tests whether the EulerAngles.new(a, b, c) constructor maps args to (roll, pitch, yaw)
-- or a different order for PlayerPuppet (vs vehicle)
registerHotkey("HRTP4A_CycleEuler", "Cycle Euler Order (Player4a)", function()
    state.eulerOrderIdx = state.eulerOrderIdx + 1
    if state.eulerOrderIdx > #EULER_ORDERS then
        state.eulerOrderIdx = 1
    end
    state.diagCounter = NUM_DIAG
    print(string.format("[%s] EulerOrder: %d/%d = %s", ModName,
        state.eulerOrderIdx, #EULER_ORDERS, EULER_ORDER_NAMES[state.eulerOrderIdx]))
end)

-- Toggle Camera SetLocalOrientation
-- When ON: also calls cam:SetLocalOrientation(gameQuat) each frame
-- This rotates the camera independently — useful if body rotation fails
registerHotkey("HRTP4A_ToggleCam", "Toggle Camera Rotate (Player4a)", function()
    state.cameraRotate = not state.cameraRotate
    state.diagCounter = NUM_DIAG
    print(string.format("[%s] CameraRotate: %s", ModName,
        state.cameraRotate and "ON (cam:SetLocalOrientation each frame)" or "OFF"))
end)

-- Print current status of all options
registerHotkey("HRTP4A_Status", "Print Status (Player4a)", function()
    printOptions()
end)

--===========================================================================
-- Event Handlers
--===========================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized -- press toggle hotkey to start hovering", ModName))
    print(string.format("[%s] Teleport-only hover (no impulse). Toggles: TransformUpdates, EulerOrder, CameraRotate", ModName))
    print(string.format("[%s] Toggle options BEFORE or AFTER activating hover — both work", ModName))
    printOptions()
end)

registerForEvent("onUpdate", function(delta)
    if state.phase ~= "ACTIVE" then return end

    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        deactivate()
        return
    end

    -- Diagnostic throttle: only print for N frames after a rotation/toggle change
    local printDiag = state.diagCounter > 0
    if printDiag then
        state.diagCounter = state.diagCounter - 1
    end

    -----------------------------------------------------------------------
    -- Build orientation from quaternion
    -----------------------------------------------------------------------

    local gameQuat = Quat.toGameQuat(state.quat)
    local roll, pitch, yaw = Quat.toEulerRaw(state.quat)
    local targetEuler = makeEuler(roll, pitch, yaw)

    if printDiag then
        print(string.format("[%s] DIAG target euler (raw): roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, roll, pitch, yaw))
        print(string.format("[%s] DIAG euler order: %s", ModName, EULER_ORDER_NAMES[state.eulerOrderIdx]))
        print(string.format("[%s] DIAG options: transformUpdates=%s | camRotate=%s",
            ModName,
            state.transformUpdatesEnabled and "ENABLED" or "DISABLED",
            state.cameraRotate and "ON" or "OFF"))

        local eulerBefore = player:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG BEFORE Teleport: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerBefore.roll, eulerBefore.pitch, eulerBefore.yaw))
    end

    -----------------------------------------------------------------------
    -- TELEPORT: Set position + orientation via TeleportationFacility
    -- This is the ONLY mechanism — no impulse, no SetWorldTransform
    -----------------------------------------------------------------------

    local tOk, tErr = pcall(function()
        Game.GetTeleportationFacility():Teleport(
            player,
            Vector4.new(state.hoverX, state.hoverY, state.hoverZ, 1),
            targetEuler
        )
    end)

    if printDiag then
        if tOk then
            print(string.format("[%s] Teleport(EulerAngles) SUCCESS", ModName))
        else
            print(string.format("[%s] Teleport(EulerAngles) FAILED: %s", ModName, tostring(tErr)))
        end
    end

    -----------------------------------------------------------------------
    -- CAMERA ROTATION (optional toggle)
    -- If enabled, rotate the FPP camera independently via SetLocalOrientation
    -----------------------------------------------------------------------

    if state.cameraRotate then
        local camOk, camErr = pcall(function()
            local cam = player:GetFPPCameraComponent()
            if cam then
                cam:SetLocalOrientation(gameQuat)
            end
        end)
        if printDiag and not camOk then
            print(string.format("[%s] cam:SetLocalOrientation FAILED: %s", ModName, tostring(camErr)))
        end
    end

    -----------------------------------------------------------------------
    -- DIAGNOSTIC: Log orientation AFTER teleport
    -----------------------------------------------------------------------

    if printDiag then
        local eulerAfter = player:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG AFTER Teleport: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerAfter.roll, eulerAfter.pitch, eulerAfter.yaw))

        local posAfter = player:GetWorldPosition()
        print(string.format("[%s] DIAG pos after: (%.1f, %.1f, %.1f) target: (%.1f, %.1f, %.1f)",
            ModName, posAfter.x, posAfter.y, posAfter.z,
            state.hoverX, state.hoverY, state.hoverZ))

        -- Check if orientation stuck (compare against raw target values)
        local rollMatch  = math.abs(eulerAfter.roll  - roll)  < 1.0
        local pitchMatch = math.abs(eulerAfter.pitch - pitch) < 1.0
        local yawMatch   = math.abs(eulerAfter.yaw   - yaw)   < 1.0
        print(string.format("[%s] DIAG MATCH: roll=%s pitch=%s yaw=%s",
            ModName, tostring(rollMatch), tostring(pitchMatch), tostring(yawMatch)))

        -- Log camera state
        pcall(function()
            local cam = player:GetFPPCameraComponent()
            if cam then
                local camEuler = cam:GetLocalOrientation():ToEulerAngles()
                print(string.format("[%s] DIAG CAM: roll=%.1f pitch=%.1f yaw=%.1f | sensX=%.1f sensY=%.1f | heading=%s",
                    ModName, camEuler.roll, camEuler.pitch, camEuler.yaw,
                    cam.sensitivityMultX, cam.sensitivityMultY, tostring(cam.headingLocked)))
            end
        end)
    end

end)

registerForEvent("onShutdown", function()
    if state.phase ~= "IDLE" then
        deactivate()
    end
end)
