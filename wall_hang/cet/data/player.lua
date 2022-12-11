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

    self.jump_strength = self.player_arcade.jump_strength

    self.wallDistance_attract_max = self.player_arcade.wallDistance_attract_max

    self.attract_accel = self.player_arcade.attract_accel
    self.attract_pow = self.player_arcade.attract_pow
    self.attract_antigrav = self.player_arcade.attract_antigrav

    self.wallSlide_minSpeed = self.player_arcade.wallSlide_minSpeed
    self.wallSlide_dragAccel = self.player_arcade.wallSlide_dragAccel

    self.jump_speed_fullStrength = self.player_arcade.jump_speed_fullStrength
    self.jump_speed_zeroStrength = self.player_arcade.jump_speed_zeroStrength

    self.wallcrawl_speed_horz = self.player_arcade.wallcrawl_speed_horz
    self.wallcrawl_speed_up = self.player_arcade.wallcrawl_speed_up
    self.wallcrawl_speed_down = self.player_arcade.wallcrawl_speed_down


    -------------- temp rebound --------------
    self.rebound = self.player_arcade.rebound

end

------------------------------- Private Instance Methods ------------------------------

-- function Player:Load()
-- end