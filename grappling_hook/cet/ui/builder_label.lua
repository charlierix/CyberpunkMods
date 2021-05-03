function Draw_Label(def, style_colors, window_width, window_height, const, line_heights)
    if (not def.text) or def.text == "" then
        do return end
    end

    -- Calculate Position
    local width, height = CalcTextSize(def.text, def.max_width, line_heights)
    local left, top = GetControlPosition(def.position, width, height, window_width, window_height, const)

    -- Draw the text
    local color = GetNamedColor(style_colors, def.color)

    ImGui.SetCursorPos(left, top)

    if def.max_width then
        ImGui.PushStyleColor(ImGuiCol.Text, color.the_color)
        ImGui.PushTextWrapPos(left + def.max_width)

        ImGui.Text(def.text)

        ImGui.PopTextWrapPos()
        ImGui.PopStyleColor()
    else
        ImGui.TextColored(color.the_color_r, color.the_color_g, color.the_color_b, color.the_color_a, def.text)
    end
end

