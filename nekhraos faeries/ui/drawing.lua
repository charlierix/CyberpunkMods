-- function DrawConfig()
-- end

--https://stackoverflow.com/questions/26160327/sorting-a-lua-table-by-key
function DrawDebugWindow(debugInfo, vars_ui)
    ImGui.SetNextWindowPos(20 * vars_ui.scale, 300 * vars_ui.scale, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(300 * vars_ui.scale, 400 * vars_ui.scale, ImGuiCond.FirstUseEver)

    if (ImGui.Begin("Nekhraos Faeries Debug")) then
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