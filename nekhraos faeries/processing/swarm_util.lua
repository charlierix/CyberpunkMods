local Swarm_Util = {}

local this = {}

function Swarm_Util.ApplyPropertyMult_ORIG(property_mult_ORIG, percent)
    local retVal = percent * property_mult_ORIG.rate
    retVal = Clamp(property_mult_ORIG.cap_min, property_mult_ORIG.cap_max, retVal)

    return retVal
end

--Takes in a property_mult class and either returns the constant value, or gets the input and runs it through the animation curve
--NOTE: This will create an animation curve instance the first time it's needed.  It's expected that the gradient values never change
--  property_mult: (defined in models)
--  input: the floating point to be used as input to animation curve
--  returns: The constant value or the result of animation curve
function Swarm_Util.ApplyPropertyMult(property_mult, input)
    if property_mult.constant_value then
        return property_mult.constant_value

    elseif not property_mult.animcurve_values or not input then
        return 0
    end

    if not property_mult.animcurve then
        property_mult.animcurve = this.BuildAnimationCurve(property_mult.animcurve_values)
    end

    return property_mult.animcurve:Evaluate(input)
end

----------------------------------- Private Methods -----------------------------------

-- Takes an array of models\property_mult_gradientstop
-- Returns an instance of AnimationCurve
function this.BuildAnimationCurve(values)
    local retVal = AnimationCurve:new()

    for _, entry in ipairs(values) do
        retVal:AddKeyValue(entry.input, entry.output)
    end

    return retVal
end

return Swarm_Util