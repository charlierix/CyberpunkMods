-- def is models\viewmodels\GrappleDesiredLength
-- style_graphics is models\stylesheet\Graphics
function Draw_GrappleDesiredLength(def, style_graphics, screenOffset_x, screenOffset_y, parent_width, parent_height)
    if not def.should_show then
        do return end
    end

    local color
    if def.isHighlight then
        color = style_graphics.line_color_highlight_abgr
    elseif def.isStandardColor then
        color = style_graphics.line_color_standard_abgr
    else
        color = style_graphics.line_color_gray_abgr
    end

    local center_x = parent_width / 2
    local center_y = parent_height / 2

    local halfHeight = def.height / 2

    --NOTE: 0 is at to, since desired is from the anchor point
    local x = GetScaledValue(def.to_x, def.from_x, 0, 1, def.percent)
    x = center_x + x

    local y = center_y + def.y

    Draw_Line(screenOffset_x, screenOffset_y, x, y - halfHeight, x, y + halfHeight, color, style_graphics.line_thickness_main)
end