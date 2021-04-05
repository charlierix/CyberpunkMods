--https://www.lua.org/pil/contents.html
--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md

--https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
--https://github.com/jac3km4/redscript
--https://codeberg.org/adamsmasher/cyberpunk/src/branch/master
--https://redscript.redmodding.org/

require "core/check_other_mods"
require "core/customprops_wrapper"
require "core/debug_code"
require "core/drawing"
require "core/gameobj_accessor"
require "core/inputtracker_startstop"
require "core/keys"
require "core/mappinutil"
require "core/math_basic"
require "core/math_raycast"
require "core/math_vector"
require "core/math_yaw"
require "core/reporting"
require "core/util"

require "db/dal"
require "db/datautil"
require "db/player"

require "processing/flightmode_transitions"
require "processing/flightutil"
require "processing/processing_aim"
require "processing/processing_airdash"
require "processing/processing_antigrav"
require "processing/processing_flight"
require "processing/processing_standard"
require "processing/safetyfire"

function TODO()

    -- WebSwing:
    --  Activate when double tapping A,D

    -- All:
    --  Sounds

    -- Pull:
    --      May need further ray casts along the initial line segment if it was beyond 50 (a collision hull could load in as the player gets closer)

    -- Pull:
    --  If grapple point is a person (determined in aim), ragdoll them toward you
    --  GET OVER HERE!!!

    -- All:
    --  Energy tank

    -- All:
    --  Anti gravity should taper off a bit after release

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

    -- Pull/Rigid:
    --  Instead of pull/rigid being distinct, hardcoded:  Make a single straight line function that gets
    --  fed a bunch of options.  Then the user will pick which mode gets tied to which buttons:
    --      Desired Length: pull is currently zero, rigid is currently none
    --      Can airdash first
    --      Compress/Tension forces
    --          Also have option for spring forces


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

    isSafetyFireCandidate = false,      -- this will turn true when grapple is used.  Goes back to false after they touch the ground



    --TODO: Make an object that stores the current flight configs







    --TODO: These variables will need to be evaluated

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

}

local player = nil       -- set this to nil whenever a load is started

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
            player = nil
        end
    end)

    isShutdown = false

    InitializeRandom()
    EnsureTablesCreated()

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


    --TODO: FPS Safety


    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    if not player then
        player = Player:new(o, state, const, debug)
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
        Process_Aim(o, player, state, const, debug, deltaTime)

    elseif state.flightMode == const.flightModes.airdash then
        -- Didn't see a grapple point, so dashing forward
        Process_AirDash(o, player, state, const, debug, deltaTime)

    elseif state.flightMode == const.flightModes.flight then
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

registerForEvent("onDraw", function()
    if isShutdown or isLoading then
        do return end
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug)
    end
end)
