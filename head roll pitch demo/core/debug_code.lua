function PopulateDebug(debug, o, keys, vars)
    debug.roll_desired = Round(vars.roll_desired, 1)
    debug.roll_actual = Round(vars.roll_actual, 1)

    debug.timer = Round(o.timer, 1)
end