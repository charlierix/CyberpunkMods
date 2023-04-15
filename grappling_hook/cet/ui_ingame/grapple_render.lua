-- This is a copy of debug_render_screen.lua, but with different external functions that are hardcoded for drawing
-- stuff for grapple

local frame = require "ui_ingame/grapple_render_frame"
local ui = require "ui_ingame/grapple_render_ui"

local GrappleRender = {}

local this = {}

local next_id = 0
local timer = 0
local item_types = CreateEnum("dot", "line", "triangle", "text")

local controller = nil

local items = StickyList:new()
local visuals_circle = StickyList:new()
local visuals_line = StickyList:new()
local visuals_triangle = StickyList:new()
local visuals_text = StickyList:new()

local endplane_id = nil
local endplane_recalc_distsqr = nil
local endplane_pos = nil
local endplane_normal = nil
local endplane_visuals = nil

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
    frame.RebuildVisuals(controller, items, item_types, visuals_circle, visuals_line, visuals_triangle, visuals_text)
end

function GrappleRender.CallFrom_onDraw()
    if visuals_circle:GetCount() == 0 and visuals_line:GetCount() == 0 and visuals_triangle:GetCount() == 0 and visuals_text:GetCount() == 0 then
        do return end
    end

    ui.DrawCanvas(visuals_circle, visuals_line, visuals_triangle, visuals_text)
end

----------------------------------- Public Methods ------------------------------------

function GrappleRender.StraightLine(from, to, visuals, const)
    if visuals.grappleline_type == const.Visuals_GrappleLine_Type.SolidLine then
        local item = items:GetNewItem()
        this.SetItemBase(item, item_types.line, nil, visuals.grappleline_color_primary, 4, nil, nil, true)
        item.point1 = from
        item.point2 = to

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

function GrappleRender.AnchorPoint(pos)
    
end

-- Removes all visual items (doesn't remove categories)
function GrappleRender.Clear()
    items:Clear()

    endplane_id = nil
    endplane_recalc_distsqr = nil
    endplane_pos = nil
    endplane_normal = nil
    endplane_visuals = nil
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

----------------------------------- Private Methods -----------------------------------

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