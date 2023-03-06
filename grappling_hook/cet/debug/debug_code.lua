local this = {}

function PopulateDebug(debug, o, keys, vars)
    debug.flightMode = vars.flightMode

    local quest = Game.GetQuestsSystem()
    debug.mutlmod_Current = quest:GetFactStr("custom_currentlyFlying_current")
    debug.mutlmod_Vel = this.GetMultiModVelocity(quest)
    debug.mutlmod_IsOwnerOrNone = o:Custom_CurrentlyFlying_IsOwnerOrNone()
    debug.mutlmod_CanStartFlight = o:Custom_CurrentlyFlying_CanStartFlight()

    debug.isSafetyFireCandidate = vars.isSafetyFireCandidate

    debug.pos = vec_str(o.pos)
    debug.vel = vec_str(o.vel)
    --debug.yaw = Round(o.yaw, 0)

    if o.vel then
        debug.speed = tostring(Round(GetVectorLength(o.vel), 1))
    end

    debug.is_airborne = IsAirborne(o)

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

    -- for key, value in pairs(vars.startStopTracker.downTimes) do
    --     debug["down_" .. key] = value
    -- end

    -- local action = vars.startStopTracker:GetRequestedAction()
    -- if action then
    --     debug.action = action
    -- else
    --     debug.action = "-----"
    -- end

    debug.timer = Round(o.timer, 1)
end

----------------------------------- Private Methods -----------------------------------

function this.RollCamera()
--     local fppcam = o.player:GetFPPCameraComponent()

--     print("fov: " .. tostring(fppcam:GetFOV()))
--     print("zoom: " .. tostring(fppcam:GetZoom()))
--     print("initial pos: " .. vec_str(fppcam:GetInitialPosition()))
--     print("initial orientation: " .. quat_str(fppcam:GetInitialOrientation()))
--     print("local pos: " .. vec_str(fppcam:GetLocalPosition()))
--     print("local orientation: " .. quat_str(fppcam:GetLocalOrientation()))

--     -- o:GetCamera()
--     -- local quat = Quaternion_FromAxisRadians(o.lookdir_forward, Degrees_to_Radians(135))
--     -- fppcam:SetLocalOrientation(quat)
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