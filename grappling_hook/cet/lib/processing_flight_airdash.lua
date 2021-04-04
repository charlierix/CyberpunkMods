function Process_Flight_AirDash(o, state, const, debug, deltaTime)
    if SwitchedFlightMode(o, state, const) then
        do return end
    end

    -- If they are on the ground after being airborne, then exit flight
    if ShouldStopFlyingBecauseGrounded(o, state) then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    local args = const.airdash

    -- Check if time is up
    --TODO: Switch to an energy tank
    if o.timer - state.startTime > 3 then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    -- Fire a ray, according to initial conditions
    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)
    local hitPoint, _ = RayCast_HitPoint(from, state.rayDir, state.rayLength, const.grappleMinResolution, o)

    -- See if the ray hit something
    if hitPoint then
        -- Ensure pin is drawn and placed properly
        EnsureMapPinVisible(hitPoint, const.pull.mappinName, state, o)

        Transition_ToFlight(state, o, args.flightMode, from, hitPoint)
        do return end
    end

    -- Update map pin
    local aimPoint = Vector4.new(from.x + (state.rayDir.x * state.rayLength), from.y + (state.rayDir.y * state.rayLength), from.z + (state.rayDir.z * state.rayLength), 1)
    EnsureMapPinVisible(aimPoint, args.mappinName, state, o)

    -- Calculate forward accel
    local air_x, air_y, air_z, percent = Pull_GetAccel(state.rayDir, o.vel, args.speed, args.deadZone_speedDiff, state.rayLength, 0, args.accel)

    -- Need to multiply by percent, otherwise they will just accelerate up once they reach the desired
    -- speed along the dash vector
    local antigrav_z = 16 * percent

    -- Apply the acceleration
    local accelX = air_x * deltaTime
    local accelY = air_y * deltaTime
    local accelZ = (air_z + antigrav_z) * deltaTime

    o.player:GrapplingHook_AddImpulse(accelX, accelY, accelZ)
end