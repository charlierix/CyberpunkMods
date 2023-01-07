local this = {}

-- These are helper methods dealing with laying out controls

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
function GetRelativePosition_HelpButton(relative_to, const)
    return
    {
        relative_to = relative_to,

        pos_x = 10,
        pos_y = 0,

        relative_horz = const.alignment_horizontal.right,
        horizontal = const.alignment_horizontal.left,

        relative_vert = const.alignment_vertical.center,
        vertical = const.alignment_vertical.center,
    }
end
-- This is for labels/checkboxes above something (like slider, textbox)
function GetRelativePosition_LabelAbove(relative_to, const)
    return
    {
        relative_to = relative_to,

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