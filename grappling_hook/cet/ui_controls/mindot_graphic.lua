-- def is models\viewmodels\MinDotGraphic
-- style_graphics is models\stylesheet\Graphics
-- style_mindot is models\stylesheet\MinDotGraphic
function Draw_MinDotGraphic(def, style_graphics, style_mindot, screenOffset_x, screenOffset_y, parent_width, parent_height, const)
    -- Calculate Position
	local left, top = GetControlPosition(def.position, def.radius, def.radius * 2, parent_width, parent_height, const)

    -- Zero Line
    Draw_Line(screenOffset_x, screenOffset_y, left, top + def.radius, left + def.radius * 0.8, top + def.radius, style_mindot.zero_color_abgr, style_graphics.line_thickness_minor)

    -- Up Arrow
    local y0 = top + def.radius
    local yDist = def.radius * 0.95
    Draw_Arrow(screenOffset_x, screenOffset_y, left, y0 + yDist, left, y0 - yDist, style_mindot.up_color_abgr, style_graphics.line_thickness_main, style_graphics.arrow_length, style_graphics.arrow_width)

    -- Angle Arrow (zero degrees is straight up, 90 is to the right, 180 is straight down)
    local x = def.radius * math.sin(def.radians)  -- normally x is r cos, y is r sin, but that would be for zero degrees along the x axis
    local y = def.radius * math.cos(def.radians) * -1
    Draw_Arrow(screenOffset_x, screenOffset_y, left, top + def.radius, left + x, top + def.radius + y, style_mindot.angle_color_abgr, style_graphics.line_thickness_main, style_graphics.arrow_length, style_graphics.arrow_width)
end