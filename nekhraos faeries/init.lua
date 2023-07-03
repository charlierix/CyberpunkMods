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


registerHotkey("NekhraosFaeries_Grenade1", "Grenade 1", function()
    o:GetPlayerInfo()
    local pos, look_dir = o:GetCrosshairInfo()

    local spawn_point = AddVectors(pos, MultiplyVector(look_dir, 1))

    prototype_grenades.SpawnGrenade(spawn_point)
end)
registerHotkey("NekhraosFaeries_Grenade2", "Grenade 2", function()
    o:GetPlayerInfo()
    local pos, look_dir = o:GetCrosshairInfo()

    local from = AddVectors(pos, MultiplyVector(look_dir, 0.5))
    local to = AddVectors(pos, MultiplyVector(look_dir, 4))

    prototype_grenades.ThrowStraight(from, to)
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