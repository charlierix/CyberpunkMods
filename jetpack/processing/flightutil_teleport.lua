------------------------------------
-- These are methods that are only used when flying using teleports (non impulse)
------------------------------------

local this = {}
local up = nil

-- This does a couple ray casts to make sure the path is clear to jump to
-- Returns:
--      bool isSafe
--      vect4 hit's normal
function IsTeleportPointSafe(fromPos, toPos, velocity, deltaTime, o)
    -- test a bit above the teleport point
    --NOTE: pos is at the character's feet
    local hit_pos, hit_norm = o:RayCast(fromPos, Vector4.new(toPos.x, toPos.y, toPos.z + 2.3, toPos.w))

    if hit_pos and not this.IsHitUpFromTheGrave(velocity, hit_norm) then
        return false, hit_norm
    end

    -- project forward a bit
    hit_pos, hit_norm = o:RayCast(fromPos, Vector4.new(toPos.x + (velocity.x * deltaTime * 6), toPos.y + (velocity.y * deltaTime * 6), toPos.z, toPos.w))
    if hit_pos then
        return false, hit_norm
    end

    -- do an extra ground check
    -- copied from low flying v, but jetpack does this check up front
    -- if velocity.z < 6 then
    --     hit_pos, hit_norm = o:RayCast(fromPos, Vector4.new(toPos.x, toPos.y, toPos.z - 0.15, toPos.w))
    --     if hit_pos then
    --         return false, hit_norm
    --     end
    -- end

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
    if not mode.mouseSteer then
        do return end
    end

    o:GetCamera()

    local percentHorz, percentVert = this.RotateVelocity_Percent(o.lookdir_forward, vars.vel, mode.mouseSteer, debug)
    if not percentHorz then     -- they are either both nil or both non nil
        do return end
    end

    local velX = vars.vel.x
    local velY = vars.vel.y
    local velZ = vars.vel.z

    -- Horizontal
    velX, velY = this.RotateVelocity_NewXY(o.lookdir_forward.x, o.lookdir_forward.y, velX, velY, percentHorz, deltaTime)

    -- Vertical (the logic is the same, just using YZ instead of XY)
    velY, velZ = this.RotateVelocity_NewXY(o.lookdir_forward.y, o.lookdir_forward.z, velY, velZ, percentVert, deltaTime)

    if IsNaN(velX) or IsNaN(velY) or IsNaN(velZ) then
        do return end       -- can happen at slow percents, or if going straight up
    end

    vars.vel.x = velX
    vars.vel.y = velY
    vars.vel.z = velZ
end

----------------------------------- Private Methods -----------------------------------

-- If they clipped below ground and are trying to fly back up, then the up looking ray hit needs to be ignored
-- This function tries to detect that
--NOTE: pos.z < 0 check isn't good, since there are areas lower than zero, lots of areas higher than zero
function this.IsHitUpFromTheGrave(velocity, hit_norm)
    if not up then
        up = Vector4.new(0, 0, 1, 1)
    end

    -- Ignore if they are going down
    if DotProduct3D(velocity, up) < 0 then      --NOTE: velocity isn't a unit vector, so can't get more accurate than positive/negative without normalizing
        return false
    end

    -- Only consider tiles that are pointing up
    if DotProduct3D(hit_norm, up) < 0.7 then
        return false
    end

    -- They are moving up onto the backside of an up facing tile
    return true
end

function this.RotateVelocity_Percent(dirFacing, vel, mouseSteer, debug)

    -- debug.zzz_dot = "n/a"
    -- debug.zzz_scale = "n/a"
    -- debug.zzz_perc_horz = "n/a"
    -- debug.zzz_perc_vert = "n/a"

    local speedSqr = GetVectorLengthSqr(vel)
    if speedSqr < (mouseSteer.minSpeed * mouseSteer.minSpeed) then
        -- Going too slow
        return nil, nil
    end

    local speed = math.sqrt(speedSqr)
    local velUnit = DivideVector(vel, speed)

    local percentHorz = mouseSteer.percent_horz
    local percentVert = mouseSteer.percent_vert

    -- Limit percent if looking too far away
    if mouseSteer.dotPow > 0 then
        local dot = DotProduct3D(dirFacing, velUnit)        -- direction facing is already a unit vector

        -- debug.zzz_dot = dot

        if dot <= 0 then
            -- Looking perpendicular or more to velocity
            return nil, nil
        end

        percentHorz = percentHorz * dot ^ mouseSteer.dotPow
        percentVert = percentVert * dot ^ mouseSteer.dotPow
    end

    -- Limit percent if going too slow
    if speed < mouseSteer.maxSpeed then
        local scale = GetScaledValue(0, 1, mouseSteer.minSpeed, mouseSteer.maxSpeed, speed)

        -- debug.zzz_scale = scale

        percentHorz = percentHorz * scale
        percentVert = percentVert * scale
    end

    -- debug.zzz_perc_horz = percentHorz
    -- debug.zzz_perc_vert = percentVert

    return percentHorz, percentVert
end

function this.RotateVelocity_NewXY(lookX, lookY, velX, velY, percent, deltaTime)
    -- Get the angle difference
    local rad = RadiansBetween2D(lookX, lookY, velX, velY)
    if CrossProduct2D(lookX, lookY, velX, velY) < 0 then
        rad = -rad
    end

    -- Pull velocity toward camera
    return RotateVector2D(velX, velY, -rad * percent * deltaTime)
end
