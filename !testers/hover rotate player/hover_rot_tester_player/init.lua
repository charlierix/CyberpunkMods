--[[
  Hover & Rotation Tester - Player (SetWorldTransform approach)

  Tests whether player:SetWorldTransform() can rotate the player body in 6DOF.
  Hovers the player above ground via continuous SetWorldTransform every frame.
  6 hotkeys adjust yaw / pitch / roll by 30 degrees per press.

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player

  Bind hotkeys in: Settings > Key Bindings > HoverRotTesterPlayer

  Approach: SetWorldTransform on player with raw Quaternion orientation.
  This is the same pattern that works for vehicles (see hover_rot_tester_vehicle2).
  If the player entity has a physics rigid body, this should override
  the locomotion system's upright lock.
]]

local ModName       = "HoverRotTesterPlayer"
local HOVER_HEIGHT  = 3.0   -- meters above ground
local ROT_STEP      = 30    -- degrees per rotation press
local NUM_DIAG      = 3     -- how many update iterations to show debug after a change

--===========================================================================
-- State
--===========================================================================

local state = {
    phase     = "IDLE",   -- IDLE | ACTIVE
    hoverX    = 0,
    hoverY    = 0,
    hoverZ    = 0,
    quat      = nil,       -- {w, x, y, z} current orientation
    -- Saved camera settings for restore
    savedSensX      = nil,
    savedSensY      = nil,
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

    -- CET EulerAngles.new(roll, pitch, yaw)
    return EulerAngles.new(math.deg(roll), math.deg(pitch), math.deg(yaw))
end

function Quat.toGameQuat(q)
    q = Quat.normalize(q)
    -- Quaternion.new(x, y, z, w) — args are (x, y, z, w), NOT (w, x, y, z)
    return Quaternion.new(q.x, q.y, q.z, q.w)
end

--===========================================================================
-- Helper Functions
--===========================================================================

--- Raycast straight down to find ground Z height beneath a position.
local function getGroundZ(pos)
    local sqs = Game.GetSpatialQueriesSystem()
    if not sqs then return pos.z end

    local origin = Vector4.new(pos.x, pos.y, pos.z + 0.1, 0)
    local to     = Vector4.new(pos.x, pos.y, pos.z - 100.0, 0)

    local ok, hit, trace = pcall(function()
        return sqs:SyncRaycastByQueryPreset(
            origin, to, CName.new("Bullet logic"), true, false
        )
    end)

    if ok and hit and trace then
        return trace.position.z
    end
    return pos.z
end

--- Zero out the player's velocity via PSM impulse to prevent physics drift.
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

    -- Capture player position and find ground
    local pos = player:GetWorldPosition()
    local groundZ = getGroundZ(pos)

    state.hoverX = pos.x
    state.hoverY = pos.y
    state.hoverZ = groundZ + HOVER_HEIGHT

    -- Initialize quaternion from current yaw so the body doesn't snap
    local currentYaw = player:GetWorldYaw()
    state.quat = Quat.fromAxisAngle(0, 0, 1, currentYaw)

    -- Lock the player's FPPCameraComponent to stop mouse override
    local camFound = false
    pcall(function()
        local cam = player:GetFPPCameraComponent()
        if cam then
            camFound = true
            -- Save current values
            state.savedSensX       = cam.sensitivityMultX
            state.savedSensY       = cam.sensitivityMultY
            state.savedPitchMin    = cam.pitchMin
            state.savedPitchMax    = cam.pitchMax
            state.savedYawMaxLeft  = cam.yawMaxLeft
            state.savedYawMaxRight = cam.yawMaxRight

            -- Lock mouse sensitivity
            cam.sensitivityMultX = 0
            cam.sensitivityMultY = 0
            -- Expand pitch/yaw range so camera can follow any body orientation
            cam.pitchMin = -180
            cam.pitchMax = 180
            cam.yawMaxLeft = 360
            cam.yawMaxRight = 360
            print(string.format("[%s] FPPCameraComponent locked (sensitivity=0)", ModName))
        end
    end)

    -- Apply NoJump status effect to prevent jumping while hovering
    pcall(function()
        Game.GetStatusEffectSystem():ApplyStatusEffect(
            player:GetEntityID(),
            "GameplayRestriction.NoJump",
            player:GetRecordID(),
            player:GetEntityID()
        )
    end)

    state.phase = "ACTIVE"
    print(string.format("[%s] Active -- player hovering at (%.1f, %.1f, %.1f) groundZ=%.1f height=%.1f (camFound=%s)",
        ModName, state.hoverX, state.hoverY, state.hoverZ, groundZ, HOVER_HEIGHT, tostring(camFound)))

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
                if state.savedSensX       then cam.sensitivityMultX = state.savedSensX end
                if state.savedSensY       then cam.sensitivityMultY = state.savedSensY end
                if state.savedPitchMin    then cam.pitchMin = state.savedPitchMin end
                if state.savedPitchMax    then cam.pitchMax = state.savedPitchMax end
                if state.savedYawMaxLeft  then cam.yawMaxLeft = state.savedYawMaxLeft end
                if state.savedYawMaxRight then cam.yawMaxRight = state.savedYawMaxRight end
            end
        end)

        -- Remove NoJump status effect
        pcall(function()
            StatusEffectHelper.RemoveStatusEffect(player, "GameplayRestriction.NoJump")
        end)
    end

    state.phase          = "IDLE"
    state.quat           = nil
    state.savedSensX      = nil
    state.savedSensY      = nil
    state.savedPitchMin   = nil
    state.savedPitchMax   = nil
    state.savedYawMaxLeft  = nil
    state.savedYawMaxRight = nil
    state.diagCounter     = 0

    print(string.format("[%s] Deactivated", ModName))
end

local function applyRotation(ax, ay, az, deg)
    if state.phase ~= "ACTIVE" or not state.quat then return end
    local rot = Quat.fromAxisAngle(ax, ay, az, deg)
    state.quat = Quat.mul(state.quat, rot)  -- post-multiply for local-axis rotation
    state.diagCounter = NUM_DIAG
    local euler = Quat.toEuler(state.quat)
    print(string.format("[%s] Rot -> roll=%.0f pitch=%.0f yaw=%.0f",
        ModName, euler.roll, euler.pitch, euler.yaw))
end

--===========================================================================
-- Root-Level Hotkeys
-- (MUST be at file root — CET discovers these during its initial scan,
--  before onInit fires. See CET hotkey registration rule.)
--===========================================================================

registerHotkey("HRTP_Toggle", "Toggle Hover (Player)", function()
    if state.phase == "IDLE" then
        activate()
    else
        deactivate()
    end
end)

registerHotkey("HRTP_YawPos", "Yaw +30 (Player)", function()
    applyRotation(0, 0, 1, ROT_STEP)
end)

registerHotkey("HRTP_YawNeg", "Yaw -30 (Player)", function()
    applyRotation(0, 0, 1, -ROT_STEP)
end)

registerHotkey("HRTP_PitchPos", "Pitch +30 (Player)", function()
    applyRotation(1, 0, 0, ROT_STEP)
end)

registerHotkey("HRTP_PitchNeg", "Pitch -30 (Player)", function()
    applyRotation(1, 0, 0, -ROT_STEP)
end)

registerHotkey("HRTP_RollPos", "Roll +30 (Player)", function()
    applyRotation(0, 1, 0, ROT_STEP)
end)

registerHotkey("HRTP_RollNeg", "Roll -30 (Player)", function()
    applyRotation(0, 1, 0, -ROT_STEP)
end)

--===========================================================================
-- Event Handlers
--===========================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized — bind hotkeys in Settings > Key Bindings", ModName))
end)

registerForEvent("onUpdate", function(delta)
    if state.phase ~= "ACTIVE" then return end

    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        deactivate()
        return
    end

    -- Kill velocity so gravity / momentum can't pull the player off the hover point
    zeroVelocity(player)

    -- DIAGNOSTIC: only print for N frames after a rotation change
    local printDiag = state.diagCounter > 0
    if printDiag then
        state.diagCounter = state.diagCounter - 1
    end

    if printDiag then
        local targetEuler = Quat.toEuler(state.quat)
        print(string.format("[%s] DIAG target: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, targetEuler.roll, targetEuler.pitch, targetEuler.yaw))

        local eulerBefore = player:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG BEFORE: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerBefore.roll, eulerBefore.pitch, eulerBefore.yaw))
    end

    -- Build WorldTransform with hover position + quaternion orientation
    local gameQuat = Quat.toGameQuat(state.quat)

    local wtOk, wtErr = pcall(function()
        local wt = WorldTransform.new()
        wt:SetPosition(Vector4.new(state.hoverX, state.hoverY, state.hoverZ, 1))
        wt:SetOrientation(gameQuat)
        player:SetWorldTransform(wt)
    end)

    if printDiag then
        if wtOk then
            print(string.format("[%s] SetWorldTransform SUCCESS", ModName))
        else
            print(string.format("[%s] SetWorldTransform FAILED: %s", ModName, tostring(wtErr)))
        end

        -- Log orientation AFTER SetWorldTransform
        local eulerAfter = player:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG AFTER: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerAfter.roll, eulerAfter.pitch, eulerAfter.yaw))

        -- Log position after
        local posAfter = player:GetWorldPosition()
        print(string.format("[%s] DIAG pos after: (%.1f, %.1f, %.1f) target: (%.1f, %.1f, %.1f)",
            ModName, posAfter.x, posAfter.y, posAfter.z, state.hoverX, state.hoverY, state.hoverZ))

        -- Log camera state
        pcall(function()
            local cam = player:GetFPPCameraComponent()
            if cam then
                local camEuler = cam:GetLocalOrientation():ToEulerAngles()
                print(string.format("[%s] DIAG CAM: roll=%.1f pitch=%.1f yaw=%.1f | sensX=%.1f sensY=%.1f",
                    ModName, camEuler.roll, camEuler.pitch, camEuler.yaw,
                    cam.sensitivityMultX, cam.sensitivityMultY))
            end
        end)
    end
end)

registerForEvent("onShutdown", function()
    if state.phase ~= "IDLE" then
        deactivate()
    end
end)
