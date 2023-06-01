Map = {}

local this = {}

local STALECHECK_DOWNED = 0.3333
local STALECHECK_ALIVE = 0.1

local REMEMBER_DOWNED = 9
local REMEMBER_ALIVE = 2

function Map:new(o, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.const = const

    obj.corpse_container = StickyList:new()
    obj.npcs_dead = StickyList:new()
    obj.npcs_defeated = StickyList:new()
    obj.npcs_alive = StickyList:new()

    obj.checkedstale_corpse_container = o.timer
    obj.checkedstale_npcs_dead = o.timer
    obj.checkedstale_npcs_defeated = o.timer
    obj.checkedstale_npcs_alive = o.timer

    return obj
end

function Map:Tick()
    local timer = self.o.timer

    if self.corpse_container:GetCount() > 0 and timer - self.checkedstale_corpse_container > STALECHECK_DOWNED then
        this.ClearStale(self.corpse_container, timer, REMEMBER_DOWNED)
        self.checkedstale_corpse_container = timer
    end

    if self.npcs_dead:GetCount() > 0 and timer - self.checkedstale_npcs_dead > STALECHECK_DOWNED then
        this.ClearStale(self.npcs_dead, timer, REMEMBER_DOWNED)
        self.checkedstale_npcs_dead = timer
    end

    if self.npcs_defeated:GetCount() > 0 and timer - self.checkedstale_npcs_defeated > STALECHECK_DOWNED then
        this.ClearStale(self.npcs_defeated, timer, REMEMBER_DOWNED)
    end

    if self.npcs_alive:GetCount() > 0 and timer - self.checkedstale_npcs_alive > STALECHECK_ALIVE then
        this.ClearStale(self.npcs_alive, timer, REMEMBER_ALIVE)
    end
end

function Map:Add_Corpse_Container(entityID, pos)
    local item = this.RefreshOrCreateItem(self.corpse_container, self.o.timer, entityID, pos)
    item.body_type = self.const.map_body_type.CorpseContainer
end
function Map:Add_NPC_Dead(entityID, pos, affiliation, limb_damage)
    local item = this.RefreshOrCreateItem(self.npcs_dead, self.o.timer, entityID, pos)
    item.body_type = self.const.map_body_type.NPC_Dead
    item.affiliation = affiliation
    item.limb_damage = limb_damage
end
function Map:Add_NPC_Defeated(entityID, pos, affiliation)
    local item = this.RefreshOrCreateItem(self.npcs_defeated, self.o.timer, entityID, pos)
    item.body_type = self.const.map_body_type.NPC_Defeated
    item.affiliation = affiliation
    item.limb_damage = 0
end
function Map:Add_NPC_Alive(entityID, pos, affiliation)
    local item = this.RefreshOrCreateItem(self.npcs_alive, self.o.timer, entityID, pos)
    item.body_type = self.const.map_body_type.NPC_Alive
    item.affiliation = affiliation
    item.limb_damage = 0
end

-- Removes a body based on the definition returned from self:GetNearby
--  models/map_body.cs
function Map:Remove(map_body)
    if map_body.body_type == self.const.map_body_type.CorpseContainer then
        self:Remove_Corpse_Container(map_body.id_hash)

    elseif map_body.body_type == self.const.map_body_type.NPC_Dead then
        self:Remove_NPC_Dead(map_body.id_hash)

    elseif map_body.body_type == self.const.map_body_type.NPC_Defeated then
        self:Remove_NPC_Defeated(map_body.id_hash)

    elseif map_body.body_type == self.const.map_body_type.NPC_Alive then
        self:Remove_NPC_Alive(map_body.id_hash)

    else
        LogError("Map:Remove - Unknown body type: " .. tostring(map_body.body_type))
    end
end

function Map:Remove_Corpse_Container(id_hash)
    this.Remove_ByIDHash(self.corpse_container, id_hash)
end
function Map:Remove_NPC_Dead(id_hash)
    this.Remove_ByIDHash(self.npcs_dead, id_hash)
end
function Map:Remove_NPC_Defeated(id_hash)
    this.Remove_ByIDHash(self.npcs_defeated, id_hash)
end
function Map:Remove_NPC_Alive(id_hash)
    this.Remove_ByIDHash(self.npcs_alive, id_hash)
end

-- Returns list of body definitions
--  models/map_body.cs
function Map:GetNearby(pos, radius, include_corpse_container, include_dead, include_defeated, include_alive)
    local retVal = {}

    local radius_sqr = radius * radius

    if include_corpse_container then
        this.GetNearby(self.corpse_container, pos, radius_sqr, retVal)
    end

    if include_dead then
        this.GetNearby(self.npcs_dead, pos, radius_sqr, retVal)
    end

    if include_defeated then
        this.GetNearby(self.npcs_defeated, pos, radius_sqr, retVal)
    end

    if include_alive then
        this.GetNearby(self.npcs_alive, pos, radius_sqr, retVal)
    end

    return retVal
end

----------------------------------- Private Methods -----------------------------------

function this.RefreshOrCreateItem(list, timer, entityID, pos)
    local hash = entity_helper.GetIDHash_ID(entityID)

    local item = this.Find_ByIDHash(list, hash)
    if not item then
        item = list:GetNewItem()
        item.entityID = entityID
        item.id_hash = hash
    end

    item.timer = timer
    item.pos = pos

    return item
end

function this.Remove_ByIDHash(list, hash)
    local item, index = this.Find_ByIDHash(list, hash)
    if item then
        list:RemoveItem(index)
    end
end

function this.Find_ByIDHash(list, hash)
    for i = 1, list:GetCount(), 1 do
        local item = list:GetItem(i)

        if item.id_hash == hash then
            return item, i
        end
    end

    return nil, -1
end

function this.ClearStale(list, timer, max_time)
    local index = 1

    while index <= list:GetCount() do
        local item = list:GetItem(index)

        if timer - item.timer > max_time then
            list:RemoveItem(index)
        else
            index = index + 1
        end
    end
end

function this.GetNearby(list, pos, radius_sqr, retVal)
    for i = 1, list:GetCount(), 1 do
        local item = list:GetItem(i)

        if GetVectorDiffLengthSqr(item.pos, pos) <= radius_sqr then
            table.insert(retVal, item)
        end
    end
end