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

function Scanner_Player:EnsureScanned()
    local searchQuery = TSQ_ALL()
    searchQuery.maxDistance = 4

    local found, entities = self.o:GetTargetEntities(searchQuery)
    if found then
        for _, entity in ipairs(entities) do
            if entity:IsNPC() then
                if entity:IsDead() then
                    self.map:Add_NPC_Dead(entity:GetEntityID(), entity:GetWorldPosition(), entity:GetAffiliation(), entity:GetTotalFrameWoundsDamage())

                elseif entity:IsDefeated() then
                    self.map:Add_NPC_Defeated(entity:GetEntityID(), entity:GetWorldPosition(), entity:GetAffiliation())
                end

            --elseif Game.NameToString(entity:GetClassName()) == "LootContainerObjectAnimatedByTransform" and Game.NameToString(entity:GetCurrentAppearanceName()):find("_corpse") then
            elseif Game.NameToString(entity:GetCurrentAppearanceName()):find("_corpse") then        -- sometimes it's a gameObject, most times it's LootContainerObjectAnimatedByTransform.  Just use entity:IsContainer() to see if it's holding anything
                self.map:Add_Corpse_Container(entity:GetEntityID(), entity:GetWorldPosition())
            end
        end
    end
end