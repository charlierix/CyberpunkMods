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

function DrawConfig(vars_ui, player, const)
    if not player then
        do return end
    end

    ImGui.SetNextWindowPos(vars_ui.mainWindow.left, vars_ui.mainWindow.top, ImGuiCond.FirstUseEver)     -- this will place it in the hardcoded location, but if they move it, it will show at the new location
    ImGui.SetNextWindowSize(vars_ui.mainWindow.width, vars_ui.mainWindow.height, ImGuiCond.Always)

    if (ImGui.Begin("Grappling Hook", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoCollapse)) then
        -- These will be used by workers for this window as well as sub windows
        Refresh_WindowPos(vars_ui.mainWindow)
        Refresh_LineHeights(vars_ui)




        -- if vars_ui.test_summary then
        --     Draw_SummaryButton(vars_ui.test_summary, vars_ui.line_heights, vars_ui.style.summaryButton, vars_ui.mainWindow.left, vars_ui.mainWindow.top)
        -- end

        if vars_ui.test_label then
            Draw_Label(vars_ui.test_label, vars_ui.style.colors, vars_ui.mainWindow.width, vars_ui.mainWindow.height, const)
        end

        -- if vars_ui.test_orderedlist then
        --     Draw_OrderedList(vars_ui.test_orderedlist, vars_ui.style.colors, vars_ui.mainWindow.width, vars_ui.mainWindow.height, const, vars_ui.line_heights)
        -- end


        -- -- Finalize models for this frame
        -- Refresh_EnergyTank(vars_ui.energyTank, player.energy_tank)

        -- Refresh_GrappleSlot(vars_ui.grapple1, player.grapple1)
        -- Refresh_GrappleSlot(vars_ui.grapple2, player.grapple2)
        -- Refresh_GrappleSlot(vars_ui.grapple3, player.grapple3)
        -- Refresh_GrappleSlot(vars_ui.grapple4, player.grapple4)
        -- Refresh_GrappleSlot(vars_ui.grapple5, player.grapple5)
        -- Refresh_GrappleSlot(vars_ui.grapple6, player.grapple6)

        -- -- Show ui elements
        -- Draw_SummaryButton(vars_ui.energyTank, vars_ui.line_heights, vars_ui.style.summaryButton, vars_ui.mainWindow.left, vars_ui.mainWindow.top)

        -- Draw_SummaryButton(vars_ui.grapple1, vars_ui.line_heights, vars_ui.style.summaryButton, vars_ui.mainWindow.left, vars_ui.mainWindow.top)
        -- Draw_SummaryButton(vars_ui.grapple2, vars_ui.line_heights, vars_ui.style.summaryButton, vars_ui.mainWindow.left, vars_ui.mainWindow.top)
        -- Draw_SummaryButton(vars_ui.grapple3, vars_ui.line_heights, vars_ui.style.summaryButton, vars_ui.mainWindow.left, vars_ui.mainWindow.top)
        -- Draw_SummaryButton(vars_ui.grapple4, vars_ui.line_heights, vars_ui.style.summaryButton, vars_ui.mainWindow.left, vars_ui.mainWindow.top)
        -- Draw_SummaryButton(vars_ui.grapple5, vars_ui.line_heights, vars_ui.style.summaryButton, vars_ui.mainWindow.left, vars_ui.mainWindow.top)
        -- Draw_SummaryButton(vars_ui.grapple6, vars_ui.line_heights, vars_ui.style.summaryButton, vars_ui.mainWindow.left, vars_ui.mainWindow.top)




        --TODO: Warn them about needing to pull up console
        --TODO: Experience


        --TODO: Close button (inner dialogs will have: save/cancel if dirty -vs- close)




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
