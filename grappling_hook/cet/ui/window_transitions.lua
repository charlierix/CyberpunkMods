function WindowTransition_Main(vars_ui, const)
    vars_ui.currentWindow = const.windows.main
end

function WindowTransition_Energy_Tank(vars_ui, const)
    vars_ui.currentWindow = const.windows.energy_tank

    local changes = vars_ui.energy_tank.changes

    changes.max_energy = 0
    changes.recovery_rate = 0
    changes.flying_percent = 0
    changes.experience = 0
end

function WindowTransition_Grapple_Straight(vars_ui, const, grappleIndex)
    vars_ui.currentWindow = const.windows.grapple_straight

    vars_ui.transition_info.grappleIndex = grappleIndex
end