function ExitFlight(state, const, debug, o)
    state.flightMode = const.flightModes.standard
    o:Set_Custom_IsFlying(false)

    state.startStopTracker:ResetKeyDowns()

    -- remove mappin

end
