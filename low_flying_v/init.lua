--https://www.lua.org/pil/contents.html
--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md

--https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
--https://github.com/jac3km4/redscript
--https://codeberg.org/adamsmasher/cyberpunk/src/branch/master
--https://redscript.redmodding.org/

require "core/color"
require "core/debug_code"
require "core/gameobj_accessor"
require "core/lists"
require "core/math_basic"
require "core/math_raycast"
require "core/math_vector"
require "core/math_yaw"
require "core/multimod_flight"
require "core/raycast_hit_storage"
require "core/rollingbuffer"
require "core/sticky_list"
require "core/util"

require "lib/unittests"

require "processing/flightmode_transitions"
require "processing/flightutil"
require "processing/floatplayer"
require "processing/laser_finder_manager"
require "processing/laser_finder_worker"
require "processing/processing_impulse_launch"
require "processing/processing_inflight"
require "processing/processing_standard"

require "ui/drawing"
require "ui/input_actionMapper"
require "ui/input_processing"
require "ui/kdashinputtracker"
require "ui/keys"
require "ui/reporting"
require "ui/sounds_wallhit"

local this = {}

--------------------------------------------------------------------
---                  User Preference Constants                   ---
--------------------------------------------------------------------

local const =
{
    rightstick_sensitivity = 35,        -- the mouse x seems to be yaw/second (in degrees).  The controller's right thumbstick is -1 to 1.  So this multiplier will convert into yaw/second.  NOTE: the game speeds it up if they hold it for a while, but this doesn't do that
    mouse_sensitivity = -0.08,

    -- Accelerations when keys are pressed
    --NOTE: Keybinds currently only report on keyup, so these have to be applied instantly (not ideal, need to change when better events are available)
    accel_forward = 10,
    accel_backward = 20,
    accel_side = 25,
    accel_jump = 60,

    -- How much to turn when left and right keys are pressed (in degrees)
    should_yaw_turn = false,        -- Useful for keyboard, annoying for controller
    yaw_turn_min = 1.8,             -- amount at low speed
    yaw_turn_max = 0.7,             -- amount at high speed

    -- How sensitive the mouse turn should be
    yaw_mouse_mult = 0.07,

    -- These are the forces felt when in flight.  Each raycast hit point acts like a repulsor
    --
    -- It would be nice to loosen the linear force so it's not so spongy, but once the player touches the
    -- ground, the teleports stop working
    --
    -- This is a linear gradient where there is zero force at max distance and max force at zero distance
    linear_maxDist = 5,
    linear_maxAccel = 5,

    -- This is 1/(cx).  The distance is normalized, where x is 0 to 1
    inverse_maxDist = 5,
    inverse_maxAccel = 9,
    inverse_c = 18,         -- (any value less than 4 is meaningless) (plot it in desmos for easy visualization/manipulation)

    -- This is 1/(cx)^2
    inverseSqr_maxDist = 5,
    inverseSqr_maxAccel = 18,
    inverseSqr_c = 20,

    -- Gravity modifier
    gravity_open_mult = 6,              -- how much extra gravity to apply when flying upward in open air
    gravity_open_velZ_min = 1,          -- extra gravity will start applying at this upward speed
    gravity_open_velZ_max = 12,         -- max extra gravity will apply at this upward speed
    gravity_zeroAtDistPercent = 0.5,    -- gravity will be zero when close to objects.  This is % of detect distance

    -- These pull the velocity toward the direction facing
    percent_towardCamera_horz = 0.7,    -- percent per second (I don't think this does anything anymore)
    percent_towardCamera_vert = 1.5,    -- this needs to be large so they can duck under things

    -- This pulls the camera toward the current velocity (I don't think this does anything anymore)
    percent_towardVelocity_horz = 0.2,

    -- After hitting something or keyboard turning, need to go into quick swivel mode,
    -- which causes the look direction to more quickly align with velocity.  Otherwise,
    -- velocity will stubbornly swivel back to look direction.  And instant look dir
    -- changes are jarring
    quickSwivel_duration = 0.5,
    quickSwivel_percent_towardVelocity = 2,

    -- This keeps from going too slow
    accel_underspeed = 12,
    minSpeed = 24,
    minSpeedOverride_duration = 18,     -- when forward or backward buttons are pressed (and the new speed is greater than this minSpeed), that new desired speed will be held.  This is the total time the override is active, but the speed will decay to default during the last portion of this time
    minSpeed_absolute = 12,             -- if slowing down below min speed, the cruise control will be more coarse and not auto speed up.  This is as slow as it will go (much slower, and you'll drop out of flight)

    -- Launch Settings
    launch_horz = 48,                    -- this is the impulse strength to apply when starting flight from a hotkey
    launch_vert = 48,

    maxSpeed = 144,                     -- player:GetVelocity() isn't the same as the car's reported speed.  A car speed of 100 is around 26 world speed.  150 is about 33.  So a world speed of 180 would be a car speed of around 720

    flightModes = CreateEnum("standard", "impulse_launch", "flying"),

    modNames = CreateEnum("grappling_hook", "jetpack", "low_flying_v", "wall_hang"),

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

local debug = { }

local vars =
{
    flightMode = const.flightModes.standard,
    --kdash = KDashInputTracker:new(),          -- moved to init
    --rayHitStorage = RaycastHitStorage:new(),  -- moved to init
    --keys      -- putting this here so it can be referenced elsewhere

    ----- these are added from other places -----
    --lasercats
    --vel
    --startFlightTime

    -- When a keyboard turn is requested or bouncing off a wall, the direction facing needs to
    -- match velocity.  But it's disorienting if it's instant.  So this is when an action like
    -- that starts, and the look direction will be pulled toward velocity for a small window of
    -- time
    quickSwivel_startTime = 0,

    -- This remembers when they became under speed (when in flight mode).  This way, if they are
    -- too slow for a while, flight will end
    --lowSpeedTime = nil,

    -- Whenever backbutton is pressed, this gets the current time, which will be used to disable
    -- the auto speed up for a bit
    hitBackTime = 0,

    -- These are an override to the min speed.  They activate after the user has pressed the forward
    -- or backward key.  The new speed will be the overridden min for a while, then decay back to the
    -- default
    minSpeedOverride_current = 0,       -- this is the new current min speed
    minSpeedOverride_start = -1000,     -- this is when the override started (really negative init ensures there's no override)

    --sound_current = nil,      -- can't store nil in a table, because it just goes away.  But non nil will use this name.  Keeping it simple, only allowing one sound at a time.  If multiple are needed, use StickyList
    sound_started = 0,

    --sound_hover = nil,        -- this one stays playing while they are hovering
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

    keys = Keys:new(debug, const)
    vars.keys = keys
    vars.kdash = KDashInputTracker:new()
    vars.rayHitStorage = RaycastHitStorage:new()

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
    function wrappers.GetQuestsSystem() return Game.GetQuestsSystem() end
    function wrappers.GetQuestFactStr(quest, key) return quest:GetFactStr(key) end
    function wrappers.SetQuestFactStr(quest, key, id) quest:SetFactStr(key, id) end       -- id must be an integer
    function wrappers.GetSpatialQueriesSystem() return Game.GetSpatialQueriesSystem() end
    function wrappers.GetTargetingSystem() return Game.GetTargetingSystem() end

    o = GameObjectAccessor:new(wrappers)

    vars.lasercats = LaserFinderManager:new(o, vars.rayHitStorage)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    this.ClearObjects()
end)

registerForEvent("onUpdate", function(deltaTime)
    shouldDraw = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        Transition_ToStandard(vars, debug, o, const)
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        Transition_ToStandard(vars, debug, o, const)
        do return end
    end

    PossiblyStopSound(o, vars)

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        Transition_ToStandard(vars, debug, o, const)
        do return end
    end

    shouldDraw = true

    PopulateDebug(debug, o, keys, vars)

    if vars.flightMode == const.flightModes.standard then
        -- Standard (walking around)
        Process_Standard(o, vars, keys, debug, const)

    elseif vars.flightMode == const.flightModes.impulse_launch then
        -- Getting airborne and up to speed before flight
        Process_ImpulseLaunch(o, vars, keys, debug, const)

    elseif vars.flightMode == const.flightModes.flying then
        -- In Flight
        Process_InFlight(o, vars, keys, debug, const, deltaTime)

    else
        LogError("Unknown flightMode: " .. tostring(vars.flightMode))
        Transition_ToStandard(vars, debug, o, const)
    end

    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
end)

registerHotkey("lowflyingvForceFlight", "Force Flight", function()
    keys.forceFlight = true
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        do return end
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug)
    end
end)

----------------------------------- Private Methods -----------------------------------

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    Transition_ToStandard(vars, debug, o, const)

    if o then
        o:Clear()
    end
end