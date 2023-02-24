local DebugRenderScreen_UI = {}

local this = {}

function DebugRenderScreen_UI.DrawCanvas(visuals_circle, visuals_line, visuals_triangle, visuals_text)
    local width, height = this.GetScreenInfo()
    local center_x = width / 2
    local center_y = height / 2

    ImGui.SetNextWindowPos(0, 0, ImGuiCond.Always)
    ImGui.SetNextWindowSize(width, height, ImGuiCond.Always)

    if (ImGui.Begin("debug_canvas", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar + ImGuiWindowFlags.NoBackground)) then
        for _, triangle in ipairs(visuals_triangle) do
            local x1, y1 = this.TransformToScreen(triangle.x1, triangle.y1, center_x, center_y)
            local x2, y2 = this.TransformToScreen(triangle.x2, triangle.y2, center_x, center_y)
            local x3, y3 = this.TransformToScreen(triangle.x3, triangle.y3, center_x, center_y)
            this.Draw_Triangle(x1, y1, x2, y2, x3, y3, triangle.color, nil, nil)
        end

        for _, circle in ipairs(visuals_circle) do
            local x, y = this.TransformToScreen(circle.center_x, circle.center_y, center_x, center_y)
            this.Draw_Circle(x, y, circle.radius, circle.color_background, circle.color_border, circle.thickness)
        end

        for _, line in ipairs(visuals_line) do
            local x1, y1 = this.TransformToScreen(line.x1, line.y1, center_x, center_y)
            local x2, y2 = this.TransformToScreen(line.x2, line.y2, center_x, center_y)
            this.Draw_Line(x1, y1, x2, y2, line.color, line.thickness)
        end

        for _, text in ipairs(visuals_text) do
            local x, y = this.TransformToScreen(text.center_x, text.center_y, center_x, center_y)
            this.Draw_Text(x, y, text.text, text.color, text.color_back)
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

function this.Draw_Text(center_x, center_y, text, color, color_back)
    local width, height = ImGui.CalcTextSize(text, false, -1)
    local halfWidth = width / 2
    local halfHeight = height / 2

    if color_back then
        local roundCorners = this.Get_ImDrawFlags_RoundCornersAll()

        local margin_x = 10
        local margin_y = 2
        local cornerRadius = 2

        local left = center_x - halfWidth - margin_x
        local top = center_y - halfHeight - margin_y
        local right = center_x + halfWidth + margin_x
        local bottom = center_y + halfHeight + margin_y

        ImGui.ImDrawListAddRectFilled(ImGui.GetWindowDrawList(), left, top, right, bottom, color_back, cornerRadius, roundCorners)
    end

    ImGui.SetCursorPos(center_x - halfWidth, center_y - halfHeight)

    ImGui.PushStyleColor(ImGuiCol.Text, color)

    ImGui.Text(text)

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

function this.Get_ImDrawFlags_RoundCornersAll()
    -- // Flags for ImDrawList functions
    -- // (Legacy: bit 0 must always correspond to ImDrawFlags_Closed to be backward compatible with old API using a bool. Bits 1..3 must be unused)
    -- enum ImDrawFlags_
    -- {
    --     ImDrawFlags_None                        = 0,
    --     ImDrawFlags_Closed                      = 1 << 0, // PathStroke(), AddPolyline(): specify that shape should be closed (Important: this is always == 1 for legacy reason)
    --     ImDrawFlags_RoundCornersTopLeft         = 1 << 4, // AddRect(), AddRectFilled(), PathRect(): enable rounding top-left corner only (when rounding > 0.0f, we default to all corners). Was 0x01.
    --     ImDrawFlags_RoundCornersTopRight        = 1 << 5, // AddRect(), AddRectFilled(), PathRect(): enable rounding top-right corner only (when rounding > 0.0f, we default to all corners). Was 0x02.
    --     ImDrawFlags_RoundCornersBottomLeft      = 1 << 6, // AddRect(), AddRectFilled(), PathRect(): enable rounding bottom-left corner only (when rounding > 0.0f, we default to all corners). Was 0x04.
    --     ImDrawFlags_RoundCornersBottomRight     = 1 << 7, // AddRect(), AddRectFilled(), PathRect(): enable rounding bottom-right corner only (when rounding > 0.0f, we default to all corners). Wax 0x08.
    --     ImDrawFlags_RoundCornersNone            = 1 << 8, // AddRect(), AddRectFilled(), PathRect(): disable rounding on all corners (when rounding > 0.0f). This is NOT zero, NOT an implicit flag!
    --     ImDrawFlags_RoundCornersTop             = ImDrawFlags_RoundCornersTopLeft | ImDrawFlags_RoundCornersTopRight,
    --     ImDrawFlags_RoundCornersBottom          = ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersBottomRight,
    --     ImDrawFlags_RoundCornersLeft            = ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersTopLeft,
    --     ImDrawFlags_RoundCornersRight           = ImDrawFlags_RoundCornersBottomRight | ImDrawFlags_RoundCornersTopRight,
    --     ImDrawFlags_RoundCornersAll             = ImDrawFlags_RoundCornersTopLeft | ImDrawFlags_RoundCornersTopRight | ImDrawFlags_RoundCornersBottomLeft | ImDrawFlags_RoundCornersBottomRight,
    --     ImDrawFlags_RoundCornersDefault_        = ImDrawFlags_RoundCornersAll, // Default to ALL corners if none of the _RoundCornersXX flags are specified.
    --     ImDrawFlags_RoundCornersMask_           = ImDrawFlags_RoundCornersAll | ImDrawFlags_RoundCornersNone
    -- };

    return
        Bit_LShift(1, 4) +  -- ImDrawFlags_RoundCornersTopLeft
        Bit_LShift(1, 5) +  -- ImDrawFlags_RoundCornersTopRight
        Bit_LShift(1, 6) +  -- ImDrawFlags_RoundCornersBottomLeft
        Bit_LShift(1, 7)    -- ImDrawFlags_RoundCornersBottomRight
end

return DebugRenderScreen_UI