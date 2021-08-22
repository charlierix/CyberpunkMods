-- This is called each tick when they aren't in flight (just walking around)
-- Timer has already been updated and it's verified that they aren't in a vehicle
-- or in the menu
function Process_Standard(o, vars, keys, debug, const)
    if keys.forceFlight and CheckOtherModsFor_FlightStart(o, const.modNames) then


        -- Need to skip a frame for the impulse to take effect

        --TODO: apply an arc
        --o.player:LowFlyingV_AddImpulse(0, 0, 36)


        Transition_ToFlight(o, vars, const)
        do return end
    end

    vars.kdash:StoreInputs(o.timer, keys.forward and not keys.prev_forward, keys.jump and not keys.prev_jump, keys.rmb and not keys.prev_rmb)
    if vars.kdash:WasKDashPerformed(o.timer, o.vel, debug) and CheckOtherModsFor_FlightStart(o, const.modNames) then
        Transition_ToFlight(o, vars, const)
        do return end
    end
end