--Borderless progress bar inspired by / lifted from survival mod by Architect
--https://www.nexusmods.com/cyberpunk2077/mods/1405
--NOTE: This is a copy of DrawJetpackProgress
--NOTE: This is positioned according to how things look at 4K.  The progress is a bit low on 1K, but it's not bad.  I tried scaling position according to resolution, but text was still large, probably would need to scale that too
function DrawEnergyProgress(energy, max, experience, state)
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
--  true: keep showing config
--  false: stop showing config
function DrawConfig(isConfigRepress, vars_ui, player, const)
    if not player then
        return false
    end

    local continueShowing = true        -- only the main window is allowed to set this to false

    local window = vars_ui.mainWindow

    ImGui.PushStyleColor(ImGuiCol.WindowBg, vars_ui.style.back_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.Border, vars_ui.style.border_color_abgr)

    ImGui.SetNextWindowPos(window.left, window.top, ImGuiCond.FirstUseEver)     -- this will place it in the hardcoded location, but if they move it, it will show at the new location
    ImGui.SetNextWindowSize(window.width, window.height, ImGuiCond.Always)

    if (ImGui.Begin("Grappling Hook", true, ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoCollapse)) then    
        -- These will be used by workers for this window as well as sub windows
        Refresh_WindowPos(window)
        Refresh_LineHeights(vars_ui)

        if vars_ui.currentWindow == const.windows.main then
            continueShowing = DrawWindow_Main(isConfigRepress, vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.energy_tank then
            DrawWindow_EnergyTank(vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_choose then
            DrawWindow_Grapple_Choose(vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight then
            DrawWindow_Grapple_Straight(vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_accelalong then
            DrawWindow_GrappleStraight_AccelAlong(vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_accellook then
            DrawWindow_GrappleStraight_AccelLook(vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_aimduration then
            DrawWindow_GrappleStraight_AimDuration(vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_airdash then
            DrawWindow_GrappleStraight_AirDash(vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_antigrav then
            DrawWindow_GrappleStraight_AntiGrav(vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_description then
            DrawWindow_GrappleStraight_Description(vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_distances then
            DrawWindow_GrappleStraight_Distances(vars_ui, player, window, const)
        end
    end
    ImGui.End()

    ImGui.PopStyleColor(2)

    return continueShowing
end

--https://stackoverflow.com/questions/26160327/sorting-a-lua-table-by-key
function DrawDebugWindow(debugInfo)
    --ImGui.SetNextWindowPos(20, 300, ImGuiCond.Always)
    ImGui.SetNextWindowPos(20, 720, ImGuiCond.FirstUseEver)
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
