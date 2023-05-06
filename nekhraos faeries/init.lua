require "core/color"
require "core/math_basic"
require "core/util"

require "debug/debug_code"
require "debug/debug_render_logger"
debug_render_screen = require "debug/debug_render_screen"
require "debug/reporting"

require "ui/drawing"
require "ui/init_ui"

require "ui_framework/util_misc"

--------------------------------------------------------------------
---                          Constants                           ---
--------------------------------------------------------------------

local const =
{
    shouldShowScreenDebug = false,      -- draws debug info in game
    shouldShowDebugWindow = false,      -- shows a window with extra debug info
}

--------------------------------------------------------------------
---                        Current State                         ---
--------------------------------------------------------------------

local isShutdown = true
local isLoaded = false
local shouldDraw = false

local vars_ui =
{
    scale = 1,      -- control and window sizes are defined in pixels, then get multiplied by scale at runtime.  CET may adjust scale on non 1920x1080 monitors to give a consistent relative size, but higher resolution
}

registerForEvent("onInit", function()
    Observe("PlayerPuppet", "OnGameAttached", function(obj)
        obj:RegisterInputListener(obj)
    end)

    -- Observe("PlayerPuppet", "OnAction", function(_, action)        -- observe must be inside init and before other code
    --     keys:MapAction(action)
    -- end)

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
    InitializeUI(vars_ui, const)       --NOTE: This must be done after db is initialized.  TODO: listen for video settings changing and call this again (it stores the current screen resolution)
    debug_render_screen.CallFrom_onInit(const.shouldShowScreenDebug)
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

    -- o:Tick(deltaTime)

    -- o:GetInWorkspot()
    -- if o.isInWorkspot then      -- in a vehicle
    --     --Transition_ToStandard(vars, const, debug, o)
    --     do return end
    -- end

    shouldDraw = true       -- don't want a hung progress bar while in menu or driving

    if const.shouldShowDebugWindow then
        PopulateDebug(debug)
    end








    debug_render_screen.CallFrom_onUpdate(deltaTime)
end)


registerHotkey("NekhraosFaerieOrbis_", "Clear Debug Visuals", function()
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