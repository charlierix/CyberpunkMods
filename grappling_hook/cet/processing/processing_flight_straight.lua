local this = {}

-- This is the primary worker method for grappling.  Conditions were set up while
-- aiming
--
-- There is an anchor point, possibly separate desired distance.  Then it's a matter
-- of applying acceleration toward desired distance with extra options for when they
-- overshoot
--
-- There's also an option to apply a separate acceleration in the direction that the
-- player is looking.  This makes it possible to control the swing, so it's not just
-- a boring straight line pull
--
-- There are a lot of different ways that a grapple could be set up.  Any actual
-- grapple config probably won't use all the acceleration types, but it's easier
-- to have a single worker method that can handle lots of possible config scenarios
function Process_Flight_Straight(o, player, vars, const, debug, deltaTime)
    -- Gain/Reduce energy.  Exit if there wasn't enough energy left
    if not this.AdjustEnergy(o, player, vars, const, deltaTime) then
        do return end
    end

    if HasSwitchedFlightMode(o, player, vars, const, true) then
        do return end
    end

    -- If they are on the ground after being airborne, then exit flight
    local shouldStop, isAirborne = ShouldStopFlyingBecauseGrounded(o, vars, true)
    if shouldStop then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    local grapple = vars.grapple       -- this will be used a lot, save a dot reference

    -- If about to hit a wall, then cancel, but only if the settings say to
    if vars.hasBeenAirborne and grapple.stop_on_wallHit and IsWallCollisionImminent(o, o.vel, deltaTime) then
        this.Transition_AntiGravOrStandard(vars, const, debug, o, grapple)
        do return end
    end

    local eye_pos, look_dir = o:GetCrosshairInfo()

    if IsAboveAnyPlane(vars.stop_planes, eye_pos) then
        this.Transition_AntiGravOrStandard(vars, const, debug, o, grapple)
        do return end
    end

    local _, _, grappleLen, grappleDirUnit = GetGrappleLine(o, vars, const)

    if grapple.stop_distance and grappleLen <= grapple.stop_distance then
        this.Transition_AntiGravOrStandard(vars, const, debug, o, grapple)
        do return end
    end

    o:GetCamera()

    if grapple.minDot and (DotProduct3D(o.lookdir_forward, grappleDirUnit) < grapple.minDot) then
        -- They looked too far away
        this.Transition_AntiGravOrStandard(vars, const, debug, o, grapple)
        do return end
    end

    -- Calculate accelerations
    local accel_x, accel_y, accel_z = GetAccel_GrappleStraight(o, vars, grapple, grappleLen, grappleDirUnit, o.vel)

    local antigrav_z = GetAntiGravity(grapple.anti_gravity, isAirborne)     -- cancel gravity

    accel_x = accel_x * deltaTime
    accel_y = accel_y * deltaTime
    accel_z = (accel_z + antigrav_z) * deltaTime

    -- debug.accel_x = Round(accel_x / deltaTime, 1)
    -- debug.accel_y = Round(accel_y / deltaTime, 1)
    -- debug.accel_z = Round(accel_z / deltaTime, 1)

    o:AddImpulse(accel_x, accel_y, accel_z)
end

----------------------------------- Private Methods -----------------------------------

function this.AdjustEnergy(o, player, vars, const, deltaTime)
    -- Recover at a reduced rate
    vars.energy = RecoverEnergy(vars.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate * player.energy_tank.flying_percent, deltaTime)

    if vars.airanchor then
        -- Reduce Energy
        -- NOTE: Still want to gain energy.  There's just the extra drain of the air anchor
        local newEnergy, isEnergyEmpty = ConsumeEnergy(vars.energy, vars.airanchor.energyBurnRate * (1 - vars.airanchor.burnReducePercent), deltaTime)

        if isEnergyEmpty then
            vars.animation_lowEnergy:ActivateAnimation()
            Transition_ToStandard(vars, const, debug, o)
            return false
        else
            vars.energy = newEnergy
        end
    end

    return true
end

function this.Transition_AntiGravOrStandard(vars, const, debug, o, grapple)
    if grapple.anti_gravity then
        Transition_ToAntiGrav(vars, const, o)
    else
        Transition_ToStandard(vars, const, debug, o)
    end
end