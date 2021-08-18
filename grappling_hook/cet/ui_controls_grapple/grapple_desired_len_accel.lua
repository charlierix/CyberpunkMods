local this = {}

-- Putting these in the same file, since they use some of the same calculations

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

    local x, y = this.GetXY(def, parent_width, parent_height)

    local halfHeight = def.height / 2

    Draw_Line(screenOffset_x, screenOffset_y, x, y - halfHeight, x, y + halfHeight, color, style_graphics.line_thickness_main)
end

-- def is models\viewmodels\GrappleAccelToDesired
-- style_graphics is models\stylesheet\Graphics
function Draw_GrappleAccelToDesired(def, style_graphics, screenOffset_x, screenOffset_y, parent_width, parent_height)
    if not def.show_accel_left and not def.show_accel_right and not def.show_dead then
        do return end
    end

    local x, y = this.GetXY(def, parent_width, parent_height)

    local color

    -- Accel
    if def.show_accel_left or def.show_accel_right then
        local acc_y = y + def.yOffset_accel

        if def.show_accel_left then
            if def.isHighlight_accel_left then
                color = style_graphics.line_color_highlight_abgr
            elseif def.isStandardColor_accel then
                color = style_graphics.line_color_standard_abgr
            else
                color = style_graphics.line_color_gray_abgr
            end

            Draw_Arrow(screenOffset_x, screenOffset_y, x - def.length_accel, acc_y, x - def.length_accel_halfgap, acc_y, color, style_graphics.line_thickness_main, style_graphics.arrow_length, style_graphics.arrow_width)
        end

        -- No need to draw the arrow from the anchor point to desired if desired is at the anchor point
        if def.show_accel_right and not IsNearZero(def.percent) then
            if def.isHighlight_accel_right then
                color = style_graphics.line_color_highlight_abgr
            elseif def.isStandardColor_accel then
                color = style_graphics.line_color_standard_abgr
            else
                color = style_graphics.line_color_gray_abgr
            end

            Draw_Arrow(screenOffset_x, screenOffset_y, x + def.length_accel, acc_y, x + def.length_accel_halfgap, acc_y, color, style_graphics.line_thickness_main, style_graphics.arrow_length, style_graphics.arrow_width)
        end
    end

    -- Dead Spot
    if def.show_dead then
        if def.isHighlight_dead then
            color = style_graphics.line_color_highlight_abgr
        elseif def.isStandardColor_dead then
            color = style_graphics.line_color_standard_abgr
        else
            color = style_graphics.line_color_gray_abgr
        end

        local dead_y = y + def.yOffset_dead

        local halfHeight = def.deadHeight / 2

        local from_x = x - def.length_dead
        local to_x = x
        if not IsNearZero(def.percent) then
            to_x = x + def.length_dead
        end

        -- Horizontal
        Draw_Line(screenOffset_x, screenOffset_y, from_x, dead_y, to_x, dead_y, color, style_graphics.line_thickness_main)

        -- End Caps
        Draw_Line(screenOffset_x, screenOffset_y, from_x, dead_y - halfHeight, from_x, dead_y + halfHeight, color, style_graphics.line_thickness_main)
        Draw_Line(screenOffset_x, screenOffset_y, to_x, dead_y - halfHeight, to_x, dead_y + halfHeight, color, style_graphics.line_thickness_main)
    end
end

----------------------------------- Private Methods -----------------------------------

-- This returns the position of the center of the desired line (in parent coords)
function this.GetXY(def, parent_width, parent_height)
    local center_x = parent_width / 2
    local center_y = parent_height / 2

    --NOTE: 0 is at to, since desired is from the anchor point    
    local x = GetScaledValue(def.to_x, def.from_x, 0, 1, def.percent)

    return
        center_x + x,
        center_y + def.y
end