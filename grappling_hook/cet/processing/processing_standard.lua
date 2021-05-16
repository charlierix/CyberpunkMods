local this = {}

-- This gets call most of the time, it's them running around playing the game normally
-- This recovers energy and looks at key inputs to see if they activated a grapple
function Process_Standard(o, player, state, const, debug, deltaTime)
    state.energy = RecoverEnergy(state.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate, deltaTime)

    StartFlightIfRequested(o, player, state, const)        -- putting this in its own function so it can also be called from Process_Flight
end

-- Looks at buttons to see if they are requesting a grapple
function StartFlightIfRequested(o, player, state, const)
    local isDown1, isDown2 = state.startStopTracker:ShouldGrapple()

    if isDown1 then
        return this.TryStartFlight(o, state, const, player.grapple1)
    elseif isDown2 then
        return this.TryStartFlight(o, state, const, player.grapple2)
    else
        return false
    end
end

--------------------------------------- Private Methods ---------------------------------------

function this.TryStartFlight(o, state, const, grapple)
    if CheckOtherModsFor_FlightStart(o, const.modNames) then
        -- No other mod is standing in the way
        if Transition_ToAim(grapple, state, const, o, true) then
            return true
        else
            -- There wasn't enough energy
            state.startStopTracker:ResetKeyDowns()
            return false
        end
    else
        -- Another mod is flying, don't interfere.  Also eat the keys
        state.startStopTracker:ResetKeyDowns()
        return true
    end
end