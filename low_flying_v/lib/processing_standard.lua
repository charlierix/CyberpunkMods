-- This is called each tick when they aren't in flight (just walking around)
-- Timer has already been updated and it's verified that they aren't in a vehicle
-- or in the menu
function Process_Standard(o, vars, keys, debug)
    if keys.forceFlight then
        EnterFlight(o, vars)
        do return end
    end

    vars.kdash:StoreInputs(o.timer, keys.forward and not keys.prev_forward, keys.jump and not keys.prev_jump, keys.rmb and not keys.prev_rmb)
    if vars.kdash:WasKDashPerformed(o.timer, o.vel, debug) then
        EnterFlight(o, vars)
        do return end
    end
end

function EnterFlight(o, vars)
    vars.isInFlight = true
    vars.vel = o.vel
    vars.startFlightTime = o.timer
    vars.lowSpeedTime = nil
    vars.minSpeedOverride_start = -1000
end