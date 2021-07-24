function Process_Hang(o, vars, const, debug, keys, startStopTracker)
    local isHangDown, isJumpDown = startStopTracker:GetButtonState()
    if not isHangDown then
        Transition_ToStandard(vars, const, debug, o)
        do return end

    elseif isJumpDown then
        Transition_ToJump(vars, const, o, vars.hangPos, vars.normal, vars.material)
        do return end
    end

    local deltaYaw = keys.mouse_x * -0.08

    local yaw = AddYaw(o.yaw, deltaYaw)

    --TODO: Don't perfectly hold this position
    --
    -- When first entering hang, move in the direction of
    -- their prev velocity and ease into a stop (over a very short distance, but still more than
    -- an instant stop)
    --
    -- Also, the final resting position should be slightly lower than the initial hang position.
    -- This will give a sense of weight to the player
    --
    -- Then slowly drift around randomly.  Mostly in the plane of the wall, but a little off the
    -- wall (like a really flat ellipsoid)

    o:Teleport(vars.hangPos, yaw)
end