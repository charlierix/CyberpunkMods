--https://www.lua.org/pil/contents.html
--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md

require "lib/gameobj_accessor"
require "lib/ghosting"
require "lib/input_processing"
require "lib/mathutils"
require "lib/peeking"
require "lib/util"

--------------------------------------------------------------------

local jumpDistance = 1.8

local peekTime = 1.5      -- seconds
local peekDistance = jumpDistance * 2.5
local shouldAnimatePeek = true

--------------------------------------------------------------------

local isShutdown = true

local o     -- This is a class that wraps access to Game.xxx

local keys = { ghostForward=false, peekForward=false }

local isPeeking = false
local peekingStartTime = 0

--------------------------------------------------------------------

registerForEvent("onInit", function()
    isShutdown = false

    local wrappers = {}
    function wrappers.GetPlayer() return Game.GetPlayer() end
    function wrappers.Player_GetPos(player) return player:GetWorldPosition() end
    function wrappers.Player_GetVel(player) return player:GetVelocity() end
    function wrappers.Player_GetYaw(player) return player:GetWorldYaw() end
    function wrappers.GetWorkspotSystem() return Game.GetWorkspotSystem() end
    function wrappers.Workspot_InWorkspot(workspot, player) return workspot:IsActorInWorkspot(player) end
    function wrappers.GetCameraSystem() return Game.GetCameraSystem() end
    function wrappers.Camera_GetForward(camera) return camera:GetActiveCameraForward() end
    function wrappers.GetTeleportationFacility() return Game.GetTeleportationFacility() end
    function wrappers.Teleport(teleport, player, pos, yaw) return teleport:Teleport(player, pos, EulerAngles.new(0, 0, yaw)) end
    function wrappers.GetFPPCamera(player) return player:GetFPPCameraComponent() end
    function wrappers.SetLocalCamPosition(playerCam, pos) playerCam:SetLocalPosition(pos) end
    o = GameObjectAccessor_gf:new(wrappers)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
end)

registerForEvent("onUpdate", function(deltaTime)


--TODO: Check if in menu


    if isShutdown then
        do return end
    end

    o:Tick(deltaTime)

    if (not keys.ghostForward) and (not keys.peekForward) and (not isPeeking) then
        do return end
    end

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        ResetKeys(keys)
        do return end
    end

    o:GetInWorkspot()       -- this crashes soon after loading a save.  With ghost forward, it should only happen if they initiate a peek right before starting a load
    if o.isInWorkspot then
        ResetKeys(keys)
        do return end
    end

    -- Ghost Forward
    if keys.ghostForward then
        GhostForward(jumpDistance, true, o)
    end

    -- Peek Forward
    if isPeeking then
        if o.timer - peekingStartTime < peekTime then
            if shouldAnimatePeek then
                local offset = peekDistance * GetPeekDistPercent(o.timer - peekingStartTime, peekTime)

                o:SetLocalCamPosition(Vector4.new(0, offset, 0, 1))
            end
        else
            isPeeking = false

            o:SetLocalCamPosition(Vector4.new(0, 0, 0, 1))
        end
    elseif keys.peekForward then
        isPeeking = true
        peekingStartTime = o.timer

        if not shouldAnimatePeek then
            -- no animation, so just set it to the max immediately
            o:SetLocalCamPosition(Vector4.new(0, peekDistance, 0, 1))
        end
    end

    ResetKeys(keys)
end)

registerHotkey("shouldGhostForward", "Ghost Forward", function()
    keys.ghostForward = true
end)

registerHotkey("shouldPeekForward", "Peek Forward", function()
    keys.peekForward = true
end)
