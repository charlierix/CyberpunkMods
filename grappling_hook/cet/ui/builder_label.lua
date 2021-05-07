-- Draws a label at an arbitrary location within the parent
-- def is models\ui\Label
function Draw_Label(def, style_colors, parent_width, parent_height, const)
    if (not def.text) or def.text == "" then
        do return end
    end

    -- Calculate Size
    local width = nil
    local height = nil
    if def.max_width then
        width, height = ImGui.CalcTextSize(def.text, false, def.max_width)
    else
        width, height = ImGui.CalcTextSize(def.text)
    end

    -- Calculate Position
    local left, top = GetControlPosition(def.position, width, height, parent_width, parent_height, const)

    -- Draw the text
    local color = GetNamedColor(style_colors, def.color)

    ImGui.SetCursorPos(left, top)

    if def.max_width then
        ImGui.PushStyleColor(ImGuiCol.Text, color.the_color_r, color.the_color_g, color.the_color_b, color.the_color_a)
        --ImGui.PushStyleColor(ImGuiCol.Text, 0xFF88FF88)     -- ABGR?
        ImGui.PushTextWrapPos(left + def.max_width)

        ImGui.Text(def.text)

        ImGui.PopTextWrapPos()
        ImGui.PopStyleColor()
    else
        ImGui.TextColored(color.the_color_r, color.the_color_g, color.the_color_b, color.the_color_a, def.text)
    end
end