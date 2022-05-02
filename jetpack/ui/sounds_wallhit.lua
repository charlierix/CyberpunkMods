local this = {}

-- local speed_low_med = 6      -- instead of a hard cutover from low -> med -> high, have boundry areas where there's a random chance of one or the other sound playing
-- local speed_med_high = 18

local speed_start_med = 4.5
local speed_end_low = 8

local speed_start_high = 13
local speed_end_med = 24


function PlaySound_WallHit(o, vars, vel)
    if not vel then
        o:PlaySound(this.GetRandomSound1(this.speed_low), vars)
        do return end
    end

    local speed = GetVectorLength(vel)

    local sound = nil

    if speed < speed_start_med then
        sound = this.GetRandomSound1(this.speed_low)

    elseif speed < speed_end_low then
        sound = this.GetRandomSound2(this.speed_low, this.speed_medium)

    elseif speed < speed_start_high then
        sound = this.GetRandomSound1(this.speed_medium)

    elseif speed < speed_end_med then
        sound = this.GetRandomSound2(this.speed_medium, this.speed_high)

    else
        sound = this.GetRandomSound1(this.speed_high)
    end

    o:PlaySound(sound, vars)
end

function this.GetRandomSound1(list)
    return list[math.random(#list)]
end
function this.GetRandomSound2(list1, list2)
    if math.random() < 0.5 then
        return this.GetRandomSound1(list1)
    else
        return this.GetRandomSound1(list2)
    end
end

this.speed_low =
{
    "lcm_adt_metal_belt_light_hit",
    "lcm_fs_additional_wood_hollow_hand_grab",
    "lcm_fs_heels_concrete_jump",
    "lcm_fs_heels_tarp_jump",
    "lcm_fs_heels_wood_hollow_jump",
    "lcm_fs_sneakers_tarp_jump",
    "lcm_fs_sneakers_tiles_jump",
    "lcm_fs_sneakers_carpet_land",
}

this.speed_medium =
{
    "lcm_fs_heels_concrete_dirty_jump",
    "w_bul_hit_cardboard_heavy",
    "w_bul_hit_cardboard_railgun",
    "w_bul_hit_cardboard_shotgun",
    "w_bul_hit_cardboard",
    "w_bul_hit_subdermal_heavy",
    "w_bul_hit_subdermal_railgun",
    "w_bul_hit_subdermal_shotgun",
    "w_bul_hit_subdermal",
}

this.speed_high =
{
    "w_bul_npc_hit_meatshield",
    "w_bul_npc_hit_screen_heavy",
    "w_bul_npc_hit_screen_railgun",
    "w_bul_npc_hit_screen_shotgun",
    "w_bul_npc_hit_screen",
    "w_bul_npc_hit_subdermal",
    "w_bul_hit_linoleum_heavy",
    "w_bul_hit_linoleum_railgun",
    "w_bul_hit_linoleum_shotgun",
    "w_bul_hit_linoleum",
    "w_bul_hit_plastic_heavy",
    "w_bul_hit_plastic_railgun",
    "w_bul_hit_plastic_shotgun",
    "w_bul_hit_plastic",
    "w_bul_hit_plexiglass_heavy",
    "w_bul_hit_plexiglass_railgun",
    "w_bul_hit_plexiglass_shotgun",
    "w_bul_hit_plexiglass",
    "w_bul_hit_screen_heavy",
    "w_bul_hit_screen_railgun",
    "w_bul_hit_screen_shotgun",
    "w_bul_hit_screen",
    "w_bul_hit_styrofoarm_heavy",
    "w_bul_hit_styrofoarm_railgun",
    "w_bul_hit_styrofoarm_shotgun",
    "w_bul_hit_styrofoarm",
    "v_car_generic_collision_impact_heavy",
}