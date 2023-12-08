local aimswing_raycasts = {}

local this = {}

local up = nil
local c1 = nil
local c2 = nil
local s1 = nil
local s2 = nil

local HORZRADIAL_FROM = 2
local HORZRADIAL_TO = 30
local HORZRADIAL_RADIUS = 24

local LOOK_TO = 30
local LOOK_FROM_RADIUS = 1
local LOOK_TO_RADIUS = 6

local cylinder_distradial_by_speed = nil

local debug_categories = CreateEnum("RAY_missline", "RAY_hitline", "RAY_hitpoint")

-- This treats horizontal tunnel scan and look direction independently, doesn't take into account velocity
function aimswing_raycasts.InitialCone1(o, const, vel)
    o:GetCamera()

    this.InitRays()

    local log = DebugRenderLogger:new(true)

    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + 1, 1)

    log:DefineCategory("player", "2F95CC")
    log:Add_Dot(o.pos, "player")
    log:Add_Line(o.pos, AddVectors(o.pos, vel), "player")

    log:Add_Dot(from)

    this.RaysLook_LookDir(o, log, from)

    -- TODO: If they are looking nearly straight up, the horizontal scan is mostly useless.  So try for horizontal, but cap at a max angle from look
    -- (same but opposite when looking down)
    --
    -- An alternative could be current velocity that helps choose the tunnel cast
    this.RaysHorizontal(o, log, from)

    log:Save()
end

function aimswing_raycasts.Scan_LookAndVelocity1(o, const, vel)
    o:GetCamera()

    this.InitRays()

    local log = DebugRenderLogger:new(true)

    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + 1, 1)

    local vel_len = GetVectorLength(vel)

    log:Add_Dot(o.pos, nil, "2F95CC")
    log:Add_Line(o.pos, AddVectors(o.pos, vel), nil, "115980", nil, "velocity: " .. tostring(Round(vel_len, 1)))
    log:Add_Line(o.pos, AddVectors(o.pos, o.lookdir_forward), nil, "CCC71B", nil, "look direction")


    --TODO: figure out the arc to scan
    -- use currently velocity to decide how far to scan
    --  vel < 3 should be ignored
    --  min if velocity isn't very high
    --  max if too high


    --TODO: a hard if statement isn't the answer
    -- velocity influences the angle of the cone


    --TODO: if the angle is close to 180, there's no need to look at all the intermediate angle of the arc
    --  just scan the look direction
    --  maybe a little along the current velocity to help the caller know how strong to pull the player


    --TODO: scans along the outer lines isn't the correct solution
    --  based on the cone, get uniform interior points and fire a few rays from each (outward rays, not back toward the sender)


    if vel_len < 7 then
        -- Only consider look direction
        this.RaysCombined(o, log, from, o.lookdir_forward, o.lookdir_right)

    else
        -- Also consider velocity
        local vel_unit = MultiplyVector(vel, 1 / vel_len)


        --TODO: If the angle is small between look and velocity, then choose the vector avg
        -- If the angle is too large, choose middle vectors



        this.RaysCombined(o, log, from, o.lookdir_forward, o.lookdir_right)

        local right = CrossProduct3D(vel_unit, up)
        this.RaysCombined(o, log, from, vel_unit, right)
    end

    log:Save()
end

-- Chooses start points along a line, firing out rays at angles
-- This would be used for short, low velocity hops
function aimswing_raycasts.Cylinder(o, from, dir_unit, distance)
    local DIST_ALONG_INITIAL = 3
    local DIST_ALONG_REMAINING = 5
    local DIST_RADIAL = 4.5
    local MAX_BURSTS = 4

    this.InitRays()

    local dir_right = CrossProduct3D(dir_unit, up)

    local offset_along = MultiplyVector(dir_unit, DIST_ALONG_INITIAL)

    local retVal = {}

    -- Initial rays at from position
    this.Cylinder_Burst(o, from, AddVectors(from, offset_along), dir_unit, dir_right, DIST_RADIAL, 1, retVal)

    -- Do a few more bursts down the line, based on how long the line is
    local remain_distance = distance - DIST_ALONG_INITIAL
    local remain_count = math.floor(remain_distance / DIST_ALONG_REMAINING)

    local remain_along_dist
    if remain_count <= MAX_BURSTS - 1 then      -- subtract one because initial is one of the bursts
        remain_along_dist = DIST_ALONG_REMAINING
    else
        remain_along_dist = remain_distance / (MAX_BURSTS - 1)      -- there would too many busts.  Spread them evenly along the remaining distance
        remain_count = MAX_BURSTS - 1
    end

    for i = 1, remain_count, 1 do
        local dist_along_from = DIST_ALONG_INITIAL + (remain_along_dist * (i - 1))
        local dist_along_to = DIST_ALONG_INITIAL + (remain_along_dist * i)

        local offset_along_from = MultiplyVector(dir_unit, dist_along_from)
        local offset_along_to = MultiplyVector(dir_unit, dist_along_to)

        this.Cylinder_Burst(o, AddVectors(from, offset_along_from), AddVectors(from, offset_along_to), dir_unit, dir_right, DIST_RADIAL, 1, retVal)
    end

    return retVal
end

function aimswing_raycasts.Cylinder2(o, from, dir_unit, distance, speed_look, down_extra_percent)
    local DIST_ALONG_INITIAL = 3
    local DIST_ALONG_REMAINING = 5
    local MAX_BURSTS = 4

    if not cylinder_distradial_by_speed then
        cylinder_distradial_by_speed = AnimationCurve:new()
        cylinder_distradial_by_speed:AddKeyValue(0, 4.5)
        cylinder_distradial_by_speed:AddKeyValue(8, 5)
        cylinder_distradial_by_speed:AddKeyValue(20, 7)
        cylinder_distradial_by_speed:AddKeyValue(30, 10)
        cylinder_distradial_by_speed:AddKeyValue(60, 14)
    end

    local dist_radial = cylinder_distradial_by_speed:Evaluate(speed_look)

    this.InitRays()

    local dir_right = CrossProduct3D(dir_unit, up)

    local offset_along = MultiplyVector(dir_unit, DIST_ALONG_INITIAL)

    local num_calls = 0
    local hits = {}

    -- Initial rays at from position
    num_calls = num_calls + this.Cylinder_Burst(o, from, AddVectors(from, offset_along), dir_unit, dir_right, dist_radial, down_extra_percent, hits)

    -- Do a few more bursts down the line, based on how long the line is
    local remain_distance = distance - DIST_ALONG_INITIAL
    local remain_count = math.floor(remain_distance / DIST_ALONG_REMAINING)

    local remain_along_dist
    if remain_count <= MAX_BURSTS - 1 then      -- subtract one because initial is one of the bursts
        remain_along_dist = DIST_ALONG_REMAINING
    else
        remain_along_dist = remain_distance / (MAX_BURSTS - 1)      -- there would too many busts.  Spread them evenly along the remaining distance
        remain_count = MAX_BURSTS - 1
    end

    for i = 1, remain_count, 1 do
        local dist_along_from = DIST_ALONG_INITIAL + (remain_along_dist * (i - 1))
        local dist_along_to = DIST_ALONG_INITIAL + (remain_along_dist * i)

        local offset_along_from = MultiplyVector(dir_unit, dist_along_from)
        local offset_along_to = MultiplyVector(dir_unit, dist_along_to)

        num_calls = num_calls + this.Cylinder_Burst(o, AddVectors(from, offset_along_from), AddVectors(from, offset_along_to), dir_unit, dir_right, dist_radial, down_extra_percent, hits)
    end

    return hits, num_calls
end

----------------------------------- Private Methods -----------------------------------

function this.InitRays()
    if up then
        do return end
    end

    up = Vector4.new(0, 0, 1, 1)

    -- coordinates of a pentagon
    -- https://mathworld.wolfram.com/RegularPentagon.html
    local rad_5 = math.sqrt(5)
    s1 = math.sqrt(10 + 2 * rad_5) / 4      -- x upper
    s2 = math.sqrt(10 - 2 * rad_5) / 4      -- x lower
    c1 = (rad_5 - 1) / 4                    -- y upper
    c2 = (rad_5 + 1) / 4                    -- y lower

    debug_render_screen.DefineCategory(debug_categories.RAY_missline, nil, "A0C25A48")
    debug_render_screen.DefineCategory(debug_categories.RAY_hitline, nil, "4ACF4A")
    debug_render_screen.DefineCategory(debug_categories.RAY_hitpoint, "377538")
end

function this.GetPoint_Radial(from, dir_right, dir_up, dist_right, dist_up, ray_dist)
    local x = from.x + (dir_right.x * ray_dist * dist_right) + (dir_up.x * ray_dist * dist_up)
    local y = from.y + (dir_right.y * ray_dist * dist_right) + (dir_up.y * ray_dist * dist_up)
    local z = from.z + (dir_right.z * ray_dist * dist_right) + (dir_up.z * ray_dist * dist_up)

    return Vector4.new(x, y, z, 1)
end

function this.FireRay(o, log, from, to)
    log:Add_Line(from, to)

    local hitPoint = o:RayCast(from, to)
    if hitPoint then
        log:Add_Line(from, hitPoint, nil, "2C2", 2)
    end
end
function this.FireRay2(o, from, to, hit_list)
    local hitPoint = o:RayCast(from, to)

    if hitPoint then
        debug_render_screen.Add_Line(from, hitPoint, debug_categories.RAY_hitline)
        debug_render_screen.Add_Dot(hitPoint, debug_categories.RAY_hitpoint)
        table.insert(hit_list, hitPoint)
    else
        debug_render_screen.Add_Line(from, to, debug_categories.RAY_missline)
    end
end

------------------------------------- InitialCone1 ------------------------------------

-- Fires a ray along look direction, and a few around that, somewhat parallel
function this.RaysLook_LookDir(o, log, from)
    local to = Vector4.new(from.x + o.lookdir_forward.x * LOOK_TO, from.y + o.lookdir_forward.y * LOOK_TO, from.z + o.lookdir_forward.z * LOOK_TO, 1)
    this.FireRay(o, log, from, to)

    local look_up = CrossProduct3D(o.lookdir_right, o.lookdir_forward)

    -- Up
    local near = this.GetPoint_Radial(from, o.lookdir_right, look_up, 0, 1, LOOK_FROM_RADIUS)
    local far = this.GetPoint_Radial(to, o.lookdir_right, look_up, 0, 1, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Up Right
    near = this.GetPoint_Radial(from, o.lookdir_right, look_up, s1, c1, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, look_up, s1, c1, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Down Right
    near = this.GetPoint_Radial(from, o.lookdir_right, look_up, s2, -c2, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, look_up, s2, -c2, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Down Left
    near = this.GetPoint_Radial(from, o.lookdir_right, look_up, -s2, -c2, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, look_up, -s2, -c2, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Up Left
    near = this.GetPoint_Radial(from, o.lookdir_right, look_up, -s1, c1, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, look_up, -s1, c1, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)
end

-- Fires a ray horizontally, and a few outward radially at progressive distances (identifies structures around the player)
function this.RaysHorizontal(o, log, from)
    local forw_horz = GetProjectedVector_AlongPlane(o.lookdir_forward, up)
    local right_horz = GetProjectedVector_AlongPlane(o.lookdir_right, up)

    -- Along horizontal
    this.FireRay(o, log, from, Vector4.new(from.x + forw_horz.x * HORZRADIAL_TO, from.y + forw_horz.y * HORZRADIAL_TO, from.z + forw_horz.z * HORZRADIAL_TO, 1))

    -- Radial around horizontal
    for i = 1, 4, 1 do
        local dist = GetScaledValue(HORZRADIAL_FROM, HORZRADIAL_TO, 1, 4, i)

        local ray_from = Vector4.new(from.x + (forw_horz.x * dist), from.y + (forw_horz.y * dist), from.z + (forw_horz.z * dist), 1)
        log:Add_Dot(ray_from)

        -- Up
        local ray_out = this.GetPoint_Radial(ray_from, right_horz, up, 0, 1, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Up Right
        ray_out = this.GetPoint_Radial(ray_from, right_horz, up, s1, c1, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Down Right
        ray_out = this.GetPoint_Radial(ray_from, right_horz, up, s2, -c2, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Down Left
        ray_out = this.GetPoint_Radial(ray_from, right_horz, up, -s2, -c2, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Up Left
        ray_out = this.GetPoint_Radial(ray_from, right_horz, up, -s1, c1, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)
    end
end

--------------------------------- Scan_LookAndVelocity --------------------------------

function this.RaysCombined(o, log, from, direction, right)
    local look_up = CrossProduct3D(o.lookdir_right, direction)

    this.RaysCombined_AlongDir(o, log, from, direction, look_up)
    this.RaysCombined_Outward(o, log, from, direction, look_up, o.lookdir_right)
end
function this.RaysCombined_AlongDir(o, log, from, direction, dir_up)
    local to = Vector4.new(from.x + direction.x * LOOK_TO, from.y + direction.y * LOOK_TO, from.z + direction.z * LOOK_TO, 1)
    this.FireRay(o, log, from, to)

    -- Up
    local near = this.GetPoint_Radial(from, o.lookdir_right, dir_up, 0, 1, LOOK_FROM_RADIUS)
    local far = this.GetPoint_Radial(to, o.lookdir_right, dir_up, 0, 1, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Up Right
    near = this.GetPoint_Radial(from, o.lookdir_right, dir_up, s1, c1, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, dir_up, s1, c1, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Down Right
    near = this.GetPoint_Radial(from, o.lookdir_right, dir_up, s2, -c2, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, dir_up, s2, -c2, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Down Left
    near = this.GetPoint_Radial(from, o.lookdir_right, dir_up, -s2, -c2, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, dir_up, -s2, -c2, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)

    -- Up Left
    near = this.GetPoint_Radial(from, o.lookdir_right, dir_up, -s1, c1, LOOK_FROM_RADIUS)
    far = this.GetPoint_Radial(to, o.lookdir_right, dir_up, -s1, c1, LOOK_TO_RADIUS)
    this.FireRay(o, log, near, far)
end
function this.RaysCombined_Outward(o, log, from, direction, dir_up, dir_right)
    -- Radial out from direction line
    for i = 1, 4, 1 do
        local dist = GetScaledValue(HORZRADIAL_FROM, HORZRADIAL_TO, 1, 4, i)

        local ray_from = Vector4.new(from.x + (direction.x * dist), from.y + (direction.y * dist), from.z + (direction.z * dist), 1)
        log:Add_Dot(ray_from)

        -- Up
        local ray_out = this.GetPoint_Radial(ray_from, dir_right, dir_up, 0, 1, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Up Right
        ray_out = this.GetPoint_Radial(ray_from, dir_right, dir_up, s1, c1, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Down Right
        ray_out = this.GetPoint_Radial(ray_from, dir_right, dir_up, s2, -c2, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Down Left
        ray_out = this.GetPoint_Radial(ray_from, dir_right, dir_up, -s2, -c2, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)

        -- Up Left
        ray_out = this.GetPoint_Radial(ray_from, dir_right, dir_up, -s1, c1, HORZRADIAL_RADIUS)
        this.FireRay(o, log, ray_from, ray_out)
    end
end

--------------------------------------- Cylinder --------------------------------------

-- Fires rays starting at from, ending at points radially away from to_line_point
-- Logs to the screen visualizer
-- Adds to list of hits (just hits, not normals)
function this.Cylinder_Burst(o, from, to_line_point, direction, dir_right, radial_len, down_extra_percent, hit_list)
    local dir_up = CrossProduct3D(dir_right, direction)

    -- Up
    local ray_out = this.GetPoint_Radial(to_line_point, dir_right, dir_up, 0, 1, radial_len)
    this.FireRay2(o, from, ray_out, hit_list)

    -- Up Right
    ray_out = this.GetPoint_Radial(to_line_point, dir_right, dir_up, s1, c1, radial_len)
    this.FireRay2(o, from, ray_out, hit_list)

    -- Down Right
    ray_out = this.GetPoint_Radial(to_line_point, dir_right, dir_up, s2, -c2 * down_extra_percent, radial_len)
    this.FireRay2(o, from, ray_out, hit_list)

    -- Down Left
    ray_out = this.GetPoint_Radial(to_line_point, dir_right, dir_up, -s2, -c2 * down_extra_percent, radial_len)
    this.FireRay2(o, from, ray_out, hit_list)

    -- Up Left
    ray_out = this.GetPoint_Radial(to_line_point, dir_right, dir_up, -s1, c1, radial_len)
    this.FireRay2(o, from, ray_out, hit_list)

    return 5
end

return aimswing_raycasts