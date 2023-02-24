--NOTE: This gets heavily added to, removed from, queried.  It uses stickylist everywhere to
--avoid unnecessary memory allocations / deallocations.  I don't know how lua handles garbage
--collection, but this should avoid all that

RaycastHitStorage = {}

function RaycastHitStorage:new(garbageCollectInterval_seconds, garbageCountThreshold)
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    if not garbageCollectInterval_seconds then
        garbageCollectInterval_seconds = 1 + math.random()
    end

    if not garbageCountThreshold then
        garbageCountThreshold = 3
    end

    obj.garbageCollectInterval_seconds = garbageCollectInterval_seconds
    obj.garbageCountThreshold = garbageCountThreshold

    obj.nextCollectTime = 0
    obj.nextGarbageTrack = 0

    -- Each entry of points contains:
    -- point                    vector4
    -- sources                  stickylist
    --      source              link to ray cast worker
    --      key                 a string used by ray cast worker to indentify the ray source (integers "x,y,z")
    -- wasRequestedThisPeriod   bool gets set to true when points are requested, false at beginning of observation period
    -- garbageCount             how many collections it's gone without being requested
    obj.points = StickyList:new()

    -- This gets reused and returned from GetNearbyPoints
    -- This is an optimization to avoid creating arrays all the time.  The limitation is that
    -- a caller of getnearby must iterate and act on the list immediately, and not store the
    -- list, because the next call will invalidate it
    obj.getnearby_return = StickyList:new()

    return obj
end

-- Adds a point to the list, and a link to the calling ray caster so it can be informed
-- of removals
-- TODO: Instead of source being an object reference, it should probably just be a function with key as the param
function RaycastHitStorage:Add(point, source, key)
    -- Find a potential dupe
    for i=1, self.points:GetCount() do
        local existing = self.points:GetItem(i)

        if RaycastHitStorage_IsDupeHit(existing.point, point) then
            RaycastHitStorage_StoreSource(existing.sources, source, key)
            do return end
        end
    end

    -- Add new
    local entry = self.points:GetNewItem()

    entry.point = point
    entry.wasRequestedThisPeriod = true
    entry.garbageCount = 0

    if entry.sources then
        entry.sources:Clear()
    else
        entry.sources = StickyList:new()
    end

    RaycastHitStorage_StoreSource(entry.sources, source, key)
end

-- This finds points that are within the search radius
--
-- NOTE: Ideally, this would just return { point1, point2, point3 }, but stickylist is
-- used to avoid memory allocations.  Since it's hardcoded for each entry to be a table,
-- there's that extra layer of indirection
--
-- Returns:
--      A stickylist, each entry of that list is an array containing a single property "point"
--      That point is actually another array { point, garbageCount, wasRequestedThisPeriod, sources }
function RaycastHitStorage:GetNearbyPoints(center, radius)
    local radSqr = radius * radius

    self.getnearby_return:Clear()

    for i=1, self.points:GetCount() do
        local point = self.points:GetItem(i)

        if GetVectorDiffLengthSqr(point.point, center) <= radSqr then
            -- It's close enough, add to the return
            local retItem = self.getnearby_return:GetNewItem()
            retItem.point = point

            point.wasRequestedThisPeriod = true
        end
    end

    return self.getnearby_return
end

-- Clears all the points.  Also informs ray casters of the removals
function RaycastHitStorage:Clear()
    for i=1, self.points:GetCount() do
        local point = self.points:GetItem(i)

        RaycastHitStorage_InformRemovals(point.sources)
    end

    self.points:Clear()
end

-- Call this regularly, allowing this class to do garbage collection
-- time is just a growing number in seconds (seconds since game start)
function RaycastHitStorage:Tick(time)
    if time >= self.nextGarbageTrack then
        self:IncrementGarbageCounts()
        self.nextGarbageTrack = time + 1
    end

    if time >= self.nextCollectTime then
        self:Collect()
        self.nextCollectTime = time + self.garbageCollectInterval_seconds
    end
end

---------------------------------------- Private Instance Methods ----------------------------------------

-- Each second, this updates the garbage count for each point (0 if touched, count++ if untouched)
-- The reason garbage count isn't bumped directly during FindPoints is so the value stays
-- independent of framerate, queries per tick, etc
function RaycastHitStorage:IncrementGarbageCounts()
    for i=1, self.points:GetCount() do
        local point = self.points:GetItem(i)

        if point.wasRequestedThisPeriod then
            point.garbageCount = 0
        else
            point.garbageCount = point.garbageCount + 1
        end

        point.wasRequestedThisPeriod = false
    end
end

-- This looks for dead points (outside search radius for a while).  It then informs the sources
-- of removal and removes those points
function RaycastHitStorage:Collect()
    local index = 1

    while index <= self.points:GetCount() do
        local point = self.points:GetItem(index)

        if point.garbageCount >= self.garbageCountThreshold then
            RaycastHitStorage_InformRemovals(point.sources)

            self.points:RemoveItem(index)
        else
            index = index + 1
        end
    end
end

----------------------------------------- Private Static Methods -----------------------------------------

-- The standard IsNearValue is way to strict.  Since the raycasts are approximate, the threshold has
-- to be pretty loose
function RaycastHitStorage_IsDupeHit(hit1, hit2)
    if IsNearValue_custom(hit1.x, hit2.x, 0.25) and IsNearValue_custom(hit1.y, hit2.y, 0.25) and IsNearValue_custom(hit1.z, hit2.z, 0.25) then
        return true
    else
        return false
    end
end

------- Helper methods for working with self.sources
function RaycastHitStorage_StoreSource(sources, source, key)
    local entry = sources:GetNewItem()

    entry.source = source
    entry.key = key
end

function RaycastHitStorage_InformRemovals(sources)
    for i=1, sources:GetCount() do
        local entry = sources:GetItem(i)

        entry.source(entry.key)
    end
end
