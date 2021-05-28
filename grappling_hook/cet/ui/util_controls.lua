local this = {}

-- Places an invisible button so that mouse events can be detected
-- TODO: CET is currently suppressing ImGui's LeftMouseDown.  When that changes, add that as a return (if it's absolutely needed, maybe get it from Observe("PlayerPuppet", "OnAction"))
-- NOTE: Each InvisibleButton within a window needs a unique name
-- Returns:
--  isClicked
--  isHovered
function Draw_InvisibleButton(name, center_x, center_y, width, height, padding)
    -- Don't want to go all the way to the edge of the padding
    padding = padding * 0.667

    local left = center_x - (width / 2)
    local top = center_y - (height / 2)

    ImGui.SetCursorPos(left - padding, top - padding)

    local isClicked = ImGui.InvisibleButton(name, width + (padding * 2), height + (padding * 2))        --NOTE: name needs to be unique within the window or isClicked won't work

    local isHovered = ImGui.IsItemHovered()

    return isClicked, isHovered
end

-- Draws a rounded border and background (each color is optional, will only draw that portion
-- if non nil)
-- The colors are single integers of the form: 0xFF4488CC (hex of argb)
-- Params:
-- screenOffset_x, screenOffset_y = the parent's left,top in screen coords
-- center_x, center_y = the center of the border in parent coords
-- width, height = the size of the content portion
-- padding = distance around the content portion
-- isHovered = whether the mouse is currently over this border
-- color_back_standard, color_back_hovered = background color
-- color_border_standard, color_border_hovered = border color
-- cornerRadius = 0 is rectangle
-- thickness = pen width of the border line
function Draw_Border(screenOffset_x, screenOffset_y, center_x, center_y, width, height, padding, isHovered, color_back_standard, color_back_hovered, color_border_standard, color_border_hovered, cornerRadius, thickness)
    local roundCorners = Get_ImDrawFlags_RoundCornersAll()

    local halfWidth = width / 2
    local halfHeight = height / 2
    local left = screenOffset_x + center_x - halfWidth - padding
    local top = screenOffset_y + center_y - halfHeight - padding
    local right = screenOffset_x + center_x + halfWidth + padding
    local bottom = screenOffset_y + center_y + halfHeight + padding

    local background = nil
    local border = nil
    if isHovered then
        background = color_back_hovered
        border = color_border_hovered
    else
        background = color_back_standard
        border = color_border_standard
    end

    if background then
        ImGui.ImDrawListAddRectFilled(ImGui.GetWindowDrawList(), left, top, right, bottom, background, cornerRadius, roundCorners)
    end

    if border then
        ImGui.ImDrawListAddRect(ImGui.GetWindowDrawList(), left, top, right, bottom, border, cornerRadius, roundCorners, thickness)
    end
end

--NOTE: This needs ABGR
function Draw_Circle(screenOffset_x, screenOffset_y, center_x, center_y, radius, isHovered, color_back_standard, color_back_hovered, color_border_standard, color_border_hovered, thickness)
    -- TODO: Calculate based on radius, have a min and max
    local numSegments = 12

    local background = nil
    local border = nil
    if isHovered then
        background = color_back_hovered
        border = color_border_hovered
    else
        background = color_back_standard
        border = color_border_standard
    end

    if background then
        ImGui.ImDrawListAddCircleFilled(ImGui.GetWindowDrawList(), screenOffset_x + center_x, screenOffset_y + center_y, radius, background, numSegments)
    end

    if border then
        ImGui.ImDrawListAddCircle(ImGui.GetWindowDrawList(), screenOffset_x + center_x, screenOffset_y + center_y, radius, border, numSegments, thickness)
    end
end

--TODO: Make an overload that draws a dashed line.  That functionality isn't native, so it would be a for loop drawing little sub lines
function Draw_Line(screenOffset_x, screenOffset_y, x1, y1, x2, y2, color, thickness)
    ImGui.ImDrawListAddLine(ImGui.GetWindowDrawList(), screenOffset_x + x1, screenOffset_y + y1, screenOffset_x + x2, screenOffset_y + y2, color, thickness)
end

-- Draws a line, and an arrow at the x2,y2 position (arrow from 1 to 2)
function Draw_Arrow(screenOffset_x, screenOffset_y, x1, y1, x2, y2, color, thickness, arrow_length, arrow_width)
    Draw_Line(screenOffset_x, screenOffset_y, x1, y1, x2, y2, color, thickness)

    local ax1, ay1, ax2, ay2, ax3, ay3 = GetArrowCoords(x1, y1, x2, y2, arrow_length, arrow_width)
    Draw_Triangle(screenOffset_x, screenOffset_y, ax1, ay1, ax2, ay2, ax3, ay3, color, nil, nil)
end

function Draw_Triangle(screenOffset_x, screenOffset_y, x1, y1, x2, y2, x3, y3, color_back, color_border, thickness)
    if color_back then
        ImGui.ImDrawListAddTriangleFilled(ImGui.GetWindowDrawList(), screenOffset_x + x1, screenOffset_y + y1, screenOffset_x + x2, screenOffset_y + y2, screenOffset_x + x3, screenOffset_y + y3, color_back)
    end

    if color_border then
        ImGui.ImDrawListAddTriangle(ImGui.GetWindowDrawList(), screenOffset_x + x1, screenOffset_y + y1, screenOffset_x + x2, screenOffset_y + y2, screenOffset_x + x3, screenOffset_y + y3, color_border, thickness)
    end
end

----------------------------------- Private Methods -----------------------------------

function GetArrowCoords(x1, y1, x2, y2, length, width)
    local magnitude = Get2DLength(x2 - x1, y2 - y1)

    -- Get a unit vector that points from the to point back to the base of the arrow head
    local baseDir_x = (x1 - x2) / magnitude
    local baseDir_y = (y1 - y2) / magnitude

    -- Now get two unit vectors that point from the shaft out to the tips
    local edgeDir1_x = -baseDir_y
    local edgeDir1_y = baseDir_x

    local edgeDir2_x = baseDir_y
    local edgeDir2_y = -baseDir_x

    -- Get the point at the base of the arrow that is on the shaft
    local base_x = x2 + (baseDir_x * length)
    local base_y = y2 + (baseDir_y * length)

    local halfWidth = width / 2

    return
        x2,     -- arrow tip
        y2,
        base_x + (edgeDir1_x * halfWidth),      -- base point 1
        base_y + (edgeDir1_y * halfWidth),
        base_x + (edgeDir2_x * halfWidth),      -- base point 2
        base_y + (edgeDir2_y * halfWidth)
end