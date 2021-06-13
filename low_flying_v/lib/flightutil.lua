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

-- This does a couple ray casts to make sure the path is clear to jump to
-- Returns:
--      bool isSafe
--      bool isHorzHit
--      bool isVertHit
function IsTeleportPointSafe(fromPos, toPos, velocity, deltaTime, o)
    -- test a bit above the teleport point
    --NOTE: pos is at the character's feet
    --NOTE: Doing a z check in case they clipped under the ground, let them pop back out
    if (fromPos.z > 0) and (not o:IsPointVisible(fromPos, Vector4.new(toPos.x, toPos.y, toPos.z + 2.3, toPos.w))) then
        return false, false, true
    end

    -- project forward a bit
    if not o:IsPointVisible(fromPos, Vector4.new(toPos.x + (velocity.x * deltaTime * 6), toPos.y + (velocity.y * deltaTime * 6), toPos.z, toPos.w)) then
        return false, true, false
    end

    -- do an extra ground check
    if (velocity.z < 6) and (not o:IsPointVisible(fromPos, Vector4.new(toPos.x, toPos.y, toPos.z - 0.15, toPos.w))) then
        return false, false, true
    end

    return true, false, false
end

-- This will move the player to the next point
function Process_InFlight_NewPos(o, newPos, deltaYaw, vars, const)
    local yaw = AddYaw(o.yaw, deltaYaw)
    o:Teleport(newPos, yaw)
end

-- This responds to wall/floor hits
function Process_InFlight_HitWall(vel, isHorzHit, isVertHit, vars, timer)
    -- Lose some momentum
    if isHorzHit then
        vel.x = vel.x * 0.5     --TODO: Bounce off the wall, don't just loose momentum (also need to adust yaw).  Need more information, can't just negate x and y velocity
        vel.y = vel.y * 0.5

        vars.quickSwivel_startTime = timer
    end

    if isVertHit then
        vel.z = vel.z * -0.5        -- this one is easy enough to reflect
    end
end

-- If gravity is simply 9.8, then things get too bouncy.  So increase gravity if going up too quickly
-- This will help dampen things, keep the player more stuck to the ground
-- Also don't have gravity when close to the ground so the repulse forces don't have to be as strong
function GetGravity(closestDist, maxDist, velZ, maxMult, zMin, zMax, minDistPercent)
    local gravMult = 1
    if velZ >= zMax then
        gravMult = maxMult
    elseif velZ > zMin then
        gravMult = 1 + (((maxMult - 1)) * (velZ - zMin) / (zMax - zMin))
    end

    local gravity = 9.8 * gravMult

    if not closestDist then
        return gravity
    end

    local zeroAtDist = maxDist * minDistPercent

    if closestDist <= zeroAtDist then
        return 0
    end

    return (closestDist - zeroAtDist) / (maxDist - zeroAtDist) * gravity
end

-- This returns acceleration if the speed is too slow
function EnforceMinSpeed(vars, const, isBackPressed, timer)
    -- If they are hitting back, then they are trying to slow down.  Disengage for a bit
    if isBackPressed then
        vars.hitBackTime = timer
    end

    if (timer - vars.hitBackTime) < 0.5 then
        return 0, 0, 0
    end

    local minSpeed = GetOverridenMinSpeed(vars, const, timer)

    local speedSqr = GetVectorLengthSqr(vars.vel)

    if speedSqr >= (minSpeed * minSpeed) then
        -- Going fast enough, no need to apply extra acceleration
        return 0, 0, 0
    elseif IsNearZero(speedSqr) then
        -- This should never happen, and next frame should have a velocity.  But just in case, accelerate in a random direction
        local randVel = Vector4.new(math.random(), math.random(), math.random(), 1)
        local speed = GetVectorLength(randVel)
        return
            randVel.x / speed * const.accel_underspeed,
            randVel.y / speed * const.accel_underspeed,
            randVel.z / speed * const.accel_underspeed
    else
        -- Going too slow
        local speed = math.sqrt(speedSqr)
        return
            vars.vel.x / speed * const.accel_underspeed,
            vars.vel.y / speed * const.accel_underspeed,
            vars.vel.z / speed * const.accel_underspeed
    end
end

-- This will set the min speed
function AdjustMinSpeed(o, vars, const, keys)
    -- Wait a bit before allowing adjustments
    if ((o.timer - vars.startFlightTime) < 4) or ((not keys.forward) and (not keys.backward)) then
        do return end
    end

    local currentSpeed = GetVectorLength(vars.vel)

    if (currentSpeed < const.minSpeed) and keys.backward then
        -- When trying to slow done below min speed, they are probably in a stressful situation and
        -- just want it to slow down.  So instead of slow increments, just have absolute min speed
        -- and halfway between absolute and min speed
        vars.minSpeedOverride_current = const.minSpeed_absolute
    else
        vars.minSpeedOverride_current = currentSpeed
    end

    vars.minSpeedOverride_start = o.timer
end

-- Calculate what the current min speed should be based on the default and override values
function GetOverridenMinSpeed(vars, const, timer)
    -- If they are trying to go slower than min speed, then don't bother with timer.  Just
    -- go that lower speed until they manually say to go faster
    if vars.minSpeedOverride_current < const.minSpeed then
        return vars.minSpeedOverride_current
    end

    -- See how long since an override started
    local elapsed = timer - vars.minSpeedOverride_start

    -- Use default if too much time has passed
    if elapsed > const.minSpeedOverride_duration then
        return const.minSpeed
    end

    -- Hold full speed for the first part of the override duration
    local fullSpeedDuration = const.minSpeedOverride_duration * 0.667

    if elapsed <= fullSpeedDuration then
        return vars.minSpeedOverride_current
    end

    -- Convert elapsed into 0 to 1
    elapsed = GetScaledValue(0, 1, fullSpeedDuration, const.minSpeedOverride_duration, elapsed)

    -- Figure out how much to decay the override
    local percent = 2.5 * elapsed
    percent = percent * percent
    percent = 2.7182818 ^ -percent

    return GetScaledValue(const.minSpeed, vars.minSpeedOverride_current, 0, 1, percent)
end