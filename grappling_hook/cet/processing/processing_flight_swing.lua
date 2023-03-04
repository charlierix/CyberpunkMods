function Process_Flight_Swing(o, player, vars, const, debug, deltaTime)
    if debug_render_screen.IsEnabled() then
        local position, look_dir = o:GetCrosshairInfo()
        debug_render_screen.Add_Dot(position, nil, "BBB", nil, 2, nil)
    end

    Process_Flight_Straight(o, player, vars, const, debug, deltaTime)
end