local config = require("modules/config")

tester = {
    runtimeData = {
        cetOpen = false
    }
}

function tester:new()
    registerForEvent("onInit", function()
        tester.ui = require("modules/ui")
        tester.ui.loadNames()

        config.tryCreateConfig("saved.json", {})
        tester.ui.saved = config.loadFile("saved.json")
    end)

    registerForEvent("onShutdown", function ()
        tester.ui.stopCurrentSound()
    end)

    registerForEvent("onDraw", function()
        if tester.runtimeData.cetOpen then
            tester.ui.draw()
        end
    end)

    registerForEvent("onOverlayOpen", function()
        tester.runtimeData.cetOpen = true
    end)

    registerForEvent("onOverlayClose", function()
        tester.runtimeData.cetOpen = false
    end)

    return tester

end

return tester:new()