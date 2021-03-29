function ShouldExitFlight(o, state, isRedscript)
    -- Even if they are close to the ground, if they are actively under thrust, then they shouldn't
    -- exit flight
    --
    -- If it's flown exclusively in CET, then also need to make sure that velocity is up, or they
    -- might clip through the ground
    if state.thrust.isDown and (state.remainBurnTime > 0.1) and (isRedscript or state.vel.z >= 0) then
        return false
    end

    -- See if they are in water
    if o:HasHeadUnderwater() then
        return true
    end

    -- See if they are too close to the ground
    --TODO: This is too simplistic.  It's only dangerous when z is large negative
    --LowFlyingV has a better check
    if not IsAirborne(o) then
        return true
    end

    -- If they have been airborne, but haven't used thrust for quite a while, then exit airborne state
    -- This would be extra benefitial in case the airborne state is in error (while driving, swimming, etc)
    if (o.timer - state.lastThrustTime) > 8 then
        return true
    end

    return false;
end

-- This will return true as long as there is some air below the player
function IsAirborne(o)
    -- can't look too far down, or it won't be possible to jump into flight mode, but if it doesn't look down
    -- far enough, the player will clip into the floor

    -- only if down velocity is high


    return o:IsPointVisible(o.pos, Vector4.new(o.pos.x, o.pos.y, o.pos.z - 1, 1))
end

function UseBurnTime(remainBurnTime, requestedEnergy, startThrustTime, timer)
    if timer - startThrustTime < 0.4 then
        -- Burn fuel very slowly at first.  In modes like realism, fuel feels like it's
        -- being wasted in the beginning.  It would be easy to just add more fuel capacity,
        -- but this will make it feel like you're flying before the fuel gauge goes down
        return remainBurnTime - (requestedEnergy * 0.05)
    else
        return remainBurnTime - requestedEnergy
    end
end

function RecoverBurnTime(current, max, recoverRate, deltaTime)
    current = current + (recoverRate * deltaTime)

    if current > max then
        current = max
    end

    return current
end

-- This will blow people back if the impace speed is large enough
function ExplosivelyLand(o, velZ, state)
    local maxForce = 6

    local force = GetScaledValue(0, maxForce, 0, 36, -velZ)
    force = Clamp(0, maxForce, force)

    if force < 1 then       -- don't bother for soft landings
        do return end
    end

    local radius = GetScaledValue(3, 9, 0, maxForce, force)

    o:RagdollNPCs_ExplodeOut(radius, force, force * 0.75)

    if force < 4 then
        o:PlaySound("v_col_player_impact", state)
    else
        o:PlaySound("v_mbike_dst_crash_fall", state)
    end
end

function ClampVelocity_Drag(vel, maxSpeed)
    local speedSqr = GetVectorLengthSqr(vel)

    local maxSpeed_min = maxSpeed * 0.75

    if speedSqr < (maxSpeed_min * maxSpeed_min) then
        return 0, 0, 0
    end

    local speed = math.sqrt(speedSqr)

    local percent = 1
    if speedSqr < (maxSpeed * maxSpeed) then
        percent = GetScaledValue(0, 1, maxSpeed_min, maxSpeed, speed)
    end

    -- max accel will be maxSpeed/6
    -- square the percent so it ramps up instead of linear climb
    local accel = GetScaledValue(0, maxSpeed / 2, 0, 1, percent * percent)

    return vel.x / speed * -accel, vel.y / speed * -accel, vel.z / speed * -accel
end

function ExitFlight(state, debug, o)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if (not state) or (not state.isInFlight) then
        do return end
    end

    state.isInFlight = false
    o:Custom_CurrentlyFlying_Clear()
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
