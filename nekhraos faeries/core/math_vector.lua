local this = {}

local circlePoints_byCount = {}

function vec_str(vector)
    if not vector then
        return "nil"
    elseif not vector.x or not vector.y or not vector.z then
        return tostring(vector)
    end

    return tostring(Round(vector.x, 2)) .. ", " .. tostring(Round(vector.y, 2)) .. ", " .. tostring(Round(vector.z, 2))
end

function quat_str(quat)
    if not quat then
        return "nil"
    end

    return tostring(Round(quat.i, 3)) .. ", " .. tostring(Round(quat.j, 3)) .. ", " .. tostring(Round(quat.k, 3)) .. ", " .. tostring(Round(quat.r, 3))
end

--------------------------------------- Length ----------------------------------------

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

function GetVectorLength3DSqr(x, y, z)
    return (x * x) + (y * y) + (z * z)
end

function GetVectorLength3D(x, y, z)
    return math.sqrt((x * x) + (y * y) * (z * z))
end

function GetVectorLengthNDSqr(vector)
    if not vector then
        return 0
    end

    local len_sqr = 0

    for _, axis in ipairs(vector) do
        len_sqr = len_sqr + (axis * axis)
    end

    return len_sqr
end
function GetVectorLengthND(vector)
    return math.sqrt(GetVectorLengthNDSqr(vector))
end

---------------------------------------- Misc -----------------------------------------

function DotProduct2D(x1, y1, x2, y2)
    return (x1 * x2) + (y1 * y2)
end

function DotProduct3D(v1, v2)
    return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z)
end

function DotProductND(v1, v2)
    local retVal = 0

    local count = math.min(#v1, #v2)

    for i = 1, count, 1 do
        retVal = retVal + (v1[i] * v2[i])
    end

    return retVal
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

-- Returns:
--  min: vector holding the lowest values of x,y,z
--  max: vector with highest x,y,z
function GetAABB(points)
    if not points or #points == 0 then
        -- No points passed in
        return Vector4.new(0, 0, 0, 1), Vector4.new(0, 0, 0, 1)
    end

    local minX = 2147000000     -- 2147483647 (giving a little extra room) -- (math.maxinteger is returning nil)
    local minY = 2147000000
    local minZ = 2147000000
    local maxX = -2147000000
    local maxY = -2147000000
    local maxZ = -2147000000

    for i = 1, #points do
        if points[i].x < minX then
            minX = points[i].x
        end

        if points[i].y < minY then
            minY = points[i].y
        end

        if points[i].z < minZ then
            minZ = points[i].z
        end

        if points[i].x > maxX then
            maxX = points[i].x
        end

        if points[i].y > maxY then
            maxY = points[i].y
        end

        if points[i].z > maxZ then
            maxZ = points[i].z
        end
    end

    return Vector4.new(minX, minY, minZ, 1), Vector4.new(maxX, maxY, maxZ, 1)
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
    local axis_unit = axis
    if not IsNearValue(GetVectorLengthSqr(axis), 1) then
        axis_unit = ToUnit(axis)
    end

    --https://redscript.redmodding.org/#30122
    --public static native SetAxisAngle(out q: Quaternion, axis: Vector4, angle: Float): Void
    return GetSingleton('Quaternion'):SetAxisAngle(axis_unit, radians)     -- looks like cet turns out param into return
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
function RotateVector3D_axis_angle(vector, axis, angle)
    return RotateVector3D_axis_radian(vector, axis, Degrees_to_Radians(angle))
end
function RotateVector3D_axis_radian(vector, axis, radians)
    return RotateVector3D(vector, Quaternion_FromAxisRadians(axis, radians))
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

function ToUnit(vector)
    local length = GetVectorLength(vector)

    if IsNearZero(length) then
        return Vector4.new(0, 0, 0, 1)
    else
        return Vector4.new(vector.x / length, vector.y / length, vector.z / length, 1)
    end
end

function ToUnit_ND(vector)
    local length_sqr = GetVectorLengthNDSqr(vector)

    if IsNearZero(length_sqr) or IsNearValue(length_sqr, 1) then
        return vector
    end

    local retVal = {}

    local length = math.sqrt(length_sqr)

    for index, value in ipairs(vector) do
        retVal[index] = value / length
    end

    return retVal
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

function Negate(vector)
    return Vector4.new(-vector.x, -vector.y, -vector.z, 1)
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

    Normalize(alongLine)

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

function GetClosestPoint_Line_Point(pointOnLine, lineDirection, testPoint)
    local dirToPoint = SubtractVectors(testPoint, pointOnLine)

    local dot1 = DotProduct3D(dirToPoint, lineDirection)
    local dot2 = DotProduct3D(lineDirection, lineDirection)
    local ratio = dot1 / dot2

    return AddVectors(pointOnLine, MultiplyVector(lineDirection, ratio))
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

-- Returns an array of Vector2
-- NOTE: Vector2 has X,Y capitalized.  Vector4 is lower case
function GetCircle_Cached(num_sides)
    local key = "sides" .. tostring(num_sides)

    if not circlePoints_byCount[key] then
        circlePoints_byCount[key] = this.GetCirclePoints(num_sides)
    end

    return circlePoints_byCount[key]
end

--------------------------------------- Random ----------------------------------------

-- Returns a vector that is perpendicular to the vector passed in
-- NOTE: Returned won't be a unit vector
function GetArbitraryOrthogonal(vector)
    if IsNearZero_vec4(vector) then
        return Vector4.new(0, 0, 0, 1)
    end

    local rand = GetRandomVector_square(1)

    for i = 1, 10 do
        local retVal = CrossProduct3D(vector, rand)

        if IsNearZero_vec4(retVal) then
            rand = GetRandomVector_square(1)
        else
            return retVal
        end
    end

    LogError("GetArbitraryOrhonganal: Infinite loop detected")
    return Vector4.new(0, 0, 0, 1)
end

-- Get a random vector between boundry lower and boundry upper (lower and upper are vectors)
function GetRandomVector_fromto(boundryLower, boundryUpper)
    return Vector4.new
    (
        GetScaledValue(boundryLower.x, boundryUpper.x, 0, 1, math.random()),
        GetScaledValue(boundryLower.y, boundryUpper.y, 0, 1, math.random()),
        GetScaledValue(boundryLower.z, boundryUpper.z, 0, 1, math.random()),
        1
    )
end
-- Get a random vector between -maxValue and maxValue
function GetRandomVector_square(maxValue)
    return Vector4.new
    (
        GetScaledValue(-maxValue, maxValue, 0, 1, math.random()),
        GetScaledValue(-maxValue, maxValue, 0, 1, math.random()),
        GetScaledValue(-maxValue, maxValue, 0, 1, math.random()),
        1
    )
end

-- Gets a random vector with radius between maxRadius*-1 and maxRadius (bounds are spherical,
-- rather than cube).  The radius will never be inside minRadius
--
-- The sqrt idea came from here:
-- http://dzindzinovic.blogspot.com/2010/05/xna-random-point-in-circle.html
function GetRandomVector_Spherical(minRadius, maxRadius)
    -- A sqrt, sin and cos  :(           can it be made cheaper?
    local radius = minRadius + ((maxRadius - minRadius) * math.sqrt(math.random()))     -- without the square root, there is more chance at the center than the edges

    return GetRandomVector_Spherical_Shell(radius)
end
-- Gets a random vector with the radius passed in (bounds are spherical, rather than cube)
function GetRandomVector_Spherical_Shell(radius)
    local theta = math.random() * math.pi * 2

    local phi = GetPhiForRandom(GetScaledValue(-1, 1, 0, 1, math.random()))

    local sinPhi = math.sin(phi)

    local x = radius * math.cos(theta) * sinPhi
    local y = radius * math.sin(theta) * sinPhi
    local z = radius * math.cos(phi)

    return Vector4.new(x, y, z, 1)
end

-- Gets a random vector with radius between maxRadius*-1 and maxRadius (bounds are spherical,
-- rather than cube).  The radius will never be inside minRadius.  Z will always be zero.
--
-- The sqrt idea came from here:
-- http://dzindzinovic.blogspot.com/2010/05/xna-random-point-in-circle.html
function GetRandomVector_Circular(minRadius, maxRadius)
    local radius = minRadius + ((maxRadius - minRadius) * math.sqrt(math.random()))     -- without the square root, there is more chance at the center than the edges

    return GetRandomVector_Circular_Shell(radius)
end
-- Gets a random vector with the radius passed in (bounds are spherical, rather than cube).  Z will always be zero
function GetRandomVector_Circular_Shell(radius)
    local angle = math.random() * math.pi * 2

    local x = radius * math.cos(angle)
    local y = radius * math.sin(angle)

    return Vector4.new(x, y, 0, 1)
end

function GetRandomVector_Cone(axis, minAngle, maxAngle, minRadius, maxRadius)
    local minRand = GetRandomForPhi(Degrees_to_Radians(minAngle))
    local maxRand = GetRandomForPhi(Degrees_to_Radians(maxAngle))
    if maxRand < minRand then
        local temp = minRand
        minRand = maxRand
        maxRand = temp
    end

    local theta = math.random() * 2 * math.pi
    local phi = GetPhiForRandom(minRand + (math.random() * (maxRand - minRand)))
    local radius = minRadius + ((maxRadius - minRadius) * math.sqrt(math.random()))     -- without the square root, there is more chance at the center than the edges

    local sinPhi = math.sin(phi)

    local retVal = Vector4.new
    (
        radius * math.cos(theta) * sinPhi,
        radius * math.sin(theta) * sinPhi,
        radius * math.cos(phi),
        1
    );

    local quat = GetRotation(Vector4.new(0, 0, 1, 1), axis)
    retVal = RotateVector3D(retVal, quat)

    return retVal
end

function GetRandomRotation()
    local axis = GetRandomVector_Spherical_Shell(1)
    local radians = math.random() * math.pi * 2

    return Quaternion_FromAxisRadians(axis, radians)
end

-- This returns a phi from 0 to pi based on an input from -1 to 1
--
-- NOTE: The input is linear (even chance of any value from -1 to 1), but the output is scaled to give an even chance of a Z
-- on a sphere:
--
-- z is cos of phi, which isn't linear.  So the probability is higher that more will be at the poles.  Which means if I want
-- a linear probability of z, I need to feed the cosine something that will flatten it into a line.  The curve that will do that
-- is arccos (which basically rotates the cosine wave 90 degrees).  This means that it is undefined for any x outside the range
-- of -1 to 1.  So I have to shift the random statement to go between -1 to 1, run it through the curve, then shift the result
-- to go between 0 and pi
function GetPhiForRandom(num_negone_posone)
    --double phi = rand.NextDouble(-1, 1);      // value from -1 to 1
    --phi = -Math.Asin(phi) / (Math.PI * .5d);      // another value from -1 to 1
    --phi = (1d + phi) * Math.PI * .5d;     // from 0 to pi

    return math.pi / 2 - math.asin(num_negone_posone)
end
-- This is a complimentary function to GetPhiForRandom.  It's used to figure out the range for random to get a desired phi
function GetRandomForPhi(expectedRadians)
    return -math.sin(expectedRadians - (math.pi / 2))
end

--------------------------------------- Convert ---------------------------------------

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

function GetMidPoint(point1, point2)
    return Vector4.new(
        point1.x + ((point2.x - point1.x) / 2),
        point1.y + ((point2.y - point1.y) / 2),
        point1.z + ((point2.z - point1.z) / 2),
        1)
end

-------------------------------------- Operators --------------------------------------

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

function this.GetCirclePoints(num_sides)
    local delta_theta = 2 * math.pi / num_sides
    local theta = 0

    local points = {}       -- these define a unit circle

    for i = 1, num_sides, 1 do
        table.insert(points, Vector2.new({ X = math.cos(theta), Y = math.sin(theta)}))

        theta = theta + delta_theta;
    end

    return points
end