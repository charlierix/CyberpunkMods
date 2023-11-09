local this = {}

-- This gets called during init and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode_Rebound(vars_ui, const)
    local mode_rebound = {}
    vars_ui.mode_rebound = mode_rebound

    mode_rebound.changes = Changes:new()

    mode_rebound.title = Define_Title("Rebound", const)
    mode_rebound.name = Define_Name(const)

    -- checkbox
    mode_rebound.hasrebound_checkbox = this.Define_HasRebound_Checkbox(const)
    mode_rebound.hasrebound_help = this.Define_HasRebound_Help(mode_rebound.hasrebound_checkbox, const)

    -- percent_at_zero
    mode_rebound.percentzero_value = this.Define_PercentZero_Value(const)
    mode_rebound.percentzero_label = this.Define_PercentZero_Label(mode_rebound.percentzero_value, const)
    mode_rebound.percentzero_help = this.Define_PercentZero_Help(mode_rebound.percentzero_label, const)

    -- percent_at_max
    mode_rebound.percentmax_value = this.Define_PercentMax_Value(const)
    mode_rebound.percentmax_label = this.Define_PercentMax_Label(mode_rebound.percentmax_value, const)
    mode_rebound.percentmax_help = this.Define_PercentMax_Help(mode_rebound.percentmax_label, const)

    -- speed_of_max
    mode_rebound.speedmax_value = this.Define_SpeedMax_Value(const)
    mode_rebound.speedmax_label = this.Define_SpeedMax_Label(mode_rebound.speedmax_value, const)
    mode_rebound.speedmax_help = this.Define_SpeedMax_Help(mode_rebound.speedmax_label, const)

    mode_rebound.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(mode_rebound)
end

function ActivateWindow_Mode_Rebound(vars_ui, const)
    if not vars_ui.mode_rebound then
        DefineWindow_Mode_Rebound(vars_ui, const)
    end

    local mode_rebound = vars_ui.mode_rebound

    mode_rebound.changes:Clear()

    mode_rebound.hasrebound_checkbox.isChecked = nil
    mode_rebound.percentzero_value.value = nil
    mode_rebound.percentmax_value.value = nil
    mode_rebound.speedmax_value.value = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode_Rebound(isCloseRequested, vars, vars_ui, player, window, o, const)
    local mode_rebound = vars_ui.mode_rebound

    local mode = vars_ui.transition_info.mode

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(mode_rebound.name, mode.name)

    this.Refresh_HasRebound_Checkbox(mode_rebound.hasrebound_checkbox, mode)
    this.Refresh_PercentZero_Value(mode_rebound.percentzero_value, mode)
    this.Refresh_PercentMax_Value(mode_rebound.percentmax_value, mode)
    this.Refresh_SpeedMax_Value(mode_rebound.speedmax_value, mode)

    this.Refresh_IsDirty(mode_rebound.okcancel, mode, mode_rebound.hasrebound_checkbox, mode_rebound.percentzero_value, mode_rebound.percentmax_value, mode_rebound.speedmax_value)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(mode_rebound.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(mode_rebound.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(mode_rebound.title, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(mode_rebound.name, vars_ui.style.colors, vars_ui.scale)

    -- checkbox
    Draw_CheckBox(mode_rebound.hasrebound_checkbox, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(mode_rebound.hasrebound_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    if mode_rebound.hasrebound_checkbox.isChecked then
        -- percent_at_zero
        Draw_Label(mode_rebound.percentzero_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_rebound.percentzero_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_rebound.percentzero_value, vars_ui.style.slider, vars_ui.scale)

        -- percent_at_max
        Draw_Label(mode_rebound.percentmax_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_rebound.percentmax_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_rebound.percentmax_value, vars_ui.style.slider, vars_ui.scale)

        -- speed_of_max
        Draw_Label(mode_rebound.speedmax_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_rebound.speedmax_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_rebound.speedmax_value, vars_ui.style.slider, vars_ui.scale)
    end

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(mode_rebound.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index, mode_rebound.hasrebound_checkbox, mode_rebound.percentzero_value, mode_rebound.percentmax_value, mode_rebound.speedmax_value)
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)

    elseif isCancelClicked then
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)
    end

    return not (isCloseRequested and not mode_rebound.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_HasRebound_Checkbox(const)
    -- CheckBox
    return
    {
        invisible_name = "Mode_Rebound_HasRebound_Checkbox",

        text = "Has Rebound",

        isEnabled = true,

        position =
        {
            pos_x = 0,
            pos_y = -140,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_HasRebound_Checkbox(def, mode)
    --NOTE: DrawWindow_Mode_Rebound sets this to nil
    if def.isChecked == nil then
        if mode.rebound then
            def.isChecked = true
        else
            def.isChecked = false
        end
    end
end
function this.Define_HasRebound_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "Mode_Rebound_HasRebound_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Allows the player to bounce off the ground if they hold in jump as they hit the ground (also reactivates jetpack)

If jump is just held in to soften a fall, there won't be a rebound.  The jump button needs to get pressed as you hit the ground]]

    return retVal
end

function this.Define_PercentZero_Label(relative_to, const)
    -- Label
    return
    {
        text = "Percent at Zero",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_PercentZero_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Rebound_PercentZero_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The percent of vertical part of velocity to rebound with when vertical component of velocity is zero

In other words, horizontal part of velocity is ignored.  How fast you are going down gets multiplied by this percent and an impulse makes you go up at that new speed

When at zero, there is no speed or rebound.  This is just setting up the gradient boundary value]]

    return retVal
end
function this.Define_PercentZero_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Rebound_PercentZero_Value",

        min = 0,
        max = 2,

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
function this.Refresh_PercentZero_Value(def, mode)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_Rebound sets this to nil
    if not def.value then
        if mode.rebound then
            def.value = mode.rebound.percent_at_zero
        else
            def.value = 1
        end
    end
end

function this.Define_PercentMax_Label(relative_to, const)
    -- Label
    return
    {
        text = "Percent at Max",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_PercentMax_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Rebound_PercentMax_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The percent to use at a high impact speed (speed is defined by speed at max)

Values above one will rebound with more speed than at impact]]

    return retVal
end
function this.Define_PercentMax_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Rebound_PercentMax_Value",

        min = 0,
        max = 2,

        decimal_places = 3,

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
function this.Refresh_PercentMax_Value(def, mode)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_Rebound sets this to nil
    if not def.value then
        if mode.rebound then
            def.value = mode.rebound.percent_at_max
        else
            def.value = 1
        end
    end
end

function this.Define_SpeedMax_Label(relative_to, const)
    -- Label
    return
    {
        text = "Speed at Max",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_SpeedMax_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Rebound_SpeedMax_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[The speed where percent at max should be applied.  Any speed higher than this will also use percent at max

These units might be meters per second?  Walking is around 3.5, sprinting is double that.  Lethal speed starts around mid twenties.  30 to 40 is a good range for this value

If you want more information, edit init.lua and set "shouldShowDebugWindow = true", then push the "Reload all mods" button in cet]]

    return retVal
end
function this.Define_SpeedMax_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Rebound_SpeedMax_Value",

        min = 0,
        max = 60,

        decimal_places = 0,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = 80,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_SpeedMax_Value(def, mode)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_Rebound sets this to nil
    if not def.value then
        if mode.rebound then
            def.value = mode.rebound.speed_of_max
        else
            def.value = 30
        end
    end
end

function this.Refresh_IsDirty(def, mode, def_hasrebound_checkbox, def_percentzero_value, def_percentmax_value, def_speedmax_value)
    local isDirty = false

    if def_hasrebound_checkbox.isChecked then
        if not mode.rebound then
            isDirty = true
        end
    else
        if mode.rebound then
            isDirty = true
        end
    end

    if not isDirty and mode.rebound then
        if not IsNearValue(mode.rebound.percent_at_zero, def_percentzero_value.value) then
            isDirty = true

        elseif not IsNearValue(mode.rebound.percent_at_max, def_percentmax_value.value) then
            isDirty = true

        elseif not IsNearValue(mode.rebound.speed_of_max, def_speedmax_value.value) then
            isDirty = true
        end
    end

    def.isDirty = isDirty
end

function this.Save(player, mode, mode_index, def_hasrebound_checkbox, def_percentzero_value, def_percentmax_value, def_speedmax_value)
    if def_hasrebound_checkbox.isChecked then
        if not mode.rebound then
            mode.rebound = {}
        end

        mode.rebound.percent_at_zero = def_percentzero_value.value
        mode.rebound.percent_at_max = def_percentmax_value.value
        mode.rebound.speed_of_max = def_speedmax_value.value
    else
        mode.rebound = nil
    end

    player:SaveUpdatedMode(mode, mode_index)
end