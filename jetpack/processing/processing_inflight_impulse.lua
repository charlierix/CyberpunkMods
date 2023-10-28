local this = {}

function Process_InFlight_Impulse(o, vars, const, player, keys, debug, deltaTime)
    debug.time_flying_idle = o.timer - vars.lastThrustTime

    if ShouldReboundJump_InFlight(o, vars, player.mode) then
        -- There's something about landing that eats impulses.  Just let the landing finish and standard processing can do the rebound
        this.PrepForRebound(o, vars, player, debug)
        do return end
    end

    local safetyFireHit = GetSafetyFireHitPoint(o, o.pos, o.vel.z, player.mode, deltaTime)     -- even though impulse based won't kill on impact, it still plays pain and stagger animations on hard landings
    if safetyFireHit then
        this.SafetyFire(o, vars, player, debug, safetyFireHit)
        do return end
    end

    if ShouldExitFlight(o, vars, player.mode, deltaTime) then        -- not checking for explosive landing, because it would be foolish to want explosive landing and no safety
        ExitFlight(vars, debug, o, player)
        do return end
    end

    this.Accelerate(o, vars, const, player.mode, keys, debug, deltaTime)
end

----------------------------------- Private Methods -----------------------------------

function this.PrepForRebound(o, vars, player, debug)
    vars.should_rebound_impulse = true

    if player.mode.jump_land.explosiveLanding then
        ExplosivelyLand(o, o.vel.z, vars)
    end

    ExitFlight(vars, debug, o, player, true)

    o:Teleport(o.pos, o.yaw)        -- don't let the player slam into the ground (teleporting zeros out velocity).  This needs to be called after exit flight so it can remember the current velocity
end

function this.SafetyFire(o, vars, player, debug, safetyFireHit)
    local velZ = o.vel.z        -- saving this, because safety fire will set the velocity to zero

    ExitFlight(vars, debug, o, player)

    SafetyFire(o, safetyFireHit)

    if player.mode.jump_land.explosiveLanding then
        ExplosivelyLand(o, velZ, vars)
    end
end

function this.Accelerate(o, vars, const, mode, keys, debug, deltaTime)
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

        vars.remainBurnTime = RecoverBurnTime(vars.remainBurnTime, mode.energy.maxBurnTime, mode.energy.recoveryRate, deltaTime)
    end

    -- Handle gravity when different from standard
    -- NOTE: When charge legs get reused mid flight, they mess with gravity
    accelZ = accelZ + 16 + mode.accel.gravity

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

    o:AddImpulse(accelX, accelY, accelZ)
end