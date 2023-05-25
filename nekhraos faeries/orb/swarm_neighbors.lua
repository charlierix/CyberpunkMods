local OrbSwarmNeighbors = {}

local this = {}

local swarm_util = require "processing/swarm_util"

function OrbSwarmNeighbors.GetAccelNeighbors(props, neighbors, limits)
    local nearby = this.FindNearby(props, neighbors)
    if #nearby == 0 then
        return 0, 0, 0, false
    end

    local count = math.min(#nearby, neighbors.count)

    local flock_center, flock_vel, actual_count = this.GetCenterVelocity(nearby, count)
    if actual_count == 0 then
        return 0, 0, 0, false       -- all the neighbors are dead (should have been caught by FindNearby)
    end

    local flock_center_projected = this.GetProjectedPoint(flock_center, flock_vel, neighbors.accel_percents.center_project_seconds)

    -- attract to center of flock
    local accel_center_x, accel_center_y, accel_center_z, distance_center = this.TowardCenter(flock_center_projected, props.pos, neighbors.accel_percents.toward_flock_center, limits.max_accel)

    -- align velocity with flock's average
    local accel_align_x, accel_align_y, accel_align_z = this.AlignVelocity(flock_vel, props.vel, distance_center, neighbors.accel_percents.align_flock_velocity_speed, neighbors.accel_percents.align_flock_velocity_distance, limits.max_accel, limits.max_speed)

    -- drag orth flock's velocity
    local accel_orthvel_x, accel_orthvel_y, accel_orthvel_z = this.OrthFlockVelocity(flock_vel, props.vel, distance_center, neighbors.accel_percents.drag_orth_flock_velocity_speed, neighbors.accel_percents.drag_orth_flock_velocity_distance, limits.max_accel, limits.max_speed)

    -- don't get too close to any
    local accel_avoid_x, accel_avoid_y, accel_avoid_z = this.AvoidOthers(props.pos, props.vel, nearby, neighbors.accel_percents.repel_other_orb, neighbors.accel_percents.repel_other_orb_velocitytoward, limits.max_accel)

    return
        accel_center_x + accel_align_x + accel_orthvel_x + accel_avoid_x,
        accel_center_y + accel_align_y + accel_orthvel_y + accel_avoid_y,
        accel_center_z + accel_align_z + accel_orthvel_z + accel_avoid_z,
        true
end

----------------------------------- Private Methods -----------------------------------

function this.FindNearby(props, neighbors)
    --TODO: handle being part of a pod

    -- See if an existing scan is still valid
    if neighbors.nearby and props.o.timer < neighbors.next_nearbyscan_time and this.AreAllAlive(neighbors.nearby) then
        return neighbors.nearby
    end

    -- Randomizing the pull time a bit to avoid the risk of multiple orbs created at the same time doing a scan in
    -- the same frame
    local base = neighbors.nearbyscan_interval_seconds
    local variance = base * 0.1
    local interval = GetScaledValue(base - variance, base + variance, 0, 1, math.random())

    neighbors.next_nearbyscan_time = props.o.timer + interval

    neighbors.nearby = orb_pool.FindNearby(props.pos, neighbors.search_radius, props.id)

    return neighbors.nearby
end

-- NOTE: returns true if count is zero
function this.AreAllAlive(nearby)
    for _, item in ipairs(nearby) do
        if not item.orb.is_alive then
            return false
        end
    end

    return true
end

function this.GetCenterVelocity(nearby, count)
    local center_x = 0
    local center_y = 0
    local center_z = 0

    local vel_x = 0
    local vel_y = 0
    local vel_z = 0

    local actual_count = 0

    for _, item in ipairs(nearby) do
        if item.orb.is_alive then
            center_x = center_x + item.orb.props.pos.x
            center_y = center_y + item.orb.props.pos.y
            center_z = center_z + item.orb.props.pos.z

            vel_x = vel_x + item.orb.props.vel.x
            vel_y = vel_y + item.orb.props.vel.y
            vel_z = vel_z + item.orb.props.vel.z

            actual_count = actual_count + 1
            if actual_count >= count then
                do break end
            end
        end
    end

    if actual_count == 0 then
        return
            Vector4.new(0, 0, 0, 1),
            Vector4.new(0, 0, 0, 1),
            actual_count

    else
        return
            Vector4.new(center_x / actual_count, center_y / actual_count, center_z / actual_count, 1),
            Vector4.new(vel_x / actual_count, vel_y / actual_count, vel_z / actual_count, 1),
            actual_count
    end
end

function this.GetProjectedPoint(pos, vel, seconds)
    return Vector4.new(
        pos.x + (vel.x * seconds),
        pos.y + (vel.y * seconds),
        pos.z + (vel.z * seconds),
        1)
end

function this.TowardCenter(center, pos, toward_flock_center, max_accel)
    local toward_center = SubtractVectors(center, pos)
    local distance_center_sqr = GetVectorLengthSqr(toward_center)

    if IsNearZero(distance_center_sqr) then
        return 0, 0, 0
    end

    local distance_center = math.sqrt(distance_center_sqr)
    local toward_center_unit = DivideVector(toward_center, distance_center)

    local percent_accel = swarm_util.ApplyPropertyMult(toward_flock_center, distance_center)

    return
        toward_center_unit.x * percent_accel * max_accel,
        toward_center_unit.y * percent_accel * max_accel,
        toward_center_unit.z * percent_accel * max_accel,
        distance_center
end

function this.AlignVelocity(flock_vel, orb_vel, distance_center, align_flock_velocity_speed, align_flock_velocity_distance, max_accel, max_speed)
    -- There's a chance that accel is zero when the orb is too far away, so check this first
    local percent_accel_dist = swarm_util.ApplyPropertyMult(align_flock_velocity_distance, distance_center)

    if IsNearZero(percent_accel_dist) then
        return 0, 0, 0
    end

    -- Now take the difference between orb's velocity and flock's velocity
    local vel_diff = SubtractVectors(flock_vel, orb_vel)
    local speed_diff = GetVectorLength(vel_diff)

    local speed_percent = speed_diff / max_speed

    if IsNearZero(speed_percent) then
        return 0, 0, 0
    end

    local percent_accel_speed = swarm_util.ApplyPropertyMult(align_flock_velocity_speed, speed_percent)

    -- Multiply these with the unit of velocity diff
    return
        (vel_diff.x / speed_diff) * percent_accel_speed * percent_accel_dist * max_accel,
        (vel_diff.y / speed_diff) * percent_accel_speed * percent_accel_dist * max_accel,
        (vel_diff.z / speed_diff) * percent_accel_speed * percent_accel_dist * max_accel
end

function this.OrthFlockVelocity(flock_vel, orb_vel, distance_center, drag_orth_flock_velocity_speed, drag_orth_flock_velocity_distance, max_accel, max_speed)
    -- There's a chance that accel is zero when the orb is too far away, so check this first
    local percent_accel_dist = swarm_util.ApplyPropertyMult(drag_orth_flock_velocity_distance, distance_center)

    if IsNearZero(percent_accel_dist) then
        return 0, 0, 0
    end

    -- Find the part of the orb's velocity that is perpendicular from flock's velocity
    local up = CrossProduct3D(flock_vel, orb_vel)       -- not taking unit vectors to keep it cheap

    if IsNearZero(GetVectorLengthSqr(up)) then
        return 0, 0, 0      -- they are either parallel or one of the vectors is near zero
    end

    local orth_unit = ToUnit(CrossProduct3D(flock_vel, up))

    local vel_orth = GetProjectedVector_AlongVector(orb_vel, orth_unit, true)
    local speed_orth = GetVectorLength(vel_orth)

    local speed_percent = speed_orth / max_speed

    local percent_accel_speed = swarm_util.ApplyPropertyMult(drag_orth_flock_velocity_speed, speed_percent)

    -- Multiply these with the unit of orth velocity (negated to be drag)
    return
        (vel_orth.x / -speed_orth) * percent_accel_speed * percent_accel_dist * max_accel,
        (vel_orth.y / -speed_orth) * percent_accel_speed * percent_accel_dist * max_accel,
        (vel_orth.z / -speed_orth) * percent_accel_speed * percent_accel_dist * max_accel
end

function this.AvoidOthers(pos, vel, nearby, repel_other_orb, repel_other_orb_velocitytoward, max_accel)
    local accel_x = 0
    local accel_y = 0
    local accel_z = 0

    for _, item in ipairs(nearby) do
        if item.orb.is_alive then
            local x, y, z = this.AvoidOthers_Other(pos, vel, item.orb.props.pos, repel_other_orb, repel_other_orb_velocitytoward, max_accel)
            accel_x = accel_x + x
            accel_y = accel_y + y
            accel_z = accel_z + z
        end
    end

    return accel_x, accel_y, accel_z
end
function this.AvoidOthers_Other(pos, vel, other_pos, repel_other_orb, repel_other_orb_velocitytoward, max_accel)
    -- Repulse based on distance
    local to_other = SubtractVectors(other_pos, pos)
    local dist_to_other = GetVectorLength(to_other)

    local percent_accel = swarm_util.ApplyPropertyMult(repel_other_orb, dist_to_other)

    local accel_x = (to_other.x / -dist_to_other) * percent_accel * max_accel
    local accel_y = (to_other.y / -dist_to_other) * percent_accel * max_accel
    local accel_z = (to_other.z / -dist_to_other) * percent_accel * max_accel

    -- Drag of part of velocity going toward other
    local accel_drag_x = 0
    local accel_drag_y = 0
    local accel_drag_z = 0

    if DotProduct3D(vel, to_other) > 0 then
        local vel_toward_unit = ToUnit(GetProjectedVector_AlongVector(vel, Vector4.new(to_other.x / dist_to_other, to_other.y / dist_to_other, to_other.z / dist_to_other, 1), false))

        local percent_drag_accel = swarm_util.ApplyPropertyMult(repel_other_orb_velocitytoward, dist_to_other)

        accel_drag_x = -vel_toward_unit.x * percent_drag_accel * max_accel
        accel_drag_y = -vel_toward_unit.y * percent_drag_accel * max_accel
        accel_drag_z = -vel_toward_unit.z * percent_drag_accel * max_accel
    end

    return
        accel_x + accel_drag_x,
        accel_y + accel_drag_y,
        accel_z + accel_drag_z
end

return OrbSwarmNeighbors