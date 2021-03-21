--https://www.lua.org/pil/contents.html
--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md

--https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
--https://github.com/jac3km4/redscript
--https://codeberg.org/adamsmasher/cyberpunk/src/branch/master
--https://redscript.redmodding.org/

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
require "lib/processing_flight_rigid"
require "lib/processing_standard"
require "lib/reporting"
require "lib/safetyfire"
require "lib/throwaway_code"
require "lib/util"

--------------------------------------------------------------------
---                  User Preference Constants                   ---
--------------------------------------------------------------------

local const =
{
    flightModes = CreateEnum({ "standard", "aim_pull", "aim_rigid", "air_dash", "flight_pull", "flight_rigid" }),

    pull =
    {
        maxDistance = 130,
        allowAirDash = true,
        mappinName = "AimVariant",
        flightMode = "flight_pull",         -- flightModes.flight_pull
        minDot = 0,                         -- grapple will disengage when dot product of look direction and grapple line is less than this
    },

    rigid =
    {
        maxDistance = 70,
        allowAirDash = false,
        mappinName = "TakeControlVariant",
        flightMode = "flight_rigid",        -- flightModes.flight_rigid
        minDot = 0,                         -- grapple will disengage when dot product of look direction and grapple line is less than this
    },

    mappinName_aim = "CustomPositionVariant",
    aim_duration = 1,           -- how long to aim before giving up and switching to airdash, or back to standard

    grappleFrom_Z = 1.5,
    grappleMinResolution = 0.5,

    maxSpeed = 60,                     -- player:GetVelocity() isn't the same as the car's reported speed, it's about 4 times slower.  So 100 would be roughly car speed of 400

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

    --rayFrom       -- gets populated when transitioning to airdash or flight
    --rayHit        -- gets populated when transitioning to flight
    --rayDir        -- gets populated when transitioning to airdash
    --rayLength     -- gets populated when transitioning to airdash

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
    function wrappers.Get_Custom_IsFlying(player) return Get_Custom_IsFlying(player) end
    function wrappers.Set_Custom_IsFlying(player, value) Set_Custom_IsFlying(player, value) end
    function wrappers.QueueSound(player, sound) player:GrapplingHook_QueueSound(sound) end
    function wrappers.StopQueuedSound(player, sound) player:GrapplingHook_StopQueuedSound(sound) end
    function wrappers.GetMapPinSystem() return Game.GetMappinSystem() end
    function wrappers.RegisterMapPin(mapPin, data, pos) return mapPin:RegisterMappin(data, pos) end
    function wrappers.SetMapPinPosition(mapPin, id, pos) mapPin:SetMappinPosition(id, pos) end
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

    --Test_Raycast_Mappin(o, state, debug)




    -- 144 is too far.  It's noticablly unreliable at that distance.  Something like 80 might be
    -- better (actually, up to 120 should be good, anticipating collision hulls loading in later)
    --
    -- Grapple Initiated:
    --  Start firing these raycasts
    --      If miss, show one type of map pin
    --      If hit, show another type of map pin
    --      Once there is a hit, move on to the next phase
    --
    --  After a small amount of time or if there was a hit
    --      Play a starting tone
    --
    --  After another small time
    --      play a final tone
    --      Start the actual grapple flight
    --
    --  Grapple Flight (if miss):
    --      This is limited, going mostly straight
    --      Keep firing ray traces along the initial line, in case collision hulls load in as the player gets closer (do this every X frames)
    --          If there is a hit along that line segment:
    --              Play a special tone
    --              Switch to hit flight
    --
    --  Grapple Flight (if hit):
    --      May need further ray casts along the initial line segment if it was beyond 80 (a collision hull could load in as the player gets closer)



    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, keys, state)
    end

    if state.flightMode == const.flightModes.standard then
        -- Standard (walking around)
        Process_Standard(o, state, const, deltaTime)

    elseif state.flightMode == const.flightModes.aim_pull then
        -- Aiming the pull forward grapple
        Process_Aim_Pull(o, state, const, debug)

    elseif state.flightMode == const.flightModes.aim_rigid then
        -- Aiming the rigid grapple
        Process_Aim_Rigid(o, state, const, debug)


    -- elseif state.flightMode == const.flightModes.air_dash then
    -- elseif state.flightMode == const.flightModes.flight_pull then


    elseif state.flightMode == const.flightModes.flight_rigid then
        Process_Flight_Rigid(o, state, const, debug, deltaTime)

    else
        print("Grappling ERROR, unknown flightMode: " .. tostring(state.flightMode))
        Transition_ToStandard(state, const, debug, o)
    end

    keys:Tick()
end)

registerForEvent("onDraw", function()
    if isShutdown or isLoading then
        do return end
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug)
    end
end)
