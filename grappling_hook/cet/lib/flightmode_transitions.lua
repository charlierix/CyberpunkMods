-- This can come from any state back to standard (the other mods called this ExitFlight)
function Transition_ToStandard(state, const, debug, o)
    state.flightMode = const.flightModes.standard
    o:Custom_CurrentlyFlying_Clear()

    state.startStopTracker:ResetKeyDowns()

    EnsureMapPinRemoved(state, o)
end

-- This can come from any state into aiming
function Transition_ToAim(state, o, flightMode)
    state.flightMode = flightMode
    o:Custom_CurrentlyFlying_StartFlight()

    -- Don't want this misreporting.  Force the user to let go of the keys before this sees any new
    -- action attempt
    state.startStopTracker:ResetKeyDowns()

    state.startTime = o.timer
end

-- This goes from aim into flight
function Transition_ToFlight(state, o, flightMode, rayFrom, rayHit)
    state.flightMode = flightMode
    o:Custom_CurrentlyFlying_StartFlight()

    state.startTime = o.timer

    state.rayFrom = rayFrom
    state.rayHit = rayHit
    state.distToHit = math.sqrt(GetVectorDiffLengthSqr(rayHit, rayFrom))

    state.hasBeenAirborne = false
end

-- This happens when they aimed too long without a hit, moving into airdash flight
function Transition_ToAirDash(state, o, const, rayFrom, lookDist)
    state.flightMode = const.flightModes.air_dash
    o:Custom_CurrentlyFlying_StartFlight()

    state.startTime = o.timer

    state.rayFrom = rayFrom
    state.rayDir = o.lookdir_forward
    state.rayLength = lookDist

    state.hasBeenAirborne = false
end