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

require "core/color"
require "core/gameobj_accessor"
require "core/math_basic"
require "core/math_raycast"
require "core/math_vector"
require "core/math_yaw"
require "core/util"

require "debug/debug_code"

require "processing/apply_rotations_absolute"
require "processing/apply_rotations_additive"
require "processing/handle_inputs"

require "ui/drawing"
require "ui/trackball"

-- NOTE: Copied in all these files, even though only some of the methods are needed.  Some of the functions reference functions
-- in ui_controls_generic, which also expect the stylesheet to have certain sections, but none of that was copied (currently,
-- grappling hook and wall hang use this ui framework, but it's overkill to copy the whole thing here)
require "ui_framework/changes"
require "ui_framework/common_definitions"
require "ui_framework/updown_delegates"
require "ui_framework/util_controls"
require "ui_framework/util_layout"
require "ui_framework/util_misc"
require "ui_framework/util_setup"

extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

local this = {}

--------------------------------------------------------------------
---                          Constants                           ---
--------------------------------------------------------------------

local const =
{
    turn_rate = 60,        -- degrees per second
    trackball_mult = 8,

    use_absolute = false,        -- only use absolute if you apply rotations around a single axis (like rolling).  In that case, it's a good optimization

    -- These are set in Define_UI_Framework_Constants() called during init
    -- alignment_horizontal = CreateEnum("left", "center", "right"),
    -- alignment_vertical = CreateEnum("top", "center", "bottom"),

    shouldShowDebugWindow = true,      -- shows a window with extra debug info
}

--------------------------------------------------------------------
---                        Current State                         ---
--------------------------------------------------------------------

local isShutdown = true
local isLoaded = false
local shouldDraw = false
local shouldShowConfig = false

local o     -- This is a class that wraps access to Game.xxx

local keys =
{
    roll_left = false,
    roll_right = false,

    pitch_down = false,
    pitch_up = false,

    yaw_left = false,
    yaw_right = false,
}

local debug = {}

local vars =
{
    roll_desired = 0,
    roll_current = 0,        -- current is only used by absolute.  the additive just sets desired back to zero once it's applied (because for additive, desired is treated like a delta)

    pitch_desired = 0,
    pitch_current = 0,

    yaw_desired = 0,
    yaw_current = 0,

    deltas = {},       -- this is used by the trackball control.  It is a list of delta quaternions to apply
}

local vars_ui =
{
    --style     -- this gets loaded from json during init
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
    Define_UI_Framework_Constants(const)
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
    function wrappers.SetTimeDilation(timeSpeed) Game.SetTimeDilation(tostring(timeSpeed)) end      -- for some reason, it takes in string
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    function wrappers.GetGetFPPCamera(player) return player:GetFPPCameraComponent() end
    function wrappers.GetInitialOrientation(fppcam) return fppcam:GetInitialOrientation() end
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
        PopulateDebug(debug, o, keys, vars)
    end

    HandleInputs(vars, keys, const, deltaTime)

    if const.use_absolute then
        ApplyRotations_Absolute(o, vars, debug, const)
    else
        ApplyRotations_Additive(o, vars, debug, const)
    end
end)

registerHotkey("HeadRollPitchDemo_Reset", "Reset", function()
    vars.roll_desired = 0
    vars.roll_current = 0

    vars.pitch_desired = 0
    vars.pitch_current = 0

    vars.yaw_desired = 0
    vars.yaw_current = 0

    for i = #vars.deltas, 1, -1 do
        table.remove(vars.deltas, i)
    end
    
    --o:FPP_SetLocalOrientation(o:FPP_GetInitialOrientation())      -- this doesn't work, since initial_orientation always seems to be the same as local_orientation
    o:FPP_SetLocalOrientation(GetIdentityQuaternion())
end)

registerInput("HeadRollPitchDemo_RollLeft", "Roll Left", function(isDown)
    keys.roll_left = isDown
end)
registerInput("HeadRollPitchDemo_RollRight", "Roll Right", function(isDown)
    keys.roll_right = isDown
end)

registerInput("HeadRollPitchDemo_PitchDown", "Pitch Down", function(isDown)
    keys.pitch_down = isDown
end)
registerInput("HeadRollPitchDemo_PitchUp", "Pitch Up", function(isDown)
    keys.pitch_up = isDown
end)

registerInput("HeadRollPitchDemo_YawLeft", "Yaw Left", function(isDown)
    keys.yaw_left = isDown
end)
registerInput("HeadRollPitchDemo_YawRight", "Yaw Right", function(isDown)
    keys.yaw_right = isDown
end)

-- no need to disable when console is closed
-- registerForEvent("onOverlayOpen", function()
--     shouldShowConfig = true
-- end)
-- registerForEvent("onOverlayClose", function()
--     shouldShowConfig = false
-- end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        shouldShowConfig = false
        do return end
    end

    --if shouldShowConfig then
    DrawConfig(vars, vars_ui, o, debug, const)
    --end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug)
    end
end)

------------------------- Private Methods --------------------------

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    if o then
        o:Clear()
    end
end