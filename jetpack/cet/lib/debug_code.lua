local this = {}

function PopulateDebug(debug, o, keys, vars)
    debug.inFlight = vars.isInFlight

    local quest = Game.GetQuestsSystem()
    debug.mutlmod_Current = quest:GetFactStr("custom_currentlyFlying_current")
    debug.mutlmod_Vel = this.GetMultiModVelocity(quest)
    debug.mutlmod_IsOwnerOrNone = o:Custom_CurrentlyFlying_IsOwnerOrNone()
    debug.mutlmod_CanStartFlight = o:Custom_CurrentlyFlying_CanStartFlight()

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
    -- debug.mouse_x = Round(keys.mouse_x, 3)
    debug.analog_x = Round(keys.analog_x, 3)
    debug.analog_y = Round(keys.analog_y, 3)
    debug.analog_len = Round(GetVectorLength2D(keys.analog_x, keys.analog_y), 3)

    -- debug.thrust_isDown = vars.thrust.isDown
    -- debug.thrust_isDashing = vars.thrust.isDashing
    -- debug.thrust_downDuration = Round(vars.thrust.downDuration, 1)

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