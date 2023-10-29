local this = {}

-- def is models\viewmodels\OrderedList
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_OrderedList(def, style, const, line_heights, scale)
    if not def.sizes then
        def.sizes = {}
    end

    local width_p, width_g, width_v, width_total = this.Calculate_Width(def, scale)
    local height = this.Calculate_Height(def, line_heights)

    def.sizes.width_p = width_p
    def.sizes.width_g = width_g
    def.sizes.width_v = width_v
    -- def.sizes.width_total = width_total
    -- def.sizes.height = height

    def.render_pos.width = width_total
    def.render_pos.height = height
end

-- Draws multiple lines of text in two columns (prompts are col1, values are col2)
-- def is models\viewmodels\OrderedList
--
-- NOTE: A lot of this is a copy of SummaryButton's content logic.  Making a copy, because SummaryButton
-- is too hardcoded and specific.  A version 2 may get built in the future where it's composed of these
-- more generic controls
function Draw_OrderedList(def, style_colors)
    -- Draw the prompts
    if def.sizes.width_p > 0 then       -- there may only be values
        local color = GetNamedColor(style_colors, def.color_prompt)

        ImGui.SetCursorPos(def.render_pos.left, def.render_pos.top)
        ImGui.BeginGroup()      -- new lines stay at the same x value instead of going to zero

        ImGui.PushStyleColor(ImGuiCol.Text, color.the_color_abgr)

        for _, key in ipairs(def.content_keys) do       -- content_keys is sorted
            local text = def.content[key].prompt
            if not text then
                text = ""
            end

            ImGui.Text(text)
        end

        ImGui.PopStyleColor()

        ImGui.EndGroup()
    end

    -- Draw the values
    if def.sizes.width_v > 0 then
        local color = GetNamedColor(style_colors, def.color_value)

        ImGui.SetCursorPos(def.render_pos.left + def.sizes.width_p + def.sizes.width_g, def.render_pos.top)
        ImGui.BeginGroup()

        ImGui.PushStyleColor(ImGuiCol.Text, color.the_color_abgr)

        for _, key in ipairs(def.content_keys) do
            local text = def.content[key].value
            if not text then
                text = ""
            end

            ImGui.Text(text)
        end

        ImGui.PopStyleColor()

        ImGui.EndGroup()
    end
end

----------------------------------- Private Methods -----------------------------------

function this.Calculate_Width(def, scale)
    local prompt = 0
    local gap = 0
    local value = 0

    for _, content in pairs(def.content) do
        local p, g, v = this.Calculate_Width_PromptValue(content.prompt, content.value, def.gap * scale)

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
function this.Calculate_Width_PromptValue(prompt, value, gap)
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

function this.Calculate_Height(def, line_heights)
    local numLines = 0
    for _, _ in pairs(def.content) do
        numLines = numLines + 1
    end

    return (numLines * line_heights.line) + ((numLines - 1) * line_heights.gap)
end