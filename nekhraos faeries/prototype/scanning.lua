local PrototypeScanning = {}

local this = {}

function PrototypeScanning.GetAllObjects(radius)
    local searchQuery = TSQ_ALL()
    searchQuery.maxDistance = radius

    --searchQuery.maxDistance = Game["SNameplateRangesData::GetDisplayRange;"]() -- Set search radius

    --searchQuery.searchFilter = TSF_And(TSF_All(TSFMV.Obj_Puppet), TSF_Not(TSFMV.Obj_Player))        -- allow dead

    --searchQuery.searchFilter = TSF_NPC()       -- this is the contents of TSF_NPC: TSF_And(TSF_All(TSFMV.Obj_Puppet | TSFMV.St_Alive), TSF_Not(TSFMV.Obj_Player))
    --searchQuery.searchFilter = TSF_And(TSF_All(TSFMV.Obj_Puppet), TSF_Not(TSFMV.Obj_Player), TSF_Not(TSFMV.Att_Friendly))       -- allow dead, not sure if friendly is the same as companion




    -- public static func TSF_NPC() -> TargetSearchFilter {
    -- let tsf: TargetSearchFilter = TSF_And(TSF_All(TSFMV.Obj_Puppet | TSFMV.St_Alive), TSF_Not(TSFMV.Obj_Player));
    -- return tsf; }

    -- public static func TSF_EnemyNPC() -> TargetSearchFilter {
    -- let tsf: TargetSearchFilter = TSF_And(TSF_All(TSFMV.Obj_Puppet | TSFMV.Att_Hostile | TSFMV.St_Alive), TSF_Not(TSFMV.Obj_Player));
    -- return tsf; }

    -- public static func TSF_Quickhackable() -> TargetSearchFilter {
    -- let tsf: TargetSearchFilter = TSF_And(TSF_All(TSFMV.St_QuickHackable), TSF_Not(TSFMV.Obj_Player), TSF_Not(TSFMV.Att_Friendly), TSF_Any(TSFMV.Sp_Aggressive | TSFMV.Obj_Device));
    -- return tsf; }

    -- public static func TSQ_ALL() -> TargetSearchQuery {
    -- let tsq: TargetSearchQuery;
    -- return tsq; }

    -- public static func TSQ_NPC() -> TargetSearchQuery {
    -- let tsq: TargetSearchQuery;
    -- tsq.searchFilter = TSF_NPC();
    -- return tsq; }

    -- public static func TSQ_EnemyNPC() -> TargetSearchQuery {
    -- let tsq: TargetSearchQuery;
    -- tsq.searchFilter = TSF_EnemyNPC();
    -- return tsq; }



    --TODO: This only sees what's in front of the player.  Test creating a game object and move it to various orb's locations
    --Or the center of a few objects
    local found, targetParts = Game.GetTargetingSystem():GetTargetParts(Game.GetPlayer(), searchQuery)
    if not found or #targetParts == 0 then
        return false, nil
    end

    -- For some reason, the same dead body will be in the parts list 8 times
    -- Might as well convert to entity here
    return true, this.GetDedupedEntities(targetParts)
end

function PrototypeScanning.DebugVisual_Entity(entity)
    local pos = entity:GetWorldPosition()

    local name = Game.NameToString(entity:GetClassName())
    local report = name

    --IsDefined

    --IsNPC
    --IsFriendlyTowardsPlayer
    --IsHostile
    --IsVehicle
    --IsPuppet
    --IsPlayer
    --IsContainer
    --IsDevice
    --IsSensor
    --IsTurret
    --IsActive
    --IsDrone
    --IsItem
    --IsDead
    --IsAccessPoint
    --IsQuickHackAble
    --IsExplosive
    --IsNetrunner
    --IsInvestigating
    --IsQuest

    local color = nil

    if entity:IsPlayer() then
        report = report .. "\r\nPlayer"
        color = "FFF"

    elseif entity:IsNPC() then
        -- entity is NPCPuppet
        report = report .. "\r\nNPC"

        if entity:IsPlayerCompanion() then
            report = report .. "\r\nPlayerCompanion"
        end

        if entity:IsDead() then
            report = report .. " (dead)"
            color = "F00"

        elseif entity:IsDefeated() then
            report = report .. " (defeated)"
            color = "F66"

        else
            report = report .. " (alive)"
            color = "0F0"
        end

        ------- use these to determine personality of sprite
        --GetMyKiller
        report = report .. "\r\nLastHitAttackType: " .. tostring(entity:GetLastHitAttackType())     -- { ChargedWhipAttack = 0, Direct = 1, Effect = 2, Explosion = 3, GuardBreak = 4, Hack = 5, Melee = 6, PressureWave = 7, QuickMelee = 8, Ranged = 9, Reflect = 10, StrongMelee = 11, Thrown = 12, WhipAttack = 13, Count = 14, Invalid = 15}

        -- the GetTotalFrameWoundsDamage seems to be the only non zero one.  100 was roughly a limb blown off.  need to keep testing
        report = report .. "\r\nDamage: " .. tostring(Round(entity:GetTotalFrameDamage(), 2)) .. " | " .. tostring(Round(entity:GetTotalFrameDismembermentDamage(), 2)) .. " | " .. tostring(Round(entity:GetTotalFrameWoundsDamage(), 2))

        report = report .. "\r\n" .. entity:GetAffiliation()

    elseif entity:IsExplosive() then
        report = report .. "\r\nExplosive"
        color = "0FF"

    elseif name == "LootContainerObjectAnimatedByTransform" then
        --report = report .. "\r\nDeterminGameplayRole: " .. tostring(entity:DeterminGameplayRole())        -- these two are no different between containers that look like bodies and other containers
        --report = report .. "\r\nGetCurrentOutline: " .. tostring(entity:GetCurrentOutline())

        report = report .. "\r\nIsContainer: " .. tostring(entity:IsContainer())        -- I think this is true when it holds stuff, false when it's empty

        local appearance = Game.NameToString(entity:GetCurrentAppearanceName())


        if appearance:find("_corpse") then
            report = report .. "\r\nCORPSE CONTAINER!!!"
        else
            report = report .. "\r\nGetCurrentAppearanceName: " .. appearance
        end

        color = "FF0"

    elseif entity:IsDevice() then
        report = report .. "\r\nDevice"     -- hopefully, these are all considered distractable
        color = "88F"

    else
        report = report .. "\r\nOther"
        color = "00F"
    end

    debug_render_screen.Add_Dot(pos, nil, color)
    debug_render_screen.Add_Text(Vector4.new(pos.x, pos.y, pos.z - 0.5, 1), report, nil, "6222", "FFF")
end

function PrototypeScanning.DebugVisual_Entity_Harvestable(entity)
    local pos = entity:GetWorldPosition()

    local report = nil
    local color = nil

    if entity:IsNPC() then
        if entity:IsDead() then
            report = "dead"
            color = "F00"

        elseif entity:IsDefeated() then
            report = "defeated"
            color = "F66"
        end

    --elseif Game.NameToString(entity:GetClassName()) == "LootContainerObjectAnimatedByTransform" and Game.NameToString(entity:GetCurrentAppearanceName()):find("_corpse") then     -- sometimes it's gameObject
    elseif Game.NameToString(entity:GetCurrentAppearanceName()):find("_corpse") then
        report = "corpse container"
        color = "FF0"
    end

    if report then
        debug_render_screen.Add_Dot(pos, nil, color)
        debug_render_screen.Add_Text(Vector4.new(pos.x, pos.y, pos.z - 0.5, 1), report, nil, "6222", "FFF")
    end

    return report ~= nil
end

----------------------------------- Private Methods -----------------------------------

-- Turns target parts into entities, deduped on hash
function this.GetDedupedEntities(targetParts)
    local entities = {}
    local ids = {}

    for _, part in ipairs(targetParts) do
        local entity = part:GetComponent():GetEntity()
        local id = tostring(entity:GetEntityID().hash)     -- int64 in game, but cet uses float.  Convert to string to be safe

        if not this.Contains(ids, id) then
            table.insert(ids, id)
            table.insert(entities, entity)
        end
    end

    return entities
end

function this.Contains(ids, id)
    for _, value in ipairs(ids) do
        if value == id then
            return true
        end
    end

    return false
end

return PrototypeScanning