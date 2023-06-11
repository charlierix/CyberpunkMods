local SettingsUtil = {}

local this = {}

function SettingsUtil.Goals()
    -- models\swarmbot_goals
    return this.DeserializeJSON("!configs/goals.json")
end

function SettingsUtil.Limits()
    -- models\swarmbot_limits
    return this.DeserializeJSON("!configs/limits.json")
end

function SettingsUtil.Neighbors()
    -- models\swarmbot_neighbors
    return this.DeserializeJSON("!configs/neighbors.json")
end

----------------------------------- Private Methods -----------------------------------

-- Small wrapper to file.open and json.decode
-- Returns
--  object, nil
--  nil, errMsg
function this.DeserializeJSON(filename)
    local handle = io.open(filename, "r")
    local json = handle:read("*all")

    local sucess, retVal = pcall(
        function(j) return extern_json.decode(j) end,
        json)

    if sucess then
        return retVal, nil
    else
        return nil, tostring(retVal)      -- when pcall has an error, the second value returned is the error message, otherwise it't the successful return value.  It should already be a sting, but doing a tostring just to be safe
    end
end

return SettingsUtil