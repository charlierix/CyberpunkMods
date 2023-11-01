local this = {}

local instructions = CreateEnum("line", "arrow", "circle", "rect", "triangle")

-- def is models\viewmodels\IconButton
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_IconButton(def, style, const, line_heights, scale)
    if not def.sizes then
        def.sizes = {}
    end

    this.Calculate_Sizes(def, style.iconbutton, scale)

    def.render_pos.width = def.sizes.width_height
    def.render_pos.height = def.sizes.width_height
end

-- def is models\viewmodels\IconButton
-- style_button is models\stylesheet\IconButton
-- Returns:
--  isClicked
function Draw_IconButton(def, vars_ui, screenOffset_x, screenOffset_y, scale)
    local left = def.render_pos.left
    local top = def.render_pos.top

    -- Invisible Button
    local clickableSize
    if def.is_circle then
        clickableSize = def.sizes.width_height * 0.85
    else
        clickableSize = def.sizes.width_height
    end

    local isClicked, isHovered = Draw_InvisibleButton(def.invisible_name, left + def.sizes.center_x, top + def.sizes.center_y, clickableSize, clickableSize, 0)
    if isClicked then
        print("icon button clicked: " .. def.tooltip)
    end

    -- Get colors
    local color_back, color_fore, color_border = this.GetColors(def.isEnabled, isClicked, isHovered, vars_ui.style.iconbutton)

    -- Border
    if def.is_circle then
        Draw_Circle(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, def.sizes.radius, false, color_back, nil, color_border, nil, vars_ui.style.iconbutton.border_thickness)
    else
        Draw_Border(screenOffset_x, screenOffset_y, left + def.sizes.center_x, top + def.sizes.center_y, def.sizes.width_height, def.sizes.width_height, 0, false, color_back, nil, color_border, nil, vars_ui.style.iconbutton.border_cornerRadius, vars_ui.style.iconbutton.border_thickness)
    end

    -- Tooltip
    if isHovered and def.tooltip then
        local notouch = def.sizes.radius + (12 * scale)
        Draw_Tooltip(def.tooltip, vars_ui.style.tooltip, screenOffset_x + left + def.sizes.center_x, screenOffset_y + top + def.sizes.center_y, notouch, notouch, vars_ui)
    end

    -- Image
    this.EnsureParsed(def)

    if def.icon_data_parsed then
        this.DrawIcon(def.icon_data_parsed, screenOffset_x, screenOffset_y, left, top, def.render_pos.width, def.render_pos.height, color_fore, scale)
    end

    return isClicked, isHovered
end

----------------------------------- Private Methods -----------------------------------

function this.DrawIcon(icon_data_parsed, screenOffset_x, screenOffset_y, left, top, width, height, color, scale)
    for _, entry in ipairs(icon_data_parsed) do
        if entry[1] == instructions.line or entry[1] == instructions.arrow or entry[1] == instructions.rect then
            local x1 = left + entry[2] * width
            local y1 = top + entry[3] * height
            local x2 = left + entry[4] * width
            local y2 = top + entry[5] * height
            local thickness = entry[6]

            if entry[1] == instructions.line then
                Draw_Line(screenOffset_x, screenOffset_y, x1, y1, x2, y2, color, thickness)

            elseif entry[1] == instructions.arrow then
                local arrow_width = thickness * 2 * scale
                local arrow_length = arrow_width * 1.429        -- grappling hook has width=7, length=10.  Keeping that same ratio

                Draw_Arrow(screenOffset_x, screenOffset_y, x1, y1, x2, y2, color, thickness, arrow_length, arrow_width)

            elseif entry[1] == instructions.rect then
                Draw_Border(screenOffset_x, screenOffset_y, (x1 + x2) / 2, (y1 + y2) / 2, x2 - x1, y2 - y1, 0, false, nil, nil, color, nil, 0, thickness)
            end

        elseif entry[1] == instructions.circle then
            local center_x = left + entry[2] * width
            local center_y = top + entry[3] * height
            local radius = entry[4] * ((width + height) / 2)        -- width and height should be the same, taking the average to be safe
            local thickness = entry[5]

            Draw_Circle(screenOffset_x, screenOffset_y, center_x, center_y, radius, false, nil, nil, color, nil, thickness)

        elseif entry[1] == instructions.triangle then
            local x1 = left + entry[2] * width
            local y1 = top + entry[3] * height
            local x2 = left + entry[4] * width
            local y2 = top + entry[5] * height
            local x3 = left + entry[6] * width
            local y3 = top + entry[7] * height
            local thickness = entry[8]

            Draw_Triangle(screenOffset_x, screenOffset_y, x1, y1, x2, y2, x3, y3, nil, color, thickness)

        else
            LogError("Unexpected instruction: " .. tostring(entry[1]))
        end
    end
end

function this.EnsureParsed(def)
    if not def.icon_data then
        def.icon_data_parsed = nil
        def.icon_data_parsed_against = nil

    elseif def.icon_data ~= def.icon_data_parsed_against then
        def.icon_data_parsed = this.Parse(def.icon_data)
        def.icon_data_parsed_against = def.icon_data
    end
end

function this.Parse(icon_data)
    local retVal = {}
    local current = nil

    for token in string.gmatch(icon_data, "%S+") do       -- capital s for non whitespace
        if Contains_Key(instructions, token) then
            -- Start of a new instruction
            if current then
                table.insert(retVal, current)       -- store the previous instruction
            end

            current = {}
            table.insert(current, token)
        else
            -- All other values must be numbers
            local as_num = tonumber(token)

            if type(as_num) ~= "number" or IsNaN(as_num) then
                LogError("Couldn't parse icon_data element as a number: " .. token .. "\nWhole String:\n" .. icon_data)
                return {}
            end

            table.insert(current, as_num)
        end
    end

    if current then
        table.insert(retVal, current)
    end

    local errMsg = this.FinishParsedEntries(retVal)
    if errMsg then
        LogError(errMsg)
        return {}
    end

    return retVal
end
function this.FinishParsedEntries(parsed)
    for _, entry in ipairs(parsed) do
        -- Make sure there enough arguments
        local arg_count
        if entry[1] == instructions.circle then
            arg_count = 3
        elseif entry[1] == instructions.triangle then
            arg_count = 6
        else
            arg_count = 4
        end

        if #entry < arg_count + 1 then
            return "Not enough arguments for entry: " .. String_Join(" ", Select(entry, function(a) return tostring(a) end))
        end

        -- Make sure thickness is populated (it's optional)
        if not entry[arg_count + 2] then
            entry[arg_count + 2] = 1
        end

        if #entry > arg_count + 2 then
            return "Too many arguments for entry: " .. String_Join(" ", Select(entry, function(a) return tostring(a) end))
        end
    end

    return nil
end

-- Returns back, fore, border
function this.GetColors(isEnabled, isClicked, isHovered, style_iconbutton)
    if not isEnabled then
        return
            style_iconbutton.disabled_back_color_abgr,
            style_iconbutton.disabled_fore_color_abgr,
            style_iconbutton.disabled_border_color_abgr

    elseif isClicked then
        return
            style_iconbutton.back_color_click_abgr,
            style_iconbutton.foreground_color_click_abgr,
            style_iconbutton.border_color_click_abgr

    elseif isHovered then
        return
            style_iconbutton.back_color_hover_abgr,
            style_iconbutton.foreground_color_hover_abgr,
            style_iconbutton.border_color_hover_abgr

    else
        return
            style_iconbutton.back_color_standard_abgr,
            style_iconbutton.foreground_color_standard_abgr,
            style_iconbutton.border_color_standard_abgr
    end
end

function this.Calculate_Sizes(def, style_iconbutton, scale)
    local width_height = style_iconbutton.width_height
    if def.width_height then
        width_height = def.width_height
    end

    def.sizes.width_height = width_height * scale
    def.sizes.radius = def.sizes.width_height / 2

    def.sizes.center_x = def.sizes.width_height / 2
    def.sizes.center_y = def.sizes.width_height / 2
end