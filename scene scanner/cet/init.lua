--https://www.lua.org/pil/contents.html
--https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
--http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#numerical_error_and_result_codes

--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md
--https://github.com/ocornut/imgui/blob/b493cae8c971843886d760bb816dcab661779d69/imgui.h
--https://github.com/ocornut/imgui/blob/25fbff2156640cc79e9a79db00522019b4a0420f/imgui_draw.cpp

--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://redscript.redmodding.org/
--https://codeberg.org/adamsmasher/cyberpunk/src/branch/master

--https://github.com/jac3km4/redscript

require "!src/core/color"
require "!src/core/gameobj_accessor"
require "!src/core/math_basic"
require "!src/core/math_raycast"
require "!src/core/math_vector"
require "!src/core/math_yaw"
require "!src/core/util"

require "!src/debug/debug_code"

require "!src/processing/recorder"

require "!src/ui/window_debug"
require "!src/ui/window_recording"

-- NOTE: Copied in all these files, even though only some of the methods are needed.  Some of the functions reference functions
-- in ui_controls_generic, which also expect the stylesheet to have certain sections, but none of that was copied (currently,
-- grappling hook and wall hang use this ui framework, but it's overkill to copy the whole thing here)
require "!src/ui_framework/changes"
require "!src/ui_framework/common_definitions"
require "!src/ui_framework/updown_delegates"
require "!src/ui_framework/util_controls"
require "!src/ui_framework/util_layout"
require "!src/ui_framework/util_misc"
require "!src/ui_framework/util_setup"

extern_json = require "!src/external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

local this = {}

---------------------------------------------------------------------------------------
---                                    Constants                                    ---
---------------------------------------------------------------------------------------

local const =
{
    raysPerFrame = 14,
    rayLen = 60,
    rayHeightMin = 1,
    rayHeightMax = 2.5,

    shouldShowDebugWindow = false,      -- shows a window with extra debug info
}

---------------------------------------------------------------------------------------
---                                  Current State                                  ---
---------------------------------------------------------------------------------------

local isShutdown = true
local isLoaded = false
local shouldDraw = false
local shouldShowConfig = false

local o     -- This is a class that wraps access to Game.xxx

local debug = {}

local recorder = nil

local vars =
{
    --recording_start_time      -- gets set when the recording starts
}

local vars_ui =
{
    --style     -- this gets loaded from json during init
}

---------------------------------------------------------------------------------------

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
    vars_ui.style = LoadStylesheet()

    local wrappers = {}
    function wrappers.GetPlayer() return Game.GetPlayer() end
    function wrappers.Player_GetPos(player) return player:GetWorldPosition() end
    function wrappers.Player_GetVel(player) return player:GetVelocity() end
    function wrappers.Player_GetYaw(player) return player:GetWorldYaw() end
    function wrappers.GetWorkspotSystem() return Game.GetWorkspotSystem() end
    function wrappers.Workspot_InWorkspot(workspot, player) return workspot:IsActorInWorkspot(player) end
    function wrappers.GetCameraSystem() return Game.GetCameraSystem() end
    function wrappers.Camera_GetForwardRight(camera) return camera:GetActiveCameraForward(), camera:GetActiveCameraRight() end
    function wrappers.GetTeleportationFacility() return Game.GetTeleportationFacility() end
    function wrappers.Teleport(teleport, player, pos, yaw) return teleport:Teleport(player, pos, EulerAngles.new(0, 0, yaw)) end
    function wrappers.GetSenseManager() return Game.GetSenseManager() end
    function wrappers.IsPositionVisible(sensor, fromPos, toPos) return sensor:IsPositionVisible(fromPos, toPos) end
    function wrappers.RayCast(player, from, to, staticOnly) return player:SceneScanner_RayCast(from, to, staticOnly) end
    function wrappers.SetTimeDilation(timeSpeed) Game.SetTimeDilation(tostring(timeSpeed)) end      -- for some reason, it takes in string
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    function wrappers.GetGetFPPCamera(player) return player:GetFPPCameraComponent() end
    function wrappers.GetLocalOrientation(fppcam) return fppcam:GetLocalOrientation() end
    function wrappers.SetLocalOrientation(fppcam, quat) fppcam:SetLocalOrientation(quat) end

    o = GameObjectAccessor:new(wrappers)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    this.ClearObjects()
end)

registerForEvent("onUpdate", function(deltaTime)
    shouldDraw = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        do return end
    end

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        do return end
    end

    shouldDraw = true

    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, vars, recorder)
    end

    if recorder then
        recorder:Tick()
    end
end)

registerHotkey("SceneScanner_StartStopRecording_no", "Start/Stop Recording -vehicles", function()
    this.StartStop(false)
end)
registerHotkey("SceneScanner_StartStopRecording_yes", "Start/Stop Recording +vehicles", function()
    this.StartStop(true)
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        shouldShowConfig = false
        do return end
    end

    if recorder then
        DrawRecording(o, vars_ui, vars.recording_start_time, #recorder.hits)
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug)
    end
end)

----------------------------------- Private Methods -----------------------------------

function this.StartStop(includeVehicles)
    if recorder then
        recorder:Stop()
        recorder = nil
    else
        recorder = Recorder:new(o, const, includeVehicles)
        vars.recording_start_time = o.timer
    end
end

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    if o then
        o:Clear()
    end
end