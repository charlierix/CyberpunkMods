local config = require("modules/config")

ui = {
    names = {},
    currentName = "",
    searchText = "",
    savedSearch = "",
    saved = {}
}

function ui.has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function ui.loadNames()
    ui.names = config.loadPaths("names.txt")
end

function ui.draw()
    ImGui.Begin("Sound Clip Tester (keanuWheeze)", ImGuiWindowFlags.AlwaysAutoResize)

    if ImGui.BeginTabBar("Tabbar", ImGuiTabItemFlags.NoTooltip) then
        if ImGui.BeginTabItem("Play") then
            ui.drawPlay()
            ImGui.EndTabItem()
        end

        if ImGui.BeginTabItem("Saved") then
            ui.drawSaved()
            ImGui.EndTabItem()
        end

        ImGui.EndTabBar()
    end

    ImGui.End()
end

function ui.drawPlay()
    ui.searchText = ImGui.InputTextWithHint('##Filter', 'Search...', ui.searchText, 100)

    if ui.searchText ~= '' then
        ImGui.SameLine()
        if ImGui.Button('X') then
            ui.searchText = ''
        end
    end

    ImGui.BeginChild("list", 500, 850)

    for _, path in pairs(ui.names) do
        if (path:lower():match(ui.searchText:lower())) ~= nil then
            ImGui.PushID(path)

            local hasColor = false
            if ui.currentName == path then
                ImGui.PushStyleColor(ImGuiCol.Button, 0xff009933)
                ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 0xff009900)
                hasColor = true
            end

            if ImGui.Button(path) then
                ui.stopCurrentSound()
                ui.currentName = path
                local audioEvent = SoundPlayEvent.new ()
                audioEvent.soundName = ui.currentName
                Game.GetPlayer():QueueEvent(audioEvent)

                ImGui.SetClipboardText(path)
            end

            if ui.currentName == path then
                ImGui.SameLine()
                if ImGui.Button("Stop") then
                    ui.stopCurrentSound()
                end
            end

            if hasColor then ImGui.PopStyleColor(2) end

            ImGui.SameLine()
            if ImGui.Button("Save") and not ui.has_value(ui.saved, path) then
                table.insert(ui.saved, path)
                config.saveFile("saved.json", ui.saved)
            end

            ImGui.PopID()
        end
    end

    ImGui.EndChild()
end

function ui.drawSaved()
    ui.savedSearch = ImGui.InputTextWithHint('##Filter', 'Search...', ui.savedSearch, 100)

    if ui.savedSearch ~= '' then
        ImGui.SameLine()
        if ImGui.Button('X') then
            ui.savedSearch = ''
        end
    end

    for k, path in pairs(ui.saved) do
        if (path:lower():match(ui.savedSearch:lower())) ~= nil then
            ImGui.PushID(path)

            local hasColor = false
            if ui.currentName == path then
                ImGui.PushStyleColor(ImGuiCol.Button, 0xff009933)
                ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 0xff009900)
                hasColor = true
            end
            if ImGui.Button(path) then
                ui.stopCurrentSound()
                ui.currentName = path
                local audioEvent = SoundPlayEvent.new()
                audioEvent.soundName = ui.currentName
                Game.GetPlayer():QueueEvent(audioEvent)

                ImGui.SetClipboardText(path)
            end

            if ui.currentName == path then
                ImGui.SameLine()
                if ImGui.Button("Stop") then
                    ui.stopCurrentSound()
                end
            end

            if hasColor then ImGui.PopStyleColor(2) end

            ImGui.SameLine()
            if ImGui.Button("Remove") then
                table.remove(ui.saved, k)
                config.saveFile("saved.json", ui.saved)
            end

            ImGui.PopID()
        end
    end
end

function ui.stopCurrentSound()
    local audioEvent = SoundStopEvent.new ()
    audioEvent.soundName = ui.currentName
    Game.GetPlayer():QueueEvent(audioEvent)
    ui.currentName = ""
end

return ui