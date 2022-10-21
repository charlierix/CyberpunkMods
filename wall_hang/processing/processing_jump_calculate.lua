local this = {}

local BACKWARD_POW = 1.5

local up = nil      -- can't use vector4 before init

function Process_Jump_Calculate(o, player, vars, const, debug)
    o:GetCamera()
    if not o.lookdir_forward then       -- shouldn't happen
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    -- Compare the look direction with the wall's normal, figure out the direction to go
    local is_up, jump_dir = this.CalculateJumpDirection_Direct(o.lookdir_forward, vars.normal, const)

    if is_up then
        -- Going straight up is simpler and can go straight to impulse.  Though the impulse force needs
        -- to be reduced if going up too fast
        local has_impulse, impulse = this.GetImpulse_Up(jump_dir, o.vel, player.jump_strength, player.jump_speed_fullStrength, player.jump_speed_zeroStrength)

        if has_impulse then
            Transition_ToJump_Impulse(vars, const, debug, o, impulse, false)
        else
            PlaySound_FailJump(vars, o)
            Transition_ToStandard(vars, const, debug, o)
        end

    else
        -- Rotate up so the jump will be in an arc
        local impulse = this.GetImpulse_Out(jump_dir, player.jump_strength)

        --NOTE: In the future, there may be reasons to not adjust the look direction (because they are
        --holding a direction key, or config says not to).  In those cases, go straight to jump_impulse

        Transition_ToJump_TeleTurn(vars, const, debug, o, impulse, jump_dir)
    end
end

----------------------------------- Private Methods -----------------------------------

-- NOTE: This isn't the perfect final direction they will go.  It does tell what yaw to use
-- and how much power to put into the jump
-- Returns
--  is_up, direction
function this.CalculateJumpDirection_Direct(lookdir, normal, const)
    local dot = DotProduct3D(lookdir, normal)

    if dot > const.jumpcalc_mindot then
        -- They are looking away from the wall, jump the direction they're looking
        return false, lookdir
    end

    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    local upDot = DotProduct3D(lookdir, up)

    if dot < 0 and upDot >= const.jumpcalc_straightupdot then
        -- They are facing the wall and looking up.  Jump straight up instead of spinning around and jumping away
        -- TODO: Instead of going straight up, go perpendicular from normal along the up direction
        return true, up
    end

    if dot < 0 then
        -- Need to flip the look direction so it's going the same direction as the normal
        local onPlane = GetProjectedVector_AlongPlane(lookdir, normal)

        lookdir = Vector4.new(onPlane.x * 2 - lookdir.x, onPlane.y * 2 - lookdir.y, onPlane.z * 2 - lookdir.z, 1)
    end

    -- Need to jump backward off the wall.  Figure out how to blend normal and look direction
    local percentNormal = GetScaledValue(0, 1, const.jumpcalc_mindot, -1, dot)
    percentNormal = percentNormal ^ BACKWARD_POW

    local rotate = GetRotation(lookdir, normal, percentNormal)

    return false, RotateVector3D(lookdir, rotate)
end

-- Returns
--  hasImpulse, impulse_vector
function this.GetImpulse_Up(direction, velocity, jump_strength, speed_fullStrength, speed_zeroStrength)
    -- Get the speed going up
    --local speed_up = GetVectorLength(GetProjectedVector_AlongVector(velocity, up, true))      -- this is how to do it for a direction other than up
    local speed_up = velocity.z

    local percent = 1
    if speed_up >= speed_zeroStrength then
        return false, nil
    elseif speed_up >= speed_fullStrength then
        percent = GetScaledValue(1, 0, speed_fullStrength, speed_zeroStrength, speed_up)
    end

    return true, MultiplyVector(direction, jump_strength * percent)
end

-- This returns the final impulse to apply
function this.GetImpulse_Out(direction, jump_strength)
    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    local dot = DotProduct3D(direction, up)

    -- pi       straight down
    -- pi/2     horizontal
    -- 0        straight up
    local radian = Dot_to_Radians(dot)

    --https://mycurvefit.com/
    --https://www.desmos.com/calculator

    -- Rotate up, by this angle
    --  phi is the angle they are looking
    --  result is the angle they should jump

    -- -90  -90
    --  0   45      -- when they are looking straight out, angle should be 45 for best arc
    --  90  90

    -- jumpAngle = 45 + phi - 0.005555556 * phi^2

    -- Same idea, but with radians
    --  pi      -pi/2
    --  pi/2    pi/4
    --  0       pi/2

    local adjustRadians = 1.570796 - 0.3183099 * radian ^ 2

    local axis = CrossProduct3D(direction, up)

    local horizontal = GetProjectedVector_AlongPlane(direction, up)

    local rotated = RotateVector3D(horizontal, Quaternion_FromAxisRadians(axis, adjustRadians))

    return MultiplyVector(rotated, jump_strength / GetVectorLength(rotated))      -- rotated isn't a unit vector, so dividing by len makes it 1
end