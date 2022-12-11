local up = nil      -- can't use vector4 before init

-- This will return true as long as there is some air below the player
function IsAirborne(o)
    return o:IsPointVisible(o.pos, Vector4.new(o.pos.x, o.pos.y, o.pos.z - 0.3, 1))
end

function ShouldJump(o, const, wall_normal, isShiftDown)
    if const.should_jump_backward or isShiftDown then       -- shift overrides the constant
        -- Jumping backward is allowed, so there's no reason for more checks
        return true
    end

    o:GetCamera()
    if not o.lookdir_forward then       -- shouldn't happen
        return false
    end

    local wall_dot = DotProduct3D(o.lookdir_forward, wall_normal)
    if wall_dot > const.jumpcalc_mindot then
        -- They are facing away from the wall (along the wall's normal)
        return true
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    local up_dot = DotProduct3D(o.lookdir_forward, up)

    if wall_dot < 0 and up_dot >= const.jumpcalc_straightupdot then
        -- This is a special case that makes them jump straight up
        return true
    end

    -- They are facing toward the wall
    return false
end