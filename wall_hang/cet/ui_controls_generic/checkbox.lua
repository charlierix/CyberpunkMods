-- def is models\viewmodels\CheckBox
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_CheckBox(def, style, const, line_heights, scale)
    local width, height = ImGui.CalcTextSize(def.text)

    -- Couldn't find a function to measure the size of the box and gap between box and text, so resorted
    -- to counting pixels (box is 19x19, gap is 5)
    width = width + ((19 + 5) * scale)
    height = math.max(height, 19 * scale)

    def.render_pos.width = width
    def.render_pos.height = height
end

-- def is models\viewmodels\CheckBox
-- style_checkbox is models\stylesheet\CheckBox
-- Returns
--  wasChanged, isHovered
function Draw_CheckBox(def, style_checkbox, style_colors)
    local width = def.render_pos.width
    local height = def.render_pos.height
    local left = def.render_pos.left
    local top = def.render_pos.top

    -- Draw the checkbox
    --ImGui.PushStyleColor(ImGuiCol.Border, 0xFF80FF40)     -- border is ignored
	ImGui.PushStyleColor(ImGuiCol.NavHighlight, 0x00000000)

    if def.isEnabled then
        local fore_color = style_checkbox.foreground_color_abgr
        if def.foreground_override then
            fore_color = GetNamedColor(style_colors, def.foreground_override).the_color_abgr
        end

        ImGui.PushStyleColor(ImGuiCol.Text, fore_color)
        ImGui.PushStyleColor(ImGuiCol.FrameBg, style_checkbox.background_color_standard_abgr)
        ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, style_checkbox.background_color_hover_abgr)
        ImGui.PushStyleColor(ImGuiCol.FrameBgActive, style_checkbox.background_color_click_abgr)
        ImGui.PushStyleColor(ImGuiCol.CheckMark, style_checkbox.checkmark_color_abgr)
    else
        ImGui.PushStyleColor(ImGuiCol.Text, style_checkbox.disabled_fore_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.FrameBg, style_checkbox.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, style_checkbox.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.FrameBgActive, style_checkbox.disabled_back_color_abgr)
        ImGui.PushStyleColor(ImGuiCol.CheckMark, style_checkbox.disabled_checkmark_color_abgr)
    end

    ImGui.SetCursorPos(left, top)

    local isChecked, wasChanged = ImGui.Checkbox(def.text, def.isChecked)

    -- Invisible Button
    local _, isHovered = Draw_InvisibleButton(def.invisible_name .. "Hidden", left + (width / 2), top + (height / 2), width, height, 0)

    if def.isEnabled then
        def.isChecked = isChecked
    end

    ImGui.PopStyleColor(6)

    return
        wasChanged and def.isEnabled,
        isHovered
end