function TransitionWindows_Main(vars_ui, const)
    vars_ui.currentWindow = const.windows.main

    ActivateWindow_Main(vars_ui, const)
end

function TransitionWindows_InputBindings(vars_ui, const)
    vars_ui.currentWindow = const.windows.input_bindings

    ActivateWindow_InputBindings(vars_ui, const)
end

function TransitionWindows_Jumping(vars_ui, const)
    vars_ui.currentWindow = const.windows.jumping

    ActivateWindow_Jumping(vars_ui, const)
end

function TransitionWindows_Jumping2(vars_ui, const)
    vars_ui.currentWindow = const.windows.jumping2

    ActivateWindow_Jumping2(vars_ui, const)
end

function TransitionWindows_WallAttraction(vars_ui, const)
    vars_ui.currentWindow = const.windows.wall_attraction

    ActivateWindow_WallAttraction(vars_ui, const)
end

function TransitionWindows_CrawlSlide(vars_ui, const)
    vars_ui.currentWindow = const.windows.crawl_slide

    ActivateWindow_CrawlSlide(vars_ui, const)
end