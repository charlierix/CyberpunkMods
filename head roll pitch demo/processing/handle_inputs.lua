function HandleInputs(vars, keys, const, deltaTime)
    -- Roll
    if keys.roll_left then
        vars.roll_desired = AddAngle_neg180_pos180(vars.roll_desired, -const.turn_rate * deltaTime)
    end

    if keys.roll_right then
        vars.roll_desired = AddAngle_neg180_pos180(vars.roll_desired, const.turn_rate * deltaTime)
    end

    -- Pitch
    if keys.pitch_down then
        vars.pitch_desired = AddAngle_neg180_pos180(vars.pitch_desired, -const.turn_rate * deltaTime)
    end

    if keys.pitch_up then
        vars.pitch_desired = AddAngle_neg180_pos180(vars.pitch_desired, const.turn_rate * deltaTime)
    end

    -- Yaw
    if keys.yaw_left then
        vars.yaw_desired = AddAngle_neg180_pos180(vars.yaw_desired, -const.turn_rate * deltaTime)
    end

    if keys.yaw_right then
        vars.yaw_desired = AddAngle_neg180_pos180(vars.yaw_desired, const.turn_rate * deltaTime)
    end
end