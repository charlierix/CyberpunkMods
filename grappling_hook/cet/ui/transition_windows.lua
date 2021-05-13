function TransitionWindows_Main(vars_ui, const)
    vars_ui.currentWindow = const.windows.main
end

function TransitionWindows_Energy_Tank(vars_ui, const)
    vars_ui.currentWindow = const.windows.energy_tank

    local changes = vars_ui.energy_tank.changes

    changes.max_energy = 0
    changes.recovery_rate = 0
    changes.flying_percent = 0
    changes.experience = 0
end

function TransitionWindows_Grapple(vars_ui, const, player, grappleIndex)
    local grapple = player:GetGrappleByIndex(grappleIndex)

    if grapple then
        if grapple.aim_straight then
            vars_ui.currentWindow = const.windows.grapple_straight
            vars_ui.transition_info.grappleIndex = grappleIndex
            vars_ui.grapple_straight.name.text = nil
            vars_ui.grapple_straight.description.text = nil

        elseif grapple.aim_swing then
            print("TransitionWindows_Grapple: TODO: Implement web swing")
            TransitionWindows_Main(vars_ui, const)

        else
            print("TransitionWindows_Grapple: Unknown type of grapple")
            TransitionWindows_Main(vars_ui, const)
        end

    else
        vars_ui.currentWindow = const.windows.grapple_choose
    end
end