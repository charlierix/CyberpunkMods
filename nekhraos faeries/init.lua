require "core/color"
require "core/gameobj_accessor"
require "core/math_basic"
require "core/math_shapes"
require "core/math_vector"
require "core/sticky_list"
require "core/util"

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
local shouldDraw = false

local o = nil                           -- This is a class that wraps access to Game.xxx
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

    o = GameObjectAccessor:new(wrappers)
    keys = Keys:new()
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
    shouldDraw = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        --Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    o:Tick(deltaTime)
    map:Tick()

    local in_vehicle = false
    o:GetInWorkspot()
    if o.isInWorkspot then
        in_vehicle = true
    end

    shouldDraw = true       -- don't want a hung progress bar while in menu or driving

    if const.shouldShowDebugWindow then
        PopulateDebug(debug, keys)
    end



    -- Probably want to make a dedicated harvester class
    -- Watch for crouching, f held longer than quarter second, then start looking around for bodies
    --  botch the job if they aren't looking lower than horizontal the whole time
    --  botch the job if they get more than halfway and stop prematurely



    keys:Tick()     --NOTE: This must be after everything is processed, or prev will always be the same as current

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


registerHotkey("NekhraosFaeries_ClearVisuals", "Clear Visuals", function()
    debug_render_screen.Clear()
end)

registerForEvent("onDraw", function()
    if isShutdown or not isLoaded or not shouldDraw then
        do return end
    end

    if const.shouldShowDebugWindow then
        DrawDebugWindow(debug, vars_ui, const)
    end

    debug_render_screen.CallFrom_onDraw()
end)

----------------------------------- Private Methods -----------------------------------

function this.SetupDebugCategories()
    debug_render_screen.DefineCategory(debug_categories.text2D_2sec, "BA50534A", "FFF", 2, nil, nil, nil, 0.25, 0.5)
end