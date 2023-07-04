local this = {}
function this.GetRandom_Variance(baseVal, variance)
    return baseVal - variance + (math.random() * variance * 2)
end

local pullInterval_player = this.GetRandom_Variance(12, 1)
local pullInterval_workspot = this.GetRandom_Variance(12, 1)
local pullInterval_camera = this.GetRandom_Variance(12, 1)
local pullInterval_sensor = this.GetRandom_Variance(12, 1)
local pullInterval_quest = this.GetRandom_Variance(12, 1)
local pullInterval_spacialQueries = this.GetRandom_Variance(12, 1)
local pullInterval_targeting = this.GetRandom_Variance(12, 1)

GameObjectAccessor = {}

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
    obj.lastPulled_sensor = -(pullInterval_sensor * 2)
    obj.lastPulled_quest = -(pullInterval_quest * 2)
    obj.lastPulled_spacialQueries = -(pullInterval_spacialQueries * 2)
    obj.lastPulled_targeting = -(pullInterval_targeting * 2)

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
	self.sensor = nil
	self.quest = nil
	self.spacialQueries = nil
    self.targeting = nil
end

-- Populates player, position (vel, yaw are commented out)
function GameObjectAccessor:GetPlayerInfo()
    self:EnsureLoaded_Player()

    if self.player then
        self.pos = self.wrappers.Player_GetPos(self.player)
        self.vel = self.wrappers.Player_GetVel(self.player)
        --self.yaw = self.wrappers.Player_GetYaw(self.player)
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
function GameObjectAccessor:Custom_CurrentlyFlying_GetVelocity(velocity)
    self:EnsureLoaded_Quest()

    if self.quest then
        return self.multimod_flight.GetVelocity(self.quest, self.wrappers, velocity)
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
    self:EnsureLoaded_Player()

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
-- NOTE: use Game.NameToString(material) to get just the string of the material (it's a CName)
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

function GameObjectAccessor:IsCrouching()
    self:EnsureLoaded_Player()

    if self.player then
        return self.player.inCrouch
    else
        return false
    end
end

-- Finds things near the player
--  searchQuery: see TSQ_ALL
-- Returns
--  found: bool
--  entities: indexed array of matches
function GameObjectAccessor:GetTargetEntities(searchQuery)
    self:EnsureLoaded_Player()
    self:EnsureLoaded_Targeting()

    if self.player and self.targeting then
        local found, targetParts = self.wrappers.GetTargetParts(self.targeting, self.player, searchQuery)
        if not found or #targetParts == 0 then
            return false, nil
        end

        -- For some reason, the same dead body will be in the parts list 8 times
        -- Might as well convert to entity here
        return true, this.GetDedupedEntities(targetParts)
    end
end

----------------------------------- Private Methods -----------------------------------

function GameObjectAccessor:EnsureLoaded_Player()
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

-- Turns target parts into entities, deduped on hash
function this.GetDedupedEntities(targetParts)
    local entities = {}
    local ids = {}

    for _, part in ipairs(targetParts) do
        local entity = part:GetComponent():GetEntity()
        local id_hash = entity_helper.GetIDHash_Entity(entity)

        if not this.Contains(ids, id_hash) then
            table.insert(ids, id_hash)
            table.insert(entities, entity)
        end
    end

    return entities
end

function this.Contains(list, item)
    for _, value in ipairs(list) do
        if value == item then
            return true
        end
    end

    return false
end

local raycast_filters =
{
    --"Dynamic",      -- Movable Objects
    --"Vehicle",
    "Static",       -- Buildings, Concrete Roads, Crates, etc
    --"Water",
    "Terrain",
    --"PlayerBlocker",        -- Trees, Billboards, Barriers
}
function this.RayCast_Closest(spatial, from_pos, to_pos)
    local closest = nil
    local closest_distsqr = nil

    for i = 1, #raycast_filters do
        -- it would be cool if QueryFilter.ALL() worked here, but it doesn't
        local success, result = spatial:SyncRaycastByCollisionGroup(from_pos, to_pos, raycast_filters[i], false, false)

        if success then
            --print("hit: " .. raycast_filters[i] .. " | " .. tostring(result.material))

            local dist_sqr = GetVectorDiffLengthSqr(from_pos, result.position)

            if closest == nil or dist_sqr < closest_distsqr then
                closest = result
                closest_distsqr = dist_sqr
            end
        end
    end

    return closest
end