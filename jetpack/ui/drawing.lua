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

    ImGui.PushStyleColor(ImGuiCol.WindowBg, 0x5454542E)     --542E5454
    ImGui.PushStyleColor(ImGuiCol.Border, 0x806E6E3D)       --803D6E6E

    ImGui.SetNextWindowPos(20 * scale, 300, ImGuiCond.Always)
    ImGui.SetNextWindowSize(240 * scale, 160 * scale, ImGuiCond.Appearing)

    if (ImGui.Begin("Jetpack Mode", true, ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoScrollbar)) then
        --ImGui.SetWindowFocus("Jetpack Mode")        -- hopefully, this forces it to be on top

        ImGui.SetWindowFontScale(1.2)

        Refresh_LineHeights(vars_ui_configname, const, false)
        scale = vars_ui_configname.scale       -- it might have gotten updated

        ImGui.Spacing()
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFF4CFFFF)     --FFFF4C
        ImGui.Text(mode.name)
        ImGui.PopStyleColor(1)

        ImGui.Spacing()
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFF75)     --75FFFF

        -- Only reporting settings out of ordinary (low gravity, high gravity, etc)

        --TODO: these should come from a property off of mode (like description)

        if not mode.jump_land.shouldSafetyFire then
            ImGui.Spacing()
            ImGui.Text("unsafe landing")
        end

        if mode.jump_land.explosiveLanding then
            ImGui.Spacing()
            ImGui.Text("explosive landing")
        end

        if mode.timeSpeed and mode.timeSpeed < 1 then
            ImGui.Spacing()
            ImGui.Text(string.format("%.0f", Round(mode.timeSpeed * 100, 0)) .. "% speed")

        elseif mode.timeSpeed_gradient then
            ImGui.Spacing()
            ImGui.Text(string.format("%.0f", Round(mode.timeSpeed_gradient.timeSpeed_highZSpeed * 100, 0)) .. "% to " .. string.format("%.0f", Round(mode.timeSpeed_gradient.timeSpeed_lowZSpeed * 100, 0)) .. "% speed")
        end

        if mode.rebound then
            ImGui.Spacing()
            ImGui.Text("rebound jumping")
        end

        if mode.rmb_extra then
            ImGui.Spacing()
            ImGui.Text("right mouse: " .. mode.rmb_extra:Description())
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