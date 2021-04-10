--Borderless progress bar inspired by / lifted from survival mod by Architect
--https://www.nexusmods.com/cyberpunk2077/mods/1405
function DrawJetpackProgress(name, remainBurnTime, maxBurnTime)
    ImGui.SetNextWindowPos(20, 200, ImGuiCond.Always)       -- this is under the top left combat graphic
    ImGui.SetNextWindowSize(300, 30, ImGuiCond.Appearing)

    if (ImGui.Begin(name, true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoBackground)) then
        ImGui.SetWindowFontScale(1.5)

        ImGui.Spacing()
        ImGui.Columns(2, "", false)
        --ImGui.SetColumnWidth(1, 130)      -- this seems to be ignored

        -- Progress Bar
        ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 3)
        ImGui.PushStyleColor(ImGuiCol.Text, 0.46, 1, 1, 1)
        ImGui.PushStyleColor(ImGuiCol.FrameBg, 0.37, 0.68, 0.68, 0.6)
        ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 0.45, 0.83, 0.83, 0.9)

        ImGui.ProgressBar(remainBurnTime / maxBurnTime, 130, 24)     -- %, width, height

        ImGui.PopStyleColor(3)      -- count must match the number of pushes above
        ImGui.PopStyleVar(1)

        -- Label
        ImGui.NextColumn()

        ImGui.PushStyleColor(ImGuiCol.Text, 1, 1, 0.3, 1)

        ImGui.Text(name)

        ImGui.PopStyleColor(1)
    end
    ImGui.End()
end

function DrawConfigName(mode)
    ImGui.PushStyleColor(ImGuiCol.WindowBg, 0.18, 0.33, 0.33, 0.33)
    ImGui.PushStyleColor(ImGuiCol.Border, 0.24, 0.43, 0.43, 0.5)

    ImGui.SetNextWindowPos(20, 300, ImGuiCond.Always)
    ImGui.SetNextWindowSize(240, 160, ImGuiCond.Appearing)

    if (ImGui.Begin("Jetpack Mode", true, ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoScrollbar)) then
        ImGui.SetWindowFocus("Jetpack Mode")        -- hopefully, this forces it to be on top

        ImGui.SetWindowFontScale(1.2)

        ImGui.Spacing()
        ImGui.TextColored(1, 1, 0.3, 1, mode.name)

        ImGui.Spacing()
        ImGui.PushStyleColor(ImGuiCol.Text, 0.46, 1, 1, 1)

        --Only reporting settings out of ordinary (low gravity, high gravity, etc)

        if not mode.shouldSafetyFire then
            ImGui.Spacing()
            --ImGui.TextColored(1,1,1,0.6, "unsafe landing")
            ImGui.Text("unsafe landing")
        end

        if mode.explosiveLanding then
            ImGui.Spacing()
            --ImGui.TextColored(1,1,1,0.6, "explosive landing")
            ImGui.Text("explosive landing")
        end

        if mode.timeSpeed < 1 then
            ImGui.Spacing()
            --ImGui.TextColored(1,1,1,0.6, string.format("%.0f", Round(mode.timeSpeed * 100, 0)) .. "%% speed")
            ImGui.Text(string.format("%.0f", Round(mode.timeSpeed * 100, 0)) .. "% speed")
        end

        if mode.rmb_extra then
            ImGui.Spacing()
            --ImGui.TextColored(1,1,1,0.6, "right mouse: " .. mode.rmb_extra:Description())
            ImGui.Text("right mouse: " .. mode.rmb_extra:Description())
        end

        ImGui.PopStyleColor(1)
    end
    ImGui.End()

    ImGui.PopStyleColor(2)
end

--https://stackoverflow.com/questions/26160327/sorting-a-lua-table-by-key
function DrawDebugWindow(debugInfo)
    ImGui.SetNextWindowPos(20, 300, ImGuiCond.Always)
    ImGui.SetNextWindowSize(300, 400, ImGuiCond.Appearing)

    --ImGui.SetWindowFontScale(1)

    if (ImGui.Begin("Jetpack Debug")) then
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
