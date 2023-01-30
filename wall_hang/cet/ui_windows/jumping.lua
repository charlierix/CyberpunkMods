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

    jumping.planted_shift_label = this.Define_Planted_Shift_Label(jumping.planted_combo, const)
    jumping.planted_shift_help = this.Define_Planted_Shift_Help(jumping.planted_shift_label, const)
    jumping.planted_shift_combo = this.Define_Planted_Shift_Combo(jumping.planted_shift_label, const)

    jumping.rebound_label = this.Define_Rebound_Label(jumping.planted_shift_combo, const)
    jumping.rebound_help = this.Define_Rebound_Help(jumping.rebound_label, const)
    jumping.rebound_combo = this.Define_Rebound_Combo(jumping.rebound_label, const)

    jumping.rebound_shift_label = this.Define_Rebound_Shift_Label(jumping.rebound_combo, const)
    jumping.rebound_shift_help = this.Define_Rebound_Shift_Help(jumping.rebound_shift_label, const)
    jumping.rebound_shift_combo = this.Define_Rebound_Shift_Combo(jumping.rebound_shift_label, const)

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

    Draw_Label(jumping.planted_shift_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.planted_shift_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.planted_shift_combo, vars_ui.style.combobox, vars_ui.scale)

    Draw_Label(jumping.rebound_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.rebound_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.rebound_combo, vars_ui.style.combobox, vars_ui.scale)

    Draw_Label(jumping.rebound_shift_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(jumping.rebound_shift_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_ComboBox(jumping.rebound_shift_combo, vars_ui.style.combobox, vars_ui.scale)

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
[[]]

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
[[]]

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
[[]]

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
[[]]

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
        invisible_name = "Jumping_Override_Strength_Help",

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
        invisible_name = "Jumping_Override_Speed_Help",

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

    elseif not IsNearValue(override_strength_slider.value, player_arcade.override_strength_mult) then
        isDirty = true

    elseif not IsNearValue(override_speed_slider.value, player_arcade.override_speed_mult) then
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