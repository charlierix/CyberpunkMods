function Process_Aim_Pull(o, state, const, debug)
    if state.startStopTracker:ShouldStop() then
        ExitFlight(state, const, debug, o)
        do return end
    end



end

function Process_Aim_Rigid(o, state, const, debug)
    if state.startStopTracker:ShouldStop() then
        ExitFlight(state, const, debug, o)
        do return end
    end





end