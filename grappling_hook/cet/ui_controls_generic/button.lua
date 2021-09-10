local this = {}

-- def is models\viewmodels\Button
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_Button(def, style, line_heights)
    local width = style.button.width
    if def.width_override then
        width = def.width_override
    end

    def.render_pos.width = width
    def.render_pos.height = style.button.height
end

-- def is models\viewmodels\Button
-- style_button is models\stylesheet\Button
-- Returns:
--  isClicked
function Draw_Button(def, style_button)
    local padding_h, padding_v = this.GetPadding(def, def.render_pos.width, style_button.height)

    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_button.border_cornerRadius)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_button.border_thickness)
    ImGui.PushStyleVar(ImGuiStyleVar.FramePadding, padding_h, padding_v)


    if def.isEnabled then
        ImGui.PushStyleColor(ImGuiCol.Button, style_button.back_color_standard_abgr)
        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_button.back_color_hover_abgr)
        ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_button.back_color_click_abgr)
        ImGui.PushStyleColor(ImGuiCol.Text, style_button.foreground_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.Border, style_button.border_color_abgr)
    else
        ImGui.PushStyleColor(ImGuiCol.Button, style_button.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.ButtonHovered, style_button.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.ButtonActive, style_button.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.Text, style_button.disabled_fore_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.Border, style_button.disabled_border_color_abgr)
    end

    ImGui.SetCursorPos(def.render_pos.left, def.render_pos.top)

    local isClicked = ImGui.Button(def.text)

    ImGui.PopStyleColor(5)
    ImGui.PopStyleVar(3)

    return def.isEnabled and isClicked
end

----------------------------------- Private Methods -----------------------------------

-- Gaps between the button's text and it's border.  This is what makes the button the desired width and height
function this.GetPadding(def, width, height)
    local text_width, text_height = ImGui.CalcTextSize(def.text)

    return
        ((width + 1) - text_width) / 2,
        (height - text_height) / 2
end