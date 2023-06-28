local OrbSwarmObstacles = {}

local this = {}

local nearby = StickyList:new()

local SHOW_DEBUG = false

function OrbSwarmObstacles.GetAccelObstacles(props, obstacles, limits)
    nono_squares.GetNearby(nearby, props.pos, obstacles.max_radiusmult)

    if nearby:GetCount() == 0 then
        return 0, 0, 0, false
    end

    local player_pos = props.o:GetCrosshairInfo()

    local accel_x = 0
    local accel_y = 0
    local accel_z = 0

    local had_obstacles = false

    for i = 1, nearby:GetCount(), 1 do
        local entry = nearby:GetItem(i)

        local x, y, z, used = this.ProcessObstacle(props, entry, player_pos, obstacles, limits)
        accel_x = accel_x + x
        accel_y = accel_y + y
        accel_z = accel_z + z

        if used then
            had_obstacles = true

            if SHOW_DEBUG then
                this.Draw_Debug(props, entry, accel_x, accel_y, accel_z)
            end
        end
    end

    accel_x, accel_y, accel_z = this.CapAccel(accel_x, accel_y, accel_z, limits.max_accel * obstacles.max_accel_mult)

    return accel_x, accel_y, accel_z, had_obstacles
end

function OrbSwarmObstacles.TEST_ProcessPoint(test_pos, player_pos, center, normal, radius, obstacles, limits)
    local mock_props =
    {
        pos = test_pos
    }

    local mock_entry =
    {
        center = center,
        normal = normal,
        radius = radius,
        dist_sqr = GetVectorDiffLengthSqr(test_pos, center),
    }

    return this.ProcessObstacle(mock_props, mock_entry, player_pos, obstacles, limits)
end

----------------------------------- Private Methods -----------------------------------

function this.ProcessObstacle(props, entry, player_pos, obstacles, limits)
    -- Compare dot products to see if orb and player are on oppposite sides of the obstacle
    local center_to_orb = SubtractVectors(props.pos, entry.center)
    local center_to_player = SubtractVectors(player_pos, entry.center)

    if not this.IsBehindObstacle(entry.normal, center_to_orb, center_to_player) then
        return 0, 0, 0, false
    end

    -- Convert direction to unit vector
    local center_to_orb_dist = GetVectorLength(center_to_orb)
    if IsNearZero(center_to_orb_dist) then
        return 0, 0, 0, false
    end

    local center_to_orb_unit = DivideVector(center_to_orb, -center_to_orb_dist)
    local normal_dot_orb = DotProduct3D(entry.normal, center_to_orb_unit)

    -- The final compare radius is based on the dot product with normal (it's not just a simple hemisphere)
    local radius_extended = entry.radius * obstacles.dot_radiusmult_animcurve:Evaluate(normal_dot_orb)

    if entry.dist_sqr > radius_extended * radius_extended then
        return 0, 0, 0, false
    end

    local dist_from_center = math.sqrt(entry.dist_sqr)

    -- If near the edge of the volume, the accel could be reduced
    local edge_percent = this.GetAccelMult_Edge(radius_extended, dist_from_center, entry.radius, obstacles.edge_percentradius_accelmult_animcurve)

    -- If near the plane of the hit, the accel could be reduced
    local depth_percent = this.GetAccelMult_Depth(entry.center, entry.normal, props.pos, entry.radius, obstacles.depth_percentradius_accelmult_animcurve)

    local accel_dir = nil
    if normal_dot_orb >= 0 then
        accel_dir = entry.normal
    else
        accel_dir = Negate(entry.normal)
    end

    local accel = limits.max_accel * obstacles.max_accel_mult * edge_percent * depth_percent

    return
        accel_dir.x * accel,
        accel_dir.y * accel,
        accel_dir.z * accel,
        true
end

function this.IsBehindObstacle(normal, center_to_orb, center_to_player)
    if IsNearZero_vec4(center_to_orb) or IsNearZero_vec4(center_to_player) then
        return false
    end

    local dot_orb = DotProduct3D(normal, center_to_orb)
    local dot_player = DotProduct3D(normal, center_to_player)

    local is_orb_pos = dot_orb >= 0
    local is_player_pos = dot_player >= 0

    return is_orb_pos ~= is_player_pos
end

function this.GetAccelMult_Edge(radius_extended, dist_from_center, radius, animcurve)
    local dist_from_edge = radius_extended - dist_from_center
    local dist_ratio = dist_from_edge / radius

    return animcurve:Evaluate(dist_ratio)
end

function this.GetAccelMult_Depth(center, normal, orb_pos, radius, animcurve)
    local point_on_plane = GetClosestPoint_Plane_Point(center, normal, orb_pos)
    local dist_to_plane = math.sqrt(GetVectorDiffLengthSqr(orb_pos, point_on_plane))
    local dist_ratio = dist_to_plane / radius

    return animcurve:Evaluate(dist_ratio)
end

function this.CapAccel(accel_x, accel_y, accel_z, max_accel)
    local accel_sqr = GetVectorLength3DSqr(accel_x, accel_y, accel_z)

    if accel_sqr > max_accel * max_accel then
        local accel = math.sqrt(accel_sqr)

        accel_x = accel_x / accel * max_accel
        accel_y = accel_y / accel * max_accel
        accel_z = accel_z / accel * max_accel
    end

    return accel_x, accel_y, accel_z
end

function this.Draw_Debug(props, entry, accel_x, accel_y, accel_z)
    -- line
    debug_render_screen.Add_Dot(props.pos, nil, "FFF", nil, true)
    debug_render_screen.Add_Line(props.pos, Vector4.new(props.pos.x + accel_x, props.pos.y + accel_y, props.pos.z + accel_z, 1), nil, "FF0", nil, true)

    -- plate
    debug_render_screen.Add_Square(entry.center, entry.normal, entry.radius * 2, entry.radius * 2, nil, "2FFF", "4000", nil, true)
end

return OrbSwarmObstacles