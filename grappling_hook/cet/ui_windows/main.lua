local this = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Main(vars_ui, const)
    local main = {}
    vars_ui.main = main

    main.changes = Changes:new()

    --main.title = Define_Title("Grappling Hook", const)        -- the title bar already says this

    main.consoleWarning = this.Define_ConsoleWarning(const)
    main.should_autoshow = this.Define_ShouldAutoShow(const)

    main.input_bindings = this.Define_InputBindings(const)

    main.energyTank = this.Define_EnergyTank(const)

    this.Define_GrappleSlots(main, const)

    main.experience = Define_Experience(const, nil, 15)
    main.xp_progress = this.Define_XPProgress(const)

    main.okcancel = Define_OkCancelButtons(true, vars_ui, const)
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Main(isCloseRequested, vars_ui, player, window, const)
    local main = vars_ui.main

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_ShouldAutoShow(main.should_autoshow, vars_ui)

    this.Refresh_EnergyTank(main.energyTank, player.energy_tank)

    this.Refresh_GrappleSlot(main.grapple1, player.grapple1)
    this.Refresh_GrappleSlot(main.grapple2, player.grapple2)
    this.Refresh_GrappleSlot(main.grapple3, player.grapple3)
    this.Refresh_GrappleSlot(main.grapple4, player.grapple4)
    this.Refresh_GrappleSlot(main.grapple5, player.grapple5)
    this.Refresh_GrappleSlot(main.grapple6, player.grapple6)

    this.Refresh_Experience(main.experience, player)
    this.Refresh_XPProgress(main.xp_progress, player)

    -------------------------------- Show ui elements --------------------------------

    --Draw_Label(main.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(main.consoleWarning, vars_ui.style.colors, window.width, window.height, const)

    if Draw_CheckBox(main.should_autoshow, vars_ui.style.checkbox, vars_ui.style.colors, window.width, window.height, const) then
        this.Update_ShouldAutoShow(main.should_autoshow, vars_ui, const)
    end

    if Draw_SummaryButton(main.input_bindings, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_InputBindings(vars_ui, const)
    end

    if Draw_SummaryButton(main.energyTank, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_Energy_Tank(vars_ui, const)
    end

    for i = 1, 6 do
        if Draw_RemoveButton(main["remove" .. tostring(i)], vars_ui.style.removeButton, window.left, window.top, window.width, window.height, const) then
            --NOTE: This immediately removes the grapple.  Most actions populate a change list and require ok/cancel.  But that would be difficult in this case (a change that spans windows)
            this.RemoveGrapple(player, i)
        end
    end

    for i = 1, 6 do
        if Draw_SummaryButton(main["grapple" .. tostring(i)], vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
            TransitionWindows_Grapple(vars_ui, const, player, i)
        end
    end

    Draw_OrderedList(main.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)
    Draw_ProgressBarSlim(main.xp_progress, vars_ui.style.progressbar_slim, vars_ui.style.colors, window.width, window.height, const)

    local _, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)

    return not (isCloseRequested or isCloseClicked)       -- stop showing when they click the close button (or press config key a second time.  This main page doesn't have anything to save, so it's ok to exit at any time)
end

----------------------------------- Private Methods -----------------------------------

--NOTE: Define functions get called during init.  Refresh functions get called each frame that the config is visible

function this.Define_ConsoleWarning(const)
    -- Label
    return
    {
        text = "NOTE: buttons won't respond unless the console window is also open",

        position =
        {
            pos_x = 0,
            pos_y = 24,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.top,
        },

        color = "info",
    }
end

function this.Define_ShouldAutoShow(const)
    -- CheckBox
    return
    {
        invisible_name = "Main_ShouldAutoShow",

        text = "Auto show config when opening console",

        isEnabled = true,

        position =
        {
            pos_x = 0,
            pos_y = 42,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.top,
        },

        foreground_override = "info",
    }
end
function this.Refresh_ShouldAutoShow(def, vars_ui)
    --NOTE: TransitionWindows_Main sets this to nil
    if def.isChecked == nil then
        def.isChecked = vars_ui.autoshow_withconsole
    end
end
function this.Update_ShouldAutoShow(def, vars_ui, const)
    -- In memory copy of the bool
    vars_ui.autoshow_withconsole = def.isChecked

    -- DB copy of the bool
    SetSetting_Bool(const.settings.AutoShowConfig_WithConsole, def.isChecked)
end

function this.Define_InputBindings(const)
    -- SummaryButton
    return
    {
        header_prompt = "Input Bindings",

        position =
        {
            pos_x = 48,
            pos_y = 72,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.top,
        },

        invisible_name = "Main_InputBindings",
    }
end

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

        border_cornerRadius_override = 16,

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

    local grapple, remove

    grapple, remove = this.Define_GrappleSlots_DoIt(-offset_x_small, -offset_y, "1", const)
    parent.grapple1 = grapple
    parent.remove1 = remove

    grapple, remove = this.Define_GrappleSlots_DoIt(offset_x_small, -offset_y, "2", const)
    parent.grapple2 = grapple
    parent.remove2 = remove

    grapple, remove = this.Define_GrappleSlots_DoIt(offset_x_large, 0, "3", const)
    parent.grapple3 = grapple
    parent.remove3 = remove

    grapple, remove = this.Define_GrappleSlots_DoIt(offset_x_small, offset_y, "4", const)
    parent.grapple4 = grapple
    parent.remove4 = remove

    grapple, remove = this.Define_GrappleSlots_DoIt(-offset_x_small, offset_y, "5", const)
    parent.grapple5 = grapple
    parent.remove5 = remove

    grapple, remove = this.Define_GrappleSlots_DoIt(-offset_x_large, 0, "6", const)
    parent.grapple6 = grapple
    parent.remove6 = remove
end
function this.Define_GrappleSlots_DoIt(x, y, suffix, const)
    return
        this.Define_GrappleSlots_Summary(x, y, suffix, const),
        --this.Define_GrappleSlots_Remove(x - 95, y + 50, suffix, const)
        --this.Define_GrappleSlots_Remove(x - 92, y + 53, suffix, const)
        this.Define_GrappleSlots_Remove(x - 92, y + 47, suffix, const)
end
function this.Define_GrappleSlots_Summary(x, y, suffix, const)
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

        border_cornerRadius_override = 24,

        suffix = suffix,

        invisible_name = "Main_Grapple_Summary_" .. suffix,
    }
end
function this.Define_GrappleSlots_Remove(x, y, suffix, const)
    -- RemoveButton
    return
    {
        position =
        {
            pos_x = x,
            pos_y = y,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Main_Grapple_Remove_" .. suffix,
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

function this.RemoveGrapple(player, index)
    local grapple = player:GetGrappleByIndex(index)
    if not grapple then
        do return end
    end

    player:SetGrappleByIndex(index, nil)
    player.experience = player.experience + grapple.experience

    player:Save()
end

function this.Refresh_Experience(def, player)
    def.content.available.value = tostring(math.floor(player.experience))
end

function this.Define_XPProgress(const)
    -- ProgressBar_Slim
    return
    {
        width = 155,

        position =
        {
            pos_x = 36,
            pos_y = 30,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        border_color = "xp_progress_border",
        background_color = "xp_progress_back",
        foreground_color = "xp_progress_fore",
    }
end
function this.Refresh_XPProgress(def, player)
    def.percent = player.experience - math.floor(player.experience)
end