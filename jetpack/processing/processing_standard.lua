local this = {}

-- This is called each tick when they aren't in flight (just walking around)
-- Timer has already been updated and it's verified that they aren't in a vehicle
-- or in the menu
function Process_Standard(o, vars, mode, const, debug, deltaTime)
    vars.remainBurnTime = RecoverBurnTime(vars.remainBurnTime, mode.energy.maxBurnTime, mode.energy.recoveryRate, deltaTime)

    if not const.isEnabled then
        do return end       -- the user has explicitly disabled jetpack
    end

    if vars.thrust.isDown and (vars.thrust.downDuration > mode.jump_land.holdJumpDelay) then
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

----------------------------------- Private Methods -----------------------------------

function this.ActivateFlight(o, vars, mode, velocity)
    -- Time to activate flight mode (flying will occur next tick)
    vars.isInFlight = true
    vars.startThrustTime = o.timer
    vars.lastThrustTime = o.timer
    vars.started_on_ground = false

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

        -- this slows the player down too
        o:SetTimeDilation(mode.timeSpeed)


        --[error] Function 'SetTimeDilationOnLocalPlayerZero' requires from 2 to 6 parameter(s)
        --Game.GetTimeSystem():SetTimeDilationOnLocalPlayerZero(true)



        ----- This may fix the player, but the gun still fires slow:
        -- keanuWheeze — 11/18/2021
        -- You can do Game.GetTimeSystem():SetTimeDilationOnLocalPlayerZero(true) (What psiberx posted earlier), to make the time speed change not affect the player. If you want the player to be slowed down as well, then idk tbh:PES_SadShrug:        




        ----- This was an attempt to fix the fire rate
        -- MrBounty — 11/19/2021
        -- It's work ! Thx, you sick genius ! Just missed one Game. it's Game.GetStatsSystem():AddModifier(Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), 'AttachmentSlots.WeaponRight'):GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CycleTime, gameStatModifierType.Multiplier, slowMoFact))


        --Game.GetStatsSystem():AddModifier(Game.GetTransactionSystem():GetItemInSlot(Game.GetPlayer(), 'AttachmentSlots.WeaponRight'):GetEntityID(), RPGManager.CreateStatModifier(gamedataStatType.CycleTime, gameStatModifierType.Multiplier, slowMoFact))

    end

    -- A couple extras to do when jumping from the ground
    if mode.accel.vert_initial or mode.jump_land.explosiveJumping then
        if not IsAirborne(o) then
            vars.started_on_ground = true

            if mode.accel.vert_initial then
                o:AddImpulse(0, 0, mode.accel.vert_initial)
            end

            if mode.jump_land.explosiveJumping then
                ExplosivelyJump(o)
            end
        end
    end
end