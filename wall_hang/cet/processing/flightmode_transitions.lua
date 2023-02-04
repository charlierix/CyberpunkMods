-- This can come from any state back to standard
function Transition_ToStandard(vars, const, debug, o, relatch)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if vars.flightMode == const.flightModes.standard then
        do return end
    end

    if relatch then
        vars.startStopTracker:SetRelatchTime(relatch)
    end

    vars.relatch = nil

    vars.flightMode = const.flightModes.standard
    o:Custom_CurrentlyFlying_Clear()

    if vars.is_sliding or vars.is_attracting then
        vars.is_sliding = false
        vars.is_attracting = false
        PossiblyStopSound(o, vars, true)      -- there are cases where they will slide, then touch the ground.  But the slide sound keeps playing for a couple seconds
    end
end

function Transition_ToHang(vars, const, debug, o, hangPos, normal, from_slide)
    if not o:Custom_CurrentlyFlying_TryStartFlight(true, nil) then
        Transition_ToStandard(vars, const, debug, o, nil)
        do return end
    end

    vars.flightMode = const.flightModes.hang

    vars.hangPos = hangPos
    vars.normal = normal

    vars.startStopTracker:EnteringHang()

    if from_slide then
        PlaySound_Hang_Soft(vars, o)
    else
        PlaySound_Hang_Hard(vars, o)
    end
end

function Transition_ToJump_Calculate(vars, const, debug, o, hangPos, normal, jump_settings, startStopTracker)
    if not o:Custom_CurrentlyFlying_TryStartFlight(true, nil) then
        Transition_ToStandard(vars, const, debug, o, nil)
        do return end
    end

    vars.flightMode = const.flightModes.jump_calculate

    startStopTracker:ResetHangLatch()

    vars.hangPos = hangPos
    vars.normal = normal
    vars.jump_settings = jump_settings
end

function Transition_ToJump_TeleTurn(vars, const, debug, o, impulse, final_lookdir, relatch)
    if not o:Custom_CurrentlyFlying_TryStartFlight(true, nil) then
        Transition_ToStandard(vars, const, debug, o, nil)
        do return end
    end

    vars.flightMode = const.flightModes.jump_teleturn

    vars.impulse = impulse
    vars.final_lookdir = final_lookdir
    vars.relatch = relatch

    PlaySound_Jump(vars, o, const)
end

function Transition_ToJump_Impulse(vars, const, debug, o, impulse, from_teleturn, relatch)
    if not o:Custom_CurrentlyFlying_TryStartFlight(true, nil) then
        Transition_ToStandard(vars, const, debug, o, nil)
        do return end
    end

    vars.flightMode = const.flightModes.jump_impulse

    vars.impulse = impulse
    vars.relatch = relatch

    if not from_teleturn then
        PlaySound_Jump(vars, o, const)
    end
end