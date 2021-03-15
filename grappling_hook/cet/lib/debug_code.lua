function PopulateDebug(debug, o, keys, state)
    debug.inFlight = state.isInFlight
    -- debug.inFlight_c = o:Get_Custom_IsFlying()

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

    debug.isDown_grapple = state.grappleStartTracker.isDown_grapple
    debug.isDown_polevault = state.grappleStartTracker.isDown_polevault
    debug.isDown_swing = state.grappleStartTracker.isDown_swing

    debug.timer = Round(o.timer, 1)
end
