local this = {}
local MINDOT = 0.35
local BACKWARD_POW = 1.5

function Process_Jump(o, vars, const, debug, startStopTracker)


    --TODO: Instead of having a single jump enum, break it into three:
    --  jump_calculate
    --  jump_teleturn
    --  jump_impulse


    ------------------ Initial Calculations ------------------


    o:GetCamera()
    if not o.lookdir_forward then       -- shouldn't happen
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    local jump_dir = this.CalculateJumpDirection_Direct(o.lookdir_forward, vars.normal)

    print("jump_dir: " .. vec_str(jump_dir))

    -- turn that into a destination yaw
    local yaw = Vect_to_Yaw(jump_dir.x, jump_dir.y)




    local impulse = this.GetImpulse(jump_dir, const.jump_strength)




    ------------------ Spread over a few frames ------------------



    --o:Teleport(vars.hangPos, yaw)

    o.player:WallHang_AddImpulse(impulse.x, impulse.y, impulse.z)





    ------------------ Finally ------------------


    Transition_ToStandard(vars, const, debug, o)
end

----------------------------------- Private Methods -----------------------------------

-- NOTE: This isn't the perfect final direction they will go.  It does tell what yaw to use
-- and how much power to put into the jump
function this.CalculateJumpDirection_Direct(lookdir, normal)
    local dot = DotProduct3D(lookdir, normal)

    if dot > MINDOT then
        -- They are looking away from the wall, jump the direction they're looking
        return lookdir
    end

    if dot < 0 then
        -- Need to flip the look direction so it's going the same direction as the normal
        local onPlane = GetProjectedVector_AlongPlane(lookdir, normal)

        lookdir = Vector4.new(onPlane.x * 2 - lookdir.x, onPlane.y * 2 - lookdir.y, onPlane.z * 2 - lookdir.z, 1)
    end

    -- Need to jump backward off the wall.  Figure out how to blend normal and look direction
    local percentNormal = GetScaledValue(0, 1, MINDOT, -1, dot)
    percentNormal = percentNormal ^ BACKWARD_POW

    local rotate = GetRotation(lookdir, normal, percentNormal)

    return RotateVector3D(lookdir, rotate)
end

-- This returns the final impulse to apply
function this.GetImpulse(direction, jump_strength)

    

    -- Rotate up, by this angle
    --  x is the angle they are looking (phi)
    --  y is the angle they should jump

    -- -90  -90
    --  0   45      -- when they are looking straight out, angle should be 45 for best arc
    --  90  90
    --
    -- y = 45 + x - 0.005555556 * x^2

    -- Probably need to use radians instead

    return MultiplyVector(direction, jump_strength)

end