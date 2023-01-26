local this = {}

local COMBO_NONE = "*  none  *"       -- using asterisk, because files can't have that in the name
local COMBO_DEFAULT = "default"
local COMBO_DEFAULT_SHIFT = "default - strong"
local COMBO_UPONLY = "up only"
local COMBO_BACKJUMP = "back jump"

local dropdown_items = nil

function DefineWindow_Jumping2(vars_ui, const)
    local jumping = {}
    vars_ui.jumping2 = jumping

    jumping.changes = Changes:new()

    jumping.title = Define_Title("Jumping", const)

    --jumping.combo = this.Define_Combo(const)


    jumping.planted_label = this.Define_Planted_Label(const)
    jumping.planted_help = this.Define_Planted_Help(jumping.planted_label, const)
    jumping.planted_combo = this.Define_Planted_Combo(jumping.planted_label, const)

    jumping.planted_shift_label = this.Define_Planted_Shift_Label(jumping.planted_combo, const)
    jumping.planted_shift_help = this.Define_Planted_Shift_Help(jumping.planted_shift_label, const)
    jumping.planted_shift_combo = this.Define_Planted_Shift_Combo(jumping.planted_shift_label, const)

    jumping.rebound_label = this.Define_Rebound_Label(jumping.planted_shift_combo, const)
    jumping.rebound_help = this.Define_Rebound_Help(jumping.rebound_label, const)
    jumping.rebound_combo = this.Define_Rebound_Combo(jumping.rebound_label, const)

    jumping.rebound_shift_label = this.Define_Rebound_Shift_Label(jumping.rebound_combo, const)
    jumping.rebound_shift_help = this.Define_Rebound_Shift_Help(jumping.rebound_shift_label, const)
    jumping.rebound_shift_combo = this.Define_Rebound_Shift_Combo(jumping.rebound_shift_label, const)

    jumping.button_clear = this.Define_Button_Clear(const)
    jumping.button_default = this.Define_Button_Default(jumping.button_clear, const)
    jumping.button_default_old = this.Define_Button_DefaultOld(jumping.button_default, const)


    --TODO: Overrides
    --  Relatch { use config | always | never }
    --  Strength [.5 ------ 1 ------ 2]
    --  Speed [.5 ------ 1 ------ 2]


    jumping.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(jumping)
end

function ActivateWindow_Jumping2(vars_ui, const)
    if not vars_ui.jumping2 then
        DefineWindow_Jumping2(vars_ui, const)
    end
end

function DrawWindow_Jumping2(isCloseRequested, vars_ui, window, const, player, player_arcade)
    local jumping = vars_ui.jumping2

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Planted_Combo(jumping.planted_combo)

    this.Refresh_Planted_Shift_Combo(jumping.planted_shift_combo)

    this.Refresh_Rebound_Combo(jumping.rebound_combo)

    this.Refresh_Rebound_Shift_Combo(jumping.rebound_shift_combo)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(jumping.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(jumping.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    --Draw_ComboBox(jumping.combo, vars_ui.style.combobox, vars_ui.scale)

    Draw_Label(jumping.planted_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.planted_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.planted_combo, vars_ui.style.combobox, vars_ui.scale)

    Draw_Label(jumping.planted_shift_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.planted_shift_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.planted_shift_combo, vars_ui.style.combobox, vars_ui.scale)

    Draw_Label(jumping.rebound_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.rebound_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.rebound_combo, vars_ui.style.combobox, vars_ui.scale)

    Draw_Label(jumping.rebound_shift_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.rebound_shift_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.rebound_shift_combo, vars_ui.style.combobox, vars_ui.scale)

    if Draw_Button(jumping.button_clear, vars_ui.style.button, vars_ui.scale) then
        this.Pressed_Clear(jumping)
    end

    if Draw_Button(jumping.button_default, vars_ui.style.button, vars_ui.scale) then
        this.Pressed_Default(jumping)
    end

    if Draw_Button(jumping.button_default_old, vars_ui.style.button, vars_ui.scale) then
        this.Pressed_DefaultOld(jumping)
    end




    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(jumping.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        --this.Save(player, player_arcade)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not jumping.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Combo(const)
    -- ComboBox
    return
    {
        preview_text = "select an item",
        selected_item = nil,

        items =
        {
            "hello",
            "there",
            "all",
            "item1",
            "item2",
            "item3",
            "item4",
            "item5",
            "item6",
            "item7",
            "item8",
            "item9",
            "itemX",
            "itemE",
            "item10",
            "item11",
            "really long text that needs to expand",
            "item12",
            "item13",
            "item21",
            "item22",
            "item23",
            "item24",
            "item25",
            "item26",
            "item27",
            "item28",
            "item29",
            "item2X",
            "item2E",
            "item31",
            "item32",
            "item33",
            "item34",
            "item35",
            "item36",
            "item37",
            "item38",
            "item39",
            "item3X",
            "item3E",
            "item41",
            "item42",
            "item43",
            "item44",
            "item45",
            "item46",
            "item47",
            "item48",
            "item49",
            "item4X",
            "item4E",
        },

        --width = 240,

        position =
        {
            pos_x = -100,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Jumping2_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end

function this.Define_Planted_Label(const)
    -- Label
    return
    {
        text = "Jump while hanging on wall",

        position =
        {
            pos_x = 40,
            pos_y = -180,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Planted_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping2_Planted_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_Planted_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = COMBO_NONE,
        selected_item = COMBO_NONE,

        items = nil,

        width = 300,

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

        invisible_name = "Jumping2_Planted_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Planted_Combo(def)
    if not dropdown_items then
        dropdown_items = this.GetDropdownItems()
    end

    def.items = dropdown_items
end

function this.Define_Planted_Shift_Label(relative_to, const)
    -- Label
    return
    {
        text = "Jump while hanging on wall + Shift Key",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 36,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Planted_Shift_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping2_Planted_Shift_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_Planted_Shift_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = COMBO_NONE,
        selected_item = COMBO_NONE,

        items = nil,

        width = 300,

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

        invisible_name = "Jumping2_Planted_Shift_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Planted_Shift_Combo(def)
    if not dropdown_items then
        dropdown_items = this.GetDropdownItems()
    end

    def.items = dropdown_items
end

function this.Define_Rebound_Label(relative_to, const)
    -- Label
    return
    {
        text = "Jump when close to a wall",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 36,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Rebound_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping2_Rebound_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_Rebound_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = COMBO_NONE,
        selected_item = COMBO_NONE,

        items = nil,

        width = 300,

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

        invisible_name = "Jumping2_Rebound_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Rebound_Combo(def)
    if not dropdown_items then
        dropdown_items = this.GetDropdownItems()
    end

    def.items = dropdown_items
end

function this.Define_Rebound_Shift_Label(relative_to, const)
    -- Label
    return
    {
        text = "Jump when close to a wall + Shift Key",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 36,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Rebound_Shift_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping2_Rebound_Shift_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_Rebound_Shift_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = COMBO_NONE,
        selected_item = COMBO_NONE,

        items = nil,

        width = 300,

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

        invisible_name = "Jumping2_Rebound_Shift_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Rebound_Shift_Combo(def)
    if not dropdown_items then
        dropdown_items = this.GetDropdownItems()
    end

    def.items = dropdown_items
end

function this.Define_Button_Clear(const)
    -- Button
    return
    {
        text = "Clear",

        width_override = 100,

        position =
        {
            pos_x = 40,
            pos_y = -180,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.center,
        },

        color = "hint",

        isEnabled = true,

        CalcSize = CalcSize_Button,
    }
end
function this.Pressed_Clear(jumping)
    jumping.planted_combo.selected_item = COMBO_NONE
    jumping.planted_shift_combo.selected_item = COMBO_NONE
    jumping.rebound_combo.selected_item = COMBO_NONE
    jumping.rebound_shift_combo.selected_item = COMBO_NONE
end

function this.Define_Button_Default(relative_to, const)
    -- Button
    return
    {
        text = "Default",

        width_override = 100,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 18,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "hint",

        isEnabled = true,

        CalcSize = CalcSize_Button,
    }
end
function this.Pressed_Default(jumping)
    jumping.planted_combo.selected_item = COMBO_DEFAULT
    jumping.planted_shift_combo.selected_item = COMBO_DEFAULT_SHIFT
    jumping.rebound_combo.selected_item = COMBO_DEFAULT
    jumping.rebound_shift_combo.selected_item = COMBO_DEFAULT_SHIFT
end

function this.Define_Button_DefaultOld(relative_to, const)
    -- Button
    return
    {
        text = "Default (old)",

        width_override = 100,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 18,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "hint",

        isEnabled = true,

        CalcSize = CalcSize_Button,
    }
end
function this.Pressed_DefaultOld(jumping)
    jumping.planted_combo.selected_item = COMBO_DEFAULT
    jumping.planted_shift_combo.selected_item = COMBO_DEFAULT
    jumping.rebound_combo.selected_item = COMBO_UPONLY
    jumping.rebound_shift_combo.selected_item = COMBO_BACKJUMP
end

function this.GetDropdownItems()
    --TODO: scan folder for json files

    return
    {
        COMBO_NONE,
    }
end