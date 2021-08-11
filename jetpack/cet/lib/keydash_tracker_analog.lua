KeyDashTracker_Analog = {}

-- The only thing needed from this class is whether they are dashing.  That involves:
--  length < 20% transition to length > 80%
--  initial > 80% direction and dot product with that
--
-- It should fall out of dashing if they swivel the stick too quickly, so:
--  initial dash will be some direction
--  each frame, drag that direction to toward the new direction
--  as long as dot never exceeds a threshold, they'll stay in dash


function KeyDashTracker_Analog:new(o, keys)
    local obj = { }
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.keys = keys

    obj.analog_x = 0
    obj.analog_y = 0

    obj.analog_len = 0

    obj.isDashing = false

    return obj
end

function KeyDashTracker_Analog:Tick()
    self.analog_x = self.keys.analog_x
    self.analog_y = self.keys.analog_y

    local lenSqr = GetVectorLength2DSqr(self.analog_x, self.analog_y)
    if IsNearZero(lenSqr) then
        self.analog_len = 0
    else
        self.analog_len = math.sqrt(lenSqr)
    end
end