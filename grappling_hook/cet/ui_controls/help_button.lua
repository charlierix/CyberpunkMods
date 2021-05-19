local this = {}

-- Draws a button that is a ? with a circle around it.  Used like a button to show additional
-- information
-- def is models\viewmodels\HelpButton
-- style_help is models\stylesheet\HelpButton
-- Returns:
--	isClicked, isHovered
function Draw_HelpButton(def, style_help, screenOffset_x, screenOffset_y, parent_width, parent_height, const)
	-- Calculate Sizes
	if not def.sizes then
        def.sizes = {}
    end

    this.Calculate_Sizes(def, style_help)

    -- Calculate Position
	local left, top = GetControlPosition(def.position, def.sizes.width, def.sizes.height, parent_width, parent_height, const)

    -- Invisible Button
    local clickableSize = style_help.radius * 0.85 * 2
    local isClicked, isHovered = Draw_InvisibleButton(def.invisible_name, def.sizes.center_x, def.sizes.center_y, clickableSize, clickableSize, 0)

    -- Circle
    Draw_Circle(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, style_help.radius, isHovered, style_help.back_color_standard_abgr, style_help.back_color_hover_abgr, style_help.border_color_standard_abgr, style_help.border_color_hover_abgr, style_help.border_thickness)

    -- Text
    ImGui.SetCursorPos(left + def.sizes.text_left, top + def.sizes.text_top)

    if isHovered then
        ImGui.PushStyleColor(ImGuiCol.Text, style_help.foreground_color_hover_abgr)
    else
        ImGui.PushStyleColor(ImGuiCol.Text, style_help.foreground_color_standard_abgr)
    end

    ImGui.Text("?")
    ImGui.PopStyleColor()

    return isClicked, isHovered
end

------------------------------------------- Private Methods -------------------------------------------

function this.Calculate_Sizes(def, style_help)
    local width, height = ImGui.CalcTextSize("?")

    local radius = style_help.radius

    def.sizes.text_left = radius - (width / 2)
    def.sizes.text_top = radius - (height / 2)      -- NOTE: if radius is smaller than the text, this will be negative.  But that's ok, the control will be placed according to radius
    def.sizes.center_x = radius
    def.sizes.center_y = radius
    def.sizes.width = radius * 2
    def.sizes.height = radius * 2
end