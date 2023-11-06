function TransitionWindows_Main(vars_ui, const)
    vars_ui.currentWindow = const.windows.main

    ActivateWindow_Main(vars_ui, const)
end

function TransitionWindows_Mode(vars_ui, const, mode, mode_index)
    vars_ui.currentWindow = const.windows.mode

    vars_ui.transition_info.mode = mode
    vars_ui.transition_info.mode_index = mode_index

    ActivateWindow_Mode(vars_ui, const)
end

function TransitionWindows_Mode_Energy(vars_ui, const)
    -- NOTE: This should only be called from Mode window, so everything is already stored
    -- in vars_ui.transition_info

    vars_ui.currentWindow = const.windows.mode_energy

    ActivateWindow_Mode_Energy(vars_ui, const)
end
