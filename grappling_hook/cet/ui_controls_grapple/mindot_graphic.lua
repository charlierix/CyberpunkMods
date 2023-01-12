-- def is models\viewmodels\MinDotGraphic
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_MinDotGraphic(def, style, const, line_heights, scale)
    def.render_pos.width = def.radius * scale
    def.render_pos.height = def.radius * 2 * scale
end

-- def is models\viewmodels\MinDotGraphic
-- style_graphics is models\stylesheet\Graphics
-- style_mindot is models\stylesheet\MinDotGraphic
function Draw_MinDotGraphic(def, style_graphics, style_mindot, screenOffset_x, screenOffset_y, scale)
    local left = def.render_pos.left
    local top = def.render_pos.top

    -- Zero Line
    Draw_Line(screenOffset_x, screenOffset_y, left, top + (def.radius * scale), left + (def.radius * 0.8 * scale), top + (def.radius * scale), style_mindot.zero_color_abgr, style_graphics.line_thickness_minor)

    -- Up Arrow
    local y0 = top + (def.radius * scale)
    local yDist = def.radius * 0.95 * scale
    Draw_Arrow(screenOffset_x, screenOffset_y, left, y0 + yDist, left, y0 - yDist, style_mindot.up_color_abgr, style_graphics.line_thickness_main, style_graphics.arrow_length, style_graphics.arrow_width)

    -- Angle Arrow (zero degrees is straight up, 90 is to the right, 180 is straight down)
    local x = (def.radius * scale) * math.sin(def.radians)  -- normally x is r cos, y is r sin, but that would be for zero degrees along the x axis
    local y = (def.radius * scale) * math.cos(def.radians) * -1
    Draw_Arrow(screenOffset_x, screenOffset_y, left, top + (def.radius * scale), left + x, top + (def.radius * scale) + y, style_mindot.angle_color_abgr, style_graphics.line_thickness_main, style_graphics.arrow_length * scale, style_graphics.arrow_width * scale)
end