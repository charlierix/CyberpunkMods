function IsNearValue(value, test)
    return math.abs(value - test) < 0.001
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

--TODO: See if vector4 already exposes a magnitude function
function GetVectorLength(vector)
    if not vector then
        return 0
    end

    return math.sqrt((vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z))
end

function GetVectorLengthSqr(vector)
    if not vector then
        return 0
    end

    return (vector.x * vector.x) + (vector.y * vector.y) + (vector.z * vector.z)
end

function Get2DLengthSqr(x, y)
    return (x * x) + (y * y)
end

function Get2DLength(x, y)
    return math.sqrt((x * x) + (y * y))
end

-- This removes the z and makes sure that that 2D portion is a length of 1
-- Returns two numbers.  x and y
function To2DUnit(vector)
    local lenSqr = Get2DLengthSqr(vector.x, vector.y)

    if IsNearValue(lenSqr, 1) then
        -- Already unit
        return vector.x, vector.y
    elseif IsNearZero(lenSqr) then
        -- Divide by zero.  Could return the equivalent of NaN, but zero is probably good
        return 0, 0
    end

    local len = math.sqrt(lenSqr)

    return vector.x / len, vector.y / len
end

-- This does a single ray cast to see if it is obscured
function IsRayCastHit(senseManager, fromPos, dirX, dirY, dirZ)
    return not senseManager:IsPositionVisible(fromPos, Vector4.new(fromPos.x + dirX, fromPos.y + dirY, fromPos.z + dirZ, fromPos.w))
end