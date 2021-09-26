local RECORDING_TEXT = "Recording"
local GAP_CIRCLETEXT = 18
local RADIUS_MULT = 0.66      -- difference is radius vs the text's height
local GAP_BOTTOMWINDOW = 42
local PADDING = 12
local SHADOW_OFFSET = 2
local FONT_SCALE = 4

local this = {}
local sizes = nil

function DrawRecording()
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

    ImGui.SetNextWindowPos(left, top, ImGuiCond.Always)
    ImGui.SetNextWindowSize(width, height, ImGuiCond.Always)

    if (ImGui.Begin("energy", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoBackground)) then
        ImGui.SetWindowFontScale(FONT_SCALE)

        if not sizes then
            sizes = this.GetSizes()     -- need to wait until after the font scale was set
        end

        -- Circle
        local back_abgr, border_abgr = this.GetCircleColors()
        Draw_Circle(left, top, sizes.circle_center_x, sizes.circle_center_y, sizes.cirle_radius, false, back_abgr, nil, border_abgr, nil, 1)

        -- Text Shadow
        local color_shadow = 0xFF000000

        ImGui.PushStyleColor(ImGuiCol.Text, color_shadow)

        ImGui.SetCursorPos(sizes.text_left - SHADOW_OFFSET, sizes.text_top - SHADOW_OFFSET)
        ImGui.Text(RECORDING_TEXT)

        ImGui.SetCursorPos(sizes.text_left + SHADOW_OFFSET, sizes.text_top - SHADOW_OFFSET)
        ImGui.Text(RECORDING_TEXT)

        ImGui.SetCursorPos(sizes.text_left + SHADOW_OFFSET, sizes.text_top + SHADOW_OFFSET)
        ImGui.Text(RECORDING_TEXT)

        ImGui.SetCursorPos(sizes.text_left - SHADOW_OFFSET, sizes.text_top + SHADOW_OFFSET)
        ImGui.Text(RECORDING_TEXT)

        ImGui.PopStyleColor()

        -- Text Foreground
        local color_fore = 0xFFFFFFFF

        ImGui.PushStyleColor(ImGuiCol.Text, color_fore)

        ImGui.SetCursorPos(sizes.text_left, sizes.text_top)
        ImGui.Text(RECORDING_TEXT)

        ImGui.PopStyleColor()
    end
    ImGui.End()

end

------------------------- Private Methods --------------------------

function this.GetSizes()
    local screen_width, screen_height = GetDisplayResolution()

    local text_width, text_height = ImGui.CalcTextSize(RECORDING_TEXT)

    local radius = (text_height / 2) * RADIUS_MULT

    local text_left = PADDING + (radius * 2) + GAP_CIRCLETEXT

    local width = text_left + text_width + (PADDING * 2)
    local height = math.max(radius * 2, text_height) + (PADDING * 2)

    return
    {
        screen_width = screen_width,
        screen_height = screen_height,

        left = (screen_width / 2) - (width / 2),
        top = screen_height - GAP_BOTTOMWINDOW - height,
        width = width,
        height = height,

        circle_center_x = PADDING + radius,
        circle_center_y = (height / 2),
        cirle_radius = radius,

        text_left = text_left,
        text_top = (height / 2) - (text_height / 2),
    }
end

function this.GetCircleColors()
    return 0xFF0000FF, 0xFFFFFFFF
end