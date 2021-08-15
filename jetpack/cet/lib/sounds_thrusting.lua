SoundsThrusting = {}

local this = {}

-- Plays sounds while they are using thrust (jump, directions, hover)
-- It's difficult to have something named like this and not make jokes :)
function SoundsThrusting:new(o, keys, horz_analog, isQuiet)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.keys = keys
    obj.horz_analog = horz_analog

    if isQuiet then
        obj.cname_thrust1 = "amb_g_fx_steam_small_01_loop"
        obj.cname_thrust2 = nil
        obj.cname_maneuver = "amb_g_fx_steam_small_02_loop"
    else
        obj.cname_thrust1 = "amb_g_fx_steam_small_03_loop"
        obj.cname_thrust2 = "grenade_incendiary_fire"
        obj.cname_maneuver = "amb_g_fx_steam_small_01_loop"
    end

    obj.isHovering = false

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
        self:Ensure_Playing("thrust1", self.cname_thrust1)
        if self.cname_thrust2 then
            self:Ensure_Playing("thrust2", self.cname_thrust2)
        end
    else
        self:Ensure_Stopped("thrust1")
        self:Ensure_Stopped("thrust2")
    end

    -- Maneuver
    if self.horz_analog.analog_len > 0.5 then
        self:Ensure_Playing("maneuver", self.cname_maneuver)
    else
        self:Ensure_Stopped("maneuver")
    end

    -- Hover
    if self.isHovering then
        self:Ensure_Playing("hover", this.GetRandomSound(this.hover_sounds))
    else
        self:Ensure_Stopped("hover")
    end
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

function SoundsThrusting:Ensure_Playing(name, sound)
    if not self[name] then
        self[name] = sound
        self.o:PlaySound(self[name])
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

this.hover_sounds =
{
    "v_car_archer_hella_traffic_engine_loop",
    "amb_bl_ext_ghost_town_power_cables",
    "amb_bl_int_ghost_town_power_station_room_powered",
}

---------- Other thruster candidates ----------
-- "w_tail_shotgun_power_testera_ext_narrow",
-- "amb_g_fx_fire_flames_stream_start_loop",		-- there are only two sounds, and it regularly switches between them
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
-- "amb_bl_ext_oilfield_barracks_fire",		-- close, a bit too much spark popping
-- "sq028_sc_06_boat_fire_big",


---------- Other hover candidates ----------
-- "amb_bl_ext_ghost_town_power_station_structure_02",			-- good, maybe too busy

-- "amb_bl_ext_ghost_town_power_station_structure_01",		-- a bit too much

-- "amb_g_fx_flare_loop",
-- "q101_sc_07_surgery_lamp_hum_loop",
-- "q001_sc_00c_trauma_arrives_intro_av_engines_loop",

-- "amb_g_fx_steam_small_02_loop",		-- too similar to the others

-- "amb_bl_ext_border_crossing_neon_light_02",		-- you can tell it's a light
-- "amb_bl_ext_border_crossing_neon_light_03",

-- "amb_bl_int_raffen_shiv_camp_neon_light_01",		-- too weak
--"amb_bl_loc_sts_bla_ina_04_neon_light_01",        -- too weak