-- Just keeps teleporting to the initial catch point
function Process_Hang(o, vars, const, debug, keys, startStopTracker)
    local isHangDown, isJumpDown = startStopTracker:GetButtonState()
    if not isHangDown then
        Transition_ToStandard(vars, const, debug, o)
        do return end

    elseif isJumpDown then
        Transition_ToJump_Calculate(vars, const, o, vars.hangPos, vars.normal)
        do return end
    end

    local deltaYaw = keys.mouse_x * const.mouse_sensitivity

    local yaw = AddYaw(o.yaw, deltaYaw)

    o:Teleport(vars.hangPos, yaw)
end