--https://www.lua.org/pil/contents.html
--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md

--https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
--https://github.com/jac3km4/redscript
--https://codeberg.org/adamsmasher/cyberpunk/src/branch/master
--https://redscript.redmodding.org/

require "lib/check_other_mods"
require "lib/customprops_wrapper"
require "lib/debug_code"
require "lib/drawing"
require "lib/flightutil"
require "lib/floatplayer"
require "lib/gameobj_accessor"
require "lib/input_actionMapper"
require "lib/input_processing"
require "lib/kdashinputtracker"
require "lib/keys"
require "lib/laser_finder_manager"
require "lib/laser_finder_worker"
require "lib/math_basic"
require "lib/math_raycast"
require "lib/math_vector"
require "lib/math_yaw"
require "lib/processing_inflight"
require "lib/processing_standard"
require "lib/raycast_hit_storage"
require "lib/reporting"
require "lib/rollingbuffer"
require "lib/sticky_list"
require "lib/unittests"
require "lib/util"

function TODO()
    -- GetGravity is using 9.8 instead of 16

    -- Increase repulse strength a bit at high speed
end

local this = {}

--------------------------------------------------------------------
---                  User Preference Constants                   ---
--------------------------------------------------------------------

local const =
{
    -- Accelerations when keys are pressed
    --NOTE: Keybinds currently only report on keyup, so these have to be applied instantly (not ideal, need to change when better events are available)
    accel_forward = 10,
    accel_backward = 20,
    accel_side = 0,     --TODO: Figure out why this is just speeding the player up
    accel_jump = 60,

    -- How much to turn when left and right keys are pressed (in degrees)
    yaw_turn_min = 1.8,     -- amount at low speed
    yaw_turn_max = 0.7,      -- amount at high speed

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

    maxSpeed = 144,                     -- player:GetVelocity() isn't the same as the car's reported speed.  A car speed of 100 is around 26 world speed.  150 is about 33.  So a world speed of 180 would be a car speed of around 720

    modNames = CreateEnum({ "grappling_hook", "jetpack", "low_flying_v", "wall_hang" }),

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
    isInFlight = false,
    --kdash = KDashInputTracker:new(),          -- moved to init
    --rayHitStorage = RaycastHitStorage:new(),  -- moved to init

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
}

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

    keys = Keys:new()
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
    function wrappers.Custom_CurrentlyFlying_get(player) return Custom_CurrentlyFlying_get(player) end
    function wrappers.Custom_CurrentlyFlying_StartFlight(player) Custom_CurrentlyFlying_StartFlight(player, const.modNames) end
    function wrappers.Custom_CurrentlyFlying_Clear(player) Custom_CurrentlyFlying_Clear(player, const.modNames) end

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
        ExitFlight(vars, debug, o)
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        ExitFlight(vars, debug, o)
        do return end
    end

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        ExitFlight(vars, debug, o)
        do return end
    end

    shouldDraw = true

    PopulateDebug(debug, o, keys, vars)

    if vars.isInFlight then
        -- In Flight
        Process_InFlight(o, vars, const, keys, debug, deltaTime)
    else
        -- Standard (walking around)
        Process_Standard(o, vars, keys, debug, const)
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

------------------------------------ Private Methods -----------------------------------

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    ExitFlight(vars, debug, o)

    if o then
        o:Clear()
    end
end