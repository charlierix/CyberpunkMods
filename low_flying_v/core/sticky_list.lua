-- This is a list that can be added and removed from, but the entries are never actually removed,
-- they are just shuffled to the end, waiting for more adds to come along and use them
--
-- The reason for this class is an optimization to avoid unnecessary allocations/deallocations.  It
-- is good for holding items that would otherwise be frequently created and removed between updates
--
-- Each item is a table that can hold whatever you want.  However since a delete simply moves the
-- entry to a garbage area, you must completely overwrite any entry that is returned from GetNewItem
--
-- Another consequence of the design of this class is that if you remove items, stuff gets shuffled
-- so consider index to only have meaning during a single pass through the list (for i=1 to GetCount)

StickyList = {}

function StickyList:new()
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    -- These keep track of the size of the table.  Defined region and garbage region
    obj.maxIndex = 0        -- it's one based, zero means before first entry (empty)
    obj.count = 0

    -- This only gets added towards
    --      Items between 1 and maxIndex are live entries (the entries that the public should acccess)
    --      Items between maxIndex+1 and count are items that were "deleted" and will be reused as adds are requested
    obj.table = { }

    return obj
end

-- This returns the item at the requested index
function StickyList:GetItem(index)
    if (index < 1) or (index > self.maxIndex) then
        LogError("StickyList.GetItem: index out of range (index=" .. tostring(index) .. ") (max=" .. tostring(self.maxIndex) .. ")")
        return nil
    end

    return self.table[index]
end

-- This returns the public max (the actual max could be larger if there are deleted entries)
function StickyList:GetCount()
    return self.maxIndex
end

-- This requests a new item (like a list.add)
--
-- WARNING: The table returned could be a reclaimed entry that was previously "deleted".  If so, it will
-- have all of the old entry's values.  This stickylist is meant for consumers that have fixed properties
-- that they always overwrite
--
-- Returns:
--      the table at that location
--      index into list
function StickyList:GetNewItem()
    if self.maxIndex < self.count then
        self.maxIndex = self.maxIndex + 1
    else
        self.count = self.count + 1
        self.maxIndex = self.count

        self.table[self.maxIndex] = { }
    end

    return self.table[self.maxIndex], self.maxIndex
end

-- This pretends to remove the item from the list
-- It shifts the item into the garbage zone and decrements the public max
function StickyList:RemoveItem(index)
    if (index < 1) or (index > self.maxIndex) then
        LogError("StickyList.RemoveItem: index out of range (index=" .. tostring(index) .. ") (max=" .. tostring(self.maxIndex) .. ")")
        return nil
    end
    
    local temp = self.table[index]

    self.table[index] = self.table[self.maxIndex]
    self.table[self.maxIndex] = temp

    self.maxIndex = self.maxIndex - 1
end

function StickyList:Clear()
    self.maxIndex = 0
end
