local pullInterval_player = 12
local pullInterval_workspot = 12
local pullInterval_camera = 12
local pullInterval_teleport = 12
local pullInterval_sense = 12
local pullInterval_targeting = 12
local pullInterval_mapPin = 12

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
    obj.lastPulled_sense = -(pullInterval_sense * 2)
    obj.lastPulled_targeting = -(pullInterval_targeting * 2)
    obj.lastPulled_mapPin = -(pullInterval_mapPin * 2)

    obj.lastGot_lookDir = -1

    return obj
end

function GameObjectAccessor:Tick(deltaTime)
    self.timer = self.timer + deltaTime
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

-- Get/Set player.Custom_CurrentlyFlying (added in redscript.  Allows mods to talk to each other, so only one at a time will fly)
function GameObjectAccessor:Custom_CurrentlyFlying_get()
    self:EnsurePlayerLoaded()

    if self.player then
        return self.wrappers.Custom_CurrentlyFlying_get(self.player)
    else
        return false
    end
end
function GameObjectAccessor:Custom_CurrentlyFlying_StartFlight()
    self:EnsurePlayerLoaded()

    if self.player then
        self.wrappers.Custom_CurrentlyFlying_StartFlight(self.player)
    end
end
function GameObjectAccessor:Custom_CurrentlyFlying_Clear()
    self:EnsurePlayerLoaded()

    if self.player then
        self.wrappers.Custom_CurrentlyFlying_Clear(self.player)
    end
end

-- Populates isInWorkspot
--WARNING: If this is called while load is first kicked off, it will crash the game.  So probably want to wait until the player is moving or something
function GameObjectAccessor:GetInWorkspot()
    if (self.timer - self.lastPulled_workspot) >= pullInterval_workspot then
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
    if (self.timer - self.lastPulled_camera) >= pullInterval_camera then
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
    if (self.timer - self.lastPulled_teleport) >= pullInterval_teleport then
        self.lastPulled_teleport = self.timer

        self.teleport = self.wrappers.GetTeleportationFacility()
    end

    if self.player and self.teleport then
        self.wrappers.Teleport(self.teleport, self.player, pos, yaw)
    end
end

-- This serves as a ray cast
function GameObjectAccessor:IsPointVisible(fromPos, toPos)
    if (self.timer - self.lastPulled_sense) >= pullInterval_sense then
        self.lastPulled_sense = self.timer

        self.sensor = self.wrappers.GetSenseManager()
    end

    if self.sensor then
        return self.wrappers.IsPositionVisible(self.sensor, fromPos, toPos)
    else
        return nil
    end
end

-- This ray cast also returns normal (but doesn't see quite as much as IsPointVisible)
function GameObjectAccessor:RayCast(fromPos, toPos, staticOnly)
    self:EnsurePlayerLoaded()

    if self.player then
        -- Result is empty string for a miss, or "px|py|pz|nx|ny|nz|mat"
        local result = self.wrappers.RayCast(self.player, fromPos, toPos, staticOnly)

        if result == "" then
            return nil
        end

        -- position
        local i0 = 0
        local i1 = string.find(result, "|", i0)
        local px = string.sub(result, i0, i1 - 1)

        i0 = i1 + 1
        i1 = string.find(result, "|", i0)
        local py = string.sub(result, i0, i1 - 1)

        i0 = i1 + 1
        i1 = string.find(result, "|", i0)
        local pz = string.sub(result, i0, i1 - 1)

        -- normal
        i0 = i1 + 1
        i1 = string.find(result, "|", i0)
        local nx = string.sub(result, i0, i1 - 1)

        i0 = i1 + 1
        i1 = string.find(result, "|", i0)
        local ny = string.sub(result, i0, i1 - 1)

        i0 = i1 + 1
        i1 = string.find(result, "|", i0)
        local nz = string.sub(result, i0, i1 - 1)

        -- material
        local material = string.sub(result, i1 + 1, string.len(result))

        return Vector4.new(tonumber(px), tonumber(py), tonumber(pz), 1), Vector4.new(tonumber(nx), tonumber(ny), tonumber(nz), 1), material
    end
end

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

--NOTE: It's up to the caller to make sure that GetPlayerInfo has already been called
function GameObjectAccessor:HasHeadUnderwater()
    if self.player then
        return self.wrappers.HasHeadUnderwater(self.player)
    end
end

-- This plays a sound, pass in the CName (to find possible strings, search adamsmasher for
-- SoundPlayEvent or SoundStopEvent then walk the call stack)
function GameObjectAccessor:PlaySound(soundName, state)
    self:EnsurePlayerLoaded()

    if self.player then
        StopSound(self, state)

        self.wrappers.QueueSound(self.player, soundName)

        state.sound_current = soundName
        state.sound_started = self.timer
    end
end
function GameObjectAccessor:StopSound(soundName)
    self:EnsurePlayerLoaded()

    if self.player then
        self.wrappers.StopQueuedSound(self.player, soundName)
    end
end

---------------------- private methods

function GameObjectAccessor:EnsurePlayerLoaded()
    if (self.timer - self.lastPulled_player) >= pullInterval_player then
        self.lastPulled_player = self.timer

        self.player = self.wrappers.GetPlayer()
    end
end

function GameObjectAccessor:EnsureMapPinLoaded()
    if (self.timer - self.lastPulled_mapPin) >= pullInterval_mapPin then
        self.lastPulled_mapPin = self.timer

        self.mapPin = self.wrappers.GetMapPinSystem()
    end
end
