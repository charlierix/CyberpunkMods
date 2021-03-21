function Process_Standard(o, state, const, deltaTime)

    --TODO: Recover energy


    local pull, rigid = state.startStopTracker:ShouldGrapple()

    if pull then
        Transition_ToAim(state, o, const.flightModes.aim_pull)
    elseif rigid then
        Transition_ToAim(state, o, const.flightModes.aim_rigid)
    end
end