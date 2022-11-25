local this = {}

function IsNearValue(value, test)
    return math.abs(value - test) < 0.001
end
-- This also considers nil
function IsNearValue_nillable(value, test)
    if value and test then
        return IsNearValue(value, test)
    elseif not value and not test then
        return true     -- both nil
    else
        return false        -- one is nil, the other isn't
    end
end

function IsNearValue_custom(value, test, epsilon)
    return math.abs(value - test) < epsilon
end

function IsNearValue_vec4(value, test)
    if not value and not test then
        -- Both nil
        return true
    end

    -- Ignoring w
    return
        IsNearValue_nillable(value.x, test.x) and
        IsNearValue_nillable(value.y, test.y) and
        IsNearValue_nillable(value.z, test.z)
end

function IsNearZero(value)
    return IsNearValue(value, 0)
end

function IsNearZero_vec4(value)
    if not value then
        return true
    end

    -- Ignore w, it's always 1
    return
        IsNearValue(value.x, 0) and
        IsNearValue(value.y, 0) and
        IsNearValue(value.z, 0)
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

function LERP(min, max, percent)
    return min + ((max - min) * percent)
end
function LERP_vec4(min, max, percent)
    return Vector4.new(
        LERP(min.x, max.x, percent),
        LERP(min.y, max.y, percent),
        LERP(min.z, max.z, percent),
        1)
end

function Clamp(min, max, value)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

-- Returns
--  val_min: the lesser of value1 and value2
--  val_max: the greater of value1 and value2
function MinMax(value1, value2)
    if value1 < value2 then
        return value1, value2
    else
        return value2, value1
    end
end

-- CET uses lua 5.1, bit shifting doesn't get handled natively until 5.2
function Bit_LShift(x, n)
    return x * (2^n)
end

function Random_Float(min, max)
    return min + (math.random() * (max - min));
end

-- This takes in a numeric value, returns a string in dozenal
function Format_DecimalToDozenal(decimal_value, fractional_places)
    --https://www.reddit.com/r/dozenal/comments/4is9zm/dozenal_conversion/
    --http://www.dozenal.org/articles/DSA-ConversionRules.pdf

    -- Divide the number by 12, rounding the quotient down to the nearest whole number and noting the remainder at each iteration
    --
    -- Stop when the quotient is 0
    --
    -- Then concatenate the remainders in reverse order, starting from last to first, to create the base-12 representation of the number

    -- Let's work out an example using the decimal number 45097.
    -- 45097÷12 = 3758 remainder 1
    -- 3758÷12 = 313 remainder 2
    -- 313÷12 = 26 remainder 1
    -- 26÷12 = 2 remainder 2
    -- 2÷12 = 0 remainder 2

    -- Thus, the base-12 representation of the decimal number 45097 is 22121

    local decimal_whole, decimal_fractional, is_positive = this.GetDozenalParts(decimal_value, fractional_places)

    --print("decimal_value: " .. tostring(decimal_value) .. ", fractional_places: " .. tostring(fractional_places))
    --print("decimal_whole: " .. tostring(decimal_whole) .. ", decimal_fractional: " .. tostring(decimal_fractional) .. ", is_positive: " .. tostring(is_positive))

    local fractional_text = ""
    if fractional_places > 0 and decimal_fractional > 0 then
        local text, round_up = this.GetDozenalFractional(decimal_fractional, fractional_places)
        fractional_text = text

        if round_up then
            decimal_whole = decimal_whole + 1       -- 1.EE with 1 fractional would become 1.0 + 1 (or 2.0)
        end
    end

    local retVal = this.GetDozenalWholeNum(decimal_whole)
    retVal = retVal .. fractional_text

    if not is_positive then
        retVal = "-" .. retVal
    end

    return retVal
end

-- LINQ style operations
-- Usage:
--  local min = Min(list, function(o) return o.propname end)
function Min(list, selector)
    local retVal = nil

    for _, item in pairs(list) do
        local value = selector(item)

        if retVal == nil or value < retVal then
            retVal = value
        end
    end

    return retVal
end
function Max(list, selector)
    local retVal = nil

    for _, item in pairs(list) do
        local value = selector(item)

        if retVal == nil or value > retVal then
            retVal = value
        end
    end

    return retVal
end
function Sum(list, selector)
    local retVal = 0

    for _, item in pairs(list) do
        retVal = retVal + selector(item)
    end

    return retVal
end

----------------------------------- Private Methods -----------------------------------

function this.GetDozenalParts(decimal_value, fractional_places)
    local abs_decimal = math.abs(decimal_value)

    local decimal_whole
    local decimal_fractional

    if fractional_places == 0 then
        decimal_whole = Round(abs_decimal, 0)
        decimal_fractional = 0
    else
        decimal_whole = math.floor(abs_decimal)     -- some of the fraction will be shown, so it won't be able to possibly round up the whole number portion
        decimal_fractional = abs_decimal - decimal_whole
    end

    return decimal_whole, decimal_fractional, decimal_value >= 0
end

function this.GetDozenalWholeNum(decimal_whole)
    --NOTE: A positive whole number must be passed in

    local retVal = ""

    while true do
        local mod = decimal_whole % 12

        if decimal_whole == 0 and mod == 0 then
            break
        end

        retVal = this.GetDozenalChar(mod) .. retVal

        decimal_whole = math.floor(decimal_whole / 12)
    end

    if retVal == "" then
        retVal = "0"
    end

    return retVal
end

function this.GetDozenalFractional(decimal_fractional, fractional_places)
    --NOTE: A positive whole number must be passed in

    local ints = this.GetDozenalFractional_Ints(decimal_fractional, fractional_places)

    local round_up = this.GetDozenalFractional_CarryOnes(ints)

    local retVal = this.GetDozenalFractional_Chars(ints)

    -- Strip trailing zeros
    retVal = retVal:gsub("0+$", "")

    if retVal ~= "" then
        retVal = "." .. retVal        --NOTE: They recommend semicolon, but that makes it really foreign to read (though that may be best, since some cultures use comma instead of period)
    end

    return retVal, round_up
end
function this.GetDozenalFractional_Ints(decimal_fractional, fractional_places)
    local retVal = {}

    local working_fractional = decimal_fractional

    for i = 1, fractional_places do
        working_fractional = working_fractional * 12

        --print("working_fractional: " .. tostring(working_fractional))

        local int_portion = math.floor(working_fractional)

        working_fractional = working_fractional - int_portion

        if i == fractional_places and working_fractional >= 0.5 then        -- should round up the last digit?
            int_portion = int_portion + 1
        end

        retVal[#retVal+1] = int_portion
    end

    return retVal
end
function this.GetDozenalFractional_CarryOnes(ints)
    local should_increment = false

    for i = #ints, 1, -1 do
        if should_increment then
            ints[i] = ints[i] + 1
            should_increment = false
        end

        if ints[i] > 11 then        -- it should just be 12, never higher
            ints[i] = 0
            should_increment = true
        end
    end

    return should_increment
end
function this.GetDozenalFractional_Chars(ints)
    local retVal = ""

    for i = 1, #ints do
        retVal = retVal .. this.GetDozenalChar(ints[i])
    end

    return retVal
end

function this.GetDozenalChar(value)
    if value < 0 then
        return "[ERROR: " .. tostring(value) .. "]"
    elseif value < 10 then
        return tostring(value)
    elseif value == 10 then
        return "X"
    elseif value == 11 then
        return "E"
    else
        return "[ERROR: " .. tostring(value) .. "]"
    end
end