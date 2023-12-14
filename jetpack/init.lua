--https://www.lua.org/pil/contents.html
--https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
--http://lua.sqlite.org/index.cgi/doc/tip/doc/lsqlite3.wiki#numerical_error_and_result_codes

--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md
--https://github.com/ocornut/imgui/blob/b493cae8c971843886d760bb816dcab661779d69/imgui.h
--https://github.com/ocornut/imgui/blob/25fbff2156640cc79e9a79db00522019b4a0420f/imgui_draw.cpp
--https://github.com/psiberx/CyberEngineTweaks/wiki/VS-Code-Support#installation
--https://github.com/Nats-ji/CET_ImGui_lua_type_defines/blob/main/ImGui.lua

--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://redscript.redmodding.org/
--https://codeberg.org/adamsmasher/cyberpunk/src/branch/master

--https://github.com/jac3km4/redscript

require "core/animation_curve"
require "core/bezier"
require "core/bezier_segment"
require "core/color"
require "core/even_dist_cone"
require "core/gameobj_accessor"
require "core/lists"
require "core/math_basic"
require "core/math_shapes"
require "core/math_vector"
require "core/math_yaw"
require "core/rollingbuffer"
require "core/sticky_list"
require "core/strings"
require "core/util"

dal = require "data/dal"
entity_helper = require "data/entity_helper"
mode_defaults = require "data/mode_defaults"
require "data/player"
popups_util = require "data/popups_util"

require "debug/debug_code"
require "debug/reporting"

extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

require "processing/extra_dash"
require "processing/extra_hover"
require "processing/extra_pushup"
require "processing/flightutil"
require "processing/flightutil_teleport"
require "processing/processing_inflight_impulse"
require "processing/processing_inflight_teleport"
require "processing/processing_standard"
require "processing/ragdoll"
require "processing/safetyfire"

require "ui/drawing"
require "ui/init_ui"
require "ui/key_accel"
require "ui/keydash_tracker"
require "ui/keydash_tracker_analog"
require "ui/keys"
require "ui/sounds_thrusting"
require "ui/sounds_wallhit"
require "ui/transition_windows"

require "ui_controls_generic/button"
require "ui_controls_generic/checkbox"
require "ui_controls_generic/combobox"
require "ui_controls_generic/colorsample"
require "ui_controls_generic/gridview"
require "ui_controls_generic/help_button"
require "ui_controls_generic/iconbutton"
require "ui_controls_generic/label"
require "ui_controls_generic/label_clickable"
require "ui_controls_generic/listbox"
require "ui_controls_generic/multiitem_displaylist"
require "ui_controls_generic/okcancel_buttons"
require "ui_controls_generic/orderedlist"
require "ui_controls_generic/progressbar_slim"
require "ui_controls_generic/remove_button"
require "ui_controls_generic/slider"
require "ui_controls_generic/stackpanel"
require "ui_controls_generic/summary_button"
require "ui_controls_generic/textbox"
require "ui_controls_generic/updownbuttons"

require "ui_controls_jetpack/dotpow_graph"
require "ui_controls_jetpack/modelist_add"
require "ui_controls_jetpack/modelist_item"

require "ui_framework/changes"
require "ui_framework/common_definitions"
require "ui_framework/updown_delegates"
require "ui_framework/util_controls"
require "ui_framework/util_layout"
require "ui_framework/util_misc"
require "ui_framework/util_setup"

require "ui_windows/choose_mode"
require "ui_windows/main"
require "ui_windows/mode"
require "ui_windows/mode_energy"
require "ui_windows/mode_accel"
require "ui_windows/mode_extra"
require "ui_windows/mode_jumpland"
require "ui_windows/mode_mousesteer"
require "ui_windows/mode_rebound"
require "ui_windows/mode_timedilation"
require "ui_windows/popups"

local this = {}

--------------------------------------------------------------------
---                          Constants                           ---
--------------------------------------------------------------------

local const =
{
    isEnabled = true,                   -- toggled with a hotkey, stored in the database.  Since jetpack is activated by jump held down, it could interfere with other mods.  So this is a way for the user to manually toggle it

    maxSpeed = 432,                     -- player:GetVelocity() isn't the same as the car's reported speed, it's about 4 times slower.  So 100 would be roughly car speed of 400

    rightstick_sensitivity = 50,        -- the mouse x seems to be yaw/second (in degrees).  The controller's right thumbstick is -1 to 1.  So this multiplier will convert into yaw/second.  NOTE: the game speeds it up if they hold it for a while, but this doesn't do that

    hide_energy_above_percent = 0.985,  -- For the infinite energy modes (well rounded, airplane), the progress bar is just annoying

    thrust_sound_type = CreateEnum("steam", "steam_quiet", "levitate", "jump", "silent"),

    extra_type = CreateEnum("hover", "pushup", "dash"),       --TODO: drop item, all stop

    windows = CreateEnum
    (
        "main",
            "mode",
                "mode_accel",
                "mode_energy",
                "mode_extra",
                "mode_jumpland",
                "mode_mousesteer",
                "mode_rebound",
                "mode_timedilation",
            "choose_mode",
            "popups"
    ),

    -- These are for the main window to know what button was pushed
    modelist_actions = CreateEnum("move_up", "move_down", "delete", "clone", "edit"),

    ui_dirty_epsilon = 0.009,

    settings = CreateEnum(
        -- Bools
        "IsEnabled",
        -- Ints
        "Mode"),

    shouldShowDebugWindow = false,      -- shows a window with extra debug info
}

--------------------------------------------------------------------
---              Current State (leave these alone)               ---
--------------------------------------------------------------------

local isShutdown = true
local isLoaded = false
local shouldDraw = false
local shouldShowConfig = false
local isCETOpen = false
local isConfigMinimized = false

local o     -- This is a class that wraps access to Game.xxx

local keys      -- = Keys:new()        -- moved to init

local debug = {}

local vars =
{
    isInFlight = false,

    --thrust,           -- these are created in init
    --horz_analog

    --vel = Vector4.new(0, 0, 0, 1),        -- moved this to init (Vector4 isn't available before init)
    startThrustTime = 0,
    lastThrustTime = 0,

    --remainBurnTime = player.mode.energy.maxBurnTime,        -- moved to player constructor (in update event)

    --stop_flight_time              -- gets populated in ExitFlight
    --stop_flight_velocity

    --last_rebound_time
    should_rebound_impulse = false,

    showConfigNameUntil = 0,

    --sound_current = nil,      -- can't store nil in a table, because it just goes away.  But non nil will use this name.  Keeping it simple, only allowing one sound at a time.  If multiple are needed, use StickyList
    sound_started = 0,

    --sounds_thrusting = SoundsThrusting:new(),      -- moved to init

    --cur_timeDilation             -- used when setting the timeDilation (especially when it's a gradient)

    --toggled_enabled,           -- this is a flag to tell the draw function to say enabled/disabled for a couple seconds
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
}

local vars_ui_progressbar =
{
    scale = 1,
}

local vars_ui_configname =
{
    scale = 1,
}

local player = nil
local popups = nil

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
    dal.EnsureTablesCreated()
    Define_UI_Framework_Constants(const)
    InitializeUI(vars_ui, vars_ui_progressbar, vars_ui_configname, const)       --NOTE: This must be done after db is initialized.  TODO: listen for video settings changing and call this again (it stores the current screen resolution)
    popups = popups_util.Load()

    keys = Keys:new(debug, const)

    vars.vel = Vector4.new(0, 0, 0, 1)

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
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    function wrappers.GetTimeSystem() return Game.GetTimeSystem() end
    function wrappers.SetTimeDilation(timesystem, reason, speed) timesystem:SetTimeDilation(reason, speed) end
    function wrappers.SetTimeDilationOnLocalPlayerZero(timesystem, reason, player_mult) timesystem:SetTimeDilationOnLocalPlayerZero(reason, player_mult) end
    function wrappers.UnsetTimeDilation(timesystem, reason) timesystem:UnsetTimeDilation(reason, "None") end
    function wrappers.UnsetTimeDilationOnLocalPlayerZero(timesystem, reason) timesystem:UnsetTimeDilationOnLocalPlayerZero(reason, "None") end
    function wrappers.GetTransactionSystem() return Game.GetTransactionSystem() end
    function wrappers.GetItemInSlot(transaction, player, slotID) transaction:GetItemInSlot(player, slotID) end
    function wrappers.GetStatsSystem() return Game.GetStatsSystem() end
    function wrappers.AddModifier(stats, entityID, modifierData) stats:AddModifier(entityID, modifierData) end
    function wrappers.GetSpatialQueriesSystem() return Game.GetSpatialQueriesSystem() end
    function wrappers.GetTargetingSystem() return Game.GetTargetingSystem() end     -- gametargetingTargetingSystem
    function wrappers.GetTargetParts(targetting, player, searchQuery) return targetting:GetTargetParts(player, searchQuery) end
    function wrappers.GetQuestsSystem() return Game.GetQuestsSystem() end
    function wrappers.GetQuestFactStr(quest, key) return quest:GetFactStr(key) end
    function wrappers.SetQuestFactStr(quest, key, id) quest:SetFactStr(key, id) end       -- id must be an integer
    function wrappers.GetDelaySystem() return Game.GetDelaySystem() end
    function wrappers.DelayEventNextFrame(delay, entity, event) delay:DelayEventNextFrame(entity, event) end

    o = GameObjectAccessor:new(wrappers)

    vars.thrust = KeyDashTracker:new(o, keys, "jump", "prev_jump")
    vars.horz_analog = KeyDashTracker_Analog:new(o, keys, debug)

    vars.sounds_thrusting = SoundsThrusting:new(o, keys, vars.horz_analog, const)

    const.isEnabled = dal.GetSetting_Bool(const.settings.IsEnabled, true)

    TransitionWindows_Main(vars_ui, const)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    --db:close()      -- cet fixed this in 1.12.2
    this.ClearObjects()
end)

registerForEvent("onUpdate", function(deltaTime)
    shouldDraw = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        ExitFlight(vars, debug, o, player)
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        ExitFlight(vars, debug, o, player)
        do return end
    end

    if not player then
        player = Player:new(o, vars, const, debug)
    end

    PossiblyStopSound(o, vars)

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        ExitFlight(vars, debug, o, player)
        do return end
    end

    shouldDraw = true       -- don't want a stopped progress bar while in menu or driving

    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, keys, vars)
    end

    -- Cycle Config
    if keys.cycleModes then
        keys.cycleModes = false
        player:NextMode()

        ExitFlight(vars, debug, o, player)
    end

    vars.thrust:Tick()     -- this is needed for flight and non flight

    if vars.isInFlight then
        -- In Flight
        if not player.mode then
            ExitFlight(vars, debug, o, player)      -- should never get here, unless they pulled up cet and deleted modes mid flight

        elseif not o:Custom_CurrentlyFlying_Update(GetVelocity(player.mode, vars, o)) then
            ExitFlight(vars, debug, o, player)

        elseif player.mode.useImpulse then
            Process_InFlight_Impulse(o, vars, const, player, keys, debug, deltaTime)

        else
            Process_InFlight_Teleport(o, vars, const, player, keys, debug, deltaTime)
        end
    else
        -- Standard (walking around)
        Process_Standard(o, vars, player, const, debug, deltaTime)
    end

    vars.sounds_thrusting:Tick(vars.isInFlight)

    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
end)

registerHotkey("jetpackCycleModes", "Cycle Modes", function()
    keys.cycleModes = true
end)

registerHotkey("jetpackEnableDisable", "Enable/Disable", function()
    const.isEnabled = not const.isEnabled
    dal.SetSetting_Bool(const.settings.IsEnabled, const.isEnabled)

    vars.toggled_enabled = o.timer

    if not const.isEnabled then
        ExitFlight(vars, debug, o, player)
    end
end)

registerInput("jetpackExtra1", "Extra Key 1", function(isDown)
    keys.extra1 = isDown
end)
registerInput("jetpackExtra2", "Extra Key 2", function(isDown)
    keys.extra2 = isDown
end)

registerForEvent("onOverlayOpen", function()
    isCETOpen = true
    shouldShowConfig = true
end)
registerForEvent("onOverlayClose", function()
    isCETOpen = false
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        shouldShowConfig = false
        do return end
    end

    if player then
        -- Energy tank (only show when it's not full)
        if player.mode and popups.energy_visible and vars.remainBurnTime / player.mode.energy.maxBurnTime < math.min(popups.energy_visible_under_percent, const.hide_energy_above_percent) then
            DrawJetpackProgress(player.mode.name, vars.remainBurnTime, player.mode.energy.maxBurnTime, vars_ui_progressbar, popups, const)
        end

        -- Config Name
        if vars.showConfigNameUntil > o.timer then
            DrawConfigName(player.mode, vars_ui_configname, popups, const)
        end
    end

    if vars.toggled_enabled and o.timer - vars.toggled_enabled < 2 then
        DrawEnabledDisabled(const.isEnabled)
    end

    if shouldShowConfig and player then
        local loc_shouldshow, is_minimized = DrawConfig(not isCETOpen, isConfigMinimized, vars, vars_ui, player, popups, o, const)
        shouldShowConfig = loc_shouldshow
        isConfigMinimized = is_minimized

        if not isCETOpen and isConfigMinimized then      -- can't just close when cet is gone, one of the windows could be in a dirty state
            shouldShowConfig = false
        end

        if not shouldShowConfig then
            -- They closed from an arbitrary window, make sure the next time config starts at main
            TransitionWindows_Main(vars_ui, const)
        end
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug)
    end
end)

------------------------------------ Private Methods ----------------------------------

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    ExitFlight(vars, debug, o, player)
    TransitionWindows_Main(vars_ui, const)

    player = nil

    if o then
        o:Clear()
    end
end