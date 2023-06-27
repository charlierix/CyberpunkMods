local SettingsUtil = {}

local this = {}

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

function SettingsUtil.Obstacles()
    -- models\swarmbot_obstacles
    local retVal = DeserializeJSON("!configs/obstacles.json")

    -- Set some derived properties
    retVal.dot_hitradius_animcurve = this.BuildAnimCurve_AngleToDot(retVal.angle_hitradius)

    retVal.max_radiusmult = this.GetMaxOutput(retVal.angle_radiusmult)

    retVal.dot_radiusmult_animcurve = this.BuildAnimCurve_AngleToDot(retVal.angle_radiusmult)
    retVal.edge_percentradius_accelmult_animcurve = this.BuildAnimCurve(retVal.edge_percentradius_accelmult)
    retVal.depth_percentradius_accelmult_animcurve = this.BuildAnimCurve(retVal.depth_percentradius_accelmult)

    return retVal
end

----------------------------------- Private Methods -----------------------------------

function this.GetMaxOutput(gradientstops)
    local retVal = 0

    for _, in_out in ipairs(gradientstops) do
        if in_out.output > retVal then
            retVal = in_out.output
        end
    end

    return retVal
end

function this.BuildAnimCurve(gradientstops)
    local retVal = AnimationCurve:new()

    for _, in_out in ipairs(gradientstops) do
        retVal:AddKeyValue(in_out.input, in_out.output)
    end

    return retVal
end
function this.BuildAnimCurve_AngleToDot(gradientstops)
    local retVal = AnimationCurve:new()

    for _, in_out in ipairs(gradientstops) do
        retVal:AddKeyValue(Angle_to_Dot(in_out.input), in_out.output)
    end

    return retVal
end

return SettingsUtil