-- This is a fixed sized buffer that can safely be added to as often as you'd like
--
-- self[1] holds the index that was last written to
-- self[2] .. self[#self] are the values
--
-- Traverse the entire buffer from oldest to newest with these two for loops:
-- for i=self[1]+1, #self do  ;  for i=2, self[1] do
--
-- Traverse from newest to oldest with these two:
-- for i=self[1], 2, -1 do  ;  for i=#self, self[1]+1, -1 do

local defaultVal = "null entry"

RollingBuffer = {}

function RollingBuffer:new(size)
    local obj = { 2 }       -- 2 means the first index is 2
    setmetatable(obj, self)
    self.__index = self

    for i=2, size+1 do
        obj[i] = defaultVal     -- can't assign it to nil, because #self won't work
    end

    return obj
end

function RollingBuffer:Add(item)
    local index = self[1] + 1
    if index > #self then
        index = 2
    end

    self[1] = index
    self[index] = item
end

function RollingBuffer:Clear()
    for i=2, #self do
        self[i] = defaultVal
    end
end

-- May want to use GetEntry from a loop, since this creates an array each time its called (less work for garbage collector)
function RollingBuffer:GetLatestEntries(count)
    local retVal = { }
    local index = 0

    for i=self[1], 2, -1 do
        if self[i] ~= defaultVal then
            index = index + 1
            if index > count then
                return retVal
            end

            retVal[index] = self[i]
        end
    end

    for i=#self, self[1]+1, -1 do
        if self[i] ~= defaultVal then
            index = index + 1
            if index > count then
                return retVal
            end

            retVal[index] = self[i]
        end
    end

    return retVal
end

function RollingBuffer:GetLastEntry()
    if self[self[1]] == defaultVal then
        return nil
    else
        return self[self[1]]
    end
end

-- If offset is 0, then it returns the latest entry.  If offset is GetCount() - 1, then it returns the oldest entry
function RollingBuffer:GetEntry(offset)
    local index = -1

    for i=self[1], 2, -1 do
        if self[i] ~= defaultVal then
            index = index + 1
            if index == offset then
                return self[i]
            end
        end
    end

    for i=#self, self[1]+1, -1 do
        if self[i] ~= defaultVal then
            index = index + 1
            if index == offset then
                return self[i]
            end
        end
    end

    return nil
end

function RollingBuffer:GetCount()
    for i = 2, #self, 1 do
        if self[i] == defaultVal then
            return i - 1
        end
    end

    -- It's fully populated
    return #self - 1
end

function RollingBuffer:GetSize()
    return #self - 1
end