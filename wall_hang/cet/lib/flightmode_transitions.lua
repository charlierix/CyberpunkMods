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

function Transition_ToHang(vars, const, hangPos, normal, material)
    vars.flightMode = const.flightModes.hang

    vars.hangPos = hangPos
    vars.normal = normal
    vars.material = material


    --TODO: Tell the input tracker to reset jump


end