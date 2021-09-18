local this = {}

local forward = nil     -- can't be set here, because registerForEvent("onInit" needs to run first
local up = nil
local right = nil

function ApplyRotations_Additive(o, vars, debug, const)
    if IsNearZero(vars.roll_desired) and IsNearZero(vars.pitch_desired) and IsNearZero(vars.yaw_desired) then
        do return end
    end

    this.EnsureVectorsPopulated()

    local quat = o:FPP_GetLocalOrientation()

    -- If there is more than one at once, randomizing the order each frame should keep fairly things unbiased
    local rand = math.random(6)
    if rand == 1 then
        quat = this.ApplyRotation(quat, forward, vars.roll_desired)
        quat = this.ApplyRotation(quat, right, vars.pitch_desired)
        quat = this.ApplyRotation(quat, up, vars.yaw_desired)

    elseif rand == 2 then
        quat = this.ApplyRotation(quat, right, vars.pitch_desired)
        quat = this.ApplyRotation(quat, up, vars.yaw_desired)
        quat = this.ApplyRotation(quat, forward, vars.roll_desired)

    elseif rand == 3 then
        quat = this.ApplyRotation(quat, up, vars.yaw_desired)
        quat = this.ApplyRotation(quat, forward, vars.roll_desired)
        quat = this.ApplyRotation(quat, right, vars.pitch_desired)

    elseif rand == 4 then
        quat = this.ApplyRotation(quat, forward, vars.roll_desired)
        quat = this.ApplyRotation(quat, up, vars.yaw_desired)
        quat = this.ApplyRotation(quat, right, vars.pitch_desired)

    elseif rand == 5 then
        quat = this.ApplyRotation(quat, right, vars.pitch_desired)
        quat = this.ApplyRotation(quat, forward, vars.roll_desired)
        quat = this.ApplyRotation(quat, up, vars.yaw_desired)

    else
        quat = this.ApplyRotation(quat, up, vars.yaw_desired)
        quat = this.ApplyRotation(quat, right, vars.pitch_desired)
        quat = this.ApplyRotation(quat, forward, vars.roll_desired)
    end

    o:FPP_SetLocalOrientation(quat)

    vars.roll_desired = 0
    vars.pitch_desired = 0
    vars.yaw_desired = 0
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

function this.ApplyRotation(quat, axis, angle)
    if IsNearZero(angle) then
        -- Nothing to do
        return quat
    end

    local delta = Quaternion_FromAxisRadians(axis, Degrees_to_Radians(angle))
    return RotateQuaternion(quat, delta)
end