local this = {}
function this.GetRandom_Variance(baseVal, variance)
    return baseVal - variance + (math.random() * variance * 2)
end

local pullInterval_player = this.GetRandom_Variance(12, 1)
local pullInterval_workspot = this.GetRandom_Variance(12, 1)
local pullInterval_camera = this.GetRandom_Variance(12, 1)
local pullInterval_teleport = this.GetRandom_Variance(12, 1)
local pullInterval_sensor = this.GetRandom_Variance(12, 1)
local pullInterval_targeting = this.GetRandom_Variance(12, 1)
local pullInterval_timeSys = this.GetRandom_Variance(12, 1)

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
    obj.lastPulled_targeting = -(pullInterval_targeting * 2)
    obj.lastPulled_timeSys = -(pullInterval_timeSys * 2)

    obj.lastGot_lookDir = -1

    return obj
end

-- This gets called when a load is kicked off, or shutdown
-- This needs to drop references to all objects so garbage collector can run correctly
function GameObjectAccessor:Clear()
    self.player = nil
    self.workspot = nil
    self.camera = nil
    self.teleport = nil
    self.sensor = nil
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

-- This is used to slow time
--  0.00001 for near stop
--  up to 1
--  0 Is an invalid input which causes the function UnsetTimeDilation() to run (https://codeberg.org/adamsmasher/cyberpunk/src/branch/master/core/systems/timeSystem.ws)
function GameObjectAccessor:SetTimeDilation(timeSpeed)
    self.wrappers.SetTimeDilation(timeSpeed)
end
function GameObjectAccessor:IsTimeDilationActive()
    if not self.timeSys or (self.timer - self.lastPulled_timeSys) >= pullInterval_timeSys then
        self.lastPulled_timeSys = self.timer

        self.timeSys = self.wrappers.GetTimeSystem()
    end

    if self.timeSys then
        return self.wrappers.Time_IsTimeDilationActive(self.timeSys)
    else
        return false
    end
end

function GameObjectAccessor:HasHeadUnderwater()
    self:EnsurePlayerLoaded()

    if self.player then
        -- CET 1.15 likely fixed this issue
        -- This has a chance of causing crashes, so only call it when there's a posibility of being underwater
        -- NOTE: Judy's lake is at an altitude of 180, so this shortcut won't work there
        -- if self.pos.z > 6 then
        --     return false
        -- end

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

----------------------------------- Private Methods -----------------------------------

function GameObjectAccessor:EnsurePlayerLoaded()
    if not self.player or (self.timer - self.lastPulled_player) >= pullInterval_player then
        self.lastPulled_player = self.timer

        self.player = self.wrappers.GetPlayer()
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