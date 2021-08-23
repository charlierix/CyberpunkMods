local this = {}

function Transition_ToStandard(vars, debug, o, const)
    -- This gets called every frame when they are in the menu, driving, etc.  So it needs to be
    -- safe and cheap
    if not vars or not vars.flightMode == const.flightModes.standard then
        do return end
    end

    vars.flightMode = const.flightModes.standard
    o:Custom_CurrentlyFlying_Clear()

    vars.kdash:Clear()
    vars.lasercats:Stop()

    this.StopHoverSound(o, vars)
end

function Transition_ToImpulseLaunch(o, vars, const)
    vars.flightMode = const.flightModes.impulse_launch
    o:Custom_CurrentlyFlying_StartFlight()

    vars.startFlightTime = o.timer
end

function Transition_ToFlight(o, vars, const)
    vars.flightMode = const.flightModes.flying
    o:Custom_CurrentlyFlying_StartFlight()

    vars.vel = o.vel
    vars.startFlightTime = o.timer
    vars.lowSpeedTime = nil
    vars.minSpeedOverride_start = -1000

    this.StartHoverSound(o, vars)
end

----------------------------------- Private Methods -----------------------------------

function this.StartHoverSound(o, vars)
    if not vars.sound_hover then
        vars.sound_hover = this.GetRandomSound(this.hover_sounds)
        o:PlaySound(vars.sound_hover)
    end
end
function this.StopHoverSound(o, vars)
    if vars.sound_hover then
        o:StopSound(vars.sound_hover)
        vars.sound_hover = nil
    end
end

function this.GetRandomSound(list)
    return list[math.random(#list)]
end

this.hover_sounds =
{
    --"q003_sc_03_deal_tension_LP",

    --"v_car_archer_hella_traffic_engine_loop",        --NOTE: These 3 are the same sounds as jetpack's hover
    -- "amb_bl_ext_ghost_town_power_cables",
    -- "amb_bl_int_ghost_town_power_station_room_powered",

    "v_av_rayfield_excalibur_traffic_engine_01",
    --"q115_sc_05_av_03_flight_loop",
    --"q115_sc_05_av_01_engine_idle_out_and_in_loop",
    --"v_av_news_station_01_engine",
    --"v_av_rayfield_excalibur_traffic_engine_01_av_dplr_01_veh_int",

    --"v_car_thorton_mackinaw_nomad_alt_traffic_engine_loop",
}