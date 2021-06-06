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
require "ui_controls/okcancel_buttons"
require "ui_controls/orderedlist"
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
require "ui_windows/main"

extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

function TODO()

    -- Hanging MapPins:
    --  See if it's because there's an autosave mid grapple

    -- XP:
    --  Gain experience when grappling
    --  Limit gain per time so people don't sit there and exploit instead of just playing
    --  Extra gain if low xp and high level
    --  See if achievements can be observed:
    --      Time spent
    --      High G
    --      Hang Time
    --      Chain of grapples

    -- AirDash:
    --  Sound

    -- Input:
    --  Give the option to register actions to this new style hotkey, if that's what they prefer
    -- registerInput('someID', 'Some input', function(isDown)
    --     if (isDown) then
    --         print(GetBind('someID')..' was pressed!')
    --     else
    --         print(GetBind('someID')..' was released!')
    --     end
    -- end)

    -- DB:
    --  Remove old rows

    -- All:
    --  Rename state to vars (needs to be done in all mods at the same time)

    -- GameObjectAccessor:
    --  Interval needs to be rand(12, +-1)
    --  needs to be done in all mods

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

end

--------------------------------------------------------------------
---                  User Preference Constants                   ---
--------------------------------------------------------------------

local const =
{
    flightModes = CreateEnum({ "standard", "aim", "airdash", "flight", "antigrav" }),

    grappleFrom_Z = 1.5,
    grappleMinResolution = 0.5,

    modNames = CreateEnum({ "grappling_hook", "jetpack", "low_flying_v" }),     -- this really doesn't need to know the other mod names, since grappling hook will override flight

    alignment_horizontal = CreateEnum({ "left", "center", "right" }),
    alignment_vertical = CreateEnum({ "top", "center", "bottom" }),

    -- When adding a new window, there is this enum and window lua file.  Also need to update init_ui.lua, drawing.lua, transition_windows.lua
    windows = CreateEnum(
    {
        "main",
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
            "grapple_swing",
    }),

    settings = CreateEnum({ "AutoShowConfig_WithConsole" }),

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

local keys = Keys:new()

local debug = {}

--TODO: Change to vars
local state =
{
    flightMode = const.flightModes.standard,
    --grapple = nil,    -- an instance of models.Grapple    -- gets populated in Transition_ToAim (back to nil in Transition_ToStandard)
    --airdash = nil,    -- an instance of models.AirDash    -- gets populated in Transition_ToAirDash (just a copy of grapple.aim_straight.air_dash)

    energy = 1000,      -- start with too much so the progress doesn't show during initial load

    --startStopTracker  -- this gets instantiated in init

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

    -- ***** See window_transitions.lua *****
    currentWindow = const.windows.main,
    transition_info = {}       -- this holds properties needed for the window (like grappleIndex for grapple_straight)

    -- ***** Each of these is a container of controls (name matches the values in windows enum) *****
    --main
    --energy_tank
    --grapple_straight
}

local player = nil       -- This holds current grapple settings, loaded from DB.  Resets to nil whenever a load is started, then recreated in first update

--------------------------------------------------------------------

registerForEvent("onInit", function()
    Observe("PlayerPuppet", "OnAction", function(action)        -- observe must be inside init and before other code
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

    InitializeKeyTrackers(state, keys, o)

    state.animation_lowEnergy = Animation_LowEnergy:new(o)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    --db:close()      -- cet fixed this in 1.12.2
end)

registerForEvent("onUpdate", function(deltaTime)
    shouldDraw = false
    if isShutdown or not isLoaded then
        Transition_ToStandard(state, const, debug, o)
        do return end
    elseif IsPlayerInAnyMenu() then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    o:Tick(deltaTime)
    state.animation_lowEnergy:Tick()


    --TODO: Detect FPS dips.  Also cap deltaTime


    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    if not player then
        player = Player:new(o, state, const, debug)
    end

    StopSound(o, state)

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    shouldDraw = true       -- don't want a hung progress bar while in menu or driving

    state.startStopTracker:Tick()

    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, keys, state)
    end

    PossiblySafetyFire(o, state, const, debug, deltaTime)

    if state.flightMode == const.flightModes.standard then
        -- Standard (walking around)
        Process_Standard(o, player, state, const, debug, deltaTime)

    elseif not CheckOtherModsFor_ContinueFlight(o, const.modNames) then
        -- Was flying, but another mod took over
        Transition_ToStandard(state, const, debug, o)

    elseif state.flightMode == const.flightModes.aim then
        -- Look for a grapple point
        Process_Aim(o, player, state, const, debug, deltaTime)

    elseif state.flightMode == const.flightModes.airdash then
        -- Didn't see a grapple point, so dashing forward
        Process_AirDash(o, player, state, const, debug, deltaTime)

    elseif state.flightMode == const.flightModes.flight then
        -- Actually grappling
        Process_Flight(o, player, state, const, debug, deltaTime)

    elseif state.flightMode == const.flightModes.antigrav then
        -- Powered flight has ended, transitioning from lower gravity to standard gravity
        Process_AntiGrav(o, player, state, const, debug, deltaTime)

    else
        print("Grappling ERROR, unknown flightMode: " .. tostring(state.flightMode))
        Transition_ToStandard(state, const, debug, o)
    end

    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
end)

registerHotkey("GrapplingHookSavePlayer", "tester hotkey", function()

    local aaa, errA = GetSetting_Bool("aaa", true)
    local bbb, errB = GetSetting_Bool("bbb", false)

    print(tostring(aaa) .. ": " .. tostring(errA))
    print(tostring(bbb) .. ": " .. tostring(errB))

    errA = SetSetting_Bool("aaa", not aaa)
    errB = SetSetting_Bool("bbb", not bbb)

    print(tostring(errA))
    print(tostring(errB))




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

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        shouldShowConfig = false
        do return end
    end

    if player and state.energy < player.energy_tank.max_energy then
        DrawEnergyProgress(state.energy, player.energy_tank.max_energy, player.experience, state)
    end

    if shouldShowConfig and player then
        shouldShowConfig = DrawConfig(isConfigRepress, vars_ui, player, const)
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