require "core/color"
require "core/gameobj_accessor"
require "core/math_basic"
require "core/math_shapes"
require "core/math_vector"
require "core/perlin"
require "core/sticky_list"
require "core/util"

entity_helper = require "data/entity_helper"
require "data/map"
require "data/scanner_orbs"
require "data/scanner_player"

require "debug/debug_code"
require "debug/debug_render_logger"
debug_render_screen = require "debug/debug_render_screen"
require "debug/reporting"

extern_json = require "external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

prototype_scanning = require "prototype/scanning"

harvester = require "processing/harvester"
require "processing/orb"
require "processing/orb_ai"
require "processing/orb_audiovisual"
orb_pool = require "processing/orb_pool"
require "processing/orb_swarm"

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
    map = Map:new(o)
    scanner_player = Scanner_Player:new(o, map)
    scanner_orbs = Scanner_Orbs:new(o, map)

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

    orb_pool.Tick(o, deltaTime)

    debug_render_screen.CallFrom_onUpdate(deltaTime)
end)


registerHotkey("NekhraosFaeries_IsCrouching", "Is Crouching", function()
    debug_render_screen.Clear()

    local text = nil
    if Game.GetPlayer().inCrouch then
        text = "crouching"
    else
        text = "standing up"
    end

    debug_render_screen.Add_Text2D(nil, nil, text, debug_categories.text2D_2sec)
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

registerHotkey("NekhraosFaeries_Perlin", "Perlin", function()
    local max_time = 3
    local count = 144

    local log = DebugRenderLogger:new(true)

    for i = 1, 12, 1 do
        log:NewFrame()

        local start = GetRandomVector_Spherical(0, 12)
        local dir = GetRandomVector_Spherical(0, 3)

        for t = 1, count, 1 do
            local time = max_time * ((t-1) / count)

            local perlin = Perlin(start.x + dir.x * time, start.y + dir.y * time, start.z + dir.z * time)

            log:Add_Dot(Vector4.new(time, perlin, 0, 1))

            --print(tostring(time) .. " | " .. tostring(start.x + dir.x * time) .. ", " .. tostring(start.y + dir.y * time) .. ", " .. tostring(start.z + dir.z * time) .. " | " .. tostring(perlin))
        end
    end

    log:Save("perlin")
end)


-- test to spawn an object, then call targeting sytem from its perspective


registerHotkey("NekhraosFaeries_ClearVisuals", "Clear Visuals", function()
    debug_render_screen.Clear()
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded then
        do return end
    end

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