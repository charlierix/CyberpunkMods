function GetGrappleLine(o, state, const)
    local playerAnchor = Vector4.new(o.pos.x, o.pos.y, o.pos.z + const.grappleFrom_Z, 1)

    local grappleDir = SubtractVectors(state.rayHit, playerAnchor)
    local grappleLen = GetVectorLength(grappleDir)
    local grappleDirUnit = DivideVector(grappleDir, grappleLen)

    return playerAnchor, grappleDir, grappleLen, grappleDirUnit
end

-- This is called while in flight.  It looks for the user wanting to switch flight modes
function SwitchedFlightMode(o, state, const)
    -- If they initiate a new pull or rigid, go straight to that
    local shouldPull, shouldRigid = state.startStopTracker:ShouldGrapple()
    if shouldPull then
        Transition_ToAim(state, o, const.flightModes.aim_pull)
        return true

    elseif shouldRigid then
        Transition_ToAim(state, o, const.flightModes.aim_rigid)
        return true
    end

    if state.startStopTracker:ShouldStop() then     -- doing this after the pull/rigid check, because it likely uses fewer keys
        -- Told to stop swinging, back to standard
        Transition_ToStandard(state, const, debug, o)
        return true
    end

    return false
end

-- This will return true as long as there is some air below the player
function IsAirborne(o)
    return o:IsPointVisible(o.pos, Vector4.new(o.pos.x, o.pos.y, o.pos.z - 0.5, 1))
end

function IsWallCollisionImminent(o, deltaTime)
    return not o:IsPointVisible(o.pos, Vector4.new(o.pos.x + (o.vel.x * deltaTime * 4), o.pos.y + (o.vel.y * deltaTime * 4), o.pos.z + (o.vel.z * deltaTime * 4), 1))
end

function ShouldStopFlyingBecauseGrounded(o, state)
    local isAirborne = IsAirborne(o)

    if state.hasBeenAirborne then
        -- Has been continuously airborne in this flight mode for at least a small bit of time
        if not isAirborne then
            return true
        end
    else
        -- Hasn't had enough time continuously airborne yet
        if isAirborne then
            if state.initialAirborneTime then
                -- Is airborne and has been airborne before.  See if they have been continuously long enough to transition out of this break in period
                if o.timer - state.initialAirborneTime > 0.25 then
                    state.isSafetyFireCandidate = true
                    state.hasBeenAirborne = true
                end
            else
                state.initialAirborneTime = o.timer
            end
        else
            -- Not airborne during this warmin period, remove the timer (they are starting on the ground, or sliding along the ground at a shallow angle)
            state.initialAirborneTime = nil
        end
    end

    return false
end

function Pull_GetAccel(directionUnit, vel, desiredSpeed, deadZone_speedDiff, grappleLen, deadzone_dist, accel)
    -- Get the component of the velocity along the request line
    local vel_along = GetProjectedVector_AlongVector(vel, directionUnit, false)     -- returns zero if velocity is in the opposite direction

    -- Figure out the delta between actual and desired speed
    local speedSqr = GetVectorLengthSqr(vel_along)
    if speedSqr >= desiredSpeed * desiredSpeed then
        return 0, 0, 0, 0
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
        directionUnit.z * actualAccel,
        actualAccel / accel     -- percent
end
