-- Draws multiple lines of text in two columns (prompts are col1, values are col2)
-- def is models\ui\OrderedList
--
-- NOTE: A lot of this is a copy of SummaryButton's content logic.  Making a copy, because SummaryButton
-- is too hardcoded and specific.  A version 2 may get built in the future where it's composed of these
-- more generic builders
function Draw_OrderedList(def, style_colors, window_width, window_height, const, line_heights)
    -- Calculate Position
    local width_p, width_g, width_v, width_total = Draw_OrderedList_Width(def)
    local height = Draw_OrderedList_Height(def, line_heights)

    local left, top = GetControlPosition(def.position, width_total, height, window_width, window_height, const)

    -- Draw the prompts
    if width_p > 0 then       -- there may only be values
        local color = GetNamedColor(style_colors, def.color_prompt)

        ImGui.SetCursorPos(left, top)
        ImGui.BeginGroup()      -- new lines stay at the same x value instead of going to zero

        for _, key in ipairs(def.content_keys) do       -- content_keys is sorted
            local text = def.content[key].prompt
            if not text then
                text = ""
            end

            ImGui.TextColored(color.the_color_r, color.the_color_g, color.the_color_b, color.the_color_a, text)
        end

        ImGui.EndGroup()
    end

    -- Draw the values
    if width_v > 0 then
        local color = GetNamedColor(style_colors, def.color_value)

        ImGui.SetCursorPos(left + width_p + width_g, top)
        ImGui.BeginGroup()

        for _, key in ipairs(def.content_keys) do
            local text = def.content[key].value
            if not text then
                text = ""
            end

            ImGui.TextColored(color.the_color_r, color.the_color_g, color.the_color_b, color.the_color_a, text)
        end

        ImGui.EndGroup()
    end
end

------------------------------------------- Private Methods -------------------------------------------

function Draw_OrderedList_Width(def)
    local prompt = 0
    local gap = 0
    local value = 0

    for _, content in pairs(def.content) do
        local p, g, v = Draw_OrderedList_Width_PromptValue(content.prompt, content.value, def.gap)

        prompt = math.max(prompt, p)
        gap = math.max(gap, g)
        value = math.max(value, v)
    end

    return
        prompt,
        gap,
        value,
        prompt + gap + value
end
function Draw_OrderedList_Width_PromptValue(prompt, value, gap)
    local promptWidth = 0
    local gapWidth = 0
    local valueWidth = 0

    if prompt and value then
        promptWidth = ImGui.CalcTextSize(prompt)       -- ignoring vertical result
        valueWidth = ImGui.CalcTextSize(value)

        gapWidth = gap

    elseif prompt then
        promptWidth = ImGui.CalcTextSize(prompt)

    elseif value then
        valueWidth = ImGui.CalcTextSize(value)
    end

    return promptWidth, gapWidth, valueWidth
end

function Draw_OrderedList_Height(def, line_heights)
    local numLines = 0
    for _, _ in pairs(def.content) do
        numLines = numLines + 1
    end

    return (numLines * line_heights.line) + ((numLines - 1) * line_heights.gap)
end