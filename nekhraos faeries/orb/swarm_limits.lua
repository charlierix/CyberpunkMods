local OrbSwarmLimits = {}

local this = {}

local swarm_util = require "processing/swarm_util"

local SHOW_DEBUG = false
local set_debug_categories = false
--local debug_categories = CreateEnum("LIMIT_", "LIMIT_")

--TODO: instead of spherical boundary, make an ellipsoid
--  Main boundary check should stay a sphere.  Just apply a ceiling/floor when in bounds (either ellipsoid, or just a larger sphere with offset centerpoint)

-- This applies extra acceleration when the orb exceeds predefined limits (too far away from player, going too fast)
-- Returns:
--  accelX, accelY, accelZ, should_cap_accel
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

return OrbSwarmLimits