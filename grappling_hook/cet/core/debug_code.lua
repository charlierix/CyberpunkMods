local this = {}

function PopulateDebug(debug, o, keys, vars)
    debug.flightMode = vars.flightMode

    debug.mutlmod_IsOwnerOrNone = o:Custom_CurrentlyFlying_IsOwnerOrNone()
    debug.mutlmod_CanStartFlight = o:Custom_CurrentlyFlying_CanStartFlight()

    debug.isSafetyFireCandidate = vars.isSafetyFireCandidate

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