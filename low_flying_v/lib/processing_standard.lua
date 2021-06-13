-- This is called each tick when they aren't in flight (just walking around)
-- Timer has already been updated and it's verified that they aren't in a vehicle
-- or in the menu
function Process_Standard(o, vars, keys, debug)
    if keys.forceFlight then
        EnterFlight(o, vars)
        do return end
    end

    vars.kdash:StoreInputs(o.timer, keys.forward, keys.jump, keys.rmb)
    if vars.kdash:WasKDashPerformed(o.timer, o.vel, debug) then
        EnterFlight(o, vars)
        do return end
    end


    --TODO: Detect if they are about to die from falling and config says to save them


end

function EnterFlight(o, vars)
    vars.isInFlight = true
    vars.vel = o.vel
    vars.startFlightTime = o.timer
    vars.lowSpeedTicks = 0
    vars.minSpeedOverride_start = -1000
end