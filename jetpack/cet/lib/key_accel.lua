local this = {}

-- This returns accelerations from direct keyboard inputs
function GetAccel_Keys(vars, mode, o, debug)
    --vars.thrust:Tick()       -- this was already done in init.lua
    vars.horz_analog:Tick()

    local accel_up, energyUp = this.CalculateAccel(vars.thrust.isDown, vars.thrust.isDashing, mode.accel_vert_stand, mode.accel_vert_dash, 1, mode.burnRate_dash)

    local accel_x, accel_y, energyHorz = this.CalculateAccel_Analog(vars.horz_analog.analog_x, vars.horz_analog.analog_y, vars.horz_analog.analog_len, vars.horz_analog.isDashing, mode.accel_horz_stand, mode.accel_horz_dash, mode.burnRate_horz, mode.burnRate_horz * mode.burnRate_dash)

    -- Map into world coords
    local accelX, accelY = this.ConvertAccelToWorld(accel_y, accel_x, o)
    --local accelZ = accel_up     -- accel_up is already in world coords

    local requestedEnergy = energyUp + energyHorz

    return accelX, accelY, accel_up, requestedEnergy
end

---------------------------------- Private Functions ----------------------------------

-- Calculates the acceleration in the desired direction
--
-- NOTE: The calculations are independent of deltaTime.  They are assumed for an entire second.  The returned
-- values will need to be multiplied by deltaTime to get the actual amount in the current tick
--
-- Params:
--      isDown: is the key currently held down
--      isDashing: is dashing in this direction
--      accel_stand: how much to accelerate if burning at standard rate
--      accel_dash: how much to accelerate if dashing
--      burnRate_stand: how much energy to use if standard
--      burnRate_dash: how much energy to use if dashing
-- Returns:
--      accel: how much acceleration to apply
--      energyUsed: how much energy was consumed
function this.CalculateAccel(isDown, isDashing, accel_stand, accel_dash, burnRate_stand, burnRate_dash)
    if not isDown then
        return 0, 0
    end

    if isDashing then
        return accel_dash, burnRate_dash
    else
        return accel_stand, burnRate_stand
    end
end

-- Copy of the scalar, but deals with 2D vector instead
-- The other deals with keyboard input, simple boolean for pressed or not.  This handles thumbstick input (analog
-- 2D)
--
-- NOTE: It is expected that the analog input's max length is 1, so it's just being treated like a percent by this
-- function
--
-- Returns:
--      accel_x: negative is left, positive is right
--      accel_y: negative is backward, positive is forward
--      energyUsed
function this.CalculateAccel_Analog(analog_x, analog_y, analog_len, isDashing, accel_stand, accel_dash, burnRate_stand, burnRate_dash)
    if IsNearZero(analog_len) then
        return 0, 0, 0
    end

    local accel = accel_stand
    local burnrate = burnRate_stand
    if isDashing then
        accel = accel_dash
        burnrate = burnRate_dash
    end

    return
        analog_x * accel,
        analog_y * accel,
        analog_len * burnrate
end

-- accel_forward is W-S, accel_right is D-A.  Which are in model coords
-- Turn those into world coords
function this.ConvertAccelToWorld(accel_forward, accel_right, o)
    o:GetCamera()

    local lookForward = Make2DUnit(o.lookdir_forward)
    local lookRight = Make2DUnit(o.lookdir_right)

    local accelX = (lookForward.x * accel_forward) + (lookRight.x * accel_right)
    local accelY = (lookForward.y * accel_forward) + (lookRight.y * accel_right)

    return accelX, accelY
end
