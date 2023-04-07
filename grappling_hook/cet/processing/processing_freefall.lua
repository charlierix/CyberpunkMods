local this = {}

--TODO: let the player stear a little.  better yet, emulate a wing suit

function Process_FreeFall(o, player, vars, const, keys, debug, deltaTime)
    if debug_render_screen.IsEnabled() then
        local position, look_dir = o:GetCrosshairInfo()
        debug_render_screen.Add_Dot(position, nil, "777", nil, nil, 2, nil)
    end

    vars.energy = RecoverEnergy(vars.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate * player.energy_tank.flying_percent, deltaTime)

    vars.swingprops_override:Tick(deltaTime)

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

    local boost_x, boost_y, boost_z = GetAccel_Boosting(o, vars)
    local drag1_x, drag1_y, drag1_z = ClampVelocity_Drag(vars.vel, const.maxSpeed)
    local drag2_x, drag2_y, drag2_z = GetAccel_AirFriction(vars.vel, Clamp(0, 1, -keys.analog_y), vars.swingprops_override)       -- pressing back is 100% break
    local antigrav_z = this.GetAntiGravity(o, vars, vars.grapple.anti_gravity, isAirborne)

    local accel_x = boost_x + drag1_x + drag2_x
    local accel_y = boost_y + drag1_y + drag2_y
    local accel_z = boost_z + drag1_z + drag2_z + antigrav_z

    ApplyAccel_Teleporting(o, vars, const, keys, debug, accel_x, accel_y, accel_z, deltaTime)
end

----------------------------------- Private Methods -----------------------------------

function this.GetAntiGravity(o, vars, anti_gravity, isAirborne)
    if not anti_gravity then
        return 0
    end

    local elapsed = o.timer - vars.startTime
    if elapsed > anti_gravity.fade_duration then
        return 0
    end

    local accel_z = GetAntiGravity(anti_gravity, isAirborne)     -- cancel gravity

    -- Reduce based on elapsed time
    accel_z = accel_z * GetScaledValue(1, 0, 0, anti_gravity.fade_duration, elapsed)

    return accel_z
end