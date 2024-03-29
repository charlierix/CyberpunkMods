local this = {}

function ShouldExitFlight(o, vars, mode, deltaTime)
    -- If they just initiated a rebound, then let them fly
    if vars.last_rebound_time and o.timer - vars.last_rebound_time < 0.2 then
        return false
    end

    -- Even if they are close to the ground, if they are actively under thrust, then they shouldn't
    -- exit flight
    --
    -- If it's flown exclusively teleports, then also need to make sure that velocity is up, or they
    -- might clip through the ground
    -- NOTE: It was originally only doing that z>=0 check for teleport, but there shouldn't be any harm
    -- in also doing that for impulse
    local vel_z
    if mode.useImpulse then
        vel_z = o.vel.z
    else
        vel_z = vars.vel.z
    end

    -- Only skip if thrust has been down when it started on the ground and no more than a second
    if vars.thrust.isDown and vars.remainBurnTime > 0.1 and vars.thrust.started_on_ground and vars.thrust.downTime < 0.5 and vel_z >= 0 then
        return false
    end

    -- See if they are in water
    if o:HasHeadUnderwater() then
        return true
    end

    -- See if they are too close to the ground
    if this.IsNearGround(o, vars, mode, deltaTime) then
        return true
    end

    -- If they have been airborne, but haven't used thrust for quite a while, then exit airborne state
    -- This would be extra benefitial in case the airborne state is in error (while driving, swimming, etc)
    if (o.timer - vars.lastThrustTime) > 16 then
        return true
    end

    return false;
end

-- This will return true as long as there is some air below the player
function IsAirborne(o, is_extended_look)
    -- can't look too far down, or it won't be possible to jump into flight mode, but if it doesn't look down
    -- far enough, the player will clip into the floor

    -- only if down velocity is high

    local dist = 1
    if is_extended_look then
        dist = 2
    end

    local from = Vector4.new(o.pos.x, o.pos.y, o.pos.z + 0.1, 1)
    local to = Vector4.new(from.x, from.y, from.z - dist - 0.1, 1)

    return o:IsPointVisible(from, to)
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

    --TODO: look for events that could be triggered
    -- In this mod, they are increasing tweakdb values:
    --  https://www.nexusmods.com/cyberpunk2077/mods/10596

	-- TweakDB:SetFlat("Attacks.GroundSlamFar.hitReactionSeverityMax", 4) -- -1
	-- TweakDB:SetFlat("Attacks.GroundSlamFar.hitReactionSeverityMin", 4) -- 2
	-- TweakDB:SetFlat("Attacks.GroundSlamFar.range", 40) -- 10 Range

	-- TweakDB:SetFlat("Attacks.GroundSlamFarImpulse.hitReactionSeverityMax", 4) -- -1
	-- TweakDB:SetFlat("Attacks.GroundSlamFarImpulse.hitReactionSeverityMin", 4) -- -1
	-- TweakDB:SetFlat("Attacks.GroundSlamFarImpulse.range", 20) -- 6

	-- TweakDB:SetFlat("Attacks.GroundSlamFarImpulse.range", 4) -- -1
	-- TweakDB:SetFlat("Attacks.GroundSlamNear.hitReactionSeverityMin", 4) -- 3
	-- TweakDB:SetFlat("Attacks.GroundSlamNear.range", 10) -- 4

	-- TweakDB:SetFlat("Attacks.GroundSlamNearImpulse.hitReactionSeverityMax", 4) -- -1
	-- TweakDB:SetFlat("Attacks.GroundSlamNearImpulse.hitReactionSeverityMin", 4) -- -1
	-- TweakDB:SetFlat("Attacks.GroundSlamNearImpulse.range", 15) -- 1.5

	-- TweakDB:SetFlat("Attacks.GroundSlamAttack.hitReactionSeverityMax", 4) -- 3
	-- TweakDB:SetFlat("Attacks.GroundSlamAttack.hitReactionSeverityMin", 4) -- 3
	-- TweakDB:SetFlat("Attacks.GroundSlamAttack.radius", 10) -- 0
	-- TweakDB:SetFlat("Attacks.GroundSlamAttack.range", 10)-- 0

    -- also maybe this:
    -- https://www.nexusmods.com/cyberpunk2077/mods/6017





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

function ShouldReboundJump_InFlight(o, vars, mode)
    if not mode.rebound then
        return false        -- this mode doesn't have a rebound
    end

    if vars.last_rebound_time and o.timer - vars.last_rebound_time < 0.4 then
        return false        -- they just got done rebounding (conditions could look favorable for rebounding for a few frames.  Only want to rebound once)
    end

    if o.timer - vars.thrust.downTime > 0.07 then
        return false        -- they haven't pressed jump in a while
    end

    local velocity = GetVelocity(mode, vars, o)
    if velocity.z > -1 then
        return false        -- they aren't going down fast enough to rebound.  A standard jump would probably be higher
    end

    if IsAirborne(o, true) then
        return false
    end

    return true
end
function GetReboundImpulse(mode, velocity)
    local speed = math.abs(velocity.z)

    local percent = mode.rebound.percent_at_max
    if speed < mode.rebound.speed_of_max then
        percent = GetScaledValue(mode.rebound.percent_at_zero, mode.rebound.percent_at_max, 0, mode.rebound.speed_of_max, speed)
    end

    return speed * percent
end

function ClampVelocity_Drag(vel, maxSpeed)
    local speedSqr = GetVectorLengthSqr(vel)

    local maxSpeed_min = maxSpeed * 0.75

    if speedSqr < (maxSpeed_min * maxSpeed_min) then
        return 0, 0, 0
    end

    local speed = math.sqrt(speedSqr)

    local percent = 1
    if speed < maxSpeed then
        percent = GetScaledValue(0, 1, maxSpeed_min, maxSpeed, speed)
    end

    -- max accel will be maxSpeed/6
    -- square the percent so it ramps up instead of linear climb
    local accel = GetScaledValue(0, maxSpeed / 2, 0, 1, percent * percent)

    return vel.x / speed * -accel, vel.y / speed * -accel, vel.z / speed * -accel
end

function AdjustTimeDilation(o, vars, mode, velocity)
    if mode.timeDilation then
        if mode.timeDilation > 0 and not IsNearValue(mode.timeDilation, 1) and (not vars.cur_timeDilation or mode.timeDilation ~= vars.cur_timeDilation) then
            vars.cur_timeDilation = mode.timeDilation
            o:SetTimeDilation(mode.timeDilation, 1)
        end

    elseif mode.timeDilation_gradient then
        local timeDilation = this.GetGradientTimeDilation(math.abs(velocity.z), mode.timeDilation_gradient)
        timeDilation = Round(timeDilation, 2)     -- don't want to set every frame

        if not vars.cur_timeDilation or not IsNearValue(timeDilation, vars.cur_timeDilation) then
            vars.cur_timeDilation = timeDilation
            o:SetTimeDilation(timeDilation, 1)
        end
    end
end

function ExitFlight(vars, debug, o, player, keep_thrustkeys)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if (not vars) or (not vars.isInFlight) then
        do return end
    end

    vars.isInFlight = false
    o:Custom_CurrentlyFlying_Clear()
    vars.lastThrustTime = 0
    vars.startThrustTime = 0
    o:UnsetTimeDilation()
    vars.cur_timeDilation = nil
    vars.sounds_thrusting:StopAll()
    vars.stop_flight_time = o.timer

    if player and player.mode then
        vars.stop_flight_velocity = GetVelocity(player.mode, vars, o)
    else
        vars.stop_flight_velocity = o.vel
    end

    vars.last_rebound_time = nil

    if not keep_thrustkeys then
        vars.thrust:Clear()
    end

    RemoveFlightDebug(debug)
end

function GetVelocity(mode, vars, o)
    if not mode then
        return o.vel

    elseif mode.useImpulse then
        return o.vel

    else
        return vars.vel
    end
end

function PopulateFlightDebug(vars, debug, accelX, accelY, accelZ, is_impulse, deltaTime)
    debug.accelX = Round(accelX, 1)
    debug.accelY = Round(accelY, 1)
    debug.accelZ = Round(accelZ, 1)

    debug.deltaTime = tostring(deltaTime)

    if is_impulse then
        debug.accelZ_grav = Round(accelZ - 16, 1)
    end

    debug.vel2 = vec_str(vars.vel)
    debug.speed2 = Round(GetVectorLength(vars.vel), 1)
end
function RemoveFlightDebug(debug)
    debug.accelX = nil
    debug.accelY = nil
    debug.accelZ = nil
    debug.deltaTime = nil
    debug.vel2 = nil
    debug.speed2 = nil
    debug.time_flying_idle = nil
end

----------------------------------- Private Methods -----------------------------------

function this.GetGradientTimeDilation(abs_z, timeDilation_gradient)
    if abs_z <= timeDilation_gradient.lowZSpeed then
        return timeDilation_gradient.timeDilation_lowZSpeed

    elseif abs_z >= timeDilation_gradient.highZSpeed then
        return timeDilation_gradient.timeDilation_highZSpeed

    else
        return GetScaledValue(timeDilation_gradient.timeDilation_lowZSpeed, timeDilation_gradient.timeDilation_highZSpeed, timeDilation_gradient.lowZSpeed, timeDilation_gradient.highZSpeed, abs_z)
    end
end

function this.IsNearGround(o, vars, mode, deltaTime)
    local vel = GetVelocity(mode, vars, o)

    --TODO: May need to account for time dilation
    local distance = vel.z * 2.5 * deltaTime

    distance = Clamp(-999, -0.05, distance)

    return not o:IsPointVisible(o.pos, Vector4.new(o.pos.x, o.pos.y, o.pos.z + distance, 1))
end