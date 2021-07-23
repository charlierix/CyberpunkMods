function Process_Hang(o, vars, const, debug, keys, startStopTracker)

    --TODO: Check for other mods

    local isHangDown, isJumpDown = startStopTracker:GetButtonState()
    if not isHangDown then
        Transition_ToStandard(vars, const, debug, o)
        do return end

    elseif isJumpDown then

        print("TODO: Implement Jump")
        Transition_ToStandard(vars, const, debug, o)

        do return end
    end


    local deltaYaw = keys.mouse_x * -0.08

    local yaw = AddYaw(o.yaw, deltaYaw)

    o:Teleport(vars.hangPos, yaw)
end