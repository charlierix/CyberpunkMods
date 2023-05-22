local Swarm_Util = {}

function Swarm_Util.ApplyPropertyMult(property_mult, percent)
    local retVal = percent * property_mult.rate
    retVal = Clamp(property_mult.cap_min, property_mult.cap_max, retVal)

    return retVal
end

return Swarm_Util