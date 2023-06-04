Scanner_Orbs = {}

function Scanner_Orbs:new(o, map, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.map = map
    obj.const = const

    return obj
end

-- When orbs are spawned, this should periodically do a scan from their perspective

-- This assumes it's possible to spawn a gameobject and use it for scanning (move to a position/orientation, take a picture)

-- When deciding where to go, look for places that are most stale



-- This would look for multiple types of items (npcs alive and dead, devices and explosives to mess with)