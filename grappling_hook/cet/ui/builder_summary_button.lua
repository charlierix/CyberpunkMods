-- This got complex.  It might be cleaner to just implement a proper layout engine :)
function Draw_SummaryButton(def, line_heights, style_summary, screenOffset_x, screenOffset_y)
    -- Calcuate sizes
    if not def.sizes then
        def.sizes = {}
    end

    Draw_SummaryButton_UsedWidth(def, style_summary)
    Draw_SummaryButton_UsedHeight(def, line_heights, style_summary)

    -- Invisible Button
    local isClicked, isHovered = Draw_InvisibleButton(def.center_x, def.center_y, def.sizes.horz_final, def.sizes.vert_final, style_summary.padding)

    -- Border
    Draw_Border(screenOffset_x, screenOffset_y, def.center_x, def.center_y, def.sizes.horz_final, def.sizes.vert_final, style_summary.padding, isHovered, style_summary.background_color_standard, style_summary.background_color_hover, style_summary.border_color_standard, style_summary.border_color_hover, style_summary.border_cornerRadius, style_summary.border_thickness)

    -- Place the text
    Draw_SummaryButton_Unused(def, line_heights, style_summary)
    Draw_SummaryButton_Header(def, line_heights, style_summary)
    Draw_SummaryButton_Content(def, line_heights, style_summary)
    Draw_SummaryButton_Suffix(def, line_heights, style_summary)
end

------------------------------------------- Private Methods -------------------------------------------

function Draw_SummaryButton_UsedWidth(def, style_summary)
    local unused = 0
    local h_p = 0
    local h_g = 0
    local h_v = 0
    local c_p = 0
    local c_g = 0
    local c_v = 0

    if def.unused_text then
        -- Unused
        unused = ImGui.CalcTextSize(def.unused_text)
    else
        -- Header
        h_p, h_g, h_v = Draw_SummaryButton_UsedWidth_PromptValue(def.header_prompt, def.header_value, style_summary.prompt_value_gap)

        -- Content
        if def.content then
            for _, content in pairs(def.content) do
                local p, g, v = Draw_SummaryButton_UsedWidth_PromptValue(content.prompt, content.value, style_summary.prompt_value_gap)

                c_p = math.max(c_p, p)
                c_g = math.max(c_g, g)
                c_v = math.max(c_v, v)
            end
        end
    end

    -- Suffix
    local suffix = 0
    if def.suffix then
        suffix = ImGui.CalcTextSize(def.suffix)
    end

    -- Final Width
    local final = math.max
    (
        unused,
        h_p + h_g + h_v,
        c_p + c_g + c_v,
        suffix
    )

    local expadedByMinWidth = false
    if def.min_width and def.min_width > final then
        final = def.min_width
        expadedByMinWidth = true
    end

    -- Store values
    def.sizes.horz_unused = unused

    def.sizes.horz_header_prompt = h_p
    def.sizes.horz_header_gap = h_g
    def.sizes.horz_header_value = h_v
    def.sizes.horz_header_sum = h_p + h_g + h_v

    def.sizes.horz_content_prompt = c_p
    def.sizes.horz_content_gap = c_g
    def.sizes.horz_content_value = c_v
    def.sizes.horz_content_sum = c_p + c_g + c_v

    def.sizes.horz_suffix = suffix

    def.sizes.horz_final = final
    def.sizes.expadedByMinWidth = expadedByMinWidth
end
function Draw_SummaryButton_UsedWidth_PromptValue(prompt, value, gap)
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

function Draw_SummaryButton_UsedHeight(def, line_heights, style_summary)
    -- Add up:
    --  unused (if exists) ELSE
    --  header and gap (if exists)
    --  content lines and gaps (if exists)
    --  summary and gap (if exists)
    local content, nonSuffix, suffixGap, total = Draw_SummaryButton_UsedHeight_AddIt(def, line_heights, style_summary)

    -- The calculated height is the minimum necessary to show the text.  If the minheight is defined
    -- and greater, then that is the height to use
    local expadedByMinHeight = false
    if def.min_height and def.min_height > total then
        total = def.min_height
        expadedByMinHeight = true
    end

    -- Store values
    def.sizes.vert_content = content
    def.sizes.vert_nonSuffix = nonSuffix
    def.sizes.vert_suffixGap = suffixGap
    def.sizes.vert_final = total
    def.sizes.expadedByMinHeight = expadedByMinHeight
end
-- This returns the height of header+content or unused (also suffix)
-- Returns
--  Content Height
--  NonSuffix Height
--  Gap between suffix and nonSuffix
--  Total Height
function Draw_SummaryButton_UsedHeight_AddIt(def, line_heights, style_summary)
    local content = 0
    local nonSuffix = 0
    local suffixGap = 0
    local total = 0

    if def.unused_text then
        -- Unused doesn't have its own gap defined, so it's slightly different from using a header with no content
        nonSuffix = nonSuffix + line_heights.line

        total = nonSuffix

        if def.suffix then
            suffixGap = style_summary.suffix_gap
            total = total + suffixGap
            total = total + line_heights.line
        end

    else
        local hasHeader = def.header_prompt or def.header_value     -- caching to simplify if statements below

        if def.content then
            -- There is content, which means gaps between header/content and suffix/content are straight forward
            local numLines = 0
            for _, _ in pairs(def.content) do
                numLines = numLines + 1
            end

            content = content + (numLines * line_heights.line)
            content = content + ((numLines - 1) * line_heights.gap)

            nonSuffix = nonSuffix + content

            if hasHeader then
                nonSuffix = nonSuffix + line_heights.line
                nonSuffix = nonSuffix + style_summary.header_gap
            end

            total = nonSuffix

            if def.suffix then
                suffixGap = style_summary.suffix_gap
                total = total + suffixGap
                total = total + line_heights.line
            end

        else
            -- There is no content.  Which means there's only a gap if both header and suffix are populated
            if hasHeader then
                nonSuffix = nonSuffix + line_heights.line
            end

            total = nonSuffix

            if def.suffix then
                total = total + line_heights.line
            end

            if hasHeader and def.suffix then
                suffixGap = math.max(style_summary.header_gap, style_summary.suffix_gap)        -- it's not the sum of the gaps, just the larger one
                total = total + suffixGap
            end
        end
    end

    return
        content,
        nonSuffix,
        suffixGap,
        total
end

-- This is a very specific function, called from header and/or content.  Since those two are centered
-- vertically if minHeight forces a stretch, this calculates that gap
function Draw_SummaryButton_HeaderConentGap(def, line_heights)
    -- Header and content will be vertically centered in the space left over.  Ignoring gaps, because
    -- the defined gaps are smaller than the gaps after stretching
    local availableHeight = def.sizes.vert_final

    -- I think it's safe to ignore suffix.  Just vertically center nonsuffix inside the entire button
    -- Suffix will be placed normally and shouldn't clip
    -- if def.suffix then
    --     local reduce = def.sizes.vert_suffixGap + line_heights.line
    --     availableHeight = availableHeight - reduce
    -- end

    local usedHeight = line_heights.line
    local numGaps = 2
    if def.content and (not def.unused_text) then       -- just in case they define unused and content.  Unused wins
        numGaps = numGaps + 1
        usedHeight = usedHeight + def.sizes.vert_content
    end

    -- Return that gap
    return (availableHeight - usedHeight) / numGaps
end

function Draw_SummaryButton_Unused(def, line_heights, style_summary)
    if not def.unused_text then
        do return end
    end

    -- Calculate top/left of the unused text
    local left = def.center_x - (def.sizes.horz_unused / 2)

    local top = nil
    if def.sizes.expadedByMinHeight then
        top = def.center_y - (def.sizes.vert_final / 2) + Draw_SummaryButton_HeaderConentGap(def, line_heights)       -- y is the same as gap, since it's on top and y is the top of the text
    else
        top = def.center_y - (def.sizes.vert_final / 2)
    end

    -- Draw the text
    ImGui.SetCursorPos(left, top)

    ImGui.TextColored(style_summary.unused_color_r, style_summary.unused_color_g, style_summary.unused_color_b, style_summary.unused_color_a, def.unused_text)
end
function Draw_SummaryButton_Header(def, line_heights, style_summary)
    if def.unused_text or (not (def.header_prompt or def.header_value)) then
        do return end
    end

    -- Calculate top/left of the header set
    local left = def.center_x - (def.sizes.horz_header_sum / 2)

    local top = nil
    if def.sizes.expadedByMinHeight then
        top = def.center_y - (def.sizes.vert_final / 2) + Draw_SummaryButton_HeaderConentGap(def, line_heights)       -- y is the same as gap, since it on top and y is the top of the text
    else
        top = def.center_y - (def.sizes.vert_final / 2)
    end

    -- Draw the text
    ImGui.SetCursorPos(left, top)

    if def.header_prompt then
        ImGui.TextColored(style_summary.header_color_prompt_r, style_summary.header_color_prompt_g, style_summary.header_color_prompt_b, style_summary.header_color_prompt_a, def.header_prompt)
    end

    if def.header_prompt and def.header_value then
        left = left + def.sizes.horz_header_prompt + style_summary.prompt_value_gap
        ImGui.SetCursorPos(left, top)
    end

    if def.header_value then
        ImGui.TextColored(style_summary.header_color_value_r, style_summary.header_color_value_g, style_summary.header_color_value_b, style_summary.header_color_value_a, def.header_value)
    end
end
function Draw_SummaryButton_Content(def, line_heights, style_summary)
    if def.unused_text or (not def.content) then
        do return end
    end

    -- Calculate top/left of the content set
    local left_prompt, left_value
    if def.sizes.expadedByMinWidth then
        -- Center horizontally
        local halfContent = def.sizes.horz_content_sum / 2
        left_prompt = def.center_x - halfContent
        left_value = def.center_x + halfContent - def.sizes.horz_content_value
    else
        -- Left align
        left_prompt = def.center_x - (def.sizes.horz_final / 2)
        left_value = def.center_x - (def.sizes.horz_final / 2) + def.sizes.horz_content_sum - def.sizes.horz_content_value
    end

    local top = nil
    if def.sizes.expadedByMinHeight then
        local gap = Draw_SummaryButton_HeaderConentGap(def, line_heights)
        top = def.center_y - (def.sizes.vert_final / 2) + gap       -- going from the top in case the gap calculation wants to include the height of suffix (it's currently commented out, but may change in the future)
        if def.header_prompt or def.header_value then
            top = top + line_heights.line + gap
        end
    else
        top = def.center_y - (def.sizes.vert_final / 2)
        if (def.header_prompt or def.header_value) then
            top = top + line_heights.line
            top = top + style_summary.header_gap
        end
    end

    -- Draw the prompts
    if def.sizes.horz_content_prompt > 0 then       -- there may only be values
        ImGui.SetCursorPos(left_prompt, top)
        ImGui.BeginGroup()      -- new lines stay at the same x value instead of going to zero

        for _, key in ipairs(def.content_keys) do       -- content_keys is sorted
            local text = def.content[key].prompt
            if not text then
                text = ""
            end

            ImGui.TextColored(style_summary.content_color_prompt_r, style_summary.content_color_prompt_g, style_summary.content_color_prompt_b, style_summary.content_color_prompt_a, text)
        end

        ImGui.EndGroup()
    end

    -- Draw the values
    if def.sizes.horz_content_value > 0 then
        ImGui.SetCursorPos(left_value, top)
        ImGui.BeginGroup()

        for _, key in ipairs(def.content_keys) do
            local text = def.content[key].value
            if not text then
                text = ""
            end

            ImGui.TextColored(style_summary.content_color_value_r, style_summary.content_color_value_g, style_summary.content_color_value_b, style_summary.content_color_value_a, text)
        end

        ImGui.EndGroup()
    end
end
function Draw_SummaryButton_Suffix(def, line_heights, style_summary)
    if not def.suffix then      -- suffix should still show if unused is populated
        do return end
    end

    -- Calculate top/left of the suffix
    local left = def.center_x + (def.sizes.horz_final / 2) - def.sizes.horz_suffix
    local top = def.center_y + (def.sizes.vert_final / 2) - line_heights.line

    -- Draw the text
    ImGui.SetCursorPos(left, top)

    ImGui.TextColored(style_summary.suffix_color_r, style_summary.suffix_color_g, style_summary.suffix_color_b, style_summary.suffix_color_a, def.suffix)
end
