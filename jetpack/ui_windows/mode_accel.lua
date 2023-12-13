local this = {}

local curve_vert_fromslider = nil
local curve_vert_toslider = nil

local curve_horz_fromslider = nil
local curve_horz_toslider = nil

local curve_initial_fromslider = nil
local curve_initial_toslider = nil

local curve_gravity_fromslider = nil
local curve_gravity_toslider = nil


-- This gets called during activate and sets up as much static inforation as it can for all the
-- controls (the rest of the info gets filled out each frame)
--
-- Individual controls are defined in
--  models\viewmodels\...
function DefineWindow_Mode_Accel(vars_ui, const)
    local mode_accel = {}
    vars_ui.mode_accel = mode_accel

    this.EnsureCurvesPopulated()

    mode_accel.title = Define_Title("Accelerations", const)
    mode_accel.name = Define_Name(const)

    --TODO: arrows

    -- vert_stand - 0 to 24
    mode_accel.vert_value = this.Define_Vert_Value(const)
    mode_accel.vert_label = this.Define_Vert_Label(mode_accel.vert_value, const)
    mode_accel.vert_help = this.Define_Vert_Help(mode_accel.vert_label, const)

    -- vert_dash - 0 to 24
    mode_accel.vertdash_value = this.Define_VertDash_Value(const)
    mode_accel.vertdash_label = this.Define_VertDash_Label(mode_accel.vertdash_value, const)
    mode_accel.vertdash_help = this.Define_VertDash_Help(mode_accel.vertdash_label, const)

    -- horz_stand - 0 to 80
    mode_accel.horz_value = this.Define_Horz_Value(const)
    mode_accel.horz_label = this.Define_Horz_Label(mode_accel.horz_value, const)
    mode_accel.horz_help = this.Define_Horz_Help(mode_accel.horz_label, const)

    -- horz_dash - 0 to 80
    mode_accel.horzdash_value = this.Define_HorzDash_Value(const)
    mode_accel.horzdash_label = this.Define_HorzDash_Label(mode_accel.horzdash_value, const)
    mode_accel.horzdash_help = this.Define_HorzDash_Help(mode_accel.horzdash_label, const)

    -- vert_initial - 0 to 24
    mode_accel.initial_value = this.Define_Initial_Value(const)
    --mode_accel.initial_label = this.Define_Initial_Label(mode_accel.initial_value, const)
    mode_accel.initial_checkbox = this.Define_Initial_Checkbox(mode_accel.initial_value, const)     -- using the checkbox as the label
    mode_accel.initial_help = this.Define_Initial_Help(mode_accel.initial_checkbox, const)

    -- gravity - 0 to -40
    mode_accel.gravity_value = this.Define_Gravity_Value(const)
    mode_accel.gravity_label = this.Define_Gravity_Label(mode_accel.gravity_value, const)
    mode_accel.gravity_help = this.Define_Gravity_Help(mode_accel.gravity_label, const)

    mode_accel.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(mode_accel)
end

function ActivateWindow_Mode_Accel(vars_ui, const)
    if not vars_ui.mode_accel then
        DefineWindow_Mode_Accel(vars_ui, const)
    end

    local mode_accel = vars_ui.mode_accel

    mode_accel.vert_value.value = nil
    mode_accel.vertdash_value.value = nil
    mode_accel.horz_value.value = nil
    mode_accel.horzdash_value.value = nil
    mode_accel.initial_value.value = nil
    mode_accel.initial_checkbox.isChecked = nil
    mode_accel.gravity_value.value = nil
end

-- This gets called each frame from DrawConfig()
function DrawWindow_Mode_Accel(isCloseRequested, vars, vars_ui, player, window, o, const)
    local mode_accel = vars_ui.mode_accel

    local mode = vars_ui.transition_info.mode

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(mode_accel.name, mode.name)

    this.Refresh_Vert_Value(mode_accel.vert_value, mode)
    this.Refresh_VertDash_Value(mode_accel.vertdash_value, mode)
    this.Refresh_Horz_Value(mode_accel.horz_value, mode.accel)
    this.Refresh_HorzDash_Value(mode_accel.horzdash_value, mode.accel)
    this.Refresh_Initial_Value(mode_accel.initial_value, mode.accel)
    this.Refresh_Initial_Checkbox(mode_accel.initial_checkbox, mode.accel)
    this.Refresh_Gravity_Value(mode_accel.gravity_value, mode.accel)

    this.Refresh_IsDirty(mode_accel.okcancel, mode, const, mode_accel.vert_value, mode_accel.vertdash_value, mode_accel.horz_value, mode_accel.horzdash_value, mode_accel.initial_checkbox, mode_accel.initial_value, mode_accel.gravity_value)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(mode_accel.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(mode_accel.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(mode_accel.title, vars_ui.style.colors, vars_ui.scale)
    Draw_Label(mode_accel.name, vars_ui.style.colors, vars_ui.scale)

    -- vert_stand
    Draw_Label(mode_accel.vert_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(mode_accel.vert_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(mode_accel.vert_value, vars_ui.style.slider, vars_ui.scale)

    -- vert_dash
    Draw_Label(mode_accel.vertdash_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(mode_accel.vertdash_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(mode_accel.vertdash_value, vars_ui.style.slider, vars_ui.scale)

    -- horz_stand
    Draw_Label(mode_accel.horz_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(mode_accel.horz_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(mode_accel.horz_value, vars_ui.style.slider, vars_ui.scale)

    -- horz_dash
    Draw_Label(mode_accel.horzdash_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(mode_accel.horzdash_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(mode_accel.horzdash_value, vars_ui.style.slider, vars_ui.scale)

    -- vert_initial
    --Draw_Label(mode_accel.initial_label, vars_ui.style.colors, vars_ui.scale)
    Draw_CheckBox(mode_accel.initial_checkbox, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(mode_accel.initial_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    if mode_accel.initial_checkbox.isChecked then
        Draw_Slider(mode_accel.initial_value, vars_ui.style.slider, vars_ui.scale)
    end

    -- gravity
    Draw_Label(mode_accel.gravity_label, vars_ui.style.colors, vars_ui.scale)
    Draw_HelpButton(mode_accel.gravity_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(mode_accel.gravity_value, vars_ui.style.slider, vars_ui.scale)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(mode_accel.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, mode, vars_ui.transition_info.mode_index, mode_accel.vert_value, mode_accel.vertdash_value, mode_accel.horz_value, mode_accel.horzdash_value, mode_accel.initial_checkbox, mode_accel.initial_value, mode_accel.gravity_value)
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)

    elseif isCancelClicked then
        TransitionWindows_Mode(vars_ui, const, vars_ui.transition_info.mode, vars_ui.transition_info.mode_index)
    end

    return not (isCloseRequested and not mode_accel.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Vert_Label(relative_to, const)
    -- Label
    return
    {
        text = "Vertical",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Vert_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Accel_Vert_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[How much acceleration to apply when holding in the jump button]]

    return retVal
end
function this.Define_Vert_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Accel_Vert_Value",

        min = 0,
        max = 1,

        get_custom_text = function(val) return this.Value_FromSlider_Display(val, curve_vert_fromslider) end,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = -130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Vert_Value(def, mode)
    --NOTE: ActivateWindow_Mode_Accel sets this to nil
    if not def.value then
        -- Posibly remove the gravity adjustment
        local ui_val = mode_defaults.ImpulseGravityAdjust_ToUI(mode.useImpulse, mode.accel.gravity, mode.accel.vert_stand)

        -- Map the value into scrollbar's 0 to 1
        def.value = curve_vert_toslider:Evaluate(ui_val)        --NOTE: Evaluate caps to min/max
    end
end

function this.Define_VertDash_Label(relative_to, const)
    -- Label
    return
    {
        text = "Vertical - Dashing",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_VertDash_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Accel_VertDash_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This gives an option to accelerate harder at the cost of more fuel

To activate dash, tap jump, let go, then hold in jump]]

    return retVal
end
function this.Define_VertDash_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Accel_VertDash_Value",

        min = 0,
        max = 1,

        get_custom_text = function(val) return this.Value_FromSlider_Display(val, curve_vert_fromslider) end,

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
function this.Refresh_VertDash_Value(def, mode)
    --NOTE: ActivateWindow_Mode_Accel sets this to nil
    if not def.value then
        -- Posibly remove the gravity adjustment
        local ui_val = mode_defaults.ImpulseGravityAdjust_ToUI(mode.useImpulse, mode.accel.gravity, mode.accel.vert_dash)

        -- Map the value into scrollbar's 0 to 1
        def.value = curve_vert_toslider:Evaluate(ui_val)        --NOTE: Evaluate caps to min/max
    end
end

function this.Define_Horz_Label(relative_to, const)
    -- Label
    return
    {
        text = "Horizontal",

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

        invisible_name = "Mode_Accel_Horz_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This is the acceleration used for front/back, left/right

Some modes could be more flight based, so stronger horizontal than vertical.  Other modes could be more about tall jumping]]

    return retVal
end
function this.Define_Horz_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Accel_Horz_Value",

        min = 0,
        max = 1,

        get_custom_text = function(val) return this.Value_FromSlider_Display(val, curve_horz_fromslider) end,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = -130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Horz_Value(def, accel)
    --NOTE: ActivateWindow_Mode_Accel sets this to nil
    if not def.value then
        --NOTE: Evaluate caps to min/max
        def.value = curve_horz_toslider:Evaluate(accel.horz_stand)
    end
end

function this.Define_HorzDash_Label(relative_to, const)
    -- Label
    return
    {
        text = "Horizontal - Dashing",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_HorzDash_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Accel_HorzDash_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This gives an option to accelerate harder at the cost of more fuel

To activate dash, tap the direction button, let go, then hold in that button]]

    return retVal
end
function this.Define_HorzDash_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Accel_HorzDash_Value",

        min = 0,
        max = 1,

        get_custom_text = function(val) return this.Value_FromSlider_Display(val, curve_horz_fromslider) end,

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
function this.Refresh_HorzDash_Value(def, accel)
    --NOTE: ActivateWindow_Mode_Accel sets this to nil
    if not def.value then
        --NOTE: Evaluate caps to min/max
        def.value = curve_horz_toslider:Evaluate(accel.horz_dash)
    end
end

function this.Define_Initial_Label(relative_to, const)
    -- Label
    return
    {
        text = "Initial Jump",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Initial_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Accel_Initial_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This is an optional one time boost up, only applies when starting from the ground

This is the primary acceleration for jump style modes.  Smaller values can also help the regular modes not feel so sluggish getting off the ground

There seems to be a difference between impulse and teleport based flight modes.  Teleport based can use smaller values.  With impulse based, values under 2 don't seem to do anything]]

    return retVal
end
function this.Define_Initial_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Accel_Initial_Value",

        min = 0,
        max = 1,

        get_custom_text = function(val) return this.Value_FromSlider_Display(val, curve_vert_fromslider) end,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -180,
            pos_y = 150,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Initial_Value(def, accel)
    --NOTE: ActivateWindow_Mode_Accel sets this to nil
    if not def.value then
        --NOTE: Evaluate caps to min/max
        if accel.vert_initial then
            def.value = curve_vert_toslider:Evaluate(accel.vert_initial)
        else
            def.value = def.min     -- vert_initial is nil when there is no inital impulse
        end
    end
end
function this.Define_Initial_Checkbox(relative_to, const)
    -- CheckBox
    return
    {
        invisible_name = "Mode_Accel_Initial_Checkbox",

        text = "Initial Jump",

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
function this.Refresh_Initial_Checkbox(def, accel)
    --NOTE: ActivateWindow_Mode_Accel sets this to nil
    if def.isChecked == nil then
        if accel.vert_initial then
            def.isChecked = true
        else
            def.isChecked = false
        end
    end
end

function this.Define_Gravity_Label(relative_to, const)
    -- Label
    return
    {
        text = "Gravity",

        position = GetRelativePosition_LabelAbove(relative_to, const),

        color = "edit_prompt",

        CalcSize = CalcSize_Label,
    }
end
function this.Define_Gravity_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "Mode_Accel_Gravity_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Standard gravity in game for the player is -16 (though I think grenades use -9.8)

Setting a value closer to 0 will make the player more floaty.  Stonger values are good for high speed modes]]

    return retVal
end
function this.Define_Gravity_Value(const)
    -- Slider
    return
    {
        invisible_name = "Mode_Accel_Gravity_Value",

        min = 0,
        max = 1,

        get_custom_text = function(val) return this.Value_FromSlider_Display(val, curve_gravity_fromslider) end,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 180,
            pos_y = 150,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Gravity_Value(def, accel)
    --NOTE: ActivateWindow_Mode_Accel sets this to nil
    if not def.value then
        --NOTE: Evaluate caps to min/max
        def.value = curve_gravity_toslider:Evaluate(accel.gravity)
    end
end

function this.Refresh_IsDirty(def, mode, const, def_vert_value, def_vertdash_value, def_horz_value, def_horzdash_value, def_initial_checkbox, def_initial_value, def_gravity_value)
    local accel = mode.accel

    local isDirty = false

    if def_initial_checkbox.isChecked then
        if not accel.vert_initial or not IsNearValue_custom(accel.vert_initial, curve_vert_fromslider:Evaluate(def_initial_value.value), const.ui_dirty_epsilon) then
            isDirty = true
        end
    else
        if accel.vert_initial then
            isDirty = true
        end
    end

    local gravity = curve_gravity_fromslider:Evaluate(def_gravity_value.value)

    if not isDirty then
        if not IsNearValue_custom(accel.horz_stand, curve_horz_fromslider:Evaluate(def_horz_value.value), const.ui_dirty_epsilon) then
            isDirty = true

        elseif not IsNearValue_custom(accel.horz_dash, curve_horz_fromslider:Evaluate(def_horzdash_value.value), const.ui_dirty_epsilon) then
            isDirty = true

        elseif not IsNearValue_custom(accel.gravity, gravity, const.ui_dirty_epsilon) then
            isDirty = true
        end
    end

    if not isDirty then
        local mode_val = curve_vert_fromslider:Evaluate(def_vert_value.value)
        mode_val = mode_defaults.ImpulseGravityAdjust_ToMode(mode.useImpulse, gravity, mode_val)

        if not IsNearValue_custom(accel.vert_stand, mode_val, const.ui_dirty_epsilon) then
            isDirty = true
        end
    end

    if not isDirty then
        local mode_val = curve_vert_fromslider:Evaluate(def_vertdash_value.value)
        mode_val = mode_defaults.ImpulseGravityAdjust_ToMode(mode.useImpulse, gravity, mode_val)

        if not IsNearValue_custom(accel.vert_dash, mode_val, const.ui_dirty_epsilon) then
            isDirty = true
        end
    end

    def.isDirty = isDirty
end

function this.Save(player, mode, mode_index, def_vert_value, def_vertdash_value, def_horz_value, def_horzdash_value, def_initial_checkbox, def_initial_value, def_gravity_value)
    local accel = mode.accel

    if def_initial_checkbox.isChecked then
        accel.vert_initial = curve_vert_fromslider:Evaluate(def_initial_value.value)
    else
        accel.vert_initial = nil
    end

    accel.horz_stand = curve_horz_fromslider:Evaluate(def_horz_value.value)
    accel.horz_dash = curve_horz_fromslider:Evaluate(def_horzdash_value.value)
    accel.gravity = curve_gravity_fromslider:Evaluate(def_gravity_value.value)

    local mode_val = curve_vert_fromslider:Evaluate(def_vert_value.value)
    accel.vert_stand = mode_defaults.ImpulseGravityAdjust_ToMode(mode.useImpulse, accel.gravity, mode_val)

    mode_val = curve_vert_fromslider:Evaluate(def_vertdash_value.value)
    accel.vert_dash = mode_defaults.ImpulseGravityAdjust_ToMode(mode.useImpulse, accel.gravity, mode_val)

    player:SaveUpdatedMode(mode, mode_index)
end

---------------------------------------------------------------------------------------

function this.Value_FromSlider_Display(value, curve)
    local result = curve:Evaluate(value)

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

function this.EnsureCurvesPopulated()
    if curve_vert_fromslider then
        do return end
    end

    -- Vertical
    curve_vert_fromslider = AnimationCurve:new()
    curve_vert_fromslider:AddKeyValue(0, 0)
    curve_vert_fromslider:AddKeyValue(0.5, 2)
    curve_vert_fromslider:AddKeyValue(0.75, 8)
    curve_vert_fromslider:AddKeyValue(1, 24)

    curve_vert_toslider = AnimationCurve:new()
    curve_vert_toslider:AddKeyValue(0, 0)
    curve_vert_toslider:AddKeyValue(2, 0.5)
    curve_vert_toslider:AddKeyValue(8, 0.75)
    curve_vert_toslider:AddKeyValue(24, 1)

    -- Horizontal
    curve_horz_fromslider = AnimationCurve:new()
    curve_horz_fromslider:AddKeyValue(0, 0)
    curve_horz_fromslider:AddKeyValue(0.5, 4)
    curve_horz_fromslider:AddKeyValue(0.66, 8)
    curve_horz_fromslider:AddKeyValue(0.85, 30)
    curve_horz_fromslider:AddKeyValue(1, 80)

    curve_horz_toslider = AnimationCurve:new()
    curve_horz_toslider:AddKeyValue(0, 0)
    curve_horz_toslider:AddKeyValue(4, 0.5)
    curve_horz_toslider:AddKeyValue(8, 0.66)
    curve_horz_toslider:AddKeyValue(30, 0.85)
    curve_horz_toslider:AddKeyValue(80, 1)

    -- Initial
    curve_initial_fromslider = AnimationCurve:new()
    curve_initial_fromslider:AddKeyValue(0, 0)
    curve_initial_fromslider:AddKeyValue(0.5, 3)
    curve_initial_fromslider:AddKeyValue(0.85, 12)
    curve_initial_fromslider:AddKeyValue(1, 24)

    curve_initial_toslider = AnimationCurve:new()
    curve_initial_toslider:AddKeyValue(0, 0)
    curve_initial_toslider:AddKeyValue(3, 0.5)
    curve_initial_toslider:AddKeyValue(12, 0.85)
    curve_initial_toslider:AddKeyValue(24, 1)

    -- Gravity
    curve_gravity_fromslider = AnimationCurve:new()
    curve_gravity_fromslider:AddKeyValue(0, 0)
    curve_gravity_fromslider:AddKeyValue(0.7, -16)
    curve_gravity_fromslider:AddKeyValue(0.85, -24)
    curve_gravity_fromslider:AddKeyValue(1, -40)

    curve_gravity_toslider = AnimationCurve:new()
    curve_gravity_toslider:AddKeyValue(0, 0)
    curve_gravity_toslider:AddKeyValue(-16, 0.7)
    curve_gravity_toslider:AddKeyValue(-24, 0.85)
    curve_gravity_toslider:AddKeyValue(-40, 1)
end