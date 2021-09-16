local this = {}

function PopulateDebug(debug, o, keys, vars)
    debug.roll_desired = Round(vars.roll_desired, 1)
    debug.roll_actual = Round(vars.roll_actual, 1)

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