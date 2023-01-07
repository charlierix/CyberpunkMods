-- def is models\viewmodels\Label
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_Label(def, style, const, line_heights)
    local width = 0
    local height = 0

    if def.text and def.text ~= "" then
        if def.max_width then
            width, height = ImGui.CalcTextSize(def.text, false, def.max_width * line_heights.line)
        else
            width, height = ImGui.CalcTextSize(def.text)
        end
    end

    def.render_pos.width = width
    def.render_pos.height = height
end

-- Draws a label at an arbitrary location within the parent
-- def is models\viewmodels\Label
-- style_colors is models\stylesheet\Stylesheet.colors
function Draw_Label(def, style_colors, em)
    if (not def.text) or def.text == "" then
        do return end
    end

    local color = GetNamedColor(style_colors, def.color)

    ImGui.SetCursorPos(def.render_pos.left, def.render_pos.top)

    if def.max_width then
        ImGui.PushTextWrapPos(def.render_pos.left + def.max_width * em)
    end

    ImGui.PushStyleColor(ImGuiCol.Text, color.the_color_abgr)

    ImGui.Text(def.text)

    ImGui.PopStyleColor()

    if def.max_width then
        ImGui.PopTextWrapPos()
    end
end