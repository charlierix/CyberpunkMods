function Define_Experience(const, used_prompt, y_offset)
    if not y_offset then
        y_offset = 0
    end

    -- OrderedList
    local retVal =
    {
        content =
        {
            available = { prompt = "Experience Available" },
        },

        position =
        {
            pos_x = 36,
            pos_y = 36 + y_offset,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        gap = 12,

        color_prompt = "experience_prompt",
        color_value = "experience_value",

        CalcSize = CalcSize_OrderedList,
    }

    if used_prompt then
        retVal.content.used = { prompt = "Spent on " .. used_prompt }
    end

    return retVal
end

function Define_StickFigure(isStandardColor, const)
    -- StickFigure
    return
    {
        isStandardColor = isStandardColor,
        isHighlight = false,

        width = 36,
        height = 64,

        position =
        {
            pos_x = -325,
            pos_y = -105,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        CalcSize = CalcSize_StickFigure,
    }
end
function Refresh_StickFigure(def, shouldHighlight)
    def.isHighlight = shouldHighlight
end

function Define_GrappleArrows(isStandardColor_primary, isStandardColor_look)
    -- GrappleArrows
    return
    {
        isStandardColor_primary = isStandardColor_primary,
        isStandardColor_look = isStandardColor_look,

        showLook = false,
        isHighlight_primary = false,
        isHighlight_look = false,

        --NOTE: These positions are relative to center

        --NOTE: If these values change, the values need to be copied to other controls (desired length)
        primary_from_x = -280,
        primary_to_x = -10,
        primary_y = -105,

        look_from_x = -290,
        look_from_y = -145,

        look_to_x = -200,
        look_to_y = -215,
    }
end
function Refresh_GrappleArrows(def, grapple, forceShowLook, highlight_primary, highlight_look)
    if forceShowLook then
        def.showLook = true
    else
        def.showLook = grapple.accel_alongLook ~= nil or grapple.aim_straight.air_dash ~= nil
    end

    def.isHighlight_primary = highlight_primary
    def.isHighlight_look = highlight_look
end

function Define_GrappleDesiredLength(isStandardColor)
    -- GrappleDesiredLength
    return
    {
        isStandardColor = isStandardColor,
        isHighlight = false,
        should_show = false,

        height = 36,

        --NOTE: These values are copied from Define_GrappleArrows
        from_x = -280,
        to_x = -10,
        y = -105,
    }
end
function Refresh_GrappleDesiredLength(def, grapple, changed_length, changes, shouldHighlight)
    -- Changes will only be passed in if the window modifies desired length
    local desired_length = nil
    if changed_length then
        desired_length = changed_length
    else
        desired_length = grapple.desired_length
    end

    -- See if/where to show it
    if desired_length then
        def.should_show = true
        def.percent = desired_length / (grapple.aim_straight.max_distance + changes:Get("max_distance"))
    else
        def.should_show = false
    end

    def.isHighlight = shouldHighlight
end

function Define_GrappleAccelToDesired(isStandardColor_accel, isStandardColor_dead)
    -- GrappleAccelToDesired
    return
    {
        isStandardColor_accel = isStandardColor_accel,
        isStandardColor_dead = isStandardColor_dead,

        show_accel_left = false,
        show_accel_right = false,
        show_dead = false,

        isHighlight_accel_left = false,
        isHighlight_accel_right = false,
        isHighlight_dead = false,

        yOffset_accel = -18,
        yOffset_dead = 18,

        length_accel = 60,
        length_dead = 48,       -- this one should be calculated in refresh

        length_accel_halfgap = 6,
        deadHeight = 9,

        --NOTE: These values are copied from Define_GrappleArrows
        from_x = -280,
        to_x = -10,
        y = -105,
    }
end
function Refresh_GrappleAccelToDesired(def, grapple, accel, changed_deadspot, shouldHighlight_accel, shouldHighlight_dead)
    if grapple.desired_length then
        def.percent = grapple.desired_length / grapple.aim_straight.max_distance
    else
        def.percent = 1
    end

    local deadSpot = 0
    if changed_deadspot then
        deadSpot = changed_deadspot
    else
        deadSpot = accel.deadSpot_distance
    end

    -- Scale drawn deadspot relative to the aim distance
    def.length_dead = GetScaledValue(0, def.to_x - def.from_x, 0, grapple.aim_straight.max_distance, deadSpot)

    def.show_accel_left = true       -- ConstantAccel's min accel is non zero, so there's no point in taking in an optional changed accel (it will always be true)
    def.show_accel_right = true
    def.show_dead = not IsNearZero(deadSpot)

    def.isHighlight_accel_left = shouldHighlight_accel
    def.isHighlight_accel_right = shouldHighlight_accel
    def.isHighlight_dead = shouldHighlight_dead
end