function Process_Flight(o, player, state, const, debug, deltaTime)

    if o.timer - state.startTime > 4 then
        Transition_ToStandard(state, const, debug, o)
    end



end