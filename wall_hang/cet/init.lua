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

require "lib/check_other_mods"
require "lib/customprops_wrapper"
require "lib/debug_code"
require "lib/drawing"
require "lib/flightmode_transitions"
require "lib/flightutil"
require "lib/gameobj_accessor"
require "lib/inputtracker_startstop"
require "lib/keys"
require "lib/math_basic"
require "lib/math_raycast"
require "lib/math_vector"
require "lib/math_yaw"
require "lib/processing_hang"
require "lib/processing_jump_calculate"
require "lib/processing_jump_impulse"
require "lib/processing_jump_teleturn"
require "lib/processing_standard"
require "lib/reporting"
require "lib/sounds"
require "lib/util"

local this = {}

--------------------------------------------------------------------
---                  User Preference Constants                   ---
--------------------------------------------------------------------

-- If you want to use an action that the game sees (like Q, F, Shift), then set this here
--
-- This doesn't map directly to the key, instead it maps to an action that the key produces
--
-- If you want a different action, the easiest way is to use grappling hook's input bindings
-- config to see what it's called

--NOTE: This is case sensitive
--NOTE: Comment this out if you want it ignored (and use the override instead)
local hangAction = "QuickMelee"      -- Q key (or equivalent button on a controller)

--------------------------------------------------------------------
---                     (leave these alone)                      ---
--------------------------------------------------------------------

local const =
{
    flightModes = CreateEnum("standard", "hang", "jump_calculate", "jump_teleturn", "jump_impulse"),

    modNames = CreateEnum("wall_hang", "grappling_hook", "jetpack", "low_flying_v"),     -- this really doesn't need to know the other mod names, since wall hang will override flight

    rayFrom_Z = 1.5,
    rayLen = 1.2,

    jump_strength = 11,

    teleturn_radians_per_second = math.pi * 3.5,      -- this needs to be very fast, teleturn is a hack and can't last very long.  Just enough motion that the player can sense the direction change (it's very disorienting to instantly face a new direction)

    shouldShowDebugWindow = false
}

local isShutdown = true
local isLoaded = false
local shouldDraw = false

local o     -- This is a class that wraps access to Game.xxx

local keys = nil -- = Keys:new()        -- moved to init
local startStopTracker = nil -- InputTracker_StartStop:new()        -- moved to init

local debug = {}

local vars =
{
    -- These get populated in Transition_ToHang() and/or Transition_ToJump_Calculate()
    --hangPos,
    --normal,
    --material,

    -- These get populated in Transition_ToJump_TeleTurn()
    --impulse,
    --final_lookdir,

    --NOTE: These sound props are only used for sounds that should be one at a time.  There can
    --      be other sounds that are managed elsewhere
    --sound_current = nil,  -- can't store nil in a table, because it just goes away.  But non nil will use this name.  Keeping it simple, only allowing one sound at a time.  If multiple are needed, use StickyList
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
            Transition_ToStandard(vars, const, debug, o)
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
    function wrappers.RayCast(player, from, to, staticOnly) return player:WallHang_RayCast(from, to, staticOnly) end
    function wrappers.SetTimeDilation(timeSpeed) Game.SetTimeDilation(tostring(timeSpeed)) end      -- for some reason, it takes in string
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    function wrappers.Custom_CurrentlyFlying_get(player) return Custom_CurrentlyFlying_get(player) end
    function wrappers.Custom_CurrentlyFlying_StartFlight(player) Custom_CurrentlyFlying_StartFlight(player, const.modNames) end
    function wrappers.Custom_CurrentlyFlying_Clear(player) Custom_CurrentlyFlying_Clear(player, const.modNames) end
    function wrappers.QueueSound(player, sound) player:WallHang_QueueSound(sound) end
    function wrappers.StopQueuedSound(player, sound) player:WallHang_StopQueuedSound(sound) end

    o = GameObjectAccessor:new(wrappers)

    keys = Keys:new(o, hangAction)
    startStopTracker = InputTracker_StartStop:new(o, keys, const, hangAction == nil)

    Transition_ToStandard(vars, const, debug, o)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    this.ClearObjects()
end)

registerForEvent("onUpdate", function(deltaTime)
    shouldDraw = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    StopSound(o, vars)

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    shouldDraw = true       -- don't want a hung progress bar while in menu or driving

    startStopTracker:Tick()

    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, keys, vars, startStopTracker)
    end

    if vars.flightMode == const.flightModes.standard then
        -- Standard (walking around)
        Process_Standard(o, vars, const, debug, startStopTracker)

    elseif not CheckOtherModsFor_ContinueFlight(o, const.modNames) then
        -- Was hanging/jumping, but another mod took over
        Transition_ToStandard(vars, const, debug, o)

    elseif vars.flightMode == const.flightModes.hang then
        -- Hanging from a wall
        Process_Hang(o, vars, const, debug, keys, startStopTracker)

    elseif vars.flightMode == const.flightModes.jump_calculate then
        -- Figure out direction/strength to jump
        Process_Jump_Calculate(o, vars, const, debug)

    elseif vars.flightMode == const.flightModes.jump_teleturn then
        -- Use teleport to adjust the look direction over a few frames
        Process_Jump_TeleTurn(o, vars, const, debug, deltaTime)

    elseif vars.flightMode == const.flightModes.jump_impulse then
        -- Apply a final impulse to finish jumping the player
        Process_Jump_Impulse(o, vars, const, debug)

    else
        print("Wall Hang ERROR, unknown flightMode: " .. tostring(vars.flightMode))
        Transition_ToStandard(vars, const, debug, o)
    end

    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
end)

-- registerHotkey("WallHangTesterButton", "tester hotkey", function()
-- end)

registerInput("WallHang_CustomHang", "Hang (override default)", function(isDown)
    keys:PressedCustom(isDown)
    startStopTracker:SawCustom()
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        do return end
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug)
    end
end)

------------------------- Private Methods --------------------------

-- This gets called when a load or shutdown occurs.  It removes references to the current session's objects
function this.ClearObjects()
    Transition_ToStandard(vars, const, debug, o)

    if o then
        o:Clear()
    end
end

--------------------------------------------------------------------

function TODO()

    -- Sounds

    -- Jump+Forward
    --  When jumping off a wall, if they are holding forward:
    --      Go up
    --      Don't change yaw

    -- Hang+Direction
    --  While hanging, if they hold a direction, then crawl along the wall in that direction
    --  (think of mario on those wire fences)
    --      It would be funny if a button press causes the player to flip to the other side of the wall :)

    -- Double tap jump
    --  If they quickly double tap jump, then enter bullet time for a few seconds

    -- Wall Run
    --  Hold in shift to enter and stay in wall run

    -- Hang Drift
    --  Don't perfectly hold position
    --
    --  When first entering hang, move in the direction of
    --  their prev velocity and ease into a stop (over a very short distance, but still more than
    --  an instant stop)
    --
    --  Also, the final resting position should be slightly lower than the initial hang position.
    --  This will give a sense of weight to the player
    --
    --  Then very slowly drift around randomly.  Mostly in the plane of the wall, but a little off
    --  the wall (like a really flat ellipsoid)

    -- Jump Calculation
    --  Instead of a simple hardcoded angle adjustment and constant power...
    --  Determine what they are looking at (if they are looking away from the wall)
    --  Find a trajectory that will place them where they are looking

end