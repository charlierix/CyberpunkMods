local OrbSwarmLimits = {}

local this = {}


--TODO: instead of spherical boundary, make an ellipsoid
--  Main boundary check should stay a sphere.  Just apply a ceiling/floor when in bounds (either ellipsoid, or just a larger sphere with offset centerpoint)


function OrbSwarmLimits.GetAccelLimits(props, limits, rel_vel, rel_speed_sqr)
    local max_speed, max_dist = this.GetMaxes_BySpeed(props, limits)

    local to_player = SubtractVectors(props.o.pos, props.pos)
    local dist_sqr = GetVectorLengthSqr(to_player)

    -- Allow a larger max speed based on how far away the orb is from the player.  I used low flying v to quickly escape an
    -- area.  Once I stopped, the orbs were 200 away and coming to me at their regular max speed
    local max_speed, dist = this.GetMaxSpeed_ByDistance(limits, max_speed, dist_sqr, max_dist)

    local min_dist = max_dist * limits.boundary_percent_start
    local min_speed = max_speed * limits.speed_percent_start

    if dist_sqr > min_dist * min_dist then
        if not dist then
            dist = math.sqrt(dist_sqr)
        end

        local rel_speed = math.sqrt(rel_speed_sqr)

        local accelX_orthdrag, accelY_orthdrag, accelZ_orthdrag = this.DragOrthVelocity(limits, to_player, dist, rel_vel, rel_speed, max_dist)

        if rel_speed > min_speed then
            if DotProduct3D(rel_vel, to_player) < 0 then
                -- Velocity is away from player while out of bounds.  Need to apply extra drag.  Without this, the orb accelerates toward
                -- the player to get back in bounds, but then overshoots, ending up in an oscillation
                local accelX_limit, accelY_limit, accelZ_limit, limit_percent = this.OutOfBounds_SpeedingAway(limits, rel_vel, min_speed, max_speed, rel_speed, to_player, min_dist, max_dist, dist)

                return
                    accelX_limit + accelX_orthdrag,
                    accelY_limit + accelY_orthdrag,
                    accelZ_limit + accelZ_orthdrag,
                    limit_percent,
                    false       -- the accel is capped inside the above function, don't cap it later

            else
                local accelX_boundary, accelY_boundary, accelZ_boundary, boundary_percent = this.OutOfBounds(limits, to_player, dist, min_dist, max_dist)
                local accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent = this.OverSpeed(limits, rel_vel, min_speed, max_speed, rel_speed)

                return
                    accelX_boundary + accelX_maxspeed + accelX_orthdrag,
                    accelY_boundary + accelY_maxspeed + accelY_orthdrag,
                    accelZ_boundary + accelZ_maxspeed + accelZ_orthdrag,
                    math.max(boundary_percent, maxspeed_percent),
                    true
            end

        else
            local accelX_boundary, accelY_boundary, accelZ_boundary, boundary_percent = this.OutOfBounds(limits, to_player, dist, min_dist, max_dist)

            return
                accelX_boundary + accelX_orthdrag,
                accelY_boundary + accelY_orthdrag,
                accelZ_boundary + accelZ_orthdrag,
                boundary_percent,
                true
        end

    elseif rel_speed_sqr > min_speed * min_speed then
        local rel_speed = math.sqrt(rel_speed_sqr)
        local accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent = this.OverSpeed(limits, rel_vel, min_speed, max_speed, rel_speed)
        return accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent, true

    else
        return 0, 0, 0, nil, true
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetMaxes_BySpeed(props, limits)
    local overspeed_start = limits.max_speed * limits.maxbyspeed.percent_start

    local vel = props.o:Custom_CurrentlyFlying_GetVelocity(props.o.vel)       -- a mod could be flying, so use that velocity else the velocity known by the game
    local speed_sqr = GetVectorLengthSqr(vel)

    if speed_sqr < overspeed_start * overspeed_start then
        return limits.max_speed, limits.max_dist_player
    end

    local speed = math.sqrt(speed_sqr)

    local overspeed_percent = (speed - overspeed_start) / overspeed_start

    local speed_mult = overspeed_percent * limits.maxbyspeed.speed_mult_rate
    speed_mult = Clamp(1, limits.maxbyspeed.speed_mult_cap)

    local dist_mult = overspeed_percent * limits.maxbyspeed.dist_mult_rate
    dist_mult = Clamp(1, limits.maxbyspeed.dist_mult_cap, dist_mult)

    return
        limits.max_speed * speed_mult,
        limits.max_dist_player * dist_mult
end

function this.GetMaxSpeed_ByDistance(limits, max_speed, dist_sqr, max_dist)
    if dist_sqr < max_dist * max_dist then
        return max_speed, nil
    end

    local dist = math.sqrt(dist_sqr)

    local overdist_percent = (dist - max_dist) / max_dist

    local speed_mult = overdist_percent * limits.maxbydist.speed_mult_rate
    speed_mult = Clamp(1, limits.maxbydist.speed_mult_cap, speed_mult)

    return
        max_speed * speed_mult,
        dist
end

function this.OutOfBounds_SpeedingAway(limits, rel_vel, min_speed, max_speed, rel_speed, to_player, min_dist, max_dist, dist)
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

function this.OutOfBounds(limits, to_player, dist, min_dist, max_dist)
    -- 0 at 0.75, 1 at 1, 3 at 1.5
    --local accel = 4 * dist - 3

    local accel = GetScaledValue(0, 3, min_dist, max_dist * 1.5, dist)
    accel = Clamp(0, 2, accel)
    accel = accel * limits.max_accel

    return
        (to_player.x / dist) * accel,
        (to_player.y / dist) * accel,
        (to_player.z / dist) * accel,
        dist / max_dist
end

function this.OverSpeed(limits, rel_vel, min_speed, max_speed, rel_speed)
    local accel = GetScaledValue(0, 1, min_speed, max_speed, rel_speed)
    accel = Clamp(0, 2, accel)
    accel = accel * limits.max_accel

    return
        (rel_vel.x / rel_speed) * -accel,
        (rel_vel.y / rel_speed) * -accel,
        (rel_vel.z / rel_speed) * -accel,
        rel_speed / max_speed
end

function this.DragOrthVelocity(limits, to_player, dist_to_player, rel_vel, rel_speed, bounds_max_dist)
    if IsNearZero(dist_to_player) or IsNearZero(rel_speed) then
        return 0, 0, 0
    end

    local to_player_unit = DivideVector(to_player, dist_to_player)
    local rel_vel_unit = DivideVector(rel_vel, rel_speed)

    local orth_up_unit = CrossProduct3D(rel_vel_unit, to_player_unit)
    local orth_vel_unit = CrossProduct3D(to_player_unit, orth_up_unit)

    local orth_vel = GetProjectedVector_AlongVector(rel_vel, orth_vel_unit, false)
    local orth_speed = GetVectorLength(orth_vel)

    local accel_percent = GetScaledValue(0, 0.3333, bounds_max_dist, bounds_max_dist * 2, dist_to_player)
    accel_percent = Clamp(0, 0.6667, accel_percent)

    local accel = orth_speed * accel_percent

    return
        orth_vel.x * -accel,
        orth_vel.y * -accel,
        orth_vel.z * -accel
end

return OrbSwarmLimits