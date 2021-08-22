function Transition_ToStandard(vars, debug, o, const)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if not vars or not vars.flightMode == const.flightModes.standard then
        do return end
    end

    vars.flightMode = const.flightModes.standard
    o:Custom_CurrentlyFlying_Clear()

    vars.kdash:Clear()
    vars.lasercats:Stop()
end

function Transition_ToImpulseLaunch(o, vars, const)
    vars.flightMode = const.flightModes.impulse_launch
    o:Custom_CurrentlyFlying_StartFlight()

    vars.startFlightTime = o.timer
end

function Transition_ToFlight(o, vars, const)
    vars.flightMode = const.flightModes.flying
    o:Custom_CurrentlyFlying_StartFlight()

    vars.vel = o.vel
    vars.startFlightTime = o.timer
    vars.lowSpeedTime = nil
    vars.minSpeedOverride_start = -1000
end