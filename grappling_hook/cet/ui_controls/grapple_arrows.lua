local this = {}

-- def is models\viewmodels\GrappleArrows
-- style_graphics is models\stylesheet\Graphics
function Draw_GrappleArrows(def, style_graphics, screenOffset_x, screenOffset_y, parent_width, parent_height)
    local color
    if def.isHighlight_primary then
        color = style_graphics.line_color_highlight_abgr
    elseif def.isStandardColor_primary then
        color = style_graphics.line_color_standard_abgr
    else
        color = style_graphics.line_color_gray_abgr
    end

    local center_x = parent_width / 2
    local center_y = parent_height / 2

    -- Primary
    Draw_Line(screenOffset_x, screenOffset_y, center_x + def.primary_from_x, center_y + def.primary_y, center_x + def.primary_to_x, center_y + def.primary_y, color, style_graphics.line_thickness_main)

    local x1, y1, x2, y2, x3, y3 = this.GetArrowCoords(center_x + def.primary_from_x, center_y + def.primary_y, center_x + def.primary_to_x, center_y + def.primary_y, style_graphics.arrow_length, style_graphics.arrow_width)
    Draw_Triangle(screenOffset_x, screenOffset_y, x1, y1, x2, y2, x3, y3, color, nil, nil)

    -- Look
    if def.showLook then
        if def.isHighlight_look then
            color = style_graphics.line_color_highlight_abgr
        elseif def.isStandardColor_look then
            color = style_graphics.line_color_standard_abgr
        else
            color = style_graphics.line_color_gray_abgr
        end

        Draw_Line(screenOffset_x, screenOffset_y, center_x + def.look_from_x, center_y + def.look_from_y, center_x + def.look_to_x, center_y + def.look_to_y, color, style_graphics.line_thickness_main)

        x1, y1, x2, y2, x3, y3 = this.GetArrowCoords(center_x + def.look_from_x, center_y + def.look_from_y, center_x + def.look_to_x, center_y + def.look_to_y, style_graphics.arrow_length, style_graphics.arrow_width)
        Draw_Triangle(screenOffset_x, screenOffset_y, x1, y1, x2, y2, x3, y3, color, nil, nil)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetArrowCoords(x1, y1, x2, y2, length, width)
    local magnitude = Get2DLength(x2 - x1, y2 - y1)

    -- Get a unit vector that points from the to point back to the base of the arrow head
    local baseDir_x = (x1 - x2) / magnitude
    local baseDir_y = (y1 - y2) / magnitude

    -- Now get two unit vectors that point from the shaft out to the tips
    local edgeDir1_x = -baseDir_y
    local edgeDir1_y = baseDir_x

    local edgeDir2_x = baseDir_y
    local edgeDir2_y = -baseDir_x

    -- Get the point at the base of the arrow that is on the shaft
    local base_x = x2 + (baseDir_x * length)
    local base_y = y2 + (baseDir_y * length)

    local halfWidth = width / 2

    return
        x2,     -- arrow tip
        y2,
        base_x + (edgeDir1_x * halfWidth),      -- base point 1
        base_y + (edgeDir1_y * halfWidth),
        base_x + (edgeDir2_x * halfWidth),      -- base point 2
        base_y + (edgeDir2_y * halfWidth)
end