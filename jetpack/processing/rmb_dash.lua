------------------------- Interface -------------------------
-- All derived right mouse button classes require this same interface

-- Velocity has to be passed in, because it's stored differently between redscript and cet flight
-- NOTE: Can't return 0 energy if nonzero accelerations are returned, or the calling function will ignore them

-- function RMB_:Description()
--     return "quick description"

-- function RMB_:Tick(o, vel, keys, vars)
--     return accelX, accelY, accelZ, requestedEnergy
-------------------------------------------------------------

RMB_Dash = {}

function RMB_Dash:new(acceleration, burnRate, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.rmb_type = const.rmb_type.dash
    obj.acceleration = acceleration
    obj.burnRate = burnRate

    return obj
end

function RMB_Dash:Description()
    return "dash"
end

function RMB_Dash:Tick(o, vel, keys, vars)
    if not keys.rmb then
        return 0, 0, 0, 0
    end

    o:GetCamera()
    if not o.lookdir_forward then
        return 0, 0, 0, 0
    end

    return
        o.lookdir_forward.x * self.acceleration,        -- look direction is a unit vector, so the multiplication is easy
        o.lookdir_forward.y * self.acceleration,
        o.lookdir_forward.z * self.acceleration,
        self.burnRate
end
