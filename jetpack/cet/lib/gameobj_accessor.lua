local pullInterval_player = 12
local pullInterval_workspot = 12
local pullInterval_camera = 12
local pullInterval_teleport = 12
local pullInterval_sense = 12
local pullInterval_targeting = 12

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

-- This will launch NPCs straight up (in theory, all around the player, but it seems to mostly
-- be the ones that are in front of the player)
function GameObjectAccessor:RagdollNPCs_StraightUp(radius, force, randHorz, randVert)
    self:EnsurePlayerLoaded()

    if self.player then
        self.wrappers.Ragdoll_Up(self.player, radius, force, randHorz, randVert)
    end
end

function GameObjectAccessor:RagdollNPCs_ExplodeOut(radius, force, upForce)
    self:EnsurePlayerLoaded()

    if self.player then
        self.wrappers.Ragdoll_Out(self.player, radius, force, upForce)
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