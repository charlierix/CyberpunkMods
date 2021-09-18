local this = {}

local forward = nil     -- can't be set here, because registerForEvent("onInit" needs to run first
local up = nil
local right = nil

function ApplyRotations_Absolute(o, vars, debug, const)
    --if IsNearValue(vars.roll_current, vars.roll_desired) and IsNearValue(vars.pitch_current, vars.pitch_desired) and IsNearValue(vars.yaw_current, vars.yaw_desired) then
    if IsNearZero(vars.roll_desired) and IsNearZero(vars.pitch_desired) and IsNearZero(vars.yaw_desired) then
        do return end
    end

    this.EnsureVectorsPopulated()

    local quat = GetIdentityQuaternion()

    -- Seizure warning.  This is more of an example of why you can't define a rotation as independent roll/pitch/yaw vectors.
    -- It just doesn't make sense.  A quaternion is itself a definition of a rotation, which can be rotated by any axis/angle
    -- combo
    local rand = math.random(6)
    if rand == 1 then
        quat = this.ApplyRotation(quat, forward, vars.roll_desired, vars.roll_current)
        quat = this.ApplyRotation(quat, right, vars.pitch_desired, vars.pitch_current)
        quat = this.ApplyRotation(quat, up, vars.yaw_desired, vars.yaw_current)

    elseif rand == 2 then
        quat = this.ApplyRotation(quat, right, vars.pitch_desired, vars.pitch_current)
        quat = this.ApplyRotation(quat, up, vars.yaw_desired, vars.yaw_current)
        quat = this.ApplyRotation(quat, forward, vars.roll_desired, vars.roll_current)

    elseif rand == 3 then
        quat = this.ApplyRotation(quat, up, vars.yaw_desired, vars.yaw_current)
        quat = this.ApplyRotation(quat, forward, vars.roll_desired, vars.roll_current)
        quat = this.ApplyRotation(quat, right, vars.pitch_desired, vars.pitch_current)

    elseif rand == 4 then
        quat = this.ApplyRotation(quat, forward, vars.roll_desired, vars.roll_current)
        quat = this.ApplyRotation(quat, up, vars.yaw_desired, vars.yaw_current)
        quat = this.ApplyRotation(quat, right, vars.pitch_desired, vars.pitch_current)

    elseif rand == 5 then
        quat = this.ApplyRotation(quat, right, vars.pitch_desired, vars.pitch_current)
        quat = this.ApplyRotation(quat, forward, vars.roll_desired, vars.roll_current)
        quat = this.ApplyRotation(quat, up, vars.yaw_desired, vars.yaw_current)

    else
        quat = this.ApplyRotation(quat, up, vars.yaw_desired, vars.yaw_current)
        quat = this.ApplyRotation(quat, right, vars.pitch_desired, vars.pitch_current)
        quat = this.ApplyRotation(quat, forward, vars.roll_desired, vars.roll_current)
    end

    o:FPP_SetLocalOrientation(quat)

    vars.roll_current = vars.roll_desired
    vars.pitch_current = vars.pitch_desired
    vars.yaw_current = vars.yaw_desired
end

----------------------------------- Private Methods -----------------------------------

function this.EnsureVectorsPopulated()
    if not forward then
        forward = Vector4.new(0, 1, 0, 1)
    end

    if not up then
        up = Vector4.new(0, 0, -1, 1)      -- yaw is reversed otherwise
    end

    if not right then
        right = Vector4.new(1, 0, 0, 1)
    end
end

function this.ApplyRotation(quat, axis, desired_angle, current_angle)
    if IsNearZero(desired_angle) then
        -- Nothing to do
        return quat
    end

    local delta = Quaternion_FromAxisRadians(axis, Degrees_to_Radians(desired_angle))
    return RotateQuaternion(quat, delta)
end