--Borderless progress bar inspired by / lifted from survival mod by Architect
--https://www.nexusmods.com/cyberpunk2077/mods/1405
--NOTE: This is a copy of DrawJetpackProgress
--NOTE: This is positioned according to how things look at 4K.  The progress is a bit low on 1K, but it's not bad.  I tried scaling position according to resolution, but text was still large, probably would need to scale that too
function DrawEnergyProgress(energy, max, experience, vars, vars_ui_progressbar, const)
    local scale = vars_ui_progressbar.scale

    ImGui.SetNextWindowPos(20 * scale, 230 * scale, ImGuiCond.Always)       -- this is under the top left combat graphic (placing under jetpack's progress bar)
    ImGui.SetNextWindowSize(450 * scale, 50 * scale, ImGuiCond.Appearing)

    if (ImGui.Begin("energy", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoBackground)) then
        ImGui.SetWindowFontScale(0.75)

        Refresh_LineHeights(vars_ui_progressbar, const, false)
        scale = vars_ui_progressbar.scale       -- it might have gotten updated

        -- Progress Bar
        ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 3 * scale)

        -- The color ints are in ABGR (comments to the side are ARGB for easy copy/pasting into color editor)

        if vars.animation_lowEnergy.isProgressBarRed then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF5C66FF)        --FF665C
            ImGui.PushStyleColor(ImGuiCol.FrameBg, 0x9926214A)       --994A2126
            ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 0xE64547C7)     --E6C74745
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFF75)      --75FFFF
            ImGui.PushStyleColor(ImGuiCol.FrameBg, 0x99ADAD5E)       --995EADAD
            ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 0xE6D4D473)     --E673D4D4
        end

        --ImGui.SetCursorPos(0, 0)
        ImGui.SetCursorPos(0, vars_ui_progressbar.line_heights.line / 2)
        ImGui.PushItemWidth(130 * scale)

        --ImGui.ProgressBar(energy / max, 130 * scale, 24 * scale)     -- %, width, height
        ImGui.ProgressBar(energy / max, 130 * scale, 4 * scale)     -- %, width, height

        ImGui.PopItemWidth()

        ImGui.PopStyleColor(3)      -- count must match the number of pushes above
        ImGui.PopStyleVar(1)

        -- Label
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFF4CFFFF)       --FFFF4C

        ImGui.SetCursorPos(140 * scale, 0)

        local text = "grappling hook"
        experience = math.floor(experience)
        if experience >= 1 then
            text = text .. " (xp: " .. tostring(experience) .. ")"
        end

        ImGui.Text(text)

        ImGui.PopStyleColor(1)
    end
    ImGui.End()
end

-- Draws the config screen
-- Returns:
--  continue_showing        true: keep showing config, false: stop showing config
--  is_minimized            true: the window is in a collapsed state (or completely blocked)
function DrawConfig(isCloseRequested, is_minimized, vars, vars_ui, player, o, const)
    if not player then
        return false, false
    end

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

    local width = window.width
    if is_minimized then
        width = 200 * vars_ui.scale
    end

    ImGui.SetNextWindowPos(window.left, window.top, ImGuiCond.FirstUseEver)     -- this will place it in the hardcoded location, but if they move it, it will show at the new location
    ImGui.SetNextWindowSize(width, window.height, ImGuiCond.Always)

    -- NoNavInputs was used mainly for the input binding window.  But there are so many custom controls on the rest of the windows that mouse navigation is pretty much required anyway
    if (ImGui.Begin("Grappling Hook", ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoNavInputs)) then     --NOTE: imgui.h doesn't mention this overload.  The overload that takes bool as second param only accepts true, and it adds the X button
        -- These will be used by workers for this window as well as sub windows
        Refresh_LineHeights(vars_ui, const, false)
        Refresh_WindowPos(window, vars_ui, const)

        if vars_ui.currentWindow == const.windows.main then
            continueShowing = DrawWindow_Main(isCloseRequested, vars, vars_ui, player, window, o, const)

        elseif vars_ui.currentWindow == const.windows.input_bindings then
            continueShowing = DrawWindow_InputBindings(isCloseRequested, vars, vars_ui, player, o, window, const)

        elseif vars_ui.currentWindow == const.windows.energy_tank then
            continueShowing = DrawWindow_EnergyTank(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_choose then
            continueShowing = DrawWindow_Grapple_Choose(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight then
            continueShowing = DrawWindow_Grapple_Straight(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_accelalong then
            continueShowing = DrawWindow_GrappleStraight_AccelAlong(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_accellook then
            continueShowing = DrawWindow_GrappleStraight_AccelLook(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_aimduration then
            continueShowing = DrawWindow_GrappleStraight_AimDuration(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_airanchor then
            continueShowing = DrawWindow_GrappleStraight_AirAnchor(isCloseRequested, vars_ui, player, window, const)

        -- elseif vars_ui.currentWindow == const.windows.grapple_straight_airdash then
        --     continueShowing = DrawWindow_GrappleStraight_AirDash(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_antigrav then
            continueShowing = DrawWindow_GrappleStraight_AntiGrav(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_description then
            continueShowing = DrawWindow_GrappleStraight_Description(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_distances then
            continueShowing = DrawWindow_GrappleStraight_Distances(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_stopearly then
            continueShowing = DrawWindow_GrappleStraight_StopEarly(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_velaway then
            continueShowing = DrawWindow_GrappleStraight_VelocityAway(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_swing then
            continueShowing = DrawWindow_Grapple_Swing(isCloseRequested, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_visuals then
            continueShowing = DrawWindow_Grapple_Visuals(isCloseRequested, vars_ui, player, window, const)
        end

        is_minimized = false
    else
        Refresh_LineHeights(vars_ui, const, false)      -- this won't be needed once scale is based on screen resolution instead of font height
        Refresh_WindowPos(window, vars_ui, const)

        is_minimized = true
    end
    ImGui.End()

    ImGui.PopStyleColor(8)

    return continueShowing, is_minimized
end

--https://stackoverflow.com/questions/26160327/sorting-a-lua-table-by-key
function DrawDebugWindow(debugInfo, vars_ui, const)
    ImGui.SetNextWindowPos(20 * vars_ui.scale, 300 * vars_ui.scale, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(300 * vars_ui.scale, 400 * vars_ui.scale, ImGuiCond.FirstUseEver)

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