function Process_InFlight_Red(o, state, const, mode, keys, debug, deltaTime)
    debug.time_flying_idle = o.timer - state.lastThrustTime

    -- if ShouldSafetyFire(o, mode) then       -- even though redscript won't kill on impact, it still plays pain and stagger animations on hard landings
    --     ExitFlight(state, debug, o)
    --     if mode.explosiveLanding then
    --         ExplosivelyLand(o, o.vel)
    --     end
    --     SafetyFire(o)
    --     do return end
    -- end

    local safetyFireHit = GetSafetyFireHitPoint(o, o.pos, o.vel.z, mode, deltaTime)     -- even though redscript won't kill on impact, it still plays pain and stagger animations on hard landings
    if safetyFireHit then
        local velZ = o.vel.z        -- saving this, because safety fire will set the velocity to zero

        ExitFlight(state, debug, o)

        SafetyFire(o, safetyFireHit)

        if mode.explosiveLanding then
            ExplosivelyLand(o, velZ, state)
        end
        do return end
    end

    if ShouldExitFlight(o, state, true) then        -- not checking for explosive landing, because it would be foolish to want explosive landing and no safety
        ExitFlight(state, debug, o)
        do return end
    end

    -- Convert key presses into acceleration, energy burn
    local accelX, accelY, accelZ, requestedEnergy = GetAccel_Keys(state, mode, o)

    -- Right Mouse Button (rmb holding altitude, rmb extra accel in look dir, rmb slam down...)
    if mode.rmb_extra then
        local rmbX, rmbY, rmbZ, rmbEnergy = mode.rmb_extra:Tick(o, o.vel, keys, state)
        accelX = accelX + rmbX
        accelY = accelY + rmbY
        accelZ = accelZ + rmbZ
        requestedEnergy = requestedEnergy + rmbEnergy
    end

    -- Calculate actual burn
    requestedEnergy = requestedEnergy * deltaTime

    if (requestedEnergy > 0) and (requestedEnergy < state.remainBurnTime) then
        state.lastThrustTime = o.timer
        state.remainBurnTime = UseBurnTime(state.remainBurnTime, requestedEnergy, state.startThrustTime, o.timer)
    else
        accelX = 0
        accelY = 0
        accelZ = 0

        state.remainBurnTime = RecoverBurnTime(state.remainBurnTime, mode.maxBurnTime, mode.energyRecoveryRate, deltaTime)
    end

    -- Handle gravity when different from standard
    -- NOTE: When charge legs get reused mid flight, they mess with gravity
    accelZ = accelZ + 16 + mode.accel_gravity

    -- Drag near max velocity
    local dragX, dragY, dragZ = ClampVelocity_Drag(o.vel, const.maxSpeed)
    accelX = accelX + dragX
    accelY = accelY + dragY
    accelZ = accelZ + dragZ

    if const.shouldShowDebugWindow then
        PopulateFlightDebug(state, debug, accelX, accelY, accelZ)
    end

    accelX = accelX * deltaTime
    accelY = accelY * deltaTime
    accelZ = accelZ * deltaTime

    local actual = o.player:Jetpack_AddImpulse(accelX, accelY, accelZ)
    debug.actual = vec_str(actual)
end