local SettingsUtil = {}

function SettingsUtil.Goals()
    -- models\swarmbot_goals
    return DeserializeJSON("!configs/goals.json")
end

function SettingsUtil.Limits()
    -- models\swarmbot_limits
    return DeserializeJSON("!configs/limits.json")
end

function SettingsUtil.Neighbors()
    -- models\swarmbot_neighbors
    return DeserializeJSON("!configs/neighbors.json")
end

return SettingsUtil