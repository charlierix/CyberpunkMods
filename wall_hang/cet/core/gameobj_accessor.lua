local this = {}
function this.GetRandom_Variance(baseVal, variance)
    return baseVal - variance + (math.random() * variance * 2)
end

local pullInterval_player = this.GetRandom_Variance(12, 1)
local pullInterval_workspot = this.GetRandom_Variance(12, 1)
local pullInterval_camera = this.GetRandom_Variance(12, 1)
local pullInterval_teleport = this.GetRandom_Variance(12, 1)
local pullInterval_sensor = this.GetRandom_Variance(12, 1)
local pullInterval_quest = this.GetRandom_Variance(12, 1)
local pullInterval_spacialQueries = this.GetRandom_Variance(12, 1)
local pullInterval_targeting = this.GetRandom_Variance(12, 1)
local pullInterval_stats = this.GetRandom_Variance(12, 1)

GameObjectAccessor = {}

-- Constructor
function GameObjectAccessor:new(wrappers)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.multimod_flight = require("core/multimod_flight")

    obj.timer = 0
    obj.wrappers = wrappers
    obj.lastPulled_player = -(pullInterval_player * 2)      -- timer starts at zero.  So zero - -max = max   (multiplying by two to be sure there is no math drift error)
    obj.lastPulled_workspot = -(pullInterval_workspot * 2)
    obj.lastPulled_camera = -(pullInterval_camera * 2)
    obj.lastPulled_teleport = -(pullInterval_teleport * 2)
    obj.lastPulled_sensor = -(pullInterval_sensor * 2)
    obj.lastPulled_quest = -(pullInterval_quest * 2)
    obj.lastPulled_spacialQueries = -(pullInterval_spacialQueries * 2)
    obj.lastPulled_targeting = -(pullInterval_targeting * 2)
    obj.lastPulled_stats = -(pullInterval_stats * 2)

    obj.lastGot_lookDir = -1

    return obj
end

function GameObjectAccessor:Tick(deltaTime)
    self.timer = self.timer + deltaTime
end

-- This gets called when a load is kicked off, or shutdown
-- This needs to drop references to all objects so garbage collector can run correctly
function GameObjectAccessor:Clear()
    self.player = nil
    self.workspot = nil
    self.camera = nil
    self.teleport = nil
    self.sensor = nil
    self.quest = nil
    self.spacialQueries = nil
    self.targeting = nil
    self.stats = nil
end

-- Populates this.player, position, velocity, yaw
function GameObjectAccessor:GetPlayerInfo()
    self:EnsurePlayerLoaded()

    if self.player then
        self.pos = self.wrappers.Player_GetPos(self.player)
        self.vel = self.wrappers.Player_GetVel(self.player)
        self.yaw = self.wrappers.Player_GetYaw(self.player)
    end
end

-- Allows mods to talk to each other, so only one at a time will fly
function GameObjectAccessor:Custom_CurrentlyFlying_IsOwnerOrNone()
    self:EnsureLoaded_Quest()

    if self.quest then
        return self.multimod_flight.IsOwnerOrNone(self.quest, self.wrappers)
    end
end
function GameObjectAccessor:Custom_CurrentlyFlying_HasControlSwitched()
    self:EnsureLoaded_Quest()

    if self.quest then
        return self.multimod_flight.HasControlSwitched(self.quest, self.wrappers)
    end
end
function GameObjectAccessor:Custom_CurrentlyFlying_CanStartFlight()
    self:EnsureLoaded_Quest()

    if self.quest then
        return self.multimod_flight.CanStartFlight(self.quest, self.wrappers)
    end
end
function GameObjectAccessor:Custom_CurrentlyFlying_TryStartFlight(allow_interruption, velocity)
    self:EnsureLoaded_Quest()

    if self.quest then
        local started, final_vel = self.multimod_flight.TryStartFlight(self.quest, self.wrappers, allow_interruption, velocity)

        if started and final_vel and velocity and not IsNearValue_vec4(velocity, final_vel) then
            -- Likely coming from teleport based flight (zero).  Add a kick to match the reported velocity
            self:AddImpulse(final_vel.x - velocity.x, final_vel.y - velocity.y, final_vel.z - velocity.z)
        end

        return started, final_vel
    end
end
function GameObjectAccessor:Custom_CurrentlyFlying_Update(velocity)
    self:EnsureLoaded_Quest()

    if self.quest then
        return self.multimod_flight.Update(self.quest, self.wrappers, velocity)
    end
end
function GameObjectAccessor:Custom_CurrentlyFlying_Clear()
    self:EnsureLoaded_Quest()

    if self.quest then
        self.multimod_flight.Clear(self.quest, self.wrappers)
    end
end

-- Populates isInWorkspot
--WARNING: If this is called while load is first kicked off, it will crash the game.  So probably want to wait until the player is moving or something
function GameObjectAccessor:GetInWorkspot()
    self:EnsurePlayerLoaded()

    if not self.workspot or (self.timer - self.lastPulled_workspot) >= pullInterval_workspot then
        self.lastPulled_workspot = self.timer

        self.workspot = self.wrappers.GetWorkspotSystem()
    end

    if self.player and self.workspot then
        self.isInWorkspot = self.wrappers.Workspot_InWorkspot(self.workspot, self.player)
    else
        self.isInWorkspot = false
    end
end

-- Populates look direction
function GameObjectAccessor:GetCamera()
    if not self.camera or (self.timer - self.lastPulled_camera) >= pullInterval_camera then
        self.lastPulled_camera = self.timer

        self.camera = self.wrappers.GetCameraSystem()
    end

    --This is getting called multiple times per tick, so only get the values once per tick
    if self.camera and (self.lastGot_lookDir ~= self.timer) then
        self.lookdir_forward, self.lookdir_right = self.wrappers.Camera_GetForwardRight(self.camera)
        self.lastGot_lookDir = self.timer
    end
end

-- Returns position, direction
function GameObjectAccessor:GetCrosshairInfo()
    self:EnsureLoaded_Player()
    self:EnsureLoaded_Targeting()

    if self.player and self.targeting then
        return self.targeting:GetDefaultCrosshairData(self.player)
    end

    -- local player = Game.GetPlayer()
    -- local targetting = Game.GetTargetingSystem()
    -- local crosshairPosition, crosshairForward = targetting:GetDefaultCrosshairData(player)
    -- local pos = player:GetWorldPosition()
    -- print("diff: " .. vec_str(SubtractVectors(crosshairPosition, pos)))
    --  the z changes based on looking up or not (1.59 looking down, 1.8 looking up)
    --  x and y also have a small offset (about 0.25)
end

-- Teleports to a point, look dir
function GameObjectAccessor:Teleport(pos, yaw)
    self:EnsurePlayerLoaded()

    if not self.teleport or (self.timer - self.lastPulled_teleport) >= pullInterval_teleport then
        self.lastPulled_teleport = self.timer

        self.teleport = self.wrappers.GetTeleportationFacility()
    end

    if self.player and self.teleport then
        self.wrappers.Teleport(self.teleport, self.player, pos, yaw)
    end
end

-- This serves as a quick/crude ray cast
function GameObjectAccessor:IsPointVisible(fromPos, toPos)
    if not self.sensor or (self.timer - self.lastPulled_sensor) >= pullInterval_sensor then
        self.lastPulled_sensor = self.timer

        self.sensor = self.wrappers.GetSenseManager()
    end

    if self.sensor then
        return self.wrappers.IsPositionVisible(self.sensor, fromPos, toPos)
    else
        return nil
    end
end

-- Returns a position, normal, material (or nils)
function GameObjectAccessor:RayCast(fromPos, toPos)
    self:EnsureLoaded_SpacialQueries()

    if self.spacialQueries then
        local hit = this.RayCast_Closest(self.spacialQueries, fromPos, toPos)
        if hit then
            return
                Vector4.new(hit.position.x, hit.position.y, hit.position.z, 1),
                Vector4.new(hit.normal.x, hit.normal.y, hit.normal.z, 1),
                hit.material
        else
            return nil, nil, nil
        end
    end
end

-- This is used to slow time
--  0.00001 for near stop
--  up to 1
--  0 Is an invalid input which causes the function UnsetTimeDilation() to run (https://codeberg.org/adamsmasher/cyberpunk/src/branch/master/core/systems/timeSystem.ws)
function GameObjectAccessor:SetTimeDilation(timeSpeed)
    self.wrappers.SetTimeDilation(timeSpeed)
end

function GameObjectAccessor:HasHeadUnderwater()
    self:EnsurePlayerLoaded()

    if self.player then
        return self.wrappers.HasHeadUnderwater(self.player)
    end
end

-- This plays a sound, pass in the CName.  To find possible strings, use the sound tester mod
-- https://www.nexusmods.com/cyberpunk2077/mods/1977
--
-- param: vars is optional.  If passed in, it will store this sound, and logic will be used to
-- only have one sound playing at a time.  If nil, then the caller is responsible for stopping
-- the sound
function GameObjectAccessor:PlaySound(soundName, vars)
    self:EnsurePlayerLoaded()

    if self.player then
        if vars then
            PossiblyStopSound(self, vars)
        end

        this.PlaySound(self.player, soundName)

        if vars then
            vars.sound_current = soundName
            vars.sound_started = self.timer
        end
    end
end
function GameObjectAccessor:StopSound(soundName)
    self:EnsurePlayerLoaded()

    if self.player then
        this.StopSound(self.player, soundName)
    end
end

-- This hits the player with an acceleration
function GameObjectAccessor:AddImpulse(x, y, z)
    self:EnsurePlayerLoaded()

    if self.player and not (IsNearZero(x) and IsNearZero(y) and IsNearZero(z)) then
        local impulseEvent = PSMImpulse.new()
        impulseEvent.id = "impulse"
        impulseEvent.impulse = Vector4.new(x, y, z, 1)
        self.player:QueueEvent(impulseEvent)
    end
end

function GameObjectAccessor:GetPlayerHealth_Percent()
    self:EnsureLoaded_Stats()
    self:EnsurePlayerLoaded()

    if self.stats and self.player then
        return self.wrappers.GetStatPoolValue(self.stats, self.player:GetEntityID(), gamedataStatPoolType.Health, true)
    end
end
function GameObjectAccessor:SetPlayerHealth_Percent(percent, is_delta)
    self:EnsureLoaded_Stats()
    self:EnsurePlayerLoaded()

    if self.stats and self.player then
        local entityID = self.player:GetEntityID()

        if is_delta then
            self.wrappers.SetStatPoolValue(self.stats, entityID, self.player, gamedataStatPoolType.Health, percent, true)
        else
            local health = self.wrappers.GetStatPoolValue(self.stats, entityID, gamedataStatPoolType.Health, true)
            self.wrappers.SetStatPoolValue(self.stats, entityID, self.player, gamedataStatPoolType.Health, percent - health, true)
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function GameObjectAccessor:EnsurePlayerLoaded()
    if not self.player or (self.timer - self.lastPulled_player) >= pullInterval_player then
        self.lastPulled_player = self.timer

        self.player = self.wrappers.GetPlayer()
    end
end

function GameObjectAccessor:EnsureLoaded_Quest()
    if not self.quest or (self.timer - self.lastPulled_quest) >= pullInterval_quest then
        self.lastPulled_quest = self.timer

        self.quest = self.wrappers.GetQuestsSystem()
    end
end

function GameObjectAccessor:EnsureLoaded_SpacialQueries()
    if not self.spacialQueries or (self.timer - self.lastPulled_spacialQueries) >= pullInterval_spacialQueries then
        self.lastPulled_spacialQueries = self.timer

        self.spacialQueries = self.wrappers.GetSpatialQueriesSystem()
    end
end

function GameObjectAccessor:EnsureLoaded_Targeting()
    if not self.targeting or (self.timer - self.lastPulled_targeting) >= pullInterval_targeting then
        self.lastPulled_targeting = self.timer

        self.targeting = self.wrappers.GetTargetingSystem()
    end
end

function GameObjectAccessor:EnsureLoaded_Stats()
    if not self.stats or (self.timer - self.lastPulled_stats) >= pullInterval_stats then
        self.lastPulled_stats = self.timer

        self.stats = self.wrappers.GetStatPoolsSystem()
    end
end

function this.PlaySound(player, soundName)
    local audioEvent = SoundPlayEvent.new()
    audioEvent.soundName = soundName
    player:QueueEvent(audioEvent)
end
function this.StopSound(player, soundName)
    local audioEvent = SoundStopEvent.new()
    audioEvent.soundName = soundName
    player:QueueEvent(audioEvent)
end

local raycast_filters =
{
    --"Dynamic",      -- Movable Objects
    "Vehicle",
    "Static",       -- Buildings, Concrete Roads, Crates, etc
    --"Water",
    "Terrain",
    "PlayerBlocker",        -- Trees, Billboards, Barriers
}
function this.RayCast_Closest(spatial, from_pos, to_pos)
    local closest = nil
    local closest_distsqr = nil

    for i = 1, #raycast_filters do
        -- it would be cool if QueryFilter.ALL() worked here, but it doesn't
        local success, result = spatial:SyncRaycastByCollisionGroup(from_pos, to_pos, raycast_filters[i], false, false)

        if success then
            --print("hit: " .. raycast_filters[i] .. " | " .. tostring(result.material) .. " | " .. tostring(result.position.x) .. ", " .. tostring(result.position.y) .. ", " .. tostring(result.position.z))

            local dist_sqr = GetVectorDiffLengthSqr(from_pos, result.position)

            if closest == nil or dist_sqr < closest_distsqr then
                closest = result
                closest_distsqr = dist_sqr
            end
        end
    end

    return closest
end