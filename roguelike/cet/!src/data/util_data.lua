local this = {}

local MAX_NEARBY_PERCENT = 1.5     -- nearby search will pick randomly from points that are within this percent of the shortest distance

-- This returns a random item from the list
-- NOTE: The items in the list must have a position property that is Vector4
-- NOTE: If nothing is found within the search radius, this returns the best close match
-- Params (optional):
--  center      Vector4     center point of the search
--  radius_min  float       if passed in, won't return anything closer than this
--  radius_max  float       if passed in, won't return anything farther than this
--  is3D        bool        should the distance checks be 3D or 2D (all the positions are 3D, it's just whether to ignore Z when doing distance checks)
function FindRandom_Position(list, center, radius_min, radius_max, is3D)
    if not list or #list == 0 then
        -- No points to choose
        return nil
    end

    if not (center and (radius_min or radius_max)) then
        -- No extra criteria, just pick something
        return list[math.random(#list)]
    end

    -- Find something inside the bounds of the query
    local retVal = this.FindRandom_Position_Exact(list, center, radius_min, radius_max, is3D)

    if retVal then
        return retVal
    end

    -- Couldn't get anything that exactly fits the params, widen the search
    return this.FindRandom_Position_Nearby(list, center, radius_min, radius_max)
end

-- Small wrapper to file.open and json.decode
-- Returns
--  object, nil
--  nil, errMsg
function DeserializeJSON(filename)
    local handle = io.open(filename, "r")
    local json = handle:read("*all")

    local sucess, retVal = pcall(
        function(j) return extern_json.decode(j) end,
        json)

    if sucess then
        return retVal, nil
    else
        return nil, tostring(retVal)      -- when pcall has an error, the second value returned is the error message, otherwise it't the successful return value.  It should already be a sting, but doing a tostring just to be safe
    end
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

    if #candidates > 0 then
        return candidates[math.random(#candidates)]
    else
        return nil
    end
end

function this.FindRandom_Position_Nearby(list, center, radius_min, radius_max, is3D)
    local getDist = this.GetDelegate_DistanceSqr(center, radius_min, radius_max, is3D)

    local sorted = this.GetSortedList(list, getDist)

    local max_index = this.GetTopClosestIndex(sorted, MAX_NEARBY_PERCENT)

    local index = math.random(max_index)

    return list[sorted[index].index]
end

-- Returns the index of the last item that is still in range of:
--  sqrt(list[1]) * maxPercent
-- Params
--  list        { index, distSqr }[]
--  maxPercent  The largest percent of sqrt(list[n].distSqr) to include
function this.GetTopClosestIndex(list, maxPercent)
    if not list or #list == 0 then
        return nil
    end

    local shortestDistance = math.sqrt(list[1].distSqr)

    local maxDistSqr = (shortestDistance * maxPercent) ^ 2

    local retVal = 1

    for i = 2, #list do
        if list[i].distSqr <= maxDistSqr then
            -- Still in range
            retVal = i
        else
            -- Too far away
            break
        end
    end

    return retVal
end

-- This returns a function that takes item, returns distance squared
function this.GetDelegate_DistanceSqr(center, is3D)
    if is3D then
        return function (item)
            return GetVectorDiffLengthSqr(center, item.position)
        end
    else
        return function (item)
            return GetVectorDiffLength2DSqr(center.x, item.position.x, center.y, item.position.y)
        end
    end
end

-- This returns a function that takes item, returns bool
function this.GetDelegate_Position_Exact(center, radius_min, radius_max, is3D)
    local getDistSqr = this.GetDelegate_DistanceSqr(center, is3D)

    if radius_min and radius_max then
        return function (item)
            local distSqr = getDistSqr(item)
            return distSqr >= radius_min * radius_min and distSqr <= radius_max * radius_max
        end

    elseif radius_min then
        return function (item)
            local distSqr = getDistSqr(item)
            return distSqr >= radius_min * radius_min
        end

    elseif radius_max then
        return function (item)
            local distSqr = getDistSqr(item)
            return distSqr <= radius_max * radius_max
        end

    else
        print("this.GetDelegate_Position_Exact: the code is broken")
        return nil
    end
end

-- Returns an array sorted by distance based on the getDist delegate
--
-- Params:
--  list        an array, each item has a position property
--  getDist     a delegate that takes an item from the array and returns a distanceSquared
--
-- Returns:
--  { index, distSqr }[]
function this.GetSortedList(list, getDist)
    local retVal = {}

    for outer = 1, #list do
        local entry =
        {
            index = outer,
            distSqr = getDist(list[outer]),
        }

        local addedIt = false

        for inner = 1, #retVal do
            if entry.distSqr < retVal[inner].distSqr then
                Insert(retVal, entry, inner)
                addedIt = true
                break
            end
        end

        if not addedIt then
            retVal[#retVal+1] = entry
        end
    end

    return retVal
end