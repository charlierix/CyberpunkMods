Map = {}

local this = {}

local STALECHECK_DOWNED = 0.3333
local STALECHECK_ALIVE = 0.1

local REMEMBER_DOWNED = 9
local REMEMBER_ALIVE = 2

function Map:new(o)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o

    obj.npcs_dead = StickyList:new()
    obj.npcs_defeated = StickyList:new()
    obj.npcs_alive = StickyList:new()

    obj.checkedstale_npcs_dead = o.timer
    obj.checkedstale_npcs_defeated = o.timer
    obj.checkedstale_npcs_alive = o.timer

    return obj
end

function Map:Tick()
    local timer = self.o.timer

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

function Map:Add_NPC_Dead(id, pos, affiliation, limb_damage)
    local item = this.RefreshOrCreateItem(self.npcs_dead, self.o.timer, id, pos)
    item.affiliation = affiliation
    item.limb_damage = limb_damage
end
function Map:Add_NPC_Defeated(id, pos, affiliation)
    local item = this.RefreshOrCreateItem(self.npcs_defeated, self.o.timer, id, pos)
    item.affiliation = affiliation
end
function Map:Add_NPC_Alive(id, pos, affiliation)
    local item = this.RefreshOrCreateItem(self.npcs_alive, self.o.timer, id, pos)
    item.affiliation = affiliation
end

function Map:Remove_NPC_Dead(id)
    this.Remove_ByID(self.npcs_dead, id)
end
function Map:Remove_NPC_Defeated(id)
    this.Remove_ByID(self.npcs_defeated, id)
end
function Map:Remove_NPC_Alive(id)
    this.Remove_ByID(self.npcs_alive, id)
end

function Map:GetNearby(pos, radius, include_dead, include_defeated, include_alive)
    local retVal = {}

    local radius_sqr = radius * radius

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

function this.RefreshOrCreateItem(list, timer, id, pos)
    local item = this.Find_ByID(list, id)
    if not item then
        item = list:GetNewItem()
        item.id = id
    end

    item.timer = timer
    item.pos = pos

    return item
end

function this.Remove_ByID(list, id)
    local item, index = this.Find_ByID(list, id)
    if item then
        list:RemoveItem(index)
    end
end

function this.Find_ByID(list, id)
    for i = 1, list:GetCount(), 1 do
        local item = list:GetItem(i)

        if item.id == id then
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