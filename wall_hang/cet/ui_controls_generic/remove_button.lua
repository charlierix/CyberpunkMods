local this = {}

-- def is models\viewmodels\RemoveButton
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_RemoveButton(def, style, const, line_heights, scale)
	if not def.sizes then
        def.sizes = {}
    end

    this.Calculate_Sizes(def, style.removeButton, scale)

    def.render_pos.width = def.sizes.width
    def.render_pos.height = def.sizes.height
end

-- Draws a button that is an X with a circle around it.  Used as a button to remove the
-- thing that it's over/near
-- def is models\viewmodels\RemoveButton
-- style_remove is models\stylesheet\RemoveButton
-- Returns:
--	isClicked, isHovered
function Draw_RemoveButton(def, style_remove, screenOffset_x, screenOffset_y, scale)
	local left = def.render_pos.left
    local top = def.render_pos.top

    -- Invisible Button
    local clickableSize = style_remove.radius * 0.85 * 2 * scale
    local isClicked, isHovered = Draw_InvisibleButton(def.invisible_name, left + def.sizes.center_x, top + def.sizes.center_y, clickableSize, clickableSize, 0)

    local color_back, color_fore, color_border
    if isHovered then
        color_back = style_remove.back_color_hover_abgr
        color_fore = style_remove.foreground_color_hover_abgr
        color_border = style_remove.border_color_hover_abgr
    else
        color_back = style_remove.back_color_standard_abgr
        color_fore = style_remove.foreground_color_standard_abgr
        color_border = style_remove.border_color_standard_abgr
    end

    -- Circle
    Draw_Circle(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, style_remove.radius * scale, false, color_back, nil, color_border, nil, style_remove.border_thickness)

    -- X
    local x = left + def.sizes.center_x - 0.5
    local y = top + def.sizes.center_y - 0.5
    Draw_Line(screenOffset_x, screenOffset_y, x - def.sizes.offset, y - def.sizes.offset, x + def.sizes.offset, y + def.sizes.offset, color_fore, style_remove.x_thickness)
    Draw_Line(screenOffset_x, screenOffset_y, x - def.sizes.offset, y + def.sizes.offset, x + def.sizes.offset, y - def.sizes.offset, color_fore, style_remove.x_thickness)

    return isClicked, isHovered
end

------------------------------------------- Private Methods -------------------------------------------

function this.Calculate_Sizes(def, style_remove, scale)
    local radius = style_remove.radius * scale

    def.sizes.offset = radius * 0.4     -- this is for drawing the X
    def.sizes.center_x = radius
    def.sizes.center_y = radius
    def.sizes.width = radius * 2
    def.sizes.height = radius * 2
end