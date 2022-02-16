local this = {}
function this.GetRandom_Variance(baseVal, variance)
    return baseVal - variance + (math.random() * variance * 2)
end

local pullInterval_player = this.GetRandom_Variance(12, 1)
local pullInterval_workspot = this.GetRandom_Variance(12, 1)
local pullInterval_camera = this.GetRandom_Variance(12, 1)
local pullInterval_teleport = this.GetRandom_Variance(12, 1)
local pullInternal_playerCam = this.GetRandom_Variance(12, 1)

GameObjectAccessor = {}

-- Constructor
function GameObjectAccessor:new(wrappers)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.timer = 0
    obj.wrappers = wrappers
    obj.lastPulled_player = -(pullInterval_player * 2)      -- timer starts at zero.  So zero - -last = max   (multiplying by two to be sure there is no math drift error)
    obj.lastPulled_workspot = -(pullInterval_workspot * 2)
    obj.lastPulled_camera = -(pullInterval_camera * 2)
    obj.lastPulled_teleport = -(pullInterval_teleport * 2)
    obj.lastPulled_playerCam = -(pullInternal_playerCam * 2)

    return obj
end

-- This gets called when a load is kicked off, or shutdown
-- This needs to drop references to all objects so garbage collector can run correctly
function GameObjectAccessor:Clear()
    self.player = nil
    self.workspot = nil
    self.camera = nil
    self.teleport = nil
    self.playerCam = nil
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

    if self.camera then
        self.lookdir_forward = self.wrappers.Camera_GetForward(self.camera)
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

-- This will set the local camera offset (x is left/right, y is front/back, z is up/down)
-- The position is in model coords (not world coords)
-- NOTE: -z pushes the offset up
-- NOTE: There is no need to set every frame if the offset is constant ---- test if switching to inventory and back
function GameObjectAccessor:SetLocalCamPosition(localPos)
    if not self.playerCam or (self.timer - self.lastPulled_playerCam) >= pullInternal_playerCam then
        self.lastPulled_playerCam = self.timer

        self.playerCam = self.wrappers.GetFPPCamera(self.player)
    end

    if self.playerCam then
        self.wrappers.SetLocalCamPosition(self.playerCam, localPos)
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
            PossiblyStopSound(self, vars, 0)
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