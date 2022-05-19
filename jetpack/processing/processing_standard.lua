local this = {}

local isAirborne_standard = nil
local isAirborne_extended = nil

-- This is called each tick when they aren't in flight (just walking around)
-- Timer has already been updated and it's verified that they aren't in a vehicle
-- or in the menu
function Process_Standard(o, vars, mode, const, debug, deltaTime)
    vars.remainBurnTime = RecoverBurnTime(vars.remainBurnTime, mode.energy.maxBurnTime, mode.energy.recoveryRate, deltaTime)

    if not const.isEnabled then
        do return end       -- the user has explicitly disabled jetpack
    end

    isAirborne_standard = nil
    isAirborne_extended = nil

    if this.ShouldReboundJump(o, vars, mode) then
        local rebound_impulse = GetReboundImpulse(mode, vars.stop_flight_velocity)
        this.TryActivateFlight(o, vars, mode, rebound_impulse)

    elseif vars.thrust.isDown and (vars.thrust.downDuration > mode.jump_land.holdJumpDelay) then
        this.TryActivateFlight(o, vars, mode, nil)

    elseif o:Custom_CurrentlyFlying_IsOwnerOrNone() then
        local safetyFireHit = GetSafetyFireHitPoint(o, o.pos, o.vel.z, mode, deltaTime)     -- even though redscript won't kill on impact, it still plays pain and stagger animations on hard landings
        if safetyFireHit then
            SafetyFire(o, safetyFireHit)
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function this.TryActivateFlight(o, vars, mode, rebound_impulse)
    -- Only activate flight if it makes sense based on whether other mod may be flying
    local can_start, velocity = o:Custom_CurrentlyFlying_TryStartFlight(true, o.vel)

    if can_start then
        this.ActivateFlight(o, vars, mode, velocity, rebound_impulse)
    end
end

function this.ActivateFlight(o, vars, mode, velocity, rebound_impulse)
    -- Time to activate flight mode (flying will occur next tick)
    vars.isInFlight = true
    vars.startThrustTime = o.timer
    vars.lastThrustTime = o.timer

    if rebound_impulse then
        vars.last_rebound_time = o.timer
        o:PlaySound("lcm_player_double_jump", vars)
    else
        vars.last_rebound_time = nil
    end

    if not mode.useRedscript then
        -- Once teleporting occurs, o.vel will be zero, so vars.vel holds a copy that gets updated by accelerations
        vars.vel = velocity

        -- Running into a case where the thruster kicks in slightly after the player starts
        -- falling after the top of their jump.  The first thing that happens in the next update
        -- is ShouldExitFlight() returns true because Z velocity is negative and they are close
        -- to the ground
        --
        -- This can be fixed by activating sooner, but that creates a risk of firing too easily,
        -- which could cause a CTD if they are in the menu, braindance, etc
        --
        -- So instead, just clamp the z velocity if it's not too negative
        if (vars.vel.z > -2) and (vars.vel.z < 0) then
            vars.vel.z = 0
        end
    end

    AdjustTimeSpeed(o, vars, mode, velocity)

    -- A couple extras to do when jumping from the ground
    this.ActivateFlight_Extras(o, vars, mode, rebound_impulse)
end

function this.ActivateFlight_Extras(o, vars, mode, rebound_impulse)
    if mode.jump_land.explosiveJumping then
        this.EnsureIsAirBorneCalled(o, false)
        if not isAirborne_standard then
            ExplosivelyJump(o)
        end
    end

    local impulse_x = 0
    local impulse_y = 0
    local impulse_z = nil

    if rebound_impulse then
        impulse_x, impulse_y = this.ReboundHorizontalImpulse(o, vars, mode)
        impulse_z = rebound_impulse       -- isAirBorne was already checked when deciding to set the rebound

    elseif mode.accel.vert_initial then
        this.EnsureIsAirBorneCalled(o, false)
        if not isAirborne_standard then
            impulse_z = mode.accel.vert_initial
        end
    end

    if impulse_z then
        if mode.useRedscript then
            impulse_z = impulse_z - o.vel.z     -- jump is 5.66
            o:AddImpulse(impulse_x, impulse_y, impulse_z)
        else
            vars.vel.x = vars.vel.x + impulse_x
            vars.vel.y = vars.vel.y + impulse_y
            vars.vel.z = vars.vel.z + impulse_z     -- cet based flight looks at existing velocity, so no need to apply acceleration, just directly increase the velocity
        end
    end
end

function this.ShouldReboundJump(o, vars, mode)
    if not mode.rebound then
        return false        -- this mode doesn't have a rebound
    end

    if vars.should_rebound_redscript then
        vars.should_rebound_redscript = false
        return true
    end

    if o.timer - vars.thrust.downTime > 0.07 then
        return false        -- they haven't pressed jump in a while
    end

    if not vars.stop_flight_time then
        return false        -- they haven't used jetpack yet
    end

    if o.timer - vars.stop_flight_time > 0.2 then
        return false        -- been out of flight too long
    end

    if not vars.stop_flight_velocity or vars.stop_flight_velocity.z > 0 then
        return false
    end

    this.EnsureIsAirBorneCalled(o, true)
    if isAirborne_extended then
        return false        -- not standing on the ground (or very near the ground)
    end

    return true
end

-- Rebounding from momentarily standing on the ground has a chance to zero out the velocity.  Compares current
-- velocity x,y with stop flight's
function this.ReboundHorizontalImpulse(o, vars, mode)
    if not vars.stop_flight_velocity then
        return 0, 0
    end

    local velocity
    if mode.useRedscript then
        velocity = o.vel
    else
        velocity = vars.vel
    end

    -- This is a bit crude.  The idea is if they came in with some horizontal velocity and the safety fire set
    -- that to zero, the rebound will need to get that velocity back.  But if they also momentarily pushed ASDW
    -- while rebound jumping, that will override what the horizontal velocity is
    local x = 0
    if math.abs(velocity.x) > math.abs(vars.stop_flight_velocity.x) then
        x = velocity.x
    else
        x = vars.stop_flight_velocity.x
    end

    local y = 0
    if math.abs(velocity.y) > math.abs(vars.stop_flight_velocity.y) then
        y = velocity.y
    else
        y = vars.stop_flight_velocity.y
    end

    return x, y
end

-- This check is potentially needed in several places, but the raycast should only be done once in a frame
function this.EnsureIsAirBorneCalled(o, is_extended_look)
    if is_extended_look then
        if isAirborne_extended == nil then
            isAirborne_extended = IsAirborne(o, true)

            if isAirborne_extended then
                isAirborne_standard = true      -- might as well set this, might save a few raycasts
            end
        end
    else
        if isAirborne_standard == nil then
            isAirborne_standard = IsAirborne(o, false)

            if not isAirborne_standard then
                isAirborne_extended = false
            end
        end
    end
end