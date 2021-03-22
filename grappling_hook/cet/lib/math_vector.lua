function vec_str(vector)
    if not vector then
        return "nil"
    end

    return tostring(Round(vector.x, 2)) .. ", " .. tostring(Round(vector.y, 2)) .. ", " .. tostring(Round(vector.z, 2))
end

------------------------------------- Length -------------------------------------

--TODO: See if vector4 already exposes a magnitude function --- it's GetSingleton('Vector4'):Distance(vector1, vector2)
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

function Get2DLengthSqr(x, y)
    return (x * x) + (y * y)
end

function Get2DLength(x, y)
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
    return math.acos(DotProduct2D(x1, y1, x2, y2) / (Get2DLength(x1, y1) * Get2DLength(x2, y2)))
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

-- This takes a 3D vector, gets rid of the Z, then makes that 2D projected vector have a length of 1
function Make2DUnit(vector)
    local retVal = Vector4.new(vector.x, vector.y, 0, 1)

    local length = GetVectorLength(retVal)
    if IsNearZero(length) then
        return Vector4.new(0, 0, 0, 1)
    end

    return Vector4.new(retVal.x / length, retVal.y / length, 0, 1)
end

-- This converts the vector into a unit vector (or leaves it zero length if zero length)
function Normalize(vector)
    local length = GetVectorLength(vector)

    if IsNearZero(length) then
        vector.x = 0        -- just making sure it's exactly zero
        vector.y = 0
        vector.z = 0
    else
        vector.x = vector.x / length
        vector.y = vector.y / length
        vector.z = vector.z / length
    end
end

-- Returns the portion of this vector that lies along the other vector
-- NOTE: The return will be the same direction as alongVector, but the length from zero to this vector's full length
--
-- Lookup "vector projection" to see the difference between this and dot product
-- http://en.wikipedia.org/wiki/Vector_projection
function GetProjectedVector_AlongVector(vector, alongVectorUnit, eitherDirection)
    -- c = (a dot unit(b)) * unit(b)

    if IsNearZero_vec4(vector) then
        return Vector4.new(0, 0, 0, 1)
    end

    local length = DotProduct3D(vector, alongVectorUnit);

    if (not eitherDirection) and (length < 0) then
        -- It's in the opposite direction, and that isn't allowed
        return Vector4.new(0, 0, 0, 1)
    end

    return alongVectorUnit * length;
end
function GetProjectedVector_AlongPlane(vector, alongPlanes_normal)
    -- Get a line that is parallel to the plane, but along the direction of the vector
    local alongLine = CrossProduct3D(alongPlanes_normal, CrossProduct3D(vector, alongPlanes_normal))

    Normalize(alongLine)

    -- Use the other overload to get the portion of the vector along this line
    return GetProjectedVector_AlongVector(vector, alongLine)
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