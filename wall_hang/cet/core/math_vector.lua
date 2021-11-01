local this = {}

function vec_str(vector)
    if not vector then
        return "nil"
    end

    return tostring(Round(vector.x, 2)) .. ", " .. tostring(Round(vector.y, 2)) .. ", " .. tostring(Round(vector.z, 2))
end

function quat_str(quat)
    if not quat then
        return "nil"
    end

    return tostring(Round(quat.i, 3)) .. ", " .. tostring(Round(quat.j, 3)) .. ", " .. tostring(Round(quat.k, 3)) .. ", " .. tostring(Round(quat.r, 3))
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

-- Returns a quaternion that is the rotation from v1 to v2
-- percent is optional
function GetRotation(v1, v2, percent)
    if IsNearValue_vec4(v1, v2) then
        return GetIdentityQuaternion()
    end

    local axis = CrossProduct3D(v1, v2)
    local radians = RadiansBetween3D(v1, v2)

    if percent then
        radians = radians * percent
    end

    if IsNearZero(radians) then
        return GetIdentityQuaternion()
    end

    return Quaternion_FromAxisRadians(axis, radians)
end

-- Just wrapping it to be easier to remember/use
function Quaternion_FromAxisRadians(axis, radians)
    --https://redscript.redmodding.org/#30122
    --public static native SetAxisAngle(out q: Quaternion, axis: Vector4, angle: Float): Void
    return GetSingleton('Quaternion'):SetAxisAngle(axis, radians)     -- looks like cet turns out param into return
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

function RotateVector3D(vector, quat)
    return GetSingleton('Quaternion'):Transform(quat, vector)
end

-- This returns a quaternion that is the result of rotating by a delta
function RotateQuaternion(orig_quat, delta_quat)
    --https://referencesource.microsoft.com/#PresentationCore/Core/CSharp/system/windows/Media3D/Quaternion.cs

    --TODO: Detect if either of the quaternions is identity (probably 0,0,0,1)
    -- if (orig_quat.IsDistinguishedIdentity)
    -- {
    --     return delta_quat;
    -- }
    -- if (delta_quat.IsDistinguishedIdentity)
    -- {
    --     return orig_quat;
    -- }

    local x = orig_quat.r * delta_quat.i + orig_quat.i * delta_quat.r + orig_quat.j * delta_quat.k - orig_quat.k * delta_quat.j;
    local y = orig_quat.r * delta_quat.j + orig_quat.j * delta_quat.r + orig_quat.k * delta_quat.i - orig_quat.i * delta_quat.k;
    local z = orig_quat.r * delta_quat.k + orig_quat.k * delta_quat.r + orig_quat.i * delta_quat.j - orig_quat.j * delta_quat.i;
    local w = orig_quat.r * delta_quat.r - orig_quat.i * delta_quat.i - orig_quat.j * delta_quat.j - orig_quat.k * delta_quat.k;

    return Quaternion.new(x, y, z, w)
end

-- This returns a quaternion that is somewhere between from and to quaternions
function InterpolateQuaternions(from_quat, to_quat, percent)
    -- SLERP ensures the returned quat is a unit quat.  Slower, but can handle percent rotations
    -- https://www.youtube.com/watch?v=uNHIPVOnt-Y
    return GetSingleton('Quaternion'):Slerp(from_quat, to_quat, percent)
end

function GetIdentityQuaternion()
    return Quaternion.new(0, 0, 0, 1)
end
function IsIdentityQuaternion(quat)
    if not quat then
        return true     -- pretend nil is identity
    end

    return
        IsNearZero(quat.i) and
        IsNearZero(quat.j) and
        IsNearZero(quat.k) and
        IsNearValue(quat.r, 1)
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
-- Also returns if is in same direction (false means opposite direction)
--
-- Lookup "vector projection" to see the difference between this and dot product
-- http://en.wikipedia.org/wiki/Vector_projection
function GetProjectedVector_AlongVector(vector, alongVectorUnit, eitherDirection)
    -- c = (a dot unit(b)) * unit(b)

    if IsNearZero_vec4(vector) then
        return Vector4.new(0, 0, 0, 1), true
    end

    local length = DotProduct3D(vector, alongVectorUnit);

    if (not eitherDirection) and (length < 0) then
        -- It's in the opposite direction, and that isn't allowed
        return Vector4.new(0, 0, 0, 1), false
    end

    return
        MultiplyVector(alongVectorUnit, length),
        length > 0
end
-- Returns the portion of the vector that is along the plane
function GetProjectedVector_AlongPlane(vector, alongPlanes_normal)
    -- Get a line that is parallel to the plane, but along the direction of the vector
    local alongLine = GetProjectedVector_AlongPlane_Unit(vector, alongPlanes_normal)

    -- Use the other overload to get the portion of the vector along this line
    return GetProjectedVector_AlongVector(vector, alongLine)
end
-- Returns the direction of the vector along the plane
--  Returned value is length 1 (or len 0 if vector is perpendicular to plane)
function GetProjectedVector_AlongPlane_Unit(vector, alongPlanes_normal)
    local alongLine = CrossProduct3D(alongPlanes_normal, CrossProduct3D(vector, alongPlanes_normal))

    Normalize(alongLine)

    return alongLine
end

-- Turns dot product into a user friendly angle in degrees
--  dot     angle
--   1       0
--   0       90
--  -1       180
function Dot_to_Angle(dot)
    local radians = Dot_to_Radians(dot)
    return Radians_to_Degrees(radians)
end
function Angle_to_Dot(degrees)
    local radians = Degrees_to_Radians(degrees)
    return Radians_to_Dot(radians)
end

function Dot_to_Radians(dot)
    return math.acos(dot)
end
function Radians_to_Dot(radians)
    return math.cos(radians)
end

function Degrees_to_Radians(degrees)
    return degrees * math.pi / 180
end
function Radians_to_Degrees(radians)
    return radians * 180 / math.pi
end

function AddAngle_0_360(current, delta)
    return this.AddAngle(current, delta, 0, 360)
end
function AddAngle_neg180_pos180(current, delta)
    return this.AddAngle(current, delta, -180, 180)
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

-- Returns 1 - 2
function SubtractVectors(vector1, vector2)
    return Vector4.new(vector1.x - vector2.x, vector1.y - vector2.y, vector1.z - vector2.z, 1)
end

----------------------------------- Private Methods -----------------------------------

function this.AddAngle(current, delta, min, max)
    if not min then
        min = 0
    end

    if not max then
        max = 360
    end

    local retVal = current + delta

    while true do
        if retVal < min then
            retVal = retVal + 360
        elseif retVal > max then
            retVal = retVal - 360
        else
            break
        end
    end

    return retVal
end