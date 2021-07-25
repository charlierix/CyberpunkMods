function PopulateDebug(debug, o, keys, vars, startStopTracker)
    debug.flightMode = vars.flightMode
    debug.currentlyFlying = o:Custom_CurrentlyFlying_get()

    -- debug.pos = vec_str(o.pos)
    -- debug.vel = vec_str(o.vel)
    --debug.yaw = Round(o.yaw, 0)

    -- if o.vel then
    --     debug.speed = tostring(Round(GetVectorLength(o.vel), 1))
    -- end

    -- debug.key_forward = keys.forward
    -- debug.key_backward = keys.backward
    -- debug.key_left = keys.left
    -- debug.key_right = keys.right
    -- debug.key_jump = keys.jump
    --debug.key_hang = keys.hang
    --debug.key_custom = keys.custom
    -- debug.mouse_x = keys.mouse_x

    -- local isHangDown, isJumpDown = startStopTracker:GetButtonState()
    -- debug.tracked_isHangDown = isHangDown
    -- debug.tracked_isJumpDown = isJumpDown

    --debug.isAirborne = IsAirborne(o)

    -- debug.hang_hangPos = vec_str(vars.hangPos)
    -- debug.hang_normal = vec_str(vars.normal)
    -- debug.hang_material = vars.material

    -- o:GetCamera()
    -- if o.lookdir_forward then
    --     local yaw_calc = Vect_to_Yaw(o.lookdir_forward.x, o.lookdir_forward.y)      ------- flawed
    --     debug.yaw_calc = Round(yaw_calc, 1)
    --     debug.yaw_direct = Round(o.yaw, 1)

    --     local x, y = Yaw_to_Vect(o.yaw)
    --     debug.zlook_calc = Round(x, 2) .. ", " .. Round(y, 2)

    --     local len = Get2DLength(o.lookdir_forward.x, o.lookdir_forward.y)
    --     debug.zlook_direct = Round(o.lookdir_forward.x / len, 2) .. ", " .. Round(o.lookdir_forward.y / len, 2)
    -- end

    debug.timer = Round(o.timer, 1)
end