local this = {}

function PlaySound_Hang_Soft(vars, o)
    local sound = this.GetRandomSound(this.sounds_hang_soft)
    o:PlaySound(sound, vars)
end
function PlaySound_Hang_Hard(vars, o)
    local sound = this.GetRandomSound(this.sounds_hang)
    o:PlaySound(sound, vars)
end

function PlaySound_Jump(vars, o)
    o:PlaySound("lcm_player_double_jump", vars)
end

function PlaySound_Slide(vars, o)
    local sound = this.GetRandomSound(this.sounds_slide)
    o:PlaySound(sound, vars)
end

function PlaySound_Attract(vars, o)
    local sound = this.GetRandomSound(this.sounds_attract)
    o:PlaySound(sound, vars)
end

----------------------------------- Private Methods -----------------------------------

this.sounds_hang_soft =
{
    "cmn_generic_work_tap_button",
    "global_cyberspace_shoulder_tap",
    "q001_sc_04_tap_hand",
    "w_gun_pistol_toygun_mag_tap",
}

this.sounds_hang =
{
    "q103_sc_06b_panam_fist_bump",
    "w_bul_impact_cardboard",
    "w_bul_impact_paper",
    "w_bul_impact_styrofoam",
    "w_cyb_mantis_impact_debris",

    --"v_car_dst_fx_impact_debris_wood",
}

-- These are an option if
this.sounds_hang_f =
{
    "ono_generic_f_effort_short_set_01",
    "ono_generic_f_effort_short_set_02",
    "ono_maelstrom_f_effort_short_set_04",
}
this.sounds_hang_m =
{
    "ono_generic_m_effort_short_set_01",
    "ono_generic_m_effort_short_set_02",
    "ono_maelstrom_m_effort_short_set_04",
    "ono_maelstrom_m_effort_short_set_05",
}

this.sounds_slide =
{
    "lcm_fs_additional_carpet_slide",
    "lcm_fs_additional_metal_grating_slide",
    "lcm_fs_additional_metal_hollow_slide",
    "lcm_fs_additional_metal_tin_slide",

    --"lcm_fs_additional_concrete_slide",       -- too high pitch
    --"lcm_fs_additional_glass_slide",
    --"lcm_fs_additional_linoleum_slide",
}

this.sounds_attract =
{
    "amb_g_fx_steam_dark_tense_02_loop",

    -- "sq025_delamain_warehouse_electricity_01",       -- sort of works, but doesn't seem right
    -- "sq025_delamain_warehouse_electricity_02",
    -- "sq025_delamain_warehouse_electricity_03",
    -- "sq025_delamain_warehouse_electricity_04",
    -- "sq025_delamain_warehouse_electricity_05",
    -- "sq025_delamain_warehouse_electricity_06",

    --"amb_g_city_el_electr_holotree_02",       -- too quiet
    --"vfx_fullscreen_electrocuted_start",      -- too busy

    --"ph_dst_electronics_sparks_strong",
}

--"cs_crowd_riots_loop",        -- this is a good long, loud sound to test with

function this.GetRandomSound(list)
    return list[math.random(#list)]
end