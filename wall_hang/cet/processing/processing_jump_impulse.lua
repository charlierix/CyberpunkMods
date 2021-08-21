function Process_Jump_Impulse(o, vars, const, debug)
    o.player:WallHang_AddImpulse(vars.impulse.x, vars.impulse.y, vars.impulse.z)

    Transition_ToStandard(vars, const, debug, o)
end