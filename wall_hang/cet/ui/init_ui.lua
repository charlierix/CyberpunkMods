local this = {}

function InitializeUI(vars_ui, const)
    vars_ui.autoshow_withconsole = dal.GetSetting_Bool(const.settings.AutoShowConfig_WithConsole)
    if vars_ui.autoshow_withconsole == nil then     -- this will only happen if there's a db error
        vars_ui.autoshow_withconsole = true
    end

    vars_ui.screen = GetScreenInfo()    --NOTE: This won't see changes if they mess with their video settings, but that should be super rare.  They just need to reload mods

    vars_ui.style = LoadStylesheet()

    Refresh_LineHeights(vars_ui, const, true)

    vars_ui.configWindow = this.Define_ConfigWindow(vars_ui.screen)      -- going with a SPA, so it's probably going to be the only window

    -- This can't be called yet.  It has to be done by the caller
    --TransitionWindows_Main(vars_ui, const)
end

----------------------------------- Private Methods -----------------------------------

--NOTE: this sets values in hardcoded pixels.  Every frame, width and height are updated based on scale
function this.Define_ConfigWindow(screen)
    local width = 700       -- this is also hardcoded in util_misc.Refresh_WindowPos()
    local height = 525

    return
    {
        width = width,
        height = height,
        left = screen.center_x - width / 2,
        top = screen.center_y - height / 2,
    }
end