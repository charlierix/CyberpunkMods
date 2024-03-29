--https://wiki.cybermods.net/cyber-engine-tweaks/functions/systems/audiosystem
--https://codeberg.org/adamsmasher/cyberpunk
--https://discord.com/channels/717692382849663036/795037494106128434/932024396321804319

-- These are what will play.  Change the list and reload all mods to update
-- Copy from the FilterCNames tool.  Just keep searching, playing, searching, playing until
-- you find what you're looking for
function GetPlayList()
    return
    {
        "dev_confession_booth_confessing",
        "dev_doors_hidden_stop",
        "dev_doors_v_room_secret_close",
        "dev_doors_v_room_secret_open",
        "dev_screen_glitch_distraction",
        "dev_surveillance_camera_detect",
        "dev_vending_machine_can_falls",
        "dev_vending_machine_processing",
        "enm_mech_minotaur_loco_fs_heavy",
        "g_sc_bd_rewind_pause",
        "g_sc_bd_rewind_pause_forced",
        "g_sc_bd_rewind_play",
        "g_sc_bd_rewind_restart",
        "gre_impact_solid",
        "gre_impact_solid_ozob",
        "grenade_charge_1s",
        "grenade_charge_start",
        "grenade_laser_stop",
        "grenade_stick",
        "lcm_player_double_jump",
        "lcm_wallrun_in",
        "lcm_wallrun_out",
        "q003_sc_03_ui_deal_virus",
        "q115_thruster_start",
        "q115_thruster_stop",
        "test_ad_emitter_2_1",
        "ui_focus_mode_scanning_qh",
        "ui_focus_mode_scanning_qh_done",
        "ui_focus_mode_zooming_in_enter",
        "ui_focus_mode_zooming_in_exit",
        "ui_focus_mode_zooming_in_step_change",
        "ui_generic_set_14_positive",
        "ui_gmpl_stealth_detection",
        "ui_hacking_access_denied",
        "ui_hacking_access_granted",
        "ui_hacking_close",
        "ui_jingle_car_call",
        "ui_jingle_chip_malfunction",
        "ui_jingle_vehicle_arrive",
        "ui_loading_bar",
        "ui_loading_bar_start",
        "ui_loading_bar_stop",
        "ui_loot_additional",
        "ui_loot_ammo",
        "ui_loot_cash_picking",
        "ui_loot_cyberware",
        "ui_loot_drink",
        "ui_loot_eat",
        "ui_loot_generic",
        "ui_loot_gun",
        "ui_loot_head",
        "ui_loot_lower_body",
        "ui_loot_melee",
        "ui_loot_rarity_epic",
        "ui_loot_rarity_legendary",
        "ui_loot_take_all",
        "ui_loot_upper_body",
        "ui_main_menu_cc_confirmation_screen_close",
        "ui_main_menu_cc_confirmation_screen_open",
        "ui_main_menu_cc_loading",
        "ui_main_menu_loop_start",
        "ui_main_menu_loop_stop",
        "ui_menu_hover",
        "ui_menu_map_timeskip",
        "ui_menu_onpress",
        "ui_menu_perk_level_up",
        "ui_menu_tutorial_close",
        "ui_menu_tutorial_open",
        "ui_phone_incoming_call",
        "ui_phone_incoming_call_positive",
        "ui_phone_incoming_call_stop",
        "ui_phone_initiation_call",
        "ui_phone_initiation_call_stop",
        "ui_phone_sms",
        "v_col_player_impact",
        "v_mbike_dst_crash_fall",
        "w_feedback_player_damage",
        "w_gre_mine_activate",

        "------------ good matches ------------",

        -- save the ones you like here

        "---------------- end ----------------",
    }
end

-- Hit reload mod to update this list
local soundsList = GetPlayList()
local currentIndex = 1

local currentlyPlaying = nil

registerHotkey("testSoundCurrent", "Play Current", function()
    StopPlayCurrentSound()
end)

registerHotkey("testSoundRewind", "Play Previous", function()
    currentIndex = currentIndex - 1
    if currentIndex < 1 then
        currentIndex = #soundsList
    end

    StopPlayCurrentSound()
end)

registerHotkey("testSoundAdvance", "Play Next", function()
    currentIndex = currentIndex + 1
    if currentIndex > #soundsList then
        currentIndex = 1
    end

    StopPlayCurrentSound()
end)

-- Uncomment if you want.  The way I've been using this is alt+tabbing between the game and this script, modifying
-- the top function, saving off good candidates
-- registerHotkey("testSoundPrint", "Print Current", function()
--     print(soundsList[currentIndex])
-- end)

registerForEvent("onDraw", function()
    ImGui.SetNextWindowPos(20, 200, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(1000, 100, ImGuiCond.FirstUseEver)

    local name = "Sound Clip Tester"

    if (ImGui.Begin(name)) then
		ImGui.SetWindowFontScale(2)
        ImGui.Spacing()
        ImGui.Text(soundsList[currentIndex])
    end
    ImGui.End()
end)

----------------------------------- Private Methods -----------------------------------

function StopPlayCurrentSound()
    if currentlyPlaying then
        StopSound(currentlyPlaying)
        currentlyPlaying = nil
    end

    currentlyPlaying = soundsList[currentIndex]
    PlaySound(currentlyPlaying)
end

function PlaySound(name)
    local audioEvent = SoundPlayEvent.new()
    audioEvent.soundName = name
    Game.GetPlayer():QueueEvent(audioEvent)
end
function StopSound(name)
    local audioEvent = SoundStopEvent.new()
    audioEvent.soundName = name
    Game.GetPlayer():QueueEvent(audioEvent)
end