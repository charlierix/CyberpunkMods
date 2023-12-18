local this = {}

local dilation_type = CreateEnum("none", "constant", "gradient")

-- This gets called during activate and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode_TimeDilation(vars_ui, const)
    local mode_timedilation = {}
    vars_ui.mode_timedilation = mode_timedilation

    mode_timedilation.title = Define_Title("Time Dilation", const)
    mode_timedilation.name = Define_Name(const)

    -- dilation type
    mode_timedilation.type_combo = this.Define_Type_Combo(const)
    mode_timedilation.type_help = this.Define_Type_Help(mode_timedilation.type_combo, const)
    mode_timedilation.type_label = this.Define_Type_Label(mode_timedilation.type_help, const)


    --timeDilation
    mode_timedilation.const_dilation_value = this.Define_Const_Dilation_Value(const)
    mode_timedilation.const_dilation_label = this.Define_Const_Dilation_Label(mode_timedilation.const_dilation_value, const)
    mode_timedilation.const_dilation_help = this.Define_Const_Dilation_Help(mode_timedilation.const_dilation_label, const)


    -- timeDilation_gradient.timeDilation_lowZSpeed
    mode_timedilation.gradient_dilationlow_value = this.Define_Gradient_DilationLow_Value(const)
    mode_timedilation.gradient_dilationlow_label = this.Define_Gradient_DilationLow_Label(mode_timedilation.gradient_dilationlow_value, const)
    mode_timedilation.gradient_dilationlow_help = this.Define_Gradient_DilationLow_Help(mode_timedilation.gradient_dilationlow_label, const)

    -- timeDilation_gradient.lowZSpeed
    mode_timedilation.gradient_speedlow_value = this.Define_Gradient_SpeedLow_Value(const)
    mode_timedilation.gradient_speedlow_label = this.Define_Gradient_SpeedLow_Label(mode_timedilation.gradient_speedlow_value, const)
    mode_timedilation.gradient_speedlow_help = this.Define_Gradient_SpeedLow_Help(mode_timedilation.gradient_speedlow_label, const)

    -- timeDilation_gradient.timeDilation_highZSpeed
    mode_timedilation.gradient_dilationhigh_value = this.Define_Gradient_DilationHigh_Value(const)
    mode_timedilation.gradient_dilationhigh_label = this.Define_Gradient_DilationHigh_Label(mode_timedilation.gradient_dilationhigh_value, const)
    mode_timedilation.gradient_dilationhigh_help = this.Define_Gradient_DilationHigh_Help(mode_timedilation.gradient_dilationhigh_label, const)

    -- timeDilation_gradient.highZSpeed
    mode_timedilation.gradient_speedhigh_value = this.Define_Gradient_SpeedHigh_Value(const)
    mode_timedilation.gradient_speedhigh_label = this.Define_Gradient_SpeedHigh_Label(mode_timedilation.gradient_speedhigh_value, const)
    mode_timedilation.gradient_speedhigh_help = this.Define_Gradient_SpeedHigh_Help(mode_timedilation.gradient_speedhigh_label, const)

    mode_timedilation.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(mode_timedilation)
end

function ActivateWindow_Mode_TimeDilation(vars_ui, const)
    if not vars_ui.mode_timedilation then
        DefineWindow_Mode_TimeDilation(vars_ui, const)
    end

    local mode_timedilation = vars_ui.mode_timedilation

    mode_timedilation.type_combo.selected_item = nil
    mode_timedilation.const_dilation_value.value = nil
    mode_timedilation.gradient_dilationlow_value.value = nil
    mode_timedilation.gradient_speedlow_value.value = nil
    mode_timedilation.gradient_dilationhigh_value.value = nil
    mode_timedilation.gradient_speedhigh_value.value = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode_TimeDilation(isCloseRequested, vars, vars_ui, player, window, o, const)
    local mode_timedilation = vars_ui.mode_timedilation

    local mode = vars_ui.transition_info.mode

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(mode_timedilation.name, mode.name)

    this.Refresh_Type_Combo(mode_timedilation.type_combo, mode)
    this.Refresh_Const_Dilation_Value(mode_timedilation.const_dilation_value, mode)
    this.Refresh_Gradient_DilationLow_Value(mode_timedilation.gradient_dilationlow_value, mode)
    this.Refresh_Gradient_SpeedLow_Value(mode_timedilation.gradient_speedlow_value, mode)
    this.Refresh_Gradient_DilationHigh_Value(mode_timedilation.gradient_dilationhigh_value, mode)
    this.Refresh_Gradient_SpeedHigh_Value(mode_timedilation.gradient_speedhigh_value, mode)

    this.Refresh_IsDirty(mode_timedilation.okcancel, mode, mode_timedilation.type_combo, mode_timedilation.const_dilation_value, mode_timedilation.gradient_dilationlow_value, mode_timedilation.gradient_speedlow_value, mode_timedilation.gradient_dilationhigh_value, mode_timedilation.gradient_speedhigh_value)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(mode_timedilation.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(mode_timedilation.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(mode_timedilation.title, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(mode_timedilation.name, vars_ui.style.colors, vars_ui.scale)

    -- dilation type
    Draw_ComboBox(mode_timedilation.type_combo, vars_ui.style.combobox, vars_ui.scale)
    Draw_HelpButton(mode_timedilation.type_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Label(mode_timedilation.type_label, vars_ui.style.colors, vars_ui.scale)

    if mode_timedilation.type_combo.selected_item == dilation_type.constant then
        --timeDilation
        Draw_Label(mode_timedilation.const_dilation_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_timedilation.const_dilation_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_timedilation.const_dilation_value, vars_ui.style.slider, vars_ui.scale)

    elseif mode_timedilation.type_combo.selected_item == dilation_type.gradient then
        -- timeDilation_gradient.timeDilation_lowZSpeed
        Draw_Label(mode_timedilation.gradient_dilationlow_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_timedilation.gradient_dilationlow_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_timedilation.gradient_dilationlow_value, vars_ui.style.slider, vars_ui.scale)

        -- timeDilation_gradient.lowZSpeed
        Draw_Label(mode_timedilation.gradient_speedlow_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_timedilation.gradient_speedlow_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_timedilation.gradient_speedlow_value, vars_ui.style.slider, vars_ui.scale)

        -- timeDilation_gradient.timeDilation_highZSpeed
        Draw_Label(mode_timedilation.gradient_dilationhigh_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_timedilation.gradient_dilationhigh_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_timedilation.gradient_dilationhigh_value, vars_ui.style.slider, vars_ui.scale)

        -- timeDilation_gradient.highZSpeed
        Draw_Label(mode_timedilation.gradient_speedhigh_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_timedilation.gradient_speedhigh_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_timedilation.gradient_speedhigh_value, vars_ui.style.slider, vars_ui.scale)
    end

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(mode_timedilation.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index, mode_timedilation.type_combo, mode_timedilation.const_dilation_value, mode_timedilation.gradient_dilationlow_value, mode_timedilation.gradient_speedlow_value, mode_timedilation.gradient_dilationhigh_value, mode_timedilation.gradient_speedhigh_value)
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)

    elseif isCancelClicked then
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)
    end

    return not (isCloseRequested and not mode_timedilation.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Type_Combo(const)
    -- ComboBox
    return
    {
        preview_text = const.thrust_sound_type.steam,
        selected_item = nil,

        items =
        {
            dilation_type.none,
            dilation_type.constant,
            dilation_type.gradient,
        },

        width = 120,

        position =
        {
            pos_x = 70,
            pos_y = -140,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Mode_TimeDilation_Type_Combo",

        CalcSize = CalcSize_ComboBox,
    }
end
function this.Refresh_Type_Combo(def, mode)
    if not def.selected_item then
        if mode.timeDilation then
            def.selected_item = dilation_type.constant

        elseif mode.timeDilation_gradient then
            def.selected_item = dilation_type.gradient

        else
            def.selected_item = dilation_type.none
        end
    end
end
function this.Define_Type_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Mode_TimeDilation_Type_Help",

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
[[This will slow down time while jetpacking

Constant: The amount that time is slowed is always the same

Gradient: The dilation depends on vertical speed]]

    return retVal
end
function this.Define_Type_Label(relative_to, const)
    -- Label
    return
    {
        text = "Time Dilation Type",

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

function this.Define_Const_Dilation_Label(relative_to, const)
    -- Label
    return
    {
        text = "Time Dilation",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Const_Dilation_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_TimeDilation_Const_Dilation_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[1 is standard time, 0 would be completely stopped, 0.5 would be 50% speed

I had to speed up the player and guns inverse of the time dilation, but some animations still aren't right when the dilation approaches zero.  Sub machine guns work well, but some with extra animations are terrible]]

    return retVal
end
function this.Define_Const_Dilation_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_TimeDilation_Const_Dilation_Value",

        min = 0.001,
        max = 0.99,

        decimal_places = 3,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 0,
            pos_y = 60,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Const_Dilation_Value(def, mode)
    --NOTE: ActivateWindow_Mode_TimeDilation sets this to nil
    if not def.value then
        if mode.timeDilation then
            def.value = mode.timeDilation
        else
            def.value = def.max
        end
    end
end

function this.Define_Gradient_DilationLow_Label(relative_to, const)
    -- Label
    return
    {
        text = "Time Dilation at Low Speed",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Gradient_DilationLow_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_TimeDilation_Gradient_DilationLow_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The time dilation when vertical speed is at or below low speed

1 is standard time, 0 would be completely stopped, 0.5 would be 50% speed

I had to speed up the player and guns inverse of the time dilation, but some animations still aren't right when the dilation approaches zero.  Sub machine guns work well, but some with extra animations are terrible]]

    return retVal
end
function this.Define_Gradient_DilationLow_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_TimeDilation_Gradient_DilationLow_Value",

        min = 0.001,
        max = 0.99,

        decimal_places = 3,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = 20,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Gradient_DilationLow_Value(def, mode)
    --NOTE: ActivateWindow_Mode_TimeDilation sets this to nil
    if not def.value then
        if mode.timeDilation_gradient then
            def.value = mode.timeDilation_gradient.timeDilation_lowZSpeed
        else
            def.value = def.max
        end
    end
end

function this.Define_Gradient_SpeedLow_Label(relative_to, const)
    -- Label
    return
    {
        text = "Low Speed",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Gradient_SpeedLow_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_TimeDilation_Gradient_SpeedLow_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The slowest speed, this would happen at the top of the arc or when hovering

Walking is around 3.5, sprinting is double that.  Lethal speed starts around mid twenties

This is only looking at the vertical part of the player's speed (how fast going up or down)]]

    return retVal
end
function this.Define_Gradient_SpeedLow_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_TimeDilation_Gradient_SpeedLow_Value",

        min = 0,
        max = 40,

        decimal_places = 0,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = 140,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Gradient_SpeedLow_Value(def, mode)
    --NOTE: ActivateWindow_Mode_TimeDilation sets this to nil
    if not def.value then
        if mode.timeDilation_gradient then
            def.value = mode.timeDilation_gradient.lowZSpeed
        else
            def.value = 1
        end
    end
end

function this.Define_Gradient_DilationHigh_Label(relative_to, const)
    -- Label
    return
    {
        text = "Time Dilation at High Speed",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Gradient_DilationHigh_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_TimeDilation_Gradient_DilationHigh_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The time dilation when vertical speed is at or above high speed

1 is standard time, 0 would be completely stopped, 0.5 would be 50% speed

I had to speed up the player and guns inverse of the time dilation, but some animations still aren't right when the dilation approaches zero.  Sub machine guns work well, but some with extra animations are terrible]]

    return retVal
end
function this.Define_Gradient_DilationHigh_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_TimeDilation_Gradient_DilationHigh_Value",

        min = 0.001,
        max = 0.99,

        decimal_places = 3,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = 20,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Gradient_DilationHigh_Value(def, mode)
    --NOTE: ActivateWindow_Mode_TimeDilation sets this to nil
    if not def.value then
        if mode.timeDilation_gradient then
            def.value = mode.timeDilation_gradient.timeDilation_highZSpeed
        else
            def.value = def.max
        end
    end
end

function this.Define_Gradient_SpeedHigh_Label(relative_to, const)
    -- Label
    return
    {
        text = "High Speed",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Gradient_SpeedHigh_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_TimeDilation_Gradient_SpeedHigh_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The fastest speed, this would happen after jumping into the air or falling

Walking is around 3.5, sprinting is double that.  Lethal speed starts around mid twenties

This is only looking at the vertical part of the player's speed (how fast going up or down)]]

    return retVal
end
function this.Define_Gradient_SpeedHigh_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_TimeDilation_Gradient_SpeedHigh_Value",

        min = 0,
        max = 40,

        decimal_places = 0,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = 140,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Gradient_SpeedHigh_Value(def, mode)
    --NOTE: ActivateWindow_Mode_TimeDilation sets this to nil
    if not def.value then
        if mode.timeDilation_gradient then
            def.value = mode.timeDilation_gradient.highZSpeed
        else
            def.value = 1
        end
    end
end

function this.Refresh_IsDirty(def, mode, def_type_combo, def_const_dilation_value, def_gradient_dilationlow_value, def_gradient_speedlow_value, def_gradient_dilationhigh_value, def_gradient_speedhigh_value)
    local isDirty = false

    if def_type_combo.selected_item == dilation_type.none then
        if mode.timeDilation or mode.timeDilation_gradient then
            isDirty = true
        end

    elseif def_type_combo.selected_item == dilation_type.constant then
        if not mode.timeDilation then
            isDirty = true

        elseif not IsNearValue(mode.timeDilation, def_const_dilation_value.value) then
            isDirty = true
        end

    elseif def_type_combo.selected_item == dilation_type.gradient then
        if not mode.timeDilation_gradient then
            isDirty = true

        elseif not IsNearValue(mode.timeDilation_gradient.timeDilation_lowZSpeed, def_gradient_dilationlow_value.value) then
            isDirty = true

        elseif not IsNearValue(mode.timeDilation_gradient.lowZSpeed, def_gradient_speedlow_value.value) then
            isDirty = true

        elseif not IsNearValue(mode.timeDilation_gradient.timeDilation_highZSpeed, def_gradient_dilationhigh_value.value) then
            isDirty = true

        elseif not IsNearValue(mode.timeDilation_gradient.highZSpeed, def_gradient_speedhigh_value.value) then
            isDirty = true
        end
    end

    def.isDirty = isDirty
end

function this.Save(player, mode, mode_index, def_type_combo, def_const_dilation_value, def_gradient_dilationlow_value, def_gradient_speedlow_value, def_gradient_dilationhigh_value, def_gradient_speedhigh_value)
    if def_type_combo.selected_item == dilation_type.none then
        mode.timeDilation = nil
        mode.timeDilation_gradient = nil

    elseif def_type_combo.selected_item == dilation_type.constant then
        mode.timeDilation = def_const_dilation_value.value
        mode.timeDilation_gradient = nil

    elseif def_type_combo.selected_item == dilation_type.gradient then
        mode.timeDilation = nil

        if not mode.timeDilation_gradient then
            mode.timeDilation_gradient = {}
        end

        mode.timeDilation_gradient.timeDilation_lowZSpeed = def_gradient_dilationlow_value.value
        mode.timeDilation_gradient.lowZSpeed = def_gradient_speedlow_value.value
        mode.timeDilation_gradient.timeDilation_highZSpeed = def_gradient_dilationhigh_value.value
        mode.timeDilation_gradient.highZSpeed = def_gradient_speedhigh_value.value
    end

    player:SaveUpdatedMode(mode, mode_index)
end