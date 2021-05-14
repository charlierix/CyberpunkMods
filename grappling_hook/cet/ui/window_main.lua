local this = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function Define_Window_Main(vars_ui, const)
    local main = {}
    vars_ui.main = main

    main.title = Define_Title("Grappling Hook", const)

    main.consoleWarning = this.Define_ConsoleWarning(const)

    main.energyTank = this.Define_EnergyTank(const)

    this.Define_GrappleSlots(main, const)

    main.experience = this.Define_Experience(const)

    main.okcancel = Define_OkCancelButtons(true, vars_ui, const)
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Main(isConfigRepress, vars_ui, player, window, const)
    local main = vars_ui.main

    -- Finalize models for this frame
    this.Refresh_EnergyTank(main.energyTank, player.energy_tank)

    this.Refresh_GrappleSlot(main.grapple1, player.grapple1)
    this.Refresh_GrappleSlot(main.grapple2, player.grapple2)
    this.Refresh_GrappleSlot(main.grapple3, player.grapple3)
    this.Refresh_GrappleSlot(main.grapple4, player.grapple4)
    this.Refresh_GrappleSlot(main.grapple5, player.grapple5)
    this.Refresh_GrappleSlot(main.grapple6, player.grapple6)

    this.Refresh_Experience(main.experience, player)

    -- Show ui elements
    Draw_Label(main.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(main.consoleWarning, vars_ui.style.colors, window.width, window.height, const)

    if Draw_SummaryButton(main.energyTank, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_Energy_Tank(vars_ui, const)
    end

    if Draw_SummaryButton(main.grapple1, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_Grapple(vars_ui, const, player, 1)
    end

    if Draw_SummaryButton(main.grapple2, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_Grapple(vars_ui, const, player, 2)
    end

    if Draw_SummaryButton(main.grapple3, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_Grapple(vars_ui, const, player, 3)
    end

    if Draw_SummaryButton(main.grapple4, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_Grapple(vars_ui, const, player, 4)
    end

    if Draw_SummaryButton(main.grapple5, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_Grapple(vars_ui, const, player, 5)
    end

    if Draw_SummaryButton(main.grapple6, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_Grapple(vars_ui, const, player, 6)
    end

    Draw_OrderedList(main.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local _, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)

    return not (isConfigRepress or isCloseClicked)       -- stop showing when they click the close button (or press config key a second time.  This main page doesn't have anything to save, so it's ok to exit at any time)
end

----------------------------------- Private Methods -----------------------------------

--NOTE: Define functions get called during init.  Refresh functions get called each frame that the config is visible

function this.Define_EnergyTank(const)
    -- SummaryButton
    return
    {
        -- In the middle of the window
        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Energy",

        content =
        {
            -- the content is presented as sorted by name
            a_recovery_rate = { prompt = "refill rate" },
            b_flying_percent = { prompt = "while grappling" },
        },

        invisible_name = "Main_EnergyTank",
    }
end
function this.Refresh_EnergyTank(def, energy_tank)
    def.header_value = tostring(Round(energy_tank.max_energy))
    def.content.a_recovery_rate.value = tostring(Round(energy_tank.recovery_rate, 1))
    def.content.b_flying_percent.value = tostring(Round(energy_tank.flying_percent * 100)) .. "%"
end

function this.Define_GrappleSlots(parent, const)
    -- Figure out the positions (they are in a hex pattern around the center)
    local offset_x_small = 160
    local offset_x_large = 280
    local offset_y = 180

    parent.grapple1 = this.Define_GrappleSlots_DoIt(-offset_x_small, -offset_y, "1", const)
    parent.grapple2 = this.Define_GrappleSlots_DoIt(offset_x_small, -offset_y, "2", const)
    parent.grapple3 = this.Define_GrappleSlots_DoIt(offset_x_large, 0, "3", const)
    parent.grapple4 = this.Define_GrappleSlots_DoIt(offset_x_small, offset_y, "4", const)
    parent.grapple5 = this.Define_GrappleSlots_DoIt(-offset_x_small, offset_y, "5", const)
    parent.grapple6 = this.Define_GrappleSlots_DoIt(-offset_x_large, 0, "6", const)

end
function this.Define_GrappleSlots_DoIt(x, y, suffix, const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = x,
            pos_y = y,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        min_width = 160,
        min_height = 70,

        suffix = suffix,

        invisible_name = "Main_Grapple" .. suffix,
    }
end
function this.Refresh_GrappleSlot(def, grapple)
    if grapple then
        def.header_prompt = grapple.name
        def.unused_text = nil
    else
        def.unused_text = "empty"
        def.header_prompt = nil
    end
end

function this.Define_Experience(const)
    -- OrderedList
    return
    {
        content =
        {
            available = { prompt = "Experience" },
        },

        position =
        {
            pos_x = 36,
            pos_y = 36,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        gap = 12,

        color_prompt = "experience_prompt",
        color_value = "experience_value",
    }
end
function this.Refresh_Experience(def, player)
    def.content.available.value = tostring(math.floor(player.experience))
end

function this.Define_ConsoleWarning(const)
    -- Label
    return
    {
        text = "NOTE: buttons won't respond unless the console window is also open",

        position =
        {
            pos_x = 0,
            pos_y = 30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.top,
        },

        color = "info",
    }
end