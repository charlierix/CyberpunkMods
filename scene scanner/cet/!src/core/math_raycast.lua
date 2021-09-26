-- This does a single ray cast to see if it is obscured
function IsRayCastHit(fromPos, dirX, dirY, dirZ, o)
    return not o:IsPointVisible(fromPos, Vector4.new(fromPos.x + dirX, fromPos.y + dirY, fromPos.z + dirZ, fromPos.w))
end

-- This does a ray cast and returns the hit point or nil
--
-- The most reliable raycast function is IsVisible (it sees pretty much everything except people).
-- So this has to do a binary search to estimate the hit point
--
-- SyncRaycastByCollisionGroup misses a few things, like the vertical part of lampposts.  But it
-- does have the advantage of returning normal as well as position (use that one for collision
-- handling/wall runs)
function RayCast_HitPoint(fromPos, directionUnit, searchLength, minResolution, o)
    local testPoint = GetPoint(fromPos, directionUnit, searchLength)

    if o:IsPointVisible(fromPos, testPoint) then
        -- It's visible at the maximum distance, so there is no hit point to determine
        return nil, 1
    end

    local low = 0
    local high = 1
    local prevDist = searchLength

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

-- This attempts to fix a couple misses (see GetRaycastIncrement for details).  But any time that
-- RayCast_HitPoint returns nil, this does too.  Which makes me think that the ray cast system is
-- tied to the camera
--
-- There was a building block about 70 out (40 up), but the ray didn't see it and reported beyond
-- that at 100.  I flew up a bit and it suddenly registered at around 60
--
-- In other words, visuals are loaded, but collision hulls aren't.  You have to be close (like 60)
-- before collision hulls are reliably loaded in and ray casts start working
-- function RayCast_HitPoint_Extended(fromPos, directionUnit, searchLength, minResolution, o)
--     local numCalls = 0

--     local stepLength = GetRaycastIncrement(fromPos, directionUnit, searchLength)
--     local currentLength = 0

--     while (currentLength < searchLength) and (not IsNearValue(currentLength, searchLength)) do
--         local curFrom = GetPoint(fromPos, directionUnit, currentLength)

--         local hit, currentCalls = RayCast_HitPoint(curFrom, directionUnit, stepLength, minResolution, o)

--         numCalls = numCalls + currentCalls

--         if hit then
--             return hit, numCalls
--         end

--         currentLength = currentLength + stepLength
--     end

--     return nil, numCalls
-- end

-- function GetRaycastIncrement(fromPos, directionUnit, searchLength)
--     local retVal = searchLength

--     -- The game sometimes doesn't register hits against buildings when the z difference is more than 30
--     -- It happens most often when looking up the side of a tall building.  But there was also a case
--     -- where the roof of a low building didn't register when standing on top of a tall building

--     -- Calculate the length needed to keep zdiff under 30
--     local zdiff = math.abs(fromPos.z + (directionUnit.z * searchLength))

--     if zdiff > 28 then
--         local divisions = math.ceil(zdiff / 28)
--         retVal = searchLength / divisions
--     end

--     -- Raycast doesn't see anything farther than 100 away ---- actually, it does, just not reliablly, and
--     -- the distance shown in map pin stops at 100 (or at least the resolution switches, so 120 still reports
--     -- as 100)
--     if retVal > 97 then
--         retVal = 97
--     end

--     return retVal
-- end