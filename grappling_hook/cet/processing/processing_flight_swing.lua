function Process_Flight_Swing(o, player, vars, const, keys, debug, deltaTime)
    if debug_render_screen.IsEnabled() then
        local position, look_dir = o:GetCrosshairInfo()
        debug_render_screen.Add_Dot(position, nil, "BBB", nil, nil, 2, nil)
    end

    vars.energy = RecoverEnergy(vars.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate * player.energy_tank.flying_percent, deltaTime)

    if HasSwitchedFlightMode(o, player, vars, const, true) then
        do return end
    end

    -- If they are on the ground after being airborne, then exit flight
    local shouldStop, isAirborne = ShouldStopFlyingBecauseGrounded(o, vars, true)
    if shouldStop then
        vars.vel = GetCollisionSafeVelocity(vars.vel, Vector4.new(0, 0, 1, 1))
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    local grapple = vars.grapple       -- this will be used a lot, save a dot reference
    local eye_pos, look_dir = o:GetCrosshairInfo()

    if IsAboveAnyPlane(vars.stop_planes, eye_pos) then
        Transition_ToFreeFall(vars, const, o)
        do return end
    end

    local _, _, grappleLen, grappleDirUnit = GetGrappleLine(o, vars, const)

    if grapple.stop_distance and grappleLen <= grapple.stop_distance then       -- swing should only use stop planes, but might as well check this
        Transition_ToFreeFall(vars, const, o)
        do return end
    end

    if grapple.minDot and (DotProduct3D(look_dir, grappleDirUnit) < grapple.minDot) then
        -- They looked too far away
        Transition_ToFreeFall(vars, const, o)
        do return end
    end

    if vars.popping_up then
        if o.timer - vars.startTime < 0.2 then
            do return end
        else
            vars.vel = o.vel
            vars.popping_up = false
        end
    end

    local straight_x, straight_y, straight_z = GetAccel_GrappleStraight(o, vars, grapple, grappleLen, grappleDirUnit, vars.vel)
    local boost_x, boost_y, boost_z = GetAccel_Boosting(o, vars)
    local drag_x, drag_y, drag_z = ClampVelocity_Drag(vars.vel, const.maxSpeed)
    local antigrav_z = GetAntiGravity(grapple.anti_gravity, isAirborne)     -- cancel gravity

    local accel_x = straight_x + boost_x + drag_x
    local accel_y = straight_y + boost_y + drag_y
    local accel_z = straight_z + boost_z + drag_z + antigrav_z

    ApplyAccel_Teleporting(o, vars, const, keys, debug, accel_x, accel_y, accel_z, deltaTime)
end