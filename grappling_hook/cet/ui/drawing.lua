--Borderless progress bar inspired by / lifted from survival mod by Architect
--https://www.nexusmods.com/cyberpunk2077/mods/1405
--NOTE: This is a copy of DrawJetpackProgress
function DrawEnergyProgress(energy, max, state)
    ImGui.SetNextWindowPos(20, 230, ImGuiCond.Always)       -- this is under the top left combat graphic (placing under jetpack's progress bar)
    ImGui.SetNextWindowSize(330, 50, ImGuiCond.Appearing)

    if (ImGui.Begin("energy", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoBackground)) then
        ImGui.SetWindowFontScale(1.5)

        ImGui.Spacing()
        ImGui.Columns(2, "", false)
        --ImGui.SetColumnWidth(1, 130)      -- this seems to be ignored

        -- Progress Bar
        ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 3)

        if state.animation_lowEnergy.isProgressBarRed then
            ImGui.PushStyleColor(ImGuiCol.Text, 1, 0.4, 0.36, 1)
            ImGui.PushStyleColor(ImGuiCol.FrameBg, 0.29, 0.13, 0.15, 0.6)
            ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 0.78, 0.28, 0.27, 0.9)
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0.46, 1, 1, 1)
            ImGui.PushStyleColor(ImGuiCol.FrameBg, 0.37, 0.68, 0.68, 0.6)
            ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 0.45, 0.83, 0.83, 0.9)
        end

        ImGui.ProgressBar(energy / max, 130, 24)     -- %, width, height

        ImGui.PopStyleColor(3)      -- count must match the number of pushes above
        ImGui.PopStyleVar(1)

        -- Label
        ImGui.NextColumn()

        ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 0.3, 1)

        ImGui.Text("grappling hook")

        ImGui.PopStyleColor(1)
    end
    ImGui.End()
end

function DrawConfig(vars_ui, player)
    if not player then
        do return end
    end

    ImGui.SetNextWindowPos(vars_ui.mainWindow.left, vars_ui.mainWindow.top, ImGuiCond.FirstUseEver)     -- this will place it in the hardcoded location, but if they move it, it will show at the new location
    ImGui.SetNextWindowSize(vars_ui.mainWindow.width, vars_ui.mainWindow.height, ImGuiCond.Always)

    if (ImGui.Begin("Grappling Hook", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoCollapse)) then
        local curLeft, curTop = ImGui.GetWindowPos()
        vars_ui.mainWindow.left = curLeft
        vars_ui.mainWindow.top = curTop














        

    end
    ImGui.End()
end

--https://stackoverflow.com/questions/26160327/sorting-a-lua-table-by-key
function DrawDebugWindow(debugInfo)
    --ImGui.SetNextWindowPos(20, 300, ImGuiCond.Always)
    ImGui.SetNextWindowPos(20, 720, ImGuiCond.Always)
    ImGui.SetNextWindowSize(300, 400, ImGuiCond.Appearing)

    if (ImGui.Begin("Grappling Hook Debug")) then
        local keys = {}

        -- populate the table that holds the keys
        for key in pairs(debugInfo) do
            table.insert(keys, key)
        end

        -- sort the keys
        table.sort(keys)

        -- now show the items in order
        for _, key in ipairs(keys) do       -- ipairs needs a table with numeric index and loops in order.  keys table is <int,key>
            ImGui.Spacing()
            ImGui.Text(tostring(key) .. ": " .. tostring(debugInfo[key]))
        end
    end
    ImGui.End()
end
