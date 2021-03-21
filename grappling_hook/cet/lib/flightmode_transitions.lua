-- This can come from any state back to standard (the other mods called this ExitFlight)
function Transition_ToStandard(state, const, debug, o)
    state.flightMode = const.flightModes.standard
    o:Set_Custom_IsFlying(false)

    state.startStopTracker:ResetKeyDowns()

    EnsureMapPinRemoved(state, o)
end

-- This goes from standard into aiming
function Transition_ToAim(state, o, flightMode)
    -- Don't want this misreporting.  Force the user to let go of the keys before this sees any new
    -- action attempt
    state.startStopTracker:ResetKeyDowns()

    state.startTime = o.timer


    --TODO: Set a global flag to tell that flight is being overidden


    state.flightMode = flightMode
end

-- This goes from aim into flight
function Transition_ToFlight(state, o, flightMode, rayFrom, rayHit)
    state.flightMode = flightMode

    state.startTime = o.timer

    state.rayFrom = rayFrom
    state.rayHit = rayHit
end

-- This happens when they aimed too long without a hit, moving into airdash flight
function Transition_ToAirDash(state, o, const, rayFrom, lookDist)
    state.flightMode = const.flightModes.air_dash

    state.startTime = o.timer

    state.rayFrom = rayFrom
    state.rayDir = o.lookdir_forward
    state.rayLength = lookDist
end