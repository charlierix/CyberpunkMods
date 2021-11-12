-- This pulls other settings out of the database
function InitializeSavedFields(const)
    const.mouse_sensitivity = GetSetting_Float(const.settings.MouseSensitivity, -0.06)
    const.rightstick_sensitivity = GetSetting_Float(const.settings.RightStickSensitivity, 50)
end