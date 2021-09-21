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
    --local numSegments = 13
    local numSegments = -1      -- < 0 is an auto calculate

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

    local ax1, ay1, ax2, ay2, ax3, ay3 = this.GetArrowCoords(x1, y1, x2, y2, arrow_length, arrow_width)
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

-- This shows a tooltip next to, but not touching x,y (based on no touch size)
-- style_tooltip is models\stylesheet\Tooltip
function Draw_Tooltip(text, style_tooltip, screen_x, screen_y, notouch_halfwidth, notouch_halfheight, vars_ui)
    -- This tells the parent window to use the standard titlebar color, even though it's not focused (because this
    -- tooltip steals focus).  The bool will get set to false each following frame
    vars_ui.isTooltipShowing = true

    local width, height = this.GetTooltip_Size(text, style_tooltip.max_width, style_tooltip.padding)

    local screen_left, screen_top = this.GetTooltip_Position(width, height, screen_x, screen_y, notouch_halfwidth, notouch_halfheight, vars_ui.screen)

    ImGui.PushStyleVar(ImGuiStyleVar.WindowRounding, style_tooltip.border_cornerRadius)
    ImGui.PushStyleVar(ImGuiStyleVar.WindowBorderSize, style_tooltip.border_thickness)

    ImGui.PushStyleColor(ImGuiCol.Text, style_tooltip.text_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.WindowBg, style_tooltip.back_color_abgr)
    ImGui.PushStyleColor(ImGuiCol.Border, style_tooltip.border_color_abgr)

    ImGui.SetNextWindowPos(screen_left, screen_top, ImGuiCond.Always)
    ImGui.SetNextWindowSize(width, height, ImGuiCond.Always)

    if (ImGui.Begin("tooltip", true, ImGuiWindowFlags.NoResize + ImGuiWindowFlags.NoMove + ImGuiWindowFlags.NoTitleBar + ImGuiWindowFlags.NoScrollbar)) then
        ImGui.SetCursorPos(style_tooltip.padding, style_tooltip.padding)
        ImGui.PushTextWrapPos(width - style_tooltip.padding)

        ImGui.Text(text)
    end
    ImGui.End()

    ImGui.PopStyleColor(3)

    ImGui.PopStyleVar(2)
end

----------------------------------- Private Methods -----------------------------------

function this.GetArrowCoords(x1, y1, x2, y2, length, width)
    local magnitude = GetVectorLength2D(x2 - x1, y2 - y1)

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

function this.GetTooltip_Size(text, max_width, padding)
    local width, height = ImGui.CalcTextSize(text, false, max_width)

    return
        width + (padding * 2),
        height + (padding * 2)
end

function this.GetTooltip_Position(width, height, x, y, notouch_halfwidth, notouch_halfheight, screen)
    -- Order of preference: Right, Left, Bottom, Top, else touch the no no zone
    local left, top
    left, top = this.GetTooltip_Position_RightLeft(width, height, x, y, notouch_halfwidth, screen)

    if not left then
        left, top = this.GetTooltip_Position_BottomTop(width, height, x, y, notouch_halfheight, screen)

        if not left then
            left, top = this.GetTooltip_Position_Covered(width, height, x, y, screen)
        end
    end

    return left, top
end

function this.GetTooltip_Position_RightLeft(width, height, x, y, notouch_halfwidth, screen)
    ----------- Left ----------
    -- Start to the right
    local left = x + notouch_halfwidth

    if left + width > screen.width then
        -- Right goes off the screen, try to the left
        left = x - notouch_halfwidth - width

        if left < 0 then
            -- It will cover either way.  The caller needs to try vertical displacement
            return nil, nil
        end
    end

    ----------- Top -----------
    -- Center it along y
    local top = y - (height / 2)

    if top + height > screen.height then
        -- Goes off the bottom of the screen.  If the tooltip is taller than the screen, the next if statement will fix it
        top = screen.height - height
    end

    if top < 0 then
        -- It will go off the screen, pull it down a bit
        top = 0
    end

    return left, top
end
function this.GetTooltip_Position_BottomTop(width, height, x, y, notouch_halfheight, screen)
    ----------- Top -----------
    -- Start below
    local top = y + notouch_halfheight

    if top + height > screen.height then
        -- Bottom goes off the screen, try above
        top = y - notouch_halfheight - height

        if top < 0 then
            -- It will cover either way.  The caller needs to try something else
            return nil, nil
        end
    end

    ----------- Left ----------
    -- Center it along y
    local left = x - (width / 2)
    if left < 0 then
        -- It will go off the screen, pull it down a bit
        left = 0
    end

    return left, top
end
function this.GetTooltip_Position_Covered(width, height, x, y, screen)
    local left = screen.width - width
    if left < 0 then
        left = 0
    end

    local top = y - (height / 2)
    if top < 0 then
        top = 0
    end

    return left, top
end