local this = {}

local isHovered_distance = false
local isHovered_look = false
local isHovered_along = false
local isHovered_drag = false
local isHovered_airanchor = false
--local isHovered_airdash = false
local isHovered_antigrav = false
local isHovered_stopEarly = false

function DefineWindow_Grapple_Straight(vars_ui, const)
    local grapple_straight = {}
    vars_ui.grapple_straight = grapple_straight

    grapple_straight.changes = Changes:new()

    grapple_straight.title = Define_Title("Straight Grapple", const)

    grapple_straight.name = this.Define_Name(const)
    grapple_straight.description = this.Define_Description(grapple_straight.name, const)

    grapple_straight.stickFigure = Define_StickFigure(false, const)
    grapple_straight.arrows = Define_GrappleArrows(false, false)
    grapple_straight.desired_line = Define_GrappleDesiredLength(false)

    grapple_straight.distances = this.Define_Distances(const)

    grapple_straight.accel_along = this.Define_AccelAlong(const)
    grapple_straight.accel_look = this.Define_AccelLook(const)

    grapple_straight.velocity_away = this.Define_VelocityAway(const)

    grapple_straight.visuals = this.Define_Visuals(const)

    grapple_straight.aim_duration = this.Define_AimDuration(const)

    grapple_straight.air_anchor = this.Define_AirAnchor(const)

    --grapple_straight.air_dash = this.Define_AirDash(const)

    grapple_straight.anti_grav = this.Define_AntiGrav(const)

    grapple_straight.stop_early = this.Define_StopEarly(const)

    grapple_straight.experience = Define_Experience(const, "grapple")

    grapple_straight.okcancel = Define_OkCancelButtons(false, vars_ui, const)

    FinishDefiningWindow(grapple_straight)
end

function ActivateWindow_Grapple_Straight(vars_ui, const)
    if not vars_ui.grapple_straight then
        DefineWindow_Grapple_Straight(vars_ui, const)
    end

    vars_ui.grapple_straight.changes:Clear()

    vars_ui.grapple_straight.name.text = nil
    vars_ui.grapple_straight.description.text = nil
end

function DrawWindow_Grapple_Straight(isCloseRequested, vars_ui, player, window, const)
    local grapple = player:GetGrappleByIndex(vars_ui.transition_info.grappleIndex)
    if not grapple then
        LogError("DrawWindow_Grapple_Straight: grapple is nil")
        TransitionWindows_Main(vars_ui, const)
        do return end
    end

    local grapple_straight = vars_ui.grapple_straight

    local changes = grapple_straight.changes

    ------------------------- Finalize models for this frame -------------------------

    this.Refresh_Name(grapple_straight.name, grapple)

    this.Refresh_Description(grapple_straight.description, grapple)

    local shouldHighlightAlong = isHovered_distance or isHovered_along or isHovered_drag
    Refresh_StickFigure(grapple_straight.stickFigure, isHovered_antigrav or isHovered_stopEarly)
    Refresh_GrappleArrows(grapple_straight.arrows, grapple, true, shouldHighlightAlong or isHovered_airanchor, isHovered_look)
    Refresh_GrappleDesiredLength(grapple_straight.desired_line, grapple, nil, changes, shouldHighlightAlong)

    this.Refresh_Distances(grapple_straight.distances, grapple)

    this.Refresh_AccelAlong(grapple_straight.accel_along, grapple)

    this.Refresh_AccelLook(grapple_straight.accel_look, grapple)

    this.Refresh_VelocityAway(grapple_straight.velocity_away, grapple)

    this.Refresh_AimDuration(grapple_straight.aim_duration, grapple)

    this.Refresh_AirAnchor(grapple_straight.air_anchor, grapple)

    --this.Refresh_AirDash(grapple_straight.air_dash, grapple)

    this.Refresh_AntiGrav(grapple_straight.anti_grav, grapple)

    this.Refresh_StopEarly(grapple_straight.stop_early, grapple)

    this.Refresh_Experience(grapple_straight.experience, player, grapple)

    this.Refresh_IsDirty(grapple_straight.okcancel, grapple_straight.name, grapple)

    ------------------------------ Calculate Positions -------------------------------

    CalculateSizes(grapple_straight.render_nodes, vars_ui.style, const, vars_ui.line_heights, vars_ui.scale)
    CalculatePositions(grapple_straight.render_nodes, window.width, window.height, const, vars_ui.scale)

    -------------------------------- Show ui elements --------------------------------

    Draw_Label(grapple_straight.title, vars_ui.style.colors, vars_ui.scale)

    Draw_TextBox(grapple_straight.name, vars_ui.style.textbox, vars_ui.style.colors, vars_ui.scale)
    if Draw_LabelClickable(grapple_straight.description, vars_ui.style.textbox, vars_ui.style.colors, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Straight_Description(vars_ui, const)
    end

    Draw_StickFigure(grapple_straight.stickFigure, vars_ui.style.graphics, window.left, window.top, vars_ui.scale)
    Draw_GrappleArrows(grapple_straight.arrows, vars_ui.style.graphics, window.left, window.top, window.width, window.height, vars_ui.scale)
    Draw_GrappleDesiredLength(grapple_straight.desired_line, vars_ui.style.graphics, window.left, window.top, window.width, window.height, vars_ui.scale)

    local isClicked = nil
    isClicked, isHovered_distance = Draw_SummaryButton(grapple_straight.distances, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale)
    if isClicked then
        TransitionWindows_Straight_Distances(vars_ui, const)
    end

    isClicked, isHovered_along = Draw_SummaryButton(grapple_straight.accel_along, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale)
    if isClicked then
        TransitionWindows_Straight_AccelAlong(vars_ui, const)
    end

    isClicked, isHovered_look = Draw_SummaryButton(grapple_straight.accel_look, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale)
    if isClicked then
        TransitionWindows_Straight_AccelLook(vars_ui, const)
    end

    isClicked, isHovered_drag = Draw_SummaryButton(grapple_straight.velocity_away, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale)
    if isClicked then
        TransitionWindows_Straight_VelocityAway(vars_ui, const)
    end

    if Draw_SummaryButton(grapple_straight.visuals, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Visuals(vars_ui, const)
    end

    if Draw_SummaryButton(grapple_straight.aim_duration, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale) then
        TransitionWindows_Straight_AimDuration(vars_ui, const)
    end

    isClicked, isHovered_airanchor = Draw_SummaryButton(grapple_straight.air_anchor, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale)
    if isClicked then
        TransitionWindows_Straight_AirAnchor(vars_ui, const)
    end

    -- isClicked, isHovered_airdash = Draw_SummaryButton(grapple_straight.air_dash, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale)
    -- if isClicked then
    --     TransitionWindows_Straight_AirDash(vars_ui, const)
    -- end

    isClicked, isHovered_antigrav = Draw_SummaryButton(grapple_straight.anti_grav, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale)
    if isClicked then
        TransitionWindows_Straight_AntiGrav(vars_ui, const)
    end

    isClicked, isHovered_stopEarly = Draw_SummaryButton(grapple_straight.stop_early, vars_ui.line_heights, vars_ui.style.summaryButton, window.left, window.top, vars_ui.scale)
    if isClicked then
        TransitionWindows_Straight_StopEarly(vars_ui, const)
    end

    Draw_OrderedList(grapple_straight.experience, vars_ui.style.colors)

    local isOKClicked, isCancelClicked = Draw_OkCancelButtons(grapple_straight.okcancel, vars_ui.style.okcancelButtons, vars_ui.scale)
    if isOKClicked then
        this.Save(player, grapple, grapple_straight.name)
        TransitionWindows_Main(vars_ui, const)

    elseif isCancelClicked then
        TransitionWindows_Main(vars_ui, const)
    end

    return not (isCloseRequested and not grapple_straight.okcancel.isDirty)     -- returns if it should continue showing
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

        CalcSize = CalcSize_TextBox,
    }
end
function this.Refresh_Name(def, grapple)
    -- There is no need to store changes in the changes list.  Text is directly changed as they type
    --NOTE: ActivateWindow_Grapple_Straight sets this to nil
    if not def.text then
        def.text = grapple.name
    end
end

function this.Define_Description(relative_to, const)
    -- LabelClickable
    return
    {
        invisible_name = "Grapple_Straight_GrappleDescription",

        max_width = 320,

        position =
        {
            relative_to = relative_to,

            pos_x = 0,
            pos_y = 13,

            relative_horz = const.alignment_horizontal.right,
            horizontal = const.alignment_horizontal.right,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        CalcSize = CalcSize_LabelClickable,
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
            pos_x = 290,
            pos_y = -105,
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

        CalcSize = CalcSize_SummaryButton,
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
            pos_x = 120,
            pos_y = -105,
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

        CalcSize = CalcSize_SummaryButton,
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
            pos_x = -100,
            pos_y = -200,
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

        CalcSize = CalcSize_SummaryButton,
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
            pos_x = 0,
            pos_y = 60,
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

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_VelocityAway(def, grapple)
    if grapple.velocity_away then
        if grapple.velocity_away.accel_compression then
            def.content.a_compression.value = tostring(Round(grapple.velocity_away.accel_compression))
        else
            def.content.a_compression.value = nil
        end

        if grapple.velocity_away.accel_tension then
            def.content.b_tension.value = tostring(Round(grapple.velocity_away.accel_tension))
        else
            def.content.b_tension.value = nil
        end
    end

    if grapple.velocity_away then
        def.unused_text = nil
    else
        def.unused_text = def.header_prompt
    end
end

function this.Define_Visuals(const)
    -- SummaryButton
    return
    {
        header_prompt = "Visuals / Color",

        position =
        {
            pos_x = -250,
            pos_y = -15,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "Grapple_Straight_Visuals",

        CalcSize = CalcSize_SummaryButton,
    }
end

function this.Define_AimDuration(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = -250,
            pos_y = 70,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Aim Seconds",

        invisible_name = "Grapple_Straight_AimDuration",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_AimDuration(def, grapple)
    def.header_value = tostring(Round(grapple.aim_straight.aim_duration, 2))
end

function this.Define_AirAnchor(const)
    -- SummaryButton
    return
    {
        position =
        {
            pos_x = -250,
            pos_y = 155,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Air Anchor",

        content =
        {
            -- the content is presented as sorted by name
            a_cost = { prompt = "energy cost" },
            b_burnRate = { prompt = "energy burn rate" },
        },

        invisible_name = "Grapple_Straight_AirAnchor",

        CalcSize = CalcSize_SummaryButton,
    }
end
function this.Refresh_AirAnchor(def, grapple)
    local anchor = grapple.aim_straight.air_anchor

    if anchor then
        def.content.a_cost.value = tostring(Round(anchor.energyCost * (1 - anchor.energyCost_reduction_percent), 1))
        def.content.b_burnRate.value = tostring(Round(anchor.energyBurnRate * (1 - anchor.burnReducePercent), 2))
        def.unused_text = nil

    else
        def.unused_text = def.header_prompt
    end
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

        CalcSize = CalcSize_SummaryButton,
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
            pos_y = 200,
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

        CalcSize = CalcSize_SummaryButton,
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
            pos_x = 255,
            pos_y = 130,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        header_prompt = "Stop Early",

        content =
        {
            -- the content is presented as sorted by name
            a_minDot = { prompt = "look away angle" },
            b_distance = { prompt = "distance to desired" },
            c_plane = { prompt = "pass thru plane" },
            d_wall = { prompt = "touch wall" },
        },

        invisible_name = "Grapple_Straight_StopEarly",

        CalcSize = CalcSize_SummaryButton,
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

    if grapple.stop_plane_distance then
        def.content.c_plane.value = tostring(Round(grapple.stop_plane_distance, 1))
    else
        def.content.c_plane.value = nil
    end

    if grapple.stop_on_wallHit then
        def.content.d_wall.value = " "      -- can't use "", because summary button looks for nil or empty string
    else
        def.content.d_wall.value = nil
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