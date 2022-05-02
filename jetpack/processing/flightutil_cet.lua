------------------------------------
-- These are methods that are only used when flying using cet teleports (non redscript)
------------------------------------

-- This does a couple ray casts to make sure the path is clear to jump to
-- Returns:
--      bool isSafe
--      vect4 hit's normal
function IsTeleportPointSafe(fromPos, toPos, velocity, deltaTime, o)
    -- test a bit above the teleport point
    --NOTE: pos is at the character's feet
    local hit_pos, hit_norm = o:RayCast(fromPos, Vector4.new(toPos.x, toPos.y, toPos.z + 2.3, toPos.w))

    if hit_pos then
        return false, hit_norm
    end

    -- project forward a bit
    hit_pos, hit_norm = o:RayCast(fromPos, Vector4.new(toPos.x + (velocity.x * deltaTime * 6), toPos.y + (velocity.y * deltaTime * 6), toPos.z, toPos.w))
    if hit_pos then
        return false, hit_norm
    end

    return true, nil
end

-- This will move the player to the next point
function Process_InFlight_NewPos(o, newPos, deltaYaw)
    local yaw = AddYaw(o.yaw, deltaYaw)
    o:Teleport(newPos, yaw)
end

-- This responds to wall/floor hits
function Process_InFlight_HitWall(vel, hit_normal, o, vars)
    PlaySound_WallHit(o, vars, vel)

    -- Don't perfectly bounce off at full speed
    local loss = 0.4
    vel.x = vel.x * loss
    vel.y = vel.y * loss
    vel.z = vel.z * loss

    --https://stackoverflow.com/questions/61272597/calculate-the-bouncing-angle-for-a-ball-point
    local dot = DotProduct3D(vel, hit_normal)
    if dot > 0 then
        vel.x = vel.x * -0.1
        vel.y = vel.y * -0.1
        vel.z = vel.z * -0.1

        do return end

        -- This doesn't work, just ends up getting them stuck/twitching.  It generally happens with small items, like
        -- support bars/pipes
        -- hit_normal = MultiplyVector(hit_normal, -1)
        -- dot = DotProduct3D(vel, hit_normal)
    end

    vel.x = vel.x + hit_normal.x * dot * -2
    vel.y = vel.y + hit_normal.y * dot * -2
    vel.z = vel.z + hit_normal.z * dot * -2
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
    if not mode.rotateVel.is_used then
        do return end
    end

    o:GetCamera()

    local percentHorz, percentVert = RotateVelocity_Percent(o.lookdir_forward, vars.vel, mode.rotateVel, debug)
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

function RotateVelocity_Percent(dirFacing, vel, rotateVel, debug)

    -- debug.zzz_dot = "n/a"
    -- debug.zzz_scale = "n/a"
    -- debug.zzz_perc_horz = "n/a"
    -- debug.zzz_perc_vert = "n/a"

    local speedSqr = GetVectorLengthSqr(vel)
    if speedSqr < (rotateVel.minSpeed * rotateVel.minSpeed) then
        -- Going too slow
        return nil, nil
    end

    local speed = math.sqrt(speedSqr)
    local velUnit = DivideVector(vel, speed)

    local percentHorz = rotateVel.percent_horz
    local percentVert = rotateVel.percent_vert

    -- Limit percent if looking too far away
    if rotateVel.dotPow > 0 then
        local dot = DotProduct3D(dirFacing, velUnit)        -- direction facing is already a unit vector

        -- debug.zzz_dot = dot

        if dot <= 0 then
            -- Looking perpendicular or more to velocity
            return nil, nil
        end

        percentHorz = RotateVelocity_Percent_Pow(percentHorz, dot, rotateVel.dotPow)
        percentVert = RotateVelocity_Percent_Pow(percentVert, dot, rotateVel.dotPow)
    end

    -- Limit percent if going too slow
    if speed < rotateVel.maxSpeed then
        local scale = GetScaledValue(0, 1, rotateVel.minSpeed, rotateVel.maxSpeed, speed)

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