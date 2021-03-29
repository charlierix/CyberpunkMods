function Process_Flight_Pull(o, state, const, debug, deltaTime)
    if SwitchedFlightMode(o, state, const) then
        do return end
    end



    --TODO: These are far too sensitive.  Be airborne for a little bit first


    -- hasBeenAirborne
    -- time of first airborne
    -- reset if not airborne in that initial phase (sliding along the ground)

    -- also don't do wall checks, because the tiniest obstacle can sometimes register as a wall (from is at height zero)




    -- -- If standing on the ground after being airborne, then cancel
    if IsAirborne(o) then
    --     state.hasBeenAirborne = true
         state.isSafetyFireCandidate = true
    -- elseif state.hasBeenAirborne then
    --     print("pull: stopping on ground")

    --     Transition_ToStandard(state, const, debug, o)
    --     do return end
    -- end

    -- -- If about to hit a wall, then cancel
    -- if IsWallCollisionImminent(o, deltaTime) then
    --     print("pull: stopping on wall")

    --     Transition_ToStandard(state, const, debug, o)
    --     do return end
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
    local antigrav_z = 16

    -- Apply velocity toward anchor
    local anchor_x, anchor_y, anchor_z = Pull_GetAccel(grappleDirUnit, o.vel, args.speed_towardAnchor, args.deadZone_speedDiff, grappleLen, args.deadzone_dist_towardAnchor, args.accel_towardAnchor)

    -- Apply velocity in look direction
    local look_x, look_y, look_z = Pull_GetAccel(o.lookdir_forward, o.vel, args.speed_lookDir, args.deadZone_speedDiff, grappleLen, args.deadzone_dist_lookDir, args.accel_lookDir)

    -- Apply the acceleration
    local accelX = (anchor_x + look_x) * deltaTime
    local accelY = (anchor_y + look_y) * deltaTime
    local accelZ = (anchor_z + look_z + antigrav_z) * deltaTime

     o.player:Jetpack_AddImpulse(accelX, accelY, accelZ)
end

function Pull_GetAccel(directionUnit, vel, desiredSpeed, deadZone_speedDiff, grappleLen, deadzone_dist, accel)
    -- Get the component of the velocity along the request line
    local vel_along = GetProjectedVector_AlongVector(vel, directionUnit, false)     -- returns zero if velocity is in the opposite direction

    -- Figure out the delta between actual and desired speed
    local speedSqr = GetVectorLengthSqr(vel_along)
    if speedSqr >= desiredSpeed * desiredSpeed then
        return 0, 0, 0
    end

    local speed = math.sqrt(speedSqr)

    local speedDiff = math.abs(speed - desiredSpeed)

    local actualAccel = accel
    if speedDiff < deadZone_speedDiff then
        -- Close to desired speed.  Reduce the acceleration
        actualAccel = GetScaledValue(0, accel, 0, deadZone_speedDiff, speedDiff)
    end

    if grappleLen < deadzone_dist then
        -- Close to the target.  Reduce the acceleration
        local closeAccel = GetScaledValue(0, accel, 0, deadzone_dist, grappleLen)

        if closeAccel < actualAccel then        -- it may already be reduced, so keep the weaker accel
            actualAccel = closeAccel
        end
    end

    return
        directionUnit.x * actualAccel,
        directionUnit.y * actualAccel,
        directionUnit.z * actualAccel
end
