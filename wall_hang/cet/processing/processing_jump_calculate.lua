local this = {}

local MINDOT = 0.1
local BACKWARD_POW = 1.5

local up = nil      -- can't use vector4 before init

function Process_Jump_Calculate(o, vars, const, debug)
    o:GetCamera()
    if not o.lookdir_forward then       -- shouldn't happen
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    -- Complare the look direction with the wall's normal, figure out the direction to go
    local jump_dir = this.CalculateJumpDirection_Direct(o.lookdir_forward, vars.normal)

    -- Rotate up so the jump will be in an arc
    local impulse = this.GetImpulse(jump_dir, const.jump_strength)

    --NOTE: In the future, there may be reasons to not adjust the look direction (because they are
    --holding a direction key, or config says not to).  In those cases, go straight to jump_impulse

    Transition_ToJump_TeleTurn(vars, const, o, impulse, jump_dir)
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
    if not up then
        up = Vector4.new(0, 0, 1, 0)
    end

    -- pi       straight down
    -- pi/2     horizontal
    -- 0        straight up
    local radian = Dot_to_Radians(DotProduct3D(direction, up))

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