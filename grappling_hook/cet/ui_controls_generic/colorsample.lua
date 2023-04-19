local this = {}

-- def is models\viewmodels\ColorSample
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_ColorSample(def, style, const, line_heights, scale)
    if not def.sizes then
        def.sizes = {}
    end

    local width = style.colorSample.width
    if def.width_override then
        width = def.width_override
    end

    local height = style.colorSample.height
    if def.height_override then
        height = def.height_override
    end

	def.sizes.width = width * scale
	def.sizes.height = height * scale
    def.sizes.center_x = def.sizes.width / 2
    def.sizes.center_y = def.sizes.height / 2

    def.render_pos.width = def.sizes.width
    def.render_pos.height = def.sizes.height
end

-- def is models\viewmodels\ColorSample
-- style_colorsample is models\stylesheet\ColorSample
function Draw_ColorSample(def, style_colorsample, screenOffset_x, screenOffset_y, scale)
    local left = def.render_pos.left
    local top = def.render_pos.top

    local _, color_abgr = ConvertHexStringToNumbers(def.color_hex)

    Draw_Border(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, def.sizes.width, def.sizes.height, 0, false, style_colorsample.checker_color_dark_argb, nil, nil, nil, 0, style_colorsample.border_thickness)
    this.DrawLightSquares(screenOffset_x, screenOffset_y, left, top, style_colorsample.checker_size * scale, def, style_colorsample.checker_color_light_argb)

    local padding = math.min(def.sizes.width * 0.33, def.sizes.height * 0.33)
    Draw_Border(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, def.sizes.width - padding, def.sizes.height - padding, 0, false, color_abgr, nil, style_colorsample.border_color_argb, nil, 0, 1)

    Draw_Border(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, def.sizes.width, def.sizes.height, 0, false, nil, nil, style_colorsample.border_color_argb, nil, 0, style_colorsample.border_thickness)
end

----------------------------------- Private Methods -----------------------------------

function this.DrawLightSquares(screenOffset_x, screenOffset_y, left, top, square_size, def, color_abgr)
    local count_x = math.floor(def.sizes.width / square_size)
    local count_y = math.floor(def.sizes.height / square_size)

    local half = square_size / 2

    -- Whole Squares
    for i = 0, count_x - 1, 1 do
        for j = 0, count_y - 1, 1 do
            if math.fmod(i + j, 2) == 0 then        -- only draw every other
                local square_left = left + (square_size * i)
                local square_top = top + (square_size * j)

                Draw_Border(screenOffset_x, screenOffset_y, square_left + half, square_top + half, square_size, square_size, 0, false, color_abgr, nil, nil, nil, 0, nil)
            end
        end
    end

    -- Right Edge
    local edge_width = def.sizes.width - (square_size * count_x)
    local half_edge_width = edge_width / 2

    if not IsNearZero(edge_width) then
        for j = 0, count_y - 1, 1 do
            if math.fmod(count_x + j, 2) == 0 then        -- only draw every other
                local square_left = left + (square_size * count_x)
                local square_top = top + (square_size * j)

                Draw_Border(screenOffset_x, screenOffset_y, square_left + half_edge_width, square_top + half, edge_width, square_size, 0, false, color_abgr, nil, nil, nil, 0, nil)
            end
        end
    end

    -- Bottom Edge
    local edge_height = def.sizes.height - (square_size * count_y)
    local half_edge_height = edge_height / 2

    if not IsNearZero(edge_height) then
        for i = 0, count_x - 1, 1 do
            if math.fmod(i + count_y, 2) == 0 then        -- only draw every other
                local square_left = left + (square_size * i)
                local square_top = top + (square_size * count_y)

                Draw_Border(screenOffset_x, screenOffset_y, square_left + half, square_top + half_edge_height, square_size, edge_height, 0, false, color_abgr, nil, nil, nil, 0, nil)
            end
        end
    end

    -- Bottom Right
    if not IsNearZero(edge_width) and not IsNearZero(edge_height) and math.fmod(count_x + count_y, 2) == 0 then
        local square_left = left + (square_size * count_x)
        local square_top = top + (square_size * count_y)

        Draw_Border(screenOffset_x, screenOffset_y, square_left + half_edge_width, square_top + half_edge_height, edge_width, edge_height, 0, false, color_abgr, nil, nil, nil, 0, nil)
    end
end