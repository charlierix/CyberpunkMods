--Borderless progress bar inspired by / lifted from survival mod by Architect
--https://www.nexusmods.com/cyberpunk2077/mods/1405
--NOTE: This is a copy of DrawJetpackProgress
--NOTE: This is positioned according to how things look at 4K.  The progress is a bit low on 1K, but it's not bad.  I tried scaling position according to resolution, but text was still large, probably would need to scale that too
function DrawEnergyProgress(energy, max, experience, state)
    ImGui.SetNextWindowPos(20, 230, ImGuiCond.Always)       -- this is under the top left combat graphic (placing under jetpack's progress bar)
    ImGui.SetNextWindowSize(380, 50, ImGuiCond.Appearing)

    if (ImGui.Begin("energy", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoBackground)) then
        ImGui.SetWindowFontScale(1.5)

        -- Progress Bar
        ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, 3)

        -- The color ints are in ABGR (comments to the side are ARGB for easy copy/pasting into color editor)

        if state.animation_lowEnergy.isProgressBarRed then
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFF5C66FF)        --FF665C
            ImGui.PushStyleColor(ImGuiCol.FrameBg, 0x9926214A)       --994A2126
            ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 0xE64547C7)     --E6C74745
        else
            ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFF75)      --75FFFF
            ImGui.PushStyleColor(ImGuiCol.FrameBg, 0x99ADAD5E)       --995EADAD
            ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 0xE6D4D473)     --E673D4D4
        end

        ImGui.SetCursorPos(0, 0)
        ImGui.PushItemWidth(130)

        ImGui.ProgressBar(energy / max, 130, 24)     -- %, width, height

        ImGui.PopItemWidth()

        ImGui.PopStyleColor(3)      -- count must match the number of pushes above
        ImGui.PopStyleVar(1)

        -- Label
        ImGui.PushStyleColor(ImGuiCol.Text, 0xFF4CFFFF)       --FFFF4C

        ImGui.SetCursorPos(140, 0)

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

        elseif vars_ui.currentWindow == const.windows.grapple_straight_stopearly then
            DrawWindow_GrappleStraight_StopEarly(vars_ui, player, window, const)

        elseif vars_ui.currentWindow == const.windows.grapple_straight_velaway then
            DrawWindow_GrappleStraight_VelocityAway(vars_ui, player, window, const)
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