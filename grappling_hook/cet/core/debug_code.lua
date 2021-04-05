function PopulateDebug(debug, o, keys, state)
    debug.flightMode = state.flightMode
    debug.currentlyFlying = o:Custom_CurrentlyFlying_get()

    debug.isSafetyFireCandidate = state.isSafetyFireCandidate

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

    -- for key, value in pairs(keys.actions) do
    --     debug["cur_" .. key] = value
    -- end

    -- for key, value in pairs(keys.prev_actions) do
    --     debug["prev_" .. key] = value
    -- end

    -- for key, value in pairs(state.startStopTracker.downTimes) do
    --     debug["down_" .. key] = value
    -- end

    -- debug.should_stop = state.startStopTracker:ShouldStop()

    -- local shouldPull, shouldRigid = state.startStopTracker:ShouldGrapple()
    -- debug.should_pull = shouldPull
    -- debug.should_rigid = shouldRigid


    debug.timer = Round(o.timer, 1)
end
