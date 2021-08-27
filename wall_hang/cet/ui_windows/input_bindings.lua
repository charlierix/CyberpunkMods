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





    --TODO: Checkbox - Use custom
    --  This controls whether to show action name binding
    --  vars.wallhangkey_usecustom






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
    --input_bindings.bind_buttons = this.Define_BindButtons(const)

    --input_bindings.restore_defaults = this.Define_RestoreDefaults(vars_ui, const)

    -------------- Changing Binding --------------

    -- input_bindings.instruction1 = this.Define_Instruction1(const)
    -- input_bindings.instruction2 = this.Define_Instruction2(const)
    -- input_bindings.instruction3 = this.Define_Instruction3(const)

    -- input_bindings.cancel_bind = this.Define_CancelBind(const)

    ----------------------------------------------

    input_bindings.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(input_bindings)
end

function ActivateWindow_InputBindings(vars_ui, const)
    if not vars_ui.input_bindings then
        DefineWindow_InputBindings(vars_ui, const)
    end

    -- local bind_buttons = vars_ui.input_bindings.bind_buttons

    -- for i = 1, #bind_buttons do
    --     bind_buttons[i].isDeleteChange = false
    --     bind_buttons[i].newActions = nil
    -- end

    vars_ui.keys:StartWatching()
end

function DrawWindow_InputBindings(isCloseRequested, vars, vars_ui, o, window, const)
    local input_bindings = vars_ui.input_bindings

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_WatchedActions(input_bindings.watchedActions, vars_ui.keys)

    -- for i = 1, #input_bindings.bind_buttons do
    --     this.Refresh_BindButtons_Summary(input_bindings.bind_buttons[i], vars.startStopTracker)
    -- end

    this.Refresh_IsDirty(input_bindings.okcancel, input_bindings.bind_buttons)

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

    -- if setting_bind then
    --     -------------- Changing Binding --------------

    --     local newActions, isFinishedWaiting = this.GetFinalObservedActionNames(vars_ui.keys, vars.startStopTracker, o)
    --     if isFinishedWaiting then
    --         setting_bind.newActions = newActions
    --         setting_bind.isDeleteChange = false

    --         setting_bind = nil

    --         vars_ui.keys:StopLatchingWatched()
    --     end

    --     Draw_Label(input_bindings.instruction1, vars_ui.style.colors)
    --     Draw_Label(input_bindings.instruction2, vars_ui.style.colors)
    --     Draw_Label(input_bindings.instruction3, vars_ui.style.colors)

    --     if Draw_Button(input_bindings.cancel_bind, vars_ui.style.button) then
    --         setting_bind = nil
    --     end
    -- else
    --     -------------- Standard Display --------------

    --     for i = 1, #input_bindings.bind_buttons do
    --         local current = input_bindings.bind_buttons[i]

    --         local summary_click, summary_hover = Draw_SummaryButton(current.summary, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top)
    --         local remove_click, remove_hover = Draw_RemoveButton(current.remove, vars_ui.style.removeButton, window.left, window.top)

    --         if remove_hover then
    --             this.Draw_Remove_Tooltip(current, vars_ui)
    --         elseif summary_hover then
    --             this.Draw_Summary_Tooltips(current, vars, vars_ui, window)
    --         end

    --         if remove_click then
    --             current.isDeleteChange = true
    --             current.newActions = nil
    --         elseif summary_click then
    --             setting_bind = current
    --             vars_ui.keys:StartLatchingWatched()     -- don't want quickly pressed keys to be forgotten
    --         end
    --     end

    --     if Draw_Button(input_bindings.restore_defaults, vars_ui.style.button) then
    --         this.RestoreDefaults(input_bindings.bind_buttons, const)
    --     end
    -- end

    -- OK/Cancel
    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(input_bindings.okcancel, vars_ui.style.okcancelButtons)
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

        CalcSize = CalcSize_Label,
    }
end
function this.Define_ConsoleWarning2(parent, const)
    -- Label
    return
    {
        text = "cet console needs to be CLOSED when listening for key presses",

        position =
        {
            relative_to = parent,

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

function this.Define_Help1_Label(parent, const)
    -- Label
    return
    {
        text = "actions vs cet inputs",

        position =
        {
            relative_to = parent,

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

function this.Define_Help2_Label(parent, const)
    -- Label
    return
    {
        text = "filter secondary actions",

        position =
        {
            relative_to = parent,

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
function this.Define_Help2_Button(parent, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "InputBindings_Help2",

        position =
        {
            relative_to = parent,

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

        width = 288,
        height = 600,

        position =
        {
            pos_x = 48,
            pos_y = 0,
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

function this.Refresh_IsDirty(def, bind_buttons)
    def.isDirty = false

    -- for i = 1, #bind_buttons do
    --     if bind_buttons[i].isDeleteChange or bind_buttons[i].newActions then
    --         def.isDirty = true
    --         break
    --     end
    -- end
end

function this.Save(bind_buttons, startStopTracker, keys)
    -- -- Update DB and startStopTracker
    -- for i = 1, #bind_buttons do
    --     if bind_buttons[i].isDeleteChange then
    --         SetInputBinding(bind_buttons[i].binding, nil)
    --         startStopTracker:ClearBinding(bind_buttons[i].binding)

    --     elseif bind_buttons[i].newActions then
    --         SetInputBinding(bind_buttons[i].binding, bind_buttons[i].newActions)
    --         startStopTracker:UpdateBinding(bind_buttons[i].binding, bind_buttons[i].newActions)
    --     end
    -- end

    -- -- Update keys, so it knows what to look for
    -- keys:ClearActions()

    -- for i=1, #startStopTracker.keynames do
    --     keys:AddAction(startStopTracker.keynames[i])
    -- end
end