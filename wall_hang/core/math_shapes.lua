local this = {}

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