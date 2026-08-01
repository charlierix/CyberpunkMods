--===========================================================================
-- Hover Rot Tester Vehicle 2
-- Activates while sitting in a real vehicle. Hovers the vehicle and provides
-- 6DOF rotation via quaternion math. Uses the player's FPPCameraComponent
-- (which has sensitivityMultX/Y and headingLocked) to lock mouse override.
--===========================================================================

local ModName       = "HoverRotTesterVehicle2"
local HOVER_HEIGHT  = 6.0   -- meters above ground (vehicles are larger)
local ROT_STEP      = 30    -- degrees per rotation press
local NUM_DIAG      = 1     -- how many update iterations to show debug statements after a change

--===========================================================================
-- State
--===========================================================================

local state = {
    phase     = "IDLE",   -- IDLE | ACTIVE
    vehicle   = nil,
    hoverX    = 0,
    hoverY    = 0,
    hoverZ    = 0,
    quat      = nil,       -- {w, x, y, z} current orientation
    -- Saved camera settings for restore
    savedSensX   = nil,
    savedSensY   = nil,
    savedHeading = nil,
    savedPitchMin = nil,
    savedPitchMax = nil,
    savedYawMaxLeft = nil,
    savedYawMaxRight = nil,
    -- Saved TweakDB values
    savedTDBPitchMin = nil,
    savedTDBPitchMax = nil,
    -- Diagnostic print throttle: prints N frames after a rotation change
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

    -- CET EulerAngles.new(roll, pitch, yaw) — confirmed by Jackie's Garage mod pattern
    return EulerAngles.new(math.deg(roll), math.deg(pitch), math.deg(yaw))
end

function Quat.toGameQuat(q)
    q = Quat.normalize(q)

    -- local gq = Quaternion.new()
    -- gq.x = q.x
    -- gq.y = q.y
    -- gq.z = q.z
    -- gq.w = q.w
    -- return gq

    -- Quaternion.new(x, y, z, w) — args are (x, y, z, w), NOT (w, x, y, z).
    -- This builds a raw quaternion WITHOUT going through Euler (no gimbal lock).
    -- Confirmed working in jetpack mod: Quaternion.new(x, y, z, w) at line 215.
    return Quaternion.new(q.x, q.y, q.z, q.w)
end

--===========================================================================
-- Helper Functions
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
    return z -- fallback to current z
end

local function zeroVelocity(entity)
    pcall(function()
        local imp = PSMImpulse.new()
        imp.id = "impulse"
        imp.impulse = Vector4.new(0, 0, 0, 0)
        entity:QueueEvent(imp)
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

    -- Get the vehicle the player is sitting in
    local vehicle = nil
    pcall(function()
        vehicle = Game.GetMountedVehicle(player)
    end)
    if not vehicle then
        pcall(function()
            vehicle = player:GetMountedVehicle()
        end)
    end
    if not vehicle then
        pcall(function()
            vehicle = player.mountedVehicle
        end)
    end

    if not vehicle then
        print(string.format("[%s] ERROR: No mounted vehicle found. Sit in a vehicle first!", ModName))
        return
    end

    state.vehicle = vehicle

    -- Get vehicle position
    local pos = vehicle:GetWorldPosition()
    local rot = vehicle:GetWorldOrientation():ToEulerAngles()
    local groundZ = getGroundZ(pos.x, pos.y, pos.z)

    state.hoverX = pos.x
    state.hoverY = pos.y
    state.hoverZ = groundZ + HOVER_HEIGHT

    -- Initialize quaternion from current vehicle orientation
    -- EulerAngles.new(roll, pitch, yaw) -> we store as identity since we want fresh rotations
    state.quat = Quat.identity()
    -- Actually, start from current yaw so the vehicle doesn't snap
    state.quat = Quat.fromAxisAngle(0, 0, 1, rot.yaw)

    -- Lock the player's FPPCameraComponent to stop mouse override
    local camFound = false
    pcall(function()
        local cam = player:GetFPPCameraComponent()
        if cam then
            camFound = true
            -- Save current values
            state.savedSensX      = cam.sensitivityMultX
            state.savedSensY      = cam.sensitivityMultY
            state.savedHeading    = cam.headingLocked
            state.savedPitchMin   = cam.pitchMin
            state.savedPitchMax   = cam.pitchMax
            state.savedYawMaxLeft  = cam.yawMaxLeft
            state.savedYawMaxRight = cam.yawMaxRight

            -- Lock mouse sensitivity only — do NOT lock heading
            -- headingLocked=true freezes camera in world space, preventing it
            -- from following the vehicle's rotation. We want the camera to
            -- follow the vehicle heading, but stop mouse from overriding it.
            cam.sensitivityMultX = 0
            cam.sensitivityMultY = 0
            -- Keep headingLocked as-is (don't force it true)
            cam.pitchMin = -180
            cam.pitchMax = 180
            cam.yawMaxLeft = 360
            cam.yawMaxRight = 360
            print(string.format("[%s] FPPCameraComponent locked (sensitivity=0, heading not locked)", ModName))
        end
    end)

    -- Also set TweakDB vehicle camera params for full range
    pcall(function()
        state.savedTDBPitchMin = TweakDB:GetFlat("fppCameraParamSets.Vehicle.pitchMin")
        state.savedTDBPitchMax = TweakDB:GetFlat("fppCameraParamSets.Vehicle.pitchMax")
        TweakDB:SetFlat("fppCameraParamSets.Vehicle.pitchMin", -180)
        TweakDB:SetFlat("fppCameraParamSets.Vehicle.pitchMax", 180)
        TweakDB:Update("fppCameraParamSets.Vehicle")
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
    print(string.format("[%s] Active -- vehicle hovering at (%.1f, %.1f, %.1f) groundZ=%.1f height=%.1f (camFound=%s)",
        ModName, state.hoverX, state.hoverY, state.hoverZ, groundZ, HOVER_HEIGHT, tostring(camFound)))

    state.diagCounter = NUM_DIAG  -- reset diag print throttle
end

local function deactivate()
    print(string.format("[%s] Deactivating...", ModName))

    -- Restore FPPCameraComponent settings
    local player = Game.GetPlayer()
    if player then
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

    -- Restore TweakDB values
    pcall(function()
        if state.savedTDBPitchMin then TweakDB:SetFlat("fppCameraParamSets.Vehicle.pitchMin", state.savedTDBPitchMin) end
        if state.savedTDBPitchMax then TweakDB:SetFlat("fppCameraParamSets.Vehicle.pitchMax", state.savedTDBPitchMax) end
        TweakDB:Update("fppCameraParamSets.Vehicle")
    end)

    state.phase     = "IDLE"
    state.vehicle   = nil
    state.quat      = nil
    state.savedSensX = nil
    state.savedSensY = nil
    state.savedHeading = nil
    state.savedPitchMin = nil
    state.savedPitchMax = nil
    state.savedYawMaxLeft = nil
    state.savedYawMaxRight = nil
    state.savedTDBPitchMin = nil
    state.savedTDBPitchMax = nil
    state.diagCounter = 0

    print(string.format("[%s] Deactivated", ModName))
end

local function applyRotation(ax, ay, az, deg)
    if state.phase ~= "ACTIVE" or not state.quat then return end
    local rot = Quat.fromAxisAngle(ax, ay, az, deg)
    state.quat = Quat.mul(state.quat, rot)  -- post-multiply for local-axis rotation (the axis passed in is rotated into model coords, then the quat gets rotated around the local axis)
    state.diagCounter = NUM_DIAG  -- reset diag print throttle
    local euler = Quat.toEuler(state.quat)
    print(string.format("[%s] Rot -> roll=%.0f pitch=%.0f yaw=%.0f",
        ModName, euler.roll, euler.pitch, euler.yaw))
end

--===========================================================================
-- Hotkeys (root level — CET discovers these before onInit)
--===========================================================================

registerHotkey("HRTV2_Toggle", "Toggle Hover (Vehicle2)", function()
    if state.phase == "IDLE" then
        activate()
    else
        deactivate()
    end
end)

registerHotkey("HRTV2_YawPos", "Yaw +30 (Vehicle2)", function()
    applyRotation(0, 0, 1, ROT_STEP)
end)

registerHotkey("HRTV2_YawNeg", "Yaw -30 (Vehicle2)", function()
    applyRotation(0, 0, 1, -ROT_STEP)
end)

registerHotkey("HRTV2_PitchPos", "Pitch +30 (Vehicle2)", function()
    applyRotation(1, 0, 0, ROT_STEP)
end)

registerHotkey("HRTV2_PitchNeg", "Pitch -30 (Vehicle2)", function()
    applyRotation(1, 0, 0, -ROT_STEP)
end)

registerHotkey("HRTV2_RollPos", "Roll +30 (Vehicle2)", function()
    applyRotation(0, 1, 0, ROT_STEP)
end)

registerHotkey("HRTV2_RollNeg", "Roll -30 (Vehicle2)", function()
    applyRotation(0, 1, 0, -ROT_STEP)
end)

--===========================================================================
-- Event Handlers
--===========================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized -- sit in a vehicle, then press toggle hotkey", ModName))
end)

registerForEvent("onUpdate", function(delta)
    if state.phase ~= "ACTIVE" then return end

    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        deactivate()
        return
    end

    local vehicle = state.vehicle
    if not vehicle or not vehicle:IsAttached() then
        -- Try to re-get the vehicle
        pcall(function()
            vehicle = Game.GetMountedVehicle(player)
        end)
        if not vehicle then
            print(string.format("[%s] Vehicle lost, deactivating", ModName))
            deactivate()
            return
        end
        state.vehicle = vehicle
    end



    ---------------- ASSUMPTIONS ----------------
    -- zeroing out vehicle/player velocity is needed
    --
    -- setting vehicle's world orientation sticks
    --   * log before/after
    --   * maybe set vehicle world orientation after teleport
    -- 
    -- teleporting is honoring the quat passed in (it may be ignoring quat)
    --   * log after teleport
    --   * maybe use impulses instead of teleport (initial teleport, then hover with impulses after that)
    -- 
    -- setting player camera's local orientation is needed
    --   * see what happens commented vs not commented
    ---------------------------------------------
    -- see TESTING_PLAN.md for more
    ---------------------------------------------



    -- DIAGNOSTIC: only print for N frames after a rotation change
    local printDiag = state.diagCounter > 0
    if printDiag then
        state.diagCounter = state.diagCounter - 1
    end

    if printDiag then
        -- DIAGNOSTIC: log quaternion we're trying to set
        local targetEuler = Quat.toEuler(state.quat)
        print(string.format("[%s] DIAG target: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, targetEuler.roll, targetEuler.pitch, targetEuler.yaw))

        -- DIAGNOSTIC: log vehicle orientation BEFORE any changes
        local eulerBefore = vehicle:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG BEFORE: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerBefore.roll, eulerBefore.pitch, eulerBefore.yaw))
    end


    local gameQuat = Quat.toGameQuat(state.quat)


    -- ******** V ********
    -- Zero vehicle velocity to prevent physics drift
    --zeroVelocity(vehicle)
    --zeroVelocity(player)




    -- ******** T ********
    -- Teleport vehicle for position only, preserving orientation we just set
    -- (NanoDrone pattern: Teleport(handle, pos, handle:GetWorldOrientation():ToEulerAngles()))
    -- local tOk, tErr = pcall(Game.GetTeleportationFacility():Teleport(
    --     vehicle,
    --     Vector4.new(state.hoverX, state.hoverY, state.hoverZ, 1),
    --     gameQuat:ToEulerAngles()
    -- ))

    local tOk, tErr = pcall(function()
        Game.GetTeleportationFacility():Teleport(
            vehicle,
            Vector4.new(state.hoverX, state.hoverY, state.hoverZ, 1),
            gameQuat:ToEulerAngles())
    end)

    if printDiag then
        if tOk then
            print(string.format("[%s] Teleport SUCCESS", ModName))
        else
            print(string.format("[%s] Teleport FAILED: %s", ModName, tostring(tErr)))
        end
    end




    -- ******** O ********
    -- NOTE: this is failing, but it doesn't seem to be needed anyway:
    -- [HoverRotTesterVehicle2] SetWorldOrientation FAILED: init.lua:499: attempt to call method 'SetWorldOrientation' (a nil value)

    -- Set vehicle orientation directly via Quaternion
    -- local oOk, oErr = pcall(function()
    --     vehicle:SetWorldOrientation(gameQuat)
    -- end)

    -- if printDiag then
    --     if oOk then
    --         print(string.format("[%s] SetWorldOrientation SUCCESS", ModName))
    --     else
    --         print(string.format("[%s] SetWorldOrientation FAILED: %s", ModName, tostring(oErr)))
    --     end
    -- end




    if printDiag then
        -- DIAGNOSTIC: log vehicle orientation AFTER SetWorldOrientation
        local eulerAfterO = vehicle:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG AFTER SetWorldOrient: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerAfterO.roll, eulerAfterO.pitch, eulerAfterO.yaw))

        -- DIAGNOSTIC: log vehicle orientation AFTER Teleport
        local eulerAfterT = vehicle:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG AFTER Teleport: roll=%.1f pitch=%.1f yaw=%.1f",
            ModName, eulerAfterT.roll, eulerAfterT.pitch, eulerAfterT.yaw))

        -- DIAGNOSTIC: log vehicle position after Teleport
        local posAfter = vehicle:GetWorldPosition()
        print(string.format("[%s] DIAG pos after: (%.1f, %.1f, %.1f) target hover: (%.1f, %.1f, %.1f)",
            ModName, posAfter.x, posAfter.y, posAfter.z, state.hoverX, state.hoverY, state.hoverZ))

        -- DIAGNOSTIC: log camera state (useful even when C block is commented out)
        pcall(function()
            local cam = player:GetFPPCameraComponent()
            if cam then
                local camEuler = cam:GetLocalOrientation():ToEulerAngles()
                print(string.format("[%s] DIAG CAM: roll=%.1f pitch=%.1f yaw=%.1f | pitchMin=%.1f pitchMax=%.1f | sensX=%.1f sensY=%.1f | heading=%s",
                    ModName, camEuler.roll, camEuler.pitch, camEuler.yaw,
                    cam.pitchMin, cam.pitchMax,
                    cam.sensitivityMultX, cam.sensitivityMultY,
                    tostring(cam.headingLocked)))
            end
        end)
    end



    -- ******** C ********
    -- NOTE: this isn't doing anything
    -- Also set the player's FPPCameraComponent orientation for pitch and roll
    -- The yaw should follow the vehicle heading automatically.
    -- We use the Cyberscript Core pattern: set pitchMin/Max to force pitch,
    -- and SetLocalOrientation for roll.
    -- local cOk, cErr = pcall(function()
    --     local cam = player:GetFPPCameraComponent()
    --     if cam then
    --         --local euler = Quat.toEuler(state.quat)
    --         local euler = gameQuat:ToEulerAngles()
    --         -- Force pitch via pitchMin/Max trick (small gap needed)
    --         cam.pitchMin = euler.pitch - 0.01
    --         cam.pitchMax = euler.pitch
    --         -- Set roll via SetLocalOrientation (EulerAngles.new(roll, pitch, yaw))
    --         -- Only set roll and pitch here, let yaw follow the vehicle
    --         cam:SetLocalOrientation(EulerAngles.new(euler.roll, euler.pitch, 0):ToQuat())
    --     end
    -- end)

    -- if printDiag then
    --     if cOk then
    --         print(string.format("[%s] FPPCamera SUCCESS", ModName))
    --     else
    --         print(string.format("[%s] FPPCamera FAILED: %s", ModName, tostring(cErr)))
    --     end
    -- end


end)

registerForEvent("onShutdown", function()
    if state.phase ~= "IDLE" then
        deactivate()
    end
end)
