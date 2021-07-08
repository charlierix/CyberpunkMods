function TransitionWindows_Main(vars_ui, const)
    vars_ui.currentWindow = const.windows.main

    vars_ui.main.changes:Clear()
    vars_ui.main.should_autoshow.isChecked = nil

    vars_ui.keys:StopWatching()
end

function TransitionWindows_InputBindings(vars_ui, const)
    vars_ui.currentWindow = const.windows.input_bindings

    local bind_buttons = vars_ui.input_bindings.bind_buttons

    for i = 1, #bind_buttons do
        bind_buttons[i].isDeleteChange = false
        bind_buttons[i].newActions = nil
    end

    vars_ui.keys:StartWatching()
end

function TransitionWindows_Energy_Tank(vars_ui, const)
    vars_ui.currentWindow = const.windows.energy_tank

    vars_ui.energy_tank.changes:Clear()
end

function TransitionWindows_Grapple(vars_ui, const, player, grappleIndex)
    local grapple = player:GetGrappleByIndex(grappleIndex)

    if grapple then
        if grapple.aim_straight then
            vars_ui.currentWindow = const.windows.grapple_straight

            vars_ui.transition_info.grappleIndex = grappleIndex

            vars_ui.grapple_straight.changes:Clear()
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

        ActivateWindow_Grapple_Choose(vars_ui)
    end
end

function TransitionWindows_Straight_AccelAlong(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_accelalong

    vars_ui.gst8_accalong.changes:Clear()
    vars_ui.gst8_accalong.has_accelalong.isChecked = nil
    vars_ui.gst8_accalong.deadspot_dist.value = nil
end

function TransitionWindows_Straight_AccelLook(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_accellook

    vars_ui.gst8_acclook.changes:Clear()
    vars_ui.gst8_acclook.has_accellook.isChecked = nil
end

function TransitionWindows_Straight_AimDuration(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_aimduration

    vars_ui.gst8_aimdur.changes:Clear()
end

function TransitionWindows_Straight_AirDash(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_airdash

    vars_ui.gst8_airdash.changes:Clear()
    vars_ui.gst8_airdash.has_airdash.isChecked = nil
end

function TransitionWindows_Straight_AntiGrav(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_antigrav

    vars_ui.gst8_antgrav.changes:Clear()
    vars_ui.gst8_antgrav.has_antigrav.isChecked = nil
end

function TransitionWindows_Straight_Description(vars_ui, const)
    vars_ui.currentWindow = const.windows.grapple_straight_description

    vars_ui.gst8_descr.changes:Clear()
    vars_ui.gst8_descr.description.text = nil
end

function TransitionWindows_Straight_Distances(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_distances

    vars_ui.gst8_dist.changes:Clear()
    vars_ui.gst8_dist.desired_checkbox.isChecked = nil
    vars_ui.gst8_dist.desired_slider.value = nil
end

function TransitionWindows_Straight_StopEarly(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_stopearly

    vars_ui.gst8_stop.changes:Clear()

    vars_ui.gst8_stop.has_stopDistance.isChecked = nil
    vars_ui.gst8_stop.stopDistance_value.value = nil

    vars_ui.gst8_stop.should_stopOnWallHit.isChecked = nil

    vars_ui.gst8_stop.has_stopAngle.isChecked = nil
    vars_ui.gst8_stop.stopAngle_value.value = nil
end

function TransitionWindows_Straight_VelocityAway(vars_ui, const)
    -- NOTE: This should only be called from Grapple_Straight, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.grapple_straight_velaway

    vars_ui.gst8_velaway.changes:Clear()

    vars_ui.gst8_velaway.has_velaway.isChecked = nil
    vars_ui.gst8_velaway.has_compress.isChecked = nil
    vars_ui.gst8_velaway.has_tension.isChecked = nil
    vars_ui.gst8_velaway.deadspot_dist.value = nil
end