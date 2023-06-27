local OrbSwarmObstacles = {}

local this = {}

local nearby = StickyList:new()

function OrbSwarmObstacles.GetAccelObstacles(props, obstacles, limits)
    nono_squares.GetNearby(nearby, props.pos, obstacles.max_radiusmult)

    if nearby:GetCount() == 0 then
        return 0, 0, 0, false
    end

    local player_pos = props.o.GetCrosshairInfo()

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
        end
    end

    return accel_x, accel_y, accel_z, had_obstacles
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

    local accel = limits.max_accel * edge_percent * depth_percent

    return
        accel_dir.x * accel,
        accel_dir.y * accel,
        accel_dir.z * accel,
        true
end

function this.IsBehindObstacle(normal, center_to_orb, center_to_player)
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

return OrbSwarmObstacles