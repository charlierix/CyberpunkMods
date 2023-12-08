------------------------- Interface -------------------------
-- All derived extra classes require this same interface

-- Velocity has to be passed in, because it's stored differently between impulse and teleport based flight
-- NOTE: Can't return 0 energy if nonzero accelerations are returned, or the calling function will ignore them

-- function Extra_:Description()
--     return "quick description"

-- function Extra_:Tick(o, vel, keys, vars, deltaTime)
--     return accelX, accelY, accelZ, requestedEnergy
-------------------------------------------------------------

Extra_Hover = {}

local this = {}

function Extra_Hover:new(key, mult, accel_up, accel_down, burnRate, holdDuration, useImpulse, gravity, sounds_thrusting, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.extra_type = const.extra_type.hover

    obj.key = key

    obj.mult = mult

    obj.accel_up_ORIG = accel_up
    obj.accel_up = mode_defaults.ImpulseGravityAdjust_ToMode(useImpulse, gravity, accel_up)

    obj.accel_down = accel_down
    obj.burnRate = burnRate

    obj.gravity = gravity

    obj.sounds_thrusting = sounds_thrusting

    obj.holdAltitude = 0
    obj.buttonLastDownTime = -holdDuration
    obj.holdDuration = holdDuration

    return obj
end

function Extra_Hover:Description()
    return "hover"
end

function Extra_Hover:Tick(o, vel, keys, vars, deltaTime)
    if keys.jump then
        self.buttonLastDownTime = -self.holdDuration      -- pressing jump needs to turn off cruise control
        self.sounds_thrusting:StopHover()

    elseif keys[self.key] then
        self.buttonLastDownTime = o.timer
        self.sounds_thrusting:StartHover()
    end

    if (o.timer - self.buttonLastDownTime) > self.holdDuration then
        return 0, 0, 0, 0
    end

    -- Initial press down
    if keys[self.key] and not keys["prev_" .. self.key] then
        self.holdAltitude = o.pos.z
    end

    -- Above or below desired altitude
    local offset = -self.gravity / self.mult        -- need to target above the hold altitude, because at a distance of gravity below is where the forces zero out
    local diff = self.holdAltitude + offset - o.pos.z

    -- Get accelerations
    local standard = this.GetStandardAccel(diff, self.mult, self.accel_up, self.accel_down)
    local velAdjust = this.GetVelocityAccel(vel, diff, self.mult, self.accel_up, self.accel_down)

    return 0, 0, standard + velAdjust, self.burnRate
end

----------------------------------- Private Methods -----------------------------------

function this.GetStandardAccel(diff, mult, accel_up, accel_down)
    -- Scale diff to be an acceleration
    local accel = diff * mult

    -- Cap acceleration
    local max = 999
    if accel > 0 then
        max = accel_up
    else
        max = accel_down
    end

    if math.abs(accel) > max then
        accel = (accel / math.abs(accel)) * max
    end

    return accel
end

function this.GetVelocityAccel(vel, diff, mult, accel_up, accel_down)
    --NOTE: diff is desired-pos, so is negative when above plane, positive when below plane.  Think of it
    --as the acceleration needed to get back to the plane
    if (diff < 0 and vel.z < 0) or (diff > 0 and vel.z > 0) then
        -- Above the plane and going down (or below and going up).  Doesn't need extra help
        return 0
    end

    local mockDiff = diff * math.abs(vel.z * 4)

    local accel = this.GetStandardAccel(mockDiff, mult, accel_up, accel_down)

    --print("diff="..tostring(Round(diff,2)) .." | ".. "vel="..tostring(Round(vel.z,2)) .." | ".. "mockDiff="..tostring(Round(mockDiff,2)) .." | ".. "accel="..tostring(Round(accel,2)))

    return accel
end