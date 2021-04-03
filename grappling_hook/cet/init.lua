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
require "lib/flightmode_transitions"
require "lib/flightutil"
require "lib/gameobj_accessor"
require "lib/inputtracker_startstop"
require "lib/keys"
require "lib/mappinutil"
require "lib/math_basic"
require "lib/math_raycast"
require "lib/math_vector"
require "lib/math_yaw"
require "lib/processing_aim"
require "lib/processing_flight_pull"
require "lib/processing_flight_rigid"
require "lib/processing_standard"
require "lib/reporting"
require "lib/safetyfire"
require "lib/util"

--------------------------------------------------------------------
---                  User Preference Constants                   ---
--------------------------------------------------------------------

local const =
{
    flightModes = CreateEnum({ "standard", "aim_pull", "aim_rigid", "air_dash", "flight_pull", "flight_rigid" }),

    pull =
    {
        -- common prop names
        maxDistance = 130,
        allowAirDash = true,
        mappinName = "AimVariant",
        flightMode = "flight_pull",         -- flightModes.flight_pull
        minDot = 0,                         -- grapple will disengage when dot product of look direction and grapple line is less than this

        -- pull specific properties
        speed_towardAnchor = 7,             -- how fast to go toward the anchor point (if the speed is currently greater, there is no counter force to try to slow them down)
        accel_towardAnchor = 24,
        deadzone_dist_towardAnchor = 12,    -- accel drops to zero when near the target

        speed_lookDir = 9,                  -- how fast to go in the look direction
        accel_lookDir = 36,                 -- the acceleration to apply when under speed
        deadzone_dist_lookDir = 4,

        deadZone_speedDiff = 1,             -- accel will drop toward zero if the speed is within this dead zone
    },

    rigid =
    {
        -- common prop names
        maxDistance = 70,
        allowAirDash = false,
        mappinName = "TakeControlVariant",
        flightMode = "flight_rigid",        -- flightModes.flight_rigid
        minDot = 0,                         -- grapple will disengage when dot product of look direction and grapple line is less than this

        -- rigid specific properties
        accelToRadius = 8,                 -- how hard to accelerate toward the desired radius (grapple length)
        radiusDeadSpot = 2,                 -- adding a dead zone keeps things from being jittery when very near the desired radius

        velAway_accel_tension = 84,         -- extra acceleration to apply when velocity is moving away from the desired radius (trying to make the radius larger)
        velAway_accel_compress = 8,         -- (trying to make the radius smaller)
        velAway_deadSpot = 0.5,
    },

    mappinName_aim = "CustomPositionVariant",
    aim_duration = 1,           -- how long to aim before giving up and switching to airdash, or back to standard

    grappleFrom_Z = 1.5,
    grappleMinResolution = 0.5,

    maxSpeed = 60,                     -- player:GetVelocity() isn't the same as the car's reported speed, it's about 4 times slower.  So 100 would be roughly car speed of 400

    modNames = CreateEnum({ "grappling_hook", "jetpack", "low_flying_v" }),     -- this really doesn't need to know the other mod names, since grappling hook will override flight

    shouldShowDebugWindow = true,      -- shows a window with extra debug info
}

--------------------------------------------------------------------
---              Current State (leave these alone)               ---
--------------------------------------------------------------------

local isShutdown = true
local isLoading = false --true
local o     -- This is a class that wraps access to Game.xxx

local keys = Keys:new()

local debug = { }

local state =
{
    flightMode = const.flightModes.standard,

    --startStopTracker      -- this gets instantiated in init

    --sound_current = nil,  -- can't store nil in a table, because it just goes away.  But non nil will use this name.  Keeping it simple, only allowing one sound at a time.  If multiple are needed, use StickyList
    sound_started = 0,

    --startTime      -- gets populated when transitioning into a new flight mode (into aim, into flight, etc) ---- doesn't get set when transitioning to standard

    --mappinID      -- this will be populated while the map pin is visible (managed in mappinutil.lua)
    --mappinName    -- this is the name of the map pin that is currently visible (managed in mappinutil.lua)

    --rayFrom       -- gets populated when transitioning to airdash or flight
    --rayHit        -- gets populated when transitioning to flight
    --rayDir        -- gets populated when transitioning to airdash
    --rayLength     -- gets populated when transitioning to airdash
    --distToHit     -- len(rayHit-rayFrom)    populated when transitioning to flight

    --hasBeenAirborne   -- set to false when transitioning to flight or air dash.  Used by pull and air dash
    --initialAirborneTime
    isSafetyFireCandidate = false,      -- this will turn true when grapple is used.  Goes back to false after they touch the ground
}

--------------------------------------------------------------------

registerForEvent("onInit", function()
    Observe("PlayerPuppet", "OnAction", function(action)        -- observe must be inside init and before other code
        keys:MapAction(action)
    end)

    Observe("RadialWheelController", "RegisterBlackboards", function(_, loaded)
        if loaded then
            isLoading = false
        else
            isLoading = true
        end
    end)

    isShutdown = false

    InitializeRandom()

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
    o = GameObjectAccessor:new(wrappers)

    InitializeKeyTrackers(state, keys, o)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
end)

registerForEvent("onUpdate", function(deltaTime)
    if isShutdown or isLoading or IsPlayerInAnyMenu() then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    StopSound(o, state)

    if not IsStandingStill(o.vel) then
        o:GetInWorkspot()       -- this crashes soon after loading a save.  So don't call if velocity is near zero.  Still got a crash when reloading after dying in a car shootout.  Hopefully this looser method keeps from crashing
        if o.isInWorkspot then
            Transition_ToStandard(state, const, debug, o)
            do return end
        end
    end

    state.startStopTracker:Tick()



    -- Pull:
    --  Exit if not airborne
    --  Only start looking once airborne (when starting on the ground, enter flight first)

    -- WebSwing:
    --  Activate when double tapping A,D

    -- All:
    --  Stop when close to a wall

    -- All:
    --  Sounds

    -- Air Dash:
    --      This is limited, going mostly straight
    --      Keep firing ray traces along the initial line, in case collision hulls load in as the player gets closer (do this every X frames)
    --          If there is a hit along that line segment:
    --              Play a special tone
    --              Switch to hit flight


    -- Pull:
    --      May need further ray casts along the initial line segment if it was beyond 50 (a collision hull could load in as the player gets closer)

    -- Rigid:
    --  If it's first used for compression, then it should break easily under tension

    -- Pull:
    --  If grapple point is a person (determined in aim), ragdoll them toward you
    --  GET OVER HERE!!!

    -- Pull:
    --  Stop if distance is less than 3

    -- Pull:
    --  Adjust how much anitgravity the toward has (0 to 1: the current implementation is 1)

    -- All:
    --  Energy tank

    -- All:
    --  Anti gravity (lasts a bit after release)

    -- All:
    --  Let them level up the grapple.  Start with:
    --      shorter distances
    --      weaker accelerations
    --      (maybe a bit lower max vel)
    --      lower energy max and recovery rate (but don't be too punative with this)
    --      full gravity

    -- Input:
    --  Give the option to register actions to this new style hotkey, if that's what they prefer
    -- registerInput('someID', 'Some input', function(isDown)
    --     if (isDown) then
    --         print(GetBind('someID')..' was pressed!')
    --     else
    --         print(GetBind('someID')..' was released!')
    --     end
    -- end)

    -- SafetyFire Check:
    --  Look in the velocity direction.  That should avoid death when coming in at an angle

    -- Pull/Rigid:
    --  Instead of pull/rigid being distinct, hardcoded:  Make a single straight line function that gets
    --  fed a bunch of options.  Then the user will pick which mode gets tied to which buttons:
    --      Desired Length: pull is currently zero, rigid is currently none
    --      Can airdash first
    --      Compress/Tension forces
    --          Also have option for spring forces






    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, keys, state)
    end

    PossiblySafetyFire(o, state, const, debug, deltaTime)

    if state.flightMode == const.flightModes.standard then
        -- Standard (walking around)
        Process_Standard(o, state, const, deltaTime)

    elseif not CheckOtherModsFor_ContinueFlight(o, const.modNames) then
        -- Was flying, but another mod took over
        Transition_ToStandard(state, const, debug, o)

    elseif state.flightMode == const.flightModes.aim_pull then
        -- Aiming the pull forward grapple
        Process_Aim_Pull(o, state, const, debug)

    elseif state.flightMode == const.flightModes.aim_rigid then
        -- Aiming the rigid grapple
        Process_Aim_Rigid(o, state, const, debug)


    -- elseif state.flightMode == const.flightModes.air_dash then


    elseif state.flightMode == const.flightModes.flight_pull then
        Process_Flight_Pull(o, state, const, debug, deltaTime)

    elseif state.flightMode == const.flightModes.flight_rigid then
        Process_Flight_Rigid(o, state, const, debug, deltaTime)

    else
        print("Grappling ERROR, unknown flightMode: " .. tostring(state.flightMode))
        Transition_ToStandard(state, const, debug, o)
    end

    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
end)

registerForEvent("onDraw", function()
    if isShutdown or isLoading then
        do return end
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug)
    end
end)
