function Process_InFlight_CET(o, vars, const, mode, keys, debug, deltaTime)

    debug.time_flying_idle = o.timer - vars.lastThrustTime

    if ShouldExitFlight(o, vars, false) then
        if mode.explosiveLanding and not IsAirborne(o) then
            ExplosivelyLand(o, vars.vel, vars)
        end

        ExitFlight(vars, debug, o)
    else
        -- Convert key presses into acceleration, energy burn
        local accelX, accelY, accelZ, requestedEnergy = GetAccel_Keys(vars, mode, o)

        -- Right Mouse Button (rmb holding altitude, rmb extra accel in look dir, rmb slam down...)
        if mode.rmb_extra then
            local rmbX, rmbY, rmbZ, rmbEnergy = mode.rmb_extra:Tick(o, vars.vel, keys, vars)
            accelX = accelX + rmbX
            accelY = accelY + rmbY
            accelZ = accelZ + rmbZ
            requestedEnergy = requestedEnergy + rmbEnergy
        end

        local deltaYaw = keys.mouse_x * -0.08

        -- Calculate actual burn
        requestedEnergy = requestedEnergy * deltaTime

        if (requestedEnergy > 0) and (requestedEnergy < vars.remainBurnTime) then
            vars.lastThrustTime = o.timer
            vars.remainBurnTime = UseBurnTime(vars.remainBurnTime, requestedEnergy, vars.startThrustTime, o.timer)
        else
            accelX = 0
            accelY = 0
            accelZ = mode.accel_gravity

            vars.remainBurnTime = RecoverBurnTime(vars.remainBurnTime, mode.maxBurnTime, mode.energyRecoveryRate, deltaTime)
        end

        -- Drag near max velocity
        local dragX, dragY, dragZ = ClampVelocity_Drag(vars.vel, const.maxSpeed)
        accelX = accelX + dragX
        accelY = accelY + dragY
        accelZ = accelZ + dragZ

        if const.shouldShowDebugWindow then
            PopulateFlightDebug(vars, debug, accelX, accelY, accelZ)
        end

        accelX = accelX * deltaTime
        accelY = accelY * deltaTime
        accelZ = accelZ * deltaTime

        -- Apply accelerations to the current velocity
        vars.vel.x = vars.vel.x + accelX
        vars.vel.y = vars.vel.y + accelY
        vars.vel.z = vars.vel.z + accelZ

        vars.vel = ClampVelocity(vars.vel, const.maxSpeed)      -- the game gets unstable and crashes at high speed.  Probably trying to load scenes too fast, probably machine dependent

        RotateVelocityToLookDir(o, mode, vars, deltaTime, debug)

        -- Try to move in the desired velocity (raycast first)
        local newPos = Vector4.new(o.pos.x + (vars.vel.x * deltaTime), o.pos.y + (vars.vel.y * deltaTime), o.pos.z + (vars.vel.z * deltaTime), 1)

        local isSafe, isHorzHit, isVertHit = IsTeleportPointSafe(o.pos, newPos, vars.vel, deltaTime, o)

        if isSafe then
            Process_InFlight_NewPos(o, newPos, deltaYaw)
        else
            Process_InFlight_HitWall(vars.vel, isHorzHit, isVertHit)
        end
    end
end
