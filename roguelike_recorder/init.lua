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

require "src/core/debug_code"
require "src/core/gameobj_accessor"
require "src/core/lists"
require "src/core/math_basic"
require "src/core/math_raycast"
require "src/core/math_vector"
require "src/core/math_yaw"
require "src/core/strings"
require "src/core/util"

require "src/data/json_writer"

extern_json = require "src/external/json"       -- storing this in a global variable so that its functions must be accessed through that variable (most examples use json as the variable name, but this project already has variables called json)

local this = {}

--------------------------------------------------------------------
---                          Constants                           ---
--------------------------------------------------------------------

local const =
{
    author = "",        -- This will go in the author property of all generated json files

    modded_parkour = CreateEnum("none", "light", "heavy"),
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
    --function wrappers.RayCast(player, from, to, staticOnly) return player:Roguelike_RayCast(from, to, staticOnly) end
    function wrappers.SetTimeDilation(timeSpeed) Game.SetTimeDilation(tostring(timeSpeed)) end      -- for some reason, it takes in string
    function wrappers.HasHeadUnderwater(player) return player:HasHeadUnderwater() end
    --function wrappers.QueueSound(player, sound) player:Roguelike_QueueSound(sound) end
    --function wrappers.StopQueuedSound(player, sound) player:Roguelike_StopQueuedSound(sound) end

    o = GameObjectAccessor:new(wrappers)
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



end)

registerHotkey("RoguelikeReporter_SavePosition_SpawnPoint", "Save Position - Spawn Point", function()
    o:GetPlayerInfo()      -- very important to use : and not . (colon is a syntax shortcut that passes self as a hidden first param)
    if not o.player then
        print("Can't get player")
        do return end
    end

    local spawn =
    {
        author = "",
        description = "",
        tags = {""},

        modded_parkour = const.modded_parkour.none,

        position_x = o.pos.x,       -- it's rounded during the serialize
        position_y = o.pos.y,
        position_z = o.pos.z,

        yaw = o.yaw,
    }


    Save_SpawnPoint(spawn)

end)

-- registerForEvent("onDraw", function()
--     if isShutdown or not isLoaded or not shouldDraw then
--         do return end
--     end

--     --TODO: Show a config
-- end)

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

    -- Add a wpf app to help visualize a scene, move objects, etc

    -- Add mode to this mod that does ray tracing and records hitpoints, materials
    -- This raw data dump can then be read in by the wpf app, cleaned up and use to recreate a scene

end