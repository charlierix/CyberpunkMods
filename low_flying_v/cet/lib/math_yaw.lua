-- These are in world coords
--  0, 1   ..  -0
--  1, 0   ..  -90
--  0, -1  ..  -180
--
--  -0, 1   ..  0
--  -1, 0   ..  90
--  -0, -1  ..  180
function Yaw_to_Vect(yaw)
    -- Convert cyberpunk yaw into an angle that lua likes
    if (yaw >= 90) and (yaw < 180) then
        yaw = yaw - 360
    end

    yaw = yaw + 90

    -- Convert to radians
    yaw = yaw * math.pi / 180

    return math.cos(yaw), math.sin(yaw)
end
function Vect_to_Yaw(x, y)
    local angle = math.atan(y, x) * 180 / math.pi

    angle = angle - 90

    if (angle >= -270) and (angle < -180) then
        angle = angle + 360
    end

    return angle
end

-- The way yaw wraps is weird. -179 wraps over to 179
-- So 185 becomes -175
-- -185 becomes 175
function AddYaw(yaw, addAngle)
    local retVal = yaw + addAngle

    if retVal < -180 then
        retVal = 180 + (retVal + 180)
    elseif retVal > 180 then
        retVal = -180 + (retVal - 180)
    end

    return retVal
end