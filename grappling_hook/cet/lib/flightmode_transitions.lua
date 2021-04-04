-- This can come from any state back to standard (the other mods called this ExitFlight)
function Transition_ToStandard(state, const, debug, o)
    state.flightMode = const.flightModes.standard
    o:Custom_CurrentlyFlying_Clear()

    state.startStopTracker:ResetKeyDowns()

    EnsureMapPinRemoved(state, o)
end
