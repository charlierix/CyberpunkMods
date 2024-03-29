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

function Scanner_Orbs:Scan_FromPlayersPerspective()
    local searchQuery = TSQ_ALL()

    local found, entities = self.o:GetTargetEntities(searchQuery)
    if found then
        for _, entity in ipairs(entities) do
            scanner_util.AddToMap(self.map, entity, self.const)
        end
    end
end

-- When orbs are spawned, this should periodically do a scan from their perspective

-- This assumes it's possible to spawn a gameobject and use it for scanning (move to a position/orientation, take a picture)

-- When deciding where to go, look for places that are most stale



-- This would look for multiple types of items (npcs alive and dead, devices and explosives to mess with)