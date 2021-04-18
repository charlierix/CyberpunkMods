-- This is a small transition period between flight and standard.  It lets off of
-- antigravity linearly so that antigravity to standard gravity isn't so abrupt
function Process_AntiGrav(o, player, state, const, debug, deltaTime)


    if not antigrav then
        print("**antigrav is nil")

        if not state then
            print("**state is nil")
        elseif not state.grapple then
            print("**state.grapple is nil")
        elseif not state.grapple.anti_gravity then
            print("**state.grapple.anti_gravity is nil")
        end
    end


    -- Doing a standard recovery rate
    state.energy = RecoverEnergy(state.energy, player.energy_tank.max_energy, player.energy_tank.recovery_rate, deltaTime)

    if SwitchedFlightMode(o, player, state, const) then
        do return end
    end

    if not IsAirborne(o) then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    local antigrav = state.grapple.anti_gravity



    if not antigrav then
        print("antigrav is nil")

        if not state then
            print("state is nil")
        elseif not state.grapple then
            print("state.grapple is nil")
        elseif not state.grapple.anti_gravity then
            print("state.grapple.anti_gravity is nil")
        end
    end



    local elapsed = o.timer - state.startTime
    if elapsed > antigrav.fade_duration then
        Transition_ToStandard(state, const, debug, o)
        do return end
    end

    -- Figure out standard amount of antigravity
    local accel_z = GetAntiGravity(antigrav, true)

    -- Reduce based on elapsed time
    accel_z = accel_z * GetScaledValue(1, 0, 0, antigrav.fade_duration, elapsed)

    -- Apply the acceleration
    o.player:GrapplingHook_AddImpulse(0, 0, accel_z * deltaTime)
end