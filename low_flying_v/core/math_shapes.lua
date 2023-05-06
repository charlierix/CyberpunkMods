local this = {}

function IsAbovePlane(point_on_plane, normal, test_point, trueIfOnPlane)
    -- Compute D, using an arbitrary point P, that lies on the plane: D = - (Nx*Px + Ny*Py + Nz*Pz); Don't forget the inversion !
    local d = -((normal.x * point_on_plane.x) + (normal.y * point_on_plane.y) + (normal.z * point_on_plane.z))

    -- Test point (T) with respect to the plane using the plane equation: res = Nx*Tx + Ny*Ty + Nz*Tz + D
    local res = (normal.x * test_point.x) + (normal.y * test_point.y) + (normal.z * test_point.z) + d

    if res > 0 then
        return true     -- above the plane

    elseif trueIfOnPlane and IsNearZero(res) then
        return true     -- on the plane

    else
        return false        -- below the plane
    end
end

-- Calculates the intersection line segment between 2 lines (not segments).
-- Returns false if no solution can be found.
--
-- Got this here:
-- http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline3d/calclineline.cs
-- 
-- Which was ported from the C algorithm of Paul Bourke:
-- http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline3d/
--
-- Returns
--  success
--  point1
--  point2
function GetClosestPoints_Line_Line(line1_point1, line1_point2, line2_point1, line2_point2)
    local p1 = line1_point1
    local p2 = line1_point2
    local p3 = line2_point1
    local p4 = line2_point2
    local p13 = SubtractVectors(p1, p3)
    local p43 = SubtractVectors(p4, p3)

    --if (IsNearZero(p43.LengthSquared))
    --    return false;

    local p21 = SubtractVectors(p2, p1)
    --if (IsNearZero(p21.LengthSquared))
    --    return false;

    local d1343 = (p13.x * p43.x) + (p13.y * p43.y) + (p13.z * p43.z)
    local d4321 = (p43.x * p21.x) + (p43.y * p21.y) + (p43.z * p21.z)
    local d1321 = (p13.x * p21.x) + (p13.y * p21.y) + (p13.z * p21.z)
    local d4343 = (p43.x * p43.x) + (p43.y * p43.y) + (p43.z * p43.z)
    local d2121 = (p21.x * p21.x) + (p21.y * p21.y) + (p21.z * p21.z)

    local denom = (d2121 * d4343) - (d4321 * d4321)
    --if (IsNearZero(denom))
    --    return false;
    local numer = (d1343 * d4321) - (d1321 * d4343)

    local mua = numer / denom
    if IsNaN(mua) then
        return false, nil, nil
    end

    local mub = (d1343 + d4321 * (mua)) / d4343

    local point1 = Vector4.new(p1.x + mua * p21.x, p1.y + mua * p21.y, p1.z + mua * p21.z, 1)
    local point2 = Vector4.new(p3.x + mub * p43.x, p3.y + mub * p43.y, p3.z + mub * p43.z, 1)

    if IsNaN(point1.x) or IsNaN(point1.y) or IsNaN(point1.z) or IsNaN(point2.x) or IsNaN(point2.y) or IsNaN(point2.z) then
        return false, nil, nil
    else
        return true, point1, point2
    end
end

function GetClosestPoint_Line_Point(pointOnLine, lineDirection, testPoint)
    local dirToPoint = SubtractVectors(testPoint, pointOnLine)

    local dot1 = DotProduct3D(dirToPoint, lineDirection)
    local dot2 = DotProduct3D(lineDirection, lineDirection)
    local ratio = dot1 / dot2

    return AddVectors(pointOnLine, MultiplyVector(lineDirection, ratio))
end

-- Returns a point on the plane that is closest to the test point (test point isn't on the plane)
function GetClosestPoint_Plane_Point(pointOnPlane, normalUnit, testPoint)
    --NOTE: This should never return nil, since the intersection between a plane and its normal should never be nill
    return GetIntersection_Plane_Line(pointOnPlane, normalUnit, testPoint, normalUnit, true, true)
end

-- Returns the point that is common between the plane and line.  Returns nil if direction is
-- parallel to plane, or if the constraints fail
--
-- allow_before_point, allow_beyond_direction are bools.  In the c# this was copied from, it
-- was an enum { Segment, Ray, Line}, but that would be tedious to implement in lua.  Here are
-- how the enum values relate to bools:
--  Segment     allow_before_point = false      allow_beyond_direction = false
--  Ray         allow_before_point = false      allow_beyond_direction = true
--  Line        allow_before_point = true       allow_beyond_direction = true
function GetIntersection_Plane_Line(pointOnPlane, normalUnit, pointOnLine, lineDir, allow_before_point, allow_beyond_direction)
    --NO!!!!  I don't know why this was done, but it messes up the segment length constraint
    --lineDir.Normalize();                -- Normalize the lines vector

    local originDistance = this.GetPlaneOriginDistance(pointOnPlane, normalUnit)

    -- Use the plane equation (distance = Ax + By + Cz + D) to find the distance from one of our points to the plane.
    -- Here I just chose a arbitrary point as the point to find that distance.  You notice we negate that
    -- distance.  We negate the distance because we want to eventually go BACKWARDS from our point to the plane.
    -- By doing this is will basically bring us back to the plane to find our intersection point.
    local numerator =
        -(normalUnit.x * pointOnLine.x +        -- use the plane equation with the normal and the line
        normalUnit.y * pointOnLine.y +
        normalUnit.z * pointOnLine.z + originDistance)

    -- If we take the dot product between our line vector and the normal of the polygon,
    -- this will give us the sine of the angle between the 2 (Since they are both normalized - length 1).
    -- We will then divide our Numerator by this value to find the offset towards the plane from our arbitrary point.
    local denominator = DotProduct3D(normalUnit, lineDir)

    if denominator == 0 then        -- don't want to divide by zero
        return nil      -- line is parallel to plane
    end

    -- Divide the (distance from the point to the plane) by (the dot product) to get the distance (dist)
    -- needed to move from testPoint
    local dist = numerator / denominator        -- divide to get the multiplying (percentage) factor

    if not allow_before_point and dist < 0 then
        return nil      -- this is in the opposite direction (of lineDir)
    end

    if not allow_beyond_direction and dist > 1 then
        return nil      -- this is longer than the length of lineDir
    end

    return Vector4.new(pointOnLine.x + (lineDir.x * dist), pointOnLine.y + (lineDir.y * dist), pointOnLine.z + (lineDir.z * dist), 1)
end

----------------------------------- Private Methods -----------------------------------

-- This returns the distance between a plane and the origin
-- WARNING: Make sure you actually want this instead of DistanceFromPlane
function this.GetPlaneOriginDistance(pointOnPlane, normalUnit)
    local distance = 0      -- this variable holds the distance from the plane to the origin

    -- Use the plane equation to find the distance (Ax + By + Cz + D = 0)  We want to find D.
    -- So, we come up with D = -(Ax + By + Cz)
    -- Basically, the negated dot product of the normal of the plane and the point. (More about the dot product in another tutorial)
    distance = -((normalUnit.x * pointOnPlane.x) + (normalUnit.y * pointOnPlane.y) + (normalUnit.z * pointOnPlane.z));

    return distance     -- return the distance
end