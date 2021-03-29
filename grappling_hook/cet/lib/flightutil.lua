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