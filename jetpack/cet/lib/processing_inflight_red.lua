function Process_InFlight_Red(o, vars, const, mode, keys, debug, deltaTime)
    debug.time_flying_idle = o.timer - vars.lastThrustTime

    local safetyFireHit = GetSafetyFireHitPoint(o, o.pos, o.vel.z, mode, deltaTime)     -- even though redscript won't kill on impact, it still plays pain and stagger animations on hard landings
    if safetyFireHit then
        local velZ = o.vel.z        -- saving this, because safety fire will set the velocity to zero

        ExitFlight(vars, debug, o)

        SafetyFire(o, safetyFireHit)

        if mode.explosiveLanding then
            ExplosivelyLand(o, velZ, vars)
        end
        do return end
    end

    if ShouldExitFlight(o, vars, true) then        -- not checking for explosive landing, because it would be foolish to want explosive landing and no safety
        ExitFlight(vars, debug, o)
        do return end
    end

    -- Convert key presses into acceleration, energy burn
    local accelX, accelY, accelZ, requestedEnergy = GetAccel_Keys(vars, mode, o, debug, deltaTime)

    -- Right Mouse Button (rmb holding altitude, rmb extra accel in look dir, rmb slam down...)
    if mode.rmb_extra then
        local rmbX, rmbY, rmbZ, rmbEnergy = mode.rmb_extra:Tick(o, o.vel, keys, vars)
        accelX = accelX + rmbX
        accelY = accelY + rmbY
        accelZ = accelZ + rmbZ
        requestedEnergy = requestedEnergy + rmbEnergy
    end

    -- Calculate actual burn
    requestedEnergy = requestedEnergy * deltaTime

    if (requestedEnergy > 0) and (requestedEnergy < vars.remainBurnTime) then
        vars.lastThrustTime = o.timer
        vars.remainBurnTime = UseBurnTime(vars.remainBurnTime, requestedEnergy, vars.startThrustTime, o.timer)
    else
        accelX = 0
        accelY = 0
        accelZ = 0

        vars.remainBurnTime = RecoverBurnTime(vars.remainBurnTime, mode.maxBurnTime, mode.energyRecoveryRate, deltaTime)
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
        PopulateFlightDebug(vars, debug, accelX, accelY, accelZ)
    end

    accelX = accelX * deltaTime
    accelY = accelY * deltaTime
    accelZ = accelZ * deltaTime

    local actual = o.player:Jetpack_AddImpulse(accelX, accelY, accelZ)
    debug.actual = vec_str(actual)
end