local this = {}
local PopupsUtil = {}

-- See models\PopupStyle

-- Tries to pull from database, else returns default
function PopupsUtil.Load()
    local popups_json = dal.GetLatestPopups()

    if popups_json then
        local popups = extern_json.decode(popups_json)
        PopupsUtil.ParseColors(popups)

        return popups
    else
        return PopupsUtil.GetDefault()
    end
end

-- Returns an instance with default values
function PopupsUtil.GetDefault()
    local retVal =
    {
        energy_visible = true,
        energy_visible_under_percent = 1,

        switch_scale = 1.2,

        energy_background = "995EADAD",
        energy_border = "E673D4D4",
        switch_background = "A02E5454",
        switch_border = "803D6E6E",
        text_primary = "FFFFFF4C",
        text_secondary = "FF75FFFF",
    }

    PopupsUtil.ParseColors(retVal)

    return retVal
end

-- Populates the _abgr properties based on the corresponding string properties
function PopupsUtil.ParseColors(popups)
    _, popups.energy_background_abgr = ConvertHexStringToNumbers(popups.energy_background)
    _, popups.energy_border_abgr = ConvertHexStringToNumbers(popups.energy_border)
    _, popups.switch_background_abgr = ConvertHexStringToNumbers(popups.switch_background)
    _, popups.switch_border_abgr = ConvertHexStringToNumbers(popups.switch_border)
    _, popups.text_primary_abgr = ConvertHexStringToNumbers(popups.text_primary)
    _, popups.text_secondary_abgr = ConvertHexStringToNumbers(popups.text_secondary)
end

----------------------------------- Private Methods -----------------------------------

return PopupsUtil