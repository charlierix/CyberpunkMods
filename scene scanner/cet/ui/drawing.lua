local this = {}
local sizes = nil

function DrawRecording(o, vars_ui, recording_start_time)
    local left = 0
    local top = 0
    local width = 100
    local height = 20
    if sizes then
        left = sizes.left
        top = sizes.top
        width = sizes.width
        height = sizes.height
    end

    local style = vars_ui.style.recording

    ImGui.SetNextWindowPos(left, top, ImGuiCond.Always)
    ImGui.SetNextWindowSize(width, height, ImGuiCond.Always)

    if (ImGui.Begin("energy", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoBackground)) then
        ImGui.SetWindowFontScale(style.font_scale)

        if not sizes then
            sizes = this.GetSizes(style)     -- need to wait until after the font scale was set
        end

        -- Circle
        local back_abgr, border_abgr = this.GetCircleColors(o.timer - recording_start_time, style)
        Draw_Circle(left, top, sizes.circle_center_x, sizes.circle_center_y, sizes.cirle_radius, false, back_abgr, nil, border_abgr, nil, style.circle_border_thickness)

        -- Text Shadow
        ImGui.PushStyleColor(ImGuiCol.Text, style.shadow_color_abgr)

        ImGui.SetCursorPos(sizes.text_left - style.shadow_offset, sizes.text_top - style.shadow_offset)
        ImGui.Text(style.text)

        ImGui.SetCursorPos(sizes.text_left + style.shadow_offset, sizes.text_top - style.shadow_offset)
        ImGui.Text(style.text)

        ImGui.SetCursorPos(sizes.text_left + style.shadow_offset, sizes.text_top + style.shadow_offset)
        ImGui.Text(style.text)

        ImGui.SetCursorPos(sizes.text_left - style.shadow_offset, sizes.text_top + style.shadow_offset)
        ImGui.Text(style.text)

        ImGui.PopStyleColor()

        -- Text Foreground
        ImGui.PushStyleColor(ImGuiCol.Text, style.text_color_abgr)

        ImGui.SetCursorPos(sizes.text_left, sizes.text_top)
        ImGui.Text(style.text)

        ImGui.PopStyleColor()
    end
    ImGui.End()
end

------------------------- Private Methods --------------------------

function this.GetSizes(style)
    local screen_width, screen_height = GetDisplayResolution()

    local text_width, text_height = ImGui.CalcTextSize(style.text)

    local radius = (text_height / 2) * style.radius_mult

    local text_left = style.padding + (radius * 2) + style.gap_circletext

    local width = text_left + text_width + (style.padding * 2)
    local height = math.max(radius * 2, text_height) + (style.padding * 2)

    return
    {
        screen_width = screen_width,
        screen_height = screen_height,

        left = (screen_width / 2) - (width / 2),
        top = screen_height - style.gap_bottomwindow - height,
        width = width,
        height = height,

        circle_center_x = style.padding + radius,
        circle_center_y = (height / 2),
        cirle_radius = radius,

        text_left = text_left,
        text_top = (height / 2) - (text_height / 2),
    }
end

-- Returns back color, border color
function this.GetCircleColors(elapsed, style)
    local percent = 0.5 + math.cos((2 * math.pi * elapsed) / style.strobe_duration) * -0.5

    local back_a, back_r, back_g, back_b = ColorLERP_FromStyleSheet(style, "circle_color_dark_back", "circle_color_bright_back", percent)
    local border_a, border_r, border_g, border_b = ColorLERP_FromStyleSheet(style, "circle_color_dark_border", "circle_color_bright_border", percent)

    return
        ToABGR(back_a, back_r, back_g, back_b),
        ToABGR(border_a, border_r, border_g, border_b)
end