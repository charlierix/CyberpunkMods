function InitializeUI(vars_ui, const)
    vars_ui.screen = GetScreenInfo()    --NOTE: This won't see changes if they mess with their video settings, but that should be super rare.  They just need to reload mods

    Refresh_LineHeights(vars_ui, const, true)
end