local this = {}

-- This can come from any state back to standard
function Transition_ToStandard(vars, const, debug, o)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if vars.flightMode == const.flightModes.standard then
        do return end
    end

    vars.flightMode = const.flightModes.standard
    o:Custom_CurrentlyFlying_Clear()
end

function Transition_ToHang(vars, const, o, hangPos, normal, material)
    vars.flightMode = const.flightModes.hang
    o:Custom_CurrentlyFlying_StartFlight()

    vars.hangPos = hangPos
    vars.normal = normal
    vars.material = material

    PlaySound_Hang(vars, o)
end

function Transition_ToJump_Calculate(vars, const, o, hangPos, normal, material)
    vars.flightMode = const.flightModes.jump_calculate
    o:Custom_CurrentlyFlying_StartFlight()

    vars.hangPos = hangPos
    vars.normal = normal
    vars.material = material

    PlaySound_Jump(vars, o)
end

function Transition_ToJump_TeleTurn(vars, const, o, impulse, final_lookdir)
    vars.flightMode = const.flightModes.jump_teleturn
    o:Custom_CurrentlyFlying_StartFlight()

    vars.impulse = impulse
    vars.final_lookdir = final_lookdir
end

function Transition_ToJump_Impulse(vars, const, o, impulse)
    vars.flightMode = const.flightModes.jump_impulse
    o:Custom_CurrentlyFlying_StartFlight()

    vars.impulse = impulse
end