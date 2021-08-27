function TransitionWindows_Main(vars_ui, const)
    vars_ui.currentWindow = const.windows.main

    ActivateWindow_Main(vars_ui, const)
end

function TransitionWindows_InputBindings(vars_ui, const)
    vars_ui.currentWindow = const.windows.input_bindings

    ActivateWindow_InputBindings(vars_ui, const)
end