function Process_Standard(o, player, state, const, debug, deltaTime)
    state.energy = RecoverEnergy(state.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate, deltaTime)

    local isDown1, isDown2 = state.startStopTracker:ShouldGrapple()

    if isDown1 then
        TryStartFlight(o, state, const, player.grapple1)
    elseif isDown2 then
        TryStartFlight(o, state, const, player.grapple2)
    end
end

function TryStartFlight(o, state, const, grapple)
    if CheckOtherModsFor_FlightStart(o, const.modNames) then
        -- No other mod is standing in the way
        if not Transition_ToAim(grapple, state, const, o, true) then
            -- There wasn't enough energy
            state.startStopTracker:ResetKeyDowns()
        end
    else
        -- Another mod is flying, don't interfere.  Also eat the keys
        state.startStopTracker:ResetKeyDowns()
    end
end