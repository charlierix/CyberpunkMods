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

function Scanner_Player:EnsureScanned()
    local searchQuery = TSQ_ALL()
    searchQuery.maxDistance = 4
    searchQuery.searchFilter = TSF_And(TSF_All(TSFMV.Obj_Puppet), TSF_Not(TSFMV.Obj_Player), TSF_Not(TSFMV.St_Alive))       -- only dead

    local found, entities = self.o:GetTargetEntities(searchQuery)
    if found then
        for _, entity in ipairs(entities) do
            if entity:IsNPC() and entity:IsDead() then      -- the query filter should have handled this, just making sure
                self.map:Add_NPC_Dead(entity:GetEntityID(), entity:GetWorldPosition(), entity:GetAffiliation(), entity:GetTotalFrameWoundsDamage())
            end
        end
    end
end