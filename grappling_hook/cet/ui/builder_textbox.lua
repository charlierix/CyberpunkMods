local this = {}

-- Shows a textbox.  The text is persisted in def.text
-- def is models\viewmodels\TextBox
-- style_text is models\stylesheet\TextBox
function Draw_TextBox(def, style_text, line_heights, parent_width, parent_height, const)
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
    ImGui.PushStyleColor(ImGuiCol.Text, style_text.foreground_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBg, style_text.background_color_abgr)

    ImGui.SetCursorPos(left, top)
    ImGui.PushItemWidth(def.sizes.width)

    if def.isMultiLine then
        print("Implement multiline")
    else
        def.text = ImGui.InputText("##" .. def.name, def.text, def.maxChars)
    end

    ImGui.PopItemWidth()

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