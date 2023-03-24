function Process_Flight_Swing(o, player, vars, const, debug, deltaTime)
    if debug_render_screen.IsEnabled() then
        local position, look_dir = o:GetCrosshairInfo()
        debug_render_screen.Add_Dot(position, nil, "BBB", nil, nil, 2, nil)
    end

    local extraaccel_x = 0      -- it looks like only one impulse can be applied per frame, so pass the boost accel in to the main function
    local extraaccel_y = 0
    local extraaccel_z = 0

    if vars.startStopTracker:IsPrevActionHeldDown() then
        -- Apply boost along look
        --local eye_pos, look_dir = o:GetCrosshairInfo()
        o:GetCamera()

        --TODO: get accel from swing props
        local ACCEL = 42



        --TODO: figure out what is keeping this from accelerating in certain cases.  Straight pulls and long swings should accelerate more than they are
        --I'm guessing the game doesn't allow impulses to exceed a speed of 20


        debug_render_screen.Add_Text2D(0.667, 0.67, "BOOSTING", nil, "C44", "FFF", nil, true)


        --TODO: this fights with the rope (or something).  works well with straight pulls, but rope negates a lot of it
        extraaccel_x = o.lookdir_forward.x * ACCEL
        extraaccel_y = o.lookdir_forward.y * ACCEL
        extraaccel_z = o.lookdir_forward.z * ACCEL

        --TODO: play a sound
    end

    if debug_render_screen.IsEnabled() then
        debug_render_screen.Add_Text2D(0.667, 0.5, "speed: " .. tostring(Round(GetVectorLength(o.vel), 1)), nil, "666", "CCC", nil, true)
    end

    Process_Flight_Straight(o, player, vars, const, debug, deltaTime, extraaccel_x, extraaccel_y, extraaccel_z)
end