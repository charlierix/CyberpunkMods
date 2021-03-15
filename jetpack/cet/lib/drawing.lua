function DrawJetpackProgress(name, remainBurnTime, maxBurnTime)
    ImGui.SetNextWindowPos(20, 200, ImGuiCond.Always)       -- this is under the top left combat graphic
    ImGui.SetNextWindowSize(120, 60, ImGuiCond.Appearing)

    if (ImGui.Begin(name)) then
        ImGui.Spacing()
        ImGui.ProgressBar(remainBurnTime / maxBurnTime, 90, 18)     -- %, width, height
    end
    ImGui.End()
end

function DrawConfigName(mode)
    ImGui.SetNextWindowPos(160, 200, ImGuiCond.Always)
    ImGui.SetNextWindowSize(210, 140, ImGuiCond.Appearing)

    if (ImGui.Begin("Jetpack Mode")) then
        ImGui.Spacing()
        ImGui.Text(mode.name)

        ImGui.Spacing()

        --TODO: Report settings out of ordinary (low gravity, high gravity, etc)

        if not mode.shouldSafetyFire then
            ImGui.Spacing()
            ImGui.TextColored(1,1,1,0.6, "unsafe landing")
        end

        if mode.explosiveLanding then
            ImGui.Spacing()
            ImGui.TextColored(1,1,1,0.6, "explosive landing")
        end

        if mode.timeSpeed < 1 then
            ImGui.Spacing()
            ImGui.TextColored(1,1,1,0.6, string.format("%.0f", Round(mode.timeSpeed * 100, 0)) .. "%% speed")
        end

        if mode.rmb_extra then
            ImGui.Spacing()
            ImGui.TextColored(1,1,1,0.6, "right mouse: " .. mode.rmb_extra:Description())
        end
    end
    ImGui.End()
end

--https://stackoverflow.com/questions/26160327/sorting-a-lua-table-by-key
function DrawDebugWindow(debugInfo)
    ImGui.SetNextWindowPos(20, 300, ImGuiCond.Always)
    ImGui.SetNextWindowSize(300, 400, ImGuiCond.Appearing)

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
