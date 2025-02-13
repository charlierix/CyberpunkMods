local this = {}

function InitializeUI(vars_ui, vars_ui_progressbar, const)
    vars_ui.autoshow_withconsole = dal.GetSetting_Bool(const.settings.AutoShowConfig_WithConsole, true)
    if vars_ui.autoshow_withconsole == nil then     -- this will only happen if there's a db error
        vars_ui.autoshow_withconsole = true
    end

    vars_ui.screen = GetScreenInfo()    --NOTE: This won't see changes if they mess with their video settings, but that should be super rare.  They just need to reload mods

    vars_ui.style = LoadStylesheet()

    Refresh_LineHeights(vars_ui, const, true)
    Refresh_LineHeights(vars_ui_progressbar, const, true)

    vars_ui.configWindow = this.Define_ConfigWindow(vars_ui.screen)      -- going with a SPA, so it's probably going to be the only window

    -- This can't be called yet.  It has to be done by the caller
    --TransitionWindows_Main(vars_ui, const)
end

----------------------------------- Private Methods -----------------------------------

function this.Define_ConfigWindow(screen)
    local width = 775       --NOTE: this is essentially ignored.  See util_misc.lua Refresh_WindowPos()
    local height = 620

    return
    {
        width = width,
        height = height,
        left = screen.center_x - width / 2,
        top = screen.center_y - height / 2,
    }
end