local this = {}

-- This gets called during activate and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Popups(vars_ui, const)
    local pop = {}
    vars_ui.pop = pop

    ----------- Visibility -----------
    pop.visibility_slider = this.Define_Visibility_Slider(const)
    pop.visibility_checkbox = this.Define_Visibility_Checkbox(pop.visibility_slider, const)
    pop.visibility_help = this.Define_Visibility_Help(pop.visibility_checkbox, const)


    ----------- Config Name Scale -----------
    pop.scale_slider = this.Define_Scale_Slider(pop.visibility_slider, const)
    pop.scale_label = this.Define_Scale_Label(pop.scale_slider, const)
    pop.scale_help = this.Define_Scale_Help(pop.scale_label, const)


    ----------- Colors -----------
    -- Energy Background
    pop.energy_background_value = this.Define_Energy_Background_Value(const)
    pop.energy_background_help = this.Define_Energy_Background_Help(pop.energy_background_value, const)
    pop.energy_background_label = this.Define_Energy_Background_Label(pop.energy_background_help, const)
    pop.energy_background_sample = this.Define_Energy_Background_Sample(pop.energy_background_value, const)

    -- Energy Foreground
    pop.energy_foreground_value = this.Define_Energy_Foreground_Value(pop.energy_background_value, const)
    pop.energy_foreground_help = this.Define_Energy_Foreground_Help(pop.energy_foreground_value, const)
    pop.energy_foreground_label = this.Define_Energy_Foreground_Label(pop.energy_foreground_help, const)
    pop.energy_foreground_sample = this.Define_Energy_Foreground_Sample(pop.energy_foreground_value, const)


    -- Switch Background
    pop.switch_background_value = this.Define_Switch_Background_Value(pop.energy_foreground_value, const)
    pop.switch_background_help = this.Define_Switch_Background_Help(pop.switch_background_value, const)
    pop.switch_background_label = this.Define_Switch_Background_Label(pop.switch_background_help, const)
    pop.switch_background_sample = this.Define_Switch_Background_Sample(pop.switch_background_value, const)

    -- Switch Border
    pop.switch_border_value = this.Define_Switch_Border_Value(pop.switch_background_value, const)
    pop.switch_border_help = this.Define_Switch_Border_Help(pop.switch_border_value, const)
    pop.switch_border_label = this.Define_Switch_Border_Label(pop.switch_border_help, const)
    pop.switch_border_sample = this.Define_Switch_Border_Sample(pop.switch_border_value, const)


    -- Primary Text
    pop.text_primary_value = this.Define_Text_Primary_Value(pop.switch_border_value, const)
    pop.text_primary_help = this.Define_Text_Primary_Help(pop.text_primary_value, const)
    pop.text_primary_label = this.Define_Text_Primary_Label(pop.text_primary_help, const)
    pop.text_primary_sample = this.Define_Text_Primary_Sample(pop.text_primary_value, const)

    -- Secondary Text
    pop.text_secondary_value = this.Define_Text_Secondary_Value(pop.text_primary_value, const)
    pop.text_secondary_help = this.Define_Text_Secondary_Help(pop.text_secondary_value, const)
    pop.text_secondary_label = this.Define_Text_Secondary_Label(pop.text_secondary_help, const)
    pop.text_secondary_sample = this.Define_Text_Secondary_Sample(pop.text_secondary_value, const)


    ----------- Examples -----------



    ----------- Defaults -----------
    pop.defaults = this.Define_Defaults(vars_ui, const)


    pop.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(pop)
end

function ActivateWindow_Popups(vars_ui, const)
    if not vars_ui.pop then
        DefineWindow_Popups(vars_ui, const)
    end

    local pop = vars_ui.pop

    pop.visibility_checkbox.isChecked = nil
    pop.visibility_slider.value = nil

    pop.scale_slider.value = nil

    pop.energy_background_value.text = nil
    pop.energy_foreground_value.text = nil
    pop.switch_background_value.text = nil
    pop.switch_border_value.text = nil
    pop.text_primary_value.text = nil
    pop.text_secondary_value.text = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Popups(isCloseRequested, vars, vars_ui, popups, window, o, const)
    local pop = vars_ui.pop

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Visibility_Checkbox(pop.visibility_checkbox, popups)
    this.Refresh_Visibility_Slider(pop.visibility_slider, popups)

    this.Refresh_Scale_Slider(pop.scale_slider, popups)

    this.Refresh_Energy_Background_Value(pop.energy_background_value, popups)
    this.Refresh_Energy_Background_Sample(pop.energy_background_sample, pop.energy_background_value)

    this.Refresh_Energy_Foreground_Value(pop.energy_foreground_value, popups)
    this.Refresh_Energy_Foreground_Sample(pop.energy_foreground_sample, pop.energy_foreground_value)

    this.Refresh_Switch_Background_Value(pop.switch_background_value, popups)
    this.Refresh_Switch_Background_Sample(pop.switch_background_sample, pop.switch_background_value)

    this.Refresh_Switch_Border_Value(pop.switch_border_value, popups)
    this.Refresh_Switch_Border_Sample(pop.switch_border_sample, pop.switch_border_value)

    this.Refresh_Text_Primary_Value(pop.text_primary_value, popups)
    this.Refresh_Text_Primary_Sample(pop.text_primary_sample, pop.text_primary_value)

    this.Refresh_Text_Secondary_Value(pop.text_secondary_value, popups)
    this.Refresh_Text_Secondary_Sample(pop.text_secondary_sample, pop.text_secondary_value)

    this.Refresh_IsDirty(pop.okcancel, popups, pop.visibility_checkbox, pop.visibility_slider, pop.scale_slider, pop.energy_background_value, pop.energy_foreground_value, pop.switch_background_value, pop.switch_border_value, pop.text_primary_value, pop.text_secondary_value)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(pop.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(pop.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    -- Visibility
    Draw_CheckBox(pop.visibility_checkbox, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(pop.visibility_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    if pop.visibility_checkbox.isChecked then
        Draw_Slider(pop.visibility_slider, vars_ui.style.slider, vars_ui.scale)
    end

    -- Config Name Scale
    Draw_Label(pop.scale_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(pop.scale_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(pop.scale_slider, vars_ui.style.slider, vars_ui.scale)

    -- Energy Background
    Draw_Label(pop.energy_background_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(pop.energy_background_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_TextBox(pop.energy_background_value, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_ColorSample(pop.energy_background_sample, vars_ui.style.colorSample, window.left, window.top, vars_ui.scale)

    -- Energy Border
    Draw_Label(pop.energy_foreground_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(pop.energy_foreground_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_TextBox(pop.energy_foreground_value, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_ColorSample(pop.energy_foreground_sample, vars_ui.style.colorSample, window.left, window.top, vars_ui.scale)

    -- Switch Background
    Draw_Label(pop.switch_background_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(pop.switch_background_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_TextBox(pop.switch_background_value, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_ColorSample(pop.switch_background_sample, vars_ui.style.colorSample, window.left, window.top, vars_ui.scale)

    -- Switch Border
    Draw_Label(pop.switch_border_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(pop.switch_border_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_TextBox(pop.switch_border_value, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_ColorSample(pop.switch_border_sample, vars_ui.style.colorSample, window.left, window.top, vars_ui.scale)

    -- Primary Text
    Draw_Label(pop.text_primary_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(pop.text_primary_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_TextBox(pop.text_primary_value, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_ColorSample(pop.text_primary_sample, vars_ui.style.colorSample, window.left, window.top, vars_ui.scale)

    -- Secondary Text
    Draw_Label(pop.text_secondary_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(pop.text_secondary_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_TextBox(pop.text_secondary_value, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    Draw_ColorSample(pop.text_secondary_sample, vars_ui.style.colorSample, window.left, window.top, vars_ui.scale)



    -- Examples



    -- Defaults
    if Draw_Button(pop.defaults, vars_ui.style.button, vars_ui.scale) then
        this.Restore_Defaults(pop.visibility_checkbox, pop.visibility_slider, pop.scale_slider, pop.energy_background_value, pop.energy_foreground_value, pop.switch_background_value, pop.switch_border_value, pop.text_primary_value, pop.text_secondary_value)
    end

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(pop.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(popups, pop.visibility_checkbox, pop.visibility_slider, pop.scale_slider, pop.energy_background_value, pop.energy_foreground_value, pop.switch_background_value, pop.switch_border_value, pop.text_primary_value, pop.text_secondary_value)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not pop.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Visibility_Checkbox(relative_to, const)
    -- CheckBox
    return
    {
        invisible_name = "Popups_Visibility_Checkbox",

        text = "Energy Visibility",

        isEnabled = true,

        position = GetRelativePosition_LabelAbove(relative_to, const),

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_Visibility_Checkbox(def, popups)
    --NOTE: ActivateWindow_Popups sets this to nil
    if def.isChecked == nil then
        def.isChecked = popups.energy_visible
    end
end
function this.Define_Visibility_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Popups_Visibility_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Sets when the energy progress bar should show

Uncheck if you never want it to show

The slider is a way for it to be hidden unless energy is below that percent

1 will be visible as soon as it's less than 100%.  0.5 would only show when below 50%]]

    return retVal
end
function this.Define_Visibility_Slider(const)
    -- Slider
    return
    {
        invisible_name = "Popups_Visibility_Slider",

        min = 0,
        max = 1,

        decimal_places = 2,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -210,
            pos_y = -130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Visibility_Slider(def, popups)
    --NOTE: ActivateWindow_Popups sets this to nil
    if not def.value then
        def.value = popups.energy_visible_under_percent
    end
end

function this.Define_Scale_Label(relative_to, const)
    -- Label
    return
    {
        text = "Config Info Scale",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Scale_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Popups_Scale_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The font scale of the description panel when switching modes]]

    return retVal
end
function this.Define_Scale_Slider(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Popups_Scale_Slider",

        min = 0.5,
        max = 2,

        decimal_places = 1,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 60,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Scale_Slider(def, popups)
    --NOTE: ActivateWindow_Popups sets this to nil
    if not def.value then
        def.value = popups.switch_scale
    end
end

function this.Define_Energy_Background_Value(const)
    -- TextBox
    return
    {
        invisible_name = "Popups_Energy_Background_Value",

        maxChars = 8,
        width = 120,

        isMultiLine = false,

        foreground_override = "edit_value",

        position =
        {
            pos_x = 200,
            pos_y = -120,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Energy_Background_Value(def, popups)
    --NOTE: ActivateWindow_Popups sets this to nil
    if not def.text then
        def.text = popups.energy_background
    end
end
function this.Define_Energy_Background_Help(relative_to, const)
    local tooltip =
[[Background color of the energy progress bar that shows while using jetpack

]] .. this.GetColorTooltipText()

    -- HelpButton
    return
    {
        invisible_name = "Popups_Energy_Background_Help",

        tooltip = tooltip,

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

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Define_Energy_Background_Label(relative_to, const)
    -- Label
    return
    {
        text = "Energy (background)",

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

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Energy_Background_Sample(relative_to, const)
    -- ColorSample
    return
    {
        invisible_name = "Popups_Energy_Background_Sample",

        color_hex = "8F00",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_ColorSample,
    }
end
function this.Refresh_Energy_Background_Sample(def, def_value)
    def.color_hex = def_value.text
end

function this.Define_Energy_Foreground_Value(relative_to, const)
    -- TextBox
    return
    {
        invisible_name = "Popups_Energy_Foreground_Value",

        maxChars = 8,
        width = 120,

        isMultiLine = false,

        foreground_override = "edit_value",

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

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Energy_Foreground_Value(def, popups)
    --NOTE: ActivateWindow_Popups sets this to nil
    if not def.text then
        def.text = popups.energy_foreground
    end
end
function this.Define_Energy_Foreground_Help(relative_to, const)
    local tooltip =
[[Foreground color of the energy progress bar that shows while using jetpack

]] .. this.GetColorTooltipText()

    -- HelpButton
    return
    {
        invisible_name = "Popups_Energy_Foreground_Help",

        tooltip = tooltip,

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

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Define_Energy_Foreground_Label(relative_to, const)
    -- Label
    return
    {
        text = "Energy (foreground)",

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

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Energy_Foreground_Sample(relative_to, const)
    -- ColorSample
    return
    {
        invisible_name = "Popups_Energy_Foreground_Sample",

        color_hex = "8F00",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_ColorSample,
    }
end
function this.Refresh_Energy_Foreground_Sample(def, def_value)
    def.color_hex = def_value.text
end

function this.Define_Switch_Background_Value(relative_to, const)
    -- TextBox
    return
    {
        invisible_name = "Popups_Switch_Background_Value",

        maxChars = 8,
        width = 120,

        isMultiLine = false,

        foreground_override = "edit_value",

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

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Switch_Background_Value(def, popups)
    --NOTE: ActivateWindow_Popups sets this to nil
    if not def.text then
        def.text = popups.switch_background
    end
end
function this.Define_Switch_Background_Help(relative_to, const)
    local tooltip =
[[Background color of the description panel when switching modes

]] .. this.GetColorTooltipText()

    -- HelpButton
    return
    {
        invisible_name = "Popups_Switch_Background_Help",

        tooltip = tooltip,

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

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Define_Switch_Background_Label(relative_to, const)
    -- Label
    return
    {
        text = "Switch (background)",

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

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Switch_Background_Sample(relative_to, const)
    -- ColorSample
    return
    {
        invisible_name = "Popups_Switch_Background_Sample",

        color_hex = "8F00",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_ColorSample,
    }
end
function this.Refresh_Switch_Background_Sample(def, def_value)
    def.color_hex = def_value.text
end

function this.Define_Switch_Border_Value(relative_to, const)
    -- TextBox
    return
    {
        invisible_name = "Popups_Switch_Border_Value",

        maxChars = 8,
        width = 120,

        isMultiLine = false,

        foreground_override = "edit_value",

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

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Switch_Border_Value(def, popups)
    --NOTE: ActivateWindow_Popups sets this to nil
    if not def.text then
        def.text = popups.switch_border
    end
end
function this.Define_Switch_Border_Help(relative_to, const)
    local tooltip =
[[Border color of the description panel when switching modes

]] .. this.GetColorTooltipText()

    -- HelpButton
    return
    {
        invisible_name = "Popups_Switch_Border_Help",

        tooltip = tooltip,

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

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Define_Switch_Border_Label(relative_to, const)
    -- Label
    return
    {
        text = "Switch (border)",

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

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Switch_Border_Sample(relative_to, const)
    -- ColorSample
    return
    {
        invisible_name = "Popups_Switch_Border_Sample",

        color_hex = "8F00",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_ColorSample,
    }
end
function this.Refresh_Switch_Border_Sample(def, def_value)
    def.color_hex = def_value.text
end

function this.Define_Text_Primary_Value(relative_to, const)
    -- TextBox
    return
    {
        invisible_name = "Popups_Text_Primary_Value",

        maxChars = 8,
        width = 120,

        isMultiLine = false,

        foreground_override = "edit_value",

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

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Text_Primary_Value(def, popups)
    --NOTE: ActivateWindow_Popups sets this to nil
    if not def.text then
        def.text = popups.text_primary
    end
end
function this.Define_Text_Primary_Help(relative_to, const)
    local tooltip =
[[Color of the text of the mode name when energy progress bar shows.  Also used in switch mode panel

]] .. this.GetColorTooltipText()

    -- HelpButton
    return
    {
        invisible_name = "Popups_Text_Primary_Help",

        tooltip = tooltip,

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

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Define_Text_Primary_Label(relative_to, const)
    -- Label
    return
    {
        text = "Primary Text",

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

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Text_Primary_Sample(relative_to, const)
    -- ColorSample
    return
    {
        invisible_name = "Popups_Text_Primary_Sample",

        color_hex = "8F00",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_ColorSample,
    }
end
function this.Refresh_Text_Primary_Sample(def, def_value)
    def.color_hex = def_value.text
end

function this.Define_Text_Secondary_Value(relative_to, const)
    -- TextBox
    return
    {
        invisible_name = "Popups_Text_Secondary_Value",

        maxChars = 8,
        width = 120,

        isMultiLine = false,

        foreground_override = "edit_value",

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

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Text_Secondary_Value(def, popups)
    --NOTE: ActivateWindow_Popups sets this to nil
    if not def.text then
        def.text = popups.text_secondary
    end
end
function this.Define_Text_Secondary_Help(relative_to, const)
    local tooltip =
[[Color of the bottom text of the mode switch panel

]] .. this.GetColorTooltipText()

    -- HelpButton
    return
    {
        invisible_name = "Popups_Text_Secondary_Help",

        tooltip = tooltip,

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

        CalcSize = CalcSize_HelpButton,
    }
end
function this.Define_Text_Secondary_Label(relative_to, const)
    -- Label
    return
    {
        text = "Secondary Text",

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

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Text_Secondary_Sample(relative_to, const)
    -- ColorSample
    return
    {
        invisible_name = "Popups_Text_Secondary_Sample",

        color_hex = "8F00",

        position =
        {
            relative_to = relative_to,

            pos_x = 10,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_ColorSample,
    }
end
function this.Refresh_Text_Secondary_Sample(def, def_value)
    def.color_hex = def_value.text
end

function this.Define_Defaults(vars_ui, const)
    -- Button
    return
    {
        text = "Default Values",

        width_override = 140,

        position =
        {
            pos_x = vars_ui.style.okcancelButtons.pos_x,
            pos_y = vars_ui.style.okcancelButtons.pos_y,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        color = "hint",

        isEnabled = true,

        CalcSize = CalcSize_Button,
    }
end
function this.Restore_Defaults(def_visibility_checkbox, def_visibility_slider, def_scale_slider, def_energy_background_value, def_energy_foreground_value, def_switch_background_value, def_switch_border_value, def_text_primary_value, def_text_secondary_value)
    local popups = popups_util.GetDefault()

    def_visibility_checkbox.isChecked = popups.energy_visible
    def_visibility_slider.value = popups.energy_visible_under_percent

    def_scale_slider.value = popups.switch_scale

    def_energy_background_value.text = popups.energy_background
    def_energy_foreground_value.text = popups.energy_foreground
    def_switch_background_value.text = popups.switch_background
    def_switch_border_value.text = popups.switch_border
    def_text_primary_value.text = popups.text_primary
    def_text_secondary_value.text = popups.text_secondary
end

function this.Refresh_IsDirty(def, popups, def_visibility_checkbox, def_visibility_slider, def_scale_slider, def_energy_background_value, def_energy_foreground_value, def_switch_background_value, def_switch_border_value, def_text_primary_value, def_text_secondary_value)
    local isDirty = false

    if def_visibility_checkbox.isChecked then
        if not popups.energy_visible then
            isDirty = true

        elseif not IsNearValue(def_visibility_slider.value, popups.energy_visible_under_percent) then
            isDirty = true
        end

    else
        if popups.energy_visible then
            isDirty = true
        end
    end

    if not IsNearValue(def_scale_slider.value, popups.switch_scale) then
        isDirty = true

    elseif def_energy_background_value.text ~= popups.energy_background then
        isDirty = true

    elseif def_energy_foreground_value.text ~= popups.energy_foreground then
        isDirty = true

    elseif def_switch_background_value.text ~= popups.switch_background then
        isDirty = true

    elseif def_switch_border_value.text ~= popups.switch_border then
        isDirty = true

    elseif def_text_primary_value.text ~= popups.text_primary then
        isDirty = true

    elseif def_text_secondary_value.text ~= popups.text_secondary then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(popups, def_visibility_checkbox, def_visibility_slider, def_scale_slider, def_energy_background_value, def_energy_foreground_value, def_switch_background_value, def_switch_border_value, def_text_primary_value, def_text_secondary_value)
    popups.energy_visible = def_visibility_checkbox.isChecked
    popups.energy_visible_under_percent = def_visibility_slider.value
    popups.switch_scale = def_scale_slider.value
    popups.energy_background = def_energy_background_value.text
    popups.energy_foreground = def_energy_foreground_value.text
    popups.switch_background = def_switch_background_value.text
    popups.switch_border = def_switch_border_value.text
    popups.text_primary = def_text_primary_value.text
    popups.text_secondary = def_text_secondary_value.text

    popups_util.ParseColors(popups)

    local popups_json = extern_json.encode(popups)

    dal.InsertPopups(popups_json)

    if math.random(72) == 1 then
        dal.DeleteOldPopupsRows()
    end
end

---------------------------------------------------------------------------------------

function this.GetColorTooltipText()
    return
    [[ARBG as hex (alpha is optional)

    Values go from 00 to FF (hex for 0 to 255)
    
    FF0000 would be red, 00FF00 green, 0000FF blue
    
    80FF0000 would be 50% transparent red]]
end

function this.NOTES()
    local text =
[[
------------- progress bar -------------

ABGR		ARGB
FFFFFF75	FF75FFFF
99ADAD5E	995EADAD
E6D4D473	E673D4D4


Secondary Text
ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFF75)

Energy Back/Border
ImGui.PushStyleColor(ImGuiCol.FrameBg, 0x99ADAD5E)
ImGui.PushStyleColor(ImGuiCol.PlotHistogram, 0xE6D4D473)



------------- text -------------

ABGR		ARGB
FF4CFFFF	FFFFFF4C


Primary Text
ImGui.PushStyleColor(ImGuiCol.Text, 0xFF4CFFFF)






--------------------------------------

Config Info Back/Border
ImGui.PushStyleColor(ImGuiCol.WindowBg, 0xA054542E)     --A02E5454
ImGui.PushStyleColor(ImGuiCol.Border, 0x806E6E3D)       --803D6E6E



-- these are reused
ImGui.PushStyleColor(ImGuiCol.Text, 0xFF4CFFFF)     --FFFF4C
ImGui.PushStyleColor(ImGuiCol.Text, 0xFFFFFF75)     --75FFFF
    


]]
end
