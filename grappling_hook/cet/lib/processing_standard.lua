function Process_Standard(o, state, const, deltaTime)

    --TODO: Recover energy

    local pull, rigid = state.startStopTracker:ShouldGrapple()

    if pull then
        TryStartFlight(o, state, const, const.flightModes.aim_pull)

    elseif rigid then
        TryStartFlight(o, state, const, const.flightModes.aim_rigid)
    end
end

function TryStartFlight(o, state, const, flightMode)
    if CheckOtherModsFor_FlightStart(o, const.modNames) then
        -- No other mod is standing in the way
        Transition_ToAim(state, o, flightMode)
    else
        -- Another mod is flying, don't interfere.  Also eat the keys
        state.startStopTracker:ResetKeyDowns()
    end
end