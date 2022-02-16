--https://www.lua.org/pil/contents.html
--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md

require "lib/gameobj_accessor"
require "lib/ghosting"
require "lib/input_processing"
require "lib/mathutils"
require "lib/peeking"
require "lib/util"

local this = {}

--------------------------------------------------------------------

local const =
{
    jumpDistance = 1.8,

    peekTime = 1.5,             -- seconds
    peekDistance = 1.8 * 2.5,
    shouldAnimatePeek = true,
}

--------------------------------------------------------------------

local isShutdown = true
local isLoaded = false

local o     -- This is a class that wraps access to Game.xxx

local keys = { ghostForward=false, peekForward=false }

local vars =
{
    isPeeking = false,
    peekingStartTime = 0,

    --NOTE: These sound props are only used for sounds that should be one at a time.  There can
    --      be other sounds that are managed elsewhere
    --sound_current = nil,
    sound_started = 0,
}

--------------------------------------------------------------------

registerForEvent("onInit", function()
    isLoaded = Game.GetPlayer() and Game.GetPlayer():IsAttached() and not GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame()

    Observe('QuestTrackerGameController', 'OnInitialize', function()
        if not isLoaded then
            isLoaded = true
        end
    end)

    Observe('QuestTrackerGameController', 'OnUninitialize', function()
        if Game.GetPlayer() == nil then
            isLoaded = false
            this.ClearObjects()
        end
    end)

    isShutdown = false

    InitializeRandom()

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

    o = GameObjectAccessor:new(wrappers)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    this.ClearObjects()
end)

registerForEvent("onUpdate", function(deltaTime)
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        do return end
    end

    o:Tick(deltaTime)

    if (not keys.ghostForward) and (not keys.peekForward) and (not vars.isPeeking) then
        do return end
    end

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        ResetKeys(keys)
        do return end
    end

    PossiblyStopSound(o, vars, const.peekTime * 2)

    o:GetInWorkspot()
    if o.isInWorkspot then
        ResetKeys(keys)
        do return end
    end

    -- Ghost Forward
    if keys.ghostForward then
        GhostForward(const.jumpDistance, true, o, vars)
    end

    -- Peek Forward
    if vars.isPeeking then
        ContinuePeeking(o, vars, const)
    elseif keys.peekForward then
        StartPeeking(o, vars, const)
    end

    ResetKeys(keys)
end)

registerHotkey("shouldGhostForward", "Ghost Forward", function()
    keys.ghostForward = true
end)

registerHotkey("shouldPeekForward", "Peek Forward", function()
    keys.peekForward = true
end)

------------------------------------ Private Methods -----------------------------------

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    if vars.isPeeking then
        vars.isPeeking = false
        o:SetLocalCamPosition(Vector4.new(0, 0, 0, 1))
    end

    ResetKeys(keys)

    if o then
        o:Clear()
    end
end