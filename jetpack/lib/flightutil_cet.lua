------------------------------------
-- These are methods that are only used when flying using cet teleports (non redscript)
------------------------------------

-- This does a couple ray casts to make sure the path is clear to jump to
-- Returns:
--      bool isSafe
--      bool isHorzHit
--      bool isVertHit
function IsTeleportPointSafe(fromPos, toPos, velocity, deltaTime, o)
    -- test a bit above the teleport point
    --NOTE: pos is at the character's feet
    if not o:IsPointVisible(fromPos, Vector4.new(toPos.x, toPos.y, toPos.z + 2.3, toPos.w)) then
        return false, false, true
    end

    -- project forward a bit
    if not o:IsPointVisible(fromPos, Vector4.new(toPos.x + (velocity.x * deltaTime * 6), toPos.y + (velocity.y * deltaTime * 6), toPos.z, toPos.w)) then
        return false, true, false
    end

    return true, false, false
end

-- This will move the player to the next point
function Process_InFlight_NewPos(o, newPos, deltaYaw)
    local yaw = AddYaw(o.yaw, deltaYaw)
    o:Teleport(newPos, yaw)
end

-- This responds to wall/floor hits
function Process_InFlight_HitWall(vel, isHorzHit, isVertHit)
    -- Lose some momentum
    if isHorzHit then
        vel.x = vel.x * 0.5     --TODO: Bounce off the wall, don't just loose momentum (also need to adust yaw).  Need more information, can't just negate x and y velocity
        vel.y = vel.y * 0.5
    end

    if isVertHit then
        vel.z = vel.z * -0.5        -- this one is easy enough to reflect
    end
end

function ClampVelocity(vel, maxSpeed)
    local speedSqr = GetVectorLengthSqr(vel)

    if speedSqr <= (maxSpeed * maxSpeed) then
        return vel
    else
        local speed = math.sqrt(speedSqr)
        local ratio = maxSpeed / speed

        return Vector4.new(vel.x * ratio, vel.y * ratio, vel.z * ratio, 1)
    end
end

-- This will pull the velocity toward the direction facing
function RotateVelocityToLookDir(o, mode, vars, deltaTime, debug)
    if not mode.rotateVelToLookDir then
        do return end
    end

    o:GetCamera()

    local percentHorz, percentVert = RotateVelocity_Percent(o.lookdir_forward, vars.vel, mode, debug)
    if not percentHorz then     -- they are either both nil or both non nil
        do return end
    end

    local velX = vars.vel.x
    local velY = vars.vel.y
    local velZ = vars.vel.z

    -- Horizontal
    velX, velY = RotateVelocity_NewXY(o.lookdir_forward.x, o.lookdir_forward.y, velX, velY, percentHorz, deltaTime)

    -- Vertical (the logic is the same, just using YZ instead of XY)
    velY, velZ = RotateVelocity_NewXY(o.lookdir_forward.y, o.lookdir_forward.z, velY, velZ, percentVert, deltaTime)

    vars.vel.x = velX
    vars.vel.y = velY
    vars.vel.z = velZ
end

function RotateVelocity_Percent(dirFacing, vel, mode, debug)

    -- debug.zzz_dot = "n/a"
    -- debug.zzz_scale = "n/a"
    -- debug.zzz_perc_horz = "n/a"
    -- debug.zzz_perc_vert = "n/a"

    local speedSqr = GetVectorLengthSqr(vel)
    if speedSqr < (mode.rotateVel_minSpeed * mode.rotateVel_minSpeed) then
        -- Going too slow
        return nil, nil
    end

    local speed = math.sqrt(speedSqr)
    local velUnit = DivideVector(vel, speed)

    local percentHorz = mode.rotateVel_percent_horz
    local percentVert = mode.rotateVel_percent_vert

    -- Limit percent if looking too far away
    if mode.rotateVel_dotPow > 0 then
        local dot = DotProduct3D(dirFacing, velUnit)        -- direction facing is already a unit vector

        -- debug.zzz_dot = dot

        if dot <= 0 then
            -- Looking perpendicular or more to velocity
            return nil, nil
        end

        percentHorz = RotateVelocity_Percent_Pow(percentHorz, dot, mode.rotateVel_dotPow)
        percentVert = RotateVelocity_Percent_Pow(percentVert, dot, mode.rotateVel_dotPow)
    end

    -- Limit percent if going too slow
    if speed < mode.rotateVel_maxSpeed then
        local scale = GetScaledValue(0, 1, mode.rotateVel_minSpeed, mode.rotateVel_maxSpeed, speed)

        -- debug.zzz_scale = scale

        percentHorz = percentHorz * scale
        percentVert = percentVert * scale
    end

    -- debug.zzz_perc_horz = percentHorz
    -- debug.zzz_perc_vert = percentVert

    return percentHorz, percentVert
end

function RotateVelocity_Percent_Pow(percent, dot, pow)
    -- Take dot^pow
    local dotPow = dot

    for i=2, pow do
        dotPow = dotPow * dot
    end

    return percent * dotPow
end

function RotateVelocity_NewXY(lookX, lookY, velX, velY, percent, deltaTime)
    -- Get the angle difference
    local rad = RadiansBetween2D(lookX, lookY, velX, velY)
    if CrossProduct2D(lookX, lookY, velX, velY) < 0 then
        rad = -rad
    end

    -- Pull velocity toward camera
    return RotateVector2D(velX, velY, -rad * percent * deltaTime)
end