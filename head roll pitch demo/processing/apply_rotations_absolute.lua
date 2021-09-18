local this = {}

this.forward = nil     -- can't be set here, because registerForEvent("onInit" needs to run first
this.up = nil
this.right = nil

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

function this.EnsureVectorsPopulated()
    if not this.forward then
        this.forward = Vector4.new(0, 1, 0, 1)
    end

    if not this.up then
        this.up = Vector4.new(0, 0, -1, 1)      -- yaw is reversed otherwise
    end

    if not this.right then
        this.right = Vector4.new(1, 0, 0, 1)
    end
end