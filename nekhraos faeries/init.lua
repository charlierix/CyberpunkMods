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
    map_body_type = CreateEnum("CorpseContainer", "NPC_Dead", "NPC_Defeated", "NPC_Alive"),

    shouldShowScreenDebug = true,      -- draws debug info in game
    shouldShowDebugWindow = false,      -- shows a window with extra debug info
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
    function wrappers.GetTargetingSystem() return Game.GetTargetingSystem() end     -- gametargetingTargetingSystem
    function wrappers.GetTargetParts(targetting, player, searchQuery) return targetting:GetTargetParts(player, searchQuery) end

    o = GameObjectAccessor:new(wrappers)
    keys = Keys:new(o)
    map = Map:new(o, const)
    scanner_player = Scanner_Player:new(o, map, const)
    scanner_orbs = Scanner_Orbs:new(o, map, const)

    this.SetupDebugCategories()
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    --this.ClearObjects()
end)

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

    orb_pool.Tick(o, scanner_orbs, deltaTime)

    debug_render_screen.CallFrom_onUpdate(deltaTime)
end)

registerForEvent("onOverlayOpen", function()
    isCETOpen = true
end)
registerForEvent("onOverlayClose", function()
    isCETOpen = false
end)


-- I think this is a dead end.  The best I saw was using depth query through a person to model a grenade fragment
-- I've tried various values and at best get an innacurate ray cast.  I'm not sure what this is for (maybe a raycast that has thickness?)
registerHotkey("NekhraosFaeries_GeometryDescriptionQuery", "GeometryDescriptionQuery", function()

--TODO: Make a test button comparing this with straight raycasts
-- protected final func GetDistanceFromFloor() -> Float {
--     let currentPosition: Vector4;
--     let distanceFromFloor: Float;
--     let geometryDescription: ref<GeometryDescriptionQuery>;
--     let geometryDescriptionResult: ref<GeometryDescriptionResult>;
--     let staticQueryFilter: QueryFilter;
--     QueryFilter.AddGroup(staticQueryFilter, n"Static");
--     currentPosition = this.GetWorldPosition();
--     geometryDescription = new GeometryDescriptionQuery();
--     geometryDescription.refPosition = currentPosition;
--     geometryDescription.refDirection = new Vector4(0.00, 0.00, -1.00, 0.00);
--     geometryDescription.filter = staticQueryFilter;
--     geometryDescription.primitiveDimension = new Vector4(0.10, 0.10, 0.20, 0.00);
--     geometryDescriptionResult = GameInstance.GetSpatialQueriesSystem(this.GetGame()).GetGeometryDescriptionSystem().QueryExtents(geometryDescription);
--     if NotEquals(geometryDescriptionResult.queryStatus, worldgeometryDescriptionQueryStatus.OK) {
--       return -1.00;
--     };
--     distanceFromFloor = AbsF(geometryDescriptionResult.distanceVector.Z);
--     return distanceFromFloor;
--   }

-- public final static func GetDistanceToGround(const scriptInterface: ref<StateGameScriptInterface>) -> Float {
--     let distanceToGround: Float;
--     let geometryDescription: ref<GeometryDescriptionQuery>;
--     let geometryDescriptionResult: ref<GeometryDescriptionResult>;
--     let queryFilter: QueryFilter;
--     let currentPosition: Vector4 = DefaultTransition.GetPlayerPosition(scriptInterface);
--     QueryFilter.AddGroup(queryFilter, n"Static");
--     QueryFilter.AddGroup(queryFilter, n"Terrain");
--     QueryFilter.AddGroup(queryFilter, n"PlayerBlocker");
--     geometryDescription = new GeometryDescriptionQuery();
--     geometryDescription.AddFlag(worldgeometryDescriptionQueryFlags.DistanceVector);
--     geometryDescription.filter = queryFilter;
--     geometryDescription.refPosition = currentPosition;
--     geometryDescription.refDirection = new Vector4(0.00, 0.00, -1.00, 0.00);
--     geometryDescription.primitiveDimension = new Vector4(0.50, 0.10, 0.10, 0.00);
--     geometryDescription.maxDistance = 100.00;
--     geometryDescription.maxExtent = 100.00;
--     geometryDescription.probingPrecision = 10.00;
--     geometryDescription.probingMaxDistanceDiff = 100.00;
--     geometryDescriptionResult = scriptInterface.GetSpatialQueriesSystem().GetGeometryDescriptionSystem().QueryExtents(geometryDescription);
--     if Equals(geometryDescriptionResult.queryStatus, worldgeometryDescriptionQueryStatus.NoGeometry) || NotEquals(geometryDescriptionResult.queryStatus, worldgeometryDescriptionQueryStatus.OK) {
--       return -1.00;
--     };
--     distanceToGround = AbsF(geometryDescriptionResult.distanceVector.Z);
--     return distanceToGround;
--   }


    local settings = this.DeserializeJSON("!configs/geometryquery.json")

    local eye_pos, look_dir = o:GetCrosshairInfo()

    local query_system = Game.GetSpatialQueriesSystem()
    local geometry_system = query_system:GetGeometryDescriptionSystem()

    local filter = QueryFilter.AddGroup("Static")
    filter.mask2 = filter.mask2 + QueryFilter.AddGroup("Terrain").mask2

    --local filter = QueryFilter.All()

    -- this may not be the correct way to instantiate, just guessing
    local query = GeometryDescriptionQuery.new()
    query.refPosition = eye_pos
    query.refDirection = look_dir
    query.filter = filter

    -- I'm guessing this is the thickness of the ray?  The GetIsOnGround sets direction to 0,0,-1 and primitiveDimension to 0.1,0.1,0.2, but others
    -- leave it 0.1,0.1,0.1 and set maxDistance
    --
    -- Maybe it's the min size of object to return
    --query.primitiveDimension = Vector4.new(0.1, 0.1, 0.1, 1)
    --query.primitiveDimension = Vector4.new(1, 1, 1, 1)      -- when it's this larger thickness, the search seems to find things farther away from the ray (but nearer to from point?)
    query.primitiveDimension = Vector4.new(settings.primitiveDimension_X, settings.primitiveDimension_Y, settings.primitiveDimension_Z, 1)


    --TODO: play with different values to try to get the result props to be something other than none

    -- maxDistance and probingPrecision are fairly self explanatory
    -- Not sure what maxExtent and probingMaxDistanceDiff are.  Most uses are just the same value as maxDistance
    query.maxDistance = settings.maxDistance;
    query.maxExtent = settings.maxExtent;
    query.probingPrecision = settings.probingPrecision;
    query.probingMaxDistanceDiff = settings.probingMaxDistanceDiff;


    local result = geometry_system:QueryExtents(query)

    debug_render_screen.Add_Line(eye_pos, AddVectors(eye_pos, MultiplyVector(look_dir, 24)), nil, "888")

    -- enum worldgeometryDescriptionQueryStatus
    -- {
    --    OK = 0,
    --    NoGeometry = 1,
    --    UpVectorSameAsDirection = 2
    -- }

    if result.queryStatus == worldgeometryDescriptionQueryStatus.OK then
    --if result.queryStatus == 0 then
        print("ok")
        --https://nativedb.red4ext.com/worldgeometryDescriptionResult


        ------------ directions ------------
        --left
        --right
        --top
        --depth
        --up
        --down
        --behind


        ------------ probe status ------------
        -- enum worldgeometryProbingStatus
        -- {
        --    None = 0,
        --    StillInObstacle = 1,
        --    GeometryDiverged = 2,
        --    Failure = 3
        -- }

        -- These are all coming back none

        --leftExtentStatus
        print("leftExtentStatus: " .. tostring(result.leftExtentStatus))

        --rightExtentStatus
        print("rightExtentStatus: " .. tostring(result.rightExtentStatus))

        --obstacleDepthStatus
        print("obstacleDepthStatus: " .. tostring(result.obstacleDepthStatus))

        --upExtentStatus
        print("upExtentStatus: " .. tostring(result.upExtentStatus))

        --downExtentStatus
        print("downExtentStatus: " .. tostring(result.downExtentStatus))

        --topTestStatus
        print("topTestStatus: " .. tostring(result.topTestStatus))
    
        --behindTestStatus
        print("behindTestStatus: " .. tostring(result.behindTestStatus))


        ------------ vector4 ------------

        local hit_point = AddVectors(eye_pos, result.distanceVector)
        print("hit_point: " .. this.vec_str2(hit_point))

        --distanceVector
        debug_render_screen.Add_Line(eye_pos, hit_point, nil, "DDD")
        debug_render_screen.Add_Text(hit_point, "distanceVector", nil, "4DDD", "FFF")

        --collisionNormal
        debug_render_screen.Add_Line(hit_point, AddVectors(hit_point, result.collisionNormal), nil, "8FFF")


        -- Check the corresponding enum before looking at these points
        -- If it's none, these will just be zeros

        --leftHandData.grabPointStart
        --leftHandData.grabPointEnd
        -- local left_start = AddVectors(hit_point, result.leftHandData.grabPointStart)
        -- debug_render_screen.Add_Dot(left_start, nil, "F88")
        -- debug_render_screen.Add_Line(left_start, AddVectors(hit_point, result.leftHandData.grabPointEnd), nil, "F88")
        -- debug_render_screen.Add_Text(left_start, "leftHandData", nil, "4F88", "FFF")
        print("leftHandData.grabPointStart: " .. this.vec_str2(result.leftHandData.grabPointStart))
        print("leftHandData.grabPointEnd: " .. this.vec_str2(result.leftHandData.grabPointEnd))

        --rightHandData.grabPointStart
        --rightHandData.grabPointEnd
        -- local right_start = AddVectors(hit_point, result.rightHandData.grabPointStart)
        -- debug_render_screen.Add_Dot(right_start, nil, "F00")
        -- debug_render_screen.Add_Line(right_start, AddVectors(hit_point, result.rightHandData.grabPointEnd), nil, "F00")
        -- debug_render_screen.Add_Text(right_start, "rightHandData", nil, "4F00", "FFF")
        print("rightHandData.grabPointStart: " .. this.vec_str2(result.rightHandData.grabPointStart))
        print("rightHandData.grabPointEnd: " .. this.vec_str2(result.rightHandData.grabPointEnd))

        --topPoint
        --topNormal
        -- debug_render_screen.Add_Dot(result.topPoint, nil, "0F0")
        -- debug_render_screen.Add_Line(result.topPoint, AddVectors(result.topPoint, result.topNormal), nil, "80F0")
        -- debug_render_screen.Add_Text(result.topPoint, "topPoint", nil, "40F0", "FFF")
        print("topPoint: " .. this.vec_str2(result.topPoint))
       

        --behindPoint
        --behindNormal
        print("behindPoint: " .. this.vec_str2(result.behindPoint))


        ------------ float ------------

        --obstacleDepth
        print("obstacleDepth: " .. tostring(result.obstacleDepth))

        --upExtent
        print("upExtent: " .. tostring(result.upExtent))

        --downExtent
        print("downExtent: " .. tostring(result.downExtent))

        --topExtent
        print("topExtent: " .. tostring(result.topExtent))






    else
        print("not ok: " .. tostring(result.queryStatus))
        --print(tostring(type(result.queryStatus)))     -- the type is userdata
    end
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

function this.vec_str2(vector)
    return tostring(vector.x) .. ", " .. tostring(vector.y) .. ", " .. tostring(vector.z)
    
end

-- Small wrapper to file.open and json.decode
-- Returns
--  object, nil
--  nil, errMsg
function this.DeserializeJSON(filename)
    local handle = io.open(filename, "r")
    local json = handle:read("*all")

    local sucess, retVal = pcall(
        function(j) return extern_json.decode(j) end,
        json)

    if sucess then
        return retVal, nil
    else
        return nil, tostring(retVal)      -- when pcall has an error, the second value returned is the error message, otherwise it't the successful return value.  It should already be a sting, but doing a tostring just to be safe
    end
end