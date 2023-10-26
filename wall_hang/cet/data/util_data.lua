function InitializeKeyBindings(keys, vars, const)
    vars.wallhangkey_usecustom = dal.GetSetting_Bool(const.settings.WallHangKey_UseCustom, false)

    -- Pull bindings from the DB
    local bindings = dal.GetAllInputBindings()

    if not bindings then
        -- No rows, use defaults
        bindings = GetDefaultInputBindings(const)

        -- No need to store something that is hardcoded
        -- for key, value in pairs(bindings) do
        --     dal.SetInputBinding(key, value)
        -- end
    end

    keys:SetHangActions(bindings[const.bindings.hang])      -- could be nil (which means they map to custom)
end

function GetDefaultInputBindings(const)
    local bindings = {}

    -- These strings have to exactly match what comes from Observe('PlayerPuppet', 'OnAction'

    bindings[const.bindings.hang] = { "QuickMelee" }          -- Q key (or equivalent button on a controller)
    --bindings[const.bindings.wall_run] = { "-- whatever shift key is --" }

    return bindings
end

-- This pulls other settings out of the database
function InitializeSavedFields(const)
    const.mouse_sensitivity = dal.GetSetting_Float(const.settings.MouseSensitivity, -0.06)
    const.rightstick_sensitivity = dal.GetSetting_Float(const.settings.RightStickSensitivity, 50)

    const.latch_wallhang = dal.GetSetting_Bool(const.settings.Latch_WallHang, true)
    const.jump_sound_standard = dal.GetSetting_Bool(const.settings.JumpSoundStandard, false)
end