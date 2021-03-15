local pullInterval_player = 12
local pullInterval_workspot = 12
local pullInterval_camera = 12
local pullInterval_teleport = 12
local pullInternal_playerCam = 12

GameObjectAccessor_gf = {}

-- Constructor
function GameObjectAccessor_gf:new(wrappers)
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

function GameObjectAccessor_gf:Tick(deltaTime)
    self.timer = self.timer + deltaTime
end

-- Populates this.player, position, velocity, yaw
function GameObjectAccessor_gf:GetPlayerInfo()
    if (self.timer - self.lastPulled_player) >= pullInterval_player then
        self.lastPulled_player = self.timer

        self.player = self.wrappers.GetPlayer()
    end

    if self.player then
        self.pos = self.wrappers.Player_GetPos(self.player)
        self.vel = self.wrappers.Player_GetVel(self.player)
        self.yaw = self.wrappers.Player_GetYaw(self.player)
    end
end

-- Populates isInWorkspot
--WARNING: If this is called while load is first kicked off, it will crash the game.  So probably want to wait until the player is moving or something
function GameObjectAccessor_gf:GetInWorkspot()
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
function GameObjectAccessor_gf:GetCamera()
    if (self.timer - self.lastPulled_camera) >= pullInterval_camera then
        self.lastPulled_camera = self.timer

        self.camera = self.wrappers.GetCameraSystem()
    end

    if self.camera then
        self.lookdir_forward = self.wrappers.Camera_GetForward(self.camera)
    end
end

-- Teleports to a point, look dir
function GameObjectAccessor_gf:Teleport(pos, yaw)
    if (self.timer - self.lastPulled_teleport) >= pullInterval_teleport then
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
function GameObjectAccessor_gf:SetLocalCamPosition(localPos)
    if (self.timer - self.lastPulled_playerCam) >= pullInternal_playerCam then
        self.lastPulled_playerCam = self.timer

        self.playerCam = self.wrappers.GetFPPCamera(self.player)
    end

    if self.playerCam then
        self.wrappers.SetLocalCamPosition(self.playerCam, localPos)
    end
end
