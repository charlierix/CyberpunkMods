function KeyboardFlight(keys, lookDir, rightDir, const, startFlightTime, timer, vel)
    local x = 0
    local y = 0
    local z = 0
    local yaw = 0

    -- Flight just started.  Give them a couple seconds, because they're probably still spamming keys
    if timer - startFlightTime < 1 then
        return x, y, z, yaw
    end

    if keys.analog_y > 0 then
        x = x + (lookDir.x * const.accel_forward * keys.analog_y)
        y = y + (lookDir.y * const.accel_forward * keys.analog_y)
        z = z + (lookDir.z * const.accel_forward * keys.analog_y)
    end

    if keys.analog_y < 0 then
        x = x - (lookDir.x * const.accel_backward * -keys.analog_y)
        y = y - (lookDir.y * const.accel_backward * -keys.analog_y)
        --z = z - (lookDir.z * const.accel_backward * -keys.analog_y)        -- just let them fall
    end

    if keys.jump then
        z = z + const.accel_jump
    end

    if keys.analog_x < 0 then
        x = x - (rightDir.x * const.accel_side * -keys.analog_x)
        y = y - (rightDir.y * const.accel_side * -keys.analog_x)
        z = z - (rightDir.z * const.accel_side * -keys.analog_x)
        if const.should_yaw_turn then
            yaw = yaw + KeyboardFlight_YawTurn(const.yaw_turn_min, const.yaw_turn_max, vel)
        end
    end

    if keys.analog_x > 0 then
        x = x + (rightDir.x * const.accel_side * keys.analog_x)
        y = y + (rightDir.y * const.accel_side * keys.analog_x)
        z = z + (rightDir.z * const.accel_side * keys.analog_x)
        if const.should_yaw_turn then
            yaw = yaw - KeyboardFlight_YawTurn(const.yaw_turn_min, const.yaw_turn_max, vel)
        end
    end

    yaw = yaw + keys.mouse_x * const.mouse_sensitivity

    return x, y, z, yaw
end

-- This adjusts the amount of turn based on speed.  At low speed, turn should be more
function KeyboardFlight_YawTurn(min, max, vel)
    local speedSqr = GetVectorLengthSqr(vel)

    if speedSqr <= (30 * 30) then
        return min
    elseif speedSqr >= (60 * 60) then
        return max
    end

    return GetScaledValue(min, max, 30, 60, math.sqrt(speedSqr))
end

-- This brings the velocity in line with direction facing (and vice versa)
function RotateVelocity_Horizontal(o, vars, const, deltaTime)
    -- Get the angle difference
    local rad = RotateVelocity_Horizontal_GetRad(o.lookdir_forward, vars.vel)

    -- Some events need to make the camera swivel toward velocity more quickly
    local percent_towardCamera, percent_towardVelocity = RotateVelocity_Horizontal_QuickSwivel(const, vars.quickSwivel_startTime, o.timer)

    -- Do the rotations
    return RotateVelocity_Horizontal_DoIt(vars.vel, rad, percent_towardCamera, percent_towardVelocity, deltaTime)
end

function RotateVelocity_Horizontal_GetRad(dirFacing, vel)
    local rad = RadiansBetween2D(dirFacing.x, dirFacing.y, vel.x, vel.y)
    if CrossProduct2D(dirFacing.x, dirFacing.y, vel.x, vel.y) < 0 then
        rad = -rad
    end

    return rad
end

function RotateVelocity_Horizontal_QuickSwivel(const, quickSwivel_startTime, timer)
    local percent_towardCamera = const.percent_towardCamera_horz
    local percent_towardVelocity = const.percent_towardVelocity_horz

    local duration = (timer - quickSwivel_startTime)

    if duration > const.quickSwivel_duration then
        return percent_towardCamera, percent_towardVelocity
    end

    -- This will use the quick swivel values for most of the duration, then smoothly transition
    -- to using the standard values
    local percentExisting = (duration / const.quickSwivel_duration) ^ 12

    percent_towardCamera = GetScaledValue(0, percent_towardCamera, 0, 1, percentExisting)
    percent_towardVelocity = GetScaledValue(const.quickSwivel_percent_towardVelocity, percent_towardVelocity, 0, 1, percentExisting)

    return percent_towardCamera, percent_towardVelocity
end

function RotateVelocity_Horizontal_DoIt(vel, rad, percent_towardCamera, percent_towardVelocity, deltaTime)
    -- Pull velocity toward camera
    local velX, velY = RotateVector2D(vel.x, vel.y, -rad * percent_towardCamera * deltaTime)
    vel.x = velX
    vel.y = velY

    -- The actual player rotation will happen during the position teleport, so return
    -- the delta
    local deltaYaw = rad * percent_towardVelocity * deltaTime
    deltaYaw = deltaYaw * 180 / math.pi

    return deltaYaw
end

-- Up/Down look direction can't be changed, so this only modifies velocity
function RotateVelocity_Vertical(dirFacing, vel, percent_towardCamera, deltaTime)
    local rad = RadiansBetween2D(dirFacing.y, dirFacing.z, vel.y, vel.z)
    if CrossProduct2D(dirFacing.y, dirFacing.z, vel.y, vel.z) < 0 then
        rad = -rad
    end

    -- Pull velocity toward camera
    local velY, velZ = RotateVector2D(vel.y, vel.z, -rad * percent_towardCamera * deltaTime)
    vel.y = velY
    vel.z = velZ
end