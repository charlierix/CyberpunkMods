local this = {}

function Define_Title(title, const)
    -- Label
    return
    {
        text = title,

        position =
        {
            pos_x = 24,
            pos_y = 30,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.top,
        },

        color = "title",

        CalcSize = CalcSize_Label,
    }
end

--NOTE: This is readonly.  If you want a textbox, you'll need to do it yourself
function Define_Name(const)
    -- Label
    return
    {
        text = "",

        position =
        {
            pos_x = 24,
            pos_y = 24,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.top,
        },

        color = "subTitle",

        CalcSize = CalcSize_Label,
    }
end
function Refresh_Name(def, name)
    def.text = name
end

function Define_OkCancelButtons(isMainPage, vars_ui, const)
    return
    {
        isMainPage = isMainPage,
        isDirty = false,

        position =
        {
            pos_x = vars_ui.style.okcancelButtons.pos_x,
            pos_y = vars_ui.style.okcancelButtons.pos_y,
            horizontal = const.alignment_horizontal.right,
            vertical = const.alignment_vertical.bottom,
        },

        CalcSize = CalcSize_OkCancelButtons,
    }
end

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

        width = 48,
        height = 86,

        position =
        {
            pos_x = -345,
            pos_y = -70,
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
        primary_from_x = -300,
        primary_to_x = 360,
        primary_y = -70,

        look_from_x = -310,
        look_from_y = -110,

        look_to_x = 40,
        look_to_y = -240,
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
        from_x = -300,
        to_x = 360,
        y = -70,
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
        from_x = -300,
        to_x = 360,
        y = -70,
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

function Refresh_UpDownButton(def, down, up, isFree_down, isFree_up, roundDigits, display_mult)
    --TODO: May want a significant digits function, only show one or two significant digits

    -- Down
    def.value_down = down

    if down then
        def.text_down = this.GetDisplayString(down, roundDigits, display_mult)
        def.isEnabled_down = true
    else
        def.text_down = ""
        def.isEnabled_down = false
    end

    def.isFree_down = isFree_down

    -- Up
    def.value_up = up

    if up then
        def.text_up = this.GetDisplayString(up, roundDigits, display_mult)
        def.isEnabled_up = true
    else
        def.text_up = ""
        def.isEnabled_up = false
    end

    def.isFree_up = isFree_up
end

-- This is for help buttons to the right of a label/checkbox
function GetRelativePosition_HelpButton(parent, const)
    return
    {
        relative_to = parent,

        pos_x = 10,
        pos_y = 0,

        relative_horz = const.alignment_horizontal.right,
        horizontal = const.alignment_horizontal.left,

        relative_vert = const.alignment_vertical.center,
        vertical = const.alignment_vertical.center,
    }
end
-- This is for labels/checkboxes above something (like slider, textbox)
function GetRelativePosition_LabelAbove(parent, const)
    return
    {
        relative_to = parent,

        pos_x = 1,
        pos_y = 13,

        relative_horz = const.alignment_horizontal.left,
        horizontal = const.alignment_horizontal.left,

        relative_vert = const.alignment_vertical.top,
        vertical = const.alignment_vertical.bottom,
    }
end

-- This creates a set of controls used to change a single property
-- x and y are an offset from center
-- Returns:
--  checkbox or label: property name
--  label: property value
--  updown buttons
--  help button
function Define_PropertyPack_Vertical(text, x, y, const, isCheckbox, invisibleName_base, help_tooltip_text)
    -- Probably can't use this outside of a draw function.  Just hardcode the offsets
    --local size_text_x, size_text_y = ImGui.CalcTextSize(text)

    --NOTE: Lable is absolute position, everything else is relative to it
    -- Label
    local label_value =
    {
        --text = ,      -- will be populated during refresh

        position =
        {
            pos_x = x,
            pos_y = y,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_value",

        CalcSize = CalcSize_Label,
    }

    local prompt
    if isCheckbox then
        -- CheckBox
        prompt =
        {
            invisible_name = invisibleName_base .. "_CheckBox",

            text = text,

            position =
            {
                relative_to = label_value,

                pos_x = 0,
                pos_y = 11,

                relative_horz = const.alignment_horizontal.center,
                horizontal = const.alignment_horizontal.center,

                relative_vert = const.alignment_vertical.top,
                vertical = const.alignment_vertical.bottom,
            },

            foreground_override = "edit_prompt",

            CalcSize = CalcSize_CheckBox,
        }
    else
        -- Label
        prompt =
        {
            text = text,

            position =
            {
                relative_to = label_value,

                pos_x = 0,
                pos_y = 11,

                relative_horz = const.alignment_horizontal.center,
                horizontal = const.alignment_horizontal.center,

                relative_vert = const.alignment_vertical.top,
                vertical = const.alignment_vertical.bottom,
            },

            color = "edit_prompt",

            CalcSize = CalcSize_Label,
        }
    end

    -- UpDownButtons
    local updown =
    {
        invisible_name = invisibleName_base .. "_UpDown",

        isEnabled_down = true,
        isEnabled_up = true,

        position =
        {
            relative_to = label_value,

            pos_x = 0,
            pos_y = 15,

            relative_horz = const.alignment_horizontal.center,
            horizontal = const.alignment_horizontal.center,

            relative_vert = const.alignment_vertical.bottom,
            vertical = const.alignment_vertical.top,
        },

        isHorizontal = true,

        CalcSize = CalcSize_UpDownButtons,
    }

    -- HelpButton
    local help =
    {
        invisible_name = invisibleName_base .. "_Help",

        tooltip = help_tooltip_text,

        position = GetRelativePosition_HelpButton(prompt, const),

        CalcSize = CalcSize_HelpButton,
    }

    return prompt, label_value, updown, help
end

----------------------------------- Private Methods -----------------------------------

function this.GetDisplayString(value, roundDigits, mult)
    local valMultiplied = value
    if mult then
        valMultiplied = valMultiplied * mult
    end

    if roundDigits then
        if roundDigits == 0 then
            return tostring(Round(valMultiplied))
        else
            return tostring(Round(valMultiplied, roundDigits))
        end
    else
        return tostring(valMultiplied)
    end
end