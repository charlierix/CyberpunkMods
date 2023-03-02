local this = {}

local isHovered_stopAngle_checkbox = false
local isHovered_stopdistance_checkbox = false
local isHovered_stopdistance_slider = false
local isHovered_stopplane_checkbox = false
local isHovered_stopplane_slider = false
local isHovered_stopOnWallHit_checkbox = false

function DefineWindow_GrappleStraight_StopEarly(vars_ui, const)
    local gst8_stop = {}
    vars_ui.gst8_stop = gst8_stop

    gst8_stop.changes = Changes:new()

    gst8_stop.title = Define_Title("Grapple Straight - Stop Early", const)

    gst8_stop.name = Define_Name(const)

    gst8_stop.stickFigure = Define_StickFigure(true, const)
    gst8_stop.arrows = Define_GrappleArrows(false, false)
    gst8_stop.desired_line = Define_GrappleDesiredLength(false)
    gst8_stop.desired_extra = this.Define_GrappleAccelToDesired_Custom()

    -- Stop Angle (Grapple.minDot)
    gst8_stop.has_stopAngle = this.Define_HasStopAngle(const)
    gst8_stop.stopAngle_help = this.Define_StopAngle_Help(gst8_stop.has_stopAngle, const)
    gst8_stop.stopAngle_value = this.Define_StopAngle_Value(const)
    gst8_stop.stopAngle_graphic = this.Define_StopAngle_Graphic(const)

    -- Stop Distance (Grapple.stop_distance)
    gst8_stop.has_stopDistance = this.Define_HasStopDistance(const)
    gst8_stop.stopDistance_help = this.Define_StopDistance_Help(gst8_stop.has_stopDistance, const)
    gst8_stop.stopDistance_value = this.Define_StopDistance_Value(const)

    -- Stop Plane (Grapple.stop_plane_distance)
    gst8_stop.has_stopPlane = this.Define_HasStopPlane(const)
    gst8_stop.stopPlane_help = this.Define_StopPlane_Help(gst8_stop.has_stopPlane, const)
    gst8_stop.stopPlane_value = this.Define_StopPlane_Value(const)

    -- Stop on wall hit (Grapple.stop_on_wallHit)
    gst8_stop.should_stopOnWallHit = this.Define_ShouldStopOnWallHit(const)
    gst8_stop.stopOnWallHit_help = this.Define_StopOnWallHit_Help(gst8_stop.should_stopOnWallHit, const)

    gst8_stop.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(gst8_stop)
end

function ActivateWindow_GrappleStraight_StopEarly(vars_ui, const)
    if not vars_ui.gst8_stop then
        DefineWindow_GrappleStraight_StopEarly(vars_ui, const)
    end

    vars_ui.gst8_stop.changes:Clear()

    vars_ui.gst8_stop.has_stopDistance.isChecked = nil
    vars_ui.gst8_stop.stopDistance_value.value = nil

    vars_ui.gst8_stop.has_stopPlane.isChecked = nil
    vars_ui.gst8_stop.stopPlane_value.value = nil

    vars_ui.gst8_stop.should_stopOnWallHit.isChecked = nil

    vars_ui.gst8_stop.has_stopAngle.isChecked = nil
    vars_ui.gst8_stop.stopAngle_value.value = nil
end

function DrawWindow_GrappleStraight_StopEarly(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        LogError("DrawWindow_GrappleStraight_StopEarly: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local gst8_stop = vars_ui.gst8_stop

    local changes = gst8_stop.changes

    ------------------------- Finalize models for this frame -------------------------

    Refresh_Name(gst8_stop.name, grapple.name)

    Refresh_StickFigure(gst8_stop.stickFigure, isHovered_stopAngle_checkbox or isHovered_stopOnWallHit_checkbox)
    Refresh_GrappleArrows(gst8_stop.arrows, grapple, false, false, false)
    Refresh_GrappleDesiredLength(gst8_stop.desired_line, grapple, nil, changes, false)
    this.Refresh_GrappleAccelToDesired_Custom(gst8_stop.desired_extra, grapple, gst8_stop.has_stopDistance, gst8_stop.stopDistance_value, gst8_stop.has_stopPlane, gst8_stop.stopPlane_value, isHovered_stopdistance_checkbox or isHovered_stopplane_checkbox or isHovered_stopdistance_slider or isHovered_stopplane_slider)

    this.Refresh_HasStopAngle(gst8_stop.has_stopAngle, grapple)
    this.Refresh_StopAngle_Value(gst8_stop.stopAngle_value, grapple)
    this.Refresh_StopAngle_Graphic(gst8_stop.stopAngle_graphic, gst8_stop.stopAngle_value)

    this.Refresh_HasStopDistance(gst8_stop.has_stopDistance, grapple)
    this.Refresh_StopDistance_Value(gst8_stop.stopDistance_value, grapple)

    this.Refresh_HasStopPlane(gst8_stop.has_stopPlane, grapple)
    this.Refresh_StopPlane_Value(gst8_stop.stopPlane_value, grapple)

    this.Refresh_ShouldStopOnWallHit(gst8_stop.should_stopOnWallHit, grapple)

    this.Refresh_IsDirty(gst8_stop.okcancel, grapple, gst8_stop)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(gst8_stop.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(gst8_stop.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(gst8_stop.title, vars_ui.style.colors, vars_ui.scale)

    Draw_Label(gst8_stop.name, vars_ui.style.colors, vars_ui.scale)

    Draw_StickFigure(gst8_stop.stickFigure, vars_ui.style.graphics, window.left, window.top, vars_ui.scale)
    Draw_GrappleArrows(gst8_stop.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height, vars_ui.scale)
    Draw_GrappleDesiredLength(gst8_stop.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height, vars_ui.scale)
    Draw_GrappleAccelToDesired(gst8_stop.desired_extra, vars_ui.style.graphics, window.left, window.top, window.width, window.height, vars_ui.scale)

    _, isHovered_stopAngle_checkbox = Draw_CheckBox(gst8_stop.has_stopAngle, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(gst8_stop.stopAngle_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    if gst8_stop.has_stopAngle.isChecked then
        Draw_Slider(gst8_stop.stopAngle_value, vars_ui.style.slider, vars_ui.scale)
        Draw_MinDotGraphic(gst8_stop.stopAngle_graphic, vars_ui.style.graphics, vars_ui.style.mindotGraphic, window.left, window.top, vars_ui.scale)
    end

    _, isHovered_stopdistance_checkbox = Draw_CheckBox(gst8_stop.has_stopDistance, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(gst8_stop.stopDistance_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    if gst8_stop.has_stopDistance.isChecked then
        _, isHovered_stopdistance_slider = Draw_Slider(gst8_stop.stopDistance_value, vars_ui.style.slider, vars_ui.scale)
    else
        isHovered_stopdistance_slider = false
    end

    _, isHovered_stopplane_checkbox = Draw_CheckBox(gst8_stop.has_stopPlane, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(gst8_stop.stopPlane_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    if gst8_stop.has_stopPlane.isChecked then
        _, isHovered_stopplane_slider = Draw_Slider(gst8_stop.stopPlane_value, vars_ui.style.slider, vars_ui.scale)
    else
        isHovered_stopplane_slider = false
    end

    _, isHovered_stopOnWallHit_checkbox = Draw_CheckBox(gst8_stop.should_stopOnWallHit, vars_ui.style.checkbox, vars_ui.style.colors)
    Draw_HelpButton(gst8_stop.stopOnWallHit_help, vars_ui.style.helpButton, window.left, window.top, vars_ui, const)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(gst8_stop.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, grapple, gst8_stop)
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)

    elseif isCancelClicked then
        TransitionWindows_Grapple(vars_ui, const, player, vars_ui.transition_info.grappleIndex)
    end

    return not (isCloseRequested and not gst8_stop.okcancel.isDirty)     -- returns if it should continue showing
end

----------------------------------- Private Methods -----------------------------------

function this.Define_GrappleAccelToDesired_Custom()
    -- GrappleAccelToDesired
    return
    {
        isStandardColor_accel = false,
        isStandardColor_dead = false,

        show_accel_left = false,
        show_accel_right = false,
        show_dead = true,

        isHighlight_accel_left = false,
        isHighlight_accel_right = false,
        isHighlight_dead = false,

        yOffset_accel = -18,
        yOffset_dead = 18,

        length_accel = 60,
        length_dead = 48,       -- this one should be calculated in refresh

        length_accel_halfgap = 6,
        deadHeight = 9,

        percent = 0,        -- it's always far right, since this is distance from anchor

        --NOTE: These values are copied from Define_GrappleArrows
        from_x = -300,
        to_x = 360,
        y = -70,
    }
end
function this.Refresh_GrappleAccelToDesired_Custom(def, grapple, def_checkbox_dist, def_slider_dist, def_checkbox_plane, def_slider_plane, shouldHighlight)
    if (not def_checkbox_dist.isChecked or not def_slider_dist.value) and (not def_checkbox_plane.isChecked or not def_slider_plane.value) then
        def.show_dead = false
        do return end
    end

    def.show_dead = true
    def.isStandardColor_dead = true
    def.isHighlight_dead = shouldHighlight

    local dist_dist = 0
    if def_checkbox_dist.isChecked and def_slider_dist.value then
        dist_dist = GetSliderValue(def_slider_dist)
    end

    local dist_plane = 0
    if def_checkbox_plane.isChecked and def_slider_plane.value then
        dist_plane = GetSliderValue(def_slider_plane)
    end

    -- Scale drawn deadspot relative to the aim distance
    def.length_dead = GetScaledValue(0, def.to_x - def.from_x, 0, grapple.aim_straight.max_distance, math.max(dist_dist, dist_plane))
end

-- StopAngle
function this.Define_HasStopAngle(const)
    -- CheckBox
    return
    {
        invisible_name = "GrappleStraight_StopEarly_HasStopAngle",

        text = "Look Away",

        isEnabled = true,

        position =
        {
            pos_x = -220,
            pos_y = 40,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_HasStopAngle(def, grapple)
    --NOTE: TransitionWindows_Straight_StopEarly sets this to nil
    if def.isChecked == nil then
        def.isChecked = grapple.minDot ~= nil
    end
end

function this.Define_StopAngle_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "GrappleStraight_StopEarly_StopAngle_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This will auto disengage the grapple if you look too far away from the anchor point

For pull style grapples, somewhere around 90 degrees is a good value.  If this is unchecked, or too large of an angle, then the grapple will snap the player back as they crest a ledge

For wall hanging, either unchecked or a very large angle would be best, giving the player greater flexibility when to stop the grapple]]

    return retVal
end

function this.Define_StopAngle_Value(const)
    -- Slider
    return
    {
        invisible_name = "GrappleStraight_StopEarly_StopAngle_Value",

        min = 0,
        max = 180,

        decimal_places = 0,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = -220,
            pos_y = 75,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_StopAngle_Value(def, grapple)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: Activate function sets this to nil
    if not def.value then
        if grapple.minDot then
            def.value = Dot_to_Angle(grapple.minDot)
        else
            def.value = 0
        end
    end
end

function this.Define_StopAngle_Graphic(const)
    -- MinDotGraphic
    return
    {
        radius = 90,

        position =
        {
            pos_x = -220,
            pos_y = 220,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_MinDotGraphic,
    }
end
function this.Refresh_StopAngle_Graphic(def, def_slider)
    def.radians = Degrees_to_Radians(def_slider.value)
end

-- StopDistance
function this.Define_HasStopDistance(const)
    -- CheckBox
    return
    {
        invisible_name = "GrappleStraight_StopEarly_HasStopDistance",

        text = "Too close to anchor",

        isEnabled = true,

        position =
        {
            pos_x = 220,
            pos_y = 30,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_HasStopDistance(def, grapple)
    --NOTE: TransitionWindows_Straight_StopEarly sets this to nil
    if def.isChecked == nil then
        def.isChecked = grapple.stop_distance ~= nil
    end
end

function this.Define_StopDistance_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "GrappleStraight_StopEarly_StopDistance_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Maybe use this if you want a distance shutoff instead of a look shutoff

Or to have no deadspot and a cutoff instead?]]

    return retVal
end

function this.Define_StopDistance_Value(const)
    -- Slider
    return
    {
        invisible_name = "GrappleStraight_StopEarly_StopDistance_Value",

        min = 0,
        max = 6,

        decimal_places = 1,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 220,
            pos_y = 65,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_StopDistance_Value(def, grapple)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: TransitionWindows_Straight_StopEarly sets this to nil
    if not def.value then
        if grapple.stop_distance then
            def.value = grapple.stop_distance
        else
            def.value = 0
        end
    end
end

-- StopPlane
function this.Define_HasStopPlane(const)
    -- CheckBox
    return
    {
        invisible_name = "GrappleStraight_StopEarly_HasStopPlane",

        text = "Pass thru plane",

        isEnabled = true,

        position =
        {
            pos_x = 220,
            pos_y = 110,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_HasStopPlane(def, grapple)
    --NOTE: TransitionWindows_Straight_StopEarly sets this to nil
    if def.isChecked == nil then
        def.isChecked = grapple.stop_plane_distance ~= nil
    end
end

function this.Define_StopPlane_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "GrappleStraight_StopEarly_StopPlane_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[This is useful for grapples meant to launch you into the air like a slingshot

It defines a plane at the anchor point, and the grapple will end when you pass through that plane]]

    return retVal
end

function this.Define_StopPlane_Value(const)
    -- Slider
    return
    {
        invisible_name = "GrappleStraight_StopEarly_StopPlane_Value",

        min = 0,
        max = 6,

        decimal_places = 1,

        width = 300,

        ctrlclickhint_horizontal = const.alignment_horizontal.left,
        ctrlclickhint_vertical = const.alignment_vertical.bottom,

        position =
        {
            pos_x = 220,
            pos_y = 145,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_Slider,
    }
end
function this.Refresh_StopPlane_Value(def, grapple)
    -- There is no need to store changes in the changes list.  Value is directly changed
    --NOTE: TransitionWindows_Straight_StopEarly sets this to nil
    if not def.value then
        if grapple.stop_plane_distance then
            def.value = grapple.stop_plane_distance
        else
            def.value = 0
        end
    end
end

-- WallHit
function this.Define_ShouldStopOnWallHit(const)
    -- CheckBox
    return
    {
        invisible_name = "GrappleStraight_StopEarly_ShouldStopOnWallHit",

        text = "Touch a wall",

        isEnabled = true,

        position =
        {
            pos_x = 0,
            pos_y = 240,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_CheckBox,
    }
end
function this.Refresh_ShouldStopOnWallHit(def, grapple)
    --NOTE: TransitionWindows_Straight_StopEarly sets this to nil
    if def.isChecked == nil then
        def.isChecked = grapple.stop_on_wallHit
    end
end

function this.Define_StopOnWallHit_Help(relative_to, const)
    -- HelpButton
    local retVal =
    {
        position = GetRelativePosition_HelpButton(relative_to, const),

        invisible_name = "GrappleStraight_StopEarly_StopOnWallHit_Help",

        CalcSize = CalcSize_HelpButton,
    }

    retVal.tooltip =
[[Might be useful for a pull style grapple]]

    return retVal
end

-- Saving
function this.Refresh_IsDirty(def, grapple, gst8_stop)
    -- Distance
    local isDirty_dist = false

    if gst8_stop.has_stopDistance.isChecked then
        if grapple.stop_distance then
            isDirty_dist = not IsNearValue(gst8_stop.stopDistance_value.value, grapple.stop_distance)
        else
            isDirty_dist = true
        end
    else
        isDirty_dist = grapple.stop_distance ~= nil
    end

    -- Plane
    local isDirty_plane = false

    if gst8_stop.has_stopPlane.isChecked then
        if grapple.stop_plane_distance then
            isDirty_plane = not IsNearValue(gst8_stop.stopPlane_value.value, grapple.stop_plane_distance)
        else
            isDirty_plane = true
        end
    else
        isDirty_plane = grapple.stop_plane_distance ~= nil
    end

    -- Wall Hit
    local isDirty_wall = gst8_stop.should_stopOnWallHit.isChecked ~= grapple.stop_on_wallHit

    -- Angle
    local isDirty_angle = false

    if gst8_stop.has_stopAngle.isChecked then
        if grapple.minDot then
            isDirty_angle = not IsNearValue(Angle_to_Dot(gst8_stop.stopAngle_value.value), grapple.minDot)
        else
            isDirty_angle = true
        end
    else
        isDirty_angle = grapple.minDot ~= nil
    end

    def.isDirty =
        isDirty_dist or
        isDirty_plane or
        isDirty_wall or
        isDirty_angle
end

function this.Save(player, grapple, gst8_stop)
    -- Distance
    if gst8_stop.has_stopDistance.isChecked then
        grapple.stop_distance = GetSliderValue(gst8_stop.stopDistance_value)
    else
        grapple.stop_distance = nil
    end

    -- Plane
    if gst8_stop.has_stopPlane.isChecked then
        grapple.stop_plane_distance = GetSliderValue(gst8_stop.stopPlane_value)
    else
        grapple.stop_plane_distance = nil
    end

    -- Wall Hit
    grapple.stop_on_wallHit = gst8_stop.should_stopOnWallHit.isChecked

    -- Angle
    if gst8_stop.has_stopAngle.isChecked then
        grapple.minDot = Angle_to_Dot(gst8_stop.stopAngle_value.value)
    else
        grapple.minDot = nil
    end

    player:Save()
end