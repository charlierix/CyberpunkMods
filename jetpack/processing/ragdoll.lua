local this  = {}
local pos_offset = nil      -- this is an offset vector, but can't be populated before init

-- This will launch NPCs straight up (only the npc's that the player can see)
function RagdollNPCs_StraightUp(radius, force, randHorz, randVert, o)
    local searchQuery = this.GetSearchQuery(radius)

    local found, entities = o:GetTargetEntities(searchQuery)

    if found and entities then
        for i = 1, #entities do
            this.LaunchUp(entities[i], force, randHorz, randVert, o)
        end
    end
end

-- This launches NPCs up and out, with a power drop off based on distance from the player
function RagdollNPCs_ExplodeOut(radius, force, upForce, o, is_implode)
    local searchQuery = this.GetSearchQuery(radius)

    local found, entities = o:GetTargetEntities(searchQuery)

    if found and entities then
        for i = 1, #entities do
            this.ExplodeOut(entities[i], o.pos, radius, force, upForce, o, is_implode)
        end
    end
end

----------------------------------- Private Methods -----------------------------------

function this.GetSearchQuery(radius)
    local searchQuery = TSQ_ALL()
    searchQuery.maxDistance = radius
    searchQuery.searchFilter = TSF_And(TSF_All(TSFMV.Obj_Puppet), TSF_Not(TSFMV.Obj_Player))        -- allow dead

    --searchQuery.searchFilter = TSF_NPC()       -- this is the contents of TSF_NPC: TSF_And(TSF_All(TSFMV.Obj_Puppet | TSFMV.St_Alive), TSF_Not(TSFMV.Obj_Player))
    --searchQuery.searchFilter = TSF_And(TSF_All(TSFMV.Obj_Puppet), TSF_Not(TSFMV.Obj_Player), TSF_Not(TSFMV.Att_Friendly))       -- allow dead, not sure if friendly is the same as companion

    return searchQuery
end

function this.LaunchUp(entity, force, randHorz, randVert, o)
    local npc = this.GetRagdollableNPC(entity)
    if not npc then
        do return end
    end

    local npc_pos = this.GetNPCPosition(npc)

    local mult = this.GetForceMultiplier(npc)

    local horz = GetRandomVector_Circular(0, randHorz * mult)
    local min_vert = (force - randVert) * mult
    local max_vert = (force + randVert) * mult

    local direction = Vector4.new(
        horz.x,
        horz.y,
        Clamp(0, max_vert, this.Random_MinMax(min_vert, max_vert)),
        1)

    npc:QueueEvent(CreateForceRagdollEvent("Launch Up"))
    o:DelayEventNextFrame(npc, CreateRagdollApplyImpulseEvent(npc_pos, direction, 5))       -- the impulse must wait a frame for the previous ragdoll to take affect
end

function this.ExplodeOut(entity, player_pos, radius, force, upForce, o, is_implode)
    local npc = this.GetRagdollableNPC(entity)
    if not npc then
        do return end
    end

    local npc_pos = this.GetNPCPosition(npc)
    local distance = Vector4.Distance(player_pos, npc_pos);

    if distance < 0.01 or distance > radius then      -- avoiding divide by zero, also making sure the query doesn't come back with objects too far away (shouldn't, but it's easy to check)
        do return end
    end

    local distScaled = distance / radius

    local percent = (1 - distScaled) * (1 - distScaled)       -- give a dropoff to zero

    local adjustedForce = force * percent

    local finalForce = adjustedForce + this.Random_MinMax(-adjustedForce / 12.00, adjustedForce / 12.00)

    local dir_x, dir_y, dir_z
    if is_implode then
        dir_x = (player_pos.x - npc_pos.x) / distScaled       -- unit vector
        dir_y = (player_pos.y - npc_pos.y) / distScaled
        dir_z = (player_pos.z - npc_pos.z) / distScaled
    else
        dir_x = (npc_pos.x - player_pos.x) / distScaled       -- unit vector
        dir_y = (npc_pos.y - player_pos.y) / distScaled
        dir_z = (npc_pos.z - player_pos.z) / distScaled
    end

    local mult = this.GetForceMultiplier(npc)

    local finalDirection = Vector4.new(
        (dir_x * finalForce) * mult,
        (dir_y * finalForce) * mult,
        ((dir_z * finalForce) + upForce) * mult,      -- give the z a bit extra up so they get picked up off the ground
        1)

    npc:QueueEvent(CreateForceRagdollEvent("Explode Out"))
    o:DelayEventNextFrame(npc, CreateRagdollApplyImpulseEvent(npc_pos, finalDirection, 5))       -- the impulse must wait a frame for the previous ragdoll to take affect
end

function this.GetRagdollableNPC(entity)
    -- This is coming back false for kids, possibly others
    if not ScriptedPuppet.CanRagdoll(entity) then
        return nil
    end

    if not entity:CanEnableRagdollComponent() then
        return nil      -- never saw this
    end

    -- This doesn't seem to have an effect.  That function is probably just meant to disable an existing ragdoll event
    -- if not entity:IsRagdollEnabled() then
    --     entity:SetDisableRagdoll(false)        -- double negative :(

    --     if not entity:IsRagdollEnabled() then
    --         print("GetRagdollableNPC: STILL not entity:IsRagdollEnabled()")
    --     end
    -- end

    return entity
end

function this.GetNPCPosition(npc)
    local pos_feet = npc:GetWorldPosition()

    if not pos_offset then
        pos_offset = Vector4.new(0, 0, 1, 1)        -- one meter up from their feet
    end

    return AddVectors(pos_feet, pos_offset)
end

-- Some npcs are affected differently
function this.GetForceMultiplier(npc)
    if npc:IsCrowd() then
        return 6

    -- elseif npc:IsCharacterCivilian() then        -- I think this used to need a 6
    --     return 1

    elseif npc:IsAggressive() then
        return 6

    else

        -- A few others.  There are more of these function, these just looked like they might be relevant
        --npc:IsEnemy()
        --npc:IsCivilian()
        --npc:IsCharacterCivilian()
        --npc:IsCharacterGanger()
        --npc:IsCharacterPolice()

        return 1
    end
end

-- Returns a random value between min and max (floating point)
function this.Random_MinMax(min, max)
    return GetScaledValue(min, max, 0, 1, math.random())
end