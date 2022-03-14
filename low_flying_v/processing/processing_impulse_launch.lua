function Process_ImpulseLaunch(o, vars, keys, debug, const)
    if keys.forceFlight or not o:Custom_CurrentlyFlying_Update(o.vel) then
        Transition_ToStandard(vars, debug, o, const)
        do return end
    end

    if(o.timer - vars.startFlightTime > 0.3) then
        -- Enough time has passed.  Switch to powered flight
        Transition_ToFlight(o, vars, debug, const)
    end
end