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
--require "lib/improved_raycast"        -- just comments
require "lib/keys"
--require "lib/map_pin"     -- it's just comments
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



local lastDotTime = nil
local lastDotID = nil

local wrappers2 = {}


--------------------------------------------------------------------

registerForEvent("onInit", function()
    Observe('PlayerPuppet', 'OnAction', function(action)        -- observe must be inside init and before other code
        keys:MapAction(action)
    end)

    Observe('RadialWheelController', 'RegisterBlackboards', function(_, loaded)
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
    function wrappers.RayCast(player, from, to, staticOnly) return player:GrapplingHook_RayCast_Position(from, to, staticOnly) end
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


    -- Move to process_standard
    --NOTE: If this gets called during active grappling, the results are meaningless.  They could start out pressing
    --three buttons, but let off forward or backward, then it would look like something else
    state.grappleStartTracker:Tick()



    if lastDotID and (o.timer - lastDotTime > 6) then
        o:RemovePin(lastDotID)
        lastDotID = nil
    end



    if state.grappleStartTracker.isDown_grapple or state.grappleStartTracker.isDown_polevault or state.grappleStartTracker.isDown_swing then

        o:GetCamera()

        local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + 1.5, 1)
        --local to = AddVectors(from, MultiplyVector(o.lookdir_forward, 144))


        -- This can't see certain objects, so it's only useful if normal is needed
        --local result = o:RayCast(from, to, false)
        --local result = o:



        -- This can't see past 100.  It also sometimes can't buildings more than abs(zdiff) of 30 or 40
        -- Expand the function to walk the ray if those conditions are hit
        local result = RayCast_HitPoint(from, o.lookdir_forward, 144, 0.5, o)


        if result then
            -- only +30, need to test if -30
            debug.zdiff = Round(result.z - from.z, 1)

            if lastDotID then
                o:MovePin(lastDotID, result)
            else
                lastDotID = o:CreatePin(result, "AimVariant")
            end

            lastDotTime = o.timer
        end



        -- print("from: " .. vec_str(from))
        -- print("to:   " .. vec_str(to))
        -- print("res:  " .. vec_str(result))


    end



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
