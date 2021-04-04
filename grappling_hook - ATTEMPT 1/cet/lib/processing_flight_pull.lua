function Process_Flight_Pull(o, state, const, debug, deltaTime)
    if SwitchedFlightMode(o, state, const) then
        do return end
    end

    -- If they are on the ground after being airborne, then exit flight
    if ShouldStopFlyingBecauseGrounded(o, state) then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    -- If about to hit a wall, then cancel
    if state.hasBeenAirborne and IsWallCollisionImminent(o, deltaTime) then
        print("pull: stopping on wall")

        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    local args = const.pull

    local _, _, grappleLen, grappleDirUnit = GetGrappleLine(o, state, const)

    o:GetCamera()

    if DotProduct3D(o.lookdir_forward, grappleDirUnit) < args.minDot then
        -- They looked too far away
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    -- Cancel gravity
    local antigrav_z = Pull_GetAntiGravity(args.antigrav_percent)

    -- Apply velocity toward anchor
    local anchor_x, anchor_y, anchor_z = Pull_GetAccel(grappleDirUnit, o.vel, args.speed_towardAnchor, args.deadZone_speedDiff, grappleLen, args.deadzone_dist_towardAnchor, args.accel_towardAnchor)

    -- Apply velocity in look direction
    local look_x, look_y, look_z = Pull_GetAccel(o.lookdir_forward, o.vel, args.speed_lookDir, args.deadZone_speedDiff, grappleLen, args.deadzone_dist_lookDir, args.accel_lookDir)

    -- Apply the acceleration
    local accelX = (anchor_x + look_x) * deltaTime
    local accelY = (anchor_y + look_y) * deltaTime
    local accelZ = (anchor_z + look_z + antigrav_z) * deltaTime

     o.player:GrapplingHook_AddImpulse(accelX, accelY, accelZ)
end

function Pull_GetAntiGravity(percent)
    if percent <= 0 then
        return 0
    elseif percent >= 1 then
        return 16
    else
        return GetScaledValue(0, 16, 0, 1, percent)
    end
end