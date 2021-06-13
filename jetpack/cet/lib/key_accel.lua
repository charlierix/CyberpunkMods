-- This returns accelerations from direct keyboard inputs
function GetAccel_Keys(vars, mode, o)
    --vars.thrust:Tick()       -- this was already done in init.lua
    vars.left:Tick()
    vars.right:Tick()
    vars.forward:Tick()
    vars.backward:Tick()

    local accel_up, energyUp = CalculateAccel(vars.thrust.isDown, vars.thrust.isDashing, mode.accel_vert_stand, mode.accel_vert_dash, 1, mode.burnRate_dash)
    local accel_left, energyLeft = CalculateAccel(vars.left.isDown, vars.left.isDashing, mode.accel_horz_stand, mode.accel_horz_dash, mode.burnRate_horz, mode.burnRate_horz * mode.burnRate_dash)
    local accel_right, energyRight = CalculateAccel(vars.right.isDown, vars.rightisDashing, mode.accel_horz_stand, mode.accel_horz_dash, mode.burnRate_horz, mode.burnRate_horz * mode.burnRate_dash)
    local accel_forward, energyForward = CalculateAccel(vars.forward.isDown, vars.forward.isDashing, mode.accel_horz_stand, mode.accel_horz_dash, mode.burnRate_horz, mode.burnRate_horz * mode.burnRate_dash)
    local accel_backward, energyBackward = CalculateAccel(vars.backward.isDown, vars.backward.isDashing, mode.accel_horz_stand, mode.accel_horz_dash, mode.burnRate_horz, mode.burnRate_horz * mode.burnRate_dash)

    -- Map those into world coords
    local accelX, accelY = ConvertAccelToWorld(accel_forward - accel_backward, accel_right - accel_left, o)
    --local accelZ = accel_up     -- accel_up is already in world coords

    local requestedEnergy = energyUp + energyLeft + energyRight + energyForward + energyBackward        -- this will burn energy if they hold opposing keys at the same time, but that's excessive logic to detect

    return accelX, accelY, accel_up, requestedEnergy
end

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
function CalculateAccel(isDown, isDashing, accel_stand, accel_dash, burnRate_stand, burnRate_dash)
    if not isDown then
        return 0, 0
    end

    if isDashing then
        return accel_dash, burnRate_dash
    end

    return accel_stand, burnRate_stand
end

-- accel_forward is W-S, accel_right is D-A.  Which are in model coords
-- Turn those into world coords
function ConvertAccelToWorld(accel_forward, accel_right, o)
    o:GetCamera()

    local lookForward = Make2DUnit(o.lookdir_forward)
    local lookRight = Make2DUnit(o.lookdir_right)

    local accelX = (lookForward.x * accel_forward) + (lookRight.x * accel_right)
    local accelY = (lookForward.y * accel_forward) + (lookRight.y * accel_right)

    return accelX, accelY
end
