function PopulateDebug(debug, o, keys, state)
    debug.inFlight = state.isInFlight
    -- debug.inFlight_c = o:Get_Custom_IsFlying()
    -- debug.supressFall = o:Get_Custom_SuppressFalling()

    debug.pos = vec_str(o.pos)
    debug.vel = vec_str(o.vel)
    --debug.yaw = Round(o.yaw, 0)

    if o.vel then
        debug.speed = tostring(Round(GetVectorLength(o.vel), 1))
    end

    -- debug.key_forward = keys.forward
    -- debug.key_backward = keys.backward
    -- debug.key_left = keys.left
    -- debug.key_right = keys.right
    -- debug.key_jump = keys.jump
    -- debug.key_rmb = keys.rmb
    -- debug.mouse_x = keys.mouse_x

    debug.timer = Round(o.timer, 1)
end

----------- some other potential sounds:
-- -- jetpack
-- --"gre_impact_solid",					-- a bit too recongnisable
-- --"gre_impact_solid_ozob",
-- "grenade_charge_start",
-- "grenade_laser_stop",					-- a good acknowledgement sound
-- "grenade_stick",						    -- probably not
-- --"lcm_player_double_jump",				-- too recognisable

-- "lcm_wallrun_in",

-- "q115_thruster_start",
-- "q115_thruster_stop",					-- good for jetpack, but kind of obnoxious


-- -- soft, subtle
-- "dev_doors_v_room_secret_close",		    -- nice and quiet, mechanical
-- "lcm_wallrun_out",						-- this is really nice and subtle
-- "ui_generic_set_14_positive",
-- "ui_menu_hover",
-- "ui_menu_tutorial_close",


-- -- stronger
-- --"dev_doors_v_room_secret_open",		-- pretty long
-- "dev_vending_machine_can_falls",		    -- another short mechanical sound
-- "enm_mech_minotaur_loco_fs_heavy",		-- good heavy landing


-- -- ui
-- "g_sc_bd_rewind_pause",					-- almost sounds like an error
-- "g_sc_bd_rewind_pause_forced",
-- "g_sc_bd_rewind_play",					-- also sounds like an error
-- --"g_sc_bd_rewind_restart",				-- this is a good grapple extend sound
-- --"test_ad_emitter_2_1",					-- good confirm tone

-- "ui_focus_mode_scanning_qh",
-- "ui_focus_mode_zooming_in_enter",
-- "ui_focus_mode_zooming_in_exit",
-- "ui_focus_mode_zooming_in_step_change",

-- -- "ui_main_menu_cc_confirmation_screen_close",
-- -- "ui_main_menu_cc_confirmation_screen_open",
-- -- "ui_main_menu_cc_loading",
-- -- "ui_main_menu_loop_start",
-- -- "ui_main_menu_loop_stop",
