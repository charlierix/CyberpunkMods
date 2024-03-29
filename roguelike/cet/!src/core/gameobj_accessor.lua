local this = {}
function this.GetRandom_Variance(baseVal, variance)
    return baseVal - variance + (math.random() * variance * 2)
end

local pullInterval_player = this.GetRandom_Variance(12, 1)
local pullInterval_workspot = this.GetRandom_Variance(12, 1)
local pullInterval_camera = this.GetRandom_Variance(12, 1)
local pullInterval_teleport = this.GetRandom_Variance(12, 1)
local pullInterval_sensor = this.GetRandom_Variance(12, 1)
local pullInterval_mapPin = this.GetRandom_Variance(12, 1)
local pullInterval_quest = this.GetRandom_Variance(12, 1)

GameObjectAccessor = {}

-- Constructor
function GameObjectAccessor:new(wrappers)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.timer = 0
    obj.wrappers = wrappers
    obj.lastPulled_player = -(pullInterval_player * 2)      -- timer starts at zero.  So zero - -max = max   (multiplying by two to be sure there is no math drift error)
    obj.lastPulled_workspot = -(pullInterval_workspot * 2)
    obj.lastPulled_camera = -(pullInterval_camera * 2)
    obj.lastPulled_teleport = -(pullInterval_teleport * 2)
    obj.lastPulled_sensor = -(pullInterval_sensor * 2)
    obj.lastPulled_mapPin = -(pullInterval_mapPin * 2)
    obj.lastPulled_quest = -(pullInterval_quest * 2)

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
    self.mapPin = nil
    self.quest = nil
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

function GameObjectAccessor:GetPlayerWorldTransform()
    self:EnsurePlayerLoaded()

    if self.player then
        return self.wrappers.Player_GetWorldTransform(self.player)
    else
        return nil
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

-- This serves as a ray cast
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

-- This ray cast also returns normal (but doesn't see quite as much as IsPointVisible)
-- function GameObjectAccessor:RayCast(fromPos, toPos, staticOnly)
--     self:EnsurePlayerLoaded()

--     if self.player then
--         -- Result is empty string for a miss, or "px|py|pz|nx|ny|nz|mat"
--         local result = self.wrappers.RayCast(self.player, fromPos, toPos, staticOnly)

--         if result == "" then
--             return nil
--         end

--         -- position
--         local i0 = 0
--         local i1 = string.find(result, "|", i0)
--         local px = string.sub(result, i0, i1 - 1)

--         i0 = i1 + 1
--         i1 = string.find(result, "|", i0)
--         local py = string.sub(result, i0, i1 - 1)

--         i0 = i1 + 1
--         i1 = string.find(result, "|", i0)
--         local pz = string.sub(result, i0, i1 - 1)

--         -- normal
--         i0 = i1 + 1
--         i1 = string.find(result, "|", i0)
--         local nx = string.sub(result, i0, i1 - 1)

--         i0 = i1 + 1
--         i1 = string.find(result, "|", i0)
--         local ny = string.sub(result, i0, i1 - 1)

--         i0 = i1 + 1
--         i1 = string.find(result, "|", i0)
--         local nz = string.sub(result, i0, i1 - 1)

--         -- material
--         local material = string.sub(result, i1 + 1, string.len(result))

--         return Vector4.new(tonumber(px), tonumber(py), tonumber(pz), 1), Vector4.new(tonumber(nx), tonumber(ny), tonumber(nz), 1), material
--     end
-- end

-- Copied from discord: cet-snips
-- NonameNonumber — 02/14/2021
-- Place a map pin at the player's current position: [shared credits with @b0kkr]
-- https://github.com/WolvenKit/CyberCAT/blob/main/CyberCAT.Core/Enums/Dumped%20Enums/gamedataMappinVariant.cs
function GameObjectAccessor:CreatePin(pos, variant)
    self:EnsureMapPinLoaded()

    if self.mapPin then
        local data = NewObject("gamemappinsMappinData")
        data.mappinType = TweakDBID.new("Mappins.DefaultStaticMappin")
        data.variant = Enum.new("gamedataMappinVariant", variant)
        data.visibleThroughWalls = true

        return self.wrappers.RegisterMapPin(self.mapPin, data, pos)
    end
end
function GameObjectAccessor:MovePin(id, pos)
    self:EnsureMapPinLoaded()

    if self.mapPin then
        self.wrappers.SetMapPinPosition(self.mapPin, id, pos)
    end
end
function GameObjectAccessor:ChangePinIcon(id, variant)
    self:EnsureMapPinLoaded()

    if self.mapPin then
        --NOTE: This function doesn't always work
        self.wrappers.ChangeMappinVariant(self.mapPin, id, variant)
    end
end
function GameObjectAccessor:RemovePin(id)
    self:EnsureMapPinLoaded()

    if self.mapPin then
        self.wrappers.UnregisterMapPin(self.mapPin, id)
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
-- function GameObjectAccessor:PlaySound(soundName, vars)
--     self:EnsurePlayerLoaded()

--     if self.player then
--         if vars then
--             StopSound(self, vars)
--         end

--         self.wrappers.QueueSound(self.player, soundName)

--         if vars then
--             vars.sound_current = soundName
--             vars.sound_started = self.timer
--         end
--     end
-- end
-- function GameObjectAccessor:StopSound(soundName)
--     self:EnsurePlayerLoaded()

--     if self.player then
--         self.wrappers.StopQueuedSound(self.player, soundName)
--     end
-- end

-- This gets/sets a unique ID (must be int) in the save file's quest system.  That is used to
-- uniquely identify a playthrough so that each created character has their own grapple config
--
-- Everything in the sqlite db is kept separated with this ID so that settings don't bleed
-- between playthroughs
function GameObjectAccessor:GetPlayerUniqueID()
    self:EnsureQuestLoaded()

    if self.quest then
        -- this is a made up key, and can't be the same as other mod's
        -- this returns zero if the key doesn't exist
        return self.wrappers.GetQuestFactStr(self.quest, "grapple_player_uniqueid")
    end
end
function GameObjectAccessor:SetPlayerUniqueID(id)
    self:EnsureQuestLoaded()

    if self.quest then
        self.wrappers.SetQuestFactStr(self.quest, "grapple_player_uniqueid", id)      -- the ID must be integer
    end
end

----------------------------------- Private Methods -----------------------------------

function GameObjectAccessor:EnsurePlayerLoaded()
    if not self.player or (self.timer - self.lastPulled_player) >= pullInterval_player then
        self.lastPulled_player = self.timer

        self.player = self.wrappers.GetPlayer()
    end
end

function GameObjectAccessor:EnsureMapPinLoaded()
    if not self.mapPin or (self.timer - self.lastPulled_mapPin) >= pullInterval_mapPin then
        self.lastPulled_mapPin = self.timer

        self.mapPin = self.wrappers.GetMapPinSystem()
    end
end

function GameObjectAccessor:EnsureQuestLoaded()
    if not self.quest or (self.timer - self.lastPulled_quest) >= pullInterval_quest then
        self.lastPulled_quest = self.timer

        self.quest = self.wrappers.GetQuestsSystem()
    end
end