function PopulateDebug(debug, o, keys, vars)
    debug.flightMode = vars.flightMode
    debug.currentlyFlying = o:Custom_CurrentlyFlying_get()

    debug.pos = vec_str(o.pos)
    debug.vel = vec_str(o.vel)
    --debug.yaw = Round(o.yaw, 0)

    if o.vel then
        debug.speed = tostring(Round(GetVectorLength(o.vel), 1))
    end

    -- debug.key_forward = keys.forward
    -- debug.key_backward = keys.backward
    -- debug.key_left = keys.left
    -- debug.key_right = keys.right
    -- debug.key_jump = keys.jump
    -- debug.key_rmb = keys.rmb
    -- debug.mouse_x = keys.mouse_x


    debug.timer = Round(o.timer, 1)

    --debug.inMenu = IsPlayerInAnyMenu()
end
