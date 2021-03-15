function Process_InFlight_CET(o, state, const, mode, keys, debug, deltaTime)

    debug.time_flying_idle = o.timer - state.lastThrustTime

    if ShouldExitFlight(o, state, false) then
        if mode.explosiveLanding and not IsAirborne(o) then
            ExplosivelyLand(o, state.vel, state)
        end

        ExitFlight(state, debug, o)
    else
        -- Convert key presses into acceleration, energy burn
        local accelX, accelY, accelZ, requestedEnergy = GetAccel_Keys(state, mode, o)

        -- Right Mouse Button (rmb holding altitude, rmb extra accel in look dir, rmb slam down...)
        if mode.rmb_extra then
            local rmbX, rmbY, rmbZ, rmbEnergy = mode.rmb_extra:Tick(o, state.vel, keys, state)
            accelX = accelX + rmbX
            accelY = accelY + rmbY
            accelZ = accelZ + rmbZ
            requestedEnergy = requestedEnergy + rmbEnergy
        end

        local deltaYaw = keys.mouse_x * -0.08

        -- Calculate actual burn
        requestedEnergy = requestedEnergy * deltaTime

        if (requestedEnergy > 0) and (requestedEnergy < state.remainBurnTime) then
            state.lastThrustTime = o.timer
            state.remainBurnTime = UseBurnTime(state.remainBurnTime, requestedEnergy, state.startThrustTime, o.timer)
        else
            accelX = 0
            accelY = 0
            accelZ = mode.accel_gravity

            state.remainBurnTime = RecoverBurnTime(state.remainBurnTime, mode.maxBurnTime, mode.energyRecoveryRate, deltaTime)
        end

        -- Drag near max velocity
        local dragX, dragY, dragZ = ClampVelocity_Drag(state.vel, const.maxSpeed)
        accelX = accelX + dragX
        accelY = accelY + dragY
        accelZ = accelZ + dragZ

        if const.shouldShowDebugWindow then
            PopulateFlightDebug(state, debug, accelX, accelY, accelZ)
        end

        accelX = accelX * deltaTime
        accelY = accelY * deltaTime
        accelZ = accelZ * deltaTime

        -- Apply accelerations to the current velocity
        state.vel.x = state.vel.x + accelX
        state.vel.y = state.vel.y + accelY
        state.vel.z = state.vel.z + accelZ

        state.vel = ClampVelocity(state.vel, const.maxSpeed)      -- the game gets unstable and crashes at high speed.  Probably trying to load scenes too fast, probably machine dependent

        RotateVelocityToLookDir(o, mode, state, deltaTime, debug)

        -- Try to move in the desired velocity (raycast first)
        local newPos = Vector4.new(o.pos.x + (state.vel.x * deltaTime), o.pos.y + (state.vel.y * deltaTime), o.pos.z + (state.vel.z * deltaTime), 1)

        local isSafe, isHorzHit, isVertHit = IsTeleportPointSafe(o.pos, newPos, state.vel, deltaTime, o)

        if isSafe then
            Process_InFlight_NewPos(o, newPos, deltaYaw)
        else
            Process_InFlight_HitWall(state.vel, isHorzHit, isVertHit)
        end
    end
end

function ExitFlight(state, debug, o)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if (not state) or (not state.isInFlight) then
        do return end
    end

    state.isInFlight = false
    o:Set_Custom_IsFlying(false)
    --o:Set_Custom_SuppressFalling(false)
    state.lastThrustTime = 0
    state.startThrustTime = 0
    o:SetTimeDilation(0)        -- 0 is invalid, which fully sets time to normal

    RemoveFlightDebug(debug)
end

function PopulateFlightDebug(state, debug, accelX, accelY, accelZ)
    debug.accelX = Round(accelX, 1)
    debug.accelY = Round(accelY, 1)
    debug.accelZ = Round(accelZ, 1)

    debug.vel2 = vec_str(state.vel)
    debug.speed2 = Round(GetVectorLength(state.vel), 1)
end
function RemoveFlightDebug(debug)
    debug.accelX = nil
    debug.accelY = nil
    debug.accelZ = nil
    debug.vel2 = nil
    debug.speed2 = nil
    debug.time_flying_idle = nil
end
