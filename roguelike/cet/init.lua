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

require "!src/core/color"
require "!src/core/gameobj_accessor"
require "!src/core/lists"
require "!src/core/math_basic"
require "!src/core/math_raycast"
require "!src/core/math_vector"
require "!src/core/math_yaw"
require "!src/core/strings"
require "!src/core/util"

require "!src/data/cap_strings"
require "!src/data/collection_boss_area"
require "!src/data/collection_spawn_point"
require "!src/data/logging"
require "!src/data/util_data"
require "!src/data/validations"

require "!src/debug/debug_code"
require "!src/debug/reporting"

require "!src/spawning/spawn_tests.lua"

require "!src/ui/drawing"

extern_json = require "!src/external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

local this = {}

--------------------------------------------------------------------
---                          Constants                           ---
--------------------------------------------------------------------

local const =
{
    modded_parkour = CreateEnum(
        "none",             -- This point is accessible without any mods installed (also don't need the thruster boots to get down)
        "light",            -- It will take a little modded effort to get from/to (mods like: wall hang, grappling hook)
        "heavy",            -- This is basically on top of a skyscraper that will need full flight abilities
        "unreachable"),     -- The only way is teleport (freefly doesn't count)

    filetype = CreateEnum("file", "directory"),     -- this is the .type property of items when iterating the dir fuction

    types = CreateEnum("string", "number", "table"),

    shouldShowDebugWindow = false
}

--------------------------------------------------------------------
---                        Current State                         ---
--------------------------------------------------------------------

local isShutdown = true
local isLoaded = false
local shouldDraw = false
local shouldShowConfig = false
local isConfigRepress = false

local o     -- This is a class that wraps access to Game.xxx

local debug = {}

local vars =
{
    --spawn_points      -- This holds spawn points from the corresponding folder.  Can return random spawn according to position/radius search params
    --boss_areas        -- same type of collection as spawn_points, but for boss areas
}

local vars_ui =
{
}

--------------------------------------------------------------------

registerForEvent("onInit", function()
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
    ClearDeserializeErrorLogs()

    local wrappers = {}
    function wrappers.GetPlayer() return Game.GetPlayer() end
    function wrappers.Player_GetPos(player) return player:GetWorldPosition() end
    function wrappers.Player_GetVel(player) return player:GetVelocity() end
    function wrappers.Player_GetYaw(player) return player:GetWorldYaw() end
    function wrappers.Player_GetWorldTransform(player) return player:GetWorldTransform() end
    function wrappers.GetWorkspotSystem() return Game.GetWorkspotSystem() end
    function wrappers.Workspot_InWorkspot(workspot, player) return workspot:IsActorInWorkspot(player) end
    function wrappers.GetCameraSystem() return Game.GetCameraSystem() end
    function wrappers.Camera_GetForwardRight(camera) return camera:GetActiveCameraForward(), camera:GetActiveCameraRight() end
    function wrappers.GetTeleportationFacility() return Game.GetTeleportationFacility() end
    function wrappers.Teleport(teleport, player, pos, yaw) return teleport:Teleport(player, pos, EulerAngles.new(0, 0, yaw)) end
    function wrappers.GetSenseManager() return Game.GetSenseManager() end
    function wrappers.IsPositionVisible(sensor, fromPos, toPos) return sensor:IsPositionVisible(fromPos, toPos) end
    --function wrappers.RayCast(player, from, to, staticOnly) return player:Roguelike_RayCast(from, to, staticOnly) end
    function wrappers.SetTimeDilation(timeSpeed) Game.SetTimeDilation(tostring(timeSpeed)) end      -- for some reason, it takes in string
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    --function wrappers.QueueSound(player, sound) player:Roguelike_QueueSound(sound) end
    --function wrappers.StopQueuedSound(player, sound) player:Roguelike_StopQueuedSound(sound) end

    o = GameObjectAccessor:new(wrappers)

    vars.spawn_points = Collection_SpawnPoint:new(const)
    vars.boss_areas = Collection_BossArea:new(const)
end)

registerForEvent("onShutdown", function()
    isShutdown = true
    this.ClearObjects()
end)

registerForEvent("onUpdate", function(deltaTime)
    shouldDraw = false
    if isShutdown or not isLoaded or IsPlayerInAnyMenu() then
        do return end
    end

    o:Tick(deltaTime)

    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        do return end
    end

    StopSound(o, vars)

    o:GetInWorkspot()
    if o.isInWorkspot then      -- in a vehicle
        do return end
    end

    shouldDraw = true       -- don't want a hung progress bar while in menu or driving

    if const.shouldShowDebugWindow then
        PopulateDebug(debug, o, vars)
    end
end)

registerHotkey("Roguelike_Tester_Teleports", "teleports", function()
    -- vars.spawn_points:EnsureLoaded()
    -- ReportTable(vars.spawn_points.spawn_points)

    -- print("no search criteria")

    local spawnPoint = vars.spawn_points:GetRandom()
    ReportTable(spawnPoint)


    -- print("24, -1, 3 | 30 | 50")

    -- local spawnPoint = vars.spawn_points:GetRandom(Vector4.new(24, -1, 3, 1), 30, 50, true)
    -- ReportTable(spawnPoint)




    -- print("-18, -12, 3 | 24 | 36")

    -- local spawnPoint = vars.spawn_points:GetRandom(Vector4.new(-18, -12, 3, 1), 24, 36, true)
    -- ReportTable(spawnPoint)



    --TODO: If non null, teleport there
    if spawnPoint then
        o:Teleport(spawnPoint.position, spawnPoint.yaw)
    end


end)

registerHotkey("Roguelike_Tester_NPC", "npc", function()

    --local path = "Character.q004_prostitute"      -- civilian
    local path = "Character.arr_valentinos_grunt2_ranged2_ajax_wa"      -- valentino enemy

    print("a")

    SpawnNPC_PreventionSpawnSystem(o, path)
    --SpawnNPC_exEntitySpawner(o, path)

    print("b")

end)

registerHotkey("Roguelike_Tester_BossAreas", "boss areas", function()

    print("a")

    vars.boss_areas:EnsureLoaded()

    ReportTable(vars.boss_areas.boss_areas)

    print("b")

end)

-- registerInput("Roguelike_TesterInput", "tester input", function(isDown)
-- end)

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
    --Transition_ToStandard(vars, const, debug, o)

    if o then
        o:Clear()
    end
end

--------------------------------------------------------------------

function TODO()

	-- Totems
	--	These would have a small radius around them that give some affect
	--		Heal
	--		Slowly lose health
	--
	-- Children would make good mobile totems
	--	Since they move randomly and are unaffected by everything, they would make good totems
	--	Use females as player buff / npc debuff, males as the opposite

	-- External Sites
	--	Create a discord server as a place for people to upload their stuff
	--	Provide a way for people to vote
	--	If it becomes popular, others could make their own nexus pages that are hand picked collections
	
	-- Signs
	--	Give items an optional sign property
	--	Text
	--	Enum for color scheme
	--	Or background/foreground color
	
	-- Audio
	--	Give items an optional audio property
	--
	--	Make an optional script language that lets them play notes
	--	tone+duration, gap+duration
	--	https://en.wikipedia.org/wiki/ABC_notation
	--	https://editor.drawthedots.com/

end