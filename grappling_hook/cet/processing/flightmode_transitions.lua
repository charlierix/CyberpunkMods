-- This can come from any state back to standard (the other mods called this ExitFlight)
function Transition_ToStandard(state, const, debug, o)
    state.flightMode = const.flightModes.standard
    o:Custom_CurrentlyFlying_Clear()

    state.grapple = nil
    state.airdash = nil

    state.startStopTracker:ResetKeyDowns()

    EnsureMapPinRemoved(state, o)
end

-- This can come from any state into aiming
-- Returns false if there's not enough energy
function Transition_ToAim(grapple, state, const, o, shouldConsumeEnergy)
    if shouldConsumeEnergy then
        if state.energy < grapple.energy_cost then
            --TODO: Play a fail sound
            return false
        else
            state.energy = state.energy - grapple.energy_cost
        end
    end

    state.flightMode = const.flightModes.aim
    o:Custom_CurrentlyFlying_StartFlight()

    state.grapple = grapple

    -- Don't want this misreporting.  Force the user to let go of the keys before this sees any new
    -- action attempt
    state.startStopTracker:ResetKeyDowns()

    state.startTime = o.timer

    return true
end

-- This goes from aim into flight
-- There's no need to check for energy, that was done when trying to aim
function Transition_ToFlight(state, const, o, rayFrom, rayHit)
    state.flightMode = const.flightModes.flight
    o:Custom_CurrentlyFlying_StartFlight()

    -- state.grapple is already populated by aim

    state.startTime = o.timer

    state.rayFrom = rayFrom
    state.rayHit = rayHit
    state.distToHit = math.sqrt(GetVectorDiffLengthSqr(rayHit, rayFrom))

    state.hasBeenAirborne = false
    state.initialAirborneTime = nil
end

-- This happens when they aimed too long without a hit, moving into airdash flight
function Transition_ToAirDash(airdash, state, const, o, rayFrom, lookDist)
    state.flightMode = const.flightModes.airdash
    o:Custom_CurrentlyFlying_StartFlight()

    state.airdash = airdash

    state.startTime = o.timer

    state.rayFrom = rayFrom
    state.rayDir = o.lookdir_forward
    state.rayLength = lookDist

    state.hasBeenAirborne = false
    state.initialAirborneTime = nil
end