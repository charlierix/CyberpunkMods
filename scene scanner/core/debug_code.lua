function PopulateDebug(debug, o, keys, vars)
    o:EnsurePlayerLoaded()
    o:EnsureFPPCameraLoaded()

    debug.fov = tostring(o.fppcam:GetFOV())
    debug.zoom = tostring(o.fppcam:GetZoom())
    debug.initial_pos = vec_str(o.fppcam:GetInitialPosition())
    debug.initial_orientation = quat_str(o.fppcam:GetInitialOrientation())
    debug.local_pos = vec_str(o.fppcam:GetLocalPosition())
    debug.local_orientation = quat_str(o.fppcam:GetLocalOrientation())

    debug.roll_desired = Round(vars.roll_desired, 1)
    debug.roll_current = Round(vars.roll_current, 1)

    debug.pitch_desired = Round(vars.pitch_desired, 1)
    debug.pitch_current = Round(vars.pitch_desired, 1)

    debug.yaw_desired = Round(vars.yaw_desired, 1)
    debug.yaw_current = Round(vars.yaw_desired, 1)

    debug.timer = Round(o.timer, 1)
end