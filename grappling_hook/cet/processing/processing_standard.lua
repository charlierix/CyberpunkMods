function Process_Standard(o, player, state, const, debug, deltaTime)
    state.energy = RecoverEnergy(state.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate, deltaTime)

    
end