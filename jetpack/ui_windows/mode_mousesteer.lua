local this = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode_MouseSteer(vars_ui, const)
    local mode_mousesteer = {}
    vars_ui.mode_mousesteer = mode_mousesteer

    mode_mousesteer.changes = Changes:new()

    mode_mousesteer.title = Define_Title("Mouse Steering", const)
    mode_mousesteer.name = Define_Name(const)

    -- Is Used
    mode_mousesteer.hassteer_checkbox = this.Define_HasSteer_Checkbox(const)
    mode_mousesteer.hassteer_help = this.Define_HasSteer_Help(mode_mousesteer.hassteer_checkbox, const)

    -- percent_horz
    mode_mousesteer.percent_horz_value = this.Define_PercentHorz_Value(const)
    mode_mousesteer.percent_horz_label = this.Define_PercentHorz_Label(mode_mousesteer.percent_horz_value, const)
    mode_mousesteer.percent_horz_help = this.Define_PercentHorz_Help(mode_mousesteer.percent_horz_label, const)

    -- percent_vert
    mode_mousesteer.percent_vert_value = this.Define_PercentVert_Value(mode_mousesteer.percent_horz_value, const)
    mode_mousesteer.percent_vert_label = this.Define_PercentVert_Label(mode_mousesteer.percent_vert_value, const)
    mode_mousesteer.percent_vert_help = this.Define_PercentVert_Help(mode_mousesteer.percent_vert_label, const)

    -- dotPow
    mode_mousesteer.dotpow_value = this.Define_DotPow_Value(const)
    mode_mousesteer.dotpow_label = this.Define_DotPow_Label(mode_mousesteer.dotpow_value, const)
    mode_mousesteer.dotpow_help = this.Define_DotPow_Help(mode_mousesteer.dotpow_label, const)

    --TODO: dotPow graphic under the slider
    -- a line chart
    --  X = 1 to 0 (dot product)
    --  Y = 0 to 1 (percent)
    -- below for X axis labels
    --  have an arrow pointing up: |
    --  have another pair of arrows at 45 degrees: |/
    --  and another at 90 degrees: |__

    -- minSpeed
    mode_mousesteer.minspeed_value = this.Define_MinSpeed_Value(const)
    mode_mousesteer.minspeed_label = this.Define_MinSpeed_Label(mode_mousesteer.minspeed_value, const)
    mode_mousesteer.minspeed_help = this.Define_MinSpeed_Help(mode_mousesteer.minspeed_label, const)

    -- maxSpeed
    mode_mousesteer.maxspeed_value = this.Define_MaxSpeed_Value(mode_mousesteer.minspeed_value, const)
    mode_mousesteer.maxspeed_label = this.Define_MaxSpeed_Label(mode_mousesteer.maxspeed_value, const)
    mode_mousesteer.maxspeed_help = this.Define_MaxSpeed_Help(mode_mousesteer.maxspeed_label, const)

    mode_mousesteer.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(mode_mousesteer)
end

function ActivateWindow_Mode_MouseSteer(vars_ui, const)
    if not vars_ui.mode_mousesteer then
        DefineWindow_Mode_MouseSteer(vars_ui, const)
    end

    local mode_mousesteer = vars_ui.mode_mousesteer

    mode_mousesteer.changes:Clear()

    mode_mousesteer.hassteer_checkbox.isChecked = nil
    mode_mousesteer.percent_horz_value.value = nil
    mode_mousesteer.percent_vert_value.value = nil
    mode_mousesteer.dotpow_value.value = nil
    mode_mousesteer.minspeed_value.value = nil
    mode_mousesteer.maxspeed_value.value = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode_MouseSteer(isCloseRequested, vars, vars_ui, player, window, o, const)
    local mode_mousesteer = vars_ui.mode_mousesteer

    local mode = vars_ui.transition_info.mode

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(mode_mousesteer.name, mode.name)

    this.Refresh_HasSteer_Checkbox(mode_mousesteer.hassteer_checkbox, mode)
    this.Refresh_PercentHorz_Value(mode_mousesteer.percent_horz_value, mode)
    this.Refresh_PercentVert_Value(mode_mousesteer.percent_vert_value, mode)
    this.Refresh_DotPow_Value(mode_mousesteer.dotpow_value, mode)
    this.Refresh_MinSpeed_Value(mode_mousesteer.minspeed_value, mode)
    this.Refresh_MaxSpeed_Value(mode_mousesteer.maxspeed_value, mode)

    this.Refresh_IsDirty(mode_mousesteer.okcancel, mode, mode_mousesteer.hassteer_checkbox, mode_mousesteer.percent_horz_value, mode_mousesteer.percent_vert_value, mode_mousesteer.dotpow_value, mode_mousesteer.minspeed_value, mode_mousesteer.maxspeed_value)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(mode_mousesteer.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(mode_mousesteer.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(mode_mousesteer.title, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(mode_mousesteer.name, vars_ui.style.colors, vars_ui.scale)

    -- Is Used
    Draw_CheckBox(mode_mousesteer.hassteer_checkbox, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(mode_mousesteer.hassteer_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    if mode_mousesteer.hassteer_checkbox.isChecked then
        -- percent_horz
        Draw_Label(mode_mousesteer.percent_horz_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_mousesteer.percent_horz_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_mousesteer.percent_horz_value, vars_ui.style.slider, vars_ui.scale)

        -- percent_vert
        Draw_Label(mode_mousesteer.percent_vert_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_mousesteer.percent_vert_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_mousesteer.percent_vert_value, vars_ui.style.slider, vars_ui.scale)

        -- dotPow
        Draw_Label(mode_mousesteer.dotpow_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_mousesteer.dotpow_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_mousesteer.dotpow_value, vars_ui.style.slider, vars_ui.scale)

        -- minSpeed
        Draw_Label(mode_mousesteer.minspeed_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_mousesteer.minspeed_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_mousesteer.minspeed_value, vars_ui.style.slider, vars_ui.scale)

        -- maxSpeed
        Draw_Label(mode_mousesteer.maxspeed_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_mousesteer.maxspeed_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_mousesteer.maxspeed_value, vars_ui.style.slider, vars_ui.scale)
    end

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(mode_mousesteer.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index, mode_mousesteer.hassteer_checkbox, mode_mousesteer.percent_horz_value, mode_mousesteer.percent_vert_value, mode_mousesteer.dotpow_value, mode_mousesteer.minspeed_value, mode_mousesteer.maxspeed_value)
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)

    elseif isCancelClicked then
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)
    end

    return not (isCloseRequested and not mode_mousesteer.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_HasSteer_Checkbox(const)
    -- CheckBox
    return
    {
        invisible_name = "Mode_MouseSteer_HasSteer_Checkbox",

        text = "Has Mouse Steering",

        isEnabled = true,

        position =
        {
            pos_x = 0,
            pos_y = -190,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_HasSteer_Checkbox(def, mode)
    --NOTE: DrawWindow_Mode_MouseSteer sets this to nil
    if def.isChecked == nil then
        if mode.mouseSteer then
            def.isChecked = true
        else
            def.isChecked = false
        end
    end
end
function this.Define_HasSteer_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Mode_MouseSteer_HasSteer_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end

function this.Define_PercentHorz_Label(relative_to, const)
    -- Label
    return
    {
        text = "Horizontal Percent",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_PercentHorz_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_MouseSteer_PercentHorz_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_PercentHorz_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_MouseSteer_PercentHorz_Value",

        min = 0,
        max = 1,

        decimal_places = 2,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = -100,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_PercentHorz_Value(def, mode)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_MouseSteer sets this to nil
    if not def.value then
        if mode.mouseSteer then
            def.value = mode.mouseSteer.percent_horz
        else
            def.value = 1
        end
    end
end

function this.Define_PercentVert_Label(relative_to, const)
    -- Label
    return
    {
        text = "Vertical Percent",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_PercentVert_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_MouseSteer_PercentVert_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_PercentVert_Value(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Mode_MouseSteer_PercentVert_Value",

        min = 0,
        max = 1,

        decimal_places = 2,

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
function this.Refresh_PercentVert_Value(def, mode)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_MouseSteer sets this to nil
    if not def.value then
        if mode.mouseSteer then
            def.value = mode.mouseSteer.percent_vert
        else
            def.value = 0
        end
    end
end

function this.Define_DotPow_Label(relative_to, const)
    -- Label
    return
    {
        text = "Dot Product Power",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_DotPow_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_MouseSteer_DotPow_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_DotPow_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_MouseSteer_DotPow_Value",

        min = 0,
        max = 6,

        decimal_places = 2,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = -50,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_DotPow_Value(def, mode)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_MouseSteer sets this to nil
    if not def.value then
        if mode.mouseSteer then
            def.value = mode.mouseSteer.dotPow
        else
            def.value = 2
        end
    end
end

function this.Define_MinSpeed_Label(relative_to, const)
    -- Label
    return
    {
        text = "Min Speed",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_MinSpeed_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_MouseSteer_MinSpeed_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_MinSpeed_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_MouseSteer_MinSpeed_Value",

        min = 1,
        max = 70,

        decimal_places = 0,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = 100,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_MinSpeed_Value(def, mode)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_MouseSteer sets this to nil
    if not def.value then
        if mode.mouseSteer then
            def.value = mode.mouseSteer.minSpeed
        else
            def.value = 12
        end
    end
end

function this.Define_MaxSpeed_Label(relative_to, const)
    -- Label
    return
    {
        text = "Max Speed",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_MaxSpeed_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_MouseSteer_MaxSpeed_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[]]

    return retVal
end
function this.Define_MaxSpeed_Value(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "Mode_MouseSteer_MaxSpeed_Value",

        min = 1,
        max = 70,

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
function this.Refresh_MaxSpeed_Value(def, mode)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_MouseSteer sets this to nil
    if not def.value then
        if mode.mouseSteer then
            def.value = mode.mouseSteer.maxSpeed
        else
            def.value = 24
        end
    end
end

function this.Refresh_IsDirty(def, mode, def_hassteer_checkbox, def_percent_horz_value, def_percent_vert_value, def_dotpow_value, def_minspeed_value, def_maxspeed_value)
    local isDirty = false

    if def_hassteer_checkbox.isChecked then
        if not mode.mouseSteer then
            isDirty = true
        end
    else
        if mode.mouseSteer then
            isDirty = true
        end
    end

    if not isDirty and mode.mouseSteer then
        if not IsNearValue(mode.mouseSteer.percent_horz, def_percent_horz_value.value) then
            isDirty = true

        elseif not IsNearValue(mode.mouseSteer.percent_vert, def_percent_vert_value.value) then
            isDirty = true

        elseif not IsNearValue(mode.mouseSteer.dotPow, def_dotpow_value.value) then
            isDirty = true

        elseif not IsNearValue(mode.mouseSteer.minSpeed, def_minspeed_value.value) then
            isDirty = true

        elseif not IsNearValue(mode.mouseSteer.maxSpeed, def_maxspeed_value.value) then
            isDirty = true
        end
    end

    def.isDirty = isDirty
end

function this.Save(player, mode, mode_index, def_hassteer_checkbox, def_percent_horz_value, def_percent_vert_value, def_dotpow_value, def_minspeed_value, def_maxspeed_value)
    if def_hassteer_checkbox.isChecked then
        if not mode.mouseSteer then
            mode.mouseSteer = {}
        end

        mode.mouseSteer.percent_horz = def_percent_horz_value.value
        mode.mouseSteer.percent_vert = def_percent_vert_value.value
        mode.mouseSteer.dotPow = def_dotpow_value.value
        mode.mouseSteer.minSpeed = def_minspeed_value.value
        mode.mouseSteer.maxSpeed = def_maxspeed_value.value
    else
        mode.mouseSteer = nil
    end

    player:SaveUpdatedMode(mode, mode_index)
end

---------------------------------------------------------------------------------------



