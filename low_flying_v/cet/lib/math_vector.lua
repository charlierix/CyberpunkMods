function vec_str(vector)
    if not vector then
        return "nil"
    end

    return tostring(Round(vector.x, 2)) .. ", " .. tostring(Round(vector.y, 2)) .. ", " .. tostring(Round(vector.z, 2))
end

------------------------------------- Length -------------------------------------

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

-- Get the length^2 of vector2-vector1
function GetVectorDiffLengthSqr(vector1, vector2)
    if (not vector1) or (not vector2) then
        return 0
    end

    local diffX = vector1.x - vector2.x
    local diffY = vector1.y - vector2.y
    local diffZ = vector1.z - vector2.z

    return (diffX * diffX) + (diffY * diffY) + (diffZ * diffZ)
end

function GetVectorLength2DSqr(x, y)
    return (x * x) + (y * y)
end

function GetVectorLength2D(x, y)
    return math.sqrt((x * x) + (y * y))
end

-------------------------------------- Misc ---------------------------------------

function DotProduct2D(x1, y1, x2, y2)
    return (x1 * x2) + (y1 * y2)
end

function DotProduct3D(v1, v2)
    return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z)
end

-- This only needs to return a scalar, because 2D cross product is always along z
function CrossProduct2D(x1, y1, x2, y2)
    return (x1 * y2) - (y1 * x2)
end

function CrossProduct3D(v1, v2)
    return Vector4.new
    (
        (v1.y * v2.z) - (v1.z * v2.y),
        (v1.z * v2.x) - (v1.x * v2.z),
        (v1.x * v2.y) - (v1.y * v2.x),
        1
    )
end

function RadiansBetween2D(x1, y1, x2, y2)
    --cos(theta) = dot / (len * len)
    return math.acos(DotProduct2D(x1, y1, x2, y2) / (GetVectorLength2D(x1, y1) * GetVectorLength2D(x2, y2)))
end

function RadiansBetween3D(v1, v2)
    return math.acos(DotProduct3D(v1, v2) / (GetVectorLength(v1) * GetVectorLength(v2)))
end

-- Rotates a vector by the amount of radians (right hand rule, so positive radians are counter
-- clockwise)
function RotateVector2D(x, y, radians)
    local cos = math.cos(radians)
    local sin = math.sin(radians)

    return
        (cos * x) - (sin * y),
        (sin * x) + (cos * y)
end

------------------------------------- Convert -------------------------------------

function GetPoint(fromPos, unitDirection, length)
    return Vector4.new(fromPos.x + (unitDirection.x * length), fromPos.y + (unitDirection.y * length), fromPos.z + (unitDirection.z * length), 1)
end

function GetDirection(unitDirection, length)
    return Vector4.new(unitDirection.x * length, unitDirection.y * length, unitDirection.z * length, 1)
end


-- This removes the z and makes sure that that 2D portion is a length of 1
-- Returns two numbers.  x and y
function To2DUnit(vector)
    local lenSqr = GetVectorLength2DSqr(vector.x, vector.y)

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

------------------------------------- Operators -------------------------------------

--TODO: See if some of these operators are already part of the Vector4

function MultiplyVector(vector, constant)
    return Vector4.new(vector.x * constant, vector.y * constant, vector.z * constant, 1)
end

function DivideVector(vector, constant)
    return Vector4.new(vector.x / constant, vector.y / constant, vector.z / constant, 1)
end

function AddVectors(vector1, vector2)
    return Vector4.new(vector1.x + vector2.x, vector1.y + vector2.y, vector1.z + vector2.z, 1)
end

function SubtractVectors(vector1, vector2)
    return Vector4.new(vector1.x - vector2.x, vector1.y - vector2.y, vector1.z - vector2.z, 1)
end