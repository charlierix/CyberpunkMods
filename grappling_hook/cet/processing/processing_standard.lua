-- This gets call most of the time, it's them running around playing the game normally
-- This recovers energy and looks at key inputs to see if they activated a grapple
function Process_Standard(o, player, vars, const, debug, deltaTime)
    if not player.isUnlocked then
        do return end
    end

    vars.energy = RecoverEnergy(vars.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate, deltaTime)

    HasSwitchedFlightMode(o, player, vars, const, false)       -- this is normally part of an if statement, but Process_Standard doesn't care if it returns true or false (the state will be changed, and next tick will route accordingly)
end