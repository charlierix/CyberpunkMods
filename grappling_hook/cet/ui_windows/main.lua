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
    main.should_autoshow = this.Define_ShouldAutoShow(main.consoleWarning, const)

    main.input_bindings = this.Define_InputBindings(const)

    ------- Unlocked -------
    main.energyTank = this.Define_EnergyTank(const)

    this.Define_GrappleSlots(main, const)

    main.experience = Define_Experience(const, nil, 15)
    main.xp_progress = this.Define_XPProgress(const)

    ------- Locked -------
    --NOTE: the gridview is set as the parent, everything is relative to that, so they are defined in a funny order
    --TODO: this would be a great place for a panel control.  Add these to that control, then just place the panel relative to the center of the page

    main.unlock_grid = this.Define_UnlockGrid(const)

    main.unlock_note = this.Define_UnlockNote(main.unlock_grid, const)

    main.unlock_extra_label = this.Define_UnlockExtraLabel(main.unlock_note, const)
    main.unlock_extra_help = this.Define_UnlockExtraHelp(main.unlock_extra_label, const)

    main.unlock_considered_label = this.Define_UnlockConsideredLabel(main.unlock_extra_label, const)
    main.unlock_considered_help = this.Define_UnlockConsideredHelp(main.unlock_considered_label, const)

    main.unlock_title = this.Define_UnlockTitle(main.unlock_note, const)

    main.unlock = this.Define_UnlockButton(main.unlock_grid, const)

    -------

    main.okcancel = Define_OkCancelButtons(true, vars_ui, const)

    FinishDefiningWindow(main)
end

function ActivateWindow_Main(vars_ui, const)
    if not vars_ui.main then
        DefineWindow_Main(vars_ui, const)
    end

    vars_ui.main.changes:Clear()

    vars_ui.main.should_autoshow.isChecked = nil

    vars_ui.main.last_reset_grid = 0

    vars_ui.keys:StopWatching()     -- doing this in case it came from the input bindings window (which put keys in a watching state)
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Main(isCloseRequested, vars_ui, player, window, o, const)
    local main = vars_ui.main

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_ShouldAutoShow(main.should_autoshow, vars_ui)

    if player.isUnlocked then
        this.Refresh_EnergyTank(main.energyTank, player.energy_tank)

        this.Refresh_GrappleSlot(main.grapple1, player.grapple1)
        this.Refresh_GrappleSlot(main.grapple2, player.grapple2)
        this.Refresh_GrappleSlot(main.grapple3, player.grapple3)
        this.Refresh_GrappleSlot(main.grapple4, player.grapple4)
        this.Refresh_GrappleSlot(main.grapple5, player.grapple5)
        this.Refresh_GrappleSlot(main.grapple6, player.grapple6)

        this.Refresh_Experience(main.experience, player)
        this.Refresh_XPProgress(main.xp_progress, player)
    else
        if (o.timer - main.last_reset_grid) > 0.5 then
            main.last_reset_grid = o.timer

            local report = GetUnlockReport(o, const)

            this.Refresh_UnlockGrid(vars_ui.main.unlock_grid, report)
            this.Refresh_UnlockButton(main.unlock, report)
        end
    end

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(main.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(main.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    --Draw_Label(main.title, vars_ui.style.colors, vars_ui.scale)

    Draw_Label(main.consoleWarning, vars_ui.style.colors, vars_ui.scale)

    if Draw_CheckBox(main.should_autoshow, vars_ui.style.checkbox, vars_ui.style.colors) then
        this.Update_ShouldAutoShow(main.should_autoshow, vars_ui, const)
    end

    if Draw_SummaryButton(main.input_bindings, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_InputBindings(vars_ui, const)
    end

    if player.isUnlocked then
        -------------- Unlocked --------------

        if Draw_SummaryButton(main.energyTank, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
            TransitionWindows_Energy_Tank(vars_ui, const)
        end

        for i = 1, 6 do
            if Draw_RemoveButton(main["remove" .. tostring(i)], vars_ui.style.removeButton, window.left, window.top, vars_ui.scale) then
                --NOTE: This immediately removes the grapple.  Most actions populate a change list and require ok/cancel.  But that would be difficult in this case (a change that spans windows)
                this.RemoveGrapple(player, i)
            end
        end

        for i = 1, 6 do
            if Draw_SummaryButton(main["grapple" .. tostring(i)], vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
                TransitionWindows_Grapple(vars_ui, const, player, i)
            end
        end

        Draw_OrderedList(main.experience, vars_ui.style.colors)
        Draw_ProgressBarSlim(main.xp_progress, vars_ui.style.progressbar_slim, vars_ui.style.colors, vars_ui.scale)
    else
        --------------- Locked ---------------

        Draw_Label(main.unlock_title, vars_ui.style.colors, vars_ui.scale)

        Draw_Label(main.unlock_note, vars_ui.style.colors, vars_ui.scale)

        Draw_Label(main.unlock_considered_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(main.unlock_considered_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

        Draw_Label(main.unlock_extra_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(main.unlock_extra_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

        Draw_GridView(main.unlock_grid, vars_ui.style.gridview, vars_ui.style.colors, const, vars_ui.scale)

        if Draw_Button(main.unlock, vars_ui.style.button, vars_ui.scale) then
            local success, errMsg = TryUnlockGrapple(o, player, const)
            if not success then
                LogError("ERROR Unlocking Grapple: " .. tostring(errMsg))
            end
        end
    end

    local _, isCloseClicked = Draw_OkCancelButtons(main.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)

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

        CalcSize = CalcSize_Label,
    }
end

function this.Define_ShouldAutoShow(relative_to, const)
    -- CheckBox
    return
    {
        invisible_name = "Main_ShouldAutoShow",

        text = "Auto show config when opening console",

        isEnabled = true,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 6,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        foreground_override = "info",

        CalcSize = CalcSize_CheckBox,
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

        CalcSize = CalcSize_SummaryButton,
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

        CalcSize = CalcSize_SummaryButton,
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

        CalcSize = CalcSize_SummaryButton,
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

        CalcSize = CalcSize_RemoveButton,
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

        CalcSize = CalcSize_ProgressBarSlim,
    }
end
function this.Refresh_XPProgress(def, player)
    def.percent = player.experience - math.floor(player.experience)
end

function this.Define_UnlockTitle(relative_to, const)
    -- Label
    return
    {
        text = "- Grappling Hook Locked -",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 50,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.top,
            vertical = const.alignment_vertical.bottom,
        },

        color = "title",

        CalcSize = CalcSize_Label,
    }
end

function this.Define_UnlockNote(relative_to, const)
    -- Label
    return
    {
        text = "These items will be consumed in order to craft the ability to use grappling hook",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 120,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.top,
            vertical = const.alignment_vertical.bottom,
        },

        color = "note_header",

        CalcSize = CalcSize_Label,
    }
end

function this.Define_UnlockExtraLabel(relative_to, const)
    -- Label
    return
    {
        text = "extra items",

        position =
        {
            relative_to = relative_to,

            pos_x = 20,
            pos_y = 20,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "note_header",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_UnlockExtraHelp(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Main_UnlockExtraHelp",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip = "If you have more items than necessary, then the scrapped items are chosen randomly.  Store what you care about in the trunk of your car"

    return retVal
end

function this.Define_UnlockConsideredLabel(relative_to, const)
    -- Label
    return
    {
        text = "which items are considered",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 10,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "note_header",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_UnlockConsideredHelp(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Main_UnlockConsideredHelp",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[only looks in the player's inventory

equipped items won't be scrapped (except grenades)

apartment/car trunk inventory is safe from scrapping

quest, legendary, iconic items are also ignored

silencers that are attached to weapons will be ignored]]

    return retVal
end

function this.Define_UnlockGrid(const)
    -- GridView
    return
    {
        headers =
        {
            {
                text = "item",
                horizontal = const.alignment_horizontal.left,
            },
            {
                text = "required",
                horizontal = const.alignment_horizontal.right,
            },
            {
                text = "available",
                horizontal = const.alignment_horizontal.right,
            },
        },

        -- Fill out the rows programatically
        cells = {},

        position =
        {
            pos_x = 0,
            pos_y = 70,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_GridView,
    }
end
function this.Refresh_UnlockGrid(def, report)
    def.cells = {}

    for i = 1, #report do
        local color_desc = nil
        local color_val = nil
        if report[i].availableCount >= report[i].requiredCount then
            color_val = "requirement_met"
        else
            color_val = "requirement_unmet"
            color_desc = color_val
        end

        def.cells[i] =
        {
            { text = report[i].description, foreground_override = color_desc },
            { text = report[i].requiredCount_display },
            { text = report[i].availableCount_display, foreground_override = color_val },
        }
    end
end

function this.Define_UnlockButton(relative_to, const)
    -- Button
    return
    {
        text = "Unlock",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 70,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "hint",

        isEnabled = false,

        CalcSize = CalcSize_Button,
    }
end
function this.Refresh_UnlockButton(def, report)
    local isEnabled = #report > 0

    for i = 1, #report do
        if report[i].availableCount < report[i].requiredCount then
            isEnabled = false
            break
        end
    end

    def.isEnabled = isEnabled
end