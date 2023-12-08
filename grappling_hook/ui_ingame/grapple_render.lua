-- This is a copy of debug_render_screen.lua, but with different external functions that are hardcoded for drawing
-- stuff for grapple

local frame = require "ui_ingame/grapple_render_frame"
local ui = require "ui_ingame/grapple_render_ui"

local GrappleRender = {}

local this = {}

local next_id = 0
local timer = 0
local item_types = CreateEnum("dot", "diamond", "line", "triangle", "text")

local controller = nil

local items = StickyList:new()
local visuals_circle = StickyList:new()
local visuals_diamond = StickyList:new()
local visuals_line = StickyList:new()
local visuals_triangle = StickyList:new()
local visuals_text = StickyList:new()

local line_starttime = nil
local line_duration = nil
-- Each item in this list has these props.  These points control a bezier.  Using functions like this instead of positions and
-- velocities because it's easy to calculate as time marches on.  Not as realistic, but the whole animation will run very fast
-- while moving away from the player, so good enough
--
-- time goes from 0 to 1
-- radius = (1 - time) * decay^time * height * cos(pi/2 * time * speed)
-- along = (1 - time) * decay^time * height * sin(pi/2 * time * speed)

-- radius_decay
-- radius_height
-- radius_speed
-- radius_radians
-- along_decay
-- along_height
-- along_speed
-- along_percent    percent along the spread
local line_controlpoints = StickyList:new()
local line_points_spread = nil
local line_controlpoints_forbezier = nil
--local line_log = nil

local endplane_id = nil
local endplane_recalc_distsqr = nil
local endplane_pos = nil
local endplane_normal = nil
local endplane_visuals = nil

local anchor_id = nil

local up = nil

--------------------------------- Called From Events ----------------------------------

function GrappleRender.CallFrom_onInit()
    --NOTE: There may be a better controller to use.  Chose this because it seems to run every time
    --If you reload all mods from cet console, you will need to load a save for this event to fire again
    Observe("CrosshairGameController_NoWeapon", "OnInitialize", function(obj)
        controller = obj        -- this is an instance of CrosshairGameController_NoWeapon which extends worlduiIWidgetGameController, which has ProjectWorldToScreen()
    end)
end

-- It's up to the caller to only call update/draw in valid conditions (not in menus or workspots, not shutdown)

function GrappleRender.CallFrom_onUpdate(o, deltaTime)
    timer = timer + deltaTime

    -- Remove items that have exceeded lifespan_seconds
    this.RemoveExpiredItems()

    if endplane_recalc_distsqr then
        local dist_sqr = GetVectorDiffLengthSqr(o.pos, endplane_pos)
        if dist_sqr < endplane_recalc_distsqr then
            GrappleRender.EndPlane(endplane_pos, endplane_normal, endplane_visuals)
        end
    end

    -- Go through items and populate visuals (only items that are in front of the camera).  Turns high level concepts
    -- like circle/square into line paths that match this frame's perspective
    frame.RebuildVisuals(controller, items, item_types, visuals_circle, visuals_diamond, visuals_line, visuals_triangle, visuals_text)
end

function GrappleRender.CallFrom_onDraw()
    if visuals_circle:GetCount() == 0 and visuals_diamond:GetCount() == 0 and visuals_line:GetCount() == 0 and visuals_triangle:GetCount() == 0 and visuals_text:GetCount() == 0 then
        do return end
    end

    ui.DrawCanvas(visuals_circle, visuals_diamond, visuals_line, visuals_triangle, visuals_text)
end

----------------------------------- Public Methods ------------------------------------

function GrappleRender.StraightLine_INSTANT(from, to, visuals, const)
    if visuals.grappleline_type == const.Visuals_GrappleLine_Type.solid_line then
        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, visuals.grappleline_color_primary, 4, nil, nil, true)
        item.point1 = from
        item.point2 = to

    else
        LogError("Unknown Visuals_GrappleLine_Type: " .. tostring(visuals.grappleline_type))
    end
end

function GrappleRender.StraightLine(from, to, visuals, const)
    if visuals.grappleline_type == const.Visuals_GrappleLine_Type.solid_line then
        this.SolidLine(from, to, visuals, const)
    else
        LogError("Unknown Visuals_GrappleLine_Type: " .. tostring(visuals.grappleline_type))
    end
end


function GrappleRender.EndPlane(pos, normal, visuals)
    if endplane_id then
        this.Remove(endplane_id)
        endplane_id = nil
    end

    if not visuals.show_stopplane then
        do return end
    end

    local id, distance = this.Add_Circle(pos, normal, 0.333, visuals.stopplane_color)

    local recalc_dist = distance * 0.5
    if recalc_dist < 1 then
        recalc_dist = nil
    end

    endplane_id = id
    if recalc_dist then
        endplane_recalc_distsqr = recalc_dist * recalc_dist
    else
        endplane_recalc_distsqr = nil
    end

    endplane_pos = pos
    endplane_normal = normal
    endplane_visuals = visuals
end

function GrappleRender.AnchorPoint(pos, visuals, const)
    if anchor_id then
        this.Remove(anchor_id)
        anchor_id = nil
    end

    if visuals.anchorpoint_type == const.Visuals_AnchorPoint_Type.none then
        do return end
    end

    anchor_id = this.GetNextID()

    this.Add_Dot(pos, visuals.anchorpoint_color_1, nil, nil, false, 0.25, nil, true, anchor_id)

    if visuals.anchorpoint_type == const.Visuals_AnchorPoint_Type.diamond then
        this.Add_Diamond(pos, visuals.anchorpoint_color_2, nil, false, 1.5, 0.08, true, anchor_id)

    elseif visuals.anchorpoint_type == const.Visuals_AnchorPoint_Type.circle then
        this.Add_Dot(pos, nil, visuals.anchorpoint_color_2, nil, false, 1.5, 0.08, true, anchor_id)

    else
        LogError("Unknown visuals.anchorpoint_type: " .. tostring(visuals.anchorpoint_type))
        do return end
    end
end

-- Removes all visual items (doesn't remove categories)
function GrappleRender.Clear()
    items:Clear()

    line_starttime = nil
    line_controlpoints:Clear()
    line_controlpoints_forbezier = nil

    endplane_id = nil
    endplane_recalc_distsqr = nil
    endplane_pos = nil
    endplane_normal = nil
    endplane_visuals = nil

    anchor_id = nil
end

function GrappleRender.GetGrappleFrom(eye_pos, look_dir)
    local OFFSET_HORZ = 0.075
    local OFFSET_VERT = -0.2

    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    local right = CrossProduct3D(look_dir, up)
    local forward = CrossProduct3D(up, right)

    return Vector4.new(eye_pos.x + forward.x * OFFSET_HORZ, eye_pos.y + forward.y * OFFSET_HORZ, eye_pos.z + OFFSET_VERT, 1)
end

----------------------------- Private Methods (solid line) ----------------------------

function this.SolidLine(from, to, visuals, const)
    if not line_starttime then
        this.Initialize_SolidLine_Bezier(from, to)
        --this.Initialize_SolidLine_Log()
    end

    local elapsed = timer - line_starttime

    if elapsed < line_duration then
        this.SolidLine_Bezier(from, to, visuals, elapsed / line_duration, const)
    else
        -- The bezier has travelled, just draw a straight line
        -- if line_log then
        --     line_log:Save("line animation")
        --     line_log = nil
        -- end

        this.SolidLine_Add(from, to, visuals)
    end
end

function this.Initialize_SolidLine_Bezier(from, to)
    local SPEED = 60
    local MAX_MID = 3
    local MIN_SPREAD = 0.2
    local MAX_SPREAD = 0.5
    local MIN_DECAY = 0.2
    local MAX_DECAY = 0.8
    local MIN_SPEED = 0.2
    local MAX_SPEED = 3.5
    local MIN_RAD_HEIGHT = 0.2
    local MAX_RAD_HEIGHT = 1.3
    --local MIN_ALONG_HEIGHT = 0        -- along doesn't affect the outcome enough to justify the cost of the extra call to math.sin
    --local MAX_ALONG_HEIGHT = 0.2

    -- Figure out how long it will take to travel this initial distance
    local distance = math.sqrt(GetVectorDiffLengthSqr(from, to))
    line_duration = distance / SPEED

    -- Pick a size (in percent of total line length) that the line_controlpoints will be (from tip back to player)
    line_points_spread = GetScaledValue(MIN_SPREAD, MAX_SPREAD, 0, 1, math.random())

    line_controlpoints:Clear()      -- should already be cleared, but it's cheap to do again

    local mid_count = math.random(1, MAX_MID)
    local count = mid_count + 2

    for i = 0, count - 1, 1 do
        local point = line_controlpoints:GetNewItem()

        -- Radius
        point.radius_decay = GetScaledValue(MIN_DECAY, MAX_DECAY, 0, 1, math.random())
        point.radius_height = GetScaledValue(MIN_RAD_HEIGHT, MAX_RAD_HEIGHT, 0, 1, math.random())
        point.radius_speed = GetScaledValue(MIN_SPEED, MAX_SPEED, 0, 1, math.random())
        point.radius_radians = math.random() * math.pi * 2

        -- Along
        -- point.along_decay = GetScaledValue(MIN_DECAY, MAX_DECAY, 0, 1, math.random())
        -- point.along_height = GetScaledValue(MIN_ALONG_HEIGHT, MAX_ALONG_HEIGHT, 0, 1, math.random())
        -- point.along_speed = GetScaledValue(MIN_SPEED, MAX_SPEED, 0, 1, math.random())

        point.along_percent = i / (count - 1)
    end

    line_controlpoints_forbezier = {}

    line_starttime = timer
end

-- function this.Initialize_SolidLine_Log()
--     line_log = DebugRenderLogger:new(true)

--     line_log:DefineCategory("control", "888", 0.33)
--     line_log:DefineCategory("from", "FF19A30D", 3)
--     line_log:DefineCategory("to", "FFC71717", 3)
--     line_log:DefineCategory("line", "FFF")
-- end

function this.SolidLine_Bezier(from, to, visuals, time, const)
    local COUNT_PRE = 8     -- use fewer points from 0 to first line_controlpoints_forbezier (it will be mostly a straight line in this region)
    local COUNT_POST = 18

    this.SolidLine_Bezier_PrepControls(from, to, time)

    -- line_log:NewFrame()
    -- line_log:Add_Dot(from, "from")
    -- line_log:Add_Dot(to, "to")

    -- for i = 1, #line_controlpoints_forbezier, 1 do
    --     line_log:Add_Dot(line_controlpoints_forbezier[i], "control")
    -- end

    local mid_percent = 1 - line_points_spread

    local prev_pos = from

    for i = 1, COUNT_PRE - 1, 1 do
        local percent_pre = GetScaledValue(0, 1, 0, COUNT_PRE - 1, i)
        local percent = GetScaledValue(0, mid_percent, 0, 1, percent_pre)
        local pos = GetBezierPoint_ControlPoints(percent, line_controlpoints_forbezier)

        this.SolidLine_Add(prev_pos, pos, visuals)
        --line_log:Add_Line(prev_pos, pos, "line")

        prev_pos = pos
    end

    for i = 1, COUNT_POST - 1, 1 do
        local percent_post = GetScaledValue(0, 1, 0, COUNT_POST - 1, i)
        local percent = GetScaledValue(mid_percent, 1, 0, 1, percent_post)
        local pos = GetBezierPoint_ControlPoints(percent, line_controlpoints_forbezier)

        this.SolidLine_Add(prev_pos, pos, visuals)
        --line_log:Add_Line(prev_pos, pos, "line")

        prev_pos = pos
    end
end
function this.SolidLine_Bezier_PrepControls(from, to, time)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    local from_to = MultiplyVector(SubtractVectors(to, from), time)     -- at time 0, line is zero length, at time 1, line is full length
    local from_to_unit = ToUnit(from_to)

    line_controlpoints_forbezier[1] = from

    for i = 1, line_controlpoints:GetCount(), 1 do
        local point = line_controlpoints:GetItem(i)

        -- starting with (1-time) to make sure it's zero at time one
        -- (decay^time) gives an exponential decay
        -- height * cos() gives some oscillation over time
        local radius_dist = (1 - time) * (point.radius_decay ^ time) * point.radius_height * math.cos(math.pi / 2 * time * point.radius_speed)
        --local along_dist = (1 - time) * (point.along_decay ^ time) * point.along_height * math.sin(math.pi / 2 * time * point.along_speed)

        local radius_vec_unit = RotateVector3D_axis_radian(CrossProduct3D(from_to_unit, up), from_to_unit, point.radius_radians)

        local percent_along = 1 - line_points_spread + (line_points_spread * point.along_percent)

        local line_point = AddVectors(from, MultiplyVector(from_to, percent_along))
        --line_point = AddVectors(line_point, MultiplyVector(from_to_unit, along_dist))
        line_point = AddVectors(line_point, MultiplyVector(radius_vec_unit, radius_dist))

        line_controlpoints_forbezier[i + 1] = line_point
    end
end

function this.SolidLine_Add(from, to, visuals)
    local item = items:GetNewItem()
    this.SetItemBase(item, item_types.line, nil, visuals.grappleline_color_primary, 4, nil, nil, true)
    item.point1 = from
    item.point2 = to
end

----------------------------------- Private Methods -----------------------------------

function this.Add_Dot(position, color_back, color_fore, lifespan_seconds, is_single_frame, size_mult, thickness, const_size, id)
    local item = items:GetNewItem()
    this.SetItemBase(item, item_types.dot, color_back, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame, id)
    item.position = position
    item.thickness = thickness

    return item.id
end

function this.Add_Diamond(position, color, lifespan_seconds, is_single_frame, size_mult, thickness, const_size, id)
    local item = items:GetNewItem()
    this.SetItemBase(item, item_types.diamond, nil, color, size_mult, const_size, lifespan_seconds, is_single_frame, id)
    item.position = position
    item.thickness = thickness

    return item.id
end

function this.Add_Square(center, normal, size_x, size_y, color_back, color_fore, lifespan_seconds, is_single_frame, size_mult, const_size)
    local id = this.GetNextID()

    local p1, p2, p3, p4 = this.GetSquarePoints(center, normal, size_x, size_y)

    if color_back then
        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.triangle, color_back, nil, nil, nil, lifespan_seconds, is_single_frame, id)
        item.point1 = p1
        item.point2 = p2
        item.point3 = p3

        item = items:GetNewItem()
        this.SetItemBase(item, item_types.triangle, color_back, nil, nil, nil, lifespan_seconds, is_single_frame, id)
        item.point1 = p3
        item.point2 = p4
        item.point3 = p1
    end

    if color_fore then
        if color_back and not size_mult then
            size_mult = 8
        end

        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame, id)
        item.point1 = p1
        item.point2 = p2

        item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame, id)
        item.point1 = p2
        item.point2 = p3

        item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame, id)
        item.point1 = p3
        item.point2 = p4

        item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame, id)
        item.point1 = p4
        item.point2 = p1
    end

    return id
end

function this.Add_Circle(center, normal, radius, color, lifespan_seconds, is_single_frame, size_mult, const_size)
    -- The default line thickness is too thin for a circle.  Use a larger value if there is nothing specified
    if not size_mult then
        size_mult = 8
    end

    -- Turn the circle into lines
    -- NOTE: if the player starts far away, then walks close the circle, then the num sides will be too small.  But it's not worth
    -- the expense of converting to lines every frame for that edge case
    local num_sides, distance = this.GetCircleNumSides(center, radius)

    local points = this.GetCirclePoints(center, radius, normal, num_sides)

    local id = this.GetNextID()

    for i = 1, #points - 1, 1 do
        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, color, size_mult, const_size, lifespan_seconds, is_single_frame, id)
        item.point1 = points[i]
        item.point2 = points[i + 1]
    end

    local item = items:GetNewItem()
    this.SetItemBase(item, item_types.line, nil, color, size_mult, const_size, lifespan_seconds, is_single_frame, id)
    item.point1 = points[#points]
    item.point2 = points[1]

    return id, distance
end

---@param id integer This is the id from one of the add functions
function this.Remove(id)
    local index = 1

    while index <= items:GetCount() do        -- there can be multiple items tied to the same id, so need to scan the whole list
        local item = items:GetItem(index)

        if item.id == id then
            items:RemoveItem(index)
        else
            index = index + 1
        end
    end
end

-- id is optional.  Pass it in if multiple entries need to be tied to the same id
function this.SetItemBase(item, item_type, color_back, color_fore, size_mult, const_size, lifespan_seconds, is_single_frame, id)
    if not id then
        id = this.GetNextID()
    end

    item.id = id
    item.create_time = timer

    item.item_type = item_type
    item.color_back = color_back
    item.color_fore = color_fore
    item.size_mult = size_mult
    item.const_size = const_size
    item.lifespan_seconds = lifespan_seconds

    if is_single_frame then
        item.remaining_frames = 1
    else
        item.remaining_frames = nil     -- this needs to be set because it's stored in a stickylist, which reuses entries
    end
end

function this.GetNextID()
    next_id = next_id + 1
    return next_id - 1
end

function this.RemoveExpiredItems()
    local index = 1

    while index <= items:GetCount() do
        local item = items:GetItem(index)

        if item.lifespan_seconds and timer > item.create_time + item.lifespan_seconds then
            items:RemoveItem(index)
        elseif item.remaining_frames == 0 then
            items:RemoveItem(index)
        else
            index = index + 1
        end

        if item.remaining_frames and item.remaining_frames > 0 then
            item.remaining_frames = item.remaining_frames - 1
        end
    end
end

function this.GetCircleNumSides(center, radius, degrees)
    local distance = math.sqrt(GetVectorDiffLengthSqr(Game.GetPlayer():GetWorldPosition(), center))
    if IsNearZero(distance) then
        distance = 0.01
    end
    local size = radius / distance

    local min_sides = 11
    local max_sides = 40
    local num_sides = Round(GetScaledValue(min_sides, max_sides, 0.01, 0.1, size), 0)

    if degrees then
        num_sides = num_sides * (degrees / 360)
    end

    num_sides = Clamp(min_sides, max_sides, num_sides)

    -- print("radius: " .. tostring(radius))
    -- print("distance: " .. tostring(distance))
    -- print("size: " .. tostring(size))
    -- print("num sides: " .. tostring(num_sides))

    return num_sides, distance
end

function this.GetCirclePoints(center, radius, normal, num_sides)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    local quat = GetRotation(up, ToUnit(normal))

    local points2D = GetCircle_Cached(num_sides)

    local retVal = {}

    for _, point2D in ipairs(points2D) do
        local offset = Vector4.new(point2D.X * radius, point2D.Y * radius, 0, 1)
        offset = RotateVector3D(offset, quat)

        table.insert(retVal, AddVectors(center, offset))
    end

    return retVal
end
function this.GetSquarePoints(center, normal, size_x, size_y)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    local half_x = size_x / 2
    local half_y = size_y / 2

    local p1 = Vector4.new(-half_x, -half_y, 0, 1)
    local p2 = Vector4.new(half_x, -half_y, 0, 1)
    local p3 = Vector4.new(half_x, half_y, 0, 1)
    local p4 = Vector4.new(-half_x, half_y, 0, 1)

    local quat = GetRotation(up, ToUnit(normal))

    p1 = RotateVector3D(p1, quat)
    p2 = RotateVector3D(p2, quat)
    p3 = RotateVector3D(p3, quat)
    p4 = RotateVector3D(p4, quat)

    return
        AddVectors(center, p1),
        AddVectors(center, p2),
        AddVectors(center, p3),
        AddVectors(center, p4)
end

return GrappleRender