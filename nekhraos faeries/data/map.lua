Map = {}

local this = {}

local SHOW_DEBUG = false

local STALECHECK_ALIVE = 0.1
local STALECHECK_STATICITEM = 0.3333

local REMEMBER_ALIVE = 2
local REMEMBER_STATICITEM = 9

function Map:new(o, const)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.o = o
    obj.const = const

    obj.objectives = StickyList:new()


    --TODO: store all these in the same list
    obj.corpse_containers = StickyList:new()
    obj.npcs_dead = StickyList:new()
    obj.npcs_defeated = StickyList:new()
    obj.npcs_alive = StickyList:new()


    obj.containers = StickyList:new()
    obj.devices = StickyList:new()
    obj.loot = StickyList:new()

    obj.checkedstale_corpse_containers = o.timer
    obj.checkedstale_npcs_dead = o.timer
    obj.checkedstale_npcs_defeated = o.timer
    obj.checkedstale_npcs_alive = o.timer
    obj.checkedstale_containers = o.timer
    obj.checkedstale_devices = o.timer
    obj.checkedstale_loot = o.timer

    return obj
end

function Map:Tick()
    local timer = self.o.timer

    if self.corpse_containers:GetCount() > 0 and timer - self.checkedstale_corpse_containers > STALECHECK_STATICITEM then
        this.ClearStale(self.corpse_containers, self.objectives, timer, REMEMBER_STATICITEM)
        self.checkedstale_corpse_containers = timer
    end

    if self.npcs_dead:GetCount() > 0 and timer - self.checkedstale_npcs_dead > STALECHECK_STATICITEM then
        this.ClearStale(self.npcs_dead, self.objectives, timer, REMEMBER_STATICITEM)
        self.checkedstale_npcs_dead = timer
    end

    if self.npcs_defeated:GetCount() > 0 and timer - self.checkedstale_npcs_defeated > STALECHECK_STATICITEM then
        this.ClearStale(self.npcs_defeated, self.objectives, timer, REMEMBER_STATICITEM)
    end

    if self.npcs_alive:GetCount() > 0 and timer - self.checkedstale_npcs_alive > STALECHECK_ALIVE then
        this.ClearStale(self.npcs_alive, self.objectives, timer, REMEMBER_ALIVE)
    end

    if self.containers:GetCount() > 0 and timer - self.checkedstale_containers > STALECHECK_STATICITEM then
        this.ClearStale(self.containers, self.objectives, timer, REMEMBER_STATICITEM)
    end

    if self.devices:GetCount() > 0 and timer - self.checkedstale_devices > STALECHECK_STATICITEM then
        this.ClearStale(self.devices, self.objectives, timer, REMEMBER_STATICITEM)
    end

    if self.loot:GetCount() > 0 and timer - self.checkedstale_loot > STALECHECK_STATICITEM then
        this.ClearStale(self.loot, self.objectives, timer, REMEMBER_STATICITEM)
    end

    if SHOW_DEBUG then
        this.DebugTick(self)
    end
end


--TODO: change NPC to a different word, since player will be added to Add_NPC_Alive


function Map:Add_Corpse_Container(entityID, pos)
    local item = this.RefreshOrCreateItem(self.corpse_containers, self.o.timer, entityID, pos)
    item.body_type = self.const.map_body_type.CorpseContainer

    this.Update_ObjectiveItem(self.objectives, qual_vect.GetVector_Body(item, self.const), item, item, nil, nil, nil)
end
function Map:Add_NPC_Dead(entityID, pos, affiliation, limb_damage)
    local item = this.RefreshOrCreateItem(self.npcs_dead, self.o.timer, entityID, pos)
    item.body_type = self.const.map_body_type.NPC_Dead
    item.affiliation = affiliation
    item.limb_damage = limb_damage

    this.Update_ObjectiveItem(self.objectives, qual_vect.GetVector_Body(item, self.const), item, item, nil, nil, nil)
end
function Map:Add_NPC_Defeated(entityID, pos, affiliation)
    local item = this.RefreshOrCreateItem(self.npcs_defeated, self.o.timer, entityID, pos)
    item.body_type = self.const.map_body_type.NPC_Defeated
    item.affiliation = affiliation
    item.limb_damage = 0

    this.Update_ObjectiveItem(self.objectives, qual_vect.GetVector_Body(item, self.const), item, item, nil, nil, nil)
end
function Map:Add_NPC_Alive(entityID, pos, affiliation)
    local item = this.RefreshOrCreateItem(self.npcs_alive, self.o.timer, entityID, pos)
    item.body_type = self.const.map_body_type.NPC_Alive
    item.affiliation = affiliation
    item.limb_damage = 0

    this.Update_ObjectiveItem(self.objectives, qual_vect.GetVector_Body(item, self.const), item, item, nil, nil, nil)
end
function Map:Add_Container(entityID, pos)
    local item = this.RefreshOrCreateItem(self.containers, self.o.timer, entityID, pos)

    this.Update_ObjectiveItem(self.objectives, qual_vect.GetVector_Container(item), item, nil, item, nil, nil)

    -- If a container is empty, it won't be of any interest, so there's no point in storing it
    -- It's a bit inefficient adding then removing, but the get qualifier function needs an instance, and that's part of the add
    if IsNearZero_vecnd(item.objective_item.qualifier_unit) then
        self:Remove_Container(item)
    end
end
function Map:Add_Device(entityID, pos)
    local item = this.RefreshOrCreateItem(self.devices, self.o.timer, entityID, pos)

    this.Update_ObjectiveItem(self.objectives, qual_vect.GetVector_Device(item), item, nil, nil, item, nil)

    -- If a device can't be manipulated (like sound sources, walk/don't walk signs), it won't be of any interest, so there's no point in storing it
    -- It's a bit inefficient adding then removing, but the get qualifier function needs an instance, and that's part of the add
    if IsNearZero_vecnd(item.objective_item.qualifier_unit) then
        self:Remove_Device(item)
    end
end
function Map:Add_Loot(entityID, pos)
    local item = this.RefreshOrCreateItem(self.loot, self.o.timer, entityID, pos)

    this.Update_ObjectiveItem(self.objectives, qual_vect.GetVector_Loot(item), item, nil, nil, nil, item)
end

-- Removes a body based on the definition returned from self:GetNearby_Body
--  models\map_body.cs
function Map:Remove_Body(map_body)
    if map_body.body_type == self.const.map_body_type.CorpseContainer then
        this.Remove_ByIDHash(self.corpse_containers, map_body.id_hash)

    elseif map_body.body_type == self.const.map_body_type.NPC_Dead then
        this.Remove_ByIDHash(self.npcs_dead, map_body.id_hash)

    elseif map_body.body_type == self.const.map_body_type.NPC_Defeated then
        this.Remove_ByIDHash(self.npcs_defeated, map_body.id_hash)

    elseif map_body.body_type == self.const.map_body_type.NPC_Alive then
        this.Remove_ByIDHash(self.npcs_alive, map_body.id_hash)

    else
        LogError("Map:Remove_Body - Unknown body type: " .. tostring(map_body.body_type))
    end

    this.RemoveObjectiveItem(self.objectives, map_body)
end
--  models\map_container.cs
function Map:Remove_Container(map_container)
    this.Remove_ByIDHash(self.containers, map_container.id_hash)
    this.RemoveObjectiveItem(self.objectives, map_container)
end
--  models\map_device.cs
function Map:Remove_Device(map_device)
    this.Remove_ByIDHash(self.devices, map_device.id_hash)
    this.RemoveObjectiveItem(self.objectives, map_device)
end
--  models\map_loot.cs
function Map:Remove_Loot(map_loot)
    this.Remove_ByIDHash(self.loot, map_loot.id_hash)
    this.RemoveObjectiveItem(self.objectives, map_loot)
end

-- Returns list of body definitions
--  models\map_body.cs
function Map:GetNearby_Body(pos, radius, include_corpse_container, include_dead, include_defeated, include_alive)
    local retVal = {}

    local radius_sqr = radius * radius

    if include_corpse_container then
        this.GetNearby(self.corpse_containers, pos, radius_sqr, retVal)
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

-- Returns items to be used by ai
--  models\map_objective_item.cs
function Map:GetNearby_ObjectiveItems(pos, radius)
    local radius_sqr = radius * radius

    local retVal = {}

    for i = 1, self.objectives:GetCount(), 1 do
        local item = self.objectives:GetItem(i)

        if GetVectorDiffLengthSqr(item.pos, pos) <= radius_sqr then
            table.insert(retVal, item)
        end
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

function this.ClearStale(list, list_objectives, timer, max_time)
    local index = 1

    while index <= list:GetCount() do
        local item = list:GetItem(index)

        if timer - item.timer > max_time then
            list:RemoveItem(index)
            this.RemoveObjectiveItem(list_objectives, item)
        else
            index = index + 1
        end
    end
end

function this.RemoveObjectiveItem(list, item)
    for i = 1, list:GetCount(), 1 do
        local objective_item = list:GetItem(i)

        if objective_item.base_object.id_hash == item.id_hash then
            -- Break references (need to do this explicitly, since it's a stickylist, which reuses removed items)
            objective_item.base_object = nil
            objective_item.body = nil
            objective_item.container = nil
            objective_item.device = nil
            objective_item.loot = nil

            item.objective_item = nil

            list:RemoveItem(i)
            do return end
        end
    end
end

function this.Update_ObjectiveItem(objectives, qualifier_unit, item_base, body, container, device, loot)
    if item_base.objective_item then
        -- The objective item has already been created and linked.  Just update the position
        item_base.objective_item.pos = item_base.pos
        do return end
    end

    local objective_item = objectives:GetNewItem()
    objective_item.pos = item_base.pos
    objective_item.qualifier_unit = qualifier_unit

    --NOTE: these links are set to nil in RemoveObjectiveItem

    objective_item.base_object = item_base

    objective_item.body = body
    objective_item.container = container
    objective_item.device = device
    objective_item.loot = loot

    item_base.objective_item = objective_item
end

function this.GetNearby(list, pos, radius_sqr, retVal)
    for i = 1, list:GetCount(), 1 do
        local item = list:GetItem(i)

        if GetVectorDiffLengthSqr(item.pos, pos) <= radius_sqr then
            table.insert(retVal, item)
        end
    end
end

function this.DebugTick(self)
    this.DebugTick_Body(self.corpse_containers)
    this.DebugTick_Body(self.npcs_dead)
    this.DebugTick_Body(self.npcs_defeated)
    this.DebugTick_Body(self.npcs_alive)

    this.DebugTick_Other(self.containers, "container")
    this.DebugTick_Other(self.devices, "device")
    this.DebugTick_Other(self.loot, "loot")
end
function this.DebugTick_Body(bodies)
    for i = 1, bodies:GetCount(), 1 do
        local item = bodies:GetItem(i)

        local report = item.body_type
        if item.affiliation then
            report = report .. "\r\n" .. item.affiliation
        end

        debug_render_screen.Add_Dot(item.pos, nil, "4F4", nil, true)
        debug_render_screen.Add_Text(Vector4.new(item.pos.x, item.pos.y, item.pos.z - 0.5, 1), report, nil, "6222", "FFF", nil, true)

        if not item.objective_item then
            print("this.DebugTick_Body | item.objective_item is nil | " .. report)
        end
    end
end
function this.DebugTick_Other(list, description)
    for i = 1, list:GetCount(), 1 do
        local item = list:GetItem(i)

        debug_render_screen.Add_Dot(item.pos, nil, "DD4", nil, true)
        debug_render_screen.Add_Text(Vector4.new(item.pos.x, item.pos.y, item.pos.z - 0.5, 1), description, nil, "6222", "FFF", nil, true)

        if not item.objective_item then
            print("this.DebugTick_Other | item.objective_item is nil | " .. description)
        end
    end
end