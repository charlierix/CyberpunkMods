function Define_Title(title, const)
    -- Label
    return
    {
        text = title,

        position =
        {
            pos_x = 24,
            pos_y = 24,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.top,
        },

        color = "title",
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
    }
end

function Define_Experience(const, used_prompt)
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
            pos_y = 36,
            horizontal = const.alignment_horizontal.left,
            vertical = const.alignment_vertical.bottom,
        },

        gap = 12,

        color_prompt = "experience_prompt",
        color_value = "experience_value",
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

        width = 48,
        height = 86,

        position =
        {
            pos_x = -345,
            pos_y = -70,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }
end

function Define_GrappleArrows(isStandardColor, const)
    -- GrappleArrows
    return
    {
        isStandardColor = isStandardColor,

        showLook = false,
        isHighlight_primary = false,
        isHighlight_look = false,

        --NOTE: These positions are relative to center
        primary_from_x = -300,
        primary_from_y = -70,

        primary_to_x = 360,
        primary_to_y = -70,

        look_from_x = -310,
        look_from_y = -110,

        look_to_x = 40,
        look_to_y = -240,
    }
end
function Refresh_Arrows(def, grapple, forceShowLook, highlight_primary, highlight_look)
    if forceShowLook then
        def.showLook = true
    else
        def.showLook = grapple.accel_alongLook ~= nil
    end

    def.isHighlight_primary = highlight_primary
    def.isHighlight_look = highlight_look
end

function Refresh_UpDownButton(def, down, up)
    --TODO: May want a significant digits function, only show one or two significant digits

    -- Down
    def.value_down = down

    if down then
        def.text_down = tostring(down)
        def.isEnabled_down = true
    else
        def.text_down = ""
        def.isEnabled_down = false
    end

    -- Up
    def.value_up = up

    if up then
        def.text_up = tostring(up)
        def.isEnabled_up = true
    else
        def.text_up = ""
        def.isEnabled_up = false
    end
end

-- This creates a set of controls used to change a single property
-- x and y are an offset from center
-- Returns:
--  label property name
--  label property value
--  updown buttons
--  help button
function Define_PropertyPack_Vertical(text, x, y, const)
    -- Probably can't use this outside of a draw function.  Just hardcode the offsets
    --local size_text_x, size_text_y = ImGui.CalcTextSize(text)

    -- Label
    local label_prompt =
    {
        text = text,

        position =
        {
            pos_x = x,
            pos_y = y - 24,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        color = "edit_prompt",
    }

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
    }

    -- UpDownButtons
    local updown =
    {
        isEnabled_down = true,
        isEnabled_up = true,

        position =
        {
            pos_x = x,
            pos_y = y + 32,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        isHorizontal = true,
    }

    -- HelpButton
    local help =
    {
        position =
        {
            pos_x = x + 66,
            pos_y = y - 23,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },

        invisible_name = "EnergyTank_Help" .. text
    }

    return label_prompt, label_value, updown, help
end