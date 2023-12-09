local this = {}

local curve_max_fromslider = nil
local curve_max_toslider = nil

-- This gets called during activate and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode_Energy(vars_ui, const)
    local mode_energy = {}
    vars_ui.mode_energy = mode_energy

    mode_energy.changes = Changes:new()

    mode_energy.title = Define_Title("Energy", const)
    mode_energy.name = Define_Name(const)

    mode_energy.max_unlimited = this.Define_Max_Unlimited(const)

    -- maxBurnTime
    -- 0 to 36
    mode_energy.max_time = this.Define_Max_Time(const)
    mode_energy.max_label = this.Define_Max_Label(mode_energy.max_time, const)
    mode_energy.max_help = this.Define_Max_Help(mode_energy.max_label, const)

    -- recoveryRate
    -- 0 to 2
    mode_energy.recovery_rate = this.Define_Recovery_Rate(const)
    mode_energy.recovery_label = this.Define_Recovery_Label(mode_energy.recovery_rate, const)
    mode_energy.recovery_help = this.Define_Recovery_Help(mode_energy.recovery_label, const)

    -- burnRate_dash
    -- 1 to 4
    mode_energy.dash_rate = this.Define_Dash_Rate(const)
    mode_energy.dash_label = this.Define_Dash_Label(mode_energy.dash_rate, const)
    mode_energy.dash_help = this.Define_Dash_Help(mode_energy.dash_label, const)

    -- burnRate_horz
    -- 0 to 2
    mode_energy.horz_rate = this.Define_Horz_Rate(const)
    mode_energy.horz_label = this.Define_Horz_Label(mode_energy.horz_rate, const)
    mode_energy.horz_help = this.Define_Horz_Help(mode_energy.horz_label, const)

    mode_energy.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(mode_energy)
end

function ActivateWindow_Mode_Energy(vars_ui, const)
    if not vars_ui.mode_energy then
        DefineWindow_Mode_Energy(vars_ui, const)
    end

    local mode_energy = vars_ui.mode_energy

    mode_energy.changes:Clear()

    mode_energy.max_time.value = nil
    mode_energy.max_unlimited.isChecked = nil
    mode_energy.recovery_rate.value = nil
    mode_energy.dash_rate.value = nil
    mode_energy.horz_rate.value = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode_Energy(isCloseRequested, vars, vars_ui, player, window, o, const)
    local mode_energy = vars_ui.mode_energy

    local mode = vars_ui.transition_info.mode

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(mode_energy.name, mode.name)

    this.Refresh_Max_Time(mode_energy.max_time, mode.energy)
    this.Refresh_Max_Unlimited(mode_energy.max_unlimited, mode.energy)

    this.Refresh_Recovery_Rate(mode_energy.recovery_rate, mode.energy)
    this.Refresh_Dash_Rate(mode_energy.dash_rate, mode.energy)
    this.Refresh_Horz_Rate(mode_energy.horz_rate, mode.energy)

    this.Refresh_IsDirty(mode_energy.okcancel, mode, const, mode_energy.max_unlimited, mode_energy.max_time, mode_energy.recovery_rate, mode_energy.dash_rate, mode_energy.horz_rate)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(mode_energy.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(mode_energy.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(mode_energy.title, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(mode_energy.name, vars_ui.style.colors, vars_ui.scale)

    Draw_CheckBox(mode_energy.max_unlimited, vars_ui.style.checkbox, vars_ui.style.colors)

    if not mode_energy.max_unlimited.isChecked then
        -- maxBurnTime
        Draw_Label(mode_energy.max_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_energy.max_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

        if mode_energy.max_time.value then      -- when first unchecking, need a frame to give the refresh function a chance to be called
            Draw_Slider(mode_energy.max_time, vars_ui.style.slider, vars_ui.scale)
        end

        -- recoveryRate
        Draw_Label(mode_energy.recovery_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_energy.recovery_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

        if mode_energy.recovery_rate.value then
            Draw_Slider(mode_energy.recovery_rate, vars_ui.style.slider, vars_ui.scale)
        end

        -- burnRate_dash
        Draw_Label(mode_energy.dash_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_energy.dash_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_energy.dash_rate, vars_ui.style.slider, vars_ui.scale)     -- this slider isn't conditional on unlimited checkbox.  It just stays whatver value it was

        -- burnRate_horz
        Draw_Label(mode_energy.horz_label, vars_ui.style.colors, vars_ui.scale)
        Draw_HelpButton(mode_energy.horz_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
        Draw_Slider(mode_energy.horz_rate, vars_ui.style.slider, vars_ui.scale)
    end

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(mode_energy.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index, mode_energy.max_unlimited, mode_energy.max_time, mode_energy.recovery_rate, mode_energy.dash_rate, mode_energy.horz_rate)
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)

    elseif isCancelClicked then
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)
    end

    return not (isCloseRequested and not mode_energy.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Max_Unlimited(const)
    -- CheckBox
    return
    {
        invisible_name = "Mode_Energy_Max_Checkbox",

        text = "Unlimited",

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
function this.Refresh_Max_Unlimited(def, energy)
    --NOTE: ActivateWindow_Mode_Energy sets this to nil
    if def.isChecked == nil then
        if energy.maxBurnTime > 36 then
            def.isChecked = true
        else
            def.isChecked = false
        end
    end
end

function this.Define_Max_Label(relative_to, const)
    -- Label
    return
    {
        text = "Max Time",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Max_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Energy_Max_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This is the size of the fuel tank, which is seconds of burn time

Standard vertical thrust is 1 fuel per second.  Horizontal and dashing can have different burn rates

If unlimited is checked, then the size is set to 999 and refill is 99 per second]]

    return retVal
end
function this.Define_Max_Time(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Energy_Max_Time",

        min = 0,
        max = 1,

        get_custom_text = function(val) return this.MaxBurnTime_FromSlider_Display(val) end,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Max_Time(def, energy)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_Energy sets this to nil
    if not def.value then
        if energy.maxBurnTime <= 36 then
            def.value = this.MaxBurnTime_ToSlider(energy.maxBurnTime)
        else
            def.value = def.max
        end
    end
end

function this.Define_Recovery_Label(relative_to, const)
    -- Label
    return
    {
        text = "Recovery Rate",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Recovery_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Energy_Recovery_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[How fast the energy tank fills up

Energy tank's quantity is seconds, so a recovery rate of one will replenish as fast as it's drained (unless horizontal or dash deplete it faster)

If unlimited, then rate becomes 99]]

    return retVal
end
function this.Define_Recovery_Rate(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Energy_Recovery_Rate",

        min = 0,
        max = 3,

        decimal_places = 2,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = 130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Recovery_Rate(def, energy)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_Energy sets this to nil
    if not def.value then
        if energy.recoveryRate <= def.max then
            def.value = energy.recoveryRate
        else
            def.value = def.max
        end
    end
end

function this.Define_Dash_Label(relative_to, const)
    -- Label
    return
    {
        text = "Burn Rate - Dashing",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Dash_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Energy_Dash_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Standard vertical thrust has a burn rate of one energy per second

Dashing should use more fuel

To activate dash, tap the button, let go, then hold in that button]]

    return retVal
end
function this.Define_Dash_Rate(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Energy_Dash_Rate",

        min = 1,
        max = 4,

        decimal_places = 1,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = 0,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Dash_Rate(def, energy)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_Energy sets this to nil
    if not def.value then
        def.value = energy.burnRate_dash
    end
end

function this.Define_Horz_Label(relative_to, const)
    -- Label
    return
    {
        text = "Burn Rate - Horizontal",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Horz_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Energy_Horz_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Standard vertical thrust has a burn rate of one energy per second

Maybe horizontal should cost a different amount?]]

    return retVal
end
function this.Define_Horz_Rate(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Energy_Horz_Rate",

        min = 0.01,
        max = 2,

        decimal_places = 2,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = 130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Horz_Rate(def, energy)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: ActivateWindow_Mode_Energy sets this to nil
    if not def.value then
        def.value = energy.burnRate_horz
    end
end

function this.Refresh_IsDirty(def, mode, const, def_max_unlimited, def_max_time, def_recovery_rate, def_dash_rate, def_horz_rate)
    local isDirty = false

    if not IsNearValue_custom(mode.energy.maxBurnTime, this.GetNew_MaxBurnTime(def_max_unlimited, def_max_time), const.ui_dirty_epsilon) then
        isDirty = true

    elseif not IsNearValue_custom(mode.energy.recoveryRate, this.GetNew_ReoveryRate(def_max_unlimited, def_recovery_rate), const.ui_dirty_epsilon) then
        isDirty = true

    elseif not IsNearValue_custom(mode.energy.burnRate_dash, def_dash_rate.value, const.ui_dirty_epsilon) then
        isDirty = true

    elseif not IsNearValue_custom(mode.energy.burnRate_horz, def_horz_rate.value, const.ui_dirty_epsilon) then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, mode, mode_index, def_max_unlimited, def_max_time, def_recovery_rate, def_dash_rate, def_horz_rate)
    mode.energy.maxBurnTime = this.GetNew_MaxBurnTime(def_max_unlimited, def_max_time)
    mode.energy.recoveryRate = this.GetNew_ReoveryRate(def_max_unlimited, def_recovery_rate)
    mode.energy.burnRate_dash = def_dash_rate.value
    mode.energy.burnRate_horz = def_horz_rate.value

    player:SaveUpdatedMode(mode, mode_index)
end

---------------------------------------------------------------------------------------


--TODO: Generalize these functions and put them in a public utility class
function this.GetNew_MaxBurnTime(def_max_unlimited, def_max_time)
    if def_max_unlimited.isChecked or not def_max_time.value then
        return 999
    else
        return this.MaxBurnTime_FromSlider(def_max_time.value)
    end
end
function this.GetNew_ReoveryRate(def_max_unlimited, def_recovery_rate)
    if def_max_unlimited.isChecked or not def_recovery_rate.value then
        return 99
    else
        return def_recovery_rate.value
    end
end

function this.MaxBurnTime_FromSlider_Display(value)
    local result = this.MaxBurnTime_FromSlider(value)

    local decimal_places = 0
    if result < 2 then
        decimal_places = 2
    elseif result < 12 then
        decimal_places = 1
    end

    local format = "%"
    if decimal_places == 0 then
        format = format .. "."
    else
        format = format .. "." .. tostring(decimal_places)
    end

    return string.format(format .. "f", result)
end
function this.MaxBurnTime_FromSlider_PURE(value)
    -- While this works, the inverse seems like it would be difficult to calculate
    -- https://math.stackexchange.com/questions/210720/inverse-function-of-a-polynomial
    --
    -- It should be possible, since the function only increases, but I'll just use beziers


    -- Slider will be 0 to 1.  Output will be the corresponding values
    -- 0        0
    -- 0.5      6
    -- 0.66     12
    -- 1        36

    -- y(x) = 27.54010695187169x^3 + 6.689839572192472x^2 + 1.7700534759358426x
    -- y(x) = 27.540107x^3 + 6.689840x^2 + 1.770053x

    return (27.540107 * (value ^ 3)) + (6.689840 * (value ^ 2)) + (1.770053 * value)
end
function this.MaxBurnTime_FromSlider(value)
    this.EnsureCurvesPopulated()

    return curve_max_fromslider:Evaluate(value)
end
function this.MaxBurnTime_ToSlider(value)
    this.EnsureCurvesPopulated()

    return curve_max_toslider:Evaluate(value)
end



function this.EnsureCurvesPopulated()
    if curve_max_fromslider then
        do return end
    end

    curve_max_fromslider = AnimationCurve:new()
    curve_max_fromslider:AddKeyValue(0, 0)
    curve_max_fromslider:AddKeyValue(0.5, 6)
    curve_max_fromslider:AddKeyValue(0.66, 12)
    curve_max_fromslider:AddKeyValue(1, 36)

    curve_max_toslider = AnimationCurve:new()
    curve_max_toslider:AddKeyValue(0, 0)
    curve_max_toslider:AddKeyValue(6, 0.5)
    curve_max_toslider:AddKeyValue(12, 0.66)
    curve_max_toslider:AddKeyValue(36, 1)
end