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
require "core/customprops_wrapper"
require "core/debug_code"
require "core/gameobj_accessor"
require "core/math_basic"
require "core/math_raycast"
require "core/math_vector"
require "core/math_yaw"
require "core/util"

require "data/dal"
require "data/dal_tests"
require "data/datautil"
require "data/defaults"
require "data/player"
--require "data/serialization"      -- using json instead.  Keeping this around in case there is something that needs the more direct way of encoding

require "processing/flightmode_transitions"
require "processing/flightutil"
require "processing/processing_aim"
require "processing/processing_airdash"
require "processing/processing_antigrav"
require "processing/processing_flight"
require "processing/processing_standard"
require "processing/safetyfire"
require "processing/xp_gain"

require "ui/animation_lowEnergy"
require "ui/changes"
require "ui/common_definitions"
require "ui/drawing"
require "ui/init_ui"
require "ui/inputtracker_startstop"
require "ui/keys"
require "ui/mappinutil"
require "ui/reporting"
require "ui/transition_windows"
require "ui/util_controls"
require "ui/util_ui"

require "ui_controls/checkbox"
require "ui_controls/grapple_arrows"
require "ui_controls/grapple_desired_len_accel"
require "ui_controls/help_button"
require "ui_controls/label"
require "ui_controls/label_clickable"
require "ui_controls/mindot_graphic"
require "ui_controls/multiitem_displaylist"
require "ui_controls/okcancel_buttons"
require "ui_controls/orderedlist"
require "ui_controls/progressbar_slim"
require "ui_controls/remove_button"
require "ui_controls/slider"
require "ui_controls/stickfigure"
require "ui_controls/summary_button"
require "ui_controls/textbox"
require "ui_controls/updownbuttons"

require "ui_windows/energytank"
require "ui_windows/grapple_choose"
require "ui_windows/grapple_straight"
require "ui_windows/grapple_straight_accelalong"
require "ui_windows/grapple_straight_accellook"
require "ui_windows/grapple_straight_aimduration"
require "ui_windows/grapple_straight_airdash"
require "ui_windows/grapple_straight_antigrav"
require "ui_windows/grapple_straight_description"
require "ui_windows/grapple_straight_distances"
require "ui_windows/grapple_straight_stopearly"
require "ui_windows/grapple_straight_velaway"
require "ui_windows/input_bindings"
require "ui_windows/main"

extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

function TODO()

    -- Hanging MapPins:
    --  See if it's because there's an autosave mid grapple
    --
    -- NonameNonumber — Today at 6:48 PM
    -- mappin system should be still available
    -- I do similar thing in that demo:
    -- https://github.com/WolvenKit/cet-examples/blob/main/ai-components/init.lua#L130
    -- TargetingHelper.Dispose() destroys pins

    -- Sound:
    --  airdash
	--	grapple
	--
	--	names containing monowire, whip, nano

    -- Input:
    --  Give the option to register actions to this new style hotkey, if that's what they prefer
    -- registerInput('someID', 'Some input', function(isDown)
    --     if (isDown) then
    --         print(GetBind('someID')..' was pressed!')
    --     else
    --         print(GetBind('someID')..' was released!')
    --     end
    -- end)

    -- Grapple Straight:
    --  Have an option for the anchor to be higher than the hit point
    --  This will help get over ledges when the grapple distance isn't enough to get fast enough

    -- All:
    --  Fall damage should be a percent, not a bool

    -- Pull:
    --  May need further ray casts along the initial line segment if it was beyond 50 (a collision hull could load in as the player gets closer)

    -- Pull:
    --  If grapple point is a person (determined in aim), ragdoll them toward you
    --  GET OVER HERE!!!

    -- Grapple Straight:
    --  Add a repulsion to walls when > some distance from desired distance
    --  This would be helpful with going straight up walls

    -- Grapple Straight:
    --  Add an ability to jump straight away from a wall when at the desired distance (and close to a wall)
    --  This will help with scaling tall walls.  You grapple straight up, reach the anchor, recover energy,
    --  jump and aquire a new grapple point, repeat

    -- Grapple Straight/Swing:
    --  Add extra weight when carrying a dead body

    -- Energy Tank:
    --  Drawn Weapon Cost %
    --
    --  Grapple costs more When a weapon is drawn (don't do this for fists or cyberarms):
    --      knife   10%
    --      sword   30%
    --      pistol  30%
    --      smg     60%
    --      rifle   80%
    --      shotgun 80%
    --      sniper  150%

    -- Energy Tank:
    --  Drawn Weapon Reduction % (5 to 95)
    --  This is exposed in the config screen as a way to counter the above cost

    -- UI:
    --  Unhook grapple
    --  New/Load grapple

    -- UI:
    --  Add invisible buttons to several controls, highlight graphics based on hover

    -- UI:
    --  Only allow config changes within a small radius of vendors: ripper doc, clothing, melee, ranged
    --  Still allow them to look at values, just not change
    --  Add a note when out of range

    -- UI:
    --  Controls are placed at absolute positions.  Create some container panel controls, like horizontal list,
    --  vertical list (that may also support scrollbars)
    --
    --  Control's draw methods do both size calculations and drawing.  Split that up.  That way the panel can
    --  get all the child control's sizes, do some final calculations based on sizes and margins, then pass
    --  in the location to each control's draw function (could also pass in a final width/height for controls
    --  that should stretch)

    -- UI:
    --  There's a lot of copy/pasted code.  A lot of it is around binding between model and viewmodel.  Look
    --  for patterns and create a binding util

    -- UI:
    --  All numbers should be presented as dozenal :)
    --  tostring_doz()
    --  Round_doz()     -- this is needed, because rounding fractions to a certain number of digits would have to be converted, then truncated
    --  also, if there's ever a textbox, that would need to be parsed as well

    -- ViewModels:
    --  The properties that change should have set instead of init

end

local this = {}

--------------------------------------------------------------------
---                  User Preference Constants                   ---
--------------------------------------------------------------------

local const =
{
    flightModes = CreateEnum("standard", "aim", "airdash", "flight", "antigrav"),

    grappleFrom_Z = 1.5,
    grappleMinResolution = 0.5,

    modNames = CreateEnum("grappling_hook", "jetpack", "low_flying_v"),     -- this really doesn't need to know the other mod names, since grappling hook will override flight

    alignment_horizontal = CreateEnum("left", "center", "right"),
    alignment_vertical = CreateEnum("top", "center", "bottom"),

    -- When adding a new window, there is this enum and window lua file.  Also need to update init_ui.lua, drawing.lua, transition_windows.lua
    windows = CreateEnum
    (
        "main",
            "input_bindings",
            "energy_tank",
            "grapple_choose",
            "grapple_straight",
                "grapple_straight_accelalong",
                "grapple_straight_accellook",
                "grapple_straight_aimduration",
                "grapple_straight_airdash",
                "grapple_straight_antigrav",
                "grapple_straight_description",
                "grapple_straight_distances",
                "grapple_straight_stopearly",
                "grapple_straight_velaway",
            "grapple_swing"
    ),

    bindings = CreateEnum("grapple1", "grapple2", "grapple3", "grapple4", "grapple5", "grapple6", "stop"),

    settings = CreateEnum("AutoShowConfig_WithConsole"),

    customKeyBase = "Grapple_Custom_",

    shouldShowDebugWindow = false,      -- shows a window with extra debug info
}

--------------------------------------------------------------------
---              Current State (leave these alone)               ---
--------------------------------------------------------------------

local isShutdown = true
local isLoaded = false
local shouldDraw = false
local shouldShowConfig = false
local isConfigRepress = false

local o     -- This is a class that wraps access to Game.xxx

local keys = nil -- = Keys:new()        -- moved to init

local debug = {}

local vars =
{
    flightMode = const.flightModes.standard,
    --grapple = nil,    -- an instance of models.Grapple    -- gets populated in Transition_ToAim (back to nil in Transition_ToStandard)
    --airdash = nil,    -- an instance of models.AirDash    -- gets populated in Transition_ToAirDash (just a copy of grapple.aim_straight.air_dash)

    energy = 1000,      -- start with too much so the progress doesn't show during initial load

    --startStopTracker  -- this gets instantiated in init (InitializeKeyTrackers)

    --xp_gain,          -- this is a class that gets told when grapple events occur, gains xp, periodically updates player and saves

    --startTime         -- gets populated when transitioning into a new flight mode (into aim, into flight, etc) ---- doesn't get set when transitioning to standard

    --rayFrom           -- gets populated when transitioning to airdash or flight
    --rayHit            -- gets populated when transitioning to flight
    --rayLength         -- gets populated when transitioning to airdash
    --distToHit         -- len(rayHit-rayFrom)    populated when transitioning to flight

    --hasBeenAirborne   -- set to false when transitioning to flight or air dash.  Used by air dash and flight (if flight has a desired length)
    --initialAirborneTime

    --mappinID          -- this will be populated while the map pin is visible (managed in mappinutil.lua)
    --mappinName        -- this is the name of the map pin that is currently visible (managed in mappinutil.lua)

    --NOTE: These sound props are only used for sounds that should be one at a time.  There can
    --      be other sounds that are managed elsewhere
    --sound_current = nil,  -- can't store nil in a table, because it just goes away.  But non nil will use this name.  Keeping it simple, only allowing one sound at a time.  If multiple are needed, use StickyList
    sound_started = 0,

    --animation_lowEnergy   -- instantiated in init.  Triggered when they try to fire a grapple, but don't have enough energy

    isSafetyFireCandidate = false,      -- this will turn true when grapple is used.  Goes back to false after they touch the ground
}

local vars_ui =
{
    --screen    -- info about the current screen resolution -- see GetScreenInfo()
    --style     -- this gets loaded from json during init
    --mainWindow    -- info about the location of the main window (top/left gets stored in a table if they move it) -- see Define_MainWindow()
    --line_heights  -- the height of strings -- see Refresh_LineHeights()

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

local xp_gain = nil     -- this gets called each tick, watching the player's activity.  It will slowly accumulate grapple experience, periodically add xp to player, save to db

local player = nil      -- This holds current grapple settings, loaded from DB.  Resets to nil whenever a load is started, then recreated in first update

--------------------------------------------------------------------

registerForEvent("onInit", function()
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
    EnsureTablesCreated()
    InitializeUI(vars_ui, const)       --NOTE: This must be done after db is initialized.  TODO: listen for video settings changing and call this again (it stores the current screen resolution)

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
    function wrappers.RayCast(player, from, to, staticOnly) return player:GrapplingHook_RayCast(from, to, staticOnly) end
    function wrappers.SetTimeDilation(timeSpeed) Game.SetTimeDilation(tostring(timeSpeed)) end      -- for some reason, it takes in string
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    function wrappers.Custom_CurrentlyFlying_get(player) return Custom_CurrentlyFlying_get(player) end
    function wrappers.Custom_CurrentlyFlying_StartFlight(player) Custom_CurrentlyFlying_StartFlight(player, const.modNames) end
    function wrappers.Custom_CurrentlyFlying_Clear(player) Custom_CurrentlyFlying_Clear(player, const.modNames) end
    function wrappers.QueueSound(player, sound) player:GrapplingHook_QueueSound(sound) end
    function wrappers.StopQueuedSound(player, sound) player:GrapplingHook_StopQueuedSound(sound) end
    function wrappers.GetMapPinSystem() return Game.GetMappinSystem() end
    function wrappers.RegisterMapPin(mapPin, data, pos) return mapPin:RegisterMappin(data, pos) end
    function wrappers.SetMapPinPosition(mapPin, id, pos) mapPin:SetMappinPosition(id, pos) end
    function wrappers.ChangeMappinVariant(mapPin, id, variant) mapPin:ChangeMappinVariant(id, variant) end
    function wrappers.UnregisterMapPin(mapPin, id) mapPin:UnregisterMappin(id) end
    function wrappers.GetQuestsSystem() return Game.GetQuestsSystem() end
    function wrappers.GetQuestFactStr(quest, key) return quest:GetFactStr(key) end
    function wrappers.SetQuestFactStr(quest, key, id) quest:SetFactStr(key, id) end       -- id must be an integer

    o = GameObjectAccessor:new(wrappers)

    keys = Keys:new(o)

    vars_ui.keys = keys

    InitializeKeyTrackers(vars, keys, o, const)

    xp_gain = XPGain:new(o, vars, debug, const)

    vars.animation_lowEnergy = Animation_LowEnergy:new(o)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    --db:close()      -- cet fixed this in 1.12.2
    this.ClearObjects()
end)

registerForEvent("onUpdate", function(deltaTime)
    shouldDraw = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    o:Tick(deltaTime)
    vars.animation_lowEnergy:Tick()

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    if not player then
        player = Player:new(o, vars, const, debug)
        xp_gain:PlayerCreated(player)
    end

    StopSound(o, vars)

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    shouldDraw = true       -- don't want a hung progress bar while in menu or driving

    vars.startStopTracker:Tick()

    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, keys, vars)
    end

    PossiblySafetyFire(o, vars, const, debug, deltaTime)

    if vars.flightMode == const.flightModes.standard then
        -- Standard (walking around)
        Process_Standard(o, player, vars, const, debug, deltaTime)

    elseif not CheckOtherModsFor_ContinueFlight(o, const.modNames) then
        -- Was flying, but another mod took over
        Transition_ToStandard(vars, const, debug, o)

    elseif vars.flightMode == const.flightModes.aim then
        -- Look for a grapple point
        Process_Aim(o, player, vars, const, debug, deltaTime)

    elseif vars.flightMode == const.flightModes.airdash then
        -- Didn't see a grapple point, so dashing forward
        Process_AirDash(o, player, vars, const, debug, deltaTime)

    elseif vars.flightMode == const.flightModes.flight then
        -- Actually grappling
        Process_Flight(o, player, vars, const, debug, deltaTime)

    elseif vars.flightMode == const.flightModes.antigrav then
        -- Powered flight has ended, transitioning from lower gravity to standard gravity
        Process_AntiGrav(o, player, vars, const, debug, deltaTime)

    else
        print("Grappling ERROR, unknown flightMode: " .. tostring(vars.flightMode))
        Transition_ToStandard(vars, const, debug, o)
    end

    xp_gain:Tick(deltaTime)     --NOTE: This will potentially add xp to player and call save
    debug.xp = Round(xp_gain.experience, 4)

    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
end)

registerHotkey("GrapplingHookTesterButton", "tester hotkey", function()

    --DeleteOldPlayerRows(player.playerID)

    --ReduceGrappleRows()


    -- for i = 1, 30 do
    --     --player.experience = player.experience + (1 / 12)
    --     player.grapple1.experience = math.random(12, 144)
    --     player.grapple2.experience = math.random(12, 144)
    --     player:Save()
    -- end


    -- player.experience = player.experience + 3
    -- player:Save()
end)

registerHotkey("GrapplingHookConfig", "Show Config", function()
    if shouldShowConfig then
        isConfigRepress = true      -- this is used as a request to close.  The window will only close if they are on a main screen, and not dirty
    end

    -- This only shows the config.  They need to push a close button (and possibly ok/cancel for saving)
    shouldShowConfig = true
end)
registerForEvent("onOverlayOpen", function()
    if not vars_ui.autoshow_withconsole then
        do return end
    end

    shouldShowConfig = true
end)
registerForEvent("onOverlayClose", function()
    if not vars_ui.autoshow_withconsole then
        do return end
    end

    if shouldShowConfig then
        isConfigRepress = true
    end
end)

-- These let the user bind any key or combination of keys.  The final bindings tied to specific grapple
-- actions are mapped in input_bindings.lua (and may not even use any of these, these are optional,
-- giving more flexibility)
--
-- Using A-G so people don't assume that these automatically directly tie to grapple 1-6
--
-- This has real trouble with binding to the asdw keys (didn't try jump).  Also, when bound to something
-- like w+d, the 2nd binding to a+d causes the w+d to unregister
registerInput("GrapplingHook_KeyA", "Custom Key A", function(isDown)
    keys:MapCustomKey(const.customKeyBase .. "A", isDown)
end)
registerInput("GrapplingHook_KeyB", "Custom Key B", function(isDown)
    keys:MapCustomKey(const.customKeyBase .. "B", isDown)
end)
registerInput("GrapplingHook_KeyC", "Custom Key C", function(isDown)
    keys:MapCustomKey(const.customKeyBase .. "C", isDown)
end)
registerInput("GrapplingHook_KeyD", "Custom Key D", function(isDown)
    keys:MapCustomKey(const.customKeyBase .. "D", isDown)
end)
registerInput("GrapplingHook_KeyE", "Custom Key E", function(isDown)
    keys:MapCustomKey(const.customKeyBase .. "E", isDown)
end)
registerInput("GrapplingHook_KeyF", "Custom Key F", function(isDown)
    keys:MapCustomKey(const.customKeyBase .. "F", isDown)
end)
registerInput("GrapplingHook_KeyG", "Custom Key G", function(isDown)
    keys:MapCustomKey(const.customKeyBase .. "G", isDown)
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        shouldShowConfig = false
        do return end
    end

    if player and vars.energy < player.energy_tank.max_energy then
        DrawEnergyProgress(vars.energy, player.energy_tank.max_energy, player.experience, vars)
    end

    if shouldShowConfig and player then
        shouldShowConfig = DrawConfig(isConfigRepress, vars, vars_ui, player, const)
        isConfigRepress = false

        if not shouldShowConfig then
            -- They closed from an arbitrary window, make sure the next time config starts at main
            TransitionWindows_Main(vars_ui, const)
        end
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug)
    end
end)

------------------------------------ Private Methods -----------------------------------

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    Transition_ToStandard(vars, const, debug, o)
    TransitionWindows_Main(vars_ui, const)

    player = nil

    if o then
        o:Clear()
    end

    if xp_gain then
        xp_gain:Clear()
    end
end