local OrbSwarmLimits = {}

local this = {}

local swarm_util = require "processing/swarm_util"

local SHOW_DEBUG = false
local set_debug_categories = false
local debug_categories = CreateEnum("LIMIT_Maxes_PlayerSpeed", "LIMIT_Maxes_OOB", "LIMIT_OverSpeed", "LIMIT_OOB", "LIMIT_DragOrthVelocity", "LIMIT_Center")

-- This applies extra acceleration when the orb exceeds predefined limits (too far away from player, going too fast)
-- Returns:
--  accelX, accelY, accelZ, should_cap_accel
function OrbSwarmLimits.GetAccelLimits(props, limits, rel_vel, rel_speed_sqr)
    this.EnsureDebugCategoriesSet()

    -- Increase maxes if the player is moving quickly
    local max_accel, max_dist, max_speed = this.GetMaxes_ByPlayerSpeed(props, limits)

    -- Move the center point to be in front of the player a little
    local center = this.GetCenter(props.o, max_dist)

    -- Get distance from center
    local to_center = SubtractVectors(center, props.pos)
    local dist_to_center = GetVectorLength(to_center)

    local is_outofbounds = dist_to_center > max_dist

    -- Adjust maxes if the orb is too far away from the center
    max_accel, max_speed = this.GetMaxes_ByDistToCenter(limits, dist_to_center, max_accel, max_dist, max_speed)

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
        if is_outofbounds and DotProduct3D(rel_vel, to_center) < 0 then
            local speedaway_x, speedaway_y, speedaway_z = this.Drag_Overspeed(limits.drag_outofbounds_overspeed_velaway, max_accel, rel_vel, rel_speed, overspeed_mult)
            accel_x = accel_x + speedaway_x
            accel_y = accel_y + speedaway_y
            accel_z = accel_z + speedaway_z
        end
    end

    if is_outofbounds then
        -- out of bounds toward player
        local oob_x, oob_y, oob_z = this.OutOfBounds_Accel(limits.outofbounds_accel, to_center, dist_to_center, max_dist, max_accel)
        accel_x = accel_x + oob_x
        accel_y = accel_y + oob_y
        accel_z = accel_z + oob_z

        -- out of bounds orth brake
        if not rel_speed then
            rel_speed = math.sqrt(rel_speed_sqr)
        end

        local orthvel_x, orthvel_y, orthvel_z = this.Drag_OutOfBounds_OrthVelocity(limits.drag_outofbounds_orthvelocity, to_center, dist_to_center, rel_vel, rel_speed, max_accel, max_speed)
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

    local max_accel = limits.max_accel * swarm_util.ApplyPropertyMult(limits.max_by_playerspeed.accel, speed)
    local max_dist = limits.max_dist_center * swarm_util.ApplyPropertyMult(limits.max_by_playerspeed.dist, speed)
    local max_speed = limits.max_speed * swarm_util.ApplyPropertyMult(limits.max_by_playerspeed.speed, speed)

    if SHOW_DEBUG then
        local report = "maxes player speed: " .. tostring(Round(speed, 1)) .. "\r\naccel: " .. tostring(Round(max_accel, 1)) .. "\r\ndist: " .. tostring(Round(max_dist, 1)) .. "\r\nspeed: " .. tostring(Round(max_speed, 1))
        debug_render_screen.Add_Text2D(nil, nil, report, debug_categories.LIMIT_Maxes_PlayerSpeed)
    end

    return max_accel, max_dist, max_speed
end

-- This puts the center in front of the player a bit.  Otherwise, the orbs have an equal chance of being behind the player
function this.GetCenter(o, max_dist)
    local PROJECT_PERCENT = 0.5

    local eye_pos, look_dir = o:GetCrosshairInfo()

    local center = DivideVector(AddVectors(o.pos, eye_pos), 2)

    local project_vect = MultiplyVector(look_dir, max_dist * PROJECT_PERCENT)

    center = AddVectors(center, project_vect)

    if SHOW_DEBUG then
        debug_render_screen.Add_Dot(center, debug_categories.LIMIT_Center)
        debug_render_screen.Add_Circle(center, Vector4.new(1, 0, 0, 1), max_dist, debug_categories.LIMIT_Center)
        debug_render_screen.Add_Circle(center, Vector4.new(0, 1, 0, 1), max_dist, debug_categories.LIMIT_Center)
        debug_render_screen.Add_Circle(center, Vector4.new(0, 0, 1, 1), max_dist, debug_categories.LIMIT_Center)
    end

    return center
end

-- When the orb is too far from the center, this helps it get back easier by increasing its abilities
function this.GetMaxes_ByDistToCenter(limits, dist_to_center, max_accel, max_dist, max_speed)
    if dist_to_center <= max_dist then
        return max_accel, max_speed
    end

    local amount_over = (dist_to_center - max_dist) / max_dist

    max_accel = max_accel * swarm_util.ApplyPropertyMult(limits.max_by_distfromcenter.accel, amount_over)
    max_speed = max_speed * swarm_util.ApplyPropertyMult(limits.max_by_distfromcenter.max_speed, amount_over)

    if SHOW_DEBUG then
        local report = "maxes oob dist: " .. tostring(Round(dist_to_center, 0)) .. "\r\namount_over: " .. tostring(Round(amount_over, 1)) .. "\r\nmax_accel: " .. tostring(Round(max_accel, 1)) .. "\r\nmax_speed: " .. tostring(Round(max_speed, 1))
        debug_render_screen.Add_Text2D(nil, nil, report, debug_categories.LIMIT_Maxes_OOB)
    end

    return max_accel, max_speed
end

function this.Drag_Overspeed(property_mult, max_accel, rel_vel, rel_speed, overspeed_mult)
    local maxaccel_percent = swarm_util.ApplyPropertyMult(property_mult, overspeed_mult)

    local accel = max_accel * maxaccel_percent

    if SHOW_DEBUG then
        local report = "over speed: " .. tostring(Round(rel_speed, 1)) .. "\r\noverspeed_mult: " .. tostring(Round(overspeed_mult, 2)) .. "\r\nmaxaccel_percent: " .. tostring(Round(maxaccel_percent, 2)) .. "\r\naccel: " .. tostring(Round(accel, 1))
        debug_render_screen.Add_Text2D(nil, nil, report, debug_categories.LIMIT_OverSpeed)
    end

    return
        (rel_vel.x / rel_speed) * -accel,       -- negative accel, because it's a drag
        (rel_vel.y / rel_speed) * -accel,
        (rel_vel.z / rel_speed) * -accel
end

function this.OutOfBounds_Accel(outofbounds_accel, to_center, dist_to_center, max_dist, max_accel)
    local overdist_percent = (dist_to_center - max_dist) / max_dist

    local maxaccel_percent = swarm_util.ApplyPropertyMult(outofbounds_accel, overdist_percent)

    local accel = max_accel * maxaccel_percent

    if SHOW_DEBUG then
        local report = "oob dist: " .. tostring(Round(dist_to_center, 0)) .. "\r\noverdist_percent: " .. tostring(Round(overdist_percent, 2)) .. "\r\nmaxaccel_percent: " .. tostring(Round(maxaccel_percent, 2)) .. "\r\naccel: " .. tostring(Round(accel, 1))
        debug_render_screen.Add_Text2D(nil, nil, report, debug_categories.LIMIT_OOB)
    end

    return
        (to_center.x / dist_to_center) * accel,
        (to_center.y / dist_to_center) * accel,
        (to_center.z / dist_to_center) * accel
end

function this.Drag_OutOfBounds_OrthVelocity(drag_outofbounds_orthvelocity, to_center, dist_to_center, rel_vel, rel_speed, max_accel, max_speed)
    if IsNearZero(rel_speed) then
        return 0, 0, 0
    end

    local to_center_unit = DivideVector(to_center, dist_to_center)
    local rel_vel_unit = DivideVector(rel_vel, rel_speed)

    local orth_up_unit = CrossProduct3D(rel_vel_unit, to_center_unit)
    local orth_vel_unit = CrossProduct3D(to_center_unit, orth_up_unit)

    local orth_vel = GetProjectedVector_AlongVector(rel_vel, orth_vel_unit, false)
    local orth_speed = GetVectorLength(orth_vel)

    local speed_percent = orth_speed / max_speed

    local maxaccel_percent = swarm_util.ApplyPropertyMult(drag_outofbounds_orthvelocity, speed_percent)

    local accel = max_accel * maxaccel_percent

    if SHOW_DEBUG then
        local report = "orthvel orth_speed: " .. tostring(Round(orth_speed, 1)) .. "\r\nspeed_percent: " .. tostring(Round(speed_percent, 2)) .. "\r\nmaxaccel_percent: " .. tostring(Round(maxaccel_percent, 2)) .. "\r\naccel: " .. tostring(Round(accel, 1))
        debug_render_screen.Add_Text2D(nil, nil, report, debug_categories.LIMIT_DragOrthVelocity)
    end

    return
        (orth_vel.x / orth_speed) * -accel,
        (orth_vel.y / orth_speed) * -accel,
        (orth_vel.z / orth_speed) * -accel
end

function this.EnsureDebugCategoriesSet()
    if set_debug_categories then
        do return end
    end

    debug_render_screen.DefineCategory(debug_categories.LIMIT_Maxes_PlayerSpeed, "BB66532C", "FFF", nil, true, nil, nil, 0.2, 0.2)
    debug_render_screen.DefineCategory(debug_categories.LIMIT_Maxes_OOB, "B96B6A2B", "FFF", nil, true, nil, nil, 0.2, 0.3)

    debug_render_screen.DefineCategory(debug_categories.LIMIT_OverSpeed, "B841355E", "FFF", nil, true, nil, nil, 0.2, 0.4)
    debug_render_screen.DefineCategory(debug_categories.LIMIT_OOB, "B84B194B", "FFF", nil, true, nil, nil, 0.2, 0.5)
    debug_render_screen.DefineCategory(debug_categories.LIMIT_DragOrthVelocity, "B85A1826", "FFF", nil, true, nil, nil, 0.2, 0.6)

    debug_render_screen.DefineCategory(debug_categories.LIMIT_Center, "8444", "8444", nil, true)

    set_debug_categories = true
end

return OrbSwarmLimits