local DebugRenderScreen_UI = {}

local this = {}

function DebugRenderScreen_UI.DrawCanvas(visuals_circle, visuals_line, visuals_triangle)
    local width, height = this.GetScreenInfo()
    local center_x = width / 2
    local center_y = height / 2

    ImGui.SetNextWindowPos(0, 0, ImGuiCond.Always)
    ImGui.SetNextWindowSize(width, height, ImGuiCond.Always)

    if (ImGui.Begin("debug_canvas", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoBackground)) then
        for _, circle in ipairs(visuals_circle) do
            local x, y = this.TransformToScreen(circle.center_x, circle.center_y, center_x, center_y)
            this.Draw_Circle(x, y, circle.radius, circle.color_background, circle.color_border, circle.thickness)
        end

        for _, line in ipairs(visuals_line) do
            local x1, y1 = this.TransformToScreen(line.x1, line.y1, center_x, center_y)
            local x2, y2 = this.TransformToScreen(line.x2, line.y2, center_x, center_y)
            this.Draw_Line(x1, y1, x2, y2, line.color, line.thickness)
        end

        for _, triangle in ipairs(visuals_triangle) do
            local x1, y1 = this.TransformToScreen(triangle.x1, triangle.y1, center_x, center_y)
            local x2, y2 = this.TransformToScreen(triangle.x2, triangle.y2, center_x, center_y)
            local x3, y3 = this.TransformToScreen(triangle.x3, triangle.y3, center_x, center_y)
            this.Draw_Triangle(x1, y1, x2, y2, x3, y3, triangle.color, nil, nil)
        end
    end
    ImGui.End()
end

----------------------------------- Private Methods -----------------------------------

function this.Draw_Circle(center_x, center_y, radius, color_background, color_border, thickness)
    --local numSegments = 13
    local numSegments = -1      -- < 0 is an auto calculate

    if color_background then
        ImGui.ImDrawListAddCircleFilled(ImGui.GetWindowDrawList(), center_x, center_y, radius, color_background, numSegments)
    end

    if color_border then
        ImGui.ImDrawListAddCircle(ImGui.GetWindowDrawList(), center_x, center_y, radius, color_border, numSegments, thickness)
    end
end

function this.Draw_Line(x1, y1, x2, y2, color, thickness)
    ImGui.ImDrawListAddLine(ImGui.GetWindowDrawList(), x1, y1, x2, y2, color, thickness)
end

function this.Draw_Triangle(x1, y1, x2, y2, x3, y3, color_background, color_border, thickness)
    if color_background then
        ImGui.ImDrawListAddTriangleFilled(ImGui.GetWindowDrawList(), x1, y1, x2, y2, x3, y3, color_background)
    end

    if color_border then
        ImGui.ImDrawListAddTriangle(ImGui.GetWindowDrawList(), x1, y1, x2, y2, x3, y3, color_border, thickness)
    end
end

function this.Draw_Text(center_x, center_y, text, color)
    local width, height = ImGui.CalcTextSize(text, false, -1)

    ImGui.PushStyleColor(ImGuiCol.Text, color)





    ImGui.PopStyleColor(1)
end

-- Looks like scale isn't needed.  Everything draws fine without multiplying by it
---@return integer screen_width, integer screen_height --, number scale
function this.GetScreenInfo()
    local width, height = GetDisplayResolution()
    --local line_height = ImGui.GetTextLineHeight()

    return
        width,
        height--,
        --line_height / 18        -- it's 18 at a 1:1 scale, 36 on 4k (scale of 2)
end

function this.TransformToScreen(x, y, screen_half_x, screen_half_y)
    return
        screen_half_x + (x * screen_half_x),        -- just assuming that it's normalized -1 to 1.  Need to test if it depends on aspect ratio
        screen_half_y + (-y * screen_half_y)
end

return DebugRenderScreen_UI