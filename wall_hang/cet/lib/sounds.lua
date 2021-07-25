local this = {}

function PlaySound_Hang(vars, o)
    local sound = this.GetRandomSound(this.sounds_hang)
    o:PlaySound(sound, vars)
end

function PlaySound_Jump(vars, o)
    o:PlaySound("lcm_player_double_jump", vars)
end

----------------------------------- Private Methods -----------------------------------

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
this.sounds_hang_m =
{
    "ono_generic_f_effort_short_set_01",
    "ono_generic_f_effort_short_set_02",
    "ono_maelstrom_f_effort_short_set_04",
}
this.sounds_hang_f =
{
    "ono_generic_m_effort_short_set_01",
    "ono_generic_m_effort_short_set_02",
    "ono_maelstrom_m_effort_short_set_04",
    "ono_maelstrom_m_effort_short_set_05",
}

function this.GetRandomSound(list)
    return list[math.random(#list)]
end