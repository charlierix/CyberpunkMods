--TODO: Rewrite this.  Get rid of swing, so it's a grapple_forward and grapple_static
--each action should take an array of keys to watch



-- This keeps track of a few buttons and stores true if certain combinations are pressed down
-- within a small window of time (considered to be simultaneously pressed)
--
-- Not hardcoding to ASDW, so that people with controllers could map different buttons.  For
-- example, they want to map grapple to (ps: triangle+circle || square+X) (xbox: Y+B || X+A).
-- Or people may just want a single dedicated button for grapple

GrappleStartInputTracker = {}

function GrappleStartInputTracker:new(o, keys, keyname1, keyname2, keyname_polevault, keyname_swing)
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    local prev = "prev_"

    -- This is the longest time distance for multiple keydowns to be considered simultaneous
    obj.max_elapsed = 0.06

    obj.o = o
    obj.keys = keys

    obj.keyname1 = keyname1
    obj.prevkeyname1 = prev .. keyname1

    -- keyname2 could be nil (if they want to use a dedicated button instead of two at the same time)
    obj.keyname2 = keyname2
    if keyname2 then
        obj.prevkeyname2 = prev .. keyname2
    end

    obj.keyname_polevault = keyname_polevault
    obj.prevkeyname_polevault = prev .. keyname_polevault

    obj.keyname_swing = keyname_swing
    obj.prevkeyname_swing = prev .. keyname_swing

    -- nil isn't actually stored
    --obj.downTime1 = nil
    --obj.downTime2 = nil
    --obj.downTimePoleVault = nil
    --obj.downTimeSwing = nil

    -- These will get updated after calling Tick()
    -- Only one will be true (not sure how to do enums in lua)
    obj.isDown_grapple = false
    obj.isDown_polevault = false
    obj.isDown_swing = false

    return obj
end

function GrappleStartInputTracker:Tick()
    self:StoreDownTime("keyname1", "prevkeyname1", "downTime1")
    self:StoreDownTime("keyname2", "prevkeyname2", "downTime2")
    self:StoreDownTime("keyname_polevault", "prevkeyname_polevault", "downTimePoleVault")
    self:StoreDownTime("keyname_swing", "prevkeyname_swing", "downTimeSwing")

    self.isDown_grapple = false
    self.isDown_polevault = false
    self.isDown_swing = false

    if not self:IsDown_Grapple() then
        do return end
    end

    -- At least grapple is true, see if it's one of the special cases

    if self:IsDown_Special("downTimePoleVault") then
        -- Grapple + PoleVault keys pressed
        self.isDown_polevault = true
    elseif self:IsDown_Special("downTimeSwing") then
        -- Grapple + Swing keys pressed
        self.isDown_swing = true
    else
        -- None of the special cases, so standard grapple
        self.isDown_grapple = true
    end
end

-------------------------- Private Methods --------------------------
function GrappleStartInputTracker:StoreDownTime(name, prev, time)
    if self[name] then      -- only self.keyname2 can be nil, but this method is generic
        if self.keys[self[name]] and (not self.keys[self[prev]]) then
            -- Key was just pressed down, store the time            
            self[time] = self.o.timer
        elseif not self.keys[self[name]] then
            -- Key is no longer being pressed down
            self[time] = nil
        end
    end
end

function GrappleStartInputTracker:IsDown_Grapple()
    if not self.downTime1 then
        -- The button isn't currently being held down
        return false
    end

    if not self.keyname2 then
        -- There's only one button for grapple
        return true
    end

    if not self.downTime2 then
        -- The second button isn't currently being held down
        return false
    end

    -- Both are held down, now see if they were pressed at nearly the same time
    return math.abs(self.downTime1 - self.downTime2) <= self.max_elapsed
end

--NOTE: Only call this if IsDown_Grapple returned true
function GrappleStartInputTracker:IsDown_Special(propName)
    if not self[propName] then
        -- The modifier key isn't currently pressed
        return false
    end

    if math.abs(self.downTime1 - self[propName]) > self.max_elapsed then
        -- They weren't pressed at the same time
        return false
    end

    if self.downTime2 and math.abs(self.downTime2 - self[propName]) > self.max_elapsed then
        -- They weren't pressed at the same time
        return false
    end

    -- All the keys were pressed at the same time
    return true
end
