local window = {}

function DrawConfig(vars, vars_ui, o, debug, const)
    ImGui.PushStyleColor(ImGuiCol.TitleBgActive, vars_ui.style.title_color_focused_abgr)

    if vars_ui.isTooltipShowing then
        ImGui.PushStyleColor(ImGuiCol.TitleBg, vars_ui.style.title_color_focused_abgr)      -- don't want the titlebar flashing when tooltip shows
        vars_ui.isTooltipShowing = false        -- setting back to false for the next frame.  If the tooltip is still showing, then it will become true again in this frame
    else
        ImGui.PushStyleColor(ImGuiCol.TitleBg, vars_ui.style.title_color_notFocused_abgr)      -- title when not active
    end

    ImGui.PushStyleColor(ImGuiCol.TitleBgCollapsed, vars_ui.style.title_color_collapsed_abgr)

    ImGui.PushStyleColor(ImGuiCol.Text, vars_ui.style.title_color_foreground_abgr)     -- both the title color as well as collapse button's foreground

    ImGui.PushStyleColor(ImGuiCol.ButtonHovered, vars_ui.style.title_color_button_hover_abgr)        -- collapse button (no need to set the standard button color, it's not used in the title bar)
    ImGui.PushStyleColor(ImGuiCol.ButtonActive, vars_ui.style.title_color_button_click_abgr)

    ImGui.PushStyleColor(ImGuiCol.WindowBg, vars_ui.style.back_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.Border, vars_ui.style.border_color_abgr)


    ImGui.SetNextWindowPos(20, 750, ImGuiCond.FirstUseEver)     -- this will place it in the hardcoded location, but if they move it, it will show at the new location
    ImGui.SetNextWindowSize(0, 0, ImGuiCond.Always)     -- zeros should be size to content

    -- NoNavInputs was used mainly for the input binding window.  But there are so many custom controls on the rest of the windows that mouse navigation is pretty much required anyway
    if (ImGui.Begin("Head Trackball", ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoNavInputs)) then     --NOTE: imgui.h doesn't mention this overload.  The overload that takes bool as second param only accepts true, and it adds the X button
        local curLeft, curTop = ImGui.GetWindowPos()
        window.left = curLeft
        window.top = curTop
		
		--TODO: See if ImGui.GetFrameHeight is the appropriate function
        window.title_height = 19        -- this was just from counting pixels, there may be a built in way of knowing this (I searched for title and didn't see anything)

        --TODO: If there are more types of config needed, add tab items

        DrawWindow_Trackball(vars, vars_ui, o, window, debug, const)

    end
    ImGui.End()

    ImGui.PopStyleColor(8)
end

--https://stackoverflow.com/questions/26160327/sorting-a-lua-table-by-key
function DrawDebugWindow(debugInfo)
    ImGui.SetNextWindowPos(20, 300, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(300, 400, ImGuiCond.FirstUseEver)

    if (ImGui.Begin("Head Roll/Pitch Demo")) then
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