local this = {}

-- Shows a wordwrapped label that is made to look like a textbox, but acts like a button.  If the user
-- clicks this, a multiline textbox should be shown instead.  Multiline textbox doesn't support wordwrap,
-- so that textbox will need to be much larger to make it easier for the user to type what they want
-- def is models\viewmodels\LabelClickable
-- style_text is models\stylesheet\TextBox
-- style_colors is stylesheet.colors
-- Returns isClicked
function Draw_LabelClickable(def, style_text, style_colors, screenOffset_x, screenOffset_y, parent_width, parent_height, const)
	-- Calculate Size
	if not def.sizes then
        def.sizes = {}
    end

    this.Calculate_Sizes(def, style_text)

    -- Calculate Position
    local left, top = GetControlPosition(def.position, def.sizes.width, def.sizes.height, parent_width, parent_height, const)

    -- Invisible Button
    local isClicked, isHovered = Draw_InvisibleButton(def.name, left + def.sizes.center_x, top + def.sizes.center_y, def.sizes.width_text, def.sizes.height_text, style_text.padding)

    -- Border (regular textbox doesn't have a hover color, so this won't either)
    Draw_Border(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, def.sizes.width_text, def.sizes.height_text, style_text.padding, isHovered, style_text.background_color_argb, style_text.background_color_argb, style_text.border_color_argb, style_text.border_color_argb, style_text.border_cornerRadius, style_text.border_thickness)

    -- Draw the text
    ImGui.SetCursorPos(left + style_text.padding, top + style_text.padding)

    ImGui.PushTextWrapPos(left + style_text.padding + def.max_width)
    ImGui.PushStyleColor(ImGuiCol.Text, this.GetForeground_int(def, style_text, style_colors))

    ImGui.Text(def.text)

    ImGui.PopStyleColor()
    ImGui.PopTextWrapPos()

    return isClicked
end

------------------------------------------- Private Methods -------------------------------------------

function this.Calculate_Sizes(def, style_text)
    local width_text, height_text = ImGui.CalcTextSize(def.text, false, def.max_width)

    -- Store values
	def.sizes.width = width_text + (style_text.padding * 2)
	def.sizes.height = height_text + (style_text.padding * 2)

    def.sizes.center_x = def.sizes.width / 2
    def.sizes.center_y = def.sizes.height / 2

    def.sizes.width_text = width_text
    def.sizes.height_text = height_text
end

function this.GetForeground_int(def, style_text, style_colors)
    -- This is copied from textbox.  Keeping it a copy in case the viewmodel ever changes (def of this one is LabelClickable,
    -- which just happens to have a lot of the same properties as TextBox)

    if def.foreground_override then
        local color = GetNamedColor(style_colors, def.foreground_override)
        return color.the_color_abgr
    else
        return style_text.foreground_color_abgr
    end
end