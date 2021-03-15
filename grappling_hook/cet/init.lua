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
require "lib/gameobj_accessor"
require "lib/grapplestartinputtracker"
require "lib/keys"
require "lib/math_basic"
require "lib/math_raycast"
require "lib/math_vector"
require "lib/math_yaw"
require "lib/reporting"
require "lib/safetyfire"
require "lib/util"

--------------------------------------------------------------------
---                  User Preference Constants                   ---
--------------------------------------------------------------------

local const =
{
    maxSpeed = 120,                     -- player:GetVelocity() isn't the same as the car's reported speed, it's about 4 times slower.  So 100 would be roughly car speed of 400

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
    isInFlight = false,

    --sound_current = nil,      -- can't store nil in a table, because it just goes away.  But non nil will use this name.  Keeping it simple, only allowing one sound at a time.  If multiple are needed, use StickyList
    sound_started = 0,
}

--------------------------------------------------------------------

registerForEvent("onInit", function()
    Observe('PlayerPuppet', 'OnAction', function(action)        -- observe must be inside init and before other code
        keys:MapAction(action)
    end)

    Observe('RadialWheelController', 'RegisterBlackboards', function(_, loaded)
        if loaded then
            print("Game Session Started")
            isLoading = false
        else
            print("Game Session Ended")
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
    function wrappers.SetTimeDilation(timeSpeed) Game.SetTimeDilation(tostring(timeSpeed)) end      -- for some reason, it takes in string
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    function wrappers.Get_Custom_IsFlying(player) return Get_Custom_IsFlying(player) end
    function wrappers.Set_Custom_IsFlying(player, value) Set_Custom_IsFlying(player, value) end
    function wrappers.Get_Custom_SuppressFalling(player) return Get_Custom_SuppressFalling(player) end
    function wrappers.Set_Custom_SuppressFalling(player, value) Set_Custom_SuppressFalling(player, value) end
    function wrappers.Ragdoll_Up(player, radius, force, randHorz, randVert) player:RagdollNPCs_StraightUp(radius, force, randHorz, randVert) end
    function wrappers.Ragdoll_Out(player, radius, force, upForce) player:RagdollNPCs_ExplodeOut(radius, force, upForce) end
    function wrappers.QueueSound(player, sound) player:GrapplingHook_QueueSound(sound) end
    function wrappers.StopQueuedSound(player, sound) player:GrapplingHook_StopQueuedSound(sound) end
    o = GameObjectAccessor:new(wrappers)

    state.grappleStartTracker = GrappleStartInputTracker:new(o, keys, "left", "right", "forward", "backward")
end)

registerForEvent("onShutdown", function()
    isShutdown = true
end)

registerForEvent("onUpdate", function(deltaTime)
    if isShutdown or isLoading or IsPlayerInAnyMenu() then
        --ExitFlight(state, debug, o)
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        --ExitFlight(state, debug, o)
        do return end
    end

    StopSound(o, state)

    if not IsStandingStill(o.vel) then
        o:GetInWorkspot()       -- this crashes soon after loading a save.  So don't call if velocity is near zero.  Still got a crash when reloading after dying in a car shootout.  Hopefully this looser method keeps from crashing
        if o.isInWorkspot then
            --ExitFlight(state, debug, o)
            do return end
        end
    end

    state.grappleStartTracker:Tick()

    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, keys, state)
    end

    if state.isInFlight then
        -- In Flight
    else
        -- Standard (walking around)
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
