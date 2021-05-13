local this = {}

-- Shows a textbox.  The text is persisted in def.text
-- def is models\viewmodels\TextBox
-- style_text is models\stylesheet\TextBox
-- style_colors is stylesheet.colors
function Draw_TextBox(def, style_text, style_colors, line_heights, parent_width, parent_height, const)
	-- Calculate Size
	if not def.sizes then
        def.sizes = {}
    end

    this.Calculate_Sizes(def, style_text, line_heights)

    -- Calculate Position
	local left, top = GetControlPosition(def.position, def.sizes.width, def.sizes.height, parent_width, parent_height, const)

    -- Draw the textbox
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_text.border_cornerRadius)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_text.border_thickness)
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, style_text.padding, style_text.padding)

	ImGui.PushStyleColor(ImGuiCol.NavHighlight, 0x00000000)
    ImGui.PushStyleColor(ImGuiCol.Border, style_text.border_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.Text, this.GetForeground_int(def, style_text, style_colors))
    ImGui.PushStyleColor(ImGuiCol.FrameBg, style_text.background_color_abgr)

    ImGui.SetCursorPos(left, top)

    if def.isMultiLine then
        --TODO: Figure out scrollbars

        -- This doesn't work for textbox
        --ImGui.PushTextWrapPos(left + def.sizes.width - style_text.padding)

        def.text = ImGui.InputTextMultiline("##" .. def.name, def.text, def.maxChars, def.sizes.width, def.sizes.height)

        --ImGui.PopTextWrapPos()
    else
        ImGui.PushItemWidth(def.sizes.width)
        def.text = ImGui.InputText("##" .. def.name, def.text, def.maxChars)
        ImGui.PopItemWidth()
    end

    ImGui.PopStyleColor(4)
    ImGui.PopStyleVar(3)
end

------------------------------------------- Private Methods -------------------------------------------

function this.Calculate_Sizes(def, style_text, line_heights)
    -- Width
    local width = nil
    if def.width then
        -- An fixed width is defined
        width = def.width

    else
        -- No fixed width, see how wide the text is
        if def.text then
            width = ImGui.CalcTextSize(def.text)
        else
            width = 12
        end

        -- Grow if min_width says to
        if def.min_width and def.min_width > width then
            width = def.min_width
        end

        -- Shrink if larger than max
        if def.max_width and width > def.max_width then
            width = def.max_width
        end
    end

    -- Height
    local height = def.height
    if not def.isMultiLine then
        height = line_heights.line
    end

    -- Store values
	def.sizes.width = width + (style_text.padding * 2)
	def.sizes.height = height + (style_text.padding * 2)
end

function this.GetForeground_int(def, style_text, style_colors)
    if def.foreground_override then
        local color = GetNamedColor(style_colors, def.foreground_override)
        return color.the_color_abgr
    else
        return style_text.foreground_color_abgr
    end
end