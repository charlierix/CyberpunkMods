-- def is models\viewmodels\ProgressBar_Slim
-- style is models\stylesheet\Stylesheet
-- line_heights is models\misc\LineHeights
function CalcSize_ProgressBarSlim(def, style, const, line_heights, scale)
    def.render_pos.width = def.width * scale
    def.render_pos.height = style.progressbar_slim.height * scale
end

-- Draws a progress bar that vertically small (too small for embedded text)
-- def is models\viewmodels\ProgressBar_Slim
-- style_progress is models\stylesheet\ProgressBar_Slim
-- style_colors is models\stylesheet\Stylesheet.colors
function Draw_ProgressBarSlim(def, style_progress, style_colors, scale)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameRounding, style_progress.border_cornerRadius * scale)
    ImGui.PushStyleVar(ImGuiStyleVar.FrameBorderSize, style_progress.border_thickness)

    ImGui.PushStyleColor(ImGuiCol.Text, 0x00000000)     -- don't display text
    ImGui.PushStyleColor(ImGuiCol.Border, GetNamedColor(style_colors, def.border_color).the_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.FrameBg, GetNamedColor(style_colors, def.background_color).the_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.PlotHistogram, GetNamedColor(style_colors, def.foreground_color).the_color_abgr)

    ImGui.SetCursorPos(def.render_pos.left, def.render_pos.top)
    ImGui.PushItemWidth(def.width * scale)

    ImGui.ProgressBar(def.percent, def.width * scale, style_progress.height * scale)

    ImGui.PopItemWidth()

    ImGui.PopStyleColor(4)
    ImGui.PopStyleVar(2)
end