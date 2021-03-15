-- This is called each tick when they aren't in flight (just walking around)
-- Timer has already been updated and it's verified that they aren't in a vehicle
-- or in the menu
function Process_Standard(o, state, mode, keys, debug, deltaTime)
    state.remainBurnTime = RecoverBurnTime(state.remainBurnTime, mode.maxBurnTime, mode.energyRecoveryRate, deltaTime)

    if o:Get_Custom_IsFlying() then
        -- Another mod is currently flying.  Don't interfere
        do return end
    end

    --if state.thrust.isDown and (state.thrust.downDuration > 0.37) then
    if state.thrust.isDown and (state.thrust.downDuration > mode.holdJumpDelay) then
        -- Time to activate flight mode (flying will occur next tick)
        state.isInFlight = true
        o:Set_Custom_IsFlying(true)
        --o:Set_Custom_SuppressFalling(mode.useRedscript and mode.shouldSafetyFire)
        state.startThrustTime = o.timer
        state.lastThrustTime = o.timer

        if not mode.useRedscript then
            -- Once teleporting occurs, o.vel will be zero, so state.vel holds a copy that gets updated by accelerations
            state.vel = o.vel

            -- Running into a case where the thruster kicks in slightly after the player starts
            -- falling after the top of their jump.  The first thing that happens in the next update
            -- is ShouldExitFlight() returns true because Z velocity is negative and they are close
            -- to the ground
            --
            -- This can be fixed by activating sooner, but that creates a risk of firing too easily,
            -- which could cause a CTD if they are in the menu, braindance, etc
            --
            -- So instead, just clamp the z velocity if it's not too negative
            if (state.vel.z > -2) and (state.vel.z < 0) then
                state.vel.z = 0
            end
        end

        if (mode.timeSpeed > 0) and (not IsNearValue(mode.timeSpeed, 1)) then
            o:SetTimeDilation(mode.timeSpeed)
        end

        o:PlaySound("ui_menu_tutorial_close", state)      -- could also use "q115_thruster_start" or "q115_thruster_stop", but that would get old quick.  This is also good, but not quite right "lcm_wallrun_out"
    else
        local safetyFireHit = GetSafetyFireHitPoint(o, o.pos, o.vel.z, mode, deltaTime)     -- even though redscript won't kill on impact, it still plays pain and stagger animations on hard landings
        if safetyFireHit then
            SafetyFire(o, safetyFireHit)
        end
    end
end
