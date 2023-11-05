------------------------- Interface -------------------------
-- All derived extra classes require this same interface

-- Velocity has to be passed in, because it's stored differently between impulse and teleport based flight
-- NOTE: Can't return 0 energy if nonzero accelerations are returned, or the calling function will ignore them

-- function Extra_:Description()
--     return "quick description"

-- function Extra_:Tick(o, vel, keys, vars)
--     return accelX, accelY, accelZ, requestedEnergy
-------------------------------------------------------------

Extra_Dash = {}

function Extra_Dash:new(acceleration, burnRate, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.extra_type = const.extra_type.dash
    obj.acceleration = acceleration
    obj.burnRate = burnRate

    return obj
end

function Extra_Dash:Description()
    return "dash"
end

function Extra_Dash:Tick(o, vel, keys, vars)
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
