--https://www.lua.org/pil/contents.html
--https://wiki.cybermods.net/cyber-engine-tweaks/console/functions
--https://github.com/yamashi/CyberEngineTweaks/blob/eb0f7daf2971ed480abf04355458cbe326a0e922/src/sol_imgui/README.md

--https://docs.swift.org/swift-book/LanguageGuide/TheBasics.html
--https://github.com/jac3km4/redscript
--https://codeberg.org/adamsmasher/cyberpunk/src/branch/master
--https://redscript.redmodding.org/

require "lib/check_other_mods"
require "lib/customprops_wrapper"
require "lib/dal"
require "lib/debug_code"
require "lib/drawing"
require "lib/flightutil"
require "lib/flightutil_cet"
require "lib/gameobj_accessor"
require "lib/key_accel"
require "lib/keydash_tracker"
require "lib/keydash_tracker_analog"
require "lib/keys"
require "lib/lists"
require "lib/math_basic"
require "lib/math_raycast"
require "lib/math_vector"
require "lib/math_yaw"
require "lib/processing_inflight_cet"
require "lib/processing_inflight_red"
require "lib/processing_standard"
require "lib/reporting"
require "lib/rmb_dash"
require "lib/rmb_hover"
require "lib/rmb_pushup"
require "lib/safetyfire"
require "lib/util"

local this = {}

--------------------------------------------------------------------
---                  User Preference Constants                   ---
--------------------------------------------------------------------

-- Every time keys.cycleConfig is pressed, this function will get called with the next mode
function GetConfigValues(index)
    local i = 0

    ----------------- Default Values - Can be overridden by each mode below
    local name = ""

    local useRedscript = false          -- once flight using redscript is fully developed, the cet teleporting will go away (assuming the falling death animation can be suppressed)

    local accel_gravity = -16           -- this is what the game uses for player's gravity (thrown items are -9.8)

    local accel_horz_stand = 1.5        -- standard is when you hold down a key (not dashing)
    local accel_horz_dash = 4           -- dash is when you tap then hold a direction
    local accel_vert_stand = 2.5
    local accel_vert_dash = 6

    local maxBurnTime = 4               -- seconds
    local burnRate_dash = 2             -- uses up "energy" at this higher rate when dashing (energy being time left to burn the thrusters)
    local burnRate_horz = 0.3           -- how much "energy" horizontal thruster firing uses
    local energyRecoveryRate = 0.35     -- how quickly "energy" recharges when not using thrust

    local holdJumpDelay = 0.37          -- how long to hold down the jump key to start flight

    local timeSpeed = 1                 -- 0.0001 is frozen time, 1 is standard

    local shouldSafetyFire = true       -- this detects when they are falling fast and close to the ground.  It will blip teleport to eliminate velocity and avoid death

    local rmb_extra = nil               -- this is an optional class that does custom actions when right mouse button is held in

    local explosiveLanding = false      -- this will ragdoll nearby NPCs when landing

    local rotateVelToLookDir = false    -- This only be done in CET based flight (non redscript).  This will pull the velocity to line up with the direction facing
    local rotateVel_percent_horz = 0.8  -- How strong the pull is.  This is percent per second (1 would be fully aligned after one second)
    local rotateVel_percent_vert = 0    -- Aligning vertically gets annoying, because the player is naturally looking down at an angle, causing it to always want to go down
    local rotateVel_dotPow = 3          -- unsigned integer, percent will be multiplied by the dot product so when they are looking perpendicular to velocity (or more), percent will be zero.  That dot will be taken to this power.  0 won't do the dot product, 1 is standard, 2 is squared, etc.  Paste this into desmos for a visualization: "\cos\left(\frac{\pi}{2}\cdot\left(1-x\right)\right)^{n}"
    local rotateVel_minSpeed = 30       -- the speed to start rotating velocity to look dir
    local rotateVel_maxSpeed = 55       -- the speed is above this, percent will be at its max

    ----------------- Modes (cycle with \)
    ----------------- Add/Remove/Modify modes any way you want.  Try to come up with settings that compliment specific play styles
    i = i + 1 ; if index == i then ; i = 1000
        name = "realism"

        useRedscript = true

        maxBurnTime = 3.5

        accel_horz_stand = 1.2
        accel_horz_dash = 3
        accel_vert_stand = 1.5
        accel_vert_dash = 6

        holdJumpDelay = 0.28

        accel_gravity = -12

        shouldSafetyFire = false      -- NOTE: the terminal velocity animation seems to interfere with jetpack activation, so use the jetpack before falling too much
    end

    i = i + 1 ; if index == i then ; i = 1000
        name = "well rounded"

        useRedscript = true

        maxBurnTime = 999
        energyRecoveryRate = 99

        accel_horz_stand = 2
        accel_horz_dash = 6
        accel_vert_stand = 2.4
        accel_vert_dash = 8

        holdJumpDelay = 0.24

        accel_gravity = -7

        rmb_extra = RMB_Hover:new(10, 6, 2, 1, 9999, useRedscript, accel_gravity)
    end

    i = i + 1 ; if index == i then ; i = 1000
        name = "jet trooper"

        -- Extra fuel, but still somewhat constrained
        maxBurnTime = 18
        energyRecoveryRate = 0.8

        -- Slow things down for air superiority
        accel_gravity = -3
        timeSpeed = 0.5

        accel_vert_stand = 1.5
        accel_vert_dash = 3

        rmb_extra = RMB_Hover:new(2, 2, 0.4, 0.3, 12, useRedscript, accel_gravity)
    end

    i = i + 1 ; if index == i then ; i = 1000
        name = "airplane"

        -- Give infinite fuel
        maxBurnTime = 999
        energyRecoveryRate = 99

        -- Have much faster horizontal acceleration
        accel_horz_stand = 18
        accel_horz_dash = 54

        -- A little faster vertical accelerations
        accel_vert_stand = 8
        accel_vert_dash = 16

        accel_gravity = -16

        rmb_extra = RMB_Hover:new(12, 6, 2, 1, 9999, useRedscript, accel_gravity)

        rotateVelToLookDir = true
    end

    i = i + 1 ; if index == i then ; i = 1000
        name = "npc launcher"       -- telekinetic eyeball

        useRedscript = true

        maxBurnTime = 12
        energyRecoveryRate = 1.2

        accel_gravity = -1
        accel_vert_stand = 3.5

        holdJumpDelay = 0.24

        rmb_extra = RMB_PushUp:new(12, 6, 6, 60)      -- the burn rate is only applied for one frame, so need something large
    end

    i = i + 1 ; if index == i then ; i = 1000
        name = "hulk stomp"

        maxBurnTime = 0.8
        burnRate_dash = 1
        burnRate_horz = 0.01
        energyRecoveryRate = 0.4

        accel_horz_stand = 0.5
        accel_horz_dash = 0.5
        accel_vert_stand = 18
        accel_vert_dash = 18

        accel_gravity = -28

        holdJumpDelay = 0.2
        useRedscript = true

        explosiveLanding = true
    end

    -----------------

    if i < 1000 then
        return GetConfigValues(1)
    end

    -- The vertical accelerations need to defeat gravity
    if useRedscript then
        local extra = 16 + accel_gravity      -- if gravity is 16, then this is zero.  If gravity is higher, then this is some negative amount
        accel_vert_stand = accel_vert_stand + 16 - extra
        accel_vert_dash = accel_vert_dash + 16 - extra
    end

    return { name=name, index=index, accel_gravity=accel_gravity, accel_horz_stand=accel_horz_stand, accel_horz_dash=accel_horz_dash, accel_vert_stand=accel_vert_stand, accel_vert_dash=accel_vert_dash, maxBurnTime=maxBurnTime, burnRate_dash=burnRate_dash, burnRate_horz=burnRate_horz, energyRecoveryRate=energyRecoveryRate, timeSpeed=timeSpeed, shouldSafetyFire=shouldSafetyFire, holdJumpDelay=holdJumpDelay, useRedscript=useRedscript, rmb_extra=rmb_extra, explosiveLanding=explosiveLanding, rotateVelToLookDir=rotateVelToLookDir, rotateVel_percent_horz=rotateVel_percent_horz, rotateVel_percent_vert=rotateVel_percent_vert, rotateVel_dotPow=rotateVel_dotPow, rotateVel_minSpeed=rotateVel_minSpeed, rotateVel_maxSpeed=rotateVel_maxSpeed }
end
local mode = nil -- = GetConfigValues(GetModeIndex())      -- moved to init

local const =
{
    maxSpeed = 144,                     -- player:GetVelocity() isn't the same as the car's reported speed, it's about 4 times slower.  So 100 would be roughly car speed of 400

    modNames = CreateEnum({ "grappling_hook", "jetpack", "low_flying_v", "wall_hang" }),

    rightstick_sensitivity = 50,        -- the mouse x seems to be yaw/second (in degrees).  The controller's right thumbstick is -1 to 1.  So this multiplier will convert into yaw/second.  NOTE: the game speeds it up if they hold it for a while, but this doesn't do that

    shouldShowDebugWindow = true,      -- shows a window with extra debug info
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

local vars =
{
    isInFlight = false,

    --thrust,           -- these are created in init
    --horz_analog

    --vel = Vector4.new(0, 0, 0, 1),        -- moved this to init (Vector4 isn't available before init)
    startThrustTime = 0,
    lastThrustTime = 0,

    --remainBurnTime = mode.maxBurnTime,        -- moved to init

    showConfigNameUntil = 0,

    --sound_current = nil,      -- can't store nil in a table, because it just goes away.  But non nil will use this name.  Keeping it simple, only allowing one sound at a time.  If multiple are needed, use StickyList
    sound_started = 0,
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

    mode = GetConfigValues(GetModeIndex())
    vars.remainBurnTime = mode.maxBurnTime

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
    function wrappers.SetTimeDilation(timeSpeed) Game.SetTimeDilation(tostring(timeSpeed)) end      -- for some reason, it takes in string
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    function wrappers.Custom_CurrentlyFlying_get(player) return Custom_CurrentlyFlying_get(player) end
    function wrappers.Custom_CurrentlyFlying_StartFlight(player) Custom_CurrentlyFlying_StartFlight(player, const.modNames) end
    function wrappers.Custom_CurrentlyFlying_Clear(player) Custom_CurrentlyFlying_Clear(player, const.modNames) end
    function wrappers.Ragdoll_Up(player, radius, force, randHorz, randVert) player:RagdollNPCs_StraightUp(radius, force, randHorz, randVert) end
    function wrappers.Ragdoll_Out(player, radius, force, upForce) player:RagdollNPCs_ExplodeOut(radius, force, upForce) end
    function wrappers.QueueSound(player, sound) player:Jetpack_QueueSound(sound) end
    function wrappers.StopQueuedSound(player, sound) player:Jetpack_StopQueuedSound(sound) end

    o = GameObjectAccessor:new(wrappers)

    vars.thrust = KeyDashTracker:new(o, keys, "jump", "prev_jump")
    vars.horz_analog = KeyDashTracker_Analog:new(o, keys, debug)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
	--db:close()      -- cet fixed this in 1.12.2
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

    StopSound(o, vars)

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        ExitFlight(vars, debug, o)
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
        UpdateModeIndex(newIndex)
        mode = GetConfigValues(newIndex)
        vars.showConfigNameUntil = o.timer + 3
        ExitFlight()
    end

    vars.thrust:Tick()     -- this is needed for flight and non flight

    if vars.isInFlight then
        -- In Flight
        if not CheckOtherModsFor_ContinueFlight(o, const.modNames) then
            ExitFlight(vars, debug, o)
        elseif mode.useRedscript then
            Process_InFlight_Red(o, vars, const, mode, keys, debug, deltaTime)
        else
            Process_InFlight_CET(o, vars, const, mode, keys, debug, deltaTime)
        end
    else
        -- Standard (walking around)
        Process_Standard(o, vars, mode, const, debug, deltaTime)
    end

    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
end)

registerHotkey("jetpackCycleModes", "Cycle Modes", function()
    keys.cycleModes = true
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        do return end
    end

    -- Energy tank (only show when it's not full)
    if vars.remainBurnTime < mode.maxBurnTime then
        DrawJetpackProgress(mode.name, vars.remainBurnTime, mode.maxBurnTime)
    end

    -- Config Name
    if vars.showConfigNameUntil > o.timer then
        DrawConfigName(mode)
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