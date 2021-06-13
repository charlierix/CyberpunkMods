-- This keeps track of a few buttons and stores true if certain combinations are pressed down
-- within a small window of time (considered to be simultaneously pressed)
--
-- Not hardcoding to ASDW, so that people with controllers could map different buttons.  For
-- example, they want to map grapple to (ps: triangle+circle || square+X) (xbox: Y+B || X+A).
-- Or people may just want a single dedicated button for grapple

InputTracker_StartStop = {}

-- The arrays passed in are in the form: keynames[i]=actionname
function InputTracker_StartStop:new(o, keys, keynames_1, keynames_2, keynames_stop)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    -- This is the longest time distance for multiple keydowns to be considered simultaneous
    obj.max_elapsed = 0.06

    obj.o = o
    obj.keys = keys

    obj.keynames_1 = keynames_1
    obj.keynames_2 = keynames_2
    obj.keynames_stop = keynames_stop

    -- This holds a deduped list of keys from the three lists of action names
    obj.keynames = GetDeduped({ keynames_1, keynames_2, keynames_stop })
    --ReportTable(obj.keynames)

    -- This holds the keydown time of each action
    -- key=actionname, value=keydown_time (or nil)
    obj.downTimes = {}

    return obj
end

function InputTracker_StartStop:Tick()
    for i=1, #self.keynames do
        local name = self.keynames[i]

        if self.keys.actions[name] and (not self.keys.prev_actions[name]) then
            -- Key was just pressed down, store the time
            self.downTimes[name] = self.o.timer

        elseif not self.keys.actions[name] then
            -- Key is no longer being pressed down
            self.downTimes[name] = nil
        end
    end
end

-- This forgets that keys were pressed down.  Call this after an action is started so this class
-- won't keep saying to start actions (forces the user to let go of the keys and repress them)
function InputTracker_StartStop:ResetKeyDowns()
    for key, _ in pairs(self.downTimes) do
        self.downTimes[key] = nil
    end
end

function InputTracker_StartStop:ShouldGrapple()
    return
        self:IsDown(self.keynames_1),
        self:IsDown(self.keynames_2)
end
function InputTracker_StartStop:ShouldStop()
    return self:IsDown(self.keynames_stop)
end

-------------------------------------- Private Methods --------------------------------------

function InputTracker_StartStop:IsDown(keynames)
    -- Single Key
    if #keynames == 1 then
        -- There's only one, so it's a simple check
        return self.downTimes[keynames[1]] ~= nil
    end

    -- Multiple Keys (make sure they were pressed nearly the same time)
    for outer=1, #keynames-1 do
        if not self.downTimes[keynames[outer]] then
            -- The button isn't currently being pressed
            return false
        end

        for inner=outer+1, #keynames do
            if not self.downTimes[keynames[inner]] then
                -- The button isn't currently being pressed
                return false
            end

            if math.abs(self.downTimes[keynames[outer]] - self.downTimes[keynames[inner]]) > self.max_elapsed then
                -- Both buttons are pressed, but not at the same time
                return false
            end
        end
    end

    -- All buttons were pressed simultaneously (at least within the alloted window of time)
    return true
end

function GetDeduped(jagged)
    -- Store all the actionnames in deduper as keys, and it will auto dedupe
    local deduper = {}

    for i=1, #jagged do
        for j=1, #jagged[i] do
            deduper[jagged[i][j]] = 1        -- the value doesn't matter, only interested in the key
        end
    end

    -- Now commit those keys to an int indexed array
    local deduped = {}

    local index = 1
    for key, _ in pairs(deduper) do
        deduped[index] = key
        index = index + 1
    end

    return deduped
end
