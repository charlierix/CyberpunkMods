Scanner_Player = {}

function Scanner_Player:new(o, map, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.map = map
    obj.const = const

    return obj
end

-- This should only do scans when trying to harvest a body.  Otherwise, let the orbs do the scanning

-- Instead of using the player's eyes, make a gameobject and put it above the player.  If there's a low ceiling, just swivel it around

function Scanner_Player:EnsureScanned()
    local searchQuery = TSQ_ALL()
    searchQuery.maxDistance = 4

    local found, entities = self.o:GetTargetEntities(searchQuery)
    if found then
        for _, entity in ipairs(entities) do
            scanner_util.AddToMap(self.map, entity, self.const)
        end
    end
end