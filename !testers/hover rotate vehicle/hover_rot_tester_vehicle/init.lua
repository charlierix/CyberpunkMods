--[[
   Hover & Rotation Tester Mod (Vehicle/Entity Approach) - CET (Lua)

   Toggles a hover mode that spawns a drone entity, binds the camera to it,
   and freezes the player in place.  6 hotkeys adjust yaw / pitch / roll by
   30 degrees per press using quaternion math for proper 6DOF rotation.

   Install: Copy this folder to:
     bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_vehicle/

   Bind hotkeys in: Settings > Key Bindings > HoverRotTesterVehicle

   Pattern source: NanoDrone mod
     - Entity spawn      = exEntitySpawner.Spawn(path, transform)
     - Camera binding     = entity:OnToggleTakeOverControl(ToggleTakeOverControl.new())
     - Camera release     = TakeOverControlSystem.ReleaseControl()
     - Entity move        = Teleport(entity, pos, EulerAngles) each frame
     - Player lock        = Teleport(player, fixedPos, fixedRot) each frame
     - Entity destroy     = handle:GetEntity():Destroy()
     - maxPitch property  = controls pitch range (set high for full 6DOF)

   Quaternion math is implemented in pure Lua to avoid euler gimbal lock
   and ensure rotations combine correctly in any order.
]]

local ModName = "HoverRotTesterVehicle"

--===========================================================================
-- CONFIG
--===========================================================================

local HOVER_HEIGHT  = 3.0   -- meters above ground
local ROT_STEP      = 30    -- degrees per rotation hotkey press
-- Base-game camera drone entities (no custom archive needed):
--   base\quest\main_quests\part1\q112\entities\q112_camera_drone.ent
--   ep1\quest\minor_quests\mq303\entities\mq303_camera_drone_01.ent
-- NanoDrone's custom entity (base\nano_drone\drone.ent) needs its archive installed.
local ENTITY_PATH  = "base\\nano_drone\\drone.ent"
local SPAWN_TIMEOUT = 5.0  -- seconds before giving up on entity spawn

--===========================================================================
-- QUATERNION LIBRARY  (w, x, y, z)
--===========================================================================
-- Standard quaternion math for proper 6DOF rotation without gimbal lock.
-- All internal angles in radians; conversion at API boundaries.
-- Local-axis rotation: q_new = q_current * q_rotation (post-multiply).

local Quat = {}

function Quat.identity()
    return { w = 1, x = 0, y = 0, z = 0 }
end

--- Create a quaternion from axis-angle representation.
--- @param ax number Axis X component.
--- @param ay number Axis Y component.
--- @param az number Axis Z component.
--- @param angleRad number Rotation angle in radians.
--- @return table Quaternion {w, x, y, z}.
function Quat.fromAxisAngle(ax, ay, az, angleRad)
    local half = angleRad * 0.5
    local s = math.sin(half)
    return {
        w = math.cos(half),
        x = ax * s,
        y = ay * s,
        z = az * s,
    }
end

--- Multiply two quaternions: q1 * q2 (Hamilton product).
--- @param q1 table First quaternion.
--- @param q2 table Second quaternion.
--- @return table Result quaternion.
function Quat.mul(q1, q2)
    return {
        w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z,
        x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y,
        y = q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x,
        z = q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w,
    }
end

--- Convert quaternion to Cyberpunk EulerAngles (roll, pitch, yaw) in degrees.
--- Uses standard ZYX (intrinsic) euler decomposition.
--- EulerAngles.new(roll, pitch, yaw) = EulerAngles.new(X, Y, Z).
--- @param q table Quaternion {w, x, y, z}.
--- @return EulerAngles Cyberpunk EulerAngles struct.
function Quat.toEuler(q)
    -- Normalize for safety
    local len = math.sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z)
    if len < 0.0001 then
        return EulerAngles.new(0, 0, 0)
    end
    local w, x, y, z = q.w / len, q.x / len, q.y / len, q.z / len

    -- Pitch (Y-axis rotation)
    local sinp = 2 * (w * y - z * x)
    if math.abs(sinp) > 1 then sinp = sinp > 0 and 1 or -1 end
    local pitch = math.asin(sinp)

    -- Roll (X-axis rotation)
    local roll = math.atan2(2 * (w * x + y * z), 1 - 2 * (x * x + y * y))

    -- Yaw (Z-axis rotation)
    local yaw = math.atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z))

    return EulerAngles.new(math.deg(roll), math.deg(pitch), math.deg(yaw))
end

--- Convert Lua quaternion table to a game Quaternion struct.
--- Tries direct field assignment first, falls back to EulerAngles.ToQuat.
--- @param q table Quaternion {w, x, y, z}.
--- @return Quaternion Game Quaternion struct.
function Quat.toGameQuat(q)
    -- Normalize for safety
    local len = math.sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z)
    if len < 0.0001 then
        return EulerAngles.ToQuat(EulerAngles.new(0, 0, 0))
    end
    local w, x, y, z = q.w / len, q.x / len, q.y / len, q.z / len

    -- Try direct Quaternion construction
    local ok, gameQuat = pcall(function()
        local q = Quaternion.new()
        q.w = w
        q.x = x
        q.y = y
        q.z = z
        return q
    end)

    if ok and gameQuat then
        return gameQuat
    end

    -- Fallback: convert through EulerAngles (may have gimbal lock at pitch=±90)
    local euler = Quat.toEuler(q)
    return EulerAngles.ToQuat(euler)
end

--===========================================================================
-- STATE
--===========================================================================

local state = {
    phase = "IDLE",    -- "IDLE" | "SPAWNING" | "ACTIVE" | "DESTROYING"
    entity = nil,      -- entity reference (from Game.FindEntityByID)
    entID  = nil,      -- entity ID (from exEntitySpawner.Spawn)

    -- Hover position (where the entity floats)
    hoverX = 0,
    hoverY = 0,
    hoverZ = 0,

    -- Player lock position (where the player is frozen)
    playerX   = 0,
    playerY   = 0,
    playerZ   = 0,
    playerRot = nil,   -- EulerAngles

    -- Current orientation as a quaternion
    quat = nil,

    -- Spawn timeout tracking
    spawnTimer = 0,
}

--===========================================================================
-- HELPERS
--===========================================================================

--- Raycast straight down to find ground Z height beneath a position.
--- @param pos Vector4 Player world position.
--- @return number Ground Z height, or pos.z if raycast fails.
local function findGroundZ(pos)
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
--- @param player GameObject The player puppet.
local function zeroVelocity(player)
    pcall(function()
        local imp = PSMImpulse.new()
        imp.id = "impulse"
        imp.impulse = Vector4.new(0, 0, 0, 0)
        player:QueueEvent(imp)
    end)
end

--- Spawn the drone entity at the given position with the given yaw.
--- @param pos Vector4 Spawn position.
--- @param yawDeg number Initial yaw in degrees.
--- @return EntityID|nil The entity ID, or nil on failure.
local function spawnEntity(pos, yawDeg)
    local player = Game.GetPlayer()
    if not player then return nil end

    local rotQuat = EulerAngles.ToQuat(EulerAngles.new(0, 0, yawDeg))

    local transform = player:GetWorldTransform()
    transform:SetOrientation(rotQuat)
    transform:SetPosition(pos)

    -- Don't use pcall here — let CET log the real error if the entity path is invalid
    local entID = exEntitySpawner.Spawn(ENTITY_PATH, transform)
    if entID then
        return entID
    end
    print(string.format("[%s] ERROR: exEntitySpawner.Spawn returned nil for path: %s", ModName, ENTITY_PATH))
    print(string.format("[%s] This entity path may not exist in your game. Try installing NanoDrone mod or change ENTITY_PATH.", ModName))
    return nil
end

--- Begin deactivation: release camera control, then destroy entity next frame.
local function deactivate()
    -- Remove NoJump restriction
    pcall(function()
        local player = Game.GetPlayer()
        if player then
            StatusEffectHelper.RemoveStatusEffect(player, "GameplayRestriction.NoJump")
        end
    end)

    -- Release camera control back to the player
    pcall(function()
        TakeOverControlSystem.ReleaseControl()
    end)

    -- Schedule entity destruction for next frame (safer than same-frame)
    state.phase = "DESTROYING"
    print(string.format("[%s] Deactivating...", ModName))
end

--- Apply a local-axis rotation to the current quaternion.
--- @param ax number Axis X.
--- @param ay number Axis Y.
--- @param az number Axis Z.
--- @param angleDeg number Rotation angle in degrees.
local function applyRotation(ax, ay, az, angleDeg)
    if state.phase ~= "ACTIVE" or not state.quat then return end
    local rotQuat = Quat.fromAxisAngle(ax, ay, az, math.rad(angleDeg))
    state.quat = Quat.mul(state.quat, rotQuat)
    local euler = Quat.toEuler(state.quat)
    print(string.format("[%s] Rot -> roll=%.0f pitch=%.0f yaw=%.0f",
        ModName, euler.roll, euler.pitch, euler.yaw))
end

--===========================================================================
-- ROOT-LEVEL HOTKEYS
-- (MUST be at file root — CET discovers these during its initial scan,
--  before onInit fires. See CET hotkey registration rule.)
--===========================================================================

registerHotkey("HRTV_Toggle", "Toggle Hover (Vehicle)", function()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then return end

    if state.phase == "IDLE" then
        -- Activate: find ground, set positions, spawn entity
        local pos = player:GetWorldPosition()
        local groundZ = findGroundZ(pos)
        local yaw = player:GetWorldYaw()

        -- Hover position (entity floats here)
        state.hoverX = pos.x
        state.hoverY = pos.y
        state.hoverZ = groundZ + HOVER_HEIGHT

        -- Player lock position (player frozen here)
        state.playerX   = pos.x
        state.playerY   = pos.y
        state.playerZ   = pos.z
        state.playerRot = player:GetWorldOrientation():ToEulerAngles()

        -- Initial orientation quaternion (yaw-only, matching player facing)
        state.quat = Quat.fromAxisAngle(0, 0, 1, math.rad(yaw))

        -- Spawn the drone entity at hover position
        local spawnPos = Vector4.new(state.hoverX, state.hoverY, state.hoverZ, 1)
        state.entID = spawnEntity(spawnPos, yaw)

        if state.entID then
            state.phase = "SPAWNING"
            state.spawnTimer = 0
            print(string.format(
                "[%s] Spawning entity at (%.1f, %.1f, %.1f) ground=%.1f height=%.1f",
                ModName, state.hoverX, state.hoverY, state.hoverZ, groundZ, HOVER_HEIGHT
            ))
        end
    elseif state.phase == "SPAWNING" then
        print(string.format("[%s] Still spawning, please wait...", ModName))
    elseif state.phase == "ACTIVE" then
        deactivate()
    end
end)

registerHotkey("HRTV_YawPos", "Yaw +30 (Vehicle)", function()
    applyRotation(0, 0, 1, ROT_STEP)
end)

registerHotkey("HRTV_YawNeg", "Yaw -30 (Vehicle)", function()
    applyRotation(0, 0, 1, -ROT_STEP)
end)

registerHotkey("HRTV_PitchPos", "Pitch +30 (Vehicle)", function()
    applyRotation(0, 1, 0, ROT_STEP)
end)

registerHotkey("HRTV_PitchNeg", "Pitch -30 (Vehicle)", function()
    applyRotation(0, 1, 0, -ROT_STEP)
end)

registerHotkey("HRTV_RollPos", "Roll +30 (Vehicle)", function()
    applyRotation(1, 0, 0, ROT_STEP)
end)

registerHotkey("HRTV_RollNeg", "Roll -30 (Vehicle)", function()
    applyRotation(1, 0, 0, -ROT_STEP)
end)

--===========================================================================
-- EVENT HANDLERS
--===========================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized -- bind hotkeys in Settings > Key Bindings", ModName))
end)

registerForEvent("onUpdate", function(delta)

    if state.phase == "SPAWNING" then
        -- Timeout check — entity didn't appear in time
        state.spawnTimer = state.spawnTimer + delta
        if state.spawnTimer > SPAWN_TIMEOUT then
            print(string.format("[%s] ERROR: Entity spawn timed out after %.1fs. Path may be invalid: %s", ModName, SPAWN_TIMEOUT, ENTITY_PATH))
            state.phase = "IDLE"
            state.entID = nil
            state.spawnTimer = 0
            return
        end

        -- Wait for entity to be available, then take over camera control
        local ent = Game.FindEntityByID(state.entID)
        if ent then
            state.entity = ent

            -- Bind camera to the entity (NanoDrone pattern)
            pcall(function()
                ent:OnToggleTakeOverControl(ToggleTakeOverControl.new())
            end)

            -- Set entity-level pitch range (NanoDrone sets maxPitch=3)
            pcall(function()
                ent.minPitch = -180
                ent.maxPitch = 180
            end)

            -- Try to find and lock the FPPCameraComponent on the entity
            -- This stops mouse input from overriding our SetWorldOrientation
            local camFound = false
            pcall(function()
                local cam = ent:GetFPPCameraComponent()
                if cam then
                    camFound = true
                    cam.sensitivityMultX = 0   -- Disable mouse X (yaw) input
                    cam.sensitivityMultY = 0   -- Disable mouse Y (pitch) input
                    cam.headingLocked = true    -- Lock heading
                    cam.pitchMin = -180
                    cam.pitchMax = 180
                    cam.yawMaxLeft = 360
                    cam.yawMaxRight = 360
                    print(string.format("[%s] FPPCameraComponent locked (sensitivity=0, headingLocked)", ModName))
                end
            end)

            if not camFound then
                -- Try FindComponentByName for camera components
                pcall(function()
                    for _, name in ipairs({"camera", "fpp_camera", "FPPCamera", "camera_comp"}) do
                        local cam = ent:FindComponentByName(CName.new(name))
                        if cam then
                            print(string.format("[%s] Found component by name: %s", ModName, name))
                            cam.sensitivityMultX = 0
                            cam.sensitivityMultY = 0
                            cam.headingLocked = true
                            camFound = true
                            break
                        end
                    end
                end)
            end

            -- Try to lock input via TakeOverControlSystem
            pcall(function()
                local tcs = Game.GetScriptableSystemsContainer():Get(CName.new('TakeOverControlSystem'))
                if tcs then
                    tcs.isInputLockedFromQuest = true
                    print(string.format("[%s] TakeOverControlSystem input locked", ModName))
                end
            end)

            -- Diagnostic: enumerate entity components
            pcall(function()
                local comps = ent:GetComponents()
                if comps then
                    local compNames = {}
                    for _, comp in ipairs(comps) do
                        local cn = comp:GetClassName()
                        if cn then table.insert(compNames, tostring(cn)) end
                    end
                    if #compNames > 0 then
                        print(string.format("[%s] Entity components: %s", ModName, table.concat(compNames, ", ")))
                    end
                end
            end)

            -- Prevent player from jumping while in hover mode
            pcall(function()
                local player = Game.GetPlayer()
                if player then
                    Game.GetStatusEffectSystem():ApplyStatusEffect(
                        player:GetEntityID(),
                        "GameplayRestriction.NoJump",
                        player:GetRecordID(),
                        player:GetEntityID()
                    )
                end
            end)

            state.phase = "ACTIVE"
            print(string.format("[%s] Active -- camera bound to entity (camFound=%s)", ModName, tostring(camFound)))
        end

    elseif state.phase == "ACTIVE" then
        local player = Game.GetPlayer()
        if not player or not player:IsAttached() then
            deactivate()
            return
        end

        -- Check entity still exists
        local ent = Game.FindEntityByID(state.entID)
        if not ent then
            print(string.format("[%s] Entity lost, deactivating", ModName))
            deactivate()
            return
        end
        state.entity = ent

        -- Kill player velocity to prevent physics drift
        zeroVelocity(player)

        -- Set entity orientation directly via Quaternion (avoids euler gimbal lock)
        -- This is the key fix: SetWorldOrientation forces the rotation, then
        -- we Teleport for position only, preserving the orientation we just set.
        -- NanoDrone pattern: Teleport(handle, pos, handle:GetWorldOrientation():ToEulerAngles())
        local gameQuat = Quat.toGameQuat(state.quat)
        pcall(function()
            ent:SetWorldOrientation(gameQuat)
        end)

        -- Teleport for position only, preserving the orientation set above
        -- (same pattern as NanoDrone line 227)
        Game.GetTeleportationFacility():Teleport(
            ent,
            Vector4.new(state.hoverX, state.hoverY, state.hoverZ, 1),
            ent:GetWorldOrientation():ToEulerAngles()
        )

        -- Lock player at original position
        Game.GetTeleportationFacility():Teleport(
            player,
            Vector4.new(state.playerX, state.playerY, state.playerZ, 1),
            state.playerRot
        )

    elseif state.phase == "DESTROYING" then
        -- Destroy entity on next frame (camera already released)
        if state.entity then
            pcall(function()
                local realEnt = state.entity:GetEntity()
                if realEnt then realEnt:Destroy() end
            end)
        end
        state.phase  = "IDLE"
        state.entity = nil
        state.entID  = nil
        state.quat   = nil
        print(string.format("[%s] Deactivated", ModName))
    end
end)

registerForEvent("onShutdown", function()
    if state.phase ~= "IDLE" then
        -- Force immediate cleanup (skip DESTROYING delay)
        pcall(function()
            local player = Game.GetPlayer()
            if player then
                StatusEffectHelper.RemoveStatusEffect(player, "GameplayRestriction.NoJump")
            end
        end)
        pcall(function()
            TakeOverControlSystem.ReleaseControl()
        end)
        -- Restore TakeOverControlSystem input lock
        pcall(function()
            local tcs = Game.GetScriptableSystemsContainer():Get(CName.new('TakeOverControlSystem'))
            if tcs then
                tcs.isInputLockedFromQuest = false
            end
        end)
        if state.entity then
            pcall(function()
                local realEnt = state.entity:GetEntity()
                if realEnt then realEnt:Destroy() end
            end)
        end
        state.phase  = "IDLE"
        state.entity = nil
        state.entID  = nil
        state.quat   = nil
    end
end)
