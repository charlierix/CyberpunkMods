local this = {}

local hint = "ctrl+click to type"

-- Shows a slider.  The value is persisted in def.value
-- def is models\viewmodels\Slider
-- style_slider is models\stylesheet\Slider
-- Returns
--  wasChanged, isHovered
function Draw_Slider(def, style_slider, parent_width, parent_height, const, line_heights)
	-- Calculate Size
	local width = def.width
	local height = line_heights.line + 11       -- just counted pixels

    -- Calculate Position
	local left, top = GetControlPosition(def.position, width, height, parent_width, parent_height, const)

    -- Draw the slider
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_slider.border_cornerRadius)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_slider.border_thickness)

    ImGui.PushStyleColor(ImGuiCol.Border, style_slider.border_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.Text, style_slider.foreground_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBg, style_slider.background_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBgHovered, style_slider.background_color_hover_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBgActive, style_slider.background_color_click_abgr)
    ImGui.PushStyleColor(ImGuiCol.SliderGrab, style_slider.grab_color_standard_abgr)
    ImGui.PushStyleColor(ImGuiCol.SliderGrabActive, style_slider.grab_color_click_abgr)
    ImGui.PushStyleColor(ImGuiCol.TextSelectedBg, style_slider.highlight_text_background_color_abgr)       -- this is when they ctrl+click

    ImGui.SetCursorPos(left, top)

    ImGui.PushItemWidth(width)

    local changed
    def.value, changed = ImGui.SliderFloat("##" .. def.invisible_name, def.value, def.min, def.max, this.GetFormat(def), Get_ImGuiSliderFlags_AlwaysClamp_NoRoundToFormat())

    ImGui.PopItemWidth()

    ImGui.PopStyleColor(8)
    ImGui.PopStyleVar(2)

    -- Invisible Button
    local _, isHovered = Draw_InvisibleButton(def.invisible_name .. "Hidden", left + (width / 2), top + (height / 2), width, height, 0)

    --TODO: hint text on hover
    --TODO: take in isHovered to see where to place the hint

    return changed, isHovered
end

----------------------------------- Private Methods -----------------------------------

function this.GetFormat(def)
    local decimal = ""
    if def.decimal_places > 0 then
        decimal = tostring(def.decimal_places)
    end

    local prefix = def.prefix
    if not prefix then
        prefix = ""
    end

    local suffix = def.suffix
    if not suffix then
        suffix = ""
    end

    return prefix .. "%." .. decimal .. "f" .. suffix
end