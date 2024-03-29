-- At some point, there will be an option for a playthrough to use realism or arcade mode
-- Realism will have properties that need to be earned/upgraded
-- Arcade will just be the same values for all playthroughs (that aren't in realism mode)
--
-- All the physics code references this class, so this class needs to load its properties from current
-- realism settings, or a copy of the arcade settings

Player = {}

function Player:new(o, vars, const, debug, player_arcade)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.vars = vars
    obj.const = const
    obj.debug = debug
    obj.player_arcade = player_arcade

    obj.isRealismMode = false

    -- See PlayerArcade:MapModelToSelf for the rest of the member variables

    obj:Reset()

    return obj
end

function Player:Reset()
    --TODO: When realism is implemented, query the player table to see if this playthrough is realism or arcade mode
    self.isRealismMode = false

    self.fall_damage = self.player_arcade.fall_damage

    self.wallDistance_attract_max = self.player_arcade.wallDistance_attract_max

    self.attract_accel = self.player_arcade.attract_accel
    self.attract_pow = self.player_arcade.attract_pow
    self.attract_antigrav = self.player_arcade.attract_antigrav

    self.wallSlide_minSpeed = self.player_arcade.wallSlide_minSpeed
    self.wallSlide_dragAccel = self.player_arcade.wallSlide_dragAccel

    self.wallcrawl_speed_horz = self.player_arcade.wallcrawl_speed_horz
    self.wallcrawl_speed_up = self.player_arcade.wallcrawl_speed_up
    self.wallcrawl_speed_down = self.player_arcade.wallcrawl_speed_down

    self.planted_name = self.player_arcade.planted_name
    self.planted = self.player_arcade.planted

    self.planted_shift_name = self.player_arcade.planted_shift_name
    self.planted_shift = self.player_arcade.planted_shift

    self.rebound_name = self.player_arcade.rebound_name
    self.rebound = self.player_arcade.rebound

    self.rebound_shift_name = self.player_arcade.rebound_shift_name
    self.rebound_shift = self.player_arcade.rebound_shift

    self.override_relatch = self.player_arcade.override_relatch
    self.override_strength_mult = self.player_arcade.override_strength_mult
    self.override_speed_mult = self.player_arcade.override_speed_mult
end

------------------------------- Private Instance Methods ------------------------------

-- function Player:Load()
-- end