-- This is called each tick when they flying (and not in the menu)
function Process_InFlight(o, vars, const, keys, debug, deltaTime)
    if keys.forceFlight or not CheckOtherModsFor_ContinueFlight(o, const.modNames) then
        ExitFlight(vars, debug, o)
        do return end
    end

    -- Detect low speed near the ground for a few frames and drop out of flight
    if keys.backward and GetVectorLengthSqr(vars.vel) < (12 * 12) and not o:IsPointVisible(o.pos, Vector4.new(o.pos.x, o.pos.y, o.pos.z - 8, 1)) then       -- walking speed is 5, running is about 7.5.  Flying is closer to 20+, except for brief collisions
        if not vars.lowSpeedTime then
            vars.lowSpeedTime = o.timer
        end

        --NOTE: By requiring continuous holding the back key, they can safely tap back key to have nice and
        --controlled slow flight
        if(o.timer - vars.lowSpeedTime > 0.55) then        -- this is in seconds
            ExitFlight(vars, debug, o)
            do return end
        end
    else
        vars.lowSpeedTime = nil
    end

    -- Detect obstacles
    vars.lasercats:Tick(o.pos, vars.vel)
    vars.rayHitStorage:Tick(o.timer)

    -- Repulse accelerations
    local accelX, accelY, accelZ, closestDist, maxDist = FloatPlayer_GetAcceleration(vars.rayHitStorage, o.pos, const)

    -- Gravity
    accelZ = accelZ - GetGravity(closestDist, maxDist, vars.vel.z, const.gravity_open_mult, const.gravity_open_velZ_min, const.gravity_open_velZ_max, const.gravity_zeroAtDistPercent)

    -- Keyboard inputs
    o:GetCamera()
    local keyX, keyY, keyZ, keyYaw = KeyboardFlight(keys, o.lookdir_forward, o.lookdir_right, const, vars.startFlightTime, o.timer, vars.vel)
    accelX = accelX + keyX
    accelY = accelY + keyY
    accelZ = accelZ + keyZ

    -- Don't let it get too slow (this mod needs to feel a bit frenetic)
    local dx, dy, dz = EnforceMinSpeed(vars, const, keys.backward, o.timer)
    accelX = accelX + dx
    accelY = accelY + dy
    accelZ = accelZ + dz

    if const.shouldShowDebugWindow then
        PopulateFlightDebug(vars, debug, accelX, accelY, accelZ)
    end

    -- Apply accelerations to the current velocity
    accelX = accelX * deltaTime
    accelY = accelY * deltaTime
    accelZ = accelZ * deltaTime

    vars.vel.x = vars.vel.x + accelX
    vars.vel.y = vars.vel.y + accelY
    vars.vel.z = vars.vel.z + accelZ

    vars.vel = ClampVelocity(vars.vel, const.maxSpeed)      -- the game gets unstable and crashes at high speed.  Probably trying to load scenes too fast, probably machine dependent

    -- Push them up if they are underwater
    if o:HasHeadUnderwater() then
        vars.vel.z = math.max(vars.vel.z, -o.pos.z)
    end

    -- Turn velocity
    if not IsNearZero(keyYaw) then
        local velX, velY = RotateVector2D(vars.vel.x, vars.vel.y, keyYaw * math.pi / 180)
        vars.vel.x = velX
        vars.vel.y = velY

        vars.quickSwivel_startTime = o.timer
    end

    -- Pull velocity direction toward direction facing (and vice versa)
    local lookYaw = RotateVelocity_Horizontal(o, vars, const, deltaTime)

    RotateVelocity_Vertical(o.lookdir_forward, vars.vel, const.percent_towardCamera_vert, deltaTime)

    -- Commit the point
    local newPos = Vector4.new(o.pos.x + (vars.vel.x * deltaTime), o.pos.y + (vars.vel.y * deltaTime), o.pos.z + (vars.vel.z * deltaTime), 1)

    local isSafe, isHorzHit, isVertHit = IsTeleportPointSafe(o.pos, newPos, vars.vel, deltaTime, o)

    if isSafe then
        Process_InFlight_NewPos(o, newPos, lookYaw, vars, const)
    else
        Process_InFlight_HitWall(vars.vel, isHorzHit, isVertHit, vars, o.timer)
    end

    -- See if cruise control speed should be adjusted
    AdjustMinSpeed(o, vars, const, keys)
end

---------------------------------------- Private Methods ----------------------------------------

function ExitFlight(vars, debug, o)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if (not vars) or (not vars.isInFlight) then
        do return end
    end

    vars.isInFlight = false
    o:Custom_CurrentlyFlying_Clear()
    vars.kdash:Clear()
    vars.lasercats:Stop()

    RemoveFlightDebug(debug)
end

function PopulateFlightDebug(vars, debug, accelX, accelY, accelZ)
    --TODO: Report high level stats

    --  num shots fired
    --  num actual ray casts
    --  num hits

    --  current hit count
    debug.hitstorage = vars.rayHitStorage.points:GetCount()

    debug.accelX = Round(accelX, 1)
    debug.accelY = Round(accelY, 1)
    debug.accelZ = Round(accelZ, 1)

    debug.vel2 = vec_str(vars.vel)
    debug.speed2 = Round(GetVectorLength(vars.vel), 1)
end
function RemoveFlightDebug(debug)
    debug.hitstorage = nil
    debug.accelX = nil
    debug.accelY = nil
    debug.accelZ = nil
    debug.vel2 = nil
    debug.speed2 = nil
end