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

function Define_StickFigure(const)
    -- StickFigure
    return
    {
        width = 48,
        height = 86,

        position =
        {
            pos_x = -325,
            pos_y = -150,
            horizontal = const.alignment_horizontal.center,
            vertical = const.alignment_vertical.center,
        },
    }
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
