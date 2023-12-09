--Borderless progress bar inspired by / lifted from survival mod by Architect
--https://www.nexusmods.com/cyberpunk2077/mods/1405
function DrawJetpackProgress(name, remainBurnTime, maxBurnTime, vars_ui_progressbar, const)
    local scale = vars_ui_progressbar.scale

    ImGui.SetNextWindowPos(20 * scale, 200 * scale, ImGuiCond.Always)       -- this is under the top left combat graphic
    ImGui.SetNextWindowSize(380 * scale, 50 * scale, ImGuiCond.Appearing)

    if (ImGui.Begin(name, true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoBackground)) then
        ImGui.SetWindowFontScale(0.75)

        Refresh_LineHeights(vars_ui_progressbar, const, false)
        scale = vars_ui_progressbar.scale       -- it might have gotten updated

        -- Progress Bar
        ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 3 * scale)

        -- The color ints are in ABGR (comments to the side are ARGB for easy copy/pasting into color editor)

        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFF75)
        ImGui.PushStyleColor(ImGuiCol.FrameBg, 0x99ADAD5E)
        ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 0xE6D4D473)

        --ImGui.SetCursorPos(0, 0)
        ImGui.SetCursorPos(0, vars_ui_progressbar.line_heights.line / 2)
        ImGui.PushItemWidth(130 * scale)

        ImGui.ProgressBar(remainBurnTime / maxBurnTime, 130 * scale, 4 * scale)     -- %, width, height

        ImGui.PopItemWidth()

        ImGui.PopStyleColor(3)      -- count must match the number of pushes above
        ImGui.PopStyleVar(1)

        -- Label
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFF4CFFFF)

        ImGui.SetCursorPos(140 * scale, 0)

        ImGui.Text(name)

        ImGui.PopStyleColor(1)
    end
    ImGui.End()
end

function DrawConfigName(mode, vars_ui_configname, const)
    local scale = vars_ui_configname.scale

    ImGui.PushStyleColor(ImGuiCol.WindowBg, 0xA054542E)     --542E5454
    ImGui.PushStyleColor(ImGuiCol.Border, 0x806E6E3D)       --803D6E6E

    ImGui.SetNextWindowPos(20 * scale, 250, ImGuiCond.Always)       --NOTE: not applying scale to Y.  That would make it draw too low
    ImGui.SetNextWindowSize(0, 0, ImGuiCond.Always)      -- setting to zero to tell it to autosize

    if (ImGui.Begin("Jetpack Mode", true, ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoScrollbar)) then
        --ImGui.SetWindowFocus("Jetpack Mode")        -- hopefully, this forces it to be on top

        ImGui.SetWindowFontScale(1.2)

        Refresh_LineHeights(vars_ui_configname, const, false)
        scale = vars_ui_configname.scale       -- it might have gotten updated

        ImGui.Spacing()
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFF4CFFFF)     --FFFF4C
        if mode then
            ImGui.Text(mode.name)
        else
            ImGui.Text("<< No Modes >>")
        end
        ImGui.PopStyleColor(1)

        ImGui.Spacing()
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFF75)     --75FFFF

        -- Only reporting settings out of ordinary (low gravity, high gravity, etc)

        if mode then
            if not mode.jump_land.shouldSafetyFire then
                ImGui.Spacing()
                ImGui.Text("unsafe landing")
            end

            if mode.jump_land.explosiveLanding then
                ImGui.Spacing()
                ImGui.Text("explosive landing")
            end

            if mode.timeDilation and mode.timeDilation < 1 then
                ImGui.Spacing()
                ImGui.Text(string.format("%.0f", Round(mode.timeDilation * 100, 0)) .. "% speed")

            elseif mode.timeDilation_gradient then
                ImGui.Spacing()
                ImGui.Text(string.format("%.0f", Round(mode.timeDilation_gradient.timeDilation_highZSpeed * 100, 0)) .. "% to " .. string.format("%.0f", Round(mode.timeDilation_gradient.timeDilation_lowZSpeed * 100, 0)) .. "% speed")
            end

            if mode.rebound then
                ImGui.Spacing()
                ImGui.Text("rebound jumping")
            end

            if mode.extra_rmb then
                ImGui.Spacing()
                ImGui.Text("right mouse: " .. mode.extra_rmb:Description())
            end

            if mode.extra_key1 then
                ImGui.Spacing()
                ImGui.Text("extra 1: " .. mode.extra_key1:Description())
            end

            if mode.extra_key2 then
                ImGui.Spacing()
                ImGui.Text("extra 2: " .. mode.extra_key2:Description())
            end
        end

        ImGui.PopStyleColor(1)
    end
    ImGui.End()

    ImGui.PopStyleColor(2)
end

function DrawEnabledDisabled(isEnabled)
    ImGui.PushStyleColor(ImGuiCol.WindowBg, 0x5454542E)     --542E5454
    ImGui.PushStyleColor(ImGuiCol.Border, 0x806E6E3D)       --803D6E6E

    ImGui.SetNextWindowPos(20, 250, ImGuiCond.Always)
    ImGui.SetNextWindowSize(240, 50, ImGuiCond.Appearing)

    if (ImGui.Begin("Enable Disable", true, ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoScrollbar)) then
        ImGui.SetWindowFontScale(1.8)

        ImGui.Spacing()
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFF4CFFFF)     --FFFF4C

        if isEnabled then
            ImGui.Text("Jetpack Enabled")
        else
            ImGui.Text("Jetpack Disabled")
        end

        ImGui.PopStyleColor(1)

        -- ImGui.Spacing()
        -- ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFF75)      --75FFFF

        -- if not isEnabled then
        --     ImGui.Spacing()
        --     ImGui.Text("allows for other mods....")     -- not sure what to say
        -- end

        -- ImGui.PopStyleColor(1)
    end
    ImGui.End()

    ImGui.PopStyleColor(2)
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
    if (ImGui.Begin("Jetpack", ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoNavInputs)) then     --NOTE: imgui.h doesn't mention this overload.  The overload that takes bool as second param only accepts true, and it adds the X button
        -- These will be used by workers for this window as well as sub windows
        Refresh_LineHeights(vars_ui, const, false)
        Refresh_WindowPos(window, vars_ui, const)

        if vars_ui.currentWindow == const.windows.main then
            continueShowing = DrawWindow_Main(isCloseRequested, vars, vars_ui, player, window, o, const)

        elseif vars_ui.currentWindow == const.windows.mode then
            continueShowing = DrawWindow_Mode(isCloseRequested, vars, vars_ui, player, window, o, const)

        elseif vars_ui.currentWindow == const.windows.mode_accel then
            continueShowing = DrawWindow_Mode_Accel(isCloseRequested, vars, vars_ui, player, window, o, const)

        elseif vars_ui.currentWindow == const.windows.mode_energy then
            continueShowing = DrawWindow_Mode_Energy(isCloseRequested, vars, vars_ui, player, window, o, const)

        elseif vars_ui.currentWindow == const.windows.mode_extra then
            continueShowing = DrawWindow_Mode_Extra(isCloseRequested, vars, vars_ui, player, window, o, const)

        elseif vars_ui.currentWindow == const.windows.mode_jumpland then
            continueShowing = DrawWindow_Mode_JumpLand(isCloseRequested, vars, vars_ui, player, window, o, const)

        elseif vars_ui.currentWindow == const.windows.mode_mousesteer then
            continueShowing = DrawWindow_Mode_MouseSteer(isCloseRequested, vars, vars_ui, player, window, o, const)

        elseif vars_ui.currentWindow == const.windows.mode_rebound then
            continueShowing = DrawWindow_Mode_Rebound(isCloseRequested, vars, vars_ui, player, window, o, const)

        elseif vars_ui.currentWindow == const.windows.mode_timedilation then
            continueShowing = DrawWindow_Mode_TimeDilation(isCloseRequested, vars, vars_ui, player, window, o, const)

        elseif vars_ui.currentWindow == const.windows.choose_mode then
            continueShowing = DrawWindow_ChooseMode(isCloseRequested, vars, vars_ui, player, window, o, const)
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
function DrawDebugWindow(debugInfo)
    ImGui.SetNextWindowPos(20, 300, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(300, 400, ImGuiCond.FirstUseEver)

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