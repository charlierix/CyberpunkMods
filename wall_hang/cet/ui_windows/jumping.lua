local this = {}

local FOLDER = "!settings"
local STRENGTH_0 = 0.75
local STRENGTH_2 = 3
local SPEED_0 = 0.5
local SPEED_2 = 2

local dropdown_items = nil

function DefineWindow_Jumping(vars_ui, const)
    local jumping = {}
    vars_ui.jumping = jumping

    jumping.changes = Changes:new()

    jumping.title = Define_Title("Jumping", const)

    -- Config ComboBoxes
    jumping.planted_label = this.Define_Planted_Label(const)
    jumping.planted_help = this.Define_Planted_Help(jumping.planted_label, const)
    jumping.planted_combo = this.Define_Planted_Combo(jumping.planted_label, const)
    jumping.planted_combo_help = this.Define_Planted_Combo_Help(jumping.planted_combo, const)

    jumping.planted_shift_label = this.Define_Planted_Shift_Label(jumping.planted_combo, const)
    jumping.planted_shift_help = this.Define_Planted_Shift_Help(jumping.planted_shift_label, const)
    jumping.planted_shift_combo = this.Define_Planted_Shift_Combo(jumping.planted_shift_label, const)
    jumping.planted_shift_combo_help = this.Define_Planted_Shift_Combo_Help(jumping.planted_shift_combo, const)

    jumping.rebound_label = this.Define_Rebound_Label(jumping.planted_shift_combo, const)
    jumping.rebound_help = this.Define_Rebound_Help(jumping.rebound_label, const)
    jumping.rebound_combo = this.Define_Rebound_Combo(jumping.rebound_label, const)
    jumping.rebound_combo_help = this.Define_Rebound_Combo_Help(jumping.rebound_combo, const)

    jumping.rebound_shift_label = this.Define_Rebound_Shift_Label(jumping.rebound_combo, const)
    jumping.rebound_shift_help = this.Define_Rebound_Shift_Help(jumping.rebound_shift_label, const)
    jumping.rebound_shift_combo = this.Define_Rebound_Shift_Combo(jumping.rebound_shift_label, const)
    jumping.rebound_shift_combo_help = this.Define_Rebound_Shift_Combo_Help(jumping.rebound_shift_combo, const)

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

    -- Helper Buttons
    jumping.button_clear = this.Define_Button_Clear(vars_ui.style, const)
    jumping.button_default = this.Define_Button_Default(jumping.button_clear, const)
    jumping.button_default_old = this.Define_Button_DefaultOld(jumping.button_default, const)

    jumping.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(jumping)
end

function ActivateWindow_Jumping(vars_ui, const)
    if not vars_ui.jumping then
        DefineWindow_Jumping(vars_ui, const)
    end

    local jumping = vars_ui.jumping

    jumping.planted_combo.selected_item = nil
    jumping.planted_shift_combo.selected_item = nil
    jumping.rebound_combo.selected_item = nil
    jumping.rebound_shift_combo.selected_item = nil

    jumping.planted_combo_help.tooltip = nil
    jumping.planted_combo_help.combo_value = nil

    jumping.planted_shift_combo_help.tooltip = nil
    jumping.planted_shift_combo_help.combo_value = nil

    jumping.rebound_combo_help.tooltip = nil
    jumping.rebound_combo_help.combo_value = nil

    jumping.rebound_shift_combo.tooltip = nil
    jumping.rebound_shift_combo.combo_value = nil

    jumping.override_relatch_combo.selected_item = nil
    jumping.override_strength_slider.value = nil
    jumping.override_speed_slider.value = nil
end

function DrawWindow_Jumping(isCloseRequested, vars_ui, window, const, player, player_arcade)
    local jumping = vars_ui.jumping

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Planted_Combo(jumping.planted_combo, player_arcade, const)
    this.Refresh_Planted_Shift_Combo(jumping.planted_shift_combo, player_arcade, const)
    this.Refresh_Rebound_Combo(jumping.rebound_combo, player_arcade, const)
    this.Refresh_Rebound_Shift_Combo(jumping.rebound_shift_combo, player_arcade, const)

    this.Refresh_Planted_Combo_Help(jumping.planted_combo_help, jumping.planted_combo, const)
    this.Refresh_Planted_Combo_Help(jumping.planted_shift_combo_help, jumping.planted_shift_combo, const)
    this.Refresh_Planted_Combo_Help(jumping.rebound_combo_help, jumping.rebound_combo, const)
    this.Refresh_Planted_Combo_Help(jumping.rebound_shift_combo_help, jumping.rebound_shift_combo, const)

    this.Refresh_Override_Relatch_Combo(jumping.override_relatch_combo, player_arcade)
    this.Refresh_Override_Strength_Slider(jumping.override_strength_slider, player_arcade)
    this.Refresh_Override_Speed_Slider(jumping.override_speed_slider, player_arcade)

    this.Refresh_IsDirty(jumping.okcancel, player_arcade, jumping.planted_combo, jumping.planted_shift_combo, jumping.rebound_combo, jumping.rebound_shift_combo, jumping.override_relatch_combo, jumping.override_strength_slider, jumping.override_speed_slider)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(jumping.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(jumping.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(jumping.title, vars_ui.style.colors, vars_ui.scale)

    Draw_Label(jumping.planted_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.planted_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.planted_combo, vars_ui.style.combobox, vars_ui.scale)
    Draw_HelpButton(jumping.planted_combo_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    Draw_Label(jumping.planted_shift_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.planted_shift_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.planted_shift_combo, vars_ui.style.combobox, vars_ui.scale)
    Draw_HelpButton(jumping.planted_shift_combo_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    Draw_Label(jumping.rebound_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.rebound_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.rebound_combo, vars_ui.style.combobox, vars_ui.scale)
    Draw_HelpButton(jumping.rebound_combo_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    Draw_Label(jumping.rebound_shift_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.rebound_shift_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.rebound_shift_combo, vars_ui.style.combobox, vars_ui.scale)
    Draw_HelpButton(jumping.rebound_shift_combo_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    Draw_Label(jumping.override_relatch_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.override_relatch_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.override_relatch_combo, vars_ui.style.combobox, vars_ui.scale)

    Draw_Label(jumping.override_strength_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.override_strength_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(jumping.override_strength_slider, vars_ui.style.slider, vars_ui.scale)

    Draw_Label(jumping.override_speed_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.override_speed_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(jumping.override_speed_slider, vars_ui.style.slider, vars_ui.scale)

    if Draw_Button(jumping.button_clear, vars_ui.style.button, vars_ui.scale) then
        this.Pressed_Clear(jumping, const)
    end

    if Draw_Button(jumping.button_default, vars_ui.style.button, vars_ui.scale) then
        this.Pressed_Default(jumping, const)
    end

    if Draw_Button(jumping.button_default_old, vars_ui.style.button, vars_ui.scale) then
        this.Pressed_DefaultOld(jumping, const)
    end

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(jumping.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, player_arcade, jumping.planted_combo, jumping.planted_shift_combo, jumping.rebound_combo, jumping.rebound_shift_combo, jumping.override_relatch_combo, jumping.override_strength_slider, jumping.override_speed_slider)
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
            pos_x = 35,
            pos_y = -160,
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
        invisible_name = "Jumping_Planted_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Jump settings to use when holding onto a wall and pressing the jump button

These are .json files in \mods\wall_hang\!settings

There is an optional download for the editor of these files if you'd like to make your own

These specify jump direction and strength to apply based on where the player is looking relative to the wall's normal]]

    return retVal
end
function this.Define_Planted_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = const.jump_config_none,
        selected_item = nil,

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

        invisible_name = "Jumping_Planted_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Planted_Combo(def, player_arcade, const)
    if not dropdown_items then
        dropdown_items = this.GetDropdownItems(const)
    end

    def.items = dropdown_items

    if not def.selected_item then
        def.selected_item = player_arcade.planted_name
    end
end
function this.Define_Planted_Combo_Help(relative_to, const)
    -- HelpButton
    return
    {
        invisible_name = "Jumping_Planted_Combo_Help",

        tooltip = nil,

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Refresh_Planted_Combo_Help(def, combo_def, const)
    if combo_def.selected_item ~= def.combo_value then
        def.tooltip = this.GetComboHelp(combo_def, const)
        def.combo_value = combo_def.selected_item
    end
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
function this.Define_Planted_Shift_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping_Planted_Shift_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Jump settings to use when holding onto a wall and pressing the shift + jump button

These are .json files in \mods\wall_hang\!settings

There is an optional download for the editor of these files if you'd like to make your own

These specify jump direction and strength to apply based on where the player is looking relative to the wall's normal]]

    return retVal
end
function this.Define_Planted_Shift_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = const.jump_config_none,
        selected_item = nil,

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

        invisible_name = "Jumping_Planted_Shift_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Planted_Shift_Combo(def, player_arcade, const)
    if not dropdown_items then
        dropdown_items = this.GetDropdownItems(const)
    end

    def.items = dropdown_items

    if not def.selected_item then
        def.selected_item = player_arcade.planted_shift_name
    end
end
function this.Define_Planted_Shift_Combo_Help(relative_to, const)
    -- HelpButton
    return
    {
        invisible_name = "Jumping_Planted_Shift_Combo_Help",

        tooltip = nil,

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Refresh_Planted_Shift_Combo_Help(def, combo_def, const)
    if combo_def.selected_item ~= def.combo_value then
        def.tooltip = this.GetComboHelp(combo_def, const)
        def.combo_value = combo_def.selected_item
    end
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
function this.Define_Rebound_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping_Rebound_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Jump settings to use when jumping off a wall (not hanging from the wall)

You must be midair when jumping off the wall.  So run toward a wall, jump, then jump off the wall

These are .json files in \mods\wall_hang\!settings

There is an optional download for the editor of these files if you'd like to make your own

These specify jump direction and strength to apply based on where the player is looking relative to the wall's normal]]

    return retVal
end
function this.Define_Rebound_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = const.jump_config_none,
        selected_item = nil,

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

        invisible_name = "Jumping_Rebound_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Rebound_Combo(def, player_arcade, const)
    if not dropdown_items then
        dropdown_items = this.GetDropdownItems(const)
    end

    def.items = dropdown_items

    if not def.selected_item then
        def.selected_item = player_arcade.rebound_name
    end
end
function this.Define_Rebound_Combo_Help(relative_to, const)
    -- HelpButton
    return
    {
        invisible_name = "Jumping_Rebound_Combo_Help",

        tooltip = nil,

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Refresh_Rebound_Combo_Help(def, combo_def, const)
    if combo_def.selected_item ~= def.combo_value then
        def.tooltip = this.GetComboHelp(combo_def, const)
        def.combo_value = combo_def.selected_item
    end
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
function this.Define_Rebound_Shift_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Jumping_Rebound_Shift_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Jump settings to use when shift + jumping off a wall (not hanging from the wall)

You must be midair when jumping off the wall.  So run toward a wall, jump, then shift+jump off the wall

These are .json files in \mods\wall_hang\!settings

There is an optional download for the editor of these files if you'd like to make your own

These specify jump direction and strength to apply based on where the player is looking relative to the wall's normal]]

    return retVal
end
function this.Define_Rebound_Shift_Combo(relative_to, const)
    -- ComboBox
    return
    {
        preview_text = const.jump_config_none,
        selected_item = nil,

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

        invisible_name = "Jumping_Rebound_Shift_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Rebound_Shift_Combo(def, player_arcade, const)
    if not dropdown_items then
        dropdown_items = this.GetDropdownItems(const)
    end

    def.items = dropdown_items

    if not def.selected_item then
        def.selected_item = player_arcade.rebound_shift_name
    end
end
function this.Define_Rebound_Shift_Combo_Help(relative_to, const)
    -- HelpButton
    return
    {
        invisible_name = "Jumping_Rebound_Shift_Combo_Help",

        tooltip = nil,

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Refresh_Rebound_Shift_Combo_Help(def, combo_def, const)
    if combo_def.selected_item ~= def.combo_value then
        def.tooltip = this.GetComboHelp(combo_def, const)
        def.combo_value = combo_def.selected_item
    end
end

function this.Define_Override_Relatch_Label(const)
    -- Label
    return
    {
        text = "Override Relatch",

        position =
        {
            pos_x = 210,
            pos_y = -80,
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
        invisible_name = "Jumping_Override_Relatch_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Relatching auto applies latch after jumping (will get sucked back to the nearest wall and stick when slow enough)

The configs can specify whether relatching is enabled, disabled, or only enabled at certain angles

This override is a way to guarantee always or never relatch

NOTE: The latch won't stay applied if 'Latch WallHang Key' is unchecked.  The wall attraction still works, but there won't be an auto latch when you touch the wall]]

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
            const.override_relatch.use_config:gsub("_", " "),
            const.override_relatch.always,
            const.override_relatch.never,
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

        invisible_name = "Jumping_Override_Relatch_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Override_Relatch_Combo(def, player_arcade)
    --NOTE: Activate function sets this to nil
    if not def.selected_item then
        def.selected_item = player_arcade.override_relatch:gsub("_", " ")
    end
end

function this.Define_Override_Strength_Label(relative_to, const)
    -- Label
    return
    {
        text = "Strength Multiplier",

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
        invisible_name = "Jumping_Override_Strength_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The configs specify how strong of an impulse to apply

This is a multiplier in case you'd like to make the jump weaker or stronger]]

    return retVal
end
function this.Define_Override_Strength_Slider(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Jumping_Override_Strength_Slider",

        min = 0,
        max = 2,

        get_custom_text = function(val) return this.GetMultSlider_Display(val, STRENGTH_0, STRENGTH_2) end,

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
function this.Refresh_Override_Strength_Slider(def, player_arcade)
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = this.GetMultSlider_Value_UI(player_arcade.override_strength_mult, STRENGTH_0, STRENGTH_2)
    end
end

function this.Define_Override_Speed_Label(relative_to, const)
    -- Label
    return
    {
        text = "Zero Speed Multiplier",

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
        invisible_name = "Jumping_Override_Speed_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[If the player is moving too fast when jump is pressed, the impulse is reduced (or zero)

This lets you adjust the speeds defined by the configs

If greater than 1: The player's speed is allowed to be greater before jump impulse is reduced

If less than 1: The jump impulse is reduced at lower speeds]]

    return retVal
end
function this.Define_Override_Speed_Slider(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Jumping_Override_Speed_Slider",

        min = 0,
        max = 2,

        get_custom_text = function(val) return this.GetMultSlider_Display(val, SPEED_0, SPEED_2) end,

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
function this.Refresh_Override_Speed_Slider(def, player_arcade)
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = this.GetMultSlider_Value_UI(player_arcade.override_speed_mult, SPEED_0, SPEED_2)
    end
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
            pos_y = style.okcancelButtons.pos_y,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        color = "hint",

        isEnabled = true,

        CalcSize = CalcSize_Button,
    }
end
function this.Pressed_Clear(jumping, const)
    jumping.planted_combo.selected_item = const.jump_config_none
    jumping.planted_shift_combo.selected_item = const.jump_config_none
    jumping.rebound_combo.selected_item = const.jump_config_none
    jumping.rebound_shift_combo.selected_item = const.jump_config_none
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

            pos_x = 12,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.bottom,
        },

        color = "hint",

        isEnabled = true,

        CalcSize = CalcSize_Button,
    }
end
function this.Pressed_Default(jumping, const)
    jumping.planted_combo.selected_item = const.jump_config_default
    jumping.planted_shift_combo.selected_item = const.jump_config_default_shift
    jumping.rebound_combo.selected_item = const.jump_config_default
    jumping.rebound_shift_combo.selected_item = const.jump_config_default_shift
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

            pos_x = 12,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.bottom,
        },

        color = "hint",

        isEnabled = true,

        CalcSize = CalcSize_Button,
    }
end
function this.Pressed_DefaultOld(jumping, const)
    jumping.planted_combo.selected_item = const.jump_config_default_nolatch
    jumping.planted_shift_combo.selected_item = const.jump_config_default_nolatch
    jumping.rebound_combo.selected_item = const.jump_config_uponly_nolatch
    jumping.rebound_shift_combo.selected_item = const.jump_config_backjump_nolatch
end

function this.Refresh_IsDirty(def, player_arcade, planted_combo, planted_shift_combo, rebound_combo, rebound_shift_combo, override_relatch_combo, override_strength_slider, override_speed_slider)
    local isDirty = false

    if planted_combo.selected_item ~= player_arcade.planted_name then
        isDirty = true

    elseif planted_shift_combo.selected_item ~= player_arcade.planted_shift_name then
        isDirty = true

    elseif rebound_combo.selected_item ~= player_arcade.rebound_name then
        isDirty = true

    elseif rebound_shift_combo.selected_item ~= player_arcade.rebound_shift_name then
        isDirty = true

    elseif override_relatch_combo.selected_item ~= player_arcade.override_relatch:gsub("_", " ") then
        isDirty = true

    elseif not IsNearValue(this.GetMultSlider_Value_Save(override_strength_slider.value, STRENGTH_0, STRENGTH_2), player_arcade.override_strength_mult) then
        isDirty = true

    elseif not IsNearValue(this.GetMultSlider_Value_Save(override_speed_slider.value, SPEED_0, SPEED_2), player_arcade.override_speed_mult) then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, player_arcade, planted_combo, planted_shift_combo, rebound_combo, rebound_shift_combo, override_relatch_combo, override_strength_slider, override_speed_slider)
    player_arcade.planted_name = planted_combo.selected_item
    player_arcade.planted_shift_name = planted_shift_combo.selected_item
    player_arcade.rebound_name = rebound_combo.selected_item
    player_arcade.rebound_shift_name = rebound_shift_combo.selected_item

    player_arcade.override_relatch = override_relatch_combo.selected_item:gsub(" ", "_")
    player_arcade.override_strength_mult = this.GetMultSlider_Value_Save(override_strength_slider.value, STRENGTH_0, STRENGTH_2)
    player_arcade.override_speed_mult = this.GetMultSlider_Value_Save(override_speed_slider.value, SPEED_0, SPEED_2)

    player_arcade:Save()
    player:Reset()
end

---------------------------------------------------------------------------------------

function this.GetDropdownItems(const)
    local retVal =
    {
        const.jump_config_none,
    }

    for _, file in pairs(dir(FOLDER)) do
        if file.type == const.filetype.file and file.name:match("%.json$") then
            -- file.name is only the name (no folder)
            -- gsub is a regex replace, but % is the escape char instead of \
            retVal[#retVal+1] = file.name:gsub("%.json", "")
        end
    end

    return retVal
end

-- The sliders go from 0 to 2, but the multiplier is from value_0 to value_2
function this.GetMultSlider_Display(value, value_0, value_2)
    local mult = this.GetMultSlider_Value_Save(value, value_0, value_2)
    return Format_DecimalToDozenal(mult, 2)
end

-- Converts from saved value to ui value (ui is from 0 to 2)
function this.GetMultSlider_Value_UI(value, value_0, value_2)
    if value == nil then
        return 1
    elseif value < 1 then
        return GetScaledValue(0, 1, value_0, 1, value)
    else
        return GetScaledValue(1, 2, 1, value_2, value)
    end
end
-- Converts from ui value (0 to 2) to saved value
function this.GetMultSlider_Value_Save(value, value_0, value_2)
    if value == nil then
        return 1
    elseif value < 1 then
        return GetScaledValue(value_0, 1, 0, 1, value)
    else
        return GetScaledValue(1, value_2, 1, 2, value)
    end
end

-- Tries to summarize a jump config as a text dump
function this.GetComboHelp(combo_def, const)
    if combo_def.selected_item == const.jump_config_none then
        return "Jump disabled"
    end

    local settings = PlayerArcade_DeserializeConfigFile(combo_def.selected_item)
    if not settings then
        return "-- INVALID CONFIG FILE --"
    end

    local sections = {}
    if settings.description and settings.description ~= "" then
        table.insert(sections, settings.description)
    end

    if settings.has_horizontal or settings.has_straightup then
        local legend =
[[Below are graphs, available characters are extremely limited and not monospaced.  Space is none, # is full
|<--- facing wall       away from wall --->|]]
        table.insert(sections, legend)
    end

    if settings.has_horizontal then
        local sub_sections = {}

        table.insert(sub_sections, this.GetHelpKeyValue("strength", Format_DecimalToDozenal(settings.horizontal.strength, 1)))
        table.insert(sub_sections, this.GetHelpKeyValue("look %", this.GraphAnimCurve(settings.horizontal.percent_look)))
        table.insert(sub_sections, this.GetHelpKeyValue("look strength %", this.GraphAnimCurve(settings.horizontal.percent_look_strength)))
        table.insert(sub_sections, this.GetHelpKeyValue("up %", this.GraphAnimCurve(settings.horizontal.percent_up)))
        table.insert(sub_sections, this.GetHelpKeyValue("along %", this.GraphAnimCurve(settings.horizontal.percent_along)))
        table.insert(sub_sections, this.GetHelpKeyValue("away %", this.GraphAnimCurve(settings.horizontal.percent_away)))
        table.insert(sub_sections, this.GetHelpKeyValue("relatch", this.GraphAnimCurve(settings.horizontal.percent_latch_after_jump, true)))

        table.insert(sections, this.AddSection("Standard", sub_sections))
    end

    if settings.has_straightup then
        local sub_sections = {}

        table.insert(sub_sections, this.GetHelpKeyValue("strength", Format_DecimalToDozenal(settings.straight_up.strength, 1)))
        table.insert(sub_sections, this.GetHelpKeyValue("relatch", tostring(settings.straight_up.latch_after_jump)))

        table.insert(sections, this.AddSection("Straight Up", sub_sections))
    end

    return this.BuildFinal(sections)
end
function this.GraphAnimCurve_ATTEMPT1(curve, is_bool)
    local symbols =
    {
        "▁",        -- unicode 2581
        "▂",
        "▃",
        "▄",
        "▅",
        "▆",
        "▇",
        "█",        -- unicode 2588
    }

    local symbols2 =        -- still ????
    {
        " ",
        "░",        -- 176
        "▒",        -- 177
        "▓",        -- 178
        "█"         -- 219
    }

    local test = ""

    for i = 1, #symbols, 1 do
        test = test .. symbols[i]
    end

    --return test       -- just prints ????????

    return " .:#"
end
function this.GraphAnimCurve(curve, is_bool)
    -- The available chars are incredibly limited.  Unicode 2581 - 2588 would be ideal, but they just show as ?.  Same with 176, 177, 178, 219
    -- So going with a vertically centered bar graph
    local symbols =
    {
        " ",
        "-",
        "=",
        "#",
    }

    local count = 36

    local retVal = ""

    for i = 1, count, 1 do
        local angle = 180 - (180 * (i - 0.5) / count)
        print("i: " .. tostring(i) .. ", angle: " .. tostring(angle))
        local dot = Angle_to_Dot(angle)
        local value = curve:Evaluate(dot)
        print("dot: " .. tostring(dot) .. ", value: " .. tostring(value))

        value = Clamp(0, 1, value)

        local char = ""
        if is_bool then
            if value >= 0.5 then
                char = symbols[#symbols]
            else
                char = symbols[1]
            end
        else
            local index = 1 + Round(value * #symbols, 0)
            index = Clamp(1, #symbols, index)
            print("value: " .. tostring(value) .. ", index: " .. tostring(index))
            char = symbols[index]
        end

        retVal = retVal .. char
    end

    return "|" .. retVal .. "|"
end
function this.GetHelpKeyValue(key, value)
    return
    {
        key = key,
        value = value,
    }
end
function this.AddSection(header, sub_sections)
    local retVal = "------------ " .. header .. [[ ------------

]]

    for i = 1, #sub_sections, 1 do
        if i > 1 then
            retVal = retVal .. [[

]]
        end

        retVal = retVal .. sub_sections[i].key .. ": " .. sub_sections[i].value .. [[
]]
    end

    return retVal
end
function this.BuildFinal(sections)
    local retVal = ""

    for i = 1, #sections, 1 do
        if i > 1 then
            retVal = retVal .. [[


]]
        end

        retVal = retVal .. sections[i]
    end

    return retVal
end