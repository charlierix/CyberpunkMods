-- Air Dash is like a small rocket thruster that propels the player in the direction
-- that they are looking
--
-- It's meant to be a bridge between aiming and grappling, to get them to a grapple
-- point at a high energy cost
--
-- Though, if airdash is highly upgraded, and the corresponding grapple is set super
-- weak, it could basically be its own thing.  For example, set the grapple to be
-- really short range, almost no forces, incredibly small dot product threshold
function Process_AirDash(o, player, vars, const, debug, deltaTime)
    local dash = vars.grapple.aim_straight.air_dash

    -- Reduce Energy
    local newEnergy, isEnergyEmpty = ConsumeEnergy(vars.energy, dash.energyBurnRate * (1 - dash.burnReducePercent), deltaTime)
    if isEnergyEmpty then
        vars.animation_lowEnergy:ActivateAnimation()
        Transition_ToStandard(vars, const, debug, o)
        do return end
    else
        vars.energy = newEnergy
    end

    if SwitchedFlightMode(o, player, vars, const) then
        do return end
    end

    -- If they are on the ground after being airborne, then exit flight
    local shouldStop, _ = ShouldStopFlyingBecauseGrounded(o, vars)
    if shouldStop then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    o:GetCamera()

    -- Fire a ray, according to initial conditions
    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)

    local hitPoint, _ = RayCast_HitPoint(from, o.lookdir_forward, vars.rayLength, const.grappleMinResolution, o)

    -- See if the ray hit something
    if hitPoint then
        -- Ensure pin is drawn and placed properly (flight pin, not aim pin)
        EnsureMapPinVisible(hitPoint, vars.grapple.mappin_name, vars, o)

        Transition_ToFlight(vars, const, o, from, hitPoint)
        do return end
    end

    -- Update map pin
    local aimPoint = Vector4.new(from.x + (o.lookdir_forward.x * vars.rayLength), from.y + (o.lookdir_forward.y * vars.rayLength), from.z + (o.lookdir_forward.z * vars.rayLength), 1)
    EnsureMapPinVisible(aimPoint, dash.mappin_name, vars, o)

    -- Get the component of the velocity along the request line
    local vel_along, isSameDir = GetProjectedVector_AlongVector(o.vel, o.lookdir_forward, true)

    -- Figure out the delta between actual and desired speed
    local speed = math.sqrt(GetVectorLengthSqr(vel_along))

    -- Calculate forward accel
    local air_x, air_y, air_z, percent = GetPullAccel_Constant(dash.accel, o.lookdir_forward, 1000, speed, not isSameDir)

    -- Need to multiply by percent, otherwise they will just accelerate up once they reach the desired
    -- speed along the dash vector
    local antigrav_z = 16 * percent

    -- Apply the acceleration
    local accel_x = air_x * deltaTime
    local accel_y = air_y * deltaTime
    local accel_z = (air_z + antigrav_z) * deltaTime

    -- debug.accel_x = Round(accel_x / deltaTime, 1)
    -- debug.accel_y = Round(accel_y / deltaTime, 1)
    -- debug.accel_z = Round(accel_z / deltaTime, 1)

    o.player:GrapplingHook_AddImpulse(accel_x, accel_y, accel_z)
end