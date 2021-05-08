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
        ImGui.PushTextWrapPos(left + def.max_width)
    end

    ImGui.PushStyleColor(ImGuiCol.Text, color.the_color_abgr)

    ImGui.Text(def.text)

    ImGui.PopStyleColor()

    if def.max_width then
        ImGui.PopTextWrapPos()
    end
end