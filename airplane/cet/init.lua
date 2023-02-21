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

require "core/check_other_mods"
require "core/color"
require "core/customprops_wrapper"
require "core/gameobj_accessor"
require "core/lists"
require "core/math_basic"
require "core/math_raycast"
require "core/math_shapes"
require "core/math_vector"
require "core/math_yaw"
require "core/strings"
require "core/util"

require "data/dal"
require "data/util_data"

require "debug/debug_code"
require "debug/debug_render_logger"

require "processing/flightmode_transitions"
require "processing/processing_flying"
require "processing/processing_standard"

-- require "ui/drawing"
-- require "ui/init_ui"
-- require "ui/keys"
-- require "ui/reporting"
-- require "ui/sounds"
-- require "ui/transition_windows"

-- require "ui_controls_generic/button"
-- require "ui_controls_generic/checkbox"
-- require "ui_controls_generic/help_button"
-- require "ui_controls_generic/label"
-- require "ui_controls_generic/label_clickable"
-- require "ui_controls_generic/listbox"
-- require "ui_controls_generic/multiitem_displaylist"
-- require "ui_controls_generic/okcancel_buttons"
-- require "ui_controls_generic/orderedlist"
-- require "ui_controls_generic/progressbar_slim"
-- require "ui_controls_generic/remove_button"
-- require "ui_controls_generic/slider"
-- require "ui_controls_generic/summary_button"
-- require "ui_controls_generic/textbox"
-- require "ui_controls_generic/updownbuttons"

-- require "ui_framework/changes"
-- require "ui_framework/common_definitions"
-- require "ui_framework/updown_delegates"
-- require "ui_framework/util_controls"
-- require "ui_framework/util_layout"
-- require "ui_framework/util_misc"
-- require "ui_framework/util_setup"

-- require "ui_windows/main"

extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

local this = {}

--------------------------------------------------------------------
---                          Constants                           ---
--------------------------------------------------------------------

local const =
{
    flightModes = CreateEnum("standard", "flying"),

    modNames = CreateEnum("airplane"),     -- this really doesn't need to know the other mod names, since airplane is triggered by a hotkey

    -- Populated in InitializeSavedFields()
    --mouse_sensitivity = -0.08,
    --rightstick_sensitivity = 50,        -- the mouse x seems to be yaw/second (in degrees).  The controller's right thumbstick is -1 to 1.  So this multiplier will convert into yaw/second.  NOTE: the game speeds it up if they hold it for a while, but this doesn't do that

    -- These are set in Define_UI_Framework_Constants() called during init
    -- alignment_horizontal = CreateEnum("left", "center", "right"),
    -- alignment_vertical = CreateEnum("top", "center", "bottom"),

    -- windows = CreateEnum
    -- (
    --     "main"
    -- ),

    settings = CreateEnum(
        -- Bools
        "AutoShowConfig_WithConsole",
        -- Floats
        "MouseSensitivity",
        "RightStickSensitivity"),

    rayFrom_Z = 1.5,

    shouldShowDebugWindow = false,
}

--------------------------------------------------------------------
---                        Current State                         ---
--------------------------------------------------------------------

local isShutdown = true
local isLoaded = false
local shouldDraw = false
local shouldShowConfig = false
local isConfigRepress = false

local o     -- This is a class that wraps access to Game.xxx

local debug = {}

local vars =
{
    --flightMode,       -- Holds what state of flight it is in.  One of const.flightModes

    --NOTE: These sound props are only used for sounds that should be one at a time.  There can
    --      be other sounds that are managed elsewhere
    --sound_current = nil,  -- can't store nil in a table, because it just goes away.  But non nil will use this name.  Keeping it simple, only allowing one sound at a time.  If multiple are needed, use StickyList
    sound_started = 0,
}

-- local vars_ui =
-- {
--     --screen    -- info about the current screen resolution -- see GetScreenInfo()
--     --style     -- this gets loaded from json during init
--     --configWindow  -- info about the location of the config window -- see Define_ConfigWindow()
--     --line_heights  -- the height of strings -- see Refresh_LineHeights()

--     --autoshow_withconsole      -- bool that tells whether config shows the same time as the cet console, or requires a separate hotkey

--     isTooltipShowing = false,       -- the tooltip is actually a sub window.  This is needed so the parent window's titlebar can stay the active color

--     -- ***** See window_transitions.lua *****
--     currentWindow = const.windows.main,
--     transition_info = {}       -- this holds properties needed for the window (like grappleIndex for grapple_straight)
-- }

--------------------------------------------------------------------

registerForEvent("onInit", function()
    Observe("PlayerPuppet", "OnGameAttached", function(self)
        self:RegisterInputListener(self)
    end)

    Observe("PlayerPuppet", "OnAction", function(_, action)        -- observe must be inside init and before other code
        keys:MapAction(action)
    end)

    isLoaded = Game.GetPlayer() and Game.GetPlayer():IsAttached() and not GetSingleton('inkMenuScenario'):GetSystemRequestsHandler():IsPreGame()

    Observe('QuestTrackerGameController', 'OnInitialize', function()
        if not isLoaded then
            isLoaded = true
            Transition_ToStandard(vars, const, debug, o)
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
    EnsureTablesCreated()
    --Define_UI_Framework_Constants(const)
    --InitializeUI(vars_ui, const)       --NOTE: This must be done after db is initialized.  TODO: listen for video settings changing and call this again (it stores the current screen resolution)
    InitializeSavedFields(const)

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
    function wrappers.RayCast(player, from, to, staticOnly) return player:Airplane_RayCast(from, to, staticOnly) end
    function wrappers.SetTimeDilation(timeSpeed) Game.SetTimeDilation(tostring(timeSpeed)) end      -- for some reason, it takes in string
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    function wrappers.Custom_CurrentlyFlying_get(player) return Custom_CurrentlyFlying_get(player) end
    function wrappers.Custom_CurrentlyFlying_StartFlight(player) Custom_CurrentlyFlying_StartFlight(player, const.modNames) end
    function wrappers.Custom_CurrentlyFlying_Clear(player) Custom_CurrentlyFlying_Clear(player, const.modNames) end
    function wrappers.QueueSound(player, sound) player:Airplane_QueueSound(sound) end
    function wrappers.StopQueuedSound(player, sound) player:Airplane_StopQueuedSound(sound) end

    o = GameObjectAccessor:new(wrappers)

    Transition_ToStandard(vars, const, debug, o)
    --TransitionWindows_Main(vars_ui, const)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    this.ClearObjects()
end)

registerForEvent("onUpdate", function(deltaTime)
    shouldDraw = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    StopSound(o, vars)

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    shouldDraw = true       -- don't want a hung progress bar while in menu or driving

    -- if const.shouldShowDebugWindow then
    --     PopulateDebug(debug, o, keys, vars, startStopTracker)
    -- end

    if vars.flightMode == const.flightModes.standard then
        -- Standard (walking around)
        Process_Standard(o, vars, const, debug)

    elseif not CheckOtherModsFor_ContinueFlight(o, const.modNames) then
        -- Was hanging/jumping, but another mod took over
        Transition_ToStandard(vars, const, debug, o)

    elseif vars.flightMode == const.flightModes.flying then
        Process_Flying(o, vars, const, debug, deltaTime)

    else
        LogError("Unknown flightMode: " .. tostring(vars.flightMode))
        Transition_ToStandard(vars, const, debug, o)
    end
end)

-- registerHotkey("AirplaneTesterButton", "tester hotkey", function()
-- end)

-- registerHotkey("Airplane_Config", "Show Config", function()
--     if shouldShowConfig then
--         isConfigRepress = true      -- this is used as a request to close.  The window will only close if they are on a main screen, and not dirty
--     end

--     -- This only shows the config.  They need to push a close button (and possibly ok/cancel for saving)
--     shouldShowConfig = true
-- end)
-- registerForEvent("onOverlayOpen", function()
--     if not vars_ui.autoshow_withconsole then
--         do return end
--     end

--     shouldShowConfig = true
-- end)
-- registerForEvent("onOverlayClose", function()
--     if not vars_ui.autoshow_withconsole then
--         do return end
--     end

--     if shouldShowConfig then
--         isConfigRepress = true
--     end
-- end)

registerHotkey("Airplane_ToggleFlight", "Toggle Flight", function()
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        do return end
    end

    -- if shouldShowConfig and player and player_arcade then
    --     shouldShowConfig = DrawConfig(isConfigRepress, vars, vars_ui, o, const, player, player_arcade)
    --     isConfigRepress = false

    --     if not shouldShowConfig then
    --         -- They closed from an arbitrary window, make sure the next time config starts at main
    --         TransitionWindows_Main(vars_ui, const)
    --     end
    -- end

    if const.shouldShowDebugWindow then
        --DrawDebugWindow(debug)
    end
end)

------------------------- Private Methods --------------------------

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    Transition_ToStandard(vars, const, debug, o)

    if o then
        o:Clear()
    end
end

--------------------------------------------------------------------

function TODO()
end