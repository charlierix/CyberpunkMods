--[[
  Hover & Rotation Tester - Player 2 (Impulse hover + SetWorldTransform orientation)

  V1 showed SetWorldTransform succeeds but is a complete no-op (position and
  orientation never change). This tester isolates the orientation test:
  - Hovers the player with PSMImpulse (like jetpack/grappling hook)
  - Calls SetWorldTransform with the player's CURRENT position + quaternion
    orientation only — not a fixed hover position
  - This tests whether SetOrientation within SetWorldTransform has any effect
    when SetPosition isn't fighting the impulse-based hover

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player2

  Bind hotkeys in: Settings > Key Bindings > HoverRotTesterPlayer2
]]

local ModName       = "HoverRotTesterPlayer2"
local HOVER_HEIGHT  = 3.0   -- meters above ground
local ROT_STEP      = 30    -- degrees per rotation press
local NUM_DIAG      = 3     -- frames of debug output after a change

-- Hover tuning (impulse-based, delta-v per frame)
local GRAVITY       = 16.0  -- CP2077 gravity m/s^2 (from jetpack source)
local SPRING_K      = 8.0   -- spring constant for height error
local DAMPING_K     = 2.0   -- damping for vertical velocity
local HORIZ_DAMP_K  = 3.0   -- damping for horizontal drift
local MAX_DV        = 5.0   -- max delta-v per axis per frame (m/s)

--===========================================================================
-- State
--===========================================================================

local state = {
    phase     = "IDLE",   -- IDLE | ACTIVE
    hoverZ    = 0,        -- target hover Z (ground + HOVER_HEIGHT)
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

    local sinr_cosp = 2 * (w * x + y * z)
    local cosr_cosp = 1 - 2 * (x * x + y * y)
    local roll = math.atan2(sinr_cosp, cosr_cosp)

    local sinp = 2 * (w * y - z * x)
    if math.abs(sinp) >= 1 then
        sinp = sinp > 0 and 1 or -1
    end
    local pitch = math.asin(sinp)

    local siny_cosp = 2 * (w * z + x * y)
    local cosy_cosp = 1 - 2 * (y * y + z * z)
    local yaw = math.atan2(siny_cosp, cosy_cosp)

    return EulerAngles.new(math.deg(roll), math.deg(pitch), math.deg(yaw))
end

function Quat.toGameQuat(q)
    q = Quat.normalize(q)
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

--- Apply a PSMImpulse to the player (delta-v in m/s).
local function addImpulse(player, dvX, dvY, dvZ)
    pcall(function()
        local imp = PSMImpulse.new()
        imp.id = "impulse"
        imp.impulse = Vector4.new(dvX, dvY, dvZ, 0)
        player:QueueEvent(imp)
    end)
end

--- Clamp a value to [-max, max].
local function clamp(val, maxVal)
    if val > maxVal then return maxVal end
    if val < -maxVal then return -maxVal end
    return val
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
    local groundZ = getGroundZ(pos)

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
            state.savedSensX       = cam.sensitivityMultX
            state.savedSensY       = cam.sensitivityMultY
            state.savedPitchMin    = cam.pitchMin
            state.savedPitchMax    = cam.pitchMax
            state.savedYawMaxLeft  = cam.yawMaxLeft
            state.savedYawMaxRight = cam.yawMaxRight

            cam.sensitivityMultX = 0
            cam.sensitivityMultY = 0
            cam.pitchMin = -180
            cam.pitchMax = 180
            cam.yawMaxLeft = 360
            cam.yawMaxRight = 360
            print(string.format("[%s] FPPCameraComponent locked (sensitivity=0)", ModName))
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
    print(string.format("[%s] Active -- hover target Z=%.1f groundZ=%.1f height=%.1f (camFound=%s)",
        ModName, state.hoverZ, groundZ, HOVER_HEIGHT, tostring(camFound)))

    state.diagCounter = NUM_DIAG
end

local function deactivate()
    print(string.format("[%s] Deactivating...", ModName))

    local player = Game.GetPlayer()
    if player then
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
    state.quat = Quat.mul(state.quat, rot)
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

registerHotkey("HRTP2_Toggle", "Toggle Hover (Player2)", function()
    if state.phase == "IDLE" then
        activate()
    else
        deactivate()
    end
end)

registerHotkey("HRTP2_YawPos", "Yaw +30 (Player2)", function()
    applyRotation(0, 0, 1, ROT_STEP)
end)

registerHotkey("HRTP2_YawNeg", "Yaw -30 (Player2)", function()
    applyRotation(0, 0, 1, -ROT_STEP)
end)

registerHotkey("HRTP2_PitchPos", "Pitch +30 (Player2)", function()
    applyRotation(1, 0, 0, ROT_STEP)
end)

registerHotkey("HRTP2_PitchNeg", "Pitch -30 (Player2)", function()
    applyRotation(1, 0, 0, -ROT_STEP)
end)

registerHotkey("HRTP2_RollPos", "Roll +30 (Player2)", function()
    applyRotation(0, 1, 0, ROT_STEP)
end)

registerHotkey("HRTP2_RollNeg", "Roll -30 (Player2)", function()
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

    -- Read current position and velocity
    local pos = player:GetWorldPosition()
    local vel = player:GetVelocity()

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
        print(string.format("[%s] DIAG BEFORE: roll=%.1f pitch=%.1f yaw=%.1f pos=(%.1f,%.1f,%.1f) vel=(%.2f,%.2f,%.2f)",
            ModName, eulerBefore.roll, eulerBefore.pitch, eulerBefore.yaw,
            pos.x, pos.y, pos.z, vel.x, vel.y, vel.z))
    end

    -----------------------------------------------------------------------
    -- 1. HOVER: Apply impulse to maintain altitude and kill drift
    -----------------------------------------------------------------------

    -- Spring-damper for vertical hover (anti-gravity + position correction)
    local errZ = state.hoverZ - pos.z
    local accelZ = SPRING_K * errZ - DAMPING_K * vel.z + GRAVITY

    -- Damp horizontal drift
    local accelX = -HORIZ_DAMP_K * vel.x
    local accelY = -HORIZ_DAMP_K * vel.y

    -- Convert acceleration to delta-v
    local dvX = clamp(accelX * delta, MAX_DV)
    local dvY = clamp(accelY * delta, MAX_DV)
    local dvZ = clamp(accelZ * delta, MAX_DV)

    addImpulse(player, dvX, dvY, dvZ)

    if printDiag then
        print(string.format("[%s] DIAG impulse: dv=(%.3f, %.3f, %.3f) errZ=%.2f velZ=%.2f",
            ModName, dvX, dvY, dvZ, errZ, vel.z))
    end

    -----------------------------------------------------------------------
    -- 2. ROTATION: SetWorldTransform with current position + orientation
    -----------------------------------------------------------------------

    local gameQuat = Quat.toGameQuat(state.quat)

    local wtOk, wtErr = pcall(function()
        local wt = WorldTransform.new()
        -- Use player's CURRENT position — not a fixed hover point.
        -- This isolates whether SetOrientation has any effect.
        wt:SetPosition(Vector4.new(pos.x, pos.y, pos.z, 1))
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
        print(string.format("[%s] DIAG pos after: (%.1f, %.1f, %.1f) hoverZ=%.1f",
            ModName, posAfter.x, posAfter.y, posAfter.z, state.hoverZ))

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
