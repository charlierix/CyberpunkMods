function IsNearValue(value, test)
    return math.abs(value - test) < 0.001
end

function IsNearValue_custom(value, test, epsilon)
    return math.abs(value - test) < epsilon
end

function IsNearZero(value)
    return IsNearValue(value, 0)
end

function IsNearZero_vec4(value)
    if not value then
        return true
    end

    -- Ignore w, it's always 1
    return IsNearValue(value.x, 0) and IsNearValue(value.y, 0) and IsNearValue(value.z, 0)
end

--http://lua-users.org/wiki/SimpleRound
function Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)     -- why OR zero? (I'm guessing if they pass in nil?)
    return math.floor(num * mult + 0.5) / mult
end

-- This is good for converting one number into another
--
-- minReturn    This is the value that will be returned when valueRange == minRange
-- maxReturn    This is the value that will be returned with valueRange == maxRange
-- minRange     The lowest value that valueRange can be
-- maxRange     The highest value that valueRange can be
-- valueRange   Somewhere between minRange and maxRange
--
-- returns      Somewhere between minReturn and maxReturn
function GetScaledValue(minReturn, maxReturn, minRange, maxRange, valueRange)
    if IsNearValue(minRange, maxRange) then
        return minReturn
    end

    -- Get the percent of value within the range
    local percent = (valueRange - minRange) / (maxRange - minRange)

    -- Get the lerp between the return range
    return minReturn + (percent * (maxReturn - minReturn))
end