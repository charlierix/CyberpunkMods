local this = {}

function DefineWindow_InputBindings(vars_ui, const)
    local input_bindings = {}
    vars_ui.input_bindings = input_bindings


    input_bindings.remove = this.Define_RemoveButton(const)


    input_bindings.watchedActions = this.Define_WatchedActions(const)
    --input_bindings.watchedActions_OLD = this.Define_WatchedActions_OLD(const)

    --TODO: Watched (not hotkeys, don't know what they're called)

    input_bindings.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

function DrawWindow_InputBindings(isCloseRequested, vars_ui, player, window, const)
    local input_bindings = vars_ui.input_bindings

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_WatchedActions(input_bindings.watchedActions, vars_ui.keys)
    --this.Refresh_WatchedActions_OLD(input_bindings.watchedActions_OLD, vars_ui.keys)

    this.Refresh_IsDirty(input_bindings.okcancel)

    -------------------------------- Show ui elements --------------------------------


    Draw_RemoveButton(input_bindings.remove, vars_ui.style.removeButton, window.left, window.top, window.width, window.height, const)


    Draw_MultiItemDisplayList(input_bindings.watchedActions, vars_ui.style.multiitem_displaylist, window.left, window.top, window.width, window.height, const, vars_ui.line_heights)
    --Draw_OrderedList(input_bindings.watchedActions_OLD, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)


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

function this.Define_WatchedActions_OLD(const)
    -- OrderedList
    return
    {
        content =
        {
            a = { prompt = "action name" },
        },

        position =
        {
            pos_x = 200,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        gap = 12,

        color_prompt = "info",
        color_value = "info",
    }
end
function this.Refresh_WatchedActions_OLD(def, keys)
    -- Remove existing
    for key, _ in pairs(def.content) do
        def.content[key] = nil
        def.content_keys[key] = nil
    end

    local sorted = {}

    for key, _ in pairs(keys.watching) do
        def.content[key] = { prompt = key }
        table.insert(sorted, key)
    end


    -- -- Can't sort the content table directly, need an index table so that ipairs can be used
    -- local keys = {}

    -- -- populate the table that holds the keys
    -- for key in pairs(content) do
    --     table.insert(keys, key)
    -- end

    -- sort the keys
    table.sort(sorted)

    def.content_keys = sorted


end

function this.Refresh_IsDirty(def)

    --TODO: Watch for unsaved bindings

    def.isDirty = false
end


function this.Define_RemoveButton(const)
    -- RemoveButton
    return
    {
        position =
        {
            pos_x = 0,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "InputBindings_Remove",
    }
end