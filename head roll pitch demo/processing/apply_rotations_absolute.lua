local this = {}

this.forward = nil     -- can't be set here, because registerForEvent("onInit" needs to run first

function ApplyRotations_Absolute(o, vars, debug, const)
    if IsNearValue(vars.roll_actual, vars.roll_desired) then
        do return end
    end

    if const.shouldShowDebugWindow then
        this.PopulateDebug(o, debug)
    end

    -- o:GetCamera()
    -- local quat = Quaternion_FromAxisRadians(o.lookdir_forward, Degrees_to_Radians(vars.roll_desired))

    this.EnsureVectorsPopulated()

    local quat = Quaternion_FromAxisRadians(this.forward, Degrees_to_Radians(vars.roll_desired))

    o:FPP_SetLocalOrientation(quat)

    vars.roll_actual = vars.roll_desired
end

----------------------------------- Private Methods -----------------------------------

function this.PopulateDebug(o, debug)
    o:EnsurePlayerLoaded()
    o:EnsureFPPCameraLoaded()

    debug.fov = tostring(o.fppcam:GetFOV())
    debug.zoom = tostring(o.fppcam:GetZoom())
    debug.initial_pos = vec_str(o.fppcam:GetInitialPosition())
    debug.initial_orientation = quat_str(o.fppcam:GetInitialOrientation())
    debug.local_pos = vec_str(o.fppcam:GetLocalPosition())
    debug.local_orientation = quat_str(o.fppcam:GetLocalOrientation())
end

function this.EnsureVectorsPopulated()
    if not this.forward then
        this.forward = Vector4.new(0, 1, 0, 1)
    end
end