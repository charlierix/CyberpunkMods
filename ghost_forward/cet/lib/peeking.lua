local this = {}

function StartPeeking(o, vars, const)
    vars.isPeeking = true
    vars.peekingStartTime = o.timer

    if not const.shouldAnimatePeek then
        -- no animation, so just set it to the max immediately
        o:SetLocalCamPosition(Vector4.new(0, const.peekDistance, 0, 1))
    end

    this.StartSound(o, vars)
end

function ContinuePeeking(o, vars, const)
    if o.timer - vars.peekingStartTime < const.peekTime then
        local percent = this.GetPeekDistPercent(o.timer - vars.peekingStartTime, const.peekTime)

        if const.shouldAnimatePeek then
            local offset = const.peekDistance * percent

            o:SetLocalCamPosition(Vector4.new(0, offset, 0, 1))
        end

        --this.ContinueSound(o, vars, percent)
    else
        vars.isPeeking = false

        o:SetLocalCamPosition(Vector4.new(0, 0, 0, 1))

        this.StopSound(o, vars)
    end
end

----------------------------------- Private Methods -----------------------------------

-- This creates a plateau whose edges are a gaussian curve
function this.GetPeekDistPercent(elapsedTime, totalTime)
    if (elapsedTime < 0) or (elapsedTime > totalTime) then
        return 0
    end

    local scaledTime = elapsedTime / totalTime

    if scaledTime <= 0.5 then
        return this.GetPeekDistPercent_Calc(scaledTime)
    else
        return this.GetPeekDistPercent_Calc(1 - scaledTime)
    end
end

-- Scaled must be from 0 to .5
function this.GetPeekDistPercent_Calc(scaled)
    -- 144 has it near zero at scaled time of .2 (then subtracting from 1 puts the percent at 1)
    return 1 - math.exp(-144 * scaled * scaled)
end

this.hum =
{
    "amb_bl_ext_border_crossing_neon_light_07",     -- these are good, but they're still too quiet
    "amb_g_city_el_neon_mid_10_pulsing",
    "amb_g_city_el_neon_mid_13",
    "amb_bl_ext_border_crossing_neon_light_04",

    -- too quiet
    --"amb_bl_ext_ghost_town_neon_003",
    --"amb_bl_ext_roadhouse_town_neon_light_02",
    --"amb_bl_g_neon_hum_close_med_16",
    --"amb_bl_g_neon_hum_close_med_27",
    --"amb_g_city_el_neon_high_04_pulsing",
    --"amb_bl_ext_ghost_town_power_cables",
    --"amb_bl_int_farm_electrical_box",
}

this.eerie =
{
    -- these are really good, but take too long to get to the good parts
    "amb_bl_int_school_corridor",
    "amb_int_tunnel_01_add_on_enter",
}

this.gasp =
{
    -- there are a bunch of choking sounds.  That would be funny for peek (would need to break the list into male/female)
    "q004_sc_04a_female_scared_rev",
    "ono_animals_f_death_lastbreath_set_01",
    "ono_animals_f_death_lastbreath_set",
    "ono_animals_m_death_lastbreath_set",
    "ono_generic_f_death_lastbreath_set_01",
    "sq023_sc_10_breath_loop",
}

this.other =
{
    --"vfx_fullscreen_discharge_connector_activate",

    "dev_drone_wyvern_default_investigate_scan_start",
    "dev_drone_wyvern_default_investigate_scan_red_start",
    --"dev_drone_wyvern_default_investigate_scan_red_stop",

    --"q115_piano_note_long_Ds2",
    "q003_sc_02_light_movement_02",

    -- "w_cyb_whip_wire_charge_intro",
    -- "w_cyb_nano_wobble",
}

-- this.breath_in = "q201_sc_07_ice_v_breath_in"        -- these take too long
-- this.breath_out = "q201_sc_07_ice_v_breath_out"

--this.currentSound = nil

function this.StartSound(o, vars)
    if this.currentSound then
        o:StopSound(this.currentSound)
    end

    --TODO: Default to hum, with small random chance of others

    this.currentSound = this.GetRandomSound(this.hum)

    o:PlaySound(this.currentSound, vars)        --NOTE: passing vars will allow the global StopSound to kill it if this instance stop never runs (and forces only one sound to play if they teleport mid peek)
end
function this.ContinueSound(o, vars, percent)
    -- if not this.currentSound then
    --     do return end
    -- end

    -- if percent > 0.5 and this.currentSound == this.breath_in then
    --     o:StopSound(this.currentSound)
    --     o:PlaySound(this.breath_out, vars)
    -- end
end
function this.StopSound(o, vars)
    if this.currentSound then
        o:StopSound(this.currentSound)
    end
end

function this.GetRandomSound(list)
    return list[math.random(#list)]
end