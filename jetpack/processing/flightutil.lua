local this = {}

function ShouldExitFlight(o, vars, isRedscript, idletime_override)
    -- Even if they are close to the ground, if they are actively under thrust, then they shouldn't
    -- exit flight
    --
    -- If it's flown exclusively in CET, then also need to make sure that velocity is up, or they
    -- might clip through the ground
    if vars.thrust.isDown and (vars.remainBurnTime > 0.1) and (isRedscript or vars.vel.z >= 0) then
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
    if not idletime_override then
        idletime_override = 8
    end

    if (o.timer - vars.lastThrustTime) > idletime_override then
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

-- This will knock people over that are near the player
function ExplosivelyJump(o)
    RagdollNPCs_ExplodeOut(4, 1.5, 3, o, true)      -- imploding slightly
end

-- This will blow people back if the impact speed is large enough
function ExplosivelyLand(o, velZ, vars)
    local maxForce = 9

    local force = GetScaledValue(0, maxForce, 0, 36, -velZ)
    force = Clamp(0, maxForce, force)

    if force < 1 then       -- don't bother for soft landings
        do return end
    end

    local radius = GetScaledValue(5, 12, 0, maxForce, force)

    RagdollNPCs_ExplodeOut(radius, force, force * 0.75, o)

    if force < 4 then
        o:PlaySound("v_col_player_impact", vars)
    else
        o:PlaySound("v_mbike_dst_crash_fall", vars)
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

function AdjustTimeSpeed(o, vars, mode, velocity)

    --TODO: Setting time dialation also slows the player's movements down (and gun).  Figure out how to set them independently

    --[error] Function 'SetTimeDilationOnLocalPlayerZero' requires from 2 to 6 parameter(s)
    --Game.GetTimeSystem():SetTimeDilationOnLocalPlayerZero(true)

    ----- This may fix the player, but the gun still fires slow:
    -- keanuWheeze — 11/18/2021
    -- You can do Game.GetTimeSystem():SetTimeDilationOnLocalPlayerZero(true) (What psiberx posted earlier), to make the time speed change not affect the player. If you want the player to be slowed down as well, then idk tbh:PES_SadShrug:        

    ----- This was an attempt to fix the fire rate
    -- MrBounty — 11/19/2021
    -- It's work ! Thx, you sick genius ! Just missed one Game. it's Game.GetStatsSystem():AddModifier(Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), 'AttachmentSlots.WeaponRight'):GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CycleTime, gameStatModifierType.Multiplier, slowMoFact))


    --Game.GetStatsSystem():AddModifier(Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), 'AttachmentSlots.WeaponRight'):GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CycleTime, gameStatModifierType.Multiplier, slowMoFact))




    if mode.timeSpeed then
        if mode.timeSpeed > 0 and not IsNearValue(mode.timeSpeed, 1) and (not vars.cur_timeSpeed or mode.timeSpeed ~= vars.cur_timeSpeed) then
            vars.cur_timeSpeed = mode.timeSpeed
            o:SetTimeDilation(mode.timeSpeed)
        end

    elseif mode.timeSpeed_gradient then
        local timeSpeed = this.GetGradientTimeSpeed(math.abs(velocity.z), mode.timeSpeed_gradient)

        if not vars.cur_timeSpeed or not IsNearValue(timeSpeed, vars.cur_timeSpeed) then
            vars.cur_timeSpeed = timeSpeed
            o:SetTimeDilation(timeSpeed)
        end
    end
end

function ExitFlight(vars, debug, o)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if (not vars) or (not vars.isInFlight) then
        do return end
    end

    vars.isInFlight = false
    o:Custom_CurrentlyFlying_Clear()
    vars.lastThrustTime = 0
    vars.startThrustTime = 0
    o:SetTimeDilation(0)        -- 0 is invalid, which fully sets time to normal
    vars.cur_timeSpeed = nil
    vars.sounds_thrusting:StopAll()

    RemoveFlightDebug(debug)
end

function PopulateFlightDebug(vars, debug, accelX, accelY, accelZ)
    debug.accelX = Round(accelX, 1)
    debug.accelY = Round(accelY, 1)
    debug.accelZ = Round(accelZ, 1)

    debug.vel2 = vec_str(vars.vel)
    debug.speed2 = Round(GetVectorLength(vars.vel), 1)
end
function RemoveFlightDebug(debug)
    debug.accelX = nil
    debug.accelY = nil
    debug.accelZ = nil
    debug.vel2 = nil
    debug.speed2 = nil
    debug.time_flying_idle = nil
end

----------------------------------- Private Methods -----------------------------------

function this.GetGradientTimeSpeed(abs_z, timeSpeed_gradient)
    if abs_z <= timeSpeed_gradient.lowZSpeed then
        return timeSpeed_gradient.timeSpeed_lowZSpeed

    elseif abs_z >= timeSpeed_gradient.highZSpeed then
        return timeSpeed_gradient.timeSpeed_highZSpeed

    else
        return GetScaledValue(timeSpeed_gradient.timeSpeed_lowZSpeed, timeSpeed_gradient.timeSpeed_highZSpeed, timeSpeed_gradient.lowZSpeed, timeSpeed_gradient.highZSpeed, abs_z)
    end
end