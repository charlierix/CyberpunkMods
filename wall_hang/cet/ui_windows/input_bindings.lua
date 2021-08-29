local this = {}

local setting_bind = nil        -- if they click one of the summary buttons, this is the entry in input_bindings.bind_buttons that they clicked on

function DefineWindow_InputBindings(vars_ui, const)
    local input_bindings = {}
    vars_ui.input_bindings = input_bindings

    input_bindings.consoleWarning1 = this.Define_ConsoleWarning1(const)
    input_bindings.consoleWarning2 = this.Define_ConsoleWarning2(input_bindings.consoleWarning1, const)

    input_bindings.help1_button = this.Define_Help1_Button(const)
    input_bindings.help1_label = this.Define_Help1_Label(input_bindings.help1_button, const)

    input_bindings.help2_button = this.Define_Help2_Button(input_bindings.help1_button, const)
    input_bindings.help2_label = this.Define_Help2_Label(input_bindings.help2_button, const)

    input_bindings.watchedActions = this.Define_WatchedActions(const)

    -------------- Standard Display --------------

    -- Checkbox for whether to use action name binding (vars.wallhangkey_usecustom)
    input_bindings.usecustom_wallhang = this.Define_UseCustomWallHang(const)
    input_bindings.usecustom_wallhang_help = this.Define_UseCustomWallHang_Help(input_bindings.usecustom_wallhang, const)

    -- {
    --     {
    --         binding = const.bindings enum,
    --         summary = SummaryButton,
    --         remove = RemoveButton,
    --         summary_hover_label = Label,
    --         remove_hover_label = Label,
    --         isDeleteChange,
    --         newActions = {"action1", "action2"}
    --     },
    --     {...},
    --     {...},
    -- }
    input_bindings.bind_buttons = this.Define_BindButtons(input_bindings.usecustom_wallhang, const)

    input_bindings.restore_defaults = this.Define_RestoreDefaults(vars_ui, const)

    -------------- Changing Binding --------------

    input_bindings.instruction1 = this.Define_Instruction1(const)
    input_bindings.instruction2 = this.Define_Instruction2(const)

    input_bindings.cancel_bind = this.Define_CancelBind(const)

    ----------------------------------------------

    input_bindings.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(input_bindings)
end

function ActivateWindow_InputBindings(vars_ui, const)
    if not vars_ui.input_bindings then
        DefineWindow_InputBindings(vars_ui, const)
    end

    vars_ui.input_bindings.usecustom_wallhang.isChecked = nil

    local bind_buttons = vars_ui.input_bindings.bind_buttons

    for i = 1, #bind_buttons do
        bind_buttons[i].isDeleteChange = false
        bind_buttons[i].newActions = nil
    end

    vars_ui.keys:StartWatching()
end

function DrawWindow_InputBindings(isCloseRequested, vars, vars_ui, o, window, const)
    local input_bindings = vars_ui.input_bindings

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_WatchedActions(input_bindings.watchedActions, vars_ui.keys)

    this.Refresh_UseCustomWallHang(input_bindings.usecustom_wallhang, vars)

    for i = 1, #input_bindings.bind_buttons do
        this.Refresh_BindButtons_Summary(input_bindings.bind_buttons[i], vars_ui.keys)
    end

    this.Refresh_IsDirty(input_bindings.okcancel, vars, input_bindings.usecustom_wallhang, input_bindings.bind_buttons)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(input_bindings.render_nodes, vars_ui.style, vars_ui.line_heights)
    CalculatePositions(input_bindings.render_nodes, window.width, window.height, const)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(input_bindings.consoleWarning1, vars_ui.style.colors)
    Draw_Label(input_bindings.consoleWarning2, vars_ui.style.colors)

    Draw_Label(input_bindings.help1_label, vars_ui.style.colors)
    Draw_HelpButton(input_bindings.help1_button, vars_ui.style.helpButton, window.left, window.top, vars_ui)

    Draw_Label(input_bindings.help2_label, vars_ui.style.colors)
    Draw_HelpButton(input_bindings.help2_button, vars_ui.style.helpButton, window.left, window.top, vars_ui)

    Draw_MultiItemDisplayList(input_bindings.watchedActions, vars_ui.style.multiitem_displaylist, window.left, window.top, vars_ui.line_heights)

    if setting_bind then
        -------------- Changing Binding --------------

        local newActions, isFinishedWaiting = this.GetFinalObservedActionNames(vars_ui.keys, o)
        if isFinishedWaiting then
            setting_bind.newActions = newActions
            setting_bind.isDeleteChange = false

            setting_bind = nil

            vars_ui.keys:StopLatchingWatched()
        end

        Draw_Label(input_bindings.instruction1, vars_ui.style.colors)
        Draw_Label(input_bindings.instruction2, vars_ui.style.colors)

        if Draw_Button(input_bindings.cancel_bind, vars_ui.style.button) then
            setting_bind = nil
        end
    else
        -------------- Standard Display --------------

        Draw_CheckBox(input_bindings.usecustom_wallhang, vars_ui.style.checkbox, vars_ui.style.colors)
        Draw_HelpButton(input_bindings.usecustom_wallhang_help, vars_ui.style.helpButton, window.left, window.top, vars_ui)

        for i = 1, #input_bindings.bind_buttons do
            local current = input_bindings.bind_buttons[i]

            local shouldShow = false
            if current.binding == const.bindings.hang then
                shouldShow = not input_bindings.usecustom_wallhang.isChecked
            else
                print("ERROR: " .. current.binding)
            end

            if shouldShow then
                local summary_click, summary_hover = Draw_SummaryButton(current.summary, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top)
                local remove_click, remove_hover = Draw_RemoveButton(current.remove, vars_ui.style.removeButton, window.left, window.top)

                if remove_hover then
                    this.Draw_Remove_Tooltip(current, vars_ui)
                elseif summary_hover then
                    this.Draw_Summary_Tooltips(current, vars_ui, window)
                end

                if remove_click then
                    current.isDeleteChange = true
                    current.newActions = nil
                elseif summary_click then
                    setting_bind = current
                    vars_ui.keys:StartLatchingWatched()     -- don't want quickly pressed keys to be forgotten
                end
            end
        end

        if Draw_Button(input_bindings.restore_defaults, vars_ui.style.button) then
            this.RestoreDefaults(input_bindings.bind_buttons, const)
        end
    end

    -- OK/Cancel
    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(input_bindings.okcancel, vars_ui.style.okcancelButtons)
    if isOKClicked then
        --this.Save(input_bindings.bind_buttons, vars.startStopTracker, vars_ui.keys)
        this.Save(vars, const, input_bindings.usecustom_wallhang, input_bindings.bind_buttons, vars_ui.keys)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    --return not (isCloseRequested and not input_bindings.okcancel.isDirty)     -- returns if it should continue showing
    return true     -- input bindings need to ignore the cet console closing, so the only way off this page is ok/cancel buttons
end

----------------------------------- Private Methods -----------------------------------

function this.Define_ConsoleWarning1(const)
    -- Label
    return
    {
        text = "cet console needs to be OPEN for the mouse to click on buttons",

        position =
        {
            pos_x = -140,
            pos_y = 48,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.top,
        },

        color = "info",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_ConsoleWarning2(relative_to, const)
    -- Label
    return
    {
        text = "cet console needs to be CLOSED when listening for key presses",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 8,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "info",

        CalcSize = CalcSize_Label,
    }
end

function this.Define_Help1_Label(relative_to, const)
    -- Label
    return
    {
        text = "actions vs cet inputs",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "help",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Help1_Button(const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "InputBindings_Help1",

        position =
        {
            pos_x = 24,
            pos_y = 36,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[A key can only be tied to a CET input once for a single mod

Since wall hang will only be used when close to a wall, you'll probably want to repurpose an existing key (quick melee - Q is the default)

If you want to use a custom key from the cet bindings, then remove the binding on this page and just use the cet binding]]

    return retVal
end

function this.Define_Help2_Label(relative_to, const)
    -- Label
    return
    {
        text = "filter secondary actions",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        color = "help",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Help2_Button(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "InputBindings_Help2",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 8,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[When in game keys are pressed, there tend to be several actions tied to that single key.  Even more if you interact with in game objects

If one of these secondary action names is causing problems with grapple activating, you can suppress them by adding to a list of action names near the bottom of ui\keys.lua

This list is case sensitive

Also, post a message on nexus, so it can be fixed for everyone]]

    return retVal
end

function this.Define_WatchedActions(const)
    -- MultiItemDisplayList
    return
    {
        sets = {},

        width = 240,
        height = 370,

        position =
        {
            pos_x = 42,
            pos_y = 12,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_MultiItemDisplayList,
    }
end
function this.Refresh_WatchedActions(def, keys)
    --TODO: It's really inefficient to rebuild this every frame.  Do some compares to see if anything changed
    --But the list will likely be empty most of the time, so that might be a lot of effort for nothing

    local sets = {}

    for actionName, downTime in pairs(keys.watching) do
        local time_string = tostring(downTime)     -- this is the time that the key was pressed down

        -- Show all the actions that are the same time together in the same set
        local items = sets[time_string]
        if not items then
            items = {}
            sets[time_string] = items
        end

        items[#items+1] = actionName
    end

    def.sets = sets

    MultiItemDisplayList_SetsChanged(def)
end

function this.Define_UseCustomWallHang(const)
    -- CheckBox
    return
    {
        invisible_name = "InputBindings_UseCustomWallHang",

        text = "Use CET Binding (wallhang)",

        isEnabled = true,

        position =
        {
            pos_x = -180,
            pos_y = -120,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_UseCustomWallHang(def, vars)
    --NOTE: TransitionWindows_Straight_AntiGrav sets this to nil
    if def.isChecked == nil then
        def.isChecked = vars.wallhangkey_usecustom
    end
end

function this.Define_UseCustomWallHang_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "InputBindings_UseCustomWallHang_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[  Checked: Use the key in cet -> bindings -> inputs
Unchecked: Use the binding defined in the button below

You would only want to check this if the key to use isn't an action known by the game (like F1 or something)]]

    return retVal
end

function this.Define_BindButtons(checkbox_wallhang, const)
    local retVal = {}

    -- Wall Hang
    retVal[#retVal+1] = this.Define_BindButtons_Set(const.bindings.hang, checkbox_wallhang, const)

    --TODO: Wall Run

    return retVal
end
function this.Define_BindButtons_Set(binding, relative_to, const)
    local summary = this.Define_BindButtons_Summary(relative_to, binding, const)
    local remove = this.Define_BindButtons_Remove(summary, binding, const)
    local summary_hover_label = this.Define_BindButtons_SummaryHoverLabel(summary, const)
    local remove_hover_label = this.Define_BindButtons_RemoveHoverLabel(summary, const)

    return
    {
        binding = binding,

        summary = summary,
        remove = remove,
        summary_hover_label = summary_hover_label,
        remove_hover_label = remove_hover_label,

        isDeleteChange = false,
        --newActions = nil,     -- this won't stick unless there's a value.  But this property will exist if they change values
    }
end
function this.Define_BindButtons_Summary(relative_to, name, const)
    -- SummaryButton
    return
    {
        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 18,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        min_width = 80,
        min_height = 20,

        -- Refresh will either populate the header or the unused

        invisible_name = "InputBindings_Summary_" .. name,

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Define_BindButtons_Remove(relative_to, name, const)
    -- RemoveButton
    return
    {
        position =
        {
            relative_to = relative_to,

            pos_x = -8,
            pos_y = -8,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.bottom,
        },

        invisible_name = "InputBindings_Remove_" .. name,

        CalcSize = CalcSize_RemoveButton,
    }
end
function this.Define_BindButtons_SummaryHoverLabel(relative_to, const)
    -- Label
    return
    {
        text = "Click to edit binding",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 18,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "hint",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_BindButtons_RemoveHoverLabel(relative_to, const)
    -- Label
    return
    {
        text = "Clear Binding",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 18,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "hint",

        CalcSize = CalcSize_Label,
    }
end

function this.Refresh_BindButtons_Summary(def, keys)
    if this.GetActionList(def, keys) then
        def.summary.header_prompt = def.binding
        def.summary.unused_text = nil
    else
        def.summary.unused_text = def.binding
        def.summary.header_prompt = nil
    end
end

function this.Draw_Remove_Tooltip(current, vars_ui)
    Draw_Label(current.remove_hover_label, vars_ui.style.colors)
end
function this.Draw_Summary_Tooltips(current, vars_ui, window)
    Draw_Label(current.summary_hover_label, vars_ui.style.colors)

    local actionList = this.GetActionList(current, vars_ui.keys)
    if actionList then
        local actionSummary = String_Join("\n", actionList)

        local sum_width = current.summary.render_pos.width
        local sum_height = current.summary.render_pos.height

        local gap = 24

        Draw_Tooltip(
            actionSummary,
            vars_ui.style.tooltip,
            window.left + current.summary.render_pos.left + (sum_width / 2),
            window.top + current.summary.render_pos.top + (sum_height / 2),
            (sum_width / 2) + gap,
            (sum_height / 2) + gap,
            vars_ui)
    end
end

function this.Define_RestoreDefaults(vars_ui, const)
    -- Button
    return
    {
        text = "Restore Defaults",

        width_override = 140,

        position =
        {
            pos_x = vars_ui.style.okcancelButtons.pos_x,        -- same margin as ok/cancel, but aligned left instead
            pos_y = vars_ui.style.okcancelButtons.pos_y,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        color = "hint",

        CalcSize = CalcSize_Button,
    }
end

function this.RestoreDefaults(bind_buttons, const)
    -- Default them all to delete in case default bindings miss any
    for i = 1, #bind_buttons do
        bind_buttons[i].isDeleteChange = true
        bind_buttons[i].newActions = nil
    end

    -- Apply the defaults
    for binding, actionNames in pairs(GetDefaultInputBindings(const)) do
        for i = 1, #bind_buttons do
            if bind_buttons[i].binding == binding then
                bind_buttons[i].isDeleteChange = false
                bind_buttons[i].newActions = actionNames
                break
            end
        end
    end
end

function this.Define_Instruction1(const)
    -- Label
    return
    {
        text = "Close CET console before pressing keys",

        position =
        {
            pos_x = -140,
            pos_y = -110,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "instruction",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Instruction2(const)
    -- Label
    return
    {
        text = "Make sure you don't interact with items (doors, etc)",

        position =
        {
            pos_x = -140,
            pos_y = -30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "instruction",

        CalcSize = CalcSize_Label,
    }
end

function this.Define_CancelBind(const)
    -- Button
    return
    {
        text = "Cancel",

        position =
        {
            pos_x = -140,
            pos_y = 180,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "hint",

        CalcSize = CalcSize_Button,
    }
end

function this.Refresh_IsDirty(def, vars, usecustom_wallhang, bind_buttons)
    def.isDirty = false

    if vars.wallhangkey_usecustom ~= usecustom_wallhang.isChecked then
        def.isDirty = true
        do return end
    end

    for i = 1, #bind_buttons do
        if bind_buttons[i].isDeleteChange or bind_buttons[i].newActions then
            def.isDirty = true
            break
        end
    end
end

--function this.Save(bind_buttons, startStopTracker, keys)
function this.Save(vars, const, usecustom_wallhang, bind_buttons, keys)
    -- Update DB is vars
    SetSetting_Bool(const.settings.WallHangKey_UseCustom, vars.wallhangkey_usecustom)

    vars.wallhangkey_usecustom = usecustom_wallhang.isChecked

    -- Update DB and keys
    for i = 1, #bind_buttons do
        if bind_buttons[i].isDeleteChange then
            SetInputBinding(bind_buttons[i].binding, nil)

            if bind_buttons[i].binding == const.bindings.hang then
                keys:ClearHangActions()
            else
                print("ERROR: " .. bind_buttons[i].binding)
            end

        elseif bind_buttons[i].newActions then
            SetInputBinding(bind_buttons[i].binding, bind_buttons[i].newActions)

            if bind_buttons[i].binding == const.bindings.hang then
                keys:SetHangActions(bind_buttons[i].newActions)
            else
                print("ERROR: " .. bind_buttons[i].binding)
            end
        end
    end
end

function this.GetActionList(def, keys)
    if def.isDeleteChange then
        return nil
    end

    if def.newActions then
        return def.newActions
    end

    return keys:GetActionNames(def.binding)
end

-- This returns the action names that were pressed down within the time window (relative
-- to the first key press)
-- Returns:
--  newActions          A list of action names
--  isFinishedWaiting   True if they have pressed keys and enough time has elapsed that any more key presses would be ignored
function this.GetFinalObservedActionNames(keys, o)
    --NOTE: This is copied from grappling hook, which allows for multiple buttons to be pressed at the same time
    --Wall hang should just tie to one, but should still give enough time for all the action events to fire when
    --pushing a button
    local timespan = 0.06

    -- First pass, look for the min time
    local min_time = nil

    for _, downTime in pairs(keys.watching) do
        if not min_time or downTime < min_time then
            min_time = downTime
        end
    end

    if not min_time then
        -- They haven't pressed any keys yet
        return nil, false

    elseif o.timer - min_time < timespan then
        -- They pressed a key, but need to wait longer in case they press more keys
        return nil, false       -- don't bother building an array here, it will be ignored anyway
    end

    -- Second pass, build array
    local actionNames = {}

    for actionName, downTime in pairs(keys.watching) do
        if downTime - min_time <= timespan then
            actionNames[#actionNames+1] = actionName
        end
    end

    return actionNames, true
end