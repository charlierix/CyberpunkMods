local this = {}

function DefineWindow_Grapple_Straight(vars_ui, const)

    --TODO: Tooltip panel on hover over buttons
    --TODO: mappin chooser

    local grapple_straight = {}
    vars_ui.grapple_straight = grapple_straight

    grapple_straight.changes = Changes:new()

    grapple_straight.title = Define_Title("Straight Grapple", const)

    grapple_straight.name = this.Define_Name(const)
    grapple_straight.description = this.Define_Description(const)

    grapple_straight.stickFigure = Define_StickFigure(false, const)
    grapple_straight.arrows = Define_GrappleArrows(false, false)
    grapple_straight.desired_line = Define_GrappleDesiredLength(false)

    grapple_straight.distances = this.Define_Distances(const)

    grapple_straight.accel_along = this.Define_AccelAlong(const)
    grapple_straight.accel_look = this.Define_AccelLook(const)

    grapple_straight.velocity_away = this.Define_VelocityAway(const)

    grapple_straight.aim_duration = this.Define_AimDuration(const)

    grapple_straight.air_dash = this.Define_AirDash(const)

    grapple_straight.anti_grav = this.Define_AntiGrav(const)

    grapple_straight.stop_early = this.Define_StopEarly(const)

    grapple_straight.experience = Define_Experience(const, "grapple")

    grapple_straight.okcancel = Define_OkCancelButtons(false, vars_ui, const)
end

local isHovered_distance = false
local isHovered_look = false
local isHovered_along = false
local isHovered_drag = false
local isHovered_airdash = false
local isHovered_antigrav = false

function DrawWindow_Grapple_Straight(vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        print("DrawWindow_Grapple_Straight: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local grapple_straight = vars_ui.grapple_straight

    ------------------------- Finalize models for this frame -------------------------
    this.Refresh_Name(grapple_straight.name, grapple)

    this.Refresh_Description(grapple_straight.description, grapple)

    local shouldHighlightAlong = isHovered_distance or isHovered_along or isHovered_drag
    Refresh_StickFigure(grapple_straight.stickFigure, isHovered_antigrav)
    Refresh_GrappleArrows(grapple_straight.arrows, grapple, true, shouldHighlightAlong, isHovered_look or isHovered_airdash)
    Refresh_GrappleDesiredLength(grapple_straight.desired_line, grapple, nil, grapple_straight.changes, shouldHighlightAlong)

    this.Refresh_Distances(grapple_straight.distances, grapple)

    this.Refresh_AccelAlong(grapple_straight.accel_along, grapple)

    this.Refresh_AccelLook(grapple_straight.accel_look, grapple)

    this.Refresh_VelocityAway(grapple_straight.velocity_away, grapple)

    this.Refresh_AimDuration(grapple_straight.aim_duration, grapple)

    this.Refresh_AirDash(grapple_straight.air_dash, grapple)

    this.Refresh_AntiGrav(grapple_straight.anti_grav, grapple)

    this.Refresh_StopEarly(grapple_straight.stop_early, grapple)

    this.Refresh_Experience(grapple_straight.experience, player, grapple)

    this.Refresh_IsDirty(grapple_straight.okcancel, grapple_straight.name, grapple)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(grapple_straight.title, vars_ui.style.colors, window.width, window.height, const)

    Draw_TextBox(grapple_straight.name, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.line_heights, window.width, window.height, const)
    if Draw_LabelClickable(grapple_straight.description, vars_ui.style.textbox, vars_ui.style.colors, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_Straight_Description(vars_ui, const)
    end

    Draw_StickFigure(grapple_straight.stickFigure, vars_ui.style.graphics, window.left, window.top, window.width, window.height, const)
    Draw_GrappleArrows(grapple_straight.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height)
    Draw_GrappleDesiredLength(grapple_straight.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height)

    local isClicked = nil
    isClicked, isHovered_distance = Draw_SummaryButton(grapple_straight.distances, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const)
    if isClicked then
        TransitionWindows_Straight_Distances(vars_ui, const)
    end

    isClicked, isHovered_along = Draw_SummaryButton(grapple_straight.accel_along, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const)
    if isClicked then
        print("TODO: Transition to accel_along")
    end

    isClicked, isHovered_look = Draw_SummaryButton(grapple_straight.accel_look, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const)
    if isClicked then
        print("TODO: Transition to accel_look")
    end

    isClicked, isHovered_drag = Draw_SummaryButton(grapple_straight.velocity_away, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const)
    if isClicked then
        print("TODO: Transition to velocity_away")
    end

    if Draw_SummaryButton(grapple_straight.aim_duration, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        TransitionWindows_Straight_AimDuration(vars_ui, const)
    end

    isClicked, isHovered_airdash = Draw_SummaryButton(grapple_straight.air_dash, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const)
    if isClicked then
        TransitionWindows_Straight_AirDash(vars_ui, const)
    end

    isClicked, isHovered_antigrav = Draw_SummaryButton(grapple_straight.anti_grav, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const)
    if isClicked then
        TransitionWindows_Straight_AntiGrav(vars_ui, const)
    end

    if Draw_SummaryButton(grapple_straight.stop_early, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, window.width, window.height, const) then
        print("TODO: Transition to stop_early")
    end

    Draw_OrderedList(grapple_straight.experience, vars_ui.style.colors, window.width, window.height, const, vars_ui.line_heights)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(grapple_straight.okcancel, vars_ui.style.okcancelButtons, window.width, window.height, const)
    if isOKClicked then
        this.Save(player, grapple, grapple_straight.name)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Define_Name(const)
    -- TextBox
    return
    {
        invisible_name = "Grapple_Straight_GrappleName",

        maxChars = 48,
        min_width = 120,
        --max_width = 240,

        isMultiLine = false,

        foreground_override = "subTitle",

        position =
        {
            pos_x = 30,
            pos_y = 30,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },
    }
end
function this.Refresh_Name(def, grapple)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: TransitionWindows_Grapple sets this to nil
    if not def.text then
        def.text = grapple.name
    end
end

function this.Define_Description(const)
    -- LabelClickable
    return
    {
        invisible_name = "Grapple_Straight_GrappleDescription",

        max_width = 360,

        position =
        {
            pos_x = 30,
            pos_y = 66,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },
    }
end
function this.Refresh_Description(def, grapple)
    if not def.text then
        def.text = grapple.description
    end
end

function this.Define_Distances(const)
    -- SummaryButton
    return
    {
        -- In the middle of the window
        position =
        {
            pos_x = 310,
            pos_y = -150,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Distances",

        content =
        {
            -- the content is presented as sorted by name
            a_aim = { prompt = "aim" },
            b_desired = { prompt = "desired" },
        },

        invisible_name = "Grapple_Straight_Distances",
    }
end
function this.Refresh_Distances(def, grapple)
    def.content.a_aim.value = tostring(Round(grapple.aim_straight.max_distance))

    if grapple.desired_length then
        def.content.b_desired.value = tostring(Round(grapple.desired_length, 1))
    else
        def.content.b_desired.value = nil
    end
end

function this.Define_AccelAlong(const)
    -- SummaryButton
    return
    {
        position =
        {
            -- pos_x = -100,
            -- pos_y = 10,
            pos_x = 70,
            pos_y = -150,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Accel Toward Anchor",

        content =
        {
            -- the content is presented as sorted by name
            a_accel = { prompt = "acceleration" },
            b_speed = { prompt = "max speed" },
        },

        invisible_name = "Grapple_Straight_AccelAlong",
    }
end
function this.Refresh_AccelAlong(def, grapple)
    if grapple.accel_alongGrappleLine then
        def.content.a_accel.value = tostring(Round(grapple.accel_alongGrappleLine.accel))
        def.content.b_speed.value = tostring(Round(grapple.accel_alongGrappleLine.speed))
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_AccelLook(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = -240,
            pos_y = -240,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Accel Look Direction",

        content =
        {
            -- the content is presented as sorted by name
            a_accel = { prompt = "acceleration" },
            b_speed = { prompt = "max speed" },
        },

        invisible_name = "Grapple_Straight_AccelLook",
    }
end
function this.Refresh_AccelLook(def, grapple)
    if grapple.accel_alongLook then
        def.content.a_accel.value = tostring(Round(grapple.accel_alongLook.accel))
        def.content.b_speed.value = tostring(Round(grapple.accel_alongLook.speed))
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_VelocityAway(const)
    -- SummaryButton
    return
    {
        position =
        {
            -- pos_x = 80,
            -- pos_y = 10,
            pos_x = 0,
            pos_y = 10,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Extra Drag",

        content =
        {
            -- the content is presented as sorted by name
            a_compression = { prompt = "compression" },
            b_tension = { prompt = "tension" },
        },

        invisible_name = "Grapple_Straight_VelocityAway",
    }
end
function this.Refresh_VelocityAway(def, grapple)
    local hasValue = false

    if grapple.velocity_away then
        if grapple.velocity_away.accel_compression then
            hasValue = true
            def.content.a_compression.value = tostring(Round(grapple.velocity_away.accel_compression))
        else
            def.content.a_compression.value = nil
        end

        if grapple.velocity_away then
            hasValue = true
            def.content.b_tension.value = tostring(Round(grapple.velocity_away.accel_tension))
        else
            def.content.b_tension.value = nil
        end
    end

    if hasValue then
        def.unused_text = nil
    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_AimDuration(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = -250,
            pos_y = 140,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Aim Seconds",

        invisible_name = "Grapple_Straight_AimDuration",
    }
end
function this.Refresh_AimDuration(def, grapple)
    def.header_value = tostring(Round(grapple.aim_straight.aim_duration, 2))
end

function this.Define_AirDash(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = -250,
            pos_y = 240,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Air Dash",

        content =
        {
            -- the content is presented as sorted by name
            a_accel = { prompt = "acceleration" },
            b_speed = { prompt = "max speed" },
            c_burnRate = { prompt = "energy burn rate" },
        },

        invisible_name = "Grapple_Straight_AirDash",
    }
end
function this.Refresh_AirDash(def, grapple)
    local dash = grapple.aim_straight.air_dash

    if dash then
        def.content.a_accel.value = tostring(Round(dash.accel.accel))
        def.content.b_speed.value = tostring(Round(dash.accel.speed))
        def.content.c_burnRate.value = tostring(Round(dash.energyBurnRate * (1 - dash.burnReducePercent), 2))
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_AntiGrav(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = 0,
            pos_y = 190,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Anti Gravity",

        content =
        {
            -- the content is presented as sorted by name
            a_percent = { prompt = "percent" },
            b_fade = { prompt = "fade seconds" },
        },

        invisible_name = "Grapple_Straight_AntiGrav",
    }
end
function this.Refresh_AntiGrav(def, grapple)

    if grapple.anti_gravity then
        def.content.a_percent.value = tostring(Round(grapple.anti_gravity.antigrav_percent * 100)) .. "%"
        def.content.b_fade.value = tostring(Round(grapple.anti_gravity.fade_duration, 1))
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_StopEarly(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = 250,
            pos_y = 190,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Stop Early",

        content =
        {
            -- the content is presented as sorted by name
            a_minDot = { prompt = "look away angle" },
            b_distance = { prompt = "distance to desired" },
            c_wall = { prompt = "touch wall" },
        },

        invisible_name = "Grapple_Straight_StopEarly",
    }
end
function this.Refresh_StopEarly(def, grapple)
    if grapple.minDot then
        def.content.a_minDot.value = tostring(Round(Dot_to_Angle(grapple.minDot)))
    else
        def.content.a_minDot.value = nil
    end

    if grapple.stop_distance then
        def.content.b_distance.value = tostring(Round(grapple.stop_distance, 1))
    else
        def.content.b_distance.value = nil
    end

    if grapple.stop_on_wallHit then
        def.content.c_wall.value = " "      -- can't use "", because summary button looks for nil or empty string
    else
        def.content.c_wall.value = nil
    end
end

function this.Refresh_Experience(def, player, grapple)
    def.content.available.value = tostring(math.floor(player.experience))
    def.content.used.value = tostring(Round(grapple.experience))
end

function this.Refresh_IsDirty(def, def_name, grapple)
    local isDirty = false

    if def_name.text and def_name.text ~= grapple.name then
        isDirty = true
    end

    def.isDirty = isDirty
end

function this.Save(player, grapple, def_name)
    grapple.name = def_name.text

    player:Save()
end