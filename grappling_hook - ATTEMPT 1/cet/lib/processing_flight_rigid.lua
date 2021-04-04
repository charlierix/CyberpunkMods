--TODO: If the grapple point is fairly close to the player, hold the player in place.  If too much force is applied,
--break it (but after the force was applied, so it at least slows down the player)

function Process_Flight_Rigid(o, state, const, debug, deltaTime)
    if SwitchedFlightMode(o, state, const) then
        do return end
    end

    -- If they are on the ground after being airborne, then exit flight
    if ShouldStopFlyingBecauseGrounded(o, state) then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    -- Rigid shouldn't do a wall check.  There could be an advantage to hanging off the side of a building

    local args = const.rigid

    local _, _, grappleLen, grappleDirUnit = GetGrappleLine(o, state, const)

    o:GetCamera()

    if DotProduct3D(o.lookdir_forward, grappleDirUnit) < args.minDot then
        -- They looked too far away
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    -- Apply force to bring to desired distance from grapple point
    local diffDist = grappleLen - state.distToHit

    --debug.distToHit = state.distToHit
    debug.diffDist = Round(diffDist, 2)

    local stand_x, stand_y, stand_z = Rigid_GetAccel_Standard(grappleDirUnit, diffDist, args.accelToRadius, args.radiusDeadSpot)

    -- Get the component of the velocity that's along the grapple line
    local velAlong = GetProjectedVector_AlongVector(o.vel, grappleDirUnit, true)

    -- Add extra acceleration if flying away (extra drag)
    local drag_x, drag_y, drag_z = Rigid_GetAccel_VelocityDrag(debug, grappleDirUnit, diffDist, velAlong, args.velAway_accel_tension, args.velAway_accel_compress, args.velAway_deadSpot)

    -- Apply the acceleration
    local accelX = (stand_x + drag_x) * deltaTime
    local accelY = (stand_y + drag_y) * deltaTime
    local accelZ = (stand_z + drag_z) * deltaTime

    o.player:GrapplingHook_AddImpulse(accelX, accelY, accelZ)
end

function Rigid_GetAccel_Standard(directionUnit, diffDist, maxAccel, deadSpot)
    local accel = GetAccel_Deadspot(diffDist, maxAccel, deadSpot)

    if diffDist < 0 then
        accel = -accel
    end

    return
        directionUnit.x * accel,
        directionUnit.y * accel,
        directionUnit.z * accel
end

function Rigid_GetAccel_VelocityDrag(debug, grappleDirUnit, diffDist, velAlong, maxAccel_tension, maxAccel_compress, deadSpot)
    -- Positive: moving toward.  Negative: moving away
    local dot = DotProduct3D(grappleDirUnit, velAlong)

    -- diff = actual - desired
    if (diffDist < 0 and dot < 0) or    -- Compressed and moving away from point
       (diffDist > 0 and dot > 0) then     -- Stretched and moving toward the point
        return 0, 0, 0
    end

    local accel
    if diffDist < 0 then
        -- It's being compressed
        accel = GetAccel_Deadspot(diffDist, maxAccel_compress, deadSpot)
        accel = -accel
    else
        -- It's being stretched
        accel = GetAccel_Deadspot(diffDist, maxAccel_tension, deadSpot)
    end

    return
        grappleDirUnit.x * accel,
        grappleDirUnit.y * accel,
        grappleDirUnit.z * accel
end

function GetAccel_Deadspot(diffDist, maxAccel, deadSpot)
    local accel = maxAccel

    local absDiff = math.abs(diffDist)

    if absDiff < deadSpot then
        accel = GetScaledValue(0, maxAccel, 0, deadSpot, absDiff)
    end

    return accel
end
