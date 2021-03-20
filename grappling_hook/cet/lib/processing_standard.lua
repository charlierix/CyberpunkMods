function Process_Standard(o, state, const, deltaTime)

    -- Recover energy


    local pull, rigid = state.startStopTracker:ShouldGrapple()

    if pull or rigid then
        state.startStopTracker:ResetKeyDowns()
        state.startAimTime = o.timer

        -- Set a global flag to tell that flight is being overidden

    end

    if pull then
        state.flightMode = const.flightModes.aim_pull
    elseif rigid then
        state.flightMode = const.flightModes.aim_rigid
    end
end