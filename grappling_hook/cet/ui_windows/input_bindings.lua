local this = {}

local setting_bind = nil        -- if they click one of the summary buttons, this is the entry in input_bindings.bind_buttons that they clicked on

function DefineWindow_InputBindings(vars_ui, const)
    local input_bindings = {}
    vars_ui.input_bindings = input_bindings

    input_bindings.consoleWarning1 = this.Define_ConsoleWarning1(const)
    input_bindings.consoleWarning2 = this.Define_ConsoleWarning2(const)

    input_bindings.help1_label = this.Define_Help1_Label(const)
    input_bindings.help1_button = this.Define_Help1_Button(const)

    input_bindings.help2_label = this.Define_Help2_Label(const)
    input_bindings.help2_button = this.Define_Help2_Button(const)

    input_bindings.watchedActions = this.Define_WatchedActions(const)

    -------------- Standard Display --------------

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
    input_bindings.bind_buttons = this.Define_BindButtons(const)

    input_bindings.restore_defaults = this.Define_RestoreDefaults(vars_ui, const)

    -------------- Changing Binding --------------

    input_bindings.instruction1 = this.Define_Instruction1(const)
    input_bindings.instruction2 = this.Define_Instruction2(const)
    input_bindings.instruction3 = this.Define_Instruction3(const)

    input_bindings.cancel_bind = this.Define_CancelBind(const)

    ----------------------------------------------

    input_bindings.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function ActivateWindow_InputBindings(vars_ui)
    local bind_buttons = vars_ui.input_bindings.bind_buttons

    for i = 1, #bind_buttons do
        bind_buttons[i].isDeleteChange = false
        bind_buttons[i].newActions = nil
    end

    vars_ui.keys:StartWatching()
end

function DrawWindow_InputBindings(isCloseRequested, vars, vars_ui, player, o, window, const)
    local input_bindings = vars_ui.input_bindings

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_WatchedActions(input_bindings.watchedActions, vars_ui.keys)

    for i = 1, #input_bindings.bind_buttons do
        this.Refresh_BindButtons_Summary(input_bindings.bind_buttons[i], vars.startStopTracker)
    end

    this.Refresh_IsDirty(input_bindings.okcancel, input_bindings.bind_buttons)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(input_bindings.consoleWarning1, vars_ui.style.colors, window.width, window.height, const)
    Draw_Label(input_bindings.consoleWarning2, vars_ui.style.colors, window.width, window.height, const)

    Draw_Label(input_bindings.help1_label, vars_ui.style.colors, window.width, window.height, const)
    Draw_HelpButton(input_bindings.help1_button, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

    Draw_Label(input_bindings.help2_label, vars_ui.style.colors, window.width, window.height, const)
    Draw_HelpButton(input_bindings.help2_button, vars_ui.style.helpButton, window.left, window.top, window.width, window.height, const, vars_ui)

    Draw_MultiItemDisplayList(input_bindings.watchedActions, vars_ui.style.multiitem_displaylist, window.left, window.top, window.width, window.height, const, vars_ui.line_heights)

    if setting_bind then
        -------------- Changing Binding --------------

        local newActions, isFinishedWaiting = this.GetFinalObservedActionNames(vars_ui.keys, vars.startStopTracker, o)
        if isFinishedWaiting then
            setting_bind.newActions = newActions
            setting_bind.isDeleteChange = false

            setting_bind = nil

            vars_ui.keys:StopLatchingWatched()
        end

        Draw_Label(input_bindings.instruction1, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(input_bindings.instruction2, vars_ui.style.colors, window.width, window.height, const)
        Draw_Label(input_bindings.instruction3, vars_ui.style.colors, window.width, window.height, const)

        if Draw_Button(input_bindings.cancel_bind, vars_ui.style.button, window.width, window.height, const) then
            setting_bind = nil
        end
    else
        -------------- Standard Display --------------

        for i = 1, #input_bindings.bind_buttons do
            local current = input_bindings.bind_buttons[i]

            local summary_click, summary_hover = Draw_SummaryButton(current.summary, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const)
            local remove_click, remove_hover = Draw_RemoveButton(current.remove, vars_ui.style.removeButton, window.left, window.top, window.width, window.height, const)

            if remove_hover then
                this.Draw_Remove_Tooltip(current, vars_ui, window, const)
            elseif summary_hover then
                this.Draw_Summary_Tooltips(current, vars, vars_ui, window, const)
            end

            if remove_click then
                current.isDeleteChange = true
                current.newActions = nil
            elseif summary_click then
                setting_bind = current
                vars_ui.keys:StartLatchingWatched()     -- don't want quickly pressed keys to be forgotten
            end
        end

        if Draw_Button(input_bindings.restore_defaults, vars_ui.style.button, window.width, window.height, const) then
            this.RestoreDefaults(input_bindings.bind_buttons, const)
        end
    end

    -- OK/Cancel
    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(input_bindings.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(input_bindings.bind_buttons, vars.startStopTracker, vars_ui.keys)
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
            pos_x = -160,
            pos_y = 48,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.top,
        },

        color = "info",
    }
end
function this.Define_ConsoleWarning2(const)
    -- Label
    return
    {
        text = "cet console needs to be CLOSED when listening for key presses",

        position =
        {
            pos_x = -160,
            pos_y = 66,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.top,
        },

        color = "info",
    }
end

function this.Define_Help1_Label(const)
    -- Label
    return
    {
        text = "actions vs cet inputs",

        position =
        {
            pos_x = 45,
            pos_y = 24,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },

        color = "help",
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
            pos_y = 24,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },
    }

    retVal.tooltip =
[[There are quite a few built in keys that could be reused for grapple if a couple keys are pressed at the same time

A key can only be tied to a CET input once for a single mod

This page gets around this by listening for in game keys and allowing multiple keys to be pressed at the same time

Any combination of CET inputs and in game keys can be mixed in this window's bindings]]

    return retVal
end

function this.Define_Help2_Label(const)
    -- Label
    return
    {
        text = "filter secondary actions",

        position =
        {
            pos_x = 45,
            pos_y = 45,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },

        color = "help",
    }
end
function this.Define_Help2_Button(const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "InputBindings_Help2",

        position =
        {
            pos_x = 24,
            pos_y = 45,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },
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

        width = 288,
        height = 600,

        position =
        {
            pos_x = 48,
            pos_y = 0,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.center,
        },
    }
end
function this.Refresh_WatchedActions(def, keys)
    --TODO: It's really inefficient to rebuild this every frame.  Do some compares to see if anything changed
    --But the list will likely be empty most of the time, so that might be a lot of errort for nothing

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

function this.Define_BindButtons(const)
    local base_x = 280
    local base_y = -60

    local offset_x_small = 90
    local offset_x_large = 190
    local offset_y = 110

    local offset_y_stop = 280

    local retVal = {}

    -- Create summary/remove buttons in a hexagon
    retVal[#retVal+1] = this.Define_BindButtons_Set(const.bindings.grapple1, base_x - offset_x_small, base_y - offset_y, const)
    retVal[#retVal+1] = this.Define_BindButtons_Set(const.bindings.grapple2, base_x + offset_x_small, base_y - offset_y, const)
    retVal[#retVal+1] = this.Define_BindButtons_Set(const.bindings.grapple3, base_x + offset_x_large, base_y, const)
    retVal[#retVal+1] = this.Define_BindButtons_Set(const.bindings.grapple4, base_x + offset_x_small, base_y + offset_y, const)
    retVal[#retVal+1] = this.Define_BindButtons_Set(const.bindings.grapple5, base_x - offset_x_small, base_y + offset_y, const)
    retVal[#retVal+1] = this.Define_BindButtons_Set(const.bindings.grapple6, base_x - offset_x_large, base_y, const)

    -- Create the stop button pair below
    retVal[#retVal+1] = this.Define_BindButtons_Set(const.bindings.stop, base_x, base_y + offset_y_stop, const)

    return retVal
end
function this.Define_BindButtons_Set(binding, x, y, const)
    --TODO: Placement should be Summary as absolute.  Then remove, summary_hover_label should be relative to that
    return
    {
        binding = binding,
        summary = this.Define_BindButtons_Summary(x, y, binding, const),
        remove = this.Define_BindButtons_Remove(x - 9, y + 30, binding, const),
        summary_hover_label = this.Define_BindButtons_SummaryHoverLabel(x - 22, y + 54, const),
        remove_hover_label = this.Define_BindButtons_RemoveHoverLabel(x + 16, y + 58, const),

        isDeleteChange = false,
        --newActions = nil,     -- this won't stick unless there's a value.  But this property will exist if they change values
    }
end
function this.Define_BindButtons_Summary(x, y, name, const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = x,
            pos_y = y,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },

        min_width = 80,
        min_height = 20,

        -- Refresh will either populate the header or the unused

        invisible_name = "InputBindings_Summary_" .. name,
    }
end
function this.Define_BindButtons_Remove(x, y, name, const)
    -- RemoveButton
    return
    {
        position =
        {
            pos_x = x,
            pos_y = y,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "InputBindings_Remove_" .. name,
    }
end
function this.Define_BindButtons_SummaryHoverLabel(x, y, const)
    -- Label
    return
    {
        text = "Click to edit bindings",

        position =
        {
            pos_x = x,
            pos_y = y,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },

        color = "hint",
    }
end
function this.Define_BindButtons_RemoveHoverLabel(x, y, const)
    -- Label
    return
    {
        text = "Clear Binding",

        position =
        {
            pos_x = x,
            pos_y = y,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },

        color = "hint",
    }
end

function this.Refresh_BindButtons_Summary(def, startStopTracker)
    if this.GetActionList(def, startStopTracker) then
        def.summary.header_prompt = def.binding
        def.summary.unused_text = nil
    else
        def.summary.unused_text = def.binding
        def.summary.header_prompt = nil
    end
end

function this.Draw_Remove_Tooltip(current, vars_ui, window, const)

    -- The tooltip looks out of place when the summary uses a label

    -- --TODO: Drawing controls should be broken into two calls: GetPosition, Draw.  Then the position would already be known by this point
    -- --That also adds the ability to place controls relative to each other (position = const.alignment_horizontal.right_of <control>)
    -- local radius = vars_ui.style.removeButton.radius
    -- local notouch = radius + 12

    -- local left, top = GetControlPosition(current.remove.position, radius * 2, radius * 2, window.width, window.height, const)

    -- Draw_Tooltip("Clear Binding", vars_ui.style.tooltip, window.left + left + radius, window.top + top + radius, notouch, notouch, vars_ui)


    Draw_Label(current.remove_hover_label, vars_ui.style.colors, window.width, window.height, const)
end
function this.Draw_Summary_Tooltips(current, vars, vars_ui, window, const)
    Draw_Label(current.summary_hover_label, vars_ui.style.colors, window.width, window.height, const)

    local actionList = this.GetActionList(current, vars.startStopTracker)
    if actionList then
        local actionSummary = String_Join("\n", actionList)
        local sum_width = current.summary.min_width + vars_ui.style.summaryButton.padding
        local sum_height = current.summary.min_height + vars_ui.style.summaryButton.padding

        local gap = 39

        --TODO: Same note about relative positioning as above.  This calculation on the fly is error prone and ugly
        local left, top = GetControlPosition(current.summary.position, sum_width, sum_height, window.width, window.height, const)

        Draw_Tooltip(actionSummary, vars_ui.style.tooltip, window.left + left + (sum_width / 2), window.top + top + (sum_height / 2), (sum_width / 2) + gap, (sum_height / 2) + gap, vars_ui)
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
            pos_x = -160,
            pos_y = -180,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "instruction",
    }
end
function this.Define_Instruction2(const)
    -- Label
    return
    {
        text = "Press desired keys at the same time",

        position =
        {
            pos_x = -160,
            pos_y = -40,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "instruction",
    }
end
function this.Define_Instruction3(const)
    -- Label
    return
    {
        text = "Make sure you don't interact with items (doors, etc)",

        position =
        {
            pos_x = -160,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "instruction",
    }
end

function this.Define_CancelBind(const)
    -- Button
    return
    {
        text = "Cancel",

        position =
        {
            pos_x = -160,
            pos_y = 180,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "hint",
    }
end

function this.Refresh_IsDirty(def, bind_buttons)
    def.isDirty = false

    for i = 1, #bind_buttons do
        if bind_buttons[i].isDeleteChange or bind_buttons[i].newActions then
            def.isDirty = true
            break
        end
    end
end

function this.Save(bind_buttons, startStopTracker, keys)
    -- Update DB and startStopTracker
    for i = 1, #bind_buttons do
        if bind_buttons[i].isDeleteChange then
            SetInputBinding(bind_buttons[i].binding, nil)
            startStopTracker:ClearBinding(bind_buttons[i].binding)

        elseif bind_buttons[i].newActions then
            SetInputBinding(bind_buttons[i].binding, bind_buttons[i].newActions)
            startStopTracker:UpdateBinding(bind_buttons[i].binding, bind_buttons[i].newActions)
        end
    end

    -- Update keys, so it knows what to look for
    keys:ClearActions()

    for i=1, #startStopTracker.keynames do
        keys:AddAction(startStopTracker.keynames[i])
    end
end

function this.GetActionList(def, startStopTracker)
    if def.isDeleteChange then
        return nil
    end

    if def.newActions then
        return def.newActions
    end

    return startStopTracker:GetActionNames(def.binding)
end

-- This returns the action names that were pressed down within the time window (relative
-- to the first key press)
-- Returns:
--  newActions          A list of action names
--  isFinishedWaiting   True if they have pressed keys and enough time has elapsed that any more key presses would be ignored
function this.GetFinalObservedActionNames(keys, startStopTracker, o)
    local timespan = startStopTracker:GetMaxElapsedTime() * 2       -- giving it a little extra time, so it's less frustrating

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