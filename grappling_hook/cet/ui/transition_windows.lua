function TransitionWindows_Main(vars_ui, const)
    vars_ui.currentWindow = const.windows.main

    ActivateWindow_Main(vars_ui, const)
end

function TransitionWindows_InputBindings(vars_ui, const)
    vars_ui.currentWindow = const.windows.input_bindings

    ActivateWindow_InputBindings(vars_ui, const)
end

function TransitionWindows_Energy_Tank(vars_ui, const)
    vars_ui.currentWindow = const.windows.energy_tank

    ActivateWindow_EnergyTank(vars_ui, const)
end

function TransitionWindows_Grapple(vars_ui, const, player, grappleIndex)
    vars_ui.transition_info.grappleIndex = grappleIndex

    local grapple = player:GetGrappleByIndex(grappleIndex)

    if grapple then
        if grapple.aim_straight then
            vars_ui.currentWindow = const.windows.grapple_straight
            ActivateWindow_Grapple_Straight(vars_ui, const)

        elseif grapple.aim_swing then
            print("TransitionWindows_Grapple: TODO: Implement web swing")
            TransitionWindows_Main(vars_ui, const)

        else
            print("TransitionWindows_Grapple: Unknown type of grapple")
            TransitionWindows_Main(vars_ui, const)
        end

    else
        vars_ui.currentWindow = const.windows.grapple_choose
        ActivateWindow_Grapple_Choose(vars_ui, const, player)
    end
end

function TransitionWindows_Straight_AccelAlong(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_accelalong

    ActivateWindow_GrappleStraight_AccelAlong(vars_ui, const)
end

function TransitionWindows_Straight_AccelLook(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_accellook

    ActivateWindow_GrappleStraight_AccelLook(vars_ui, const)
end

function TransitionWindows_Straight_AimDuration(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_aimduration

    ActivateWindow_GrappleStraight_AimDuration(vars_ui, const)
end

function TransitionWindows_Straight_AirDash(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_airdash

    ActivateWindow_GrappleStraight_AirDash(vars_ui, const)
end

function TransitionWindows_Straight_AntiGrav(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_antigrav

    ActivateWindow_GrappleStraight_AntiGrav(vars_ui, const)
end

function TransitionWindows_Straight_Description(vars_ui, const)
    vars_ui.currentWindow = const.windows.grapple_straight_description

    ActivateWindow_GrappleStraight_Description(vars_ui, const)
end

function TransitionWindows_Straight_Distances(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_distances

    ActivateWindow_GrappleStraight_Distances(vars_ui, const)
end

function TransitionWindows_Straight_StopEarly(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_stopearly

    ActivateWindow_GrappleStraight_StopEarly(vars_ui, const)
end

function TransitionWindows_Straight_VelocityAway(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_velaway

    ActivateWindow_GrappleStraight_VelocityAway(vars_ui, const)
end