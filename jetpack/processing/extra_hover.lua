------------------------- Interface -------------------------
-- All derived extra classes require this same interface

-- Velocity has to be passed in, because it's stored differently between impulse and teleport based flight
-- NOTE: Can't return 0 energy if nonzero accelerations are returned, or the calling function will ignore them

-- function Extra_:Description()
--     return "quick description"

-- function Extra_:Tick(o, vel, keys, vars)
--     return accelX, accelY, accelZ, requestedEnergy
-------------------------------------------------------------

Extra_Hover = {}

function Extra_Hover:new(mult, accel_up, accel_down, burnRate, holdDuration, useImpulse, gravity, sounds_thrusting, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.extra_type = const.extra_type.hover

    obj.sounds_thrusting = sounds_thrusting

    local extraUp = 0
    if useImpulse then
        extraUp = 16 + gravity      -- The vertical accelerations need to defeat gravity.  If gravity is 16, then this is zero.  If gravity is higher, then this is some negative amount
    end

    obj.mult = mult

    obj.accel_up_ORIG = accel_up
    obj.accel_up = accel_up + extraUp

    obj.accel_down = accel_down
    obj.burnRate = burnRate

    obj.holdAltitude = 0
    obj.buttonLastDownTime = -holdDuration
    obj.holdDuration = holdDuration

    return obj
end

function Extra_Hover:Description()
    return "hover"
end

function Extra_Hover:Tick(o, vel, keys, vars)
    if keys.jump then
        self.buttonLastDownTime = -self.holdDuration      -- pressing jump needs to turn off cruise control
        self.sounds_thrusting:StopHover()

    elseif keys.rmb then
        self.buttonLastDownTime = o.timer
        self.sounds_thrusting:StartHover()
    end

    if (o.timer - self.buttonLastDownTime) > self.holdDuration then
        return 0, 0, 0, 0
    end

    -- Initial press down
    if keys.rmb and not keys.prev_rmb then
        self.holdAltitude = o.pos.z
    end

    -- Above or below desired altitude
    local diff = self.holdAltitude - o.pos.z

    -- Get accelerations
    local standard = self:GetStandardAccel(diff)
    local velAdjust = self:GetVelocityAccel(vel, diff)

    return 0, 0, standard + velAdjust, self.burnRate
end

function Extra_Hover:GetStandardAccel(diff)
    -- Scale diff to be an acceleration
    local accel = diff * self.mult

    -- Cap acceleration
    local max = 999
    if accel > 0 then
        max = self.accel_up
    else
        max = self.accel_down
    end

    if math.abs(accel) > max then
        accel = (accel / math.abs(accel)) * max
    end

    return accel
end

function Extra_Hover:GetVelocityAccel(vel, diff)
    --NOTE: diff is desired-pos, so is negative when above plane, positive when below plane.  Think of it
    --as the acceleration needed to get back to the plane
    if (diff < 0 and vel.z < 0) or (diff > 0 and vel.z > 0) then
        -- Above the plane and going down (or below and going up).  Doesn't need extra help
        return 0
    end

    local mockDiff = diff * math.abs(vel.z * 4)

    local accel = self:GetStandardAccel(mockDiff)

    --print("diff="..tostring(Round(diff,2)) .." | ".. "vel="..tostring(Round(vel.z,2)) .." | ".. "mockDiff="..tostring(Round(mockDiff,2)) .." | ".. "accel="..tostring(Round(accel,2)))

    return accel
end