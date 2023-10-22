KeyDashTracker = {}

local DASH_GAP = 0.27
local DASH_WAIT = 0.12

function KeyDashTracker:new(o, keys, keyname, prevkeyname)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.keys = keys
    obj.keyname = keyname
    obj.prevkeyname = prevkeyname

    obj.downTime = 0
    obj.prevDownTime = 0
    obj.started_on_ground = false

    -- These will get updated after calling Tick()
    obj.isDown = false
    obj.isDashing = false
    obj.downDuration = 0

    obj.clear_called = false        -- if this is true, then they need to release the jump and hold the jump in again to activate jetpack

    return obj
end

-- This will figure out if the current key is in one of these three states: up, down_standard, down_dashing
-- Returns:
--      bool isDown
--      bool isDashing (tapped the key, briefly released, then keeping the key held down)
--      num downDuration (how long the key has been held down)
function KeyDashTracker:Tick()
    -- Check for initial key down

    if self.keys[self.keyname] and (not self.keys[self.prevkeyname]) then      -- this only returns true when they first push the key down (all ticks after come back false as they are holding the key down)
        self.prevDownTime = self.downTime
        self.downTime = self.o.timer
        self.started_on_ground = not IsAirborne(self.o, false)
        self.clear_called = false
    end

    if not self.clear_called and self.keys[self.keyname] and self.o.timer >= self.downTime then        -- need to wait a tick for ImGui.IsKeyPressed to also return true
        local elapsedTimeDown = self.o.timer - self.downTime

        -- Don't want to allow too long of a gap between presses or it will see pulsing the thrusters as attempted dashing
        -- Once the dash is initiated, there's no need to wait very long to kick in the dash.  That's why the second time is less than the gap time
        local isDashing = ((self.downTime - self.prevDownTime) < DASH_GAP) and (elapsedTimeDown > DASH_WAIT)

        self.isDown = true
        self.isDashing = isDashing
        self.downDuration = elapsedTimeDown
    else
        self.isDown = false
        self.isDashing = false
        self.downDuration = 0
    end
end

function KeyDashTracker:Clear()
    self.isDown = false
    self.isDashing = false
    self.downDuration = 0
    self.clear_called = true
end