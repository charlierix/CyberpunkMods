local this = {}

-- This is called each tick when they aren't in flight (just walking around)
-- Timer has already been updated and it's verified that they aren't in a vehicle
-- or in the menu
function Process_Standard(o, vars, mode, const, debug, deltaTime)
    vars.remainBurnTime = RecoverBurnTime(vars.remainBurnTime, mode.maxBurnTime, mode.energyRecoveryRate, deltaTime)

    if not const.isEnabled then
        do return end       -- the user has explicitly disabled jetpack
    end

    if vars.thrust.isDown and (vars.thrust.downDuration > mode.holdJumpDelay) then
        -- Only activate flight if it makes sense based on whether other mod may be flying
        local can_start, velocity = o:Custom_CurrentlyFlying_TryStartFlight(true, o.vel)

        if can_start then
            this.ActivateFlight(o, vars, mode, velocity)
        end

    elseif o:Custom_CurrentlyFlying_IsOwnerOrNone() then
        local safetyFireHit = GetSafetyFireHitPoint(o, o.pos, o.vel.z, mode, deltaTime)     -- even though redscript won't kill on impact, it still plays pain and stagger animations on hard landings
        if safetyFireHit then
            SafetyFire(o, safetyFireHit)
        end
    end
end

------------------------------------ Private Methods ----------------------------------

function this.ActivateFlight(o, vars, mode, velocity)
    -- Time to activate flight mode (flying will occur next tick)
    vars.isInFlight = true
    vars.startThrustTime = o.timer
    vars.lastThrustTime = o.timer

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

    if mode.timeSpeed > 0 and not IsNearValue(mode.timeSpeed, 1) then
        o:SetTimeDilation(mode.timeSpeed)
    end

    -- A couple extras to do when jumping from the ground
    if mode.accel_vert_initial or mode.explosiveJumping then
        if not IsAirborne(o) then
            if mode.accel_vert_initial then
                o:AddImpulse(0, 0, mode.accel_vert_initial)
            end

            if mode.explosiveJumping then
                ExplosivelyJump(o)
            end
        end
    end
end