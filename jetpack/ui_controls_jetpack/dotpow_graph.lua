local this = {}

-- def is models\viewmodels\DotPowGraph
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_DotPowGraph(def, style, const, line_heights, scale)
    def.render_pos.width = def.width * scale
    def.render_pos.height = (def.graph_height + def.graph_icon_gap + def.icon_size) * scale
end

-- def is models\viewmodels\DotPowGraph
-- style_dotpowgraph is models\stylesheet\DotPowGraph
function Draw_DotPowGraph(def, style_dotpowgraph, screenOffset_x, screenOffset_y, scale)
    local left = def.render_pos.left
    local top = def.render_pos.top

    local graph_height = (def.graph_height * scale)

    -- Axis Line
    Draw_Line(screenOffset_x, screenOffset_y, left, top + graph_height, left + def.render_pos.width, top + graph_height, style_dotpowgraph.x_axis_color_abgr, style_dotpowgraph.x_axis_thickness)

    -- Vertical Axis Lines
    Draw_Line(screenOffset_x, screenOffset_y, left, top, left, top + graph_height, style_dotpowgraph.vert_axis_color_abgr, style_dotpowgraph.vert_axis_thickness)
    Draw_Line(screenOffset_x, screenOffset_y, left + (def.render_pos.width / 2), top, left + (def.render_pos.width / 2), top + graph_height, style_dotpowgraph.vert_axis_color_abgr, style_dotpowgraph.vert_axis_thickness)
    Draw_Line(screenOffset_x, screenOffset_y, left + def.render_pos.width, top, left + def.render_pos.width, top + graph_height, style_dotpowgraph.vert_axis_color_abgr, style_dotpowgraph.vert_axis_thickness)

    -- Graph Line
    local count = 144
    local step = 1 / (count - 1)

    local prev_x = 0
    local prev_y = graph_height * (1 - this.PowForAnglePercent(1, def.power))

    for i = 2, count, 1 do
        local cur_x = step * i
        local cur_y = graph_height * (1 - this.PowForAnglePercent(1 - cur_x, def.power))       -- x is 1 to 0, drawing is top down to graph_height

        Draw_Line(screenOffset_x, screenOffset_y, left + (prev_x * def.render_pos.width), top + prev_y, left + (cur_x * def.render_pos.width), top + cur_y, style_dotpowgraph.graphline_color_abgr, style_dotpowgraph.graphline_thickness)

        prev_x = cur_x
        prev_y = cur_y
    end

    -- X Axis Icons
    local arrow_width = style_dotpowgraph.legendicon_thickness * 2 * scale
    local arrow_length = arrow_width * (10 / 7)        -- grappling hook has width=7, length=10.  Keeping that same ratio

    local arrow_y_top = top + graph_height + (def.graph_icon_gap * scale)
    local arrow_y_bottom = arrow_y_top + (def.icon_size * scale)

    Draw_Arrow(screenOffset_x, screenOffset_y, left, arrow_y_bottom, left, arrow_y_top, style_dotpowgraph.legendicon_color_abgr, style_dotpowgraph.legendicon_thickness, arrow_length, arrow_width)


    local half_icon = (def.icon_size / 2) * scale
    local sqrt_icon = (def.icon_size / math.sqrt(2)) * scale
    local arrow_x_center = left + (def.render_pos.width / 2)
    local arrow_x_left = arrow_x_center - (sqrt_icon / 2)
    --local arrow_x_right = arrow_x_center + (sqrt_icon / 2)

    local arrow_45_right = arrow_x_left + sqrt_icon
    local arrow_45_top = arrow_y_bottom - sqrt_icon

    Draw_Arrow(screenOffset_x, screenOffset_y, arrow_x_left, arrow_y_bottom, arrow_x_left, arrow_y_top, style_dotpowgraph.legendicon_color_abgr, style_dotpowgraph.legendicon_thickness, arrow_length, arrow_width)
    Draw_Arrow(screenOffset_x, screenOffset_y, arrow_x_left, arrow_y_bottom, arrow_45_right, arrow_45_top, style_dotpowgraph.legendicon_color_abgr, style_dotpowgraph.legendicon_thickness, arrow_length, arrow_width)


    arrow_x_center = left + def.render_pos.width
    arrow_x_left = arrow_x_center - half_icon
    local arrow_x_right = arrow_x_center + half_icon

    Draw_Arrow(screenOffset_x, screenOffset_y, arrow_x_left, arrow_y_bottom, arrow_x_left, arrow_y_top, style_dotpowgraph.legendicon_color_abgr, style_dotpowgraph.legendicon_thickness, arrow_length, arrow_width)
    Draw_Arrow(screenOffset_x, screenOffset_y, arrow_x_left, arrow_y_bottom, arrow_x_right, arrow_y_bottom, style_dotpowgraph.legendicon_color_abgr, style_dotpowgraph.legendicon_thickness, arrow_length, arrow_width)
end

----------------------------------- Private Methods -----------------------------------

function this.PowForAnglePercent(x, pow)
    return math.cos((math.pi / 2) * (1 - x)) ^ pow
end
