local OrbSwarmLimits = {}

local this = {}

local swarm_util = require "processing/swarm_util"

local SHOW_DEBUG = false
local set_debug_categories = false
local debug_categories_ORIG = CreateEnum("LIMIT_MaxesBySpeed", "LIMIT_MaxSpeedByDist", "LIMIT_OutOfBounds_SpeedingAway", "LIMIT_OutOfBounds", "LIMIT_OverSpeed", "LIMIT_DragOrthVelocity")

--TODO: instead of spherical boundary, make an ellipsoid
--  Main boundary check should stay a sphere.  Just apply a ceiling/floor when in bounds (either ellipsoid, or just a larger sphere with offset centerpoint)

-- This applies extra acceleration when the orb exceeds predefined limits (too far away from player, going too fast)
-- Returns:
--  accelX, accelY, accelZ, should_cap_accel
function OrbSwarmLimits.GetAccelLimits_ORIG(props, limits, rel_vel, rel_speed_sqr)
    this.EnsureDebugCategoriesSet_ORIG()

    local max_speed, max_dist = this.GetMaxes_BySpeed_ORIG(props, limits)

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
                    false
            end

        else
            local accelX_boundary, accelY_boundary, accelZ_boundary, boundary_percent = this.OutOfBounds(limits, to_player, dist, min_dist, max_dist)

            return
                accelX_boundary + accelX_orthdrag,
                accelY_boundary + accelY_orthdrag,
                accelZ_boundary + accelZ_orthdrag,
                boundary_percent,
                false
        end

    elseif rel_speed_sqr > min_speed * min_speed then
        local rel_speed = math.sqrt(rel_speed_sqr)
        local accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent = this.OverSpeed(limits, rel_vel, min_speed, max_speed, rel_speed)
        return accelX_maxspeed, accelY_maxspeed, accelZ_maxspeed, maxspeed_percent, true

    else
        return 0, 0, 0, nil, true
    end
end

function OrbSwarmLimits.GetAccelLimits(props, limits, rel_vel, rel_speed_sqr)
    this.EnsureDebugCategoriesSet()

    -- Increase maxes if the player is moving quickly
    local max_accel, max_dist, max_speed = this.GetMaxes_ByPlayerSpeed(props, limits)

    -- Get distance from player
    local to_player = SubtractVectors(props.o.pos, props.pos)
    local dist_to_player = GetVectorLength(to_player)

    local is_outofbounds = dist_to_player > max_dist

    -- Adjust maxes if the orb is too far away from the player
    max_accel, max_speed = this.GetMaxes_ByDistToPlayer(limits, dist_to_player, max_accel, max_dist, max_speed)

    local accel_x = 0
    local accel_y = 0
    local accel_z = 0

    local rel_speed = nil

    if rel_speed_sqr > max_speed * max_speed then
        rel_speed = math.sqrt(rel_speed_sqr)
        local overspeed_mult = (rel_speed - max_speed) / max_speed

        -- Over speed brake
        local speed_x, speed_y, speed_z = this.Drag_Overspeed(limits.drag_overspeed, max_accel, rel_vel, rel_speed, overspeed_mult)
        accel_x = accel_x + speed_x
        accel_y = accel_y + speed_y
        accel_z = accel_z + speed_z

        -- OverSpeed, OutOfBounds, VelocityAway (additional brake, avoids a slow turnaround, which would cause oscillation)
        if is_outofbounds and DotProduct3D(rel_vel, to_player) < 0 then
            local speedaway_x, speedaway_y, speedaway_z = this.Drag_Overspeed(limits.drag_outofbounds_overspeed_velaway, max_accel, rel_vel, rel_speed, overspeed_mult)
            accel_x = accel_x + speedaway_x
            accel_y = accel_y + speedaway_y
            accel_z = accel_z + speedaway_z
        end
    end

    if is_outofbounds then
        -- out of bounds toward player
        local oob_x, oob_y, oob_z = this.OutOfBounds_Accel(limits.outofbounds_accel, to_player, dist_to_player, max_dist, max_accel)
        accel_x = accel_x + oob_x
        accel_y = accel_y + oob_y
        accel_z = accel_z + oob_z

        -- out of bounds orth brake
        if not rel_speed then
            rel_speed = math.sqrt(rel_speed_sqr)
        end

        local orthvel_x, orthvel_y, orthvel_z = this.Drag_OutOfBounds_OrthVelocity(limits.drag_outofbounds_orthvelocity, to_player, dist_to_player, rel_vel, rel_speed, max_accel, max_speed)
        accel_x = accel_x + orthvel_x
        accel_y = accel_y + orthvel_y
        accel_z = accel_z + orthvel_z
    end

    return accel_x, accel_y, accel_z, false     --TODO: get rid of the bool
end

----------------------------------- Private Methods -----------------------------------

-- This expands the max accel, distance from player, speed based on the player's speed
-- Useful when the player is driving or flying around.  The orbs have an easier time keeping up
function this.GetMaxes_ByPlayerSpeed(props, limits)
    local vel = props.o:Custom_CurrentlyFlying_GetVelocity(props.o.vel)       -- a mod could be flying, so use that velocity else the velocity known by the game
    local speed = GetVectorLength(vel)

    return
        limits.max_accel * swarm_util.ApplyPropertyMult(limits.max_by_playerspeed.accel, speed),
        limits.max_dist_player * swarm_util.ApplyPropertyMult(limits.max_by_playerspeed.dist, speed),
        limits.max_speed * swarm_util.ApplyPropertyMult(limits.max_by_playerspeed.speed, speed)
end

-- When the orb is too far from the player, this helps it get back easier by increasing its abilities
function this.GetMaxes_ByDistToPlayer(limits, dist_to_player, max_accel, max_dist, max_speed)
    if dist_to_player <= max_dist then
        return max_accel, max_speed
    end

    local amount_over = (dist_to_player - max_dist) / max_dist

    return
        max_accel * swarm_util.ApplyPropertyMult(limits.max_by_distfromplayer.accel, amount_over),
        max_speed * swarm_util.ApplyPropertyMult(limits.max_by_distfromplayer.max_speed, amount_over)
end

function this.Drag_Overspeed(property_mult, max_accel, rel_vel, rel_speed, overspeed_mult)
    local maxaccel_percent = swarm_util.ApplyPropertyMult(property_mult, overspeed_mult)

    local accel = max_accel * maxaccel_percent

    return
        (rel_vel.x / rel_speed) * -accel,       -- negative accel, because it's a drag
        (rel_vel.y / rel_speed) * -accel,
        (rel_vel.z / rel_speed) * -accel
end

function this.OutOfBounds_Accel(outofbounds_accel, to_player, dist_to_player, max_dist, max_accel)
    local overdist_percent = (dist_to_player - max_dist) / max_dist

    local maxaccel_percent = swarm_util.ApplyPropertyMult(outofbounds_accel, overdist_percent)

    local accel = max_accel * maxaccel_percent

    return
        (to_player.x / dist_to_player) * accel,
        (to_player.y / dist_to_player) * accel,
        (to_player.z / dist_to_player) * accel
end

function this.Drag_OutOfBounds_OrthVelocity(drag_outofbounds_orthvelocity, to_player, dist_to_player, rel_vel, rel_speed, max_accel, max_speed)
    if IsNearZero(rel_speed) then
        return 0, 0, 0
    end

    local to_player_unit = DivideVector(to_player, dist_to_player)
    local rel_vel_unit = DivideVector(rel_vel, rel_speed)

    local orth_up_unit = CrossProduct3D(rel_vel_unit, to_player_unit)
    local orth_vel_unit = CrossProduct3D(to_player_unit, orth_up_unit)

    local orth_vel = GetProjectedVector_AlongVector(rel_vel, orth_vel_unit, false)
    local orth_speed = GetVectorLength(orth_vel)

    local speed_percent = orth_speed / max_speed

    local maxaccel_percent = swarm_util.ApplyPropertyMult(drag_outofbounds_orthvelocity, speed_percent)

    local accel = max_accel * maxaccel_percent

    return
        (orth_vel.x / orth_speed) * -accel,
        (orth_vel.y / orth_speed) * -accel,
        (orth_vel.z / orth_speed) * -accel
end

function this.EnsureDebugCategoriesSet()
    if set_debug_categories then
        do return end
    end

    -- debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_MaxesBySpeed, "BB66532C", "FFF", nil, true, nil, nil, 0.2, 0.3)
    -- debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_MaxSpeedByDist, "B96B6A2B", "FFF", nil, true, nil, nil, 0.2, 0.35)

    -- debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_OutOfBounds_SpeedingAway, "B841355E", "FFF", nil, true, nil, nil, 0.2, 0.4)
    -- debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_OutOfBounds, "B84B194B", "FFF", nil, true, nil, nil, 0.2, 0.45)
    -- debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_OverSpeed, "B85A1826", "FFF", nil, true, nil, nil, 0.2, 0.5)
    -- debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_DragOrthVelocity, "B89E2E1F", "FFF", nil, true, nil, nil, 0.2, 0.55)

    set_debug_categories = true
end


----------------------------------- Private Methods ORIG -----------------------------------

function this.GetMaxes_BySpeed_ORIG(props, limits)
    local overspeed_start = limits.max_speed * limits.maxbyspeed.percent_start

    local vel = props.o:Custom_CurrentlyFlying_GetVelocity(props.o.vel)       -- a mod could be flying, so use that velocity else the velocity known by the game
    local speed_sqr = GetVectorLengthSqr(vel)

    if speed_sqr < overspeed_start * overspeed_start then
        return limits.max_speed, limits.max_dist_player
    end

    local speed = math.sqrt(speed_sqr)

    local overspeed_percent = (speed - overspeed_start) / overspeed_start

    local speed_mult = swarm_util.ApplyPropertyMult_ORIG(limits.maxbyspeed.speed_mult, overspeed_percent)

    local dist_mult = swarm_util.ApplyPropertyMult_ORIG(limits.maxbyspeed.dist_mult, overspeed_percent)

    if SHOW_DEBUG then
        debug_render_screen.Add_Text2D(nil, nil, "overspeed\r\nspeed_mult: " .. tostring(Round(speed_mult, 2)) .. "\r\ndist_mult: " .. tostring(Round(dist_mult, 2)), debug_categories_ORIG.LIMIT_MaxesBySpeed)
    end

    return
        limits.max_speed * speed_mult,
        limits.max_dist_player * dist_mult
end

-- This increases the allowed speed when the orb gets too far from the player.  This allows the orb to catch up more quickly
-- TODO: need to allow a larger max acceleration as well
function this.GetMaxSpeed_ByDistance(limits, max_speed, dist_sqr, max_dist)
    if dist_sqr < max_dist * max_dist then
        return max_speed, nil
    end

    local dist = math.sqrt(dist_sqr)

    local overdist_percent = (dist - max_dist) / max_dist

    local speed_mult = swarm_util.ApplyPropertyMult_ORIG(limits.maxbydist.speed_mult, overdist_percent)

    if SHOW_DEBUG then
        debug_render_screen.Add_Text2D(nil, nil, "overdist\r\nspeed_mult: " .. tostring(Round(speed_mult, 2)), debug_categories_ORIG.LIMIT_MaxSpeedByDist)
    end

    return
        max_speed * speed_mult,
        dist
end

function this.OutOfBounds_SpeedingAway(limits, rel_vel, min_speed, max_speed, rel_speed, to_player, min_dist, max_dist, dist)
    local percent = GetScaledValue(0, 1, min_speed, max_speed, rel_speed)
    local mult = swarm_util.ApplyPropertyMult_ORIG(limits.outofbounds_speedingaway.accel_mult_speed, percent)
    local accel_speed = mult * limits.max_accel

    local percent = GetScaledValue(0, 1, min_dist, max_dist, dist)
    local mult = swarm_util.ApplyPropertyMult_ORIG(limits.outofbounds_speedingaway.accel_mult_bounds, percent)
    local accel_bounds = mult * limits.max_accel

    if SHOW_DEBUG then
        debug_render_screen.Add_Text2D(nil, nil, "oob, speed away\r\naccel_speed: " .. tostring(Round(accel_speed, 2)) .. ", accel_bounds: " .. tostring(Round(accel_bounds, 2)), debug_categories_ORIG.LIMIT_OutOfBounds_SpeedingAway)
    end

    return
        ((rel_vel.x / rel_speed) * -accel_speed) + ((to_player.x / dist) * accel_bounds),
        ((rel_vel.y / rel_speed) * -accel_speed) + ((to_player.y / dist) * accel_bounds),
        ((rel_vel.z / rel_speed) * -accel_speed) + ((to_player.z / dist) * accel_bounds),
        math.max(rel_speed / max_speed, dist / max_dist)
end

function this.OutOfBounds(limits, to_player, dist, min_dist, max_dist)
    -- 0 at 0.75, 1 at 1, 3 at 1.5
    --local accel = 4 * dist - 3

    -- local accel = GetScaledValue(0, 3, min_dist, max_dist * 1.5, dist)
    -- accel = Clamp(0, 2, accel)
    -- accel = accel * limits.max_accel

    local percent = (dist - min_dist) / min_dist
    local mult = swarm_util.ApplyPropertyMult_ORIG(limits.outofbounds.accel_mult, percent)
    local accel = mult * limits.max_accel

    if SHOW_DEBUG then
        debug_render_screen.Add_Text2D(nil, nil, "oob\r\naccel: " .. tostring(Round(accel, 2)), debug_categories_ORIG.LIMIT_OutOfBounds)
    end

    return
        (to_player.x / dist) * accel,
        (to_player.y / dist) * accel,
        (to_player.z / dist) * accel,
        dist / max_dist
end

function this.OverSpeed(limits, rel_vel, min_speed, max_speed, rel_speed)
    -- local accel = GetScaledValue(0, 1, min_speed, max_speed, rel_speed)
    -- accel = Clamp(0, 2, accel)
    -- accel = accel * limits.max_accel

    local percent = (rel_speed - min_speed) / min_speed
    local mult = swarm_util.ApplyPropertyMult_ORIG(limits.overspeed.accel_mult, percent)
    local accel = mult * limits.max_accel

    if SHOW_DEBUG then
        debug_render_screen.Add_Text2D(nil, nil, "over speed\r\naccel: " .. tostring(Round(accel, 2)), debug_categories_ORIG.LIMIT_OverSpeed)
    end

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

    -- local accel_percent = GetScaledValue(0, 0.3333, bounds_max_dist, bounds_max_dist * 2, dist_to_player)
    -- accel_percent = Clamp(0, 0.6667, accel_percent)

    local percent = (dist_to_player - bounds_max_dist) / bounds_max_dist
    local accel_percent = swarm_util.ApplyPropertyMult_ORIG(limits.dragorthvelocity.accel_mult, percent)

    local accel = orth_speed * accel_percent

    if SHOW_DEBUG then
        debug_render_screen.Add_Text2D(nil, nil, "drag orth\r\naccel: " .. tostring(Round(accel, 2)), debug_categories_ORIG.LIMIT_DragOrthVelocity)
    end

    return
        orth_vel.x * -accel,
        orth_vel.y * -accel,
        orth_vel.z * -accel
end

function this.EnsureDebugCategoriesSet_ORIG()
    if set_debug_categories then
        do return end
    end

    debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_MaxesBySpeed, "BB66532C", "FFF", nil, true, nil, nil, 0.2, 0.3)
    debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_MaxSpeedByDist, "B96B6A2B", "FFF", nil, true, nil, nil, 0.2, 0.35)

    debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_OutOfBounds_SpeedingAway, "B841355E", "FFF", nil, true, nil, nil, 0.2, 0.4)
    debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_OutOfBounds, "B84B194B", "FFF", nil, true, nil, nil, 0.2, 0.45)
    debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_OverSpeed, "B85A1826", "FFF", nil, true, nil, nil, 0.2, 0.5)
    debug_render_screen.DefineCategory(debug_categories_ORIG.LIMIT_DragOrthVelocity, "B89E2E1F", "FFF", nil, true, nil, nil, 0.2, 0.55)

    set_debug_categories = true
end



return OrbSwarmLimits