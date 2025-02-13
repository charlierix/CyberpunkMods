-- This keeps track of a few buttons and stores true if certain combinations are pressed down
-- within a small window of time (considered to be simultaneously pressed)
--
-- Not hardcoding to ASDW, so that people with controllers could map different buttons.  For
-- example, they want to map grapple to (ps: triangle+circle || square+X) (xbox: Y+B || X+A).
-- Or people may just want a single dedicated button for grapple

InputTracker_StartStop = {}

local this = {}

-- The arrays passed in are in the form: keynames[i]=actionname
function InputTracker_StartStop:new(o, vars, keys, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    -- This is the longest time distance for multiple keydowns to be considered simultaneous
    obj.max_elapsed = 0.06

    obj.o = o
    obj.vars = vars
    obj.keys = keys
    obj.const = const

    -- These are managed through ClearBinding, UpdateBinding methods
    --obj.keynames_1
    --obj.keynames_2
    --obj.keynames_3
    --obj.keynames_4
    --obj.keynames_5
    --obj.keynames_6
    --obj.keynames_stop

    -- This holds a deduped list of keys from the above lists of action names
    --obj.keynames

    -- This is all the bindings, but sorted in order of how they should be checked (there could be some that
    -- are subsets of others, so the subsets need to be checked later)
    --
    -- Each item is an array: { binding enum, array of action names }
    --obj.call_order

    --obj.held_names

    -- This holds the keydown time of each action
    -- key=actionname, value=keydown_time (or nil)
    obj.downTimes = {}

    return obj
end

function InputTracker_StartStop:Tick()
    if not self.keys:IsMatchingInputDevice(self.vars.input_device, self.const) then
        do return end
    end

    -- Standard key tracking
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

    -- Special list that is the previous set that triggered an action.  Needs to keep reporting as held down
    -- until they let go of one of the keys
    if self.held_names then
        for i = 1, #self.held_names, 1 do
            if not self.keys.actions[self.held_names[i]] then
                self.held_names = nil
                do break end
            end
        end
    end
end

function InputTracker_StartStop:ClearBinding(binding)
    self:UpdateBinding(binding, nil)
end
function InputTracker_StartStop:UpdateBinding(binding, actionNames)
    if binding == self.const.bindings.grapple1 then
        self.keynames_1 = actionNames

    elseif binding == self.const.bindings.grapple2 then
        self.keynames_2 = actionNames

    elseif binding == self.const.bindings.grapple3 then
        self.keynames_3 = actionNames

    elseif binding == self.const.bindings.grapple4 then
        self.keynames_4 = actionNames

    elseif binding == self.const.bindings.grapple5 then
        self.keynames_5 = actionNames

    elseif binding == self.const.bindings.grapple6 then
        self.keynames_6 = actionNames

    elseif binding == self.const.bindings.stop then
        self.keynames_stop = actionNames
    end

    self.keynames = this.GetDeduped({ self.keynames_1, self.keynames_2, self.keynames_3, self.keynames_4, self.keynames_5, self.keynames_6, self.keynames_stop })
    --ReportTable(self.keynames)

    self.call_order = this.GetCallOrder
    ({
        { self.const.bindings.grapple1, self.keynames_1 },
        { self.const.bindings.grapple2, self.keynames_2 },
        { self.const.bindings.grapple3, self.keynames_3 },
        { self.const.bindings.grapple4, self.keynames_4 },
        { self.const.bindings.grapple5, self.keynames_5 },
        { self.const.bindings.grapple6, self.keynames_6 },
        { self.const.bindings.stop, self.keynames_stop },
    })
end

-- This forgets that keys were pressed down.  Call this after an action is started so this class
-- won't keep saying to start actions (forces the user to let go of the keys and repress them)
function InputTracker_StartStop:ResetKeyDowns(remember_current)
    if remember_current then
        self:RememberCurrentForHeld()
    end

    for key, _ in pairs(self.downTimes) do
        self.downTimes[key] = nil
    end
end

-- Returns binding enum tied to the keys that the user pressed (or nil)
--NOTE: The user must press the keys at roughly the same time, or this function will ignore them
function InputTracker_StartStop:GetRequestedAction()
    for i = 1, #self.call_order do
        if self:IsDown(self.call_order[i][2]) then
            return self.call_order[i][1]
        end
    end

    return nil
end

function InputTracker_StartStop:IsPrevActionHeldDown()
    return self.held_names ~= nil
end

function InputTracker_StartStop:GetActionNames(binding)
    for i = 1, #self.call_order do
        if self.call_order[i][1] == binding then
            return self.call_order[i][2]
        end
    end

    return nil
end

function InputTracker_StartStop:GetMaxElapsedTime()
    return self.max_elapsed
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

function InputTracker_StartStop:RememberCurrentForHeld()
    self.held_names = nil       -- likely already nil, but just being safe

    local action = self:GetRequestedAction()
    if not action then
        do return end
    end

    for i = 1, #self.call_order do
        if self.call_order[i][1] == action then
            self.held_names = self.call_order[i][2]
        end
    end
end

function this.GetDeduped(jagged)
    -- Store all the actionnames in deduper as keys, and it will auto dedupe
    local deduper = {}

    for i=1, #jagged do
        if jagged[i] then       -- there can be unassigned bindings
            for j=1, #jagged[i] do
                deduper[jagged[i][j]] = 1        -- the value doesn't matter, only interested in the key
            end
        end
    end

    -- Now commit those keys to an int indexed array
    local deduped = {}

    for key, _ in pairs(deduper) do
        deduped[#deduped+1] = key
    end

    return deduped
end

-- This returns an array that is the non nil entries in jagged.  It is also sorted so that any entries that
-- are subsets are at the end of the list
--
-- Say you have a binding that is just "Q", another binding that is "Q + W".  Q+W needs to be looked for
-- first.  Otherwise, Q would return true before Q+W is ever looked at
function this.GetCallOrder(jagged)
    local retVal = {}

    for i = 1, #jagged do
        if jagged[i][2] then        -- jagged[i][1] is the binding enum
            local index = this.GetInsertIndex(retVal, jagged[i])

            Insert(retVal, jagged[i], index)
        end
    end

    return retVal
end

--NOTE: Each of these entries is {bindingEnum, actionNames}, so this function only cares about entry[2]
function this.GetInsertIndex(existing, entry)
    for i = 1, #existing do
        if Is_A_SubsetOf_B(existing[i][2], entry[2]) then
            -- This existing item is a subset of the new entry, so the new entry must be looked at before it
            return i
        end
    end

    -- It's safe to add this to the end of the list
    return #existing + 1
end