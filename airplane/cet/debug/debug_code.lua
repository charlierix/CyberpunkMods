function PopulateDebug(debug, o, keys, vars, startStopTracker)
    debug.flightMode = vars.flightMode
    debug.currentlyFlying = o:Custom_CurrentlyFlying_get()

    -- debug.pos = vec_str(o.pos)
    -- debug.vel = vec_str(o.vel)
    -- debug.yaw = Round(o.yaw, 0)

    -- if o.vel then
    --     debug.speed = tostring(Round(GetVectorLength(o.vel), 1))
    -- end

    -- debug.key_forward = keys.forward
    -- debug.key_backward = keys.backward
    -- debug.key_left = keys.left
    -- debug.key_right = keys.right
    -- debug.mouse_x = keys.mouse_x
    -- debug.mouse_y = keys.mouse_y

    -- debug.isAirborne = IsAirborne(o)

    debug.timer = Round(o.timer, 1)
end