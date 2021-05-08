local this = {}

-- Draws a pair of + - buttons, either horizontal or vertical orientations
-- def is models\ui\UpDownButtons
-- style_updown is models\stylesheet\UpDownButtons
-- Returns:
--	isDownClicked, isUpClicked
function Draw_UpDownButtons(def, style_updown, parent_width, parent_height, const)
	-- Concatenate +- with model's text
    local text_down, text_up = this.FinalText(def)

	-- Calculate Sizes
	if not def.sizes then
        def.sizes = {}
    end

    this.Calculate_Sizes(def, style_updown, text_down, text_up)

    -- Calculate Position
	local left, top = GetControlPosition(def.position, def.sizes.width, def.sizes.height, parent_width, parent_height, const)

	-- Common properties
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_updown.border_cornerRadius)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_updown.border_thickness)

	-- Down
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, def.sizes.down_pad_h, def.sizes.down_pad_v)

	if def.isEnabled_down then
		ImGui.PushStyleColor(ImGuiCol.Button, style_updown.down_color_standard_abgr)
		ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_updown.down_color_hover_abgr)
		ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_updown.down_color_click_abgr)
		ImGui.PushStyleColor(ImGuiCol.Text, style_updown.foreground_color_abgr)
		ImGui.PushStyleColor(ImGuiCol.Border, style_updown.border_color_abgr)
	else
		ImGui.PushStyleColor(ImGuiCol.Button, style_updown.disabled_back_color_abgr)
		ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_updown.disabled_back_color_abgr)
		ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_updown.disabled_back_color_abgr)
		ImGui.PushStyleColor(ImGuiCol.Text, style_updown.disabled_fore_color_abgr)
		ImGui.PushStyleColor(ImGuiCol.Border, style_updown.disabled_border_color_abgr)
	end

    ImGui.SetCursorPos(left + def.sizes.down_left, top + def.sizes.down_top)

    local isDownClicked = ImGui.Button(text_down)		-- this bool is ANDed with isEnabled at the bottom of this function

    ImGui.PopStyleColor(5)
    ImGui.PopStyleVar(1)

	-- Up
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, def.sizes.up_pad_h, def.sizes.up_pad_v)

	if def.isEnabled_up then
		ImGui.PushStyleColor(ImGuiCol.Button, style_updown.up_color_standard_abgr)
		ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_updown.up_color_hover_abgr)
		ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_updown.up_color_click_abgr)
		ImGui.PushStyleColor(ImGuiCol.Text, style_updown.foreground_color_abgr)
		ImGui.PushStyleColor(ImGuiCol.Border, style_updown.border_color_abgr)
	else
		ImGui.PushStyleColor(ImGuiCol.Button, style_updown.disabled_back_color_abgr)
		ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_updown.disabled_back_color_abgr)
		ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_updown.disabled_back_color_abgr)
		ImGui.PushStyleColor(ImGuiCol.Text, style_updown.disabled_fore_color_abgr)
		ImGui.PushStyleColor(ImGuiCol.Border, style_updown.disabled_border_color_abgr)
	end

    ImGui.SetCursorPos(left + def.sizes.up_left, top + def.sizes.up_top)

    local isUpClicked = ImGui.Button(text_up)

    ImGui.PopStyleColor(5)
    ImGui.PopStyleVar(1)

	-- /Common properties
    ImGui.PopStyleVar(2)

	return
		isDownClicked and def.isEnabled_down,
		isUpClicked and def.isEnabled_up
end

------------------------------------------- Private Methods -------------------------------------------

function this.FinalText(def)
    local text_down = "-"
    if def.text_down and def.text_down ~= "" then
        text_down = text_down .. def.text_down
    end

    local text_up = "+"
    if def.text_up and def.text_up ~= "" then
        text_up = text_up .. def.text_up
    end

    return text_down, text_up
end

function this.Calculate_Sizes(def, style_updown, text_down, text_up)
	-- Individual Sizes
	local down_width, down_height = this.Calculate_Sizes_Single(text_down, style_updown)
	local up_width, up_height = this.Calculate_Sizes_Single(text_up, style_updown)

	-- The buttons need to be the same size, so take the larger values
	local width = math.max(down_width, up_width)
	local height = math.max(down_height, up_height)

	-- Store filler size
	local down_width_extra = width - down_width
	local down_height_extra = height - down_height
	local up_width_extra = width - up_width
	local up_height_extra = height - up_height

	-- Final Size/Position
	local down_left = 0
	local down_top = 0
	local up_left = 0
	local up_top = 0
	local width_final = width
	local height_final = height

	if def.isHorizontal then
		up_left = width + style_updown.gap		-- down gap up
		width_final = (width * 2) + style_updown.gap
	else
		down_top = height + style_updown.gap		-- up gap down
		height_final = (height * 2) + style_updown.gap
	end

    -- Store values
	def.sizes.width = width_final
	def.sizes.height = height_final

	def.sizes.down_left = down_left
	def.sizes.down_top = down_top
	def.sizes.up_left = up_left
	def.sizes.up_top = up_top

	def.sizes.down_pad_h = style_updown.padding_horizontal + (down_width_extra / 2)
	def.sizes.down_pad_v = style_updown.padding_vertical + (down_height_extra / 2)
	def.sizes.up_pad_h = style_updown.padding_horizontal + (up_width_extra / 2)
	def.sizes.up_pad_v = style_updown.padding_vertical + (up_height_extra / 2)
end
function this.Calculate_Sizes_Single(text, style_updown)
	-- Ignoring border size, because it's more of an after effect.  Half the border thickness goes
	-- into the button, half goes beyond the button.  Button placement ignores border size.  If
	-- border thickness were extreme, it may need to get accounted for, but for standard sizes, it
	-- would be a hassle for no real gain

    local width, height = ImGui.CalcTextSize(text)

	width = width + (style_updown.padding_horizontal * 2) - 1
	height = height + (style_updown.padding_vertical * 2)

	return width, height
end