-- This is called each tick when they aren't in flight (just walking around)
-- Timer has already been updated and it's verified that they aren't in a vehicle
-- or in the menu
function Process_Standard(o, vars, mode, const, debug, deltaTime)
    vars.remainBurnTime = RecoverBurnTime(vars.remainBurnTime, mode.maxBurnTime, mode.energyRecoveryRate, deltaTime)

    -- See if other mods are currently in flight
    local currentlyFlying = o:Custom_CurrentlyFlying_get()

    if vars.thrust.isDown and (vars.thrust.downDuration > mode.holdJumpDelay) then
        -- Only activate flight if it makes sense based on with other mod may be flying
        if CheckOtherModsFor_FlightStart(o, currentlyFlying, const.modNames) then
            ActivateFlight(o, vars, mode)
        end

    elseif CheckOtherModsFor_SafetyFire(currentlyFlying, const.modNames) then
        local safetyFireHit = GetSafetyFireHitPoint(o, o.pos, o.vel.z, mode, deltaTime)     -- even though redscript won't kill on impact, it still plays pain and stagger animations on hard landings
        if safetyFireHit then
            SafetyFire(o, safetyFireHit)
        end
    end
end

function ActivateFlight(o, vars, mode)
    -- Time to activate flight mode (flying will occur next tick)
    vars.isInFlight = true
    o:Custom_CurrentlyFlying_StartFlight()
    vars.startThrustTime = o.timer
    vars.lastThrustTime = o.timer

    if not mode.useRedscript then
        -- Once teleporting occurs, o.vel will be zero, so vars.vel holds a copy that gets updated by accelerations
        vars.vel = o.vel

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

    if (mode.timeSpeed > 0) and (not IsNearValue(mode.timeSpeed, 1)) then
        o:SetTimeDilation(mode.timeSpeed)
    end
end
