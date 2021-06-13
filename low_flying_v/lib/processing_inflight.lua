-- This is called each tick when they flying (and not in the menu)
function Process_InFlight(o, state, const, keys, debug, deltaTime)
    if keys.forceFlight then
        ExitFlight(state, debug)
        do return end
    end

    --TODO: Detect death and drop out of flight (crashes to desktop otherwise)

    -- If they are hitting back while being close to the ground with a reasonalbly
    -- slow horizontal speed, then get out of flight
    if keys.backward and (Get2DLengthSqr(state.vel.x, state.vel.y) < (12 * 12)) and o:IsPointVisible(o.pos, Vector4.new(o.pos.x, o.pos.y, o.pos.z - 8, 1)) then
        ExitFlight(state, debug)
        do return end
    end

    -- Detect standing on the ground for a few frames and drop out of flight
    if GetVectorLengthSqr(state.vel) < (10 * 10) then       -- walking speed is 5, running is about 7.5.  Flying is closer to 20+, except for brief collisions
        state.lowSpeedTicks = state.lowSpeedTicks + 1
        if(state.lowSpeedTicks > 12) then
            ExitFlight(state, debug)
            do return end
        end
    else
        state.lowSpeedTicks = 0
    end

    -- Detect obstacles
    state.lasercats:Tick(o.pos, state.vel)
    state.rayHitStorage:Tick(o.timer)

    -- Repulse accelerations
    local accelX, accelY, accelZ, closestDist, maxDist = FloatPlayer_GetAcceleration(state.rayHitStorage, o.pos, const)

    -- Gravity
    accelZ = accelZ - GetGravity(closestDist, maxDist, state.vel.z, const.gravity_open_mult, const.gravity_open_velZ_min, const.gravity_open_velZ_max, const.gravity_zeroAtDistPercent)

    -- Keyboard inputs
    o:GetCamera()
    local keyX, keyY, keyZ, keyYaw = KeyboardFlight(keys, o.lookdir_forward, o.lookdir_right, const, state.startFlightTime, o.timer, state.vel)
    accelX = accelX + keyX
    accelY = accelY + keyY
    accelZ = accelZ + keyZ

    -- Don't let it get too slow (this mod needs to feel a bit frenetic)
    --local dx, dy, dz = EnforceMinSpeed(state.vel, const.minSpeed, const.accel_underspeed, state, keys.backward, o.timer)
    local dx, dy, dz = EnforceMinSpeed(state, const, keys.backward, o.timer)
    accelX = accelX + dx
    accelY = accelY + dy
    accelZ = accelZ + dz

    PopulateFlightDebug(state, debug, accelX, accelY, accelZ)

    -- Apply accelerations to the current velocity
    accelX = accelX * deltaTime
    accelY = accelY * deltaTime
    accelZ = accelZ * deltaTime

    state.vel.x = state.vel.x + accelX
    state.vel.y = state.vel.y + accelY
    state.vel.z = state.vel.z + accelZ

    state.vel = ClampVelocity(state.vel, const.maxSpeed)      -- the game gets unstable and crashes at high speed.  Probably trying to load scenes too fast, probably machine dependent

    -- Push them up if they are underwater
    if o:HasHeadUnderwater() then
        state.vel.z = math.max(state.vel.z, -o.pos.z)
    end

    -- Turn velocity
    if not IsNearZero(keyYaw) then
        local velX, velY = RotateVector2D(state.vel.x, state.vel.y, keyYaw * math.pi / 180)
        state.vel.x = velX
        state.vel.y = velY

        state.quickSwivel_startTime = o.timer
    end

    -- Pull velocity direction toward direction facing (and vice versa)
    local lookYaw = RotateVelocity_Horizontal(o, state, const, deltaTime)

    RotateVelocity_Vertical(o.lookdir_forward, state.vel, const.percent_towardCamera_vert, deltaTime)

    -- Commit the point
    local newPos = Vector4.new(o.pos.x + (state.vel.x * deltaTime), o.pos.y + (state.vel.y * deltaTime), o.pos.z + (state.vel.z * deltaTime), 1)

    local isSafe, isHorzHit, isVertHit = IsTeleportPointSafe(o.pos, newPos, state.vel, deltaTime, o)

    if isSafe then
        Process_InFlight_NewPos(o, newPos, lookYaw, state, const)
    else
        Process_InFlight_HitWall(state.vel, isHorzHit, isVertHit, state, o.timer)
    end

    -- See if cruise control speed should be adjusted
    AdjustMinSpeed(o, state, const, keys)
end

---------------------------------------- Private Methods ----------------------------------------

function ExitFlight(state, debug)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if (not state) or (not state.isInFlight) then
        do return end
    end

    state.isInFlight = false
    state.kdash:Clear()
    state.lasercats:Stop()

    RemoveFlightDebug(debug)
end

function PopulateFlightDebug(state, debug, accelX, accelY, accelZ)
    --TODO: Report high level stats

    --  num shots fired
    --  num actual ray casts
    --  num hits

    --  current hit count
    debug.hitstorage = state.rayHitStorage.points:GetCount()

    debug.accelX = Round(accelX, 1)
    debug.accelY = Round(accelY, 1)
    debug.accelZ = Round(accelZ, 1)

    debug.vel2 = vec_str(state.vel)
    debug.speed2 = Round(GetVectorLength(state.vel), 1)
end
function RemoveFlightDebug(debug)
    debug.hitstorage = nil
    debug.accelX = nil
    debug.accelY = nil
    debug.accelZ = nil
    debug.vel2 = nil
    debug.speed2 = nil
end
