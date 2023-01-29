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
require "core/debug_code"
require "core/debug_render_logger"
require "core/even_dist_cone"
require "core/gameobj_accessor"
require "core/lists"
require "core/math_basic"
require "core/math_vector"
require "core/math_yaw"
require "core/strings"
require "core/util"

require "data/dal"
require "data/dal_tests"
require "data/datautil"
require "data/defaults"
require "data/player"
--require "data/serialization"      -- using json instead.  Keeping this around in case there is something that needs the more direct way of encoding
require "data/util_data"

require "inventory/util_inventory"

require "processing/flightmode_transitions"
require "processing/flightutil"
require "processing/processing_aim"
require "processing/processing_airdash"
require "processing/processing_antigrav"
require "processing/processing_flight_straight"
require "processing/processing_flight_swing"
require "processing/processing_standard"
require "processing/safetyfire"
require "processing/xp_gain"

require "ui/animation_lowEnergy"
require "ui/common_definitions"
require "ui/drawing"
require "ui/init_ui"
require "ui/inputtracker_startstop"
require "ui/keys"
require "ui/mappinutil"
require "ui/reporting"
require "ui/transition_windows"
require "ui/util_ui"
require "ui/util_vm_binding"

require "ui_controls_generic/button"
require "ui_controls_generic/checkbox"
require "ui_controls_generic/gridview"
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

require "ui_controls_grapple/grapple_arrows"
require "ui_controls_grapple/grapple_desired_len_accel"
require "ui_controls_grapple/mindot_graphic"
require "ui_controls_grapple/stickfigure"

require "ui_framework/changes"
require "ui_framework/common_definitions"
require "ui_framework/updown_delegates"
require "ui_framework/util_controls"
require "ui_framework/util_layout"
require "ui_framework/util_misc"
require "ui_framework/util_setup"

require "ui_windows/energytank"
require "ui_windows/grapple_choose"
require "ui_windows/grapple_straight"
require "ui_windows/grapple_straight_accelalong"
require "ui_windows/grapple_straight_accellook"
require "ui_windows/grapple_straight_aimduration"
--require "ui_windows/grapple_straight_airdash"     -- no longer used
require "ui_windows/grapple_straight_airanchor"
require "ui_windows/grapple_straight_antigrav"
require "ui_windows/grapple_straight_description"
require "ui_windows/grapple_straight_distances"
require "ui_windows/grapple_straight_stopearly"
require "ui_windows/grapple_straight_velaway"
require "ui_windows/input_bindings"
require "ui_windows/main"

extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

local this = {}

--------------------------------------------------------------------
---                          Constants                           ---
--------------------------------------------------------------------

local const =
{
    flightModes = CreateEnum("standard", "aim", "airdash", "flight_straight", "flight_swing", "antigrav"),

    grappleFrom_Z = 1.85,

    -- These are set in Define_UI_Framework_Constants() called during init
    -- alignment_horizontal = CreateEnum("left", "center", "right"),
    -- alignment_vertical = CreateEnum("top", "center", "bottom"),

    -- When adding a new window, there is this enum and window lua file.  Also need to update drawing.lua, transition_windows.lua
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
                "grapple_straight_airanchor",
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

    unlockType = CreateEnum("shotgun", "knife", "silencer", "grenade", "clothes", "money"),

    customKeyBase = "Grapple_Custom_",

    shouldShowDebugWindow = false,      -- shows a window with extra debug info
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

local debug = {}

local vars =
{
    flightMode = const.flightModes.standard,
    --grapple = nil,    -- an instance of models.Grapple    -- gets populated in Transition_ToAim (back to nil in Transition_ToStandard)
    --airdash = nil,    -- an instance of models.AirDash    -- gets populated in Transition_ToAirDash (just a copy of grapple.aim_straight.air_dash)
    --airanchor = nil,  -- an instance of models.AirAnchor  -- gets populated in Transition_ToFlight_Straight (back to nil in Transition_ToStandard)

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

local vars_ui_progressbar =
{
    scale = 1,
}

local xp_gain = nil     -- this gets called each tick, watching the player's activity.  It will slowly accumulate grapple experience, periodically add xp to player, save to db

local player = nil      -- This holds current grapple settings, loaded from DB.  Resets to nil whenever a load is started, then recreated in first update

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
    EnsureTablesCreated()
    Define_UI_Framework_Constants(const)
    InitializeUI(vars_ui, vars_ui_progressbar, const)       --NOTE: This must be done after db is initialized.  TODO: listen for video settings changing and call this again (it stores the current screen resolution)

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
    function wrappers.GetMapPinSystem() return Game.GetMappinSystem() end
    function wrappers.RegisterMapPin(mapPin, data, pos) return mapPin:RegisterMappin(data, pos) end
    function wrappers.SetMapPinPosition(mapPin, id, pos) mapPin:SetMappinPosition(id, pos) end
    function wrappers.ChangeMappinVariant(mapPin, id, variant) mapPin:ChangeMappinVariant(id, variant) end
    function wrappers.UnregisterMapPin(mapPin, id) mapPin:UnregisterMappin(id) end
    function wrappers.GetQuestsSystem() return Game.GetQuestsSystem() end
    function wrappers.GetQuestFactStr(quest, key) return quest:GetFactStr(key) end
    function wrappers.SetQuestFactStr(quest, key, id) quest:SetFactStr(key, id) end       -- id must be an integer
    function wrappers.GetTransactionSystem() return Game.GetTransactionSystem() end
    function wrappers.GetGetItemList(transaction, player) return transaction:GetItemList(player) end
    function wrappers.GetEquipmentSystem() return Game.GetScriptableSystemsContainer():Get("EquipmentSystem") end
    function wrappers.IsItemEquipped(equipment, player, item) return equipment:IsEquipped(player, item:GetID()) end
    function wrappers.GetSpatialQueriesSystem() return Game.GetSpatialQueriesSystem() end
    function wrappers.GetTargetingSystem() return Game.GetTargetingSystem() end

    o = GameObjectAccessor:new(wrappers)

    keys = Keys:new(o)
    vars_ui.keys = keys

    InitializeKeyTrackers(vars, keys, o, const)

    xp_gain = XPGain:new(o, vars, debug, const)

    vars.animation_lowEnergy = Animation_LowEnergy:new(o)

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

    PossiblyStopSound(o, vars)

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

    elseif not o:Custom_CurrentlyFlying_Update(o.vel) then     -- there is not teleport in grappling hook, so standard velocity is correct
        -- Was flying, but another mod took over
        Transition_ToStandard(vars, const, debug, o)

    elseif vars.flightMode == const.flightModes.aim then
        -- Look for a grapple point
        Process_Aim(o, player, vars, const, debug, deltaTime)

    elseif vars.flightMode == const.flightModes.airdash then
        -- Didn't see a grapple point, so dashing forward
        Process_AirDash(o, player, vars, const, debug, deltaTime)

    elseif vars.flightMode == const.flightModes.flight_straight then
        -- Grappling in a straight line
        Process_Flight_Straight(o, player, vars, const, debug, deltaTime)

    elseif vars.flightMode == const.flightModes.flight_swing then
        -- Web Swinging
        Process_Flight_Swing(o, player, vars, const, debug, deltaTime)

    elseif vars.flightMode == const.flightModes.antigrav then
        -- Powered flight has ended, transitioning from lower gravity to standard gravity
        Process_AntiGrav(o, player, vars, const, debug, deltaTime)

    else
        LogError("Unknown flightMode: " .. tostring(vars.flightMode))
        Transition_ToStandard(vars, const, debug, o)
    end

    xp_gain:Tick(deltaTime)     --NOTE: This will potentially add xp to player and call save
    debug.xp = Round(xp_gain.experience, 4)

    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
end)

-- registerHotkey("GrapplingHookTesterButton", "tester hotkey", function()
-- end)

registerHotkey("GrapplingHookConfig", "Show Config", function()
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

registerHotkey("GrapplingHookCheatXP", "Instant XP (cheat)", function()
    player.experience = player.experience + 3

    -- The act of giving xp unlocks energy tank (player.isUnlocked is in memory only, no db), so make
    -- sure there is an energy tank
    player.isUnlocked = true

    if not player.energy_tank then
        player.energy_tank = GetDefault_EnergyTank()
    end

    player:Save()
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



-- registerHotkey("GrapplingHookConeCast_Points", "Cone Cast (points)", function()
--     local log_build = DebugRenderLogger:new(true)
--     local log_final = DebugRenderLogger:new(true)

--     local axis = Vector4.new(1, 0, 0, 1)

--     local points = GetConePointsEvenDistribution(144, axis, 45, 0, 12, 12, log_build)

--     log_final:Add_Line(Vector4.new(0, 0, 0, 1), MultiplyVector(axis, 12))

--     for i = 1, #points do
--         log_final:Add_Dot(points[i])
--     end

--     log_build:Save("build")
--     log_final:Save("final")
-- end)

-- registerHotkey("GrapplingHookConeCast_Rays", "Cone Cast (rays)", function()
--     local axis = Vector4.new(1, 0, 0, 1)

--     local log = DebugRenderLogger:new(true)
--     log:Add_Line(Vector4.new(0, 0, 0, 1), MultiplyVector(axis, 12))


--     --TODO: Play with stronger min dist


--     -- Ray From
--     local points_from = GetConePointsEvenDistribution(12, axis, 45, 0, 12, 4)

--     for i = 1, #points_from do
--         -- Ray To
--         local points_to = GetConePointsEvenDistribution(3, axis, 45, 12, 12, 6)

--         for j = 1, #points_to do
--             points_to[j] = AddVectors(points_from[i], points_to[j])

--             log:Add_Dot(points_from[i])
--             log:Add_Line(points_from[i], points_to[j])

--             local hit_pos, hit_normal, hit_material = o:RayCast(points_from[i], points_to[j])

--             if hit_pos then
--                 log:Add_Dot(hit_pos, nil, "6E6", 3, hit_material)
--                 log:Add_Line(hit_pos, AddVectors(hit_pos, hit_normal), nil, "6E6", 1, hit_material)
--             end
--         end
--     end

--     log:Save("rays")
-- end)



registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        shouldShowConfig = false
        do return end
    end

    if player and player.energy_tank and vars.energy < player.energy_tank.max_energy then
        DrawEnergyProgress(vars.energy, player.energy_tank.max_energy, player.experience, vars, vars_ui_progressbar, const)
    end

    if shouldShowConfig and player then
        local loc_shouldshow, is_minimized = DrawConfig(isConfigRepress, isConfigMinimized, vars, vars_ui, player, o, const)
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

----------------------------------- Private Methods -----------------------------------

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

---------------------------------------------------------------------------------------

function TODO()

    -- Clear on Start:
    --  Call GameObjectAccessor:Custom_CurrentlyFlying_Clear() from init in case there was a crash during uninterupptible flight

    -- Aim Allows Death:
    --  I hit the ground hard while aiming, and grappling hook had stolen flight, which prevented jetpack from doing a safe landing

	-- Angry Bird:
	--	Figure out why it loses speed

	-- Controller:
	--	Listen to MoveX, MoveY
	--	Do a length chcek + dot product and populate:  Forward, Back, Left, Right

    -- Aim:
    --  Add an option to slow down time while aiming

    -- Grapple Straight:
    --  Add a repulsion to walls when > some distance from desired distance
    --  This would be helpful with going straight up walls

    -- Grapple Straight:
    --  Add an ability to jump straight away from a wall when at the desired distance (and close to a wall)
    --  This will help with scaling tall walls.  You grapple straight up, reach the anchor, recover energy,
    --  jump and aquire a new grapple point, repeat
    --
    --  Also give an option to slow time while jumping.  This will be useful for ambushing enemies

    -- All:
    --  Fall damage should be a percent, not a bool

    -- Web Swing:
    --  Have options for increased gravity, to make the player move faster

    -- Zip Line:
    --  Choose an anchor point some distance along the look direction
    --  Calculate a parabola or bezier above the player, then draw it
    --  This wouldn't necessarily anchor to anything (because collision hulls would be too far away)

    -- Grapple Straight/Swing:
    --  Add extra weight when carrying a dead body

    -- Energy Tank:
    --  Drawn Weapon Cost %
    --
    --  Grapple costs more when a weapon is drawn (don't do this for fists or cyberarms):
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

    -- XP Gain
    --  Add achievments

    -- UI:
    --  Add invisible buttons to several controls, highlight graphics based on hover

    -- UI:
    --  The props in viewmodels that override style are currently suffixed with _override
    --  Need to make most style properties overridable by the viewmodel, and it should just be the same name

    -- UI:
    --  All numbers should be presented as dozenal :)
	--	(see wall hang)

    -- ViewModels:
    --  The properties that change should have set instead of init

    -- Crouch:
    --  Reenter crouch if grapple started from crouch
    --      (I think it already does.  The person that reported this may have walked forward after grappling.  Test a bit more)

    -- Adjust Pitch:
    --  While grappling, adjust the pitch if there is a strong enough yaw change accel
    --
    --  local fppcam = o.player:GetFPPCameraComponent()
    --  o:GetCamera()
    --  local quat = Quaternion_FromAxisRadians(o.lookdir_forward, Degrees_to_Radians(135))
    --  fppcam:SetLocalOrientation(quat)
    --
    --  The above code works, but would need to multiply a quat based on the current yaw

    -- Test and add a link to no sepia mod
    --  https://www.nexusmods.com/cyberpunk2077/mods/3161/

	-- Raycast Alternate (looks like this worked in 1.3.1, but not 1.5):
	--	keanuWheeze — Yesterday at 3:24 PM
	--	Is there any way of raycasting for every type of collision in one go, without having to do seperate ones for all the collision groups (Static, Terrain)? (https://nativedb.red4ext.com/gameSpatialQueriesSystem)
	--	SyncRaycastByCollisionPreset would sound promising, but i have no clue what the preset names are (Except for the few ones found in the dump)	
	--	
	--	psiberx — Today at 3:50 AM
	--	there is a more powerful function RayCastWithCollisionFilter but in the StateGameScriptInterface 
	--	https://nativedb.red4ext.com/gamestateMachineGameScriptInterface
	--	idk if you can grab and store script interface from state machine for a later use, but if you gonna try then better use weak reference
	--	and you can find all collision groups and presets in engine\physics\*.json
	--
	--	
	--	keanuWheeze — Yesterday at 4:17 PM
	--	It works:luvit:
	--	Observe("LocomotionEventsTransition", "OnUpdate", function(_, _, _, interface)
	--	        result = interface:RayCastWithCollisionFilter(GetPlayer():GetWorldPosition(), multVector(GetPlayer():GetWorldForward(), 20), QueryFilter.ALL())
	--	        print(result.position)
	--	end)
	--	 
	--	This checks for raycast collision with everything in one go:sogood:
	--	Havent tried storing the scriptInterface reference yet, but this observed function runs every frame anyways:risitas: Edit: Storing it works:PeepoMeLikey: 
	--
	--	keanuWheeze — Yesterday at 4:33 PM
	--	Havent managed to get a custom filter to work tho, as doing f = QueryFilter.new() and then a f:AddGroup("Static") tells me Function 'AddGroup' requires 1 parameter(s). Doing it the other way like this: QueryFilter:AddGroup(f, CName.new("Terrain")) executes fine, but does not collide with anything:BigThonk2:	
	--		
	--	psiberx — Yesterday at 4:57 PM
	--	can't use this function with cet currently because they have marked first param as out (they don't do this with other structs)	
	
end