local this = {}

-- This returns a random item from the list
-- NOTE: The items in the list must have a position property that is Vector4
-- NOTE: If nothing is found within the search radius, this returns the best close match
-- Params (optional):
--  center      Vector4     center point of the search
--  radius_min  float       if passed in, won't return anything closer than this
--  radius_max  float       if passed in, won't return anything farther than this
--  is3D        bool        should the distance checks be 3D or 2D (all the positions are 3D, it's just whether to ignore Z when doing distance checks)
function FindRandom_Position(list, center, radius_min, radius_max, is3D)

    print("FindRandom_Position a")

    if not list or #list == 0 then
        print("FindRandom_Position b")

        -- No points to choose
        return nil
    end

    print("FindRandom_Position c: " .. tostring(#list))

    if not (center and (radius_min or radius_max)) then
        print("FindRandom_Position d")

        -- No extra criteria, just pick something
        return list[math.random(#list)]
    end

    -- Find something inside the bounds of the query
    local retVal = this.FindRandom_Position_Exact(list, center, radius_min, radius_max, is3D)

    print("FindRandom_Position e")

    if retVal then

        print("FindRandom_Position f")

        return retVal
    end

    print("FindRandom_Position g")

    -- Couldn't get anything that exactly fits the params, widen the search
    return this.FindRandom_Position_Nearby(list, center, radius_min, radius_max)
end

----------------------------------- Private Methods -----------------------------------

function this.FindRandom_Position_Exact(list, center, radius_min, radius_max, is3D)
    local isMatch = this.GetDelegate_Position_Exact(center, radius_min, radius_max, is3D)

    local candidates = {}

    for i = 1, #list do
        if isMatch(list[i]) then
            candidates[#candidates+1] = list[i]
        end
    end

    print("candidates: " .. tostring(#candidates))

    if #candidates > 0 then
        return candidates[math.random(#candidates)]
    else
        return nil
    end
end

-- This returns a function that takes item, returns bool
function this.GetDelegate_Position_Exact(center, radius_min, radius_max, is3D)
    local min_sqr = nil
    if radius_min then
        min_sqr = radius_min * radius_min
    end

    local max_sqr = nil
    if radius_max then
        max_sqr = radius_max * radius_max
    end

    if radius_min and radius_max then
        if is3D then
            return function (item)
                local dist = GetVectorDiffLengthSqr(center, item.position)
                print("GetDelegate a: " .. tostring(math.sqrt(dist)))
                return dist >= min_sqr and dist <= max_sqr
            end
        else
            return function (item)
                local dist = GetVectorDiffLength2DSqr(center.x, item.position.x, center.y, item.position.y)
                print("GetDelegate b: " .. tostring(math.sqrt(dist)))
                return dist >= min_sqr and dist <= max_sqr
            end
        end

    elseif radius_min then
        if is3D then
            return function (item)
                local dist = GetVectorDiffLengthSqr(center, item.position)
                print("GetDelegate c: " .. tostring(math.sqrt(dist)))
                return dist >= min_sqr
            end
        else
            return function (item)
                local dist = GetVectorDiffLength2DSqr(center.x, item.position.x, center.y, item.position.y)
                print("GetDelegate d: " .. tostring(math.sqrt(dist)))
                return dist >= min_sqr
            end
        end

    elseif radius_max then
        if is3D then
            return function (item)
                local dist = GetVectorDiffLengthSqr(center, item.position)
                print("GetDelegate e: " .. tostring(math.sqrt(dist)))
                return dist <= max_sqr
            end
        else
            return function (item)
                local dist = GetVectorDiffLength2DSqr(center.x, item.position.x, center.y, item.position.y)
                print("GetDelegate f: " .. tostring(math.sqrt(dist)))
                return dist <= max_sqr
            end
        end

    else
        print("this.FindRandom_Position_Exact_Delegate: the code is broken")
        return nil
    end
end


function this.FindRandom_Position_Nearby(list, center, radius_min, radius_max, is3D)
    print("TODO: Finish FindRandom_Position_Nearby")
    return nil
end