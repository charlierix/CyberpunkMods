--===========================================================================
-- Hover Rot Tester Player 5 — Disable Locomotion + Airborne Rotation
--
-- Step 1 from testers/hover_rot_tester_player3/next steps.md:
--   "Try EnableTransformUpdates(false) + SetWorldTransform"
--
-- Hypothesis: EnableTransformUpdates(false) stops the locomotion system from
-- overriding our transform. If so, SetWorldTransform may actually work for
-- setting player body orientation (roll, pitch, yaw) — which was a no-op in
-- testers 1-4a without this flag.
--
-- To minimize ground interference, the player is teleported high up (z+100)
-- and re-teleported whenever z drops below z+10.
--
-- Teleport is used ONLY for position management (initial + when falling),
-- NOT every frame — to avoid interfering with the test.
-- SetWorldTransform is called every frame to set orientation (the actual test).
--
-- After each Teleport, EnableTransformUpdates(false) is re-applied in case
-- Teleport resets the locomotion state.
--
-- Hotkeys (bind in Settings > Key Bindings > HoverRotTesterPlayer5):
--   1. Toggle Hover (Player5)       — enable/disable the tester
--   2. Yaw +30 (Player5)           — rotate yaw +ROT_STEP
--   3. Yaw -30 (Player5)           — rotate yaw -ROT_STEP
--   4. Pitch +30 (Player5)         — rotate pitch +ROT_STEP
--   5. Pitch -30 (Player5)         — rotate pitch -ROT_STEP
--   6. Roll +30 (Player5)          — rotate roll +ROT_STEP
--   7. Roll -30 (Player5)          — rotate roll -ROT_STEP
--
-- Install: Copy to bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player5
--===========================================================================

local ModName  = "HoverRotTesterPlayer5"
local ROT_STEP = 30    -- degrees per rotation press
local NUM_DIAG = 3     -- frames of debug output after a change

--===========================================================================
-- State
--===========================================================================

local state = {
    phase    = "IDLE",   -- IDLE | ACTIVE
    quat     = nil,      -- {w, x, y, z} current orientation
    initialZ = 0,        -- player's z when activated
    targetZ  = 0,        -- initialZ + 100 (where to hover)
    reTeleportThreshold = 0,  -- initialZ + 10 (re-teleport if below this)
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

--===========================================================================
-- Helpers
--===========================================================================

-- Re-apply EnableTransformUpdates(false) after a Teleport
-- Teleport may reset the locomotion state, so we re-disable it
local function reapplyLocomotionDisable(player)
    local ok = pcall(function()
        player:EnableTransformUpdates(false)
    end)
    print(string.format("[%s] Re-applied EnableTransformUpdates(false) after teleport (ok=%s)", ModName, tostring(ok)))
    return ok
end

local function teleportToHeight(player, height)
    local pos = player:GetWorldPosition()
    local roll, pitch, yaw = Quat.toEulerRaw(state.quat)
    local euler = EulerAngles.new(roll, pitch, yaw)

    pcall(function()
        Game.GetTeleportationFacility():Teleport(
            player,
            Vector4.new(pos.x, pos.y, height, 1),
            euler
        )
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

    -- Store initial z and compute targets
    state.initialZ = pos.z
    state.targetZ  = pos.z + 50     -- tried 100, but it brings up a loading screen
    state.reTeleportThreshold = pos.z + 10

    -- Initialize quaternion from current yaw so player doesn't snap
    state.quat = Quat.fromAxisAngle(0, 0, 1, rot.yaw)

    -- STEP 1: Disable locomotion — EnableTransformUpdates(false)
    -- This stops the locomotion system from overriding our transform.
    -- If this works, SetWorldTransform may actually set body orientation.
    local tuOk = pcall(function()
        player:EnableTransformUpdates(false)
    end)
    print(string.format("[%s] EnableTransformUpdates(false) applied (ok=%s)", ModName, tostring(tuOk)))

    -- Lock FPPCameraComponent to stop mouse override
    pcall(function()
        local cam = player:GetFPPCameraComponent()
        if cam then
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
            print(string.format("[%s] FPPCameraComponent locked (sensitivity=0, limits expanded)", ModName))
        end
    end)

    -- Teleport player high up immediately (z+100) to get airborne
    teleportToHeight(player, state.targetZ)

    print(string.format("[%s] Teleported to z+100 (target z=%.1f)", ModName, state.targetZ))

    -- Verify locomotion is still disabled after teleport
    reapplyLocomotionDisable(player)

    state.phase = "ACTIVE"
    print(string.format("[%s] === ACTIVE === target z=%.1f (initial z=%.1f)", ModName, state.targetZ, state.initialZ))
    print(string.format("[%s] Starting yaw=%.1f roll=%.1f pitch=%.1f", ModName, rot.yaw, rot.roll, rot.pitch))
    print(string.format("[%s] Re-teleport when z < %.1f", ModName, state.reTeleportThreshold))
    print(string.format("[%s] Using SetWorldTransform for orientation each frame (step 1 test)", ModName))

    state.diagCounter = NUM_DIAG
end

local function deactivate()
    print(string.format("[%s] Deactivating...", ModName))

    local player = Game.GetPlayer()
    if player then
        -- do a final teleport so the player doesn't fall to their death
        teleportToHeight(player, state.reTeleportThreshold)

        -- Re-enable locomotion — ONLY done here, on deactivate
        pcall(function()
            player:EnableTransformUpdates(true)
        end)
        print(string.format("[%s] EnableTransformUpdates(true) — locomotion re-enabled", ModName))

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

    print(string.format("[%s] Deactivated (locomotion re-enabled)", ModName))
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
-- Hotkeys (ROOT LEVEL — CET discovers these before onInit)
--===========================================================================

-- Toggle enable/disable: activates or deactivates the tester
-- On activate: disables locomotion, teleports high up
-- On deactivate: re-enables locomotion (the ONLY time it's re-enabled)
registerHotkey("HRTP5_Toggle", "Toggle Hover (Player5)", function()
    if state.phase == "IDLE" then
        activate()
    else
        deactivate()
    end
end)

-- 6 rotation hotkeys: yaw/pitch/roll +/-
registerHotkey("HRTP5_YawPos", "Yaw +30 (Player5)", function()
    applyRotation(0, 0, 1, ROT_STEP)
end)

registerHotkey("HRTP5_YawNeg", "Yaw -30 (Player5)", function()
    applyRotation(0, 0, 1, -ROT_STEP)
end)

registerHotkey("HRTP5_PitchPos", "Pitch +30 (Player5)", function()
    applyRotation(1, 0, 0, ROT_STEP)
end)

registerHotkey("HRTP5_PitchNeg", "Pitch -30 (Player5)", function()
    applyRotation(1, 0, 0, -ROT_STEP)
end)

registerHotkey("HRTP5_RollPos", "Roll +30 (Player5)", function()
    applyRotation(0, 1, 0, ROT_STEP)
end)

registerHotkey("HRTP5_RollNeg", "Roll -30 (Player5)", function()
    applyRotation(0, 1, 0, -ROT_STEP)
end)

--===========================================================================
-- Event Handlers
--===========================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized -- press toggle hotkey to start", ModName))
    print(string.format("[%s] Step 1: EnableTransformUpdates(false) + SetWorldTransform + airborne teleport", ModName))
end)

registerForEvent("onUpdate", function(delta)
    if state.phase ~= "ACTIVE" then return end

    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        deactivate()
        return
    end

    -- Diagnostic throttle: only print for N frames after a change
    local printDiag = state.diagCounter > 0
    if printDiag then
        state.diagCounter = state.diagCounter - 1
    end

    local pos = player:GetWorldPosition()

    -----------------------------------------------------------------------
    -- CHECK Z: Re-teleport if player has fallen below threshold
    -----------------------------------------------------------------------

    if pos.z < state.reTeleportThreshold then
        print(string.format("[%s] z=%.1f below threshold %.1f — re-teleporting to z=%.1f",
            ModName, pos.z, state.reTeleportThreshold, state.targetZ))

        teleportToHeight(player, state.targetZ)

        -- Verify locomotion is still disabled after re-teleport
        reapplyLocomotionDisable(player)

        state.diagCounter = NUM_DIAG
        -- Skip SetWorldTransform this frame — we just teleported
        return
    end

    -----------------------------------------------------------------------
    -- STEP 1 TEST: SetWorldTransform with target orientation
    -- This is the core test — does SetWorldTransform work for orientation
    -- when EnableTransformUpdates(false) is in effect?
    -----------------------------------------------------------------------

    local roll, pitch, yaw = Quat.toEulerRaw(state.quat)
    local targetEuler = EulerAngles.new(roll, pitch, yaw)
    local targetQuat = targetEuler:ToQuat()

    if printDiag then
        print(string.format("[%s] DIAG target euler: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, roll, pitch, yaw))

        local eulerBefore = player:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG BEFORE SetWorldTransform: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerBefore.roll, eulerBefore.pitch, eulerBefore.yaw))
    end

    -- Build WorldTransform with current position + target orientation
    local swtOk, swtErr = pcall(function()
        local wt = WorldTransform.new()
        wt:SetPosition(Vector4.new(pos.x, pos.y, pos.z, 1))
        wt:SetOrientation(targetQuat)
        player:SetWorldTransform(wt)
    end)

    if printDiag then
        if swtOk then
            print(string.format("[%s] SetWorldTransform SUCCESS", ModName))
        else
            print(string.format("[%s] SetWorldTransform FAILED: %s", ModName, tostring(swtErr)))
        end

        -- Check orientation AFTER SetWorldTransform
        local eulerAfter = player:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG AFTER SetWorldTransform: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerAfter.roll, eulerAfter.pitch, eulerAfter.yaw))

        local posAfter = player:GetWorldPosition()
        print(string.format("[%s] DIAG pos: (%.1f, %.1f, %.1f) target z=%.1f threshold=%.1f",
            ModName, posAfter.x, posAfter.y, posAfter.z, state.targetZ, state.reTeleportThreshold))

        -- Check if orientation stuck
        local rollMatch  = math.abs(eulerAfter.roll  - roll)  < 1.0
        local pitchMatch = math.abs(eulerAfter.pitch - pitch) < 1.0
        local yawMatch   = math.abs(eulerAfter.yaw   - yaw)   < 1.0
        print(string.format("[%s] DIAG MATCH: roll=%s pitch=%s yaw=%s",
            ModName, tostring(rollMatch), tostring(pitchMatch), tostring(yawMatch)))
    end
end)

registerForEvent("onShutdown", function()
    if state.phase ~= "IDLE" then
        deactivate()
    end
end)
