SoundsThrusting = {}

local this = {}

-- Plays sounds while they are using thrust (jump, directions, hover)
-- It's difficult to have something named like this and not make jokes :)
function SoundsThrusting:new(o, keys, horz_analog, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.keys = keys
    obj.horz_analog = horz_analog
    obj.const = const

    obj.isHovering = false

    obj.sound_type = nil        -- this is one of these enum values: const.thrust_sound_type

    obj.thrust1 = nil
    obj.thrust2 = nil

    obj.maneuver = nil

    obj.hover = nil

    return obj
end

function SoundsThrusting:Tick(isInFlight)
    if not isInFlight then
        self:StopAll()
        do return end
    end

    -- Jump
    if self.keys.jump then
        self:Ensure_Playing("thrust1", this.GetSound_Thrust1)
        self:Ensure_Playing("thrust2", this.GetSound_Thrust2)
    else
        self:Ensure_Stopped("thrust1")
        self:Ensure_Stopped("thrust2")
    end

    -- Maneuver
    if self.horz_analog.analog_len > 0.5 then
        self:Ensure_Playing("maneuver", this.GetSound_Maneuver)
    else
        self:Ensure_Stopped("maneuver")
    end

    -- Hover
    if self.isHovering then
        self:Ensure_Playing("hover", this.GetSound_Hover)
    else
        self:Ensure_Stopped("hover")
    end
end

-- Each thrust mode could have a different set of sounds
function SoundsThrusting:ModeChanged(sound_type)
    self.sound_type = sound_type
end

-- Makes sure all sounds are stopped
function SoundsThrusting:StopAll()
    self:Ensure_Stopped("thrust1")
    self:Ensure_Stopped("thrust2")
    self:Ensure_Stopped("maneuver")
    self:Ensure_Stopped("hover")
end

function SoundsThrusting:StartHover()
    self.isHovering = true
end
function SoundsThrusting:StopHover()
    self.isHovering = false
end

----------------------------------- Private Methods -----------------------------------

--NOTE: get_sound is a delegate to one of the this.GetSound_xxx functions
function SoundsThrusting:Ensure_Playing(name, get_sound)
    if not self[name] then
        self[name] = get_sound(self.sound_type, self.const)

        if self[name] then
            self.o:PlaySound(self[name])
        end
    end
end
function SoundsThrusting:Ensure_Stopped(name)
    if self[name] then
        self.o:StopSound(self[name])
        self[name] = nil
    end
end

function this.GetRandomSound(list)
    return list[math.random(#list)]
end

function this.GetSound_Thrust1(sound_type, const)
    if sound_type == const.thrust_sound_type.steam then
        return "amb_g_fx_steam_small_03_loop"

    elseif sound_type == const.thrust_sound_type.steam_quiet then
        return "amb_g_fx_steam_small_01_loop"

    elseif sound_type == const.thrust_sound_type.levitate then
        return "dev_fan_factory_18_jet_low_quiet"

    elseif sound_type == const.thrust_sound_type.jump then
        return "lcm_wallrun_out"

    else        -- const.thrust_sound_type.silent
        return nil
    end
end
function this.GetSound_Thrust2(sound_type, const)
    if sound_type == const.thrust_sound_type.steam then
        return "grenade_incendiary_fire"

    elseif sound_type == const.thrust_sound_type.steam_quiet then
        return nil

    elseif sound_type == const.thrust_sound_type.levitate then
        return nil

    elseif sound_type == const.thrust_sound_type.jump then
        return nil

    else        -- const.thrust_sound_type.silent
        return nil
    end
end
function this.GetSound_Maneuver(sound_type, const)
    if sound_type == const.thrust_sound_type.steam then
        return "amb_g_fx_steam_small_01_loop"

    elseif sound_type == const.thrust_sound_type.steam_quiet then
        return "amb_g_fx_steam_small_02_loop"

    elseif sound_type == const.thrust_sound_type.levitate then
        return nil

    elseif sound_type == const.thrust_sound_type.jump then
        return nil

    else        -- const.thrust_sound_type.silent
        return nil
    end
end
function this.GetSound_Hover(sound_type, const)
    if sound_type == const.thrust_sound_type.steam then
        return this.GetRandomSound(this.hover_sounds)

    elseif sound_type == const.thrust_sound_type.steam_quiet then
        return nil

    elseif sound_type == const.thrust_sound_type.levitate then
        return nil

    elseif sound_type == const.thrust_sound_type.jump then
        return nil

    else        -- const.thrust_sound_type.silent
        return nil
    end
end

this.hover_sounds =
{
    "v_car_archer_hella_traffic_engine_loop",
    "amb_bl_ext_ghost_town_power_cables",
    "amb_bl_int_ghost_town_power_station_room_powered",
}

---------- Other thruster candidates ----------
-- "w_tail_shotgun_power_testera_ext_narrow",
-- "amb_g_fx_fire_flames_stream_start_loop",        -- there are only two sounds, and it regularly switches between them
-- "w_tail_shotgun_power_testera_ext_enclosed",

-- "w_tail_shotgun_power_testera_ext_street",
-- "w_tail_shotgun_power_testera_ext_open",
-- "w_tail_shotgun_power_testera_ext_street_wide",
-- "w_tail_shotgun_power_testera_ext_wide",

-- "q115_thruster_start",
-- "q115_thruster_stop",

-- "amb_g_fx_fire_gas_big_01_far_loop",
-- "amb_g_fx_fire_gas_big_01_loop",
-- "amb_g_fx_fire_flames_stream_loop",
-- "amb_bl_ext_oilfield_barracks_fire",     -- close, a bit too much spark popping
-- "sq028_sc_06_boat_fire_big",



---------- Other hover candidates ----------
-- "amb_bl_ext_ghost_town_power_station_structure_02",      -- good, maybe too busy

-- "amb_bl_ext_ghost_town_power_station_structure_01",      -- a bit too much

-- "amb_g_fx_flare_loop",
-- "q101_sc_07_surgery_lamp_hum_loop",
-- "q001_sc_00c_trauma_arrives_intro_av_engines_loop",

-- "amb_g_fx_steam_small_02_loop",      -- too similar to the others

-- "amb_bl_ext_border_crossing_neon_light_02",      -- you can tell it's a light
-- "amb_bl_ext_border_crossing_neon_light_03",

-- "amb_bl_int_raffen_shiv_camp_neon_light_01",     -- too weak
--"amb_bl_loc_sts_bla_ina_04_neon_light_01",        -- too weak



----------- some other potential sounds:
-- -- jetpack
-- --"gre_impact_solid",                    -- a bit too recongnisable
-- --"gre_impact_solid_ozob",
-- "grenade_charge_start",
-- "grenade_laser_stop",                    -- a good acknowledgement sound
-- "grenade_stick",                         -- probably not
-- --"lcm_player_double_jump",              -- too recognisable

-- "lcm_wallrun_in",

-- "q115_thruster_start",
-- "q115_thruster_stop",                    -- good for jetpack, but kind of obnoxious


-- -- soft, subtle
-- "dev_doors_v_room_secret_close",         -- nice and quiet, mechanical
-- "lcm_wallrun_out",                       -- this is really nice and subtle
-- "ui_generic_set_14_positive",
-- "ui_menu_hover",
-- "ui_menu_tutorial_close",


-- -- stronger
-- --"dev_doors_v_room_secret_open",        -- pretty long
-- "dev_vending_machine_can_falls",         -- another short mechanical sound
-- "enm_mech_minotaur_loco_fs_heavy",       -- good heavy landing


-- -- ui
-- "g_sc_bd_rewind_pause",                  -- almost sounds like an error
-- "g_sc_bd_rewind_pause_forced",
-- "g_sc_bd_rewind_play",                   -- also sounds like an error
-- --"g_sc_bd_rewind_restart",              -- this is a good grapple extend sound
-- --"test_ad_emitter_2_1",                 -- good confirm tone

-- "ui_focus_mode_scanning_qh",
-- "ui_focus_mode_zooming_in_enter",
-- "ui_focus_mode_zooming_in_exit",
-- "ui_focus_mode_zooming_in_step_change",

-- -- "ui_main_menu_cc_confirmation_screen_close",
-- -- "ui_main_menu_cc_confirmation_screen_open",
-- -- "ui_main_menu_cc_loading",
-- -- "ui_main_menu_loop_start",
-- -- "ui_main_menu_loop_stop",