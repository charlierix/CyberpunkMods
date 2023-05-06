LaserFinderWorker = {}

-- This is a plate of ray casters.  When a floating point vector is passed into FireRays, it
-- converts that to the nearest integer (to avoid excessive ray casts)
--
-- There will be 6 instances of this class (one for each side of an axis aligned cube).  Each
-- is feeding their ray cast hits into a single RaycastHitStorage
--
-- RaycastHitStorage does garbage collection of unrequested points and informs this class when
-- a point was removed
--
-- This also does garbage collection of the points that fired a ray, but didn't hit anything
--
-- name                 a user friendly name (only used for debugging)
-- o                    instance of GameObjectAccessor
-- storage              an instance of RaycastHitStorage
-- fireDirection        only one of the 3 axiis can be non zero, and it must be -1 or 1
-- rayLength            how far to fire the laser (the farther the distance, the more attempts it will take to get to a particular accuracy)
-- stepDistance         fire requests are floating point, but actual fire locations are integer.  This is how dense the firing pattern is (1 is the smallest)
-- numSteps             how wide of a net to cast.  0 will only be a single point.  1 will be three points (neg,zero,pos).  2 will be five, etc
--
-- string name, RaycastHitStorage storage, Vector3Int fireDirection, float rayLength, int stepDistance, int numSteps, float garbageCollectInterval_seconds, int garbageCountThreshold
function LaserFinderWorker:new(name, o, storage, fireDirection, rayLength, stepDistance, numSteps, garbageCollectInterval_seconds, garbageCountThreshold)
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    if not garbageCollectInterval_seconds then
        garbageCollectInterval_seconds = 0.5 + (math.random() * 0.5)
    end

    if not garbageCountThreshold then
        garbageCountThreshold = 3
    end

    obj.name = name

    obj.o = o
    obj.storage = storage

    obj.directionUnit = fireDirection
    obj.rayLength = rayLength

    obj.stepDirections = Vector4.new(
        LaserFinderWorker_GetStepDirection(fireDirection.x, stepDistance, numSteps),
        LaserFinderWorker_GetStepDirection(fireDirection.y, stepDistance, numSteps),
        LaserFinderWorker_GetStepDirection(fireDirection.z, stepDistance, numSteps),
        1)

    obj.stepDistances = Vector4.new(
        LaserFinderWorker_GetStepDistance(fireDirection.x, stepDistance, rayLength),
        LaserFinderWorker_GetStepDistance(fireDirection.y, stepDistance, rayLength),
        LaserFinderWorker_GetStepDistance(fireDirection.z, stepDistance, rayLength),
        1)

    obj.halfSteps = Vector4.new(       -- this might be a silly optimization, just trying to avoid these divisions multiple times each frame
        obj.stepDistances.x / 2,
        obj.stepDistances.y / 2,
        obj.stepDistances.z / 2,
        1)

    obj.garbageCollectInterval_seconds = garbageCollectInterval_seconds
    obj.garbageCountThreshold = garbageCountThreshold

    obj.nextCollectTime = 0
    obj.nextGarbageTrack = 0

    -- These remember which shots were fired to avoid repeating ray casts
    -- values   { string LaserFinderWorker_ConvertToInt().key, bool wasRequestedThisPeriod, int garbageCount }
    obj.hits = StickyList:new()
    obj.misses = StickyList:new()

    -- This gets passed to storage for each hitpoint, then storage calls this when the point gets removed
    obj.hitRemoved_delegate = function (key)
        for i = 1, obj.hits:GetCount() do
            local entry = obj.hits:GetItem(i)

            if entry.key == key then
                --print(obj.name .. " removing hit: " .. entry.key)
                obj.hits:RemoveItem(i)
                do return end
            end
        end
    end

    obj.isDownFiring = fireDirection.z < 0

    return obj
end

function LaserFinderWorker:FireRays(point)
    local int_x, int_y, int_z = LaserFinderWorker_ConvertToInt(point, self.stepDistances, self.halfSteps);

    --print(vec_str(point) .. " --> " .. tostring(int_x) .. ", " .. tostring(int_y) .. ", " .. tostring(int_z))
    --print("step stepDistances: " .. vec_str(self.stepDistances))
    --print("step stepDirections: " .. vec_str(self.stepDirections))

    for x = int_x - self.stepDirections.x, int_x + self.stepDirections.x, self.stepDistances.x do     -- stepDistance and numSteps is already multiplied into stepDirections
        for y = int_y - self.stepDirections.y, int_y + self.stepDirections.y, self.stepDistances.y do
            for z = int_z - self.stepDirections.z, int_z + self.stepDirections.z, self.stepDistances.z do
                --print("fire ray: " .. tostring(x) .. ", " .. tostring(y) .. ", " .. tostring(z))
                self:FireRay(x, y, z)
            end
        end
    end
end

-- Call this on a regular basis, passing in elapsed time in seconds since the game started
-- This will perform garbage collecion on ray casts that didn't hit anything
function LaserFinderWorker:Tick(time)
    if time >= self.nextGarbageTrack then
        self.nextGarbageTrack = time + 0.5
        self:IncrementGarbageCounts()
    end

    if time >= self.nextCollectTime then
        self.nextCollectTime = time + self.garbageCollectInterval_seconds
        self:Collect()
    end
end

-- This clears the local hits and misses lists (it's up to the caller to clear the hitpoint storage
-- class, since the caller will have multiple workers)
function LaserFinderWorker:Clear()
    self.hits:Clear()
    self.misses:Clear()
end

---------------------------------------- Private Instance Methods ----------------------------------------
-- int x, y, z
function LaserFinderWorker:FireRay(x, y, z)
    local key = LaserFinderWorker_GetKey(x, y, z)

    -- Exit if it's already there (also mark as touched this frame)
    if LaserFinderWorker_ContainsKey(self.hits, key, true) or LaserFinderWorker_ContainsKey(self.misses, key, true) then
        do return end
    end

    -- Fire ray
    local fromPos = Vector4.new(x, y, z, 1);
    local hit = self.o:RayCast(fromPos, GetPoint(fromPos, self.directionUnit, self.rayLength))

    -- the new raycast now sees water
    -- -- Detect water (water isn't seen by ray casts and is at z=0)
    -- if (not hit) and self.isDownFiring then
    --     if z < 0 then
    --         hit = Vector4.new(x, y, z, 1)
    --     elseif z - self.rayLength < 0 then
    --         hit = Vector4.new(x, y, 0, 1)
    --     end
    -- end

    -- Store the hit or miss
    if hit then
        LaserFinderWorker_StoreFiring(self.hits, key)
        self.storage:Add(hit, self.hitRemoved_delegate, key)
    else
        LaserFinderWorker_StoreFiring(self.misses, key)
    end
end

-- This function gets called on a regular basis, bumps an int based on bool.  This buffered approach lets
-- garbage collections be based on time elapsed and not framerate based
function LaserFinderWorker:IncrementGarbageCounts()
    for i = 1, self.misses:GetCount() do
        local entry = self.misses:GetItem(i)

        if entry.wasRequestedThisPeriod then
            entry.garbageCount = 0
        else
            entry.garbageCount = entry.garbageCount + 1
        end

        entry.wasRequestedThisPeriod = false
    end
end

function LaserFinderWorker:Collect()
    local index = 1

    while index <= self.misses:GetCount() do
        local entry = self.misses:GetItem(index)

        if entry.garbageCount >= self.garbageCountThreshold then
            --print(self.name .. " removing miss: " .. entry.key)
            self.misses:RemoveItem(index)
        else
            index = index + 1
        end
    end
end

----------------------------------------- Private Static Methods -----------------------------------------

-- This stores a new entry in self.hits or self.misses
function LaserFinderWorker_StoreFiring(stickylist, key)
    local item = stickylist:GetNewItem()

    item.key = key
    item.wasRequestedThisPeriod = true
    item.garbageCount = 0
end

-- Searches each item in the stickylist, looking at entry.key
function LaserFinderWorker_ContainsKey(stickylist, key, markAsTouched)
    for i = 1, stickylist:GetCount() do
        local entry = stickylist:GetItem(i)

        if entry.key == key then
            if markAsTouched then
                entry.wasRequestedThisPeriod = true
            end

            return true
        end
    end

    return false
end

-- int fireDirection, int stepDistance, int numSteps
function LaserFinderWorker_GetStepDirection(fireDirection, stepDistance, numSteps)
    -- If it's non zero, that means the ray is firing in that axis, so keep that dimension the same as
    -- the request point's
    --
    -- The other two axiis are what slide around (so you can fire multiple rays from that plane)
    if fireDirection == 0 then
        return stepDistance * numSteps
    else
        return 0
    end
end

-- int fireDirection, int stepDistance, float rayLength
function LaserFinderWorker_GetStepDistance(fireDirection, stepDistance, rayLength)
    if fireDirection == 0 then
        return stepDistance     -- it's not the firing direction that this class is instantiated for, which means it's in the plane perp to firing direction.  So use the step direction that this class was told to use
    end

    -- It's the direction that the ray is firing.  So return a sensible step distance
    -- based on the ray's max distance

    --NOTE: With this optimization, down firing rays could start below the player and never see the ground.  But the
    --up firing rays should still see the ground (though they wouldn't see anything above the ground (safety rays
    --should still catch that)

    -------- This is nice in theory, but a little too sparse
    --int rayLengthInt = rayLength.ToInt_Floor();
    --if (rayLength.IsNearValue(rayLengthInt))        // if the floating point value is a whole number, then back off one just to be safe
    --    rayLengthInt = Math.Max(rayLengthInt - 1, 1);

    --return rayLengthInt;

    -------- Half is a good compromise
    return math.max(Round(rayLength / 2, 0), 1)
end

-- Takes a vector containing floating point values and converts to a vector with integer values
-- (lua doesn't have a different datatype for float vs int, but that's what is being done)
--
-- Params:
--      vector      Vector4 with floating point values
--      steps       Vector4 with integer values (1 would truncate to every integer, 2 would only stop on evens, etc)
--
-- Returns:
--      x           The vector truncated to integer values
--      y
--      z
function LaserFinderWorker_ConvertToInt(vector, steps, halfSteps)
    local x = LaserFinderWorker_GetIntKey(vector.x, steps.x, halfSteps.x)
    local y = LaserFinderWorker_GetIntKey(vector.y, steps.y, halfSteps.y)
    local z = LaserFinderWorker_GetIntKey(vector.z, steps.z, halfSteps.z)

    return x, y, z
end
function LaserFinderWorker_GetIntKey(value, step, halfStep)
    local retVal = math.floor(value)

    retVal = retVal - (retVal % step)       -- this works for negatives as well, because the mod of a negative is positive, but this is subtracting (-3 % 2 = 1, so it becomes -4)

    if value > (retVal + halfStep) then     -- this is like rounding, but at the granularity of step
        retVal = retVal + step
    end

    return retVal
end

-- A string that can be used as a hash representing the point
function LaserFinderWorker_GetKey(x, y, z)
    return tostring(x).."|"..tostring(y).."|".. tostring(z)
end