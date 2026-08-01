--[[
  Grenade Tester Mod - CET (Lua)
  Spawns a grenade N meters along look direction and detonates after N seconds.
  Deals real AoE damage to all NPCs (and optionally player) within blast radius.

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/grenade_tester/

  Bind hotkeys in: Settings > Key Bindings > GrenadeTester
]]

local ModName = "GrenadeTester"

--============================================================================
-- CONFIGURATION  (edit these values directly)
--============================================================================
local Config = {
    fuseTime       = 1.5,    -- seconds before explosion
    spawnDistance  = 4.0,    -- meters along look direction
    damageRadius   = 8.0,    -- blast radius in meters
    damageAmount   = 200.0,  -- raw damage points to deal to each entity in range
    grenadeType    = "frag", -- frag | emp | flash | incendiary | biohazard | recon | cutting
    damagePlayer   = false,   -- also damage the player if within blast radius
    applyVisual    = true,   -- apply status effect (visual/audio) in addition to damage    (I don't think this one works, need to manually apply fx)
    debug          = true,   -- print debug info to CET console
}

--============================================================================
-- GRENADE DATA
--============================================================================

-- Explosion status effect IDs (applied for visual/audio effects)
local ExplosionEffects = {
    frag        = "BaseStatusEffect.CommonFragGrenadeExplosion",
    emp         = "BaseStatusEffect.BaseEmpGrenade",
    flash       = "BaseStatusEffect.CommonFlashGrenade",
    incendiary  = "BaseStatusEffect.BurnGrenade",
    biohazard   = "BaseStatusEffect.BioGrenade",
    recon       = "BaseStatusEffect.ReconGrenadeAttack",
    cutting     = "BaseStatusEffect.CuttingGrenadeAttack",
}

--============================================================================
-- NPC REGISTRY — track all NPCs via Observe(OnGameAttached)
-- Pattern from EnemyMultiplier mod
--============================================================================

local NPCRegistry = {}  -- table of entityID -> entity (weak references)

local function RegisterNPC(entity)
    if not entity or not IsDefined(entity) then return end
    local isNPC = false
    pcall(function() isNPC = entity:IsNPC() end)
    if not isNPC then return end

    local id = nil
    pcall(function() id = entity:GetEntityID() end)
    if not id then return end

    NPCRegistry[tostring(id)] = entity
end

local function CleanNPCRegistry()
    local toRemove = {}
    for idStr, entity in pairs(NPCRegistry) do
        if not IsDefined(entity) then
            toRemove[idStr] = true
        else
            local dead = false
            pcall(function() dead = entity:IsDead() end)
            if dead then
                toRemove[idStr] = true
            end
        end
    end
    for idStr in pairs(toRemove) do
        NPCRegistry[idStr] = nil
    end
end

--- Get all NPCs within radius of a position, from registry + SenseManager fallback
local function GetNPCsInRadius(centerPos, radius)
    local results = {}
    local seen = {}
    local radiusSq = radius * radius

    -- Method 1: NPC Registry (from Observe OnGameAttached)
    CleanNPCRegistry()
    for _, entity in pairs(NPCRegistry) do
        if IsDefined(entity) then
            local pos = nil
            pcall(function() pos = entity:GetWorldPosition() end)
            if pos then
                local dx = pos.x - centerPos.x
                local dy = pos.y - centerPos.y
                local dz = pos.z - centerPos.z
                local distSq = dx * dx + dy * dy + dz * dz
                if distSq <= radiusSq then
                    local id = nil
                    pcall(function() id = entity:GetEntityID() end)
                    local idStr = tostring(id)
                    if not seen[idStr] then
                        seen[idStr] = true
                        table.insert(results, { entity = entity, distance = math.sqrt(distSq) })
                    end
                end
            end
        end
    end

    -- Method 2: SenseManager fallback (NPCs player can perceive)
    pcall(function()
        local player = Game.GetPlayer()
        if not player then return end
        local senseManager = Game.GetSenseManager()
        if not senseManager then return end

        local objects = {}
        senseManager:GetVisibleObjects(player, objects)

        for _, obj in ipairs(objects) do
            if obj and IsDefined(obj) then
                local isNPC = false
                pcall(function() isNPC = obj:IsNPC() end)
                if isNPC then
                    local pos = nil
                    pcall(function() pos = obj:GetWorldPosition() end)
                    if pos then
                        local dx = pos.x - centerPos.x
                        local dy = pos.y - centerPos.y
                        local dz = pos.z - centerPos.z
                        local distSq = dx * dx + dy * dy + dz * dz
                        if distSq <= radiusSq then
                            local id = nil
                            pcall(function() id = obj:GetEntityID() end)
                            local idStr = tostring(id)
                            if not seen[idStr] then
                                seen[idStr] = true
                                table.insert(results, { entity = obj, distance = math.sqrt(distSq) })
                            end
                        end
                    end
                end
            end
        end
    end)

    return results
end

--============================================================================
-- HELPERS
--============================================================================

local function dprint(msg)
    if Config.debug then
        print(string.format("[%s] %s", ModName, msg))
    end
end

--- Deal damage to an entity via StatPoolsSystem
--- Pattern from wall_hang mod (verified working)
local function DealDamage(entity, amount, instigator)
    local stats = Game.GetStatPoolsSystem()
    if not stats or not entity then return false end

    local entityID = nil
    pcall(function() entityID = entity:GetEntityID() end)
    if not entityID then return false end

    local inst = instigator or Game.GetPlayer()

    local ok, err = pcall(function()
        stats:RequestChangingStatPoolValue(
            entityID,
            gamedataStatPoolType.Health,
            -amount,     -- negative = damage
            inst,
            true,        -- process the change
            false        -- false = absolute points, true = percentage
        )
    end)
    if ok then
        return true
    else
        dprint(string.format("  DealDamage failed: %s", tostring(err)))
        return false
    end
end

--- Apply a status effect to an entity for visual/audio feedback
local function ApplyVisualEffect(entity, effectID)
    pcall(function()
        Game.GetStatusEffectSystem():ApplyStatusEffect(entity:GetEntityID(), effectID)
    end)
end

--============================================================================
-- MANUAL TIMER SYSTEM (onUpdate-based)
--============================================================================

local PendingExplosions = {}

local function StartFuse(position)
    table.insert(PendingExplosions, {
        timer = Config.fuseTime,
        position = position,
    })
    dprint(string.format("Fuse started: %.1f seconds", Config.fuseTime))
end

--============================================================================
-- EXPLOSION LOGIC
--============================================================================

local function Detonate(position)
    local player = Game.GetPlayer()
    if not player then return end

    dprint(string.format("DETONATING at (%.1f, %.1f, %.1f)  radius: %.1fm  damage: %.0f",
        position.x, position.y, position.z, Config.damageRadius, Config.damageAmount))

    local effect = ExplosionEffects[Config.grenadeType] or ExplosionEffects.frag
    local hitCount = 0

    -- 1. Find all NPCs in blast radius and deal damage
    local npcs = GetNPCsInRadius(position, Config.damageRadius)
    dprint(string.format("Found %d NPCs in blast radius", #npcs))

    for _, entry in ipairs(npcs) do
        local entity = entry.entity

        -- Skip dead NPCs
        local isDead = false
        pcall(function() isDead = entity:IsDead() end)
        if not isDead then
            -- Deal actual damage
            if DealDamage(entity, Config.damageAmount, player) then
                hitCount = hitCount + 1
                dprint(string.format("  Damaged NPC at %.1fm", entry.distance))
            end

            -- Apply visual status effect for feedback
            if Config.applyVisual then
                ApplyVisualEffect(entity, effect)
            end
        end
    end



    -- NOTE: this isn't working, compare with jetpack's version
    -- 2. Optionally damage the player if within blast radius
    if Config.damagePlayer then
        local playerPos = nil
        pcall(function() playerPos = player:GetWorldPosition() end)
        if playerPos then
            local dx = playerPos.x - position.x
            local dy = playerPos.y - position.y
            local dz = playerPos.z - position.z
            local playerDist = math.sqrt(dx * dx + dy * dy + dz * dz)
            if playerDist <= Config.damageRadius then
                DealDamage(player, Config.damageAmount, player)
                if Config.applyVisual then
                    ApplyVisualEffect(player, effect)
                end
                dprint(string.format("  Player damaged at %.1fm", playerDist))
                hitCount = hitCount + 1
            end
        end
    end




    dprint(string.format("Total entities hit: %d", hitCount))
end

--============================================================================
-- MAIN SPAWN FUNCTION
--============================================================================

local function SpawnGrenade()
    local player = Game.GetPlayer()
    if not player then
        dprint("No player found")
        return
    end

    local playerPos = nil
    pcall(function() playerPos = player:GetWorldPosition() end)
    if not playerPos then
        dprint("Could not get player position")
        return
    end

    local camSys = Game.GetCameraSystem()
    if not camSys then
        dprint("Could not get camera system")
        return
    end

    local forward = nil
    pcall(function() forward = camSys:GetActiveCameraForward() end)
    if not forward then
        dprint("Could not get camera forward vector")
        return
    end

    -- Calculate target position: playerPos + forward * spawnDistance
    local targetPos = Vector4.new(
        playerPos.x + forward.x * Config.spawnDistance,
        playerPos.y + forward.y * Config.spawnDistance,
        playerPos.z + forward.z * Config.spawnDistance,
        1.0
    )

    dprint(string.format("Player:  (%.1f, %.1f, %.1f)", playerPos.x, playerPos.y, playerPos.z))
    dprint(string.format("Forward: (%.3f, %.3f, %.3f)", forward.x, forward.y, forward.z))
    dprint(string.format("Target:  (%.1f, %.1f, %.1f)", targetPos.x, targetPos.y, targetPos.z))

    -- Start the fuse timer (tracked in onUpdate)
    StartFuse(targetPos)
end

--============================================================================
-- CYCLE GRENADE TYPE
--============================================================================

local GrenadeOrder = { "frag", "emp", "flash", "incendiary", "biohazard", "recon", "cutting" }

local function CycleGrenadeType()
    for i, t in ipairs(GrenadeOrder) do
        if t == Config.grenadeType then
            Config.grenadeType = GrenadeOrder[(i % #GrenadeOrder) + 1]
            break
        end
    end
    print(string.format("[%s] Grenade type: %s", ModName, Config.grenadeType))
end

--============================================================================
-- INIT & UPDATE
--============================================================================

registerForEvent("onInit", function()

    -- this works, but it seems heavy
    -- Track NPCs as they spawn (pattern from EnemyMultiplier)
    Observe('NPCPuppet', 'OnGameAttached', function(self)
        RegisterNPC(self)
    end)

    Observe('ScriptedPuppet', 'OnGameAttached', function(self)
        local isNPC = false
        pcall(function() isNPC = self:IsNPC() end)
        if isNPC then
            RegisterNPC(self)
        end
    end)

    print(string.format("[%s] Initialized  |  fuse: %.1fs  |  dist: %.1fm  |  blast: %.1fm  |  dmg: %.0f  |  type: %s",
        ModName, Config.fuseTime, Config.spawnDistance, Config.damageRadius, Config.damageAmount, Config.grenadeType))
    print(string.format("[%s] Bind keys in: Settings > Key Bindings > GrenadeTester", ModName))
    print(string.format("[%s] NPC tracking via Observe(NPCPuppet.OnGameAttached) + SenseManager fallback", ModName))
end)

registerForEvent("onUpdate", function(delta)
    -- Process pending explosion timers
    for i = #PendingExplosions, 1, -1 do
        local pending = PendingExplosions[i]
        pending.timer = pending.timer - delta

        if pending.timer <= 0 then
            Detonate(pending.position)
            table.remove(PendingExplosions, i)
        end
    end
end)

-- Hotkeys
registerHotkey("GrenadeTesterSpawn", "Spawn Test Grenade", function()
    SpawnGrenade()
end)

registerHotkey("GrenadeTesterCycle", "Cycle Grenade Type", function()
    CycleGrenadeType()
end)
