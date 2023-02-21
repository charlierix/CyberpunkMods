local this = {}

function PopulateDebug(debug, o, keys, vars, startStopTracker)
    debug.flightMode = vars.flightMode

    local quest = Game.GetQuestsSystem()
    debug.mutlmod_Current = quest:GetFactStr("custom_currentlyFlying_current")
    debug.mutlmod_Vel = this.GetMultiModVelocity(quest)
    debug.mutlmod_IsOwnerOrNone = o:Custom_CurrentlyFlying_IsOwnerOrNone()
    debug.mutlmod_CanStartFlight = o:Custom_CurrentlyFlying_CanStartFlight()

    -- debug.pos = vec_str(o.pos)
    -- debug.vel = vec_str(o.vel)
    -- debug.yaw = Round(o.yaw, 0)

    if o.vel then
        debug.speed = tostring(Round(GetVectorLength(o.vel), 1))
    end

    -- debug.key_forward = keys.forward
    -- debug.key_backward = keys.backward
    -- debug.key_left = keys.left
    -- debug.key_right = keys.right
    -- debug.key_jump = keys.jump
    -- debug.key_hang = keys.hang
    -- debug.key_prev_hang = keys.prev_hang
    -- debug.key_custom = keys.custom
    -- debug.key_custom_hang = keys.custom_hang
    -- debug.key_prev_custom_hang = keys.prev_custom_hang
    debug.hang_latched = startStopTracker.hang_latched
    -- debug.mouse_x = keys.mouse_x

    local isHangDown, isJumpDown, isShiftDown = startStopTracker:GetButtonState()
    debug.tracked_isHangDown = isHangDown
    debug.tracked_isJumpDown = isJumpDown
    debug.tracked_isShiftDown = isShiftDown

    debug.isAirborne = IsAirborne(o)

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

    --     local len = GetVectorLength2D(o.lookdir_forward.x, o.lookdir_forward.y)
    --     debug.zlook_direct = Round(o.lookdir_forward.x / len, 2) .. ", " .. Round(o.lookdir_forward.y / len, 2)
    -- end

    debug.timer = Round(o.timer, 1)
end

-- copy of multimod_flight.GetStartingVelocity
function this.GetMultiModVelocity(quest)
    local x = quest:GetFactStr("custom_currentlyFlying_velX")
    local y = quest:GetFactStr("custom_currentlyFlying_velY")
    local z = quest:GetFactStr("custom_currentlyFlying_velZ")

    if (not x or x == 0) and (not y or y == 0) and (not z or z == 0) then       -- the quest fact comes back as zero when there is no entry
        return "empty"
    end

    -- since default is zero, a known offset is added to the result to make zero velocity store as non zero
    -- since it's an integer, the velocity is multiplied by 100
    x = (x - 1234567) / 100
    y = (y - 1234567) / 100
    z = (z - 1234567) / 100

    return tostring(x) .. ", " .. tostring(y) .. ", " .. tostring(z)
end