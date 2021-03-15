-- This does a single ray cast to see if it is obscured
function IsRayCastHit(fromPos, dirX, dirY, dirZ, o)
    return not o:IsPointVisible(fromPos, Vector4.new(fromPos.x + dirX, fromPos.y + dirY, fromPos.z + dirZ, fromPos.w))
end

-- This does a ray cast and returns the hit point or nil
-- The only raycast function I could find is IsVisible.  So this has to do a binary search
function RayCast_HitPoint(fromPos, directionUnit, searchLength, minResolution, o)
    local testPoint = GetPoint(fromPos, directionUnit, searchLength)

    if o:IsPointVisible(fromPos, testPoint) then
        -- It's visible at the maximum distance, so there is no hit point to determine
        return nil, 1
    end

    local low = 0
    local high = 1
    local prevDist = searchLength

    --TODO: Put a max of around 6.  It's too expensive to do that many calls to get higher accuracy.  The caller should fine tune what they want
    for i=0, 36 do      -- it should resolve below threshold before this count, but putting in a limit just in case
        local percent = (low + high) / 2
        local newDist = searchLength * percent

        testPoint.x = fromPos.x + (directionUnit.x * searchLength * percent)
        testPoint.y = fromPos.y + (directionUnit.y * searchLength * percent)
        testPoint.z = fromPos.z + (directionUnit.z * searchLength * percent)

        --print("diff[" .. tostring(i) .. "]: " .. tostring(math.abs(newDist - prevDist)))

        if math.abs(newDist - prevDist) < minResolution then
            return testPoint, i+2
        end

        prevDist = newDist

        if o:IsPointVisible(fromPos, testPoint) then
            -- go up
            low = percent
        else
            -- go down
            high = percent
        end
    end

    return testPoint, 38
end
