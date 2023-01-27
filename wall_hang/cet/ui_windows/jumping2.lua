local this = {}

local COMBO_NONE = "*  none  *"       -- using asterisk, because files can't have that in the name
local COMBO_DEFAULT = "default"
local COMBO_DEFAULT_SHIFT = "default - strong"
local COMBO_UPONLY = "up only"
local COMBO_BACKJUMP = "back jump"

local OVERRIDE_RELATCH_NONE = "use config"
local OVERRIDE_RELATCH_ALWAYS = "always"
local OVERRIDE_RELATCH_NEVER = "never"

local dropdown_items = nil

function DefineWindow_Jumping2(vars_ui, const)
    local jumping = {}
    vars_ui.jumping2 = jumping

    jumping.changes = Changes:new()

    jumping.title = Define_Title("Jumping", const)

    -- Config ComboBoxes
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

    -- Helper Buttons
    jumping.button_clear = this.Define_Button_Clear(vars_ui.style, const)
    jumping.button_default = this.Define_Button_Default(jumping.button_clear, const)
    jumping.button_default_old = this.Define_Button_DefaultOld(jumping.button_default, const)

    -- Config Overrides
    jumping.override_relatch_label = this.Define_Override_Relatch_Label(const)
    jumping.override_relatch_help = this.Define_Override_Relatch_Help(jumping.override_relatch_label, const)
    jumping.override_relatch_combo = this.Define_Override_Relatch_Combo(jumping.override_relatch_help, const)

    jumping.override_strength_label = this.Define_Override_Strength_Label(jumping.override_relatch_label, const)
    jumping.override_strength_help = this.Define_Override_Strength_Help(jumping.override_strength_label, const)
    jumping.override_strength_slider = this.Define_Override_Strength_Slider(jumping.override_strength_label, const)

    jumping.override_speed_label = this.Define_Override_Speed_Label(jumping.override_strength_slider, const)
    jumping.override_speed_help = this.Define_Override_Speed_Help(jumping.override_speed_label, const)
    jumping.override_speed_slider = this.Define_Override_Speed_Slider(jumping.override_speed_label, const)

    jumping.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(jumping)
end

function ActivateWindow_Jumping2(vars_ui, const)
    if not vars_ui.jumping2 then
        DefineWindow_Jumping2(vars_ui, const)
    end

    local jumping = vars_ui.jumping2

    jumping.override_relatch_combo.selected_item = nil
    jumping.override_strength_slider.value = nil
    jumping.override_speed_slider.value = nil
end

function DrawWindow_Jumping2(isCloseRequested, vars_ui, window, const, player, player_arcade)
    local jumping = vars_ui.jumping2

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Planted_Combo(jumping.planted_combo)

    this.Refresh_Planted_Shift_Combo(jumping.planted_shift_combo)

    this.Refresh_Rebound_Combo(jumping.rebound_combo)

    this.Refresh_Rebound_Shift_Combo(jumping.rebound_shift_combo)

    this.Refresh_Override_Relatch_Combo(jumping.override_relatch_combo)

    this.Refresh_Override_Strength_Slider(jumping.override_strength_slider)

    this.Refresh_Override_Speed_Slider(jumping.override_speed_slider)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(jumping.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(jumping.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

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

    Draw_Label(jumping.override_relatch_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.override_relatch_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.override_relatch_combo, vars_ui.style.combobox, vars_ui.scale)

    Draw_Label(jumping.override_strength_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.override_strength_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(jumping.override_strength_slider, vars_ui.style.slider, vars_ui.scale)

    Draw_Label(jumping.override_speed_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.override_speed_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(jumping.override_speed_slider, vars_ui.style.slider, vars_ui.scale)

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

function this.Define_Button_Clear(style, const)
    -- Button
    return
    {
        text = "Clear",

        width_override = 100,

        position =
        {
            pos_x = style.okcancelButtons.pos_x,
            pos_y = style.okcancelButtons.pos_y + 24,       -- ImGui.GetFrameHeight()
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
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

function this.Define_Override_Relatch_Label(const)
    -- Label
    return
    {
        text = "Override Relatch",

        position =
        {
            pos_x = 240,
            pos_y = -60,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Override_Relatch_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping2_Override_Relatch_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_Override_Relatch_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = "",
        selected_item = nil,        -- populated in refresh

        items =
        {
            OVERRIDE_RELATCH_NONE,
            OVERRIDE_RELATCH_ALWAYS,
            OVERRIDE_RELATCH_NEVER,
        },

        width = 100,

        position =
        {
            relative_to = relative_to,

            pos_x = 12,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Jumping2_Override_Relatch_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Override_Relatch_Combo(def)
    --NOTE: Activate function sets this to nil
    if not def.selected_item then
        def.selected_item = OVERRIDE_RELATCH_NONE
    end
end

function this.Define_Override_Strength_Label(relative_to, const)
    -- Label
    return
    {
        text = "Override Strength Multiplier",

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
function this.Define_Override_Strength_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping2_Override_Strength_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_Override_Strength_Slider(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Jumping2_Override_Strength_Slider",

        min = 0,
        max = 2,

        get_custom_text = this.GetMultSlider_Display,

        width = 280,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

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

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Override_Strength_Slider(def)
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = 1
    end
end

function this.Define_Override_Speed_Label(relative_to, const)
    -- Label
    return
    {
        text = "Override Speed Multiplier",

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 24,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Override_Speed_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping2_Override_Speed_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_Override_Speed_Slider(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Jumping2_Override_Speed_Slider",

        min = 0,
        max = 2,

        get_custom_text = this.GetMultSlider_Display,

        width = 280,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

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

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Override_Speed_Slider(def)
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = 1
    end
end

function this.GetDropdownItems()
    --TODO: scan folder for json files

    return
    {
        COMBO_NONE,
    }
end

-- The sliders go from 0 to 2, but the multiplier is from half to double
function this.GetMultSlider_Display(value)
    local mult = this.GetMultSlider_Value(value)
    return Format_DecimalToDozenal(mult, 2)
end
function this.GetMultSlider_Value(value)
    if value == nil then
        return 1
    end

    if value > 1 then
        return value
    end

    return GetScaledValue(0.5, 1, 0, 1, value)
end