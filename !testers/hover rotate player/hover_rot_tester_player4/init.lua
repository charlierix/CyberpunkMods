--===========================================================================
-- Hover Rot Tester Player 4 — Teleport-Based Rotation
--
-- Tests whether TeleportationFacility:Teleport() with FULL EulerAngles
-- (roll, pitch, yaw) actually changes the player's body orientation, or
-- whether the locomotion system still overrides roll/pitch.
--
-- Prior testers confirmed:
--   - SetWorldTransform is a no-op on player (testers 1-3)
--   - Player has no ragdoll component, CanRagdoll()=false (tester 3)
--   - TeleportationFacility:Teleport(player, pos, EulerAngles) exists (tester 3)
--
-- This tester also tries passing a Quaternion directly as the 3rd arg
-- in case there's an undocumented overload.
--
-- Install: Copy to bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player4
-- Bind hotkeys in: Settings > Key Bindings > HoverRotTesterPlayer4
--===========================================================================

local ModName       = "HoverRotTesterPlayer4"
local HOVER_HEIGHT  = 3.0   -- meters above ground
local ROT_STEP      = 30    -- degrees per rotation press
local NUM_DIAG      = 3     -- frames of debug output after a change
local GRAVITY       = 16.0  -- m/s^2 (from jetpack mod source)

-- Spring-damper hover parameters
local SPRING_K      = 200.0  -- spring constant for vertical hover
local DAMPING_K     = 30.0   -- damping for vertical hover
local HORIZ_DAMP_K  = 10.0   -- horizontal velocity damping
local MAX_DV       = 50.0   -- max delta-v per frame

--===========================================================================
-- State
--===========================================================================

local state = {
    phase     = "IDLE",   -- IDLE | ACTIVE
    hoverX    = 0,
    hoverY    = 0,
    hoverZ    = 0,
    quat      = nil,       -- {w, x, y, z} current orientation
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
    -- Try quaternion-direct teleport on one hotkey
    tryQuatDirect = false,
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

function Quat.toEuler(q)
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

    -- EulerAngles.new(roll, pitch, yaw) — confirmed by vehicle2 + Jackie's Garage pattern
    return EulerAngles.new(math.deg(roll), math.deg(pitch), math.deg(yaw))
end

function Quat.toGameQuat(q)
    q = Quat.normalize(q)
    -- Quaternion.new(x, y, z, w) — args are (x, y, z, w), NOT (w, x, y, z)
    -- Confirmed working in jetpack mod and vehicle2
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

local function zeroVelocity(player)
    pcall(function()
        local imp = PSMImpulse.new()
        imp.id = "impulse"
        imp.impulse = Vector4.new(0, 0, 0, 0)
        player:QueueEvent(imp)
    end)
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

            -- Zero mouse sensitivity — stop mouse from overriding orientation
            cam.sensitivityMultX = 0
            cam.sensitivityMultY = 0
            -- Expand pitch/yaw limits for full range
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

    state.phase = "ACTIVE"
    print(string.format("[%s] Active -- hovering at (%.1f, %.1f, %.1f) groundZ=%.1f height=%.1f (camFound=%s)",
        ModName, state.hoverX, state.hoverY, state.hoverZ, groundZ, HOVER_HEIGHT, tostring(camFound)))
    print(string.format("[%s] Starting yaw=%.1f roll=%.1f pitch=%.1f", ModName, rot.yaw, rot.roll, rot.pitch))

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
    state.tryQuatDirect = false

    print(string.format("[%s] Deactivated", ModName))
end

local function applyRotation(ax, ay, az, deg)
    if state.phase ~= "ACTIVE" or not state.quat then return end
    local rot = Quat.fromAxisAngle(ax, ay, az, deg)
    state.quat = Quat.mul(state.quat, rot)
    state.diagCounter = NUM_DIAG
    local euler = Quat.toEuler(state.quat)
    print(string.format("[%s] Rot -> roll=%.0f pitch=%.0f yaw=%.0f",
        ModName, euler.roll, euler.pitch, euler.yaw))
end

--===========================================================================
-- Hotkeys (root level — CET discovers these before onInit)
--===========================================================================

registerHotkey("HRTP4_Toggle", "Toggle Hover (Player4)", function()
    if state.phase == "IDLE" then
        activate()
    else
        deactivate()
    end
end)

registerHotkey("HRTP4_YawPos", "Yaw +30 (Player4)", function()
    applyRotation(0, 0, 1, ROT_STEP)
end)

registerHotkey("HRTP4_YawNeg", "Yaw -30 (Player4)", function()
    applyRotation(0, 0, 1, -ROT_STEP)
end)

registerHotkey("HRTP4_PitchPos", "Pitch +30 (Player4)", function()
    applyRotation(1, 0, 0, ROT_STEP)
end)

registerHotkey("HRTP4_PitchNeg", "Pitch -30 (Player4)", function()
    applyRotation(1, 0, 0, -ROT_STEP)
end)

registerHotkey("HRTP4_RollPos", "Roll +30 (Player4)", function()
    applyRotation(0, 1, 0, ROT_STEP)
end)

registerHotkey("HRTP4_RollNeg", "Roll -30 (Player4)", function()
    applyRotation(0, 1, 0, -ROT_STEP)
end)

-- Toggle between EulerAngles and direct Quaternion for the Teleport 3rd arg
registerHotkey("HRTP4_QuatMode", "Toggle Quat-Direct Teleport (Player4)", function()
    state.tryQuatDirect = not state.tryQuatDirect
    state.diagCounter = NUM_DIAG
    print(string.format("[%s] Quat-Direct Teleport mode: %s", ModName, tostring(state.tryQuatDirect)))
end)

--===========================================================================
-- Event Handlers
--===========================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized -- press toggle hotkey to start hovering", ModName))
    print(string.format("[%s] Uses TeleportationFacility:Teleport() with full EulerAngles from quaternion", ModName))
end)

registerForEvent("onUpdate", function(delta)
    if state.phase ~= "ACTIVE" then return end

    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        deactivate()
        return
    end

    -- Diagnostic throttle: only print for N frames after a rotation change
    local printDiag = state.diagCounter > 0
    if printDiag then
        state.diagCounter = state.diagCounter - 1
    end

    -----------------------------------------------------------------------
    -- 1. HOVER: PSMImpulse for position control (spring-damper)
    -----------------------------------------------------------------------

    local pos = player:GetWorldPosition()
    local vel = player:GetVelocity()

    -- Vertical spring-damper
    local dvZ = SPRING_K * (state.hoverZ - pos.z) - DAMPING_K * (vel.z or 0) + GRAVITY

    -- Horizontal damping (kill drift toward hover position)
    local dvX = SPRING_K * (state.hoverX - pos.x) - DAMPING_K * (vel.x or 0)
    local dvY = SPRING_K * (state.hoverY - pos.y) - DAMPING_K * (vel.y or 0)

    -- Clamp
    dvX = math.max(-MAX_DV, math.min(MAX_DV, dvX))
    dvY = math.max(-MAX_DV, math.min(MAX_DV, dvY))
    dvZ = math.max(-MAX_DV, math.min(MAX_DV, dvZ))

    pcall(function()
        local imp = PSMImpulse.new()
        imp.id = "impulse"
        imp.impulse = Vector4.new(dvX, dvY, dvZ, 0)
        player:QueueEvent(imp)
    end)

    -----------------------------------------------------------------------
    -- 2. TELEPORT: Set orientation via TeleportationFacility
    -----------------------------------------------------------------------

    local gameQuat = Quat.toGameQuat(state.quat)
    local targetEuler = Quat.toEuler(state.quat)

    if printDiag then
        print(string.format("[%s] DIAG target euler: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, targetEuler.roll, targetEuler.pitch, targetEuler.yaw))

        -- Log BEFORE teleport
        local eulerBefore = player:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG BEFORE Teleport: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerBefore.roll, eulerBefore.pitch, eulerBefore.yaw))
    end

    -- Teleport player to hover position with full EulerAngles
    -- This is the same pattern as vehicle2, but targeting the player
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
    -- 3. QUAT-DIRECT TEST: Try passing Quaternion as 3rd arg
    -----------------------------------------------------------------------

    if state.tryQuatDirect then
        local qOk, qErr = pcall(function()
            Game.GetTeleportationFacility():Teleport(
                player,
                Vector4.new(state.hoverX, state.hoverY, state.hoverZ, 1),
                gameQuat
            )
        end)

        if printDiag then
            if qOk then
                print(string.format("[%s] Teleport(Quaternion) SUCCESS -- overload exists!", ModName))
            else
                print(string.format("[%s] Teleport(Quaternion) FAILED: %s", ModName, tostring(qErr)))
            end
        end
    end

    -----------------------------------------------------------------------
    -- 4. DIAGNOSTIC: Log orientation AFTER teleport
    -----------------------------------------------------------------------

    if printDiag then
        local eulerAfter = player:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG AFTER Teleport: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerAfter.roll, eulerAfter.pitch, eulerAfter.yaw))

        local posAfter = player:GetWorldPosition()
        print(string.format("[%s] DIAG pos after: (%.1f, %.1f, %.1f) target: (%.1f, %.1f, %.1f)",
            ModName, posAfter.x, posAfter.y, posAfter.z,
            state.hoverX, state.hoverY, state.hoverZ))

        -- Check if orientation stuck
        local rollMatch = math.abs(eulerAfter.roll - targetEuler.roll) < 1.0
        local pitchMatch = math.abs(eulerAfter.pitch - targetEuler.pitch) < 1.0
        local yawMatch = math.abs(eulerAfter.yaw - targetEuler.yaw) < 1.0
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
