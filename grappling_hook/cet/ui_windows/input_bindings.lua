local this = {}

function DefineWindow_InputBindings(vars_ui, const)
    local input_bindings = {}
    vars_ui.input_bindings = input_bindings


    -- Note about when to open and close cet console

    -- Restore defaults button



    input_bindings.watchedActions = this.Define_WatchedActions(const)

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

    input_bindings.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function DrawWindow_InputBindings(isCloseRequested, vars, vars_ui, player, window, const)
    local input_bindings = vars_ui.input_bindings

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_WatchedActions(input_bindings.watchedActions, vars_ui.keys)

    for i = 1, #input_bindings.bind_buttons do
        this.Refresh_BindButtons_Summary(input_bindings.bind_buttons[i], vars.startStopTracker)
    end

    this.Refresh_IsDirty(input_bindings.okcancel)

    -------------------------------- Show ui elements --------------------------------

    Draw_MultiItemDisplayList(input_bindings.watchedActions, vars_ui.style.multiitem_displaylist, window.left, window.top, window.width, window.height, const, vars_ui.line_heights)

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
        end

        -- elseif summaryClick
        -- elseif summaryHover and isBound (show tooltip with the action names)


    end

    -- OK/Cancel
    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(input_bindings.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        --this.Save(player, changes)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    --return not (isCloseRequested and not input_bindings.okcancel.isDirty)     -- returns if it should continue showing
    return true     -- input bindings need to ignore the cet console closing, so the only way off this page is ok/cancel buttons
end

----------------------------------- Private Methods -----------------------------------

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
    local base_x = 240
    local base_y = 0

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


function this.GetActionList(def, startStopTracker)
    if def.isDeleteChange then
        return nil
    end

    if def.newActions then
        return def.newActions
    end

    return startStopTracker:GetActionNames(def.binding)
end







function this.Refresh_IsDirty(def)

    --TODO: Watch for unsaved bindings

    def.isDirty = false
end







