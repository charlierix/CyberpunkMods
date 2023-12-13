local this = {}

local extra_type = CreateEnum("none", "hover", "push_up", "dash")

-- This gets called during activate and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode_Extra(vars_ui, const)
    local mode_extra = {}
    vars_ui.mode_extra = mode_extra

    mode_extra.title = Define_Title("Extra Actions", const)
    mode_extra.name = Define_Name(const)

    -- combobox
    mode_extra.type_combo = this.Define_Type_Combo(const)
    mode_extra.type_help = this.Define_Type_Help(mode_extra.type_combo, const)
    mode_extra.type_label = this.Define_Type_Label(mode_extra.type_help, const)


    --------- hover ---------

    -- mult
    mode_extra.hover_mult_value = this.Define_Hover_Mult_Value(const)
    mode_extra.hover_mult_label = this.Define_Hover_Mult_Label(mode_extra.hover_mult_value, const)
    mode_extra.hover_mult_help = this.Define_Hover_Mult_Help(mode_extra.hover_mult_label, const)

    -- accel_up
    mode_extra.hover_accelup_value = this.Define_Hover_AccelUp_Value(const)
    mode_extra.hover_accelup_label = this.Define_Hover_AccelUp_Label(mode_extra.hover_accelup_value, const)
    mode_extra.hover_accelup_help = this.Define_Hover_AccelUp_Help(mode_extra.hover_accelup_label, const)

    -- accel_down
    mode_extra.hover_acceldown_value = this.Define_Hover_AccelDown_Value(mode_extra.hover_accelup_value, const)
    mode_extra.hover_acceldown_label = this.Define_Hover_AccelDown_Label(mode_extra.hover_acceldown_value, const)
    mode_extra.hover_acceldown_help = this.Define_Hover_AccelDown_Help(mode_extra.hover_acceldown_label, const)

    -- burnRate
    mode_extra.hover_burnrate_value = this.Define_Hover_BurnRate_Value(const)
    mode_extra.hover_burnrate_label = this.Define_Hover_BurnRate_Label(mode_extra.hover_burnrate_value, const)
    mode_extra.hover_burnrate_help = this.Define_Hover_BurnRate_Help(mode_extra.hover_burnrate_label, const)

    -- holdDuration
    mode_extra.hover_holdduration_value = this.Define_Hover_HoldDuration_Value(mode_extra.hover_burnrate_value, const)
    --mode_extra.hover_holdduration_label = this.Define_Hover_HoldDuration_Label(mode_extra.hover_holdduration_value, const)
    mode_extra.hover_holdduration_checkbox = this.Define_Hover_HoldDuration_Checkbox(mode_extra.hover_holdduration_value, const)        -- using the checkbox as the label
    mode_extra.hover_holdduration_help = this.Define_Hover_HoldDuration_Help(mode_extra.hover_holdduration_checkbox, const)


    --------- push up ---------

    -- force
    mode_extra.pushup_force_value = this.Define_PushUp_Force_Value(const)
    mode_extra.pushup_force_label = this.Define_PushUp_Force_Label(mode_extra.pushup_force_value, const)
    mode_extra.pushup_force_help = this.Define_PushUp_Force_Help(mode_extra.pushup_force_label, const)

    -- randVert
    mode_extra.pushup_randvert_value = this.Define_PushUp_RandVert_Value(mode_extra.pushup_force_value, const)
    mode_extra.pushup_randvert_label = this.Define_PushUp_RandVert_Label(mode_extra.pushup_randvert_value, const)
    mode_extra.pushup_randvert_help = this.Define_PushUp_RandVert_Help(mode_extra.pushup_randvert_label, const)

    -- randHorz
    mode_extra.pushup_randhorz_value = this.Define_PushUp_RandHorz_Value(mode_extra.pushup_randvert_value, const)
    mode_extra.pushup_randhorz_label = this.Define_PushUp_RandHorz_Label(mode_extra.pushup_randhorz_value, const)
    mode_extra.pushup_randhorz_help = this.Define_PushUp_RandHorz_Help(mode_extra.pushup_randhorz_label, const)

    -- burnRate
    mode_extra.pushup_burnrate_value = this.Define_PushUp_BurnRate_Value(const)
    mode_extra.pushup_burnrate_label = this.Define_PushUp_BurnRate_Label(mode_extra.pushup_burnrate_value, const)
    mode_extra.pushup_burnrate_help = this.Define_PushUp_BurnRate_Help(mode_extra.pushup_burnrate_label, const)


    --------- dash ---------

    -- acceleration
    mode_extra.dash_accel_value = this.Define_Dash_Accel_Value(const)
    mode_extra.dash_accel_label = this.Define_Dash_Accel_Label(mode_extra.dash_accel_value, const)
    mode_extra.dash_accel_help = this.Define_Dash_Accel_Help(mode_extra.dash_accel_label, const)

    -- burnRate
    mode_extra.dash_burnrate_value = this.Define_Dash_BurnRate_Value(const)
    mode_extra.dash_burnrate_label = this.Define_Dash_BurnRate_Label(mode_extra.dash_burnrate_value, const)
    mode_extra.dash_burnrate_help = this.Define_Dash_BurnRate_Help(mode_extra.dash_burnrate_label, const)


    mode_extra.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(mode_extra)
end

function ActivateWindow_Mode_Extra(vars_ui, const)
    if not vars_ui.mode_extra then
        DefineWindow_Mode_Extra(vars_ui, const)
    end

    local mode_extra = vars_ui.mode_extra

    mode_extra.type_combo.selected_item = nil
    mode_extra.hover_mult_value.value = nil
    mode_extra.hover_accelup_value.value = nil
    mode_extra.hover_acceldown_value.value = nil
    mode_extra.hover_burnrate_value.value = nil
    mode_extra.hover_holdduration_value.value = nil
    mode_extra.hover_holdduration_checkbox.isChecked = nil
    mode_extra.pushup_force_value.value = nil
    mode_extra.pushup_randvert_value.value = nil
    mode_extra.pushup_randhorz_value.value = nil
    mode_extra.pushup_burnrate_value.value = nil
    mode_extra.dash_accel_value.value = nil
    mode_extra.dash_burnrate_value.value = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode_Extra(isCloseRequested, vars, vars_ui, player, window, o, const)
    local mode_extra = vars_ui.mode_extra

    local mode = vars_ui.transition_info.mode
    local extra = vars_ui.transition_info.extra

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(mode_extra.name, mode.name)

    this.Refresh_Type_Combo(mode_extra.type_combo, vars_ui, const)
    this.Refresh_Hover_Mult_Value(mode_extra.hover_mult_value, extra, const)
    this.Refresh_Hover_AccelUp_Value(mode_extra.hover_accelup_value, extra, const)
    this.Refresh_Hover_AccelDown_Value(mode_extra.hover_acceldown_value, extra, const)
    this.Refresh_Hover_BurnRate_Value(mode_extra.hover_burnrate_value, extra, const)
    this.Refresh_Hover_HoldDuration_Value(mode_extra.hover_holdduration_value, extra, const)
    this.Refresh_Hover_HoldDuration_Checkbox(mode_extra.hover_holdduration_checkbox, mode_extra.hover_holdduration_value, extra, const)
    this.Refresh_PushUp_Force_Value(mode_extra.pushup_force_value, extra, const)
    this.Refresh_PushUp_RandVert_Value(mode_extra.pushup_randvert_value, extra, const)
    this.Refresh_PushUp_RandHorz_Value(mode_extra.pushup_randhorz_value, extra, const)
    this.Refresh_PushUp_BurnRate_Value(mode_extra.pushup_burnrate_value, extra, const)
    this.Refresh_Dash_Accel_Value(mode_extra.dash_accel_value, extra, const)
    this.Refresh_Dash_BurnRate_Value(mode_extra.dash_burnrate_value, extra, const)

    this.Refresh_IsDirty(mode_extra.okcancel, mode, extra, const, mode_extra.type_combo, mode_extra.hover_mult_value, mode_extra.hover_accelup_value, mode_extra.hover_acceldown_value, mode_extra.hover_burnrate_value, mode_extra.hover_holdduration_value, mode_extra.hover_holdduration_checkbox, mode_extra.pushup_force_value, mode_extra.pushup_randvert_value, mode_extra.pushup_randhorz_value, mode_extra.pushup_burnrate_value, mode_extra.dash_accel_value, mode_extra.dash_burnrate_value)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(mode_extra.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(mode_extra.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(mode_extra.title, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(mode_extra.name, vars_ui.style.colors, vars_ui.scale)

    -- combobox
    Draw_ComboBox(mode_extra.type_combo, vars_ui.style.combobox, vars_ui.scale)
    Draw_HelpButton(mode_extra.type_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Label(mode_extra.type_label, vars_ui.style.colors, vars_ui.scale)


    --------- hover ---------

    if mode_extra.type_combo.selected_item == extra_type.hover then
        -- mult
        Draw_Label(mode_extra.hover_mult_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_extra.hover_mult_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_extra.hover_mult_value, vars_ui.style.slider, vars_ui.scale)

        -- accel_up
        Draw_Label(mode_extra.hover_accelup_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_extra.hover_accelup_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_extra.hover_accelup_value, vars_ui.style.slider, vars_ui.scale)

        -- accel_down
        Draw_Label(mode_extra.hover_acceldown_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_extra.hover_acceldown_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_extra.hover_acceldown_value, vars_ui.style.slider, vars_ui.scale)

        -- burnRate
        Draw_Label(mode_extra.hover_burnrate_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_extra.hover_burnrate_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_extra.hover_burnrate_value, vars_ui.style.slider, vars_ui.scale)

        -- holdDuration
        Draw_CheckBox(mode_extra.hover_holdduration_checkbox, vars_ui.style.checkbox, vars_ui.style.colors)
        Draw_HelpButton(mode_extra.hover_holdduration_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        if mode_extra.hover_holdduration_checkbox.isChecked then
            Draw_Slider(mode_extra.hover_holdduration_value, vars_ui.style.slider, vars_ui.scale)
        end


    --------- push up ---------

    elseif mode_extra.type_combo.selected_item == extra_type.push_up then
        -- force
        Draw_Label(mode_extra.pushup_force_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_extra.pushup_force_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_extra.pushup_force_value, vars_ui.style.slider, vars_ui.scale)

        -- randVert
        Draw_Label(mode_extra.pushup_randvert_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_extra.pushup_randvert_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_extra.pushup_randvert_value, vars_ui.style.slider, vars_ui.scale)

        -- randHorz
        Draw_Label(mode_extra.pushup_randhorz_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_extra.pushup_randhorz_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_extra.pushup_randhorz_value, vars_ui.style.slider, vars_ui.scale)

        -- burnRate
        Draw_Label(mode_extra.pushup_burnrate_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_extra.pushup_burnrate_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_extra.pushup_burnrate_value, vars_ui.style.slider, vars_ui.scale)


    --------- dash ---------

    elseif mode_extra.type_combo.selected_item == extra_type.dash then
        -- acceleration
        Draw_Label(mode_extra.dash_accel_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_extra.dash_accel_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_extra.dash_accel_value, vars_ui.style.slider, vars_ui.scale)

        -- burnRate
        Draw_Label(mode_extra.dash_burnrate_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_extra.dash_burnrate_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_extra.dash_burnrate_value, vars_ui.style.slider, vars_ui.scale)
    end


    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(mode_extra.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index, vars_ui.transition_info.set_extra, vars.sounds_thrusting, const, mode_extra.type_combo, mode_extra.hover_mult_value, mode_extra.hover_accelup_value, mode_extra.hover_acceldown_value, mode_extra.hover_burnrate_value, mode_extra.hover_holdduration_value, mode_extra.hover_holdduration_checkbox, mode_extra.pushup_force_value, mode_extra.pushup_randvert_value, mode_extra.pushup_randhorz_value, mode_extra.pushup_burnrate_value, mode_extra.dash_accel_value, mode_extra.dash_burnrate_value)
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)

    elseif isCancelClicked then
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)
    end

    return not (isCloseRequested and not mode_extra.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Type_Combo(const)
    -- ComboBox
    return
    {
        preview_text = extra_type.none,
        selected_item = nil,

        items =
        {
            extra_type.none,
            extra_type.hover,
            extra_type.push_up,
            extra_type.dash,
        },

        width = 120,

        position =
        {
            pos_x = 0,
            pos_y = -190,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Mode_Extra_Type_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Type_Combo(def, vars_ui, const)
    if not def.selected_item then
        if not vars_ui.transition_info.extra then
            def.selected_item = extra_type.none

        elseif vars_ui.transition_info.extra.extra_type == const.extra_type.hover then
            def.selected_item = extra_type.hover

        elseif vars_ui.transition_info.extra.extra_type == const.extra_type.pushup then
            def.selected_item = extra_type.push_up

        elseif vars_ui.transition_info.extra.extra_type == const.extra_type.dash then
            def.selected_item = extra_type.dash

        else
            LogError("Unknown extra_type: " .. tostring(vars_ui.transition_info.extra.extra_type))
            def.selected_item = extra_type.none
        end
    end
end
function this.Define_Type_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Mode_Extra_Type_Help",

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

    retVal.tooltip =
[[These are custom actions that get applied when a key is pressed

Hover: Holds altitude when you push the button.  Only need to tap the button (no need to hold the button down).  This will turn off when you press jump again

Push Up:  Launches NPCs in the air every time the button is pressed.  The scan can only see NPCs that are in the vision cone, so any that are not currently on screen will be skipped

Dash:  Accelerates in the look direction while the button is held in]]

    return retVal
end
function this.Define_Type_Label(relative_to, const)
    -- Label
    return
    {
        text = "Type",

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

------------------ Hover ------------------

function this.Define_Hover_Mult_Label(relative_to, const)
    -- Label
    return
    {
        text = "Altitude Stick Multiplier",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Hover_Mult_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_Hover_Mult_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[How aggresively to snap to the desired altitude

If the value is lower, the difference between current and desired altitude will be larger before max acceleration is applied

Larger values will try to stick to that altitude more quickly]]

    return retVal
end
function this.Define_Hover_Mult_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_Hover_Mult_Value",

        min = 0.1,
        max = 24,

        decimal_places = 1,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 0,
            pos_y = 190,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Hover_Mult_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.hover then
            def.value = extra.mult
        else
            def.value = 1
        end
    end
end

function this.Define_Hover_AccelUp_Label(relative_to, const)
    -- Label
    return
    {
        text = "Acceleration Up",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Hover_AccelUp_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_Hover_AccelUp_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[How much acceleration to apply when below the desired altitude]]

    return retVal
end
function this.Define_Hover_AccelUp_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_Hover_AccelUp_Value",

        min = 0,
        max = 12,

        decimal_places = 1,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = -30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Hover_AccelUp_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.hover then
            def.value = extra.accel_up_ORIG
        else
            def.value = 2
        end
    end
end

function this.Define_Hover_AccelDown_Label(relative_to, const)
    -- Label
    return
    {
        text = "Acceleration Down",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Hover_AccelDown_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_Hover_AccelDown_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[How much acceleration to apply when above the desired altitude

This will be an extra acceleration downward]]

    return retVal
end
function this.Define_Hover_AccelDown_Value(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_Hover_AccelDown_Value",

        min = 0,
        max = 12,

        decimal_places = 1,

        width = 300,

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
function this.Refresh_Hover_AccelDown_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.hover then
            def.value = extra.accel_down
        else
            def.value = 1
        end
    end
end

function this.Define_Hover_BurnRate_Label(relative_to, const)
    -- Label
    return
    {
        text = "Burn Rate",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Hover_BurnRate_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_Hover_BurnRate_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This will use additional energy when hover is active]]

    return retVal
end
function this.Define_Hover_BurnRate_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_Hover_BurnRate_Value",

        min = 0.01,     -- if it's zero, processing will ignore it
        max = 2,

        decimal_places = 2,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = -30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Hover_BurnRate_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.hover then
            def.value = extra.burnRate
        else
            def.value = 0.5
        end
    end
end

function this.Define_Hover_HoldDuration_Label(relative_to, const)
    -- Label
    return
    {
        text = "Duration",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Hover_HoldDuration_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_Hover_HoldDuration_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This gives a chance for hover to auto shutoff after a few seconds

It is also shut off when pressing the jump button]]

    return retVal
end
function this.Define_Hover_HoldDuration_Value(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_Hover_HoldDuration_Value",

        min = 0,
        max = 60,

        decimal_places = 0,

        width = 300,

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
function this.Refresh_Hover_HoldDuration_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.hover and extra.holdDuration <= def.max then
            def.value = extra.holdDuration
        else
            def.value = 36
        end
    end
end
function this.Define_Hover_HoldDuration_Checkbox(relative_to, const)
    -- CheckBox
    return
    {
        invisible_name = "Mode_Extra_Hover_HoldDuration_Checkbox",

        text = "Duration",

        isEnabled = true,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 15,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.top,
            vertical = const.alignment_vertical.bottom,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_Hover_HoldDuration_Checkbox(def, def_slider, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if def.isChecked == nil then
        if extra and extra.extra_type == const.extra_type.hover then
            if extra.holdDuration > def_slider.max then
                def.isChecked = false       -- no time limit
            else
                def.isChecked = true
            end
        else
            def.isChecked = false       -- default to no time limit
        end
    end
end

----------------- Push Up -----------------

function this.Define_PushUp_Force_Label(relative_to, const)
    -- Label
    return
    {
        text = "Vertical Impulse Strength",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_PushUp_Force_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_PushUp_Force_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[How much impulse to apply to the NPCs straight up

The vertical applied per NPC will be Vertical Impulse Strength +- Random Vertical

If they are ragdolling for too long, the game seems to snap them out of it and just reset their animation.  So although large values are funny, more medium values are more effective]]

    return retVal
end
function this.Define_PushUp_Force_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_PushUp_Force_Value",

        min = 0,
        max = 36,

        decimal_places = 0,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = -30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_PushUp_Force_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.pushup then
            def.value = extra.force
        else
            def.value = 12
        end
    end
end

function this.Define_PushUp_RandVert_Label(relative_to, const)
    -- Label
    return
    {
        text = "Random Vertical",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_PushUp_RandVert_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_PushUp_RandVert_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The vertical applied per NPC will be Vertical Impulse Strength +- Random Vertical

So if you don't want any variation, set Random Vertical to zero]]

    return retVal
end
function this.Define_PushUp_RandVert_Value(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_PushUp_RandVert_Value",

        min = 0,
        max = 12,

        decimal_places = 1,

        width = 300,

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
function this.Refresh_PushUp_RandVert_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.pushup then
            def.value = extra.randVert
        else
            def.value = 6
        end
    end
end

function this.Define_PushUp_RandHorz_Label(relative_to, const)
    -- Label
    return
    {
        text = "Random Horizontal",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_PushUp_RandHorz_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_PushUp_RandHorz_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Each NPC will get a horizontal impulse randomly applied anywhere from 0 to this max value]]

    return retVal
end
function this.Define_PushUp_RandHorz_Value(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_PushUp_RandHorz_Value",

        min = 0,
        max = 36,

        decimal_places = 1,

        width = 300,

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
function this.Refresh_PushUp_RandHorz_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.pushup then
            def.value = extra.randHorz
        else
            def.value = 3
        end
    end
end

function this.Define_PushUp_BurnRate_Label(relative_to, const)
    -- Label
    return
    {
        text = "Burn Rate",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_PushUp_BurnRate_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_PushUp_BurnRate_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This will use up fuel each time the launch is pressed]]

    return retVal
end
function this.Define_PushUp_BurnRate_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_PushUp_BurnRate_Value",

        min = 0.01,
        max = 4,

        decimal_places = 1,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = -30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_PushUp_BurnRate_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.pushup and extra.burnRate <= def.max then
            def.value = extra.burnRate
        else
            def.value = 36
        end
    end
end

------------------- Dash ------------------

function this.Define_Dash_Accel_Label(relative_to, const)
    -- Label
    return
    {
        text = "Acceleration",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Dash_Accel_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_Dash_Accel_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[How hard to accelerate]]

    return retVal
end
function this.Define_Dash_Accel_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_Dash_Accel_Value",

        min = 0,
        max = 80,

        decimal_places = 0,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = -30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Dash_Accel_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.dash then
            def.value = extra.acceleration
        else
            def.value = 12
        end
    end
end

function this.Define_Dash_BurnRate_Label(relative_to, const)
    -- Label
    return
    {
        text = "Burn Rate",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Dash_BurnRate_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Extra_Dash_BurnRate_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Additional energy to use while boosting]]

    return retVal
end
function this.Define_Dash_BurnRate_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Extra_Dash_BurnRate_Value",

        min = 0.01,
        max = 2,

        decimal_places = 2,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = -30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Dash_BurnRate_Value(def, extra, const)
    --NOTE: ActivateWindow_Mode_Extra sets this to nil
    if not def.value then
        if extra and extra.extra_type == const.extra_type.dash then
            def.value = extra.burnRate
        else
            def.value = 1
        end
    end
end


function this.Refresh_IsDirty(def, mode, extra, const, def_type_combo, def_hover_mult_value, def_hover_accelup_value, def_hover_acceldown_value, def_hover_burnrate_value, def_hover_holdduration_value, def_hover_holdduration_checkbox, def_pushup_force_value, def_pushup_randvert_value, def_pushup_randhorz_value, def_pushup_burnrate_value, def_dash_accel_value, def_dash_burnrate_value)
    local isDirty = false

    if def_type_combo.selected_item == extra_type.none then
        if extra then
            isDirty = true
        end

    elseif def_type_combo.selected_item == extra_type.hover then
        if extra and extra.extra_type == const.extra_type.hover then
            if not IsNearValue(extra.mult, def_hover_mult_value.value) then
                isDirty = true

            elseif not IsNearValue(extra.accel_up_ORIG, def_hover_accelup_value.value) then
                isDirty = true

            elseif not IsNearValue(extra.accel_down, def_hover_acceldown_value.value) then
                isDirty = true

            elseif not IsNearValue(extra.burnRate, def_hover_burnrate_value.value) then
                isDirty = true
            end

            if def_hover_holdduration_checkbox.isChecked then
                if extra.holdDuration > def_hover_holdduration_value.max or not IsNearValue(extra.holdDuration, def_hover_holdduration_value.value) then
                    isDirty = true
                end
            else
                if not IsNearValue(extra.holdDuration, mode_defaults.HOVER_MAX_HOLD_DURATION) then
                    isDirty = true
                end
            end
        else
            isDirty = true
        end

    elseif def_type_combo.selected_item == extra_type.push_up then
        if extra and extra.extra_type == const.extra_type.pushup then
            if not IsNearValue(extra.force, def_pushup_force_value.value) then
                isDirty = true

            elseif not IsNearValue(extra.randVert, def_pushup_randvert_value.value) then
                isDirty = true

            elseif not IsNearValue(extra.randHorz, def_pushup_randhorz_value.value) then
                isDirty = true

            elseif not IsNearValue(extra.burnRate, def_pushup_burnrate_value.value) then
                isDirty = true
            end
        else
            isDirty = true
        end

    elseif def_type_combo.selected_item == extra_type.dash then
        if extra and extra.extra_type == const.extra_type.dash then
            if not IsNearValue(extra.acceleration, def_dash_accel_value.value) then
                isDirty = true

            elseif not IsNearValue(extra.burnRate, def_dash_burnrate_value.value) then
                isDirty = true
            end
        else
            isDirty = true
        end
    end

    def.isDirty = isDirty
end

function this.Save(player, mode, mode_index, set_extra, sounds_thrusting, const, def_type_combo, def_hover_mult_value, def_hover_accelup_value, def_hover_acceldown_value, def_hover_burnrate_value, def_hover_holdduration_value, def_hover_holdduration_checkbox, def_pushup_force_value, def_pushup_randvert_value, def_pushup_randhorz_value, def_pushup_burnrate_value, def_dash_accel_value, def_dash_burnrate_value)
    local extra = nil

    if def_type_combo.selected_item == extra_type.none then
        -- extra should stay nil

    elseif def_type_combo.selected_item == extra_type.hover then
        local holdDuration = nil
        if def_hover_holdduration_checkbox.isChecked then
            holdDuration = def_hover_holdduration_value.value
        else
            holdDuration = mode_defaults.HOVER_MAX_HOLD_DURATION
        end

        -- Needs to be the live instance.  Player will call ModeDefaults.ToJSON
        -- NOTE: key param is populated in set_extra()
        extra = Extra_Hover:new("", def_hover_mult_value.value, def_hover_accelup_value.value, def_hover_acceldown_value.value, def_hover_burnrate_value.value, holdDuration, mode.useImpulse, mode.accel.gravity, sounds_thrusting, const)

    elseif def_type_combo.selected_item == extra_type.push_up then
        extra = Extra_PushUp:new("", def_pushup_force_value.value, def_pushup_randhorz_value.value, def_pushup_randvert_value.value, def_pushup_burnrate_value.value, const)

    elseif def_type_combo.selected_item == extra_type.dash then
        extra = Extra_Dash:new("", def_dash_accel_value.value, def_dash_burnrate_value.value, const)
    end

    set_extra(mode, extra)

    player:SaveUpdatedMode(mode, mode_index)
end