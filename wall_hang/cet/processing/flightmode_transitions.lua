-- This can come from any state back to standard
function Transition_ToStandard(vars, const, debug, o)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if vars.flightMode == const.flightModes.standard then
        do return end
    end

    vars.flightMode = const.flightModes.standard
    o:Custom_CurrentlyFlying_Clear()

    if vars.is_sliding or vars.is_attracting then
        vars.is_sliding = false
        vars.is_attracting = false
        StopSound(o, vars, true)      -- there are cases where they will slide, then touch the ground.  But the slide sound keeps playing for a couple seconds
    end
end

function Transition_ToHang(vars, const, o, hangPos, normal, from_slide)
    vars.flightMode = const.flightModes.hang
    o:Custom_CurrentlyFlying_StartFlight()

    vars.hangPos = hangPos
    vars.normal = normal

    if from_slide then
        PlaySound_Hang_Soft(vars, o)
    else
        PlaySound_Hang_Hard(vars, o)
    end
end

function Transition_ToJump_Calculate(vars, const, o, hangPos, normal, startStopTracker)
    vars.flightMode = const.flightModes.jump_calculate
    o:Custom_CurrentlyFlying_StartFlight()

    startStopTracker:ResetHangLatch()

    vars.hangPos = hangPos
    vars.normal = normal
end

function Transition_ToJump_TeleTurn(vars, const, o, impulse, final_lookdir)
    vars.flightMode = const.flightModes.jump_teleturn
    o:Custom_CurrentlyFlying_StartFlight()

    vars.impulse = impulse
    vars.final_lookdir = final_lookdir

    PlaySound_Jump(vars, o)
end

function Transition_ToJump_Impulse(vars, const, o, impulse, from_teleturn)
    vars.flightMode = const.flightModes.jump_impulse
    o:Custom_CurrentlyFlying_StartFlight()

    vars.impulse = impulse

    if not from_teleturn then
        PlaySound_Jump(vars, o)
    end
end