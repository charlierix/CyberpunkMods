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

    -- See MapRowToSelf() for the rest of the member variables

    obj:Reset()

    return obj
end

function Player:Reset()
    --TODO: When realism is implemented, query the player table to see if this playthrough is realism or arcade mode
    self.isRealismMode = false
    self.jump_strength = self.player_arcade.jump_strength
end

------------------------------- Private Instance Methods ------------------------------

-- function Player:Load()
-- end