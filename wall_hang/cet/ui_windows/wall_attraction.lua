local this = {}

function DefineWindow_WallAttraction(vars_ui, const)
    local wall_attraction = {}
    vars_ui.wall_attraction = wall_attraction

    wall_attraction.changes = Changes:new()

    wall_attraction.title = Define_Title("Wall Attraction", const)
    wall_attraction.title_help = this.Define_Title_Help(wall_attraction.title, const)

    -- player_arcade.wallDistance_attract_max
    wall_attraction.max_dist = this.Define_MaxDist(const)
    wall_attraction.max_dist_label = this.Define_MaxDist_Label(wall_attraction.max_dist, const)
    wall_attraction.max_dist_help = this.Define_MaxDist_Help(wall_attraction.max_dist_label, const)

    -- player_arcade.attract_accel
    wall_attraction.accel = this.Define_Accel(wall_attraction.max_dist, const)
    wall_attraction.accel_label = this.Define_Accel_Label(wall_attraction.accel, const)
    wall_attraction.accel_help = this.Define_Accel_Help(wall_attraction.accel_label, const)

    -- player_arcade.attract_pow
    --TODO: Draw a graph
    wall_attraction.pow = this.Define_Pow(wall_attraction.accel, const)
    wall_attraction.pow_label = this.Define_Pow_Label(wall_attraction.pow, const)
    wall_attraction.pow_help = this.Define_Pow_Help(wall_attraction.pow_label, const)

    -- player_arcade.attract_antigrav
    wall_attraction.antigrav = this.Define_AntiGrav(wall_attraction.pow, const)
    wall_attraction.antigrav_label = this.Define_AntiGrav_Label(wall_attraction.antigrav, const)
    wall_attraction.antigrav_help = this.Define_AntiGrav_Help(wall_attraction.antigrav_label, const)

    wall_attraction.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(wall_attraction)
end

function ActivateWindow_WallAttraction(vars_ui, const)
    if not vars_ui.wall_attraction then
        DefineWindow_WallAttraction(vars_ui, const)
    end

    vars_ui.wall_attraction.changes:Clear()

    vars_ui.wall_attraction.max_dist.value = nil
    vars_ui.wall_attraction.accel.value = nil
    vars_ui.wall_attraction.pow.value = nil
    vars_ui.wall_attraction.antigrav.value = nil
end

function DrawWindow_WallAttraction(isCloseRequested, vars_ui, window, const, player, player_arcade)
    local wall_attraction = vars_ui.wall_attraction

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_MaxDist(wall_attraction.max_dist, player_arcade)

    this.Refresh_Accel(wall_attraction.accel, player_arcade)

    this.Refresh_Pow(wall_attraction.pow, player_arcade)

    this.Refresh_AntiGrav(wall_attraction.antigrav, player_arcade)

    this.Refresh_IsDirty(wall_attraction.okcancel, player_arcade, wall_attraction.max_dist, wall_attraction.accel, wall_attraction.pow, wall_attraction.antigrav)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(wall_attraction.render_nodes, vars_ui.style, const, vars_ui.line_heights)
    CalculatePositions(wall_attraction.render_nodes, window.width, window.height, const, vars_ui.em)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(wall_attraction.title, vars_ui.style.colors, vars_ui.em)
    Draw_HelpButton(wall_attraction.title_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    Draw_Label(wall_attraction.max_dist_label, vars_ui.style.colors, vars_ui.em)
    Draw_HelpButton(wall_attraction.max_dist_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(wall_attraction.max_dist, vars_ui.style.slider, vars_ui.em)

    Draw_Label(wall_attraction.accel_label, vars_ui.style.colors, vars_ui.em)
    Draw_HelpButton(wall_attraction.accel_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(wall_attraction.accel, vars_ui.style.slider, vars_ui.em)

    Draw_Label(wall_attraction.pow_label, vars_ui.style.colors, vars_ui.em)
    Draw_HelpButton(wall_attraction.pow_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(wall_attraction.pow, vars_ui.style.slider, vars_ui.em)

    Draw_Label(wall_attraction.antigrav_label, vars_ui.style.colors, vars_ui.em)
    Draw_HelpButton(wall_attraction.antigrav_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)
    Draw_Slider(wall_attraction.antigrav, vars_ui.style.slider, vars_ui.em)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(wall_attraction.okcancel, vars_ui.style.okcancelButtons, vars_ui.em)
    if isOKClicked then
        this.Save(player, player_arcade, wall_attraction.max_dist, wall_attraction.accel, wall_attraction.pow, wall_attraction.antigrav)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not wall_attraction.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Title_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "WallAttraction_Title_Help",

        position = GetRelativePosition_HelpButton(relative_to, const),

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This is an acceleration that pulls you toward a wall when you are too far away to directly grab it

This activates when you are midair and are trying to grab a wall

You also need to be looking at the wall]]

    return retVal
end

function this.Define_MaxDist_Label(relative_to, const)
    -- Label
    return
    {
        text = "Max Distance",

        position =
        {
            relative_to = relative_to,

            pos_x = 24,
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
function this.Define_MaxDist_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "WallAttraction_MaxDist_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip = "How far from a wall the attraction acceleration reaches"

    return retVal
end
function this.Define_MaxDist(const)
    -- Slider
    return
    {
        invisible_name = "WallAttraction_MaxDist_Value",

        min = const.wallDistance_stick_max,
        max = 16,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 65,
            pos_y = -130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_MaxDist(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.wallDistance_attract_max
    end
end

function this.Define_Accel_Label(relative_to, const)
    -- Label
    return
    {
        text = "Acceleration",

        position =
        {
            relative_to = relative_to,

            pos_x = 24,
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
function this.Define_Accel_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "WallAttraction_Accel_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[How strong the acceleration toward a wall is]]

    return retVal
end
function this.Define_Accel(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "WallAttraction_Accel_Value",

        min = 4,
        max = 24,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 72,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Accel(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.attract_accel
    end
end

function this.Define_Pow_Label(relative_to, const)
    -- Label
    return
    {
        text = "Accel Curve Power",

        position =
        {
            relative_to = relative_to,

            pos_x = 24,
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
function this.Define_Pow_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "WallAttraction_Pow_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[There is a gradient that is full acceleration at grabbing distance and zero acceleration at max distance

The equation of that percent is 1-x^pow (x is from 0 to 1)

If the power is 1, then the gradient is linear
    
The graph stays near 1 longer the larger the power]]

    return retVal
end
function this.Define_Pow(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "WallAttraction_Pow_Value",

        min = 1,
        max = 12,

        is_dozenal = true,
        decimal_places = 1,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

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

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_Pow(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.attract_pow
    end
end

function this.Define_AntiGrav_Label(relative_to, const)
    -- Label
    return
    {
        text = "Anti Gravity",

        position =
        {
            relative_to = relative_to,

            pos_x = 24,
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
function this.Define_AntiGrav_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        invisible_name = "WallAttraction_AntiGrav_Help",

        position =
        {
            relative_to = relative_to,

            pos_x = 11,
            pos_y = 0,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[0 would be full gravity

1 is weightless

Larger than 1 will cause the player to float up]]

    return retVal
end
function this.Define_AntiGrav(relative_to, const)
    -- Slider
    return
    {
        invisible_name = "WallAttraction_AntiGrav_Value",

        min = 0,
        max = 1.5,

        is_dozenal = true,
        decimal_places = 2,

        width = 250,

        ctrlclickhint_horizontal = const.alignment_horizontal.right,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 72,

            relative_horz = const.alignment_horizontal.left,
            horizontal = const.alignment_horizontal.left,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_AntiGrav(def, player_arcade)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        def.value = player_arcade.attract_antigrav
    end
end

function this.Refresh_IsDirty(def, player_arcade, max_dist, accel, pow, antigrav)
    local isDirty = false

    if not IsNearValue(max_dist.value, player_arcade.wallDistance_attract_max) then
        isDirty = true

    elseif not IsNearValue(accel.value, player_arcade.attract_accel) then
        isDirty = true

    elseif not IsNearValue(pow.value, player_arcade.attract_pow) then
        isDirty = true

    elseif not IsNearValue(antigrav.value, player_arcade.attract_antigrav) then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, player_arcade, max_dist, accel, pow, antigrav)
    player_arcade.wallDistance_attract_max = max_dist.value
    player_arcade.attract_accel = accel.value
    player_arcade.attract_pow = pow.value
    player_arcade.attract_antigrav = antigrav.value

    player_arcade:Save()
    player:Reset()
end