-- Draws a progress bar that vertically small (too small for embedded text)
-- def is models\viewmodels\ProgressBar_Slim
-- style_progress is models\stylesheet\ProgressBar_Slim
-- style_colors is models\stylesheet\Stylesheet.colors
function Draw_ProgressBarSlim(def, style_progress, style_colors, parent_width, parent_height, const)
    -- Calculate Position
	local left, top = GetControlPosition(def.position, def.width, style_progress.height, parent_width, parent_height, const)

    -- Draw the progress bar
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_progress.border_cornerRadius)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_progress.border_thickness)

    ImGui.PushStyleColor(ImGuiCol.Text, 0x00000000)     -- don't display text
    ImGui.PushStyleColor(ImGuiCol.Border, GetNamedColor(style_colors, def.border_color).the_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBg, GetNamedColor(style_colors, def.background_color).the_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.PlotHistogram, GetNamedColor(style_colors, def.foreground_color).the_color_abgr)

    ImGui.SetCursorPos(left, top)
    ImGui.PushItemWidth(def.width)

    ImGui.ProgressBar(def.percent, def.width, style_progress.height)

    ImGui.PopItemWidth()

    ImGui.PopStyleColor(4)
    ImGui.PopStyleVar(2)
end