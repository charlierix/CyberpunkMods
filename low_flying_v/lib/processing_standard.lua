-- This is called each tick when they aren't in flight (just walking around)
-- Timer has already been updated and it's verified that they aren't in a vehicle
-- or in the menu
function Process_Standard(o, state, keys, debug)
    if keys.forceFlight then
        EnterFlight(o, state)
        do return end
    end

    state.kdash:StoreInputs(o.timer, keys.forward, keys.jump, keys.rmb)
    if state.kdash:WasKDashPerformed(o.timer, o.vel, debug) then
        EnterFlight(o, state)
        do return end
    end


    --TODO: Detect if they are about to die from falling and config says to save them


end

function EnterFlight(o, state)
    state.isInFlight = true
    state.vel = o.vel
    state.startFlightTime = o.timer
    state.lowSpeedTicks = 0
    state.minSpeedOverride_start = -1000
end