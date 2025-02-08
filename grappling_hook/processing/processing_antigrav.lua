-- This is a small transition period between flight and standard.  It lets off of
-- antigravity linearly so that antigravity to standard gravity isn't so abrupt
function Process_AntiGrav(o, player, vars, const, debug, deltaTime)
    -- Doing a standard recovery rate
    vars.energy = RecoverEnergy(vars.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate, deltaTime)

    if HasSwitchedFlightMode(o, player, vars, const, true, const.activation_key_action.Activate) then       -- antgrav is a period of freefall after grapple has ended, so a key press should kick off a new grapple
        do return end
    end

    if not IsAirborne(o) then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    local antigrav = vars.grapple.anti_gravity

    local elapsed = o.timer - vars.startTime
    if elapsed > antigrav.fade_duration then
        Transition_ToStandard(vars, const, debug, o)
        do return end
    end

    -- Figure out standard amount of antigravity
    local accel_z = GetAntiGravity(antigrav, true)

    -- Reduce based on elapsed time
    accel_z = accel_z * GetScaledValue(1, 0, 0, antigrav.fade_duration, elapsed)

    -- Apply the acceleration
    o:AddImpulse(0, 0, accel_z * deltaTime)
end