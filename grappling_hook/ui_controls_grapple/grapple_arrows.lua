-- def is models\viewmodels\GrappleArrows
-- style_graphics is models\stylesheet\Graphics
function Draw_GrappleArrows(def, style_graphics, screenOffset_x, screenOffset_y, parent_width, parent_height, scale)
    local center_x = parent_width / 2
    local center_y = parent_height / 2

    -- Primary
    local color
    if def.isHighlight_primary then
        color = style_graphics.line_color_highlight_abgr
    elseif def.isStandardColor_primary then
        color = style_graphics.line_color_standard_abgr
    else
        color = style_graphics.line_color_gray_abgr
    end

    Draw_Arrow(screenOffset_x, screenOffset_y, center_x + (def.primary_from_x * scale), center_y + (def.primary_y * scale), center_x + (def.primary_to_x * scale), center_y + (def.primary_y * scale), color, style_graphics.line_thickness_main, style_graphics.arrow_length * scale, style_graphics.arrow_width * scale)

    -- Look
    if def.showLook then
        if def.isHighlight_look then
            color = style_graphics.line_color_highlight_abgr
        elseif def.isStandardColor_look then
            color = style_graphics.line_color_standard_abgr
        else
            color = style_graphics.line_color_gray_abgr
        end

        Draw_Arrow(screenOffset_x, screenOffset_y, center_x + (def.look_from_x * scale), center_y + (def.look_from_y * scale), center_x + (def.look_to_x * scale), center_y + (def.look_to_y * scale), color, style_graphics.line_thickness_main, style_graphics.arrow_length * scale, style_graphics.arrow_width * scale)
    end
end