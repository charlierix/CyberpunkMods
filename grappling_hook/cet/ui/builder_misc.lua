-- Places an invisible button so that mouse events can be detected
-- TODO: CET is currently suppressing ImGui's LeftMouseDown.  When that changes, add that as a return (if it's absolutely needed, maybe get it from Observe("PlayerPuppet", "OnAction"))
-- Returns:
--  isClicked
--  isHovered
function Draw_InvisibleButton(name, center_x, center_y, width, height, padding)
    -- Don't want to go all the way to the edge of the padding
    padding = padding * 0.667

    local left = center_x - (width / 2)
    local top = center_y - (height / 2)

    ImGui.SetCursorPos(left - padding, top - padding)

    local isClicked = ImGui.InvisibleButton(name, width + (padding * 2), height + (padding * 2))
    --local isClicked = ImGui.InvisibleButton("MouseObserver", width + (padding * 2), height + (padding * 2))       -- the name must be unique (not sure if across all windows)

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