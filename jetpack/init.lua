--https://www.lua.org/pil/contents.html
--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md

--https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
--https://github.com/jac3km4/redscript
--https://codeberg.org/adamsmasher/cyberpunk/src/branch/master
--https://redscript.redmodding.org/

require "core/debug_code"
require "core/gameobj_accessor"
require "core/lists"
require "core/math_basic"
require "core/math_vector"
require "core/math_yaw"
require "core/util"

require "data/dal"
require "data/modes"

require "processing/flightutil"
require "processing/flightutil_cet"
require "processing/processing_inflight_cet"
require "processing/processing_inflight_red"
require "processing/processing_standard"
require "processing/ragdoll"
require "processing/rmb_dash"
require "processing/rmb_hover"
require "processing/rmb_pushup"
require "processing/safetyfire"

require "ui/drawing"
require "ui/key_accel"
require "ui/keydash_tracker"
require "ui/keydash_tracker_analog"
require "ui/keys"
require "ui/reporting"
require "ui/sounds_thrusting"
require "ui/sounds_wallhit"

local this = {}

--------------------------------------------------------------------
---                  User Preference Constants                   ---
--------------------------------------------------------------------

local const =
{
    isEnabled = true,                   -- toggled with a hotkey, stored in the database.  Since jetpack is activated by jump held down, it could interfere with other mods.  So this is a way for the user to manually toggle it

    maxSpeed = 432,                     -- player:GetVelocity() isn't the same as the car's reported speed, it's about 4 times slower.  So 100 would be roughly car speed of 400

    rightstick_sensitivity = 50,        -- the mouse x seems to be yaw/second (in degrees).  The controller's right thumbstick is -1 to 1.  So this multiplier will convert into yaw/second.  NOTE: the game speeds it up if they hold it for a while, but this doesn't do that

    hide_energy_above_percent = 0.985,  -- For the infinite energy modes (well rounded, airplane), the progress bar is just annoying

    thrust_sound_type = CreateEnum("steam", "steam_quiet", "levitate", "jump"),

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

local o     -- This is a class that wraps access to Game.xxx

local keys = nil -- = Keys:new()        -- moved to init

local debug = {}

local mode = nil -- moved to init

local vars =
{
    isInFlight = false,

    --thrust,           -- these are created in init
    --horz_analog

    --vel = Vector4.new(0, 0, 0, 1),        -- moved this to init (Vector4 isn't available before init)
    startThrustTime = 0,
    lastThrustTime = 0,

    --remainBurnTime = mode.energy.maxBurnTime,        -- moved to init

    --stop_flight_time              -- gets populated in ExitFlight
    --stop_flight_velocity

    --last_rebound_time
    should_rebound_redscript = false,

    showConfigNameUntil = 0,

    --sound_current = nil,      -- can't store nil in a table, because it just goes away.  But non nil will use this name.  Keeping it simple, only allowing one sound at a time.  If multiple are needed, use StickyList
    sound_started = 0,

    --sounds_thrusting = SoundsThrusting:new(),      -- moved to init

    --cur_timeSpeed             -- used when setting the timeSpeed (especially when it's a gradient)

    --toggled_enabled,           -- this is a flag to tell the draw function to say enabled/disabled for a couple seconds
}

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
    function wrappers.UnsetTimeDilation(timesystem, reason) timesystem:UnsetTimeDilation(reason) end
    function wrappers.UnsetTimeDilationOnLocalPlayerZero(timesystem) timesystem:UnsetTimeDilationOnLocalPlayerZero() end
    function wrappers.GetTransactionSystem() return Game.GetTransactionSystem() end
    function wrappers.GetItemInSlot(transaction, player, slotID) transaction:GetItemInSlot(player, slotID) end
    function wrappers.GetStatsSystem() return Game.GetStatsSystem() end
    function wrappers.AddModifier(stats, entityID, modifierData) stats:AddModifier(entityID, modifierData) end
    function wrappers.GetSpatialQueriesSystem() return Game.GetSpatialQueriesSystem() end
    function wrappers.GetTargetingSystem() return Game.GetTargetingSystem() end
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

    const.isEnabled = GetSetting_Bool(const.settings.IsEnabled, true)

    mode = GetConfigValues(GetSetting_Int(const.settings.Mode, 0), vars.sounds_thrusting, const)
    vars.sounds_thrusting:ModeChanged(mode.sound_type)

    vars.remainBurnTime = mode.energy.maxBurnTime
end)

registerForEvent("onShutdown", function()
    isShutdown = true
	--db:close()      -- cet fixed this in 1.12.2
    this.ClearObjects()
end)

registerForEvent("onUpdate", function(deltaTime)
    shouldDraw = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        ExitFlight(vars, debug, o, mode)
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        ExitFlight(vars, debug, o, mode)
        do return end
    end

    PossiblyStopSound(o, vars)

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        ExitFlight(vars, debug, o, mode)
        do return end
    end

    shouldDraw = true       -- don't want a stopped progress bar while in menu or driving

    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, keys, vars)
    end

    -- Cycle Config
    if keys.cycleModes then
        keys.cycleModes = false

        local newIndex = mode.index + 1
        SetSetting_Int(const.settings.Mode, newIndex)
        mode = GetConfigValues(newIndex, vars.sounds_thrusting, const)
        vars.showConfigNameUntil = o.timer + 3

        vars.sounds_thrusting:ModeChanged(mode.sound_type)
        vars.should_rebound_redscript = false

        ExitFlight(vars, debug, o, mode)
    end

    vars.thrust:Tick()     -- this is needed for flight and non flight

    if vars.isInFlight then
        -- In Flight
        if not o:Custom_CurrentlyFlying_Update(GetVelocity(mode, vars, o)) then
            ExitFlight(vars, debug, o, mode)

        elseif mode.useRedscript then
            Process_InFlight_Red(o, vars, const, mode, keys, debug, deltaTime)

        else
            Process_InFlight_CET(o, vars, const, mode, keys, debug, deltaTime)
        end
    else
        -- Standard (walking around)
        Process_Standard(o, vars, mode, const, debug, deltaTime)
    end

    vars.sounds_thrusting:Tick(vars.isInFlight)

    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
end)

registerHotkey("jetpackCycleModes", "Cycle Modes", function()
    keys.cycleModes = true
end)

registerHotkey("jetpackEnableDisable", "Enable/Disable", function()
    const.isEnabled = not const.isEnabled
    SetSetting_Bool(const.settings.IsEnabled, const.isEnabled)

    vars.toggled_enabled = o.timer

    if not const.isEnabled then
        ExitFlight(vars, debug, o, mode)
    end
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        do return end
    end

    -- Energy tank (only show when it's not full)
    if vars.remainBurnTime / mode.energy.maxBurnTime < const.hide_energy_above_percent then
        DrawJetpackProgress(mode.name, vars.remainBurnTime, mode.energy.maxBurnTime)
    end

    -- Config Name
    if vars.showConfigNameUntil > o.timer then
        DrawConfigName(mode)
    end

    if vars.toggled_enabled and o.timer - vars.toggled_enabled < 2 then
        DrawEnabledDisabled(const.isEnabled)
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug)
    end
end)

------------------------------------ Private Methods ----------------------------------

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    ExitFlight(vars, debug, o, mode)

    if o then
        o:Clear()
    end
end