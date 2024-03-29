function TransitionWindows_Main(vars_ui, const)
    vars_ui.currentWindow = const.windows.main

    ActivateWindow_Main(vars_ui, const)
end

function TransitionWindows_ChooseMode(vars_ui, const, mode_index)
    vars_ui.currentWindow = const.windows.choose_mode

    vars_ui.transition_info.mode_index = mode_index

    ActivateWindow_ChooseMode(vars_ui, const)
end

function TransitionWindows_Mode(vars_ui, const, mode, mode_index)
    vars_ui.currentWindow = const.windows.mode

    vars_ui.transition_info.mode = mode
    vars_ui.transition_info.mode_index = mode_index

    ActivateWindow_Mode(vars_ui, const)
end

function TransitionWindows_Mode_Accel(vars_ui, const)
    -- NOTE: This should only be called from Mode window, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.mode_accel

    ActivateWindow_Mode_Accel(vars_ui, const)
end

function TransitionWindows_Mode_Energy(vars_ui, const)
    -- NOTE: This should only be called from Mode window, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.mode_energy

    ActivateWindow_Mode_Energy(vars_ui, const)
end

function TransitionWindows_Mode_Extra(vars_ui, const, extra, set_extra)
    -- NOTE: This should only be called from Mode window, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.mode_extra

    vars_ui.transition_info.extra = extra
    vars_ui.transition_info.set_extra = set_extra

    ActivateWindow_Mode_Extra(vars_ui, const)
end

function TransitionWindows_Mode_JumpLand(vars_ui, const)
    -- NOTE: This should only be called from Mode window, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.mode_jumpland

    ActivateWindow_Mode_JumpLand(vars_ui, const)
end

function TransitionWindows_Mode_MouseSteer(vars_ui, const)
    -- NOTE: This should only be called from Mode window, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.mode_mousesteer

    ActivateWindow_Mode_MouseSteer(vars_ui, const)
end

function TransitionWindows_Mode_Rebound(vars_ui, const)
    -- NOTE: This should only be called from Mode window, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.mode_rebound

    ActivateWindow_Mode_Rebound(vars_ui, const)
end

function TransitionWindows_Mode_TimeDilation(vars_ui, const)
    -- NOTE: This should only be called from Mode window, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.mode_timedilation

    ActivateWindow_Mode_TimeDilation(vars_ui, const)
end

function TransitionWindows_Popups(vars_ui, const)
    vars_ui.currentWindow = const.windows.popups

    ActivateWindow_Popups(vars_ui, const)
end