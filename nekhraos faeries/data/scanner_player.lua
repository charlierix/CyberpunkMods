Scanner_Player = {}

function Scanner_Player:new(o, map)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.map = map

    return obj
end

-- This should only do scans when trying to harvest a body.  Otherwise, let the orbs do the scanning

-- Instead of using the player's eyes, make a gameobject and put it above the player.  If there's a low ceiling, just swivel it around



-- Since this is only used when harvesting bodies, only look for dead bodies