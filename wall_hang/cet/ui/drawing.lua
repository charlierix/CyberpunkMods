-- Draws the config screen
-- Returns:
--  true: keep showing config
--  false: stop showing config
function DrawConfig(isCloseRequested, vars, vars_ui, o, const, player, player_arcade)
    local continueShowing = true        -- this should go to false when isCloseRequested true, unless the window is in a dirty state

    local window = vars_ui.configWindow

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

    ImGui.SetNextWindowPos(window.left, window.top, ImGuiCond.FirstUseEver)     -- this will place it in the hardcoded location, but if they move it, it will show at the new location
    ImGui.SetNextWindowSize(window.width, window.height, ImGuiCond.Always)

    -- NoNavInputs was used mainly for the input binding window.  But there are so many custom controls on the rest of the windows that mouse navigation is pretty much required anyway
    if (ImGui.Begin("Wall Hang", ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoNavInputs)) then     --NOTE: imgui.h doesn't mention this overload.  The overload that takes bool as second param only accepts true, and it adds the X button
        -- These will be used by workers for this window as well as sub windows
        Refresh_WindowPos(window)
        Refresh_LineHeights(vars_ui)

        if vars_ui.currentWindow == const.windows.main then
            continueShowing = DrawWindow_Main(isCloseRequested, vars, vars_ui, window, const, player, player_arcade)

        elseif vars_ui.currentWindow == const.windows.input_bindings then
            continueShowing = DrawWindow_InputBindings(isCloseRequested, vars, vars_ui, o, window, const)

        elseif vars_ui.currentWindow == const.windows.jumping then
            continueShowing = DrawWindow_Jumping(isCloseRequested, vars, vars_ui, window, const, player, player_arcade)

        elseif vars_ui.currentWindow == const.windows.wall_attraction then
            continueShowing = DrawWindow_WallAttraction(isCloseRequested, vars, vars_ui, window, const, player, player_arcade)

        elseif vars_ui.currentWindow == const.windows.crawl_slide then
            continueShowing = DrawWindow_CrawlSlide(isCloseRequested, vars, vars_ui, window, const, player, player_arcade)
        end
    end
    ImGui.End()

    ImGui.PopStyleColor(8)

    return continueShowing
end

--https://stackoverflow.com/questions/26160327/sorting-a-lua-table-by-key
function DrawDebugWindow(debugInfo)
    ImGui.SetNextWindowPos(20, 300, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(300, 400, ImGuiCond.FirstUseEver)

    if (ImGui.Begin("Wall Hang Debug")) then
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