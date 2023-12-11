local this = {}

local datautil = require "data/datautil"

-- This is 1:1 with choose_mode.available.items, and holds additional info about each item
-- NOTE: the entry for the separator lines are empty arrays
-- { { isDefault, modeKey, mode }, {...}, {...} }
local available_info = nil

-- This gets called during activate and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_ChooseMode(vars_ui, const)
    local choose_mode = {}
    vars_ui.choose_mode = choose_mode

    choose_mode.title = Define_Title("Choose a Mode", const)

    choose_mode.available = this.Define_Available(const)

    choose_mode.name = this.Define_Name(const)
    choose_mode.is_default = this.Define_IsDefault(choose_mode.name, const)
    choose_mode.description = this.Define_Description(choose_mode.name, const)

    choose_mode.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(choose_mode)
end

function ActivateWindow_ChooseMode(vars_ui, const)
    if not vars_ui.mode_energy then
        DefineWindow_ChooseMode(vars_ui, const)
    end

    local choose_mode = vars_ui.choose_mode

    available_info = nil
    choose_mode.available.items = nil
    choose_mode.available.selectable = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_ChooseMode(isCloseRequested, vars, vars_ui, player, window, o, const)
    local choose_mode = vars_ui.choose_mode

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Available(choose_mode.available, vars.sounds_thrusting, const)

    this.Refresh_Name(choose_mode.name, choose_mode.available.selected_index)
    this.Refresh_IsDefault(choose_mode.is_default, choose_mode.available.selected_index)
    this.Refresh_Description(choose_mode.description, choose_mode.available.selected_index)

    this.Refresh_IsDirty(choose_mode.okcancel, choose_mode.available.selected_index)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(choose_mode.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(choose_mode.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(choose_mode.title, vars_ui.style.colors, vars_ui.scale)

    Draw_ListBox(choose_mode.available, vars_ui.style.listbox, vars_ui.scale)

    Draw_Label(choose_mode.name, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(choose_mode.is_default, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(choose_mode.description, vars_ui.style.colors, vars_ui.scale)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(choose_mode.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, choose_mode.available.selected_index, vars_ui.transition_info.mode_index)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not choose_mode.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Available(const)
    -- ListBox
    return
    {
        invisible_name = "ChooseMode_Available",

        -- These are populated for real in activate
        items = {},
        selected_index = 0,

        width = 340,
        height = 450,

        position =
        {
            pos_x = 36,
            pos_y = 48,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_ListBox,
    }
end
function this.Refresh_Available(def, sounds_thrusting, const)
    if not available_info then
        local info, items, selectable = this.GetModes(sounds_thrusting, const)

        available_info = info
        def.items = items                 -- list of strings to display
        def.selectable = selectable       -- list of bools
        def.selected_index = 0
    end
end

function this.Define_Name(const)
    -- Label
    return
    {
        text = "",

        position =
        {
            pos_x = 36,
            pos_y = -90,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },

        color = "modelistitem_name",

        CalcSize = CalcSize_Label,
    }
end
function this.Refresh_Name(def, selected_index)
    if available_info and selected_index > 0 then
        def.text = available_info[selected_index].mode.name
    else
        def.text = ""
    end
end

function this.Define_IsDefault(relative_to, const)
    -- Label
    return
    {
        text = "",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 36,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.top,
            vertical = const.alignment_vertical.bottom,
        },

        color = "subTitle",

        CalcSize = CalcSize_Label,
    }
end
function this.Refresh_IsDefault(def, selected_index)
    if available_info and selected_index > 0 then
        if available_info[selected_index].isDefault then
            def.text = "default"
        else
            def.text = "modified"
        end
    else
        def.text = ""
    end
end

function this.Define_Description(relative_to, const)
    -- Label
    return
    {
        text = "",

        max_width = 320,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 12,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "modelistitem_description",

        CalcSize = CalcSize_Label,
    }
end
function this.Refresh_Description(def, selected_index)
    if available_info and selected_index > 0 then
        def.text = available_info[selected_index].mode.description
    else
        def.text = ""
    end
end

function this.Refresh_IsDirty(def, selected_index)
    def.isDirty = selected_index > 0
end

function this.Save(player, selected_index, insert_index)
    if insert_index < 1 or insert_index > #player.mode_keys + 1 then
        LogError("Mode Chooser Save: Invalid insert index, adding to the end: " .. tostring(insert_index) .. " | " .. tostring(#player.mode_keys))
        insert_index = #player.mode_keys + 1
    end

    table.insert(player.mode_keys, available_info[selected_index].modeKey)

    player:Save()
end

---------------------------------------------------------------------------------------

function this.GetModes(sounds_thrusting, const)
    local modes, errMsg = datautil.GetModeList(sounds_thrusting, const)
    if errMsg then
        LogError("Had trouble querying the list of modes: " .. errMsg)
        return { {} }, { "ERROR: " .. errMsg }, { false }
    end

    local info = {}
    local items = {}
    local selectable = {}

    table.insert(info, {})
    table.insert(items, "  ----------------------- DEFAULTS ----------------------- ")
    table.insert(selectable, false)

    for i = 1, #modes, 1 do
        if i > 1 and not modes[i].isDefault and modes[i-1].isDefault then
            table.insert(info, {})
            table.insert(items, "  ----------------------- MODIFIED ----------------------- ")
            table.insert(selectable, false)
        end

        table.insert(info, modes[i])
        table.insert(items, modes[i].mode.name)
        table.insert(selectable, true)
    end

    return info, items, selectable
end