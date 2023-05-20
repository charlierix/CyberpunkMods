local OrbSwarmLimits = {}

local this = {}


--TODO: when out of bounds, apply extra drag to orthogonal velocity
--TODO: instead of spherical boundary, make an ellipsoid


function OrbSwarmLimits.GetAccelLimits(props, limits, rel_vel, rel_speed_sqr)
    local max_speed, max_dist = this.GetMaxes_BySpeed(props, limits)

    local to_player = SubtractVectors(props.o.pos, props.pos)
    local dist_sqr = GetVectorLengthSqr(to_player)

    -- Allow a larger max speed based on how far away the orb is from the player.  I used low flying v to quickly escape an
    -- area.  Once I stopped, the orbs were 200 away and coming to me at their regular max speed
    local max_speed, dist = this.GetMaxSpeed_ByDistance(max_speed, dist_sqr, max_dist)

    local min_dist = max_dist * 0.75
    local min_speed = max_speed * 0.8

    if dist_sqr > min_dist * min_dist then
        if not dist then
            dist = math.sqrt(dist_sqr)
        end

        if rel_speed_sqr > min_speed * min_speed then
            local rel_speed = math.sqrt(rel_speed_sqr)

            if DotProduct3D(rel_vel, to_player) < 0 then
                -- Velocity is away from player while out of bounds.  Need to apply extra drag.  Without this, the orb accelerates toward
                -- the player to get back in bounds, but then overshoots, ending up in an oscillation
                local accelX_limit, accelY_limit, accelZ_limit, limit_percent = this.GetAccelLimits_BoundsSpeedingAway(limits, rel_vel, min_speed, max_speed, rel_speed, to_player, min_dist, max_dist, dist)
                return accelX_limit, accelY_limit, accelZ_limit, limit_percent, false       -- the accel is capped inside the above function, don't cap it later

            else
                local accelX_boundary, accelY_boundary, accelZ_boundary, boundary_percent = this.GetAccelLimits_Bounds(limits, to_player, dist, max_dist)
                local accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent = this.GetAccelLimits_Speed(limits, rel_vel, min_speed, max_speed, rel_speed)

                return
                    accelX_boundary + accelX_maxspeed,
                    accelY_boundary + accelY_maxspeed,
                    accelZ_boundary + accelZ_maxspeed,
                    math.max(boundary_percent, maxspeed_percent),
                    true
            end

        else
            local accelX_boundary, accelY_boundary, accelZ_boundary, boundary_percent = this.GetAccelLimits_Bounds(limits, to_player, dist, max_dist)
            return accelX_boundary, accelY_boundary, accelZ_boundary, boundary_percent, true
        end

    elseif rel_speed_sqr > min_speed * min_speed then
        local rel_speed = math.sqrt(rel_speed_sqr)
        local accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent = this.GetAccelLimits_Speed(limits, rel_vel, min_speed, max_speed, rel_speed)
        return accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent, true

    else
        return 0, 0, 0, nil, true
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetMaxes_BySpeed(props, limits)
    local SPEED_THRESHOLD = 7

    local vel = props.o:Custom_CurrentlyFlying_GetVelocity(props.o.vel)       -- a mod could be flying, so use that velocity else the velocity known by the game
    local speed_sqr = GetVectorLengthSqr(vel)

    if speed_sqr < SPEED_THRESHOLD * SPEED_THRESHOLD then
        return limits.max_speed, limits.max_dist_player
    end

    local speed = math.sqrt(speed_sqr)

    local speed_mult = GetScaledValue(1, 3, SPEED_THRESHOLD, SPEED_THRESHOLD * 6, speed)
    speed_mult = Clamp(1, 6, speed_mult)

    local dist_mult = GetScaledValue(1, 2, SPEED_THRESHOLD, SPEED_THRESHOLD * 6, speed)
    dist_mult = Clamp(1, 3, dist_mult)

    return
        limits.max_speed * speed_mult,
        limits.max_dist_player * dist_mult
end
function this.GetMaxSpeed_ByDistance(max_speed, dist_sqr, max_dist)
    if dist_sqr < max_dist * max_dist then
        return max_speed, nil
    end

    local dist = math.sqrt(dist_sqr)

    local speed_mult = GetScaledValue(1, 3, max_dist, max_dist * 2, dist)
    speed_mult = Clamp(1, 12, speed_mult)

    return
        max_speed * speed_mult,
        dist
end

function this.GetAccelLimits_BoundsSpeedingAway(limits, rel_vel, min_speed, max_speed, rel_speed, to_player, min_dist, max_dist, dist)
    local accel_speed = GetScaledValue(0, 1, min_speed, max_speed, rel_speed)
    accel_speed = Clamp(0, 12, accel_speed)     -- really letting it get big so the orb can turn around quickly
    accel_speed = accel_speed * limits.max_accel

    local accel_bounds = GetScaledValue(0, 1, min_dist, max_dist, dist)
    accel_bounds = Clamp(0, 1, accel_bounds)        -- this isn't as important as reversing speed
    accel_bounds = accel_bounds * limits.max_accel

    return
        ((rel_vel.x / rel_speed) * -accel_speed) + ((to_player.x / dist) * accel_bounds),
        ((rel_vel.y / rel_speed) * -accel_speed) + ((to_player.y / dist) * accel_bounds),
        ((rel_vel.z / rel_speed) * -accel_speed) + ((to_player.z / dist) * accel_bounds),
        math.max(rel_speed / max_speed, dist / max_dist)
end
function this.GetAccelLimits_Bounds(limits, to_player, dist, max_dist)
    -- 0 at 0.75, 1 at 1, 3 at 1.5
    local accel = 4 * dist - 3
    accel = Clamp(0, 2, accel)
    accel = accel * limits.max_accel

    return
        (to_player.x / dist) * accel,
        (to_player.y / dist) * accel,
        (to_player.z / dist) * accel,
        dist / max_dist
end
function this.GetAccelLimits_Speed(limits, rel_vel, min_speed, max_speed, rel_speed)
    local accel = GetScaledValue(0, 1, min_speed, max_speed, rel_speed)
    accel = Clamp(0, 2, accel)
    accel = accel * limits.max_accel

    return
        (rel_vel.x / rel_speed) * -accel,
        (rel_vel.y / rel_speed) * -accel,
        (rel_vel.z / rel_speed) * -accel,
        rel_speed / max_speed
end

return OrbSwarmLimits