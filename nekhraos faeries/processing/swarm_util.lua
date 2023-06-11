local Swarm_Util = {}

local this = {}

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

-- Applies drag orthogonal to the orb's velocity (this function is needed in a couple places, so defining it here)
function Swarm_Util.Drag_Orth_Velocity(direction, orb_vel, distance, property_mult_speed, property_mult_distance, max_accel, max_speed)
    -- There's a chance that accel is zero when the orb is too far away, so check this first
    local percent_accel_dist = Swarm_Util.ApplyPropertyMult(property_mult_distance, distance)

    if IsNearZero(percent_accel_dist) then
        return 0, 0, 0
    end

    -- Find the part of the orb's velocity that is perpendicular to the desired direction
    local up = CrossProduct3D(direction, orb_vel)       -- not taking unit vector of vel to keep it cheap

    if IsNearZero(GetVectorLengthSqr(up)) then
        return 0, 0, 0      -- they are either parallel or one of the vectors is near zero
    end

    local orth_unit = ToUnit(CrossProduct3D(direction, up))

    local vel_orth = GetProjectedVector_AlongVector(orb_vel, orth_unit, true)
    local speed_orth = GetVectorLength(vel_orth)

    local speed_percent = speed_orth / max_speed

    local percent_accel_speed = Swarm_Util.ApplyPropertyMult(property_mult_speed, speed_percent)

    -- Multiply these with the unit of orth velocity (negated to be drag)
    return
        (vel_orth.x / -speed_orth) * percent_accel_speed * percent_accel_dist * max_accel,
        (vel_orth.y / -speed_orth) * percent_accel_speed * percent_accel_dist * max_accel,
        (vel_orth.z / -speed_orth) * percent_accel_speed * percent_accel_dist * max_accel
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