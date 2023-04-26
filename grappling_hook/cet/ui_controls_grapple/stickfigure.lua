-- def is models\viewmodels\StickFigure
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_StickFigure(def, style, const, line_heights, scale)
    def.render_pos.width = def.width * scale
    def.render_pos.height = def.height * scale
end

-- def is models\viewmodels\StickFigure
-- style_graphics is models\stylesheet\Graphics
function Draw_StickFigure(def, style_graphics, screenOffset_x, screenOffset_y, scale)
    -- width = 266
    -- height = 475
    -- <Ellipse Width="112" Height="112" VerticalAlignment="Top"/>      -- head
    -- <Line X1="0" Y1="180" X2="266" Y2="180"/>        -- arms
    -- <Line X1="133" Y1="112" X2="133" Y2="288"/>      -- body
    -- <Line X1="133" Y1="288" X2="22" Y2="475"/>       -- left leg
    -- <Line X1="133" Y1="288" X2="244" Y2="475"/>      -- right leg

    local left = def.render_pos.left
    local top = def.render_pos.top
    local right = left + (def.width * scale)
    local bottom = top + (def.height * scale)
    local center_x = left + ((def.width * scale) / 2)
    --local center_y = top + ((def.height * scale) / 2)

    local color
    if def.isHighlight then
        color = style_graphics.stickfigure_color_highlight_abgr
    elseif def.isStandardColor then
        color = style_graphics.stickfigure_color_standard_abgr
    else
        color = style_graphics.stickfigure_color_gray_abgr
    end

    -- Head
    local radius = def.height * 0.11789 * scale
    Draw_Circle(screenOffset_x, screenOffset_y, center_x, top + radius, radius, false, nil, nil, color, nil, style_graphics.line_thickness_main)

    -- Body
    local pelvis_y = top + (def.height * 0.60632 * scale)
    Draw_Line(screenOffset_x, screenOffset_y, center_x, top + (radius * 2), center_x, pelvis_y, color, style_graphics.line_thickness_main)

    -- Arms
    local arm_y = top + (def.height * 0.37895 * scale)
    Draw_Line(screenOffset_x, screenOffset_y, left, arm_y, right, arm_y, color, style_graphics.line_thickness_main)

    -- Left Leg
    local halfStance = def.width * 0.41729 * scale
    Draw_Line(screenOffset_x, screenOffset_y, center_x - halfStance, bottom, center_x, pelvis_y, color, style_graphics.line_thickness_main)

    -- Right Leg
    Draw_Line(screenOffset_x, screenOffset_y, center_x + halfStance, bottom, center_x, pelvis_y, color, style_graphics.line_thickness_main)
end