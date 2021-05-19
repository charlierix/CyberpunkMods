-- def is models\viewmodels\CheckBox
-- style_checkbox is models\stylesheet\CheckBox
-- Returns
--  wasChanged
function Draw_CheckBox(def, style_checkbox, parent_width, parent_height, const)

    -- Calculate Size
    local width, height = ImGui.CalcTextSize(def.text)

    -- Couldn't find a function to measure the size of the box and gap between box and text, so resorted
    -- to counting pixels (box is 19x19, gap is 5)
    width = width + 19 + 5
    height = math.max(height, 19)

    -- Calculate Position
	local left, top = GetControlPosition(def.position, width, height, parent_width, parent_height, const)

    -- Draw the checkbox
    --ImGui.PushStyleColor(ImGuiCol.Border, 0xFF80FF40)     -- border is ignored
	ImGui.PushStyleColor(ImGuiCol.NavHighlight, 0x00000000)
    ImGui.PushStyleColor(ImGuiCol.Text, style_checkbox.foreground_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBg, style_checkbox.background_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, style_checkbox.background_color_hover_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBgActive, style_checkbox.background_color_click_abgr)
    ImGui.PushStyleColor(ImGuiCol.CheckMark, style_checkbox.checkmark_color_abgr)

    ImGui.SetCursorPos(left, top)

    local wasChanged
    def.isChecked, wasChanged = ImGui.Checkbox(def.text, def.isChecked)

    ImGui.PopStyleColor(6)

    return wasChanged
end