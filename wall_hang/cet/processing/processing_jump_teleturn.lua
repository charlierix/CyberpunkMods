local this = {}

local up = nil

function Process_Jump_TeleTurn(o, vars, const, debug, deltaTime)
    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    o:GetCamera()
    if not o.lookdir_forward then       -- shouldn't happen
        Transition_ToStandard(vars, const, debug, o, false)
        do return end
    end
    local lookdir = o.lookdir_forward

    -- Figure out how much can be turned this tick
    local radians_max = const.teleturn_radians_per_second * deltaTime

    -- See how far there is to go
    local radians_difference = RadiansBetween2D(lookdir.x, lookdir.y, vars.final_lookdir.x, vars.final_lookdir.y)
    if DotProduct3D(up, CrossProduct3D(lookdir, vars.final_lookdir)) < 0 then
        radians_difference = -radians_difference        -- cross product points down, which means it needs to rotate negative (otherwise the full rotation would be more that 180 degrees)
    end

    local new_dirfacing = nil
    local isFinished = false

    if math.abs(radians_difference) <= radians_max or IsNearZero(radians_difference) then
        debug.teleturn_func = "final"

        new_dirfacing = vars.final_lookdir
        isFinished = true
    else
        debug.teleturn_func = "intermediate"

        new_dirfacing = this.GetNewDirectionFacing(lookdir, radians_difference, radians_max, debug)
    end

    local yaw = Vect_to_Yaw(new_dirfacing.x, new_dirfacing.y)

    --NOTE: This is ignoring the user's attempts to rotate with the mouse.  That could be added if it's
    --too distracting, but this teleturn should last less than a second
    --
    --It would only be a distraction if they are trying to rotate counter to what this function is doing

    --TODO: Also calculate a point along the arc so they don't just spin in place
    o:Teleport(vars.hangPos, yaw)

    if isFinished then
        Transition_ToJump_Impulse(vars, const, debug, o, vars.impulse, true, vars.should_relatch)
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetNewDirectionFacing(lookdir, radians_difference, radians_max, debug)
    local radians = radians_max
    if radians_difference < 0 then
        radians = -radians
    end

    local quat = Quaternion_FromAxisRadians(up, radians)

    return RotateVector3D(lookdir, quat)
end