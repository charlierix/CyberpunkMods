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

require "core/animation_curve"
require "core/bezier"
require "core/bezier_segment"
require "core/color"
require "core/gameobj_accessor"
require "core/lists"
require "core/math_basic"
require "core/math_shapes"
require "core/math_vector"
require "core/perlin"
require "core/sticky_list"
require "core/strings"
require "core/util"

entity_helper = require "data/entity_helper"
require "data/map"
qual_vect = require "data/qualifier_vector"
nono_squares = require "data/nono_squares"
require "data/scanner_obstacles"
require "data/scanner_orbs"
require "data/scanner_player"
scanner_util = require "data/scanner_util"
settings_util = require "data/settings_util"

require "debug/debug_code"
require "debug/debug_render_logger"
debug_render_screen = require "debug/debug_render_screen"
require "debug/reporting"

extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

require "orb/ai"
require "orb/audiovisual"
require "orb/orb"
require "orb/swarm"

harvester = require "processing/harvester"
orb_pool = require "processing/orb_pool"

prototype_grenades = require "prototype/grenades"
prototype_grenades2 = require "prototype/grenades2"
prototype_grenades3 = require "prototype/grenades3"
prototype_scanning = require "prototype/scanning"

require "ui/drawing"
require "ui/init_ui"
require "ui/keys"

require "ui_framework/util_misc"

local this = {}

--------------------------------------------------------------------
---                          Constants                           ---
--------------------------------------------------------------------

local const =
{
    mod_name = "NekhraosFaeries",

    map_body_type = CreateEnum("CorpseContainer", "NPC_Dead", "NPC_Defeated", "NPC_Alive"),

    shouldShowScreenDebug = true,      -- draws debug info in game
    shouldShowDebugWindow = true,      -- shows a window with extra debug info
}

local debug_categories = CreateEnum("text2D_2sec")

--------------------------------------------------------------------
---                        Current State                         ---
--------------------------------------------------------------------

local isShutdown = true
local isLoaded = false
local shouldDraw_graphics = false
local shouldDraw_config = false
local isCETOpen = false

local o = nil                           -- This is a class that wraps access to Game.xxx
local debug = {}
local keys = nil -- = Keys:new()        -- moved to init
local map = nil
local scanner_player = nil
local scanner_orbs = nil
local scanner_obstacles = nil

local vars_ui =
{
    scale = 1,      -- control and window sizes are defined in pixels, then get multiplied by scale at runtime.  CET may adjust scale on non 1920x1080 monitors to give a consistent relative size, but higher resolution
}

registerForEvent("onInit", function()
    Observe("PlayerPuppet", "OnGameAttached", function(obj)
        obj:RegisterInputListener(obj)
    end)

    Observe("PlayerPuppet", "OnAction", function(_, action)        -- observe must be inside init and before other code
        keys:MapAction(action)
    end)

    Observe('PlayerPuppet', 'OnItemAddedToInventory', function(_, evt)      -- tdbd = evt.itemID.tdbid ; print(evt.itemID)
        keys:ItemAdded()
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
            --this.ClearObjects()
        end
    end)



    ObserveAfter('BaseGrenade', 'OnGameAttached', function(obj);
        if not obj:IsA('BaseGrenade') then return end;
        local id = obj:GetItemData():GetID().id;
        print('BaseGrenade', 'OnGameAttached', id, id.value, os.clock());
        if Game['OperatorEqual;TweakDBIDTweakDBID;Bool'](id, TweakDBID.new("Items.GrenadeFlashRegular")) then;
            print('HERE WE GO:', id, id.value);
        end;
    end);

    ObserveAfter('BaseGrenade', 'OnVisualSpawnAttached', function(obj);
        if not obj:IsA('BaseGrenade') then return end;
        local id = obj:GetItemData():GetID().id;
        print('BaseGrenade', 'OnVisualSpawnAttached', id, id.value, os.clock());
        if Game['OperatorEqual;TweakDBIDTweakDBID;Bool'](id, TweakDBID.new("Items.GrenadeFlashRegular")) then;
            print('HERE WE GO:', id, id.value);
        end;
    end);


    -- orig, but converted to local variables
    -- Override('CombatGadgetTransitions', 'Throw;StateGameScriptInterfaceStateContextBoolVector4Vector4', function(obj, scriptInterface, stateContext, isQuickthrow, inLocalAimForward, inLocalAimPosition)
    --     local transactionSystem = Game.GetTransactionSystem()
    --     if not obj:CheckItemCategoryInQuickWheel(scriptInterface, gamedataItemCategory.Gadget) then
    --         return
    --     end

    --     local blackboardSystem = Game.GetBlackboardSystem()
    --     local blackboard = blackboardSystem:Get(GetAllBlackboardDefs().UI_QuickSlotsData)
    --     blackboard:SetBool(GetAllBlackboardDefs().UI_QuickSlotsData.dpadHintRefresh, true)
    --     blackboard:SignalBool(GetAllBlackboardDefs().UI_QuickSlotsData.dpadHintRefresh)
    --     local playerPuppet = GetPlayer()
    --     local item = transactionSystem:GetItemInSlot(playerPuppet, obj:GetSlotTDBID(stateContext))
    --     Game.GetTelemetrySystem():LogCombatGadgetUsed(playerPuppet, item:GetItemID())
    --     if item ~= nil then
    --         transactionSystem:RemoveItemFromSlot(playerPuppet, obj:GetSlotTDBID(stateContext), item:IsClientSideOnlyGadget(), false, true)
    --     end

    --     if item and not item:IsClientSideOnlyGadget() then
    --         local launchEvent = gameprojectileSetUpAndLaunchEvent.new()
    --         obj:SetItemIDWrapperPermanentParameter(stateContext, 'grenade', item:GetItemID())
    --         local orientationEntitySpace = Quaternion.new()
    --         Quaternion.SetIdentity(orientationEntitySpace)
    --         Quaternion.SetXRot(orientationEntitySpace, obj:GetRotateAngle(isQuickthrow))

    --         local logicalPositionProvider = nil
    --         local logicalOrientationProvider = nil
    --         if Vector4.IsZero(inLocalAimPosition) or Vector4.IsZero(inLocalAimForward) then
    --             local targetingSystem = Game.GetTargetingSystem()
    --             logicalPositionProvider = targetingSystem:GetDefaultCrosshairPositionProvider(playerPuppet)
    --             logicalOrientationProvider = targetingSystem:GetDefaultCrosshairOrientationProvider(playerPuppet, orientationEntitySpace)
    --         else
    --             logicalPositionProvider = IPositionProvider.CreateEntityPositionProvider(playerPuppet, Vector4.Vector4To3(inLocalAimPosition))
    --             inLocalAimForward = Quaternion.Transform(orientationEntitySpace, inLocalAimForward)
    --             orientationEntitySpace = Quaternion.BuildFromDirectionVector(inLocalAimForward)
    --             logicalOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(nil, '', playerPuppet, orientationEntitySpace)
    --         end

    --         launchEvent.logicalPositionProvider = logicalPositionProvider
    --         launchEvent.logicalOrientationProvider = logicalOrientationProvider
    --         launchEvent.visualPositionProvider = IPositionProvider.CreateEntityPositionProvider(item)
    --         launchEvent.visualOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(nil, '', item)
    --         launchEvent.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(playerPuppet)
    --         launchEvent.lerpMultiplier = 15.0
    --         launchEvent.trajectoryParams = obj:CreateTrajectoryParams(item, isQuickthrow)
    --         launchEvent.owner = playerPuppet
    --         item:QueueEvent(launchEvent)
    --         print('throw')
    --     end
    -- end)


    isShutdown = false

    InitializeRandom()
    InitializeUI(vars_ui, const)       --NOTE: This must be done after db is initialized.  TODO: listen for video settings changing and call this again (it stores the current screen resolution)
    debug_render_screen.CallFrom_onInit(const.shouldShowScreenDebug)

    local wrappers = {}
    function wrappers.GetPlayer() return Game.GetPlayer() end
    function wrappers.Player_GetPos(player) return player:GetWorldPosition() end
    function wrappers.Player_GetVel(player) return player:GetVelocity() end
    function wrappers.Player_GetYaw(player) return player:GetWorldYaw() end
    function wrappers.GetWorkspotSystem() return Game.GetWorkspotSystem() end
    function wrappers.Workspot_InWorkspot(workspot, player) return workspot:IsActorInWorkspot(player) end
    function wrappers.GetCameraSystem() return Game.GetCameraSystem() end
    function wrappers.Camera_GetForwardRight(camera) return camera:GetActiveCameraForward(), camera:GetActiveCameraRight() end
    function wrappers.GetSenseManager() return Game.GetSenseManager() end
    function wrappers.IsPositionVisible(sensor, fromPos, toPos) return sensor:IsPositionVisible(fromPos, toPos) end
    function wrappers.GetQuestsSystem() return Game.GetQuestsSystem() end
    function wrappers.GetQuestFactStr(quest, key) return quest:GetFactStr(key) end
    function wrappers.SetQuestFactStr(quest, key, id) quest:SetFactStr(key, id) end       -- id must be an integer
    function wrappers.GetSpatialQueriesSystem() return Game.GetSpatialQueriesSystem() end
    function wrappers.GetTargetingSystem() return Game.GetTargetingSystem() end     -- gametargetingTargetingSystem
    function wrappers.GetTargetParts(targetting, player, searchQuery) return targetting:GetTargetParts(player, searchQuery) end

    o = GameObjectAccessor:new(wrappers)
    keys = Keys:new(o)
    map = Map:new(o, const)
    scanner_player = Scanner_Player:new(o, map, const)
    scanner_orbs = Scanner_Orbs:new(o, map, const)
    scanner_obstacles = Scanner_Obstacles:new(o)

    this.SetupDebugCategories()
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    --this.ClearObjects()
end)


local ownerPuppet_id = nil
local grenade_tick_countdown = nil


registerForEvent("onUpdate", function(deltaTime)
    shouldDraw_graphics = false
    shouldDraw_config = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        --Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    shouldDraw_graphics = true

    o:Tick(deltaTime)
    map:Tick()

    o:GetPlayerInfo()       -- this populates o.pos, which is expected to be populated by other functions

    o:GetInWorkspot()
    if not o.isInWorkspot then      -- returns true if in a vehicle (or menu?)
        shouldDraw_config = true      -- don't want a hung progress bar while in menu or driving

        if shouldDraw_config and const.shouldShowDebugWindow then
            PopulateDebug(debug, o, keys)
        end

        harvester.Tick(o, keys, map, scanner_player)

        keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current
    end

    -- Obstacles needs more work, probably never finish it
    --nono_squares.Tick(o)        -- doing this before scanner so that square merging isn't done in the same frame as scanner's ray casts
    --scanner_obstacles:Tick()

    orb_pool.Tick(o, scanner_orbs, deltaTime)

    debug_render_screen.CallFrom_onUpdate(deltaTime)




    if ownerPuppet_id then
        print("update grenade a")

        if grenade_tick_countdown > 0 then
            print("update grenade b")
            grenade_tick_countdown = grenade_tick_countdown - 1

        else
            print("update grenade c")

            local ownerPuppet = Game.FindEntityByID(ownerPuppet_id)
            local item = Game.GetTransactionSystem():GetItemInSlot(ownerPuppet, "AttachmentSlots.GrenadeRight")

            if not item then
                print("npc doesn't have a grenade")
                do return end
            end

            local throwAngle = 45
            local targetPosition = GetPlayer():GetWorldPosition()

            local launchParams = gameprojectileLaunchParams.new()
            launchParams.launchMode = gameprojectileELaunchMode.FromVisuals
            launchParams.logicalPositionProvider = IPositionProvider.CreateEntityPositionProvider(item)
            launchParams.logicalOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(nil, "", ownerPuppet)
            launchParams.visualPositionProvider = IPositionProvider.CreateEntityPositionProvider(item)
            launchParams.visualOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(nil, "", item)
            launchParams.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(ownerPuppet)

            local launchEvent = gameprojectileSetUpAndLaunchEvent.new()
            launchEvent.lerpMultiplier = 15
            launchEvent.owner = ownerPuppet
            launchEvent.launchParams = launchParams
            launchEvent.trajectoryParams = ParabolicTrajectoryParams.GetAccelTargetAngleParabolicParams(Vector4.new(0.00, 0.00, -9.8, 0.00), targetPosition,  throwAngle, 20)

            print("update grenade d")

            item:QueueEvent(launchEvent)

            print("update grenade e")

            Game.GetTransactionSystem():RemoveItemFromSlot(ownerPuppet, "AttachmentSlots.GrenadeRight", false)

            print("update grenade f")

            ownerPuppet_id = nil
            grenade_tick_countdown = nil
        end

        print("update grenade g")
    end

end)

registerForEvent("onOverlayOpen", function()
    isCETOpen = true
end)
registerForEvent("onOverlayClose", function()
    isCETOpen = false
end)

registerHotkey("NekhraosFaeries_ScanAllObjecs", "Scan All Objects", function()
    local found, entities = prototype_scanning.GetAllObjects()

    if found and entities then
        print("found: " .. tostring(#entities))

        for _, entity in ipairs(entities) do
            prototype_scanning.DebugVisual_Entity(entity)
        end

    else
        print("nothing found")
    end
end)
registerHotkey("NekhraosFaeries_ScanHarvestableObjecs", "Scan Harvestable Objects", function()
    local found, entities = prototype_scanning.GetAllObjects()

    local count = 0

    if found and entities then
        for _, entity in ipairs(entities) do
            if prototype_scanning.DebugVisual_Entity_Harvestable(entity) then
                count = count + 1
            end
        end
    end

    print("found count: " .. tostring(count))
end)
registerHotkey("NekhraosFaeries_ScanIntoMap", "Scan Into Map", function()
    local found, entities = prototype_scanning.GetAllObjects()

    if found and entities then
        for _, entity in ipairs(entities) do
            scanner_util.AddToMap(map, entity, const)
        end
    end
end)

registerHotkey("NekhraosFaeries_ObstacleScan", "Obstacle Scan", function()
    scanner_obstacles:TEST_Scan2(true)
end)
registerHotkey("NekhraosFaeries_VisualizeObstacleVolume", "Visualize Obstacle Volume", function()
    local obstacle_util = require "orb/swarm_obstacles"

    o:GetPlayerInfo()
    local pos, look_dir = o:GetCrosshairInfo()
    local center = AddVectors(pos, MultiplyVector(look_dir, 2))

    local normal = Vector4.new(0, 0, 1, 1)

    local player_pos = AddVectors(center, Negate(normal))       -- choose a point underneath so all tests will be behind the plane

    local radius = 1

    local obstacles = settings_util.Obstacles()
    local limits = settings_util.Limits()


    -- draw a circle with radius 1
    debug_render_screen.Add_Circle(center, normal, radius, nil, "FFF")

    debug_render_screen.Add_Dot(player_pos, nil, "FF0")

    -- draw a bunch of sample dots with color showing accel
    -- only need to do points in 2D, and only need half (results can be mirrored, even rotated radially to get 3D)

    local num_steps = 144

    for x = 0, num_steps, 1 do
        for z = 0, num_steps, 1 do
            local offset_x = GetScaledValue(0, radius * obstacles.max_radiusmult, 0, num_steps, x)
            local offset_z = GetScaledValue(0, radius * obstacles.max_radiusmult, 0, num_steps, z)

            local test_point = Vector4.new(center.x + offset_x, center.y, center.z + offset_z, 1)

            local accel_x, accel_y, accel_z, used = obstacle_util.TEST_ProcessPoint(test_point, player_pos, center, normal, radius, obstacles, limits)

            if used then
                local accel = Vector4.new(accel_x, accel_y, accel_z, 1)

                local percent = GetVectorLength(accel) / limits.max_accel

                local color = Color_PercentToHex(percent) .. "FFFFFF"

                debug_render_screen.Add_Dot(test_point, nil, color)

                if x ~= 0 then
                    debug_render_screen.Add_Dot(Vector4.new(center.x + -offset_x, center.y, center.z + offset_z, 1), nil, color)
                end
            else
                --debug_render_screen.Add_Dot(test_point, nil, "8000")
            end
        end
    end
end)

registerHotkey("NekhraosFaeries_ClearVisuals", "Clear Visuals", function()
    debug_render_screen.Clear()
end)

registerHotkey("NekhraosFaeries_SpawnOrb", "Spawn Orb", function()
    o:GetPlayerInfo()
    local pos, look_dir = o:GetCrosshairInfo()

    pos = AddVectors(pos, MultiplyVector(look_dir, 2))

    orb_pool.Add({ pos = pos }, o, Vector4.new(0, 0, 0, 1), map)
end)
registerHotkey("NekhraosFaeries_ClearOrbs", "Clear Orbs", function()
    orb_pool.Clear()
end)

registerHotkey("NekhraosFaeries_LoadConfigs", "load configs from json", function()
    orb_pool.TEST_OverwriteConfigs_FromJSON()
end)


-- registerHotkey("NekhraosFaeries_Grenade1", "Grenade 1", function()
--     o:GetPlayerInfo()
--     local pos, look_dir = o:GetCrosshairInfo()

--     local spawn_point = AddVectors(pos, MultiplyVector(look_dir, 1))

--     prototype_grenades.SpawnGrenade(spawn_point)
-- end)
-- registerHotkey("NekhraosFaeries_Grenade2", "Grenade 2", function()
--     o:GetPlayerInfo()
--     local pos, look_dir = o:GetCrosshairInfo()

--     local from = AddVectors(pos, MultiplyVector(look_dir, 0.5))
--     local to = AddVectors(pos, MultiplyVector(look_dir, 4))

--     prototype_grenades.ThrowStraight(from, to)
-- end)
-- registerHotkey("NekhraosFaeries_Grenade4", "Grenade 4", function()
--     local player = Game.GetPlayer()
--     local transaction = Game.GetTransactionSystem()

--     -- all nil
--     local names =
--     {
--         "GrenadeCore",
--         "GrenadeDelivery",
--         "GrenadeLeft",
--         "GrenadeRight",
--         "GrenadeSlots",
--     }

--     for _, name in ipairs(names) do
--         local full_name = "AttachmentSlots." .. name

--         print(full_name)

--         local item = transaction:GetItemInSlot(player, TweakDBID.new(full_name))

--         print(tostring(item))
--     end
-- end)

registerHotkey("NekhraosFaeries_Grenade3", "Grenade 3", function()
    local player = Game.GetPlayer()
    local transaction = Game.GetTransactionSystem()

    local item_object = transaction:GetItemInSlot(player, TweakDBID.new("AttachmentSlots.WeaponRight"))        -- only returns something if weapon isn't holstered
    --local item_object = transaction:GetItemInSlot(player, TweakDBID.new("AttachmentSlots.Consumable"))     -- always nil

    if not item_object then
        print("nil")
        do return end

    elseif not IsDefined(item_object) then
        print("not defined")
        do return end
    end

    local item_data = item_object:GetItemData()
    if item_data:GetItemType().value == "Gad_Grenade" then
        print("not a grenade")
        do return end

    end

    print("grenade")


    --------------------------------------


    local pos, look_dir = o:GetCrosshairInfo()

    local from = AddVectors(pos, MultiplyVector(look_dir, 4))
    local to = AddVectors(pos, MultiplyVector(look_dir, 6))

    local orientation = GetRandomRotation()

    print("Grenade3: a")

    -- set up event
    local launchEvent = gameprojectileSetUpAndLaunchEvent.new()
    launchEvent.owner = player

    print("Grenade3: b")

    -- launchEvent.launchParams.logicalPositionProvider = entIPositionProvider.CreateStaticPositionProvider(ToWorldPosition(from))
    -- launchEvent.launchParams.logicalOrientationProvider = entIOrientationProvider.CreateStaticOrientationProvider(orientation)

    launchEvent.launchParams.logicalPositionProvider = entIPositionProvider.CreateEntityPositionProvider(item_object)
    launchEvent.launchParams.logicalOrientationProvider = entIOrientationProvider.CreateEntityOrientationProvider(nil, "", item_object)

    print("Grenade3: c")

    launchEvent.launchParams.visualPositionProvider = entIPositionProvider.CreateEntityPositionProvider(item_object)
    launchEvent.launchParams.visualOrientationProvider = entIOrientationProvider.CreateEntityOrientationProvider(nil, "", item_object)

    print("Grenade3: d")

    -- I think this is to get the initial velocity.  There doesn't seem to be any static providers like above
    -- This takes gamePuppet.  These are the only classes that seem available
    --  NPCPuppet extends ScriptedPuppet
    --  PlayerPuppet extends ScriptedPuppet
    --      ScriptedPuppet extends gamePuppet
    --          gamePuppet
    --
    -- entIVelocityProvider implements IScriptable, has one function: CalculateVelocity()
    --  CalculateVelocity has no in/out params, IScriptable doesn't have a velocity property
    launchEvent.launchParams.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(player)

    print("Grenade3: e")

    launchEvent.lerpMultiplier = 15.00





    -- this is in base bullet's initialize
    -- protected cb func OnProjectileInitialize(eventData: ref<gameprojectileSetUpEvent>) -> Bool {
    --     let linearParams: ref<LinearTrajectoryParams> = new LinearTrajectoryParams();
    --     linearParams.startVel = this.m_startVelocity;
    --     linearParams.acceleration = this.m_acceleration;
    --     this.m_projectileComponent.AddLinear(linearParams);
    --     this.m_projectileComponent.ToggleAxisRotation(true);
    --     this.m_projectileComponent.AddAxisRotation(new Vector4(0.00, 1.00, 0.00, 0.00), 100.00);
    -- }



    -- I wonder if grenades only work with certain trajectory params

    local trajectoryParams = gameprojectileLinearTrajectoryParams.new()
    trajectoryParams.startVel = 6
    trajectoryParams.acceleration = 4







    print("Grenade3: f")

    launchEvent.trajectoryParams = trajectoryParams

    print("Grenade3: g")

    item_object:QueueEvent(launchEvent)

    print("Grenade3: h")

end)



-- Nothing is happening.  Maybe that only works for NPCs?
--  Try to find the code for player grenade
--  Use some of the compares from the event listeners
--  Call something from update that scans for npcs, apply filter, draw dot if they can throw a grenade

-- May want to give up on grenade for a bit and try gun projectiles

registerHotkey("NekhraosFaeries_Grenade5", "Grenade 5", function()
    prototype_grenades3.ThrowFromSlot(o)
end)
registerHotkey("NekhraosFaeries_DropGrenade", "Drop Grenade", function()
    prototype_grenades3.DropFromSlot(o)
end)

registerHotkey("NekhraosFaeries_Grenade6", "Grenade 6", function()
    print("grenade6 a")

    local player = Game.GetPlayer()

    -- local targetting = Game.GetTargetingSystem()
    -- local crosshairPosition, crosshairForward = targetting:GetDefaultCrosshairData(player)    
    local pos, look_dir = o:GetCrosshairInfo()

    --return Vector4.new(vector1.x + vector2.x, vector1.y + vector2.y, vector1.z + vector2.z, 1)
    --return Vector4.new(vector.x * constant, vector.y * constant, vector.z * constant, 1)
    local to = AddVectors(pos, MultiplyVector(look_dir, 3))


    --local item = Game.GetTransactionSystem():GetItemInSlot(player, "AttachmentSlots.GrenadeRight")
    local item = Game.GetTransactionSystem():GetItemInSlot(player, TweakDBID.new("AttachmentSlots.WeaponRight"))        -- only returns something if weapon isn't holstered

    if not item then
        print("no item in right slot - be sure your weapon isn't holstered")
        do return end

    elseif not IsDefined(item) then
        print("item isn't defined")
        do return end
    end

    local item_data = item:GetItemData()

    --TODO: handle other types of projectiles
    if item_data:GetItemType().value == "Gad_Grenade" then
        print("item isn't a grenade")
        do return end
    end

    if item:IsClientSideOnlyGadget() then
        print("ClientSideOnlyGadget")
        do return end
    end


    print("grenade6 b")

    local throwAngle = 45
    local targetPosition = to

    local launchParams = gameprojectileLaunchParams.new()
    launchParams.launchMode = gameprojectileELaunchMode.FromVisuals
    launchParams.logicalPositionProvider = IPositionProvider.CreateEntityPositionProvider(item)
    launchParams.logicalOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(nil, "", player)
    launchParams.visualPositionProvider = IPositionProvider.CreateEntityPositionProvider(item)
    launchParams.visualOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(nil, "", item)
    launchParams.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(player)

    local launchEvent = gameprojectileSetUpAndLaunchEvent.new()
    launchEvent.lerpMultiplier = 15
    launchEvent.owner = player
    launchEvent.launchParams = launchParams
    launchEvent.trajectoryParams = ParabolicTrajectoryParams.GetAccelTargetAngleParabolicParams(Vector4.new(0.00, 0.00, -9.8, 0.00), targetPosition, throwAngle, 20)

    print("grenade6 c")

    item:QueueEvent(launchEvent)

    print("grenade6 d")

    --Game.GetTransactionSystem():RemoveItemFromSlot(player, "AttachmentSlots.GrenadeRight", false)
end)

registerHotkey("NekhraosFaeries_Grenade7", "Grenade 7", function()
    print("grenade7 a")

    -- Find npc
    local searchQuery = TSQ_ALL()
    searchQuery.maxDistance = 12

    local found, entities = o:GetTargetEntities(searchQuery)

    print("grenade7 b")

    local ownerPuppet = nil
    if found then
        for _, entity in ipairs(entities) do
            if entity:IsNPC() and not entity:IsDead() and not entity:IsDefeated() then
                ownerPuppet = entity
                do break end
            end
        end
    end

    if not ownerPuppet then
        print("didn't find npc")
        do return end
    end

    print("grenade7 c")

    -- Give npc a grenade
    local cmd = NewObject("AIEquipCommand")
    cmd.slotId = TweakDBID.new("AttachmentSlots.GrenadeRight")
    cmd.itemId = TweakDBID.new("Items.GrenadeFragRegular")
    cmd.failIfItemNotFound = false
    cmd.durationOverride = true
    ownerPuppet:GetAIControllerComponent():SendCommand(cmd)

    print("grenade7 d")

    --TODO: probably need to wait a tick

    --ownerPuppet = Game.FindEntityByID(newNPC)
    local item = Game.GetTransactionSystem():GetItemInSlot(ownerPuppet, "AttachmentSlots.GrenadeRight")

    if not item then
        print("npc doesn't have a grenade")
        do return end
    end

    local throwAngle = 45
    local targetPosition = GetPlayer():GetWorldPosition()

    local launchParams = gameprojectileLaunchParams.new()
    launchParams.launchMode = gameprojectileELaunchMode.FromVisuals
    launchParams.logicalPositionProvider = IPositionProvider.CreateEntityPositionProvider(item)
    launchParams.logicalOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(nil, "", ownerPuppet)
    launchParams.visualPositionProvider = IPositionProvider.CreateEntityPositionProvider(item)
    launchParams.visualOrientationProvider = IOrientationProvider.CreateEntityOrientationProvider(nil, "", item)
    launchParams.ownerVelocityProvider = MoveComponentVelocityProvider.CreateMoveComponentVelocityProvider(ownerPuppet)

    local launchEvent = gameprojectileSetUpAndLaunchEvent.new()
    launchEvent.lerpMultiplier = 15
    launchEvent.owner = ownerPuppet
    launchEvent.launchParams = launchParams
    launchEvent.trajectoryParams = ParabolicTrajectoryParams.GetAccelTargetAngleParabolicParams(Vector4.new(0.00, 0.00, -9.8, 0.00), targetPosition,  throwAngle, 20)

    print("grenade7 e")

    item:QueueEvent(launchEvent)

    print("grenade7 f")

    Game.GetTransactionSystem():RemoveItemFromSlot(ownerPuppet, "AttachmentSlots.GrenadeRight", false)

    print("grenade7 g")

end)

registerHotkey("NekhraosFaeries_Grenade8", "Grenade 8", function()
    print("grenade8 a")

    -- Find npc
    local searchQuery = TSQ_ALL()
    searchQuery.maxDistance = 12

    local found, entities = o:GetTargetEntities(searchQuery)

    print("grenade8 b")

    local ownerPuppet = nil
    if found then
        for _, entity in ipairs(entities) do
            if entity:IsNPC() and not entity:IsDead() and not entity:IsDefeated() then
                ownerPuppet = entity
                do break end
            end
        end
    end

    if not ownerPuppet then
        print("didn't find npc")
        do return end
    end

    print("grenade8 c")

    -- Give npc a grenade
    local cmd = NewObject("AIEquipCommand")
    cmd.slotId = TweakDBID.new("AttachmentSlots.GrenadeRight")
    cmd.itemId = TweakDBID.new("Items.GrenadeFragRegular")
    cmd.failIfItemNotFound = false
    cmd.durationOverride = true
    ownerPuppet:GetAIControllerComponent():SendCommand(cmd)

    print("grenade8 d")

    ownerPuppet_id = ownerPuppet:GetEntityID()
    grenade_tick_countdown = 3      -- let the update fire a few times before throwing

    print("grenade8 e")
end)


-- test to spawn an object, then call targeting sytem from its perspective


registerForEvent("onDraw", function()
    if isShutdown or not isLoaded then
        do return end
    end

    -- if isCETOpen then
    --     DrawConfig()
    -- end

    if shouldDraw_config and const.shouldShowDebugWindow then
        DrawDebugWindow(debug, vars_ui)
    end

    if shouldDraw_graphics then
        debug_render_screen.CallFrom_onDraw()
    end
end)

----------------------------------- Private Methods -----------------------------------

function this.SetupDebugCategories()
    debug_render_screen.DefineCategory(debug_categories.text2D_2sec, "BA50534A", "FFF", 2, nil, nil, nil, 0.25, 0.5)
end