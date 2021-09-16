function HandleInputs(vars, keys, const, deltaTime)
    if keys.roll_left then
        vars.roll_desired = AddAngle_neg180_pos180(vars.roll_desired, -const.roll_rate * deltaTime)
    end

    if keys.roll_right then
        vars.roll_desired = AddAngle_neg180_pos180(vars.roll_desired, const.roll_rate * deltaTime)
    end
end