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

require "core/animation_curve"
require "core/bezier"
require "core/bezier_segment"
require "core/color"
require "core/gameobj_accessor"
require "core/lists"
require "core/math_basic"
require "core/math_shapes"
require "core/math_vector"
require "core/math_yaw"
require "core/strings"
require "core/util"

require "data/dal"
require "data/player"
require "data/player_arcade"
require "data/util_data"

require "debug/debug_code"
require "debug/debug_render_logger"
require "debug/reporting"

require "processing/flightmode_transitions"
require "processing/flightutil"
require "processing/jump_avoid_overhangs"
require "processing/processing_hang"
require "processing/processing_jump_calculate"
require "processing/processing_jump_impulse"
require "processing/processing_jump_teleturn"
require "processing/processing_standard"
require "processing/safetyfire"
require "processing/util_idealdist"
require "processing/util_wallcrawl"
require "processing/util_wallraycast"

require "ui/drawing"
require "ui/init_ui"
require "ui/inputtracker_startstop"
require "ui/keys"
require "ui/sounds"
require "ui/transition_windows"

require "ui_controls_generic/button"
require "ui_controls_generic/checkbox"
require "ui_controls_generic/combobox"
require "ui_controls_generic/help_button"
require "ui_controls_generic/label"
require "ui_controls_generic/label_clickable"
require "ui_controls_generic/listbox"
require "ui_controls_generic/multiitem_displaylist"
require "ui_controls_generic/okcancel_buttons"
require "ui_controls_generic/orderedlist"
require "ui_controls_generic/progressbar_slim"
require "ui_controls_generic/remove_button"
require "ui_controls_generic/slider"
require "ui_controls_generic/summary_button"
require "ui_controls_generic/textbox"
require "ui_controls_generic/updownbuttons"

require "ui_framework/changes"
require "ui_framework/common_definitions"
require "ui_framework/updown_delegates"
require "ui_framework/util_controls"
require "ui_framework/util_layout"
require "ui_framework/util_misc"
require "ui_framework/util_setup"

require "ui_windows/crawl_slide"
require "ui_windows/input_bindings"
require "ui_windows/jumping"
require "ui_windows/main"
require "ui_windows/wall_attraction"

extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

local this = {}

--------------------------------------------------------------------
---                          Constants                           ---
--------------------------------------------------------------------

local const =
{
    flightModes = CreateEnum("standard", "hang", "jump_calculate", "jump_teleturn", "jump_impulse"),

    -- Populated in InitializeSavedFields()
    --mouse_sensitivity = -0.08,
    --rightstick_sensitivity = 50,      -- the mouse x seems to be yaw/second (in degrees).  The controller's right thumbstick is -1 to 1.  So this multiplier will convert into yaw/second.  NOTE: the game speeds it up if they hold it for a while, but this doesn't do that
    --latch_wallhang,                   -- false: must keep the hang key held in
    --should_jump_backward,             -- replaced by the new jumping config (values stored in player)
    --jump_sound_standard,              -- true: regular jump sound, false: a lighter sound

    -- These are set in Define_UI_Framework_Constants() called during init
    -- alignment_horizontal = CreateEnum("left", "center", "right"),
    -- alignment_vertical = CreateEnum("top", "center", "bottom"),

    windows = CreateEnum
    (
        "main",
            "input_bindings",
            "jumping",
            "wall_attraction",
            "crawl_slide"
    ),

    bindings = CreateEnum("hang", "wall_run"),

    settings = CreateEnum(
        -- Bools
        "AutoShowConfig_WithConsole",
        "WallHangKey_UseCustom",
        "Latch_WallHang",
        "ShouldJumpBackward",
        "JumpSoundStandard",
        -- Floats
        "MouseSensitivity",
        "RightStickSensitivity"),

    jump_config_none = "*  none  *",        -- this is the string to use for no config (can't use nil, because then it's not known if a port from old version is needed).  Using asterisk, because files can't have that in the name
    jump_config_default = "default",
    jump_config_default_shift = "default - strong",
    jump_config_default_nolatch = "default - nolatch",
    jump_config_uponly_nolatch = "up only - nolatch",
    jump_config_backjump_nolatch = "back jump - nolatch",

    override_relatch = CreateEnum("use_config", "always", "never"),

    filetype = CreateEnum("file", "directory"),     -- this is the .type property of items when iterating the dir fuction

    fall_damage = CreateEnum("none", "damage_safe", "damage_lethal", "no_damage"),

    rayFrom_Z = 1.5,

    wallDistance_stick_min = 0.45,
    wallDistance_stick_ideal = 0.7,        --NOTE: The rest of the raycast settings are in player
    wallDistance_stick_max = 1.2,

    teleturn_radians_per_second = math.pi * 3.5,      -- this needs to be very fast, teleturn is a hack and can't last very long.  Just enough motion that the player can sense the direction change (it's very disorienting to instantly face a new direction)

    ledgeHop_impulse = 4,
    ledgeHop_angle = 86,        -- 90 would be straight up, 0 would be horizontal

    shouldShowLogging3D_latchRayTrace = false,
    shouldShowLogging3D_wallCrawl = false,
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
local isCETOpen = false
local isConfigMinimized = false

local o     -- This is a class that wraps access to Game.xxx

local keys = nil -- = Keys:new()        -- moved to init
local startStopTracker = nil -- InputTracker_StartStop:new()        -- moved to init

local debug = {}

local vars =
{
    --flightMode,       -- Holds what state of flight it is in.  One of const.flightModes

    -- Populated in InitializeKeyBindings()
    --wallhangkey_usecustom,     -- true: use the cet binding, false: use the action binding

    -- These are used by Process_Standard()
    --is_sliding,
    --is_attracting,

    -- These get populated in Transition_ToHang() and/or Transition_ToJump_Calculate()
    --hangPos,
    --normal,

    -- This gets populated in Transition_ToJump_Calculate()
    --jump_settings,

    -- These get populated in Transition_ToJump_TeleTurn()
    --impulse,
    --final_lookdir,

    -- Populated in Transition_ToJump_TeleTurn and Transition_ToJump_Impulse to tell Transition_ToStandard to set up a relatch (done by startStopTracker)
    -- This also overrides the default wall attraction props
    -- relatch =
    -- {
    --     time_seconds,
    --     distance_max,
    --     accel,
    --     pow,
    --     antigrav,
    -- },

    -- This is needed by Transition_ToStandard to tell it when to relatch
    --startStopTracker,

    --NOTE: These sound props are only used for sounds that should be one at a time.  There can
    --      be other sounds that are managed elsewhere
    --sound_current = nil,  -- can't store nil in a table, because it just goes away.  But non nil will use this name.  Keeping it simple, only allowing one sound at a time.  If multiple are needed, use StickyList
    sound_started = 0,
}

local vars_ui =
{
    --screen    -- info about the current screen resolution -- see GetScreenInfo()
    --style     -- this gets loaded from json during init
    --configWindow  -- info about the location of the config window -- see Define_ConfigWindow()
    --line_heights  -- the height of strings -- see Refresh_LineHeights()

    scale = 1,      -- control and window sizes are defined in pixels, then get multiplied by scale at runtime.  CET may adjust scale on non 1920x1080 monitors to give a consistent relative size, but higher resolution

    --autoshow_withconsole      -- bool that tells whether config shows the same time as the cet console, or requires a separate hotkey

    isTooltipShowing = false,       -- the tooltip is actually a sub window.  This is needed so the parent window's titlebar can stay the active color

    -- ***** See window_transitions.lua *****
    currentWindow = const.windows.main,
    transition_info = {}       -- this holds properties needed for the window (like grappleIndex for grapple_straight)

    -- ***** Each of these is a container of controls (name matches the values in windows enum) *****
    --main
    --energy_tank
    --grapple_straight

    --keys          -- gets added so it doesn't have to be included in a ton of function params (only used by the input bindings and transition to/from)
}

local player_arcade = nil
local player = nil

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
            Transition_ToStandard(vars, const, debug, o, nil)
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
    Define_UI_Framework_Constants(const)
    InitializeUI(vars_ui, const)       --NOTE: This must be done after db is initialized.  TODO: listen for video settings changing and call this again (it stores the current screen resolution)
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
    function wrappers.SetTimeDilation(timeSpeed) Game.SetTimeDilation(tostring(timeSpeed)) end      -- for some reason, it takes in string
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    function wrappers.GetQuestsSystem() return Game.GetQuestsSystem() end
    function wrappers.GetQuestFactStr(quest, key) return quest:GetFactStr(key) end
    function wrappers.SetQuestFactStr(quest, key, id) quest:SetFactStr(key, id) end       -- id must be an integer
    function wrappers.GetSpatialQueriesSystem() return Game.GetSpatialQueriesSystem() end
    function wrappers.GetTargetingSystem() return Game.GetTargetingSystem() end
    function wrappers.GetStatPoolsSystem() return Game.GetStatPoolsSystem() end
    function wrappers.GetStatPoolValue(stats, entityid, stat_type, is_percent) return stats:GetStatPoolValue(entityid, stat_type, is_percent) end
    function wrappers.SetStatPoolValue(stats, entityid, instigator, stat_type, delta, is_percent) stats:RequestChangingStatPoolValue(entityid, stat_type, delta, instigator, true, is_percent) end

    o = GameObjectAccessor:new(wrappers)

    keys = Keys:new(o, const)
    vars_ui.keys = keys

    InitializeKeyBindings(keys, vars, const)

    startStopTracker = InputTracker_StartStop:new(o, vars, keys, const)
    vars.startStopTracker = startStopTracker

    Transition_ToStandard(vars, const, debug, o, nil)
    TransitionWindows_Main(vars_ui, const)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    this.ClearObjects()
end)

registerForEvent("onUpdate", function(deltaTime)
    shouldDraw = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        Transition_ToStandard(vars, const, debug, o, nil)
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        Transition_ToStandard(vars, const, debug, o, nil)
        do return end
    end

    if not player or not player_arcade then     -- they'll both be nil or non nil together, but checking both just to be safe
        player_arcade = PlayerArcade:new(o, vars, const, debug)
        player = Player:new(o, vars, const, debug, player_arcade)
    end

    PossiblyStopSound(o, vars)

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        Transition_ToStandard(vars, const, debug, o, nil)
        do return end
    end

    shouldDraw = true       -- don't want a hung progress bar while in menu or driving

    startStopTracker:Tick()

    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, keys, vars, startStopTracker)
    end

    if vars.flightMode == const.flightModes.standard then
        -- Standard (walking around)
        Process_Standard(o, player, vars, const, debug, startStopTracker, deltaTime)

    elseif not o:Custom_CurrentlyFlying_Update() then       -- velocity is considered to be zero
        -- Was hanging/jumping, but another mod took over
        Transition_ToStandard(vars, const, debug, o, nil, true)

    elseif vars.flightMode == const.flightModes.hang then
        -- Hanging from a wall
        Process_Hang(o, player, vars, const, debug, keys, startStopTracker, deltaTime)

    elseif vars.flightMode == const.flightModes.jump_calculate then
        -- Figure out direction/strength to jump
        Process_Jump_Calculate(o, player, vars, const, debug)

    elseif vars.flightMode == const.flightModes.jump_teleturn then
        -- Use teleport to adjust the look direction over a few frames
        Process_Jump_TeleTurn(o, vars, const, debug, deltaTime)

    elseif vars.flightMode == const.flightModes.jump_impulse then
        -- Apply a final impulse to finish jumping the player
        Process_Jump_Impulse(o, vars, const, debug)

    else
        LogError("Unknown flightMode: " .. tostring(vars.flightMode))
        Transition_ToStandard(vars, const, debug, o, nil)
    end

    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
end)

registerHotkey("WallHang_Config", "Show Config", function()
    if shouldShowConfig then
        isConfigRepress = true      -- this is used as a request to close.  The window will only close if they are on a main screen, and not dirty
    end

    -- This only shows the config.  They need to push a close button (and possibly ok/cancel for saving)
    shouldShowConfig = true
end)
registerForEvent("onOverlayOpen", function()
    isCETOpen = true

    if not vars_ui.autoshow_withconsole then
        do return end
    end

    shouldShowConfig = true
end)
registerForEvent("onOverlayClose", function()
    isCETOpen = false

    if not vars_ui.autoshow_withconsole then
        do return end
    end

    if shouldShowConfig then
        isConfigRepress = true
    end
end)

registerInput("WallHang_CustomHang", "Hang (override default)", function(isDown)
    keys:PressedCustom_Hang(isDown)
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        do return end
    end

    if shouldShowConfig and player and player_arcade then
        local loc_shouldshow, is_minimized = DrawConfig(isConfigRepress, isConfigMinimized, vars, vars_ui, o, const, player, player_arcade)
        shouldShowConfig = loc_shouldshow
        isConfigRepress = false
        isConfigMinimized = is_minimized

        if not isCETOpen and isConfigMinimized then      -- can't just close when cet is gone, since input binding may need it showing
            shouldShowConfig = false
        end

        if not shouldShowConfig then
            -- They closed from an arbitrary window, make sure the next time config starts at main
            TransitionWindows_Main(vars_ui, const)
        end
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug, vars_ui, const)
    end
end)

------------------------- Private Methods --------------------------

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    Transition_ToStandard(vars, const, debug, o, nil)

    if o then
        o:Clear()
    end
end

--------------------------------------------------------------------

function TODO()
    -- Wall attraction stays after switching to grappling hook

    -- Crawl Cellophane
    --  Don't directly crawl on hit surfaces.  Scan an area, create some kind of bezier mesh that allows
    --  continous movement

    -- Enable double jump
    --  After they jump off a wall, reset the game's jump count so they can do a double jump
    --
    --  public class DoubleJumpDecisions extends JumpDecisions {
    --      protected const func EnterCondition(
    --          stateContext.SetPermanentIntParameter(n"currentNumberOfJumps", 0, true);
    --      ToDoubleJump
    --          if stateContext.GetIntParameter(n"currentNumberOfJumps", true) >= 2 {

    -- Double tap jump
    --  If they quickly double tap jump, then enter bullet time for a few seconds
    --  (suggested by "Let's Go! Video Games!" from youtube)

    -- Wall Run
    --  Hold in shift to enter and stay in wall run

    -- Wall Run Force
    --  Apply a force toward the wall (opposite of wall's normal)
    --  This should help the player stick to the surface of the wall
    --  The same should be done when jumping straight up the wall

    -- Jump Calculation
    --  Instead of a simple hardcoded angle adjustment and constant power...
    --  Determine what they are looking at (if they are looking away from the wall)
    --  Find a trajectory that will place them where they are looking

    -- Purchase
    --  For bare hand, require them to purchase this before it starts working
    --  Another option is to start with jump unlocked, gain experience from that before they can unlock wall hang
end