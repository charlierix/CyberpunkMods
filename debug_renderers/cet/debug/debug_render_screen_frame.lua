local DebugRenderScreen_Frame = {}

local MIN_SIZE = 0.05                -- don't bother drawing items smaller than this
local DOT_RADIUS = 18
local LINE_THICKNESS = 2
local THICKNESS_EPSILON = 0.5
local LINE_DIST_EPSILON = 0.05      -- this is world distance, it tells when to stop trying smaller line splits
local MAX_RECURSE_VV = 4
local MAX_RECURSE_VI = 8

local this = {}

-- Looks at the high level 3D items, creates 2D circles/lines/triangles that will be shown in the draw event
function DebugRenderScreen_Frame.RebuildVisuals(controller, items, item_types, visuals_circle, visuals_line, visuals_triangle, visuals_text)
    this.ClearVisuals(visuals_circle, visuals_line, visuals_triangle, visuals_text)

    if not controller or #items == 0 then      -- controller should always be populated (unless there's a reload cet mods, then loading a prevous save is required)
        do return end
    end

    local pos, dir = Game.GetTargetingSystem():GetDefaultCrosshairData(Game.GetPlayer())

    for _, item in ipairs(items) do
        if item.item_type == item_types.dot then
            this.Dot(controller, item, visuals_circle, pos)

        elseif item.item_type == item_types.line then
            this.Line(controller, item, visuals_line, pos, dir)

        elseif item.item_type == item_types.triangle then
            this.Triangle(controller, item, visuals_triangle, pos, dir)

        elseif item.item_type == item_types.text then
            this.Text(controller, item, visuals_text)
        end
    end
end

-------------------------------- Private Methods (Dot) --------------------------------

function this.Dot(controller, item, visuals_circle, pos)
    local point = controller:ProjectWorldToScreen(item.position)

    if not this.IsValidScreenPoint(point) then
        do return end
    end

    local size_mult = this.GetSizeMult(item, pos, item.position)
    if not size_mult then
        do return end
    end

    local radius = DOT_RADIUS * size_mult
    if radius * 2 < MIN_SIZE then
        do return end
    end

    local visual =
    {
        color_background = this.GetColor_ABGR(item.color_back),
        color_border = nil,
        thickness = nil,
        center_x = point.X,
        center_y = point.Y,
        radius = DOT_RADIUS * size_mult,
    }

    table.insert(visuals_circle, visual)
end

-------------------------------- Private Methods (Line) -------------------------------

function this.Line(controller, item, visuals_line, pos, dir)
    local point1 = controller:ProjectWorldToScreen(item.point1)
    local isValid1 = this.IsValidScreenPoint(point1)

    local point2 = controller:ProjectWorldToScreen(item.point2)
    local isValid2 = this.IsValidScreenPoint(point2)

    if not isValid1 and not isValid2 then
        if DotProduct3D(dir, SubtractVectors(item.point1, pos)) < 0 and DotProduct3D(dir, SubtractVectors(item.point2, pos)) < 0 then
            do return end       -- both points are behind the camera
        end

        -- There's a chance that one point is way to the left and the other is way to the right.  Try one more
        -- time with the midpoint.  It's not perfect, but it's better than giving up immediately
        local point3D_mid = GetMidPoint(item.point1, item.point2)
        local point2D_mid = controller:ProjectWorldToScreen(point3D_mid)
        if this.IsValidScreenPoint(point2D_mid) then
            this.Line_Valid_Invalid(point3D_mid, item.point1, point2D_mid, controller, item, visuals_line, pos, 0)
            this.Line_Valid_Invalid(point3D_mid, item.point2, point2D_mid, controller, item, visuals_line, pos, 0)
        end

    elseif not isValid1 then
        this.Line_Valid_Invalid(item.point2, item.point1, point2, controller, item, visuals_line, pos, 0)

    elseif not isValid2 then
        this.Line_Valid_Invalid(item.point1, item.point2, point1, controller, item, visuals_line, pos, 0)

    else
        this.Line_Valid_Valid(item.point1, item.point2, point1, point2, controller, item, visuals_line, pos, nil, nil, 0)
    end
end

-- thickness params are optional
function this.Line_Valid_Valid(point3D_1, point3D_2, point2D_1, point2D_2, controller, item, visuals_line, pos, thickness1, thickness2, recurse_count)
    if not thickness1 then
        thickness1 = LINE_THICKNESS * this.GetSizeMult(item, pos, point3D_1)
    end

    if not thickness2 then
        thickness2 = LINE_THICKNESS * this.GetSizeMult(item, pos, point3D_2)
    end

    if thickness1 < MIN_SIZE and thickness2 < MIN_SIZE then
        do return end
    end

    if math.abs(thickness1 - thickness2) <= THICKNESS_EPSILON or recurse_count > MAX_RECURSE_VV then
        this.Line_Commit(item, visuals_line, point2D_1, point2D_2, thickness1, thickness2)
        do return end
    end

    local point3D_mid = GetMidPoint(point3D_1, point3D_2)
    local point2D_mid = controller:ProjectWorldToScreen(point3D_mid)

    -- Recurse
    this.Line_Valid_Valid(point3D_1, point3D_mid, point2D_1, point2D_mid, controller, item, visuals_line, pos, thickness1, nil, recurse_count + 1)
    this.Line_Valid_Valid(point3D_2, point3D_mid, point2D_2, point2D_mid, controller, item, visuals_line, pos, thickness2, nil, recurse_count + 1)
end

function this.Line_Valid_Invalid(point3D_valid, point3D_invalid, point2D_valid, controller, item, visuals_line, pos, recurse_count)
    if recurse_count > MAX_RECURSE_VI then
        do return end
    end

    if not this.IsValidScreenPoint(point2D_valid) then
        do return end       -- no need to refine further, this line is starting off screen
    end

    local dist_sqr = GetVectorDiffLengthSqr(point3D_valid, point3D_invalid)
    if dist_sqr < LINE_DIST_EPSILON * LINE_DIST_EPSILON then
        do return end
    end

    local point3D_mid = GetMidPoint(point3D_valid, point3D_invalid)
    local point2D_mid = controller:ProjectWorldToScreen(point3D_mid)

    if this.IsValidScreenPoint(point2D_mid) then
        this.Line_Valid_Valid(point3D_valid, point3D_mid, point2D_valid, point2D_mid, controller, item, visuals_line, pos, nil, nil, 0)
        this.Line_Valid_Invalid(point3D_mid, point3D_invalid, point2D_mid, controller, item, visuals_line, pos, recurse_count + 1)
    else
        this.Line_Valid_Invalid(point3D_valid, point3D_mid, point2D_valid, controller, item, visuals_line, pos, recurse_count + 1)
    end
end

function this.Line_Commit(item, visuals_line, point2D_1, point2D_2, thickness1, thickness2)
    local thickness = LERP(thickness1, thickness2, 0.5)
    if thickness < MIN_SIZE then
        do return end
    end

    local visual =
    {
        x1 = point2D_1.X,
        y1 = point2D_1.Y,
        x2 = point2D_2.X,
        y2 = point2D_2.Y,
        color = this.GetColor_ABGR(item.color_fore),
        thickness = thickness,
    }

    table.insert(visuals_line, visual)
end

------------------------------ Private Methods (Triangle) -----------------------------

function this.Triangle(controller, item, visuals_triangle, pos, dir)
    local point1 = controller:ProjectWorldToScreen(item.point1)
    local isValid1 = this.IsValidScreenPoint(point1)

    local point2 = controller:ProjectWorldToScreen(item.point2)
    local isValid2 = this.IsValidScreenPoint(point2)

    local point3 = controller:ProjectWorldToScreen(item.point3)
    local isValid3 = this.IsValidScreenPoint(point3)

    --TODO: handle partial off screen
    --ImGui supports a polygon, but it takes an array of vector2 and I think cet handles that funny

    if isValid1 and isValid2 and isValid3 then
        local visual =
        {
            x1 = point1.X,
            y1 = point1.Y,
            x2 = point2.X,
            y2 = point2.Y,
            x3 = point3.X,
            y3 = point3.Y,
            color = this.GetColor_ABGR(item.color_back),
        }

        table.insert(visuals_triangle, visual)
    end
end

-------------------------------- Private Methods (Text) -------------------------------

function this.Text(controller, item, visuals_text)
    local point = controller:ProjectWorldToScreen(item.center)

    if not this.IsValidScreenPoint(point) then
        do return end
    end

    local color_back = nil
    if item.color_back then
        color_back = this.GetColor_ABGR(item.color_back)
    end

    local visual =
    {
        center_x = point.X,
        center_y = point.Y,
        color = this.GetColor_ABGR(item.color_fore),
        color_back = color_back,
        text = item.text,
    }

    table.insert(visuals_text, visual)
end

----------------------------------- Private Methods -----------------------------------

function this.ClearVisuals(visuals_circle, visuals_line, visuals_triangle, visuals_text)
    while #visuals_circle > 0 do
        table.remove(visuals_circle, 1)
    end

    while #visuals_line > 0 do
        table.remove(visuals_line, 1)
    end

    while #visuals_triangle > 0 do
        table.remove(visuals_triangle, 1)
    end

    while #visuals_text > 0 do
        table.remove(visuals_text, 1)
    end
end

function this.GetColor_ABGR(color)
    if not color then
        local magenta = ConvertHexStringToNumbers_Magenta()
        return magenta
    end

    local _, color_abgr = ConvertHexStringToNumbers(color)
    return color_abgr
end

function this.GetSizeMult(item, pos, point)
    local size_mult = 1
    if item.size_mult then
        size_mult = item.size_mult
    end

    local perspective_mult = 1
    if not item.const_size then
        perspective_mult = this.GetPerspectiveMult(pos, point)
        if not perspective_mult then
            return nil
        end
    end

    return size_mult * perspective_mult
end

function this.GetPerspectiveMult(pos, test_point)
    local dist_sqr = GetVectorDiffLengthSqr(pos, test_point)
    if IsNearZero(dist_sqr) then
        return 144
    end

    return 1 / math.sqrt(dist_sqr)
end

function this.IsOnScreen(point2D)
    if not this.IsValidScreenPoint(point2D) then
        return false
    else
        return math.abs(point2D.X) <= 1 and math.abs(point2D.Y) <= 1
    end
end
function this.IsValidScreenPoint(point2D)
    -- if not point or not point.X or not point.Y then      -- should never get nil
    --     return false

    if math.abs(point2D.X) > 9 or math.abs(point2D.Y) > 9 then
        -- Any value over 1 is off screen, but it's useful for lines that end off screen.  The number can get
        -- larger, but lines between on screen and way off screen were jerking around (probably some kind of
        -- fishbowl effect)
        return false

    elseif (point2D.X == -1 or point2D.X == 1) and (point2D.Y == -1 or point2D.Y == 1) then
        return false

    else
        return true
    end
end

return DebugRenderScreen_Frame