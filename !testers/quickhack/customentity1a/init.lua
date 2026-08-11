-- ============================================================
-- Custom Entity Tester 1a (CE1a)
-- Minimal Drone Spawn — CET Only, No Redscript
-- ============================================================
--
-- Purpose: Spawn a drone near the player using two proven methods.
--   Method A: exEntitySpawner.Spawn with a valid .ent file path
--   Method B: DynamicEntitySpec + CreateEntity with a TweakDB record
--
-- File: init.lua
-- Install: bin/x64/plugins/cyber_engine_tweaks/mods/customentity1a/init.lua
-- Target: Cyberpunk 2077 v2.2+
-- Requires: CET 1.39.1+ (NO redscript, NO RED4ext needed)
--
-- Hotkeys (bind in Settings > Key Bindings):
--   CE1a: Spawn Drone
--   CE1a: Despawn Drone
--
-- ============================================================

local MOD_NAME = 'customentity1a'
local LOG_FILE = 'customentity1a/log.txt'
local LOG_PREFIX = '[CE1a]'

-- Drone entity paths (from Cyberscript Core — confirmed valid in game archives)
local DRONE_ENT_PATHS = {
    "base\\vehicles\\special\\av_zetatech_bombus__basic.ent",
    "ep1\\vehicles\\special\\av_militech_wyvern__basic_01_ep1.ent",
    "ep1\\vehicles\\special\\av_zetatech_octant__basic_01_ep1.ent",
}

-- Drone TweakDB character records (from Cyberscript Core)
local DRONE_TWEAK_RECORDS = {
    "Character.aldecaldos_base_drone_bombus",
    "Character.aldecaldos_base_drone_wyvern",
    "Character.arasaka_base_drone_octant",
    "Character.arasaka_base_drone_wyvern",
}

-- State
local state = {
    entityID = nil,
    entity = nil,
    pendingSpawn = false,
    spawnMethod = '',
    spawnPath = '',
    tickCount = 0,
}

-- ============================================================
-- Logging
-- ============================================================

local function Log(msg)
    local ts = os.date('%Y-%m-%d %H:%M:%S')
    local line = string.format('[%s] %s %s', ts, LOG_PREFIX, msg)
    print(line)
    local file = io.open(LOG_FILE, 'a')
    if file then
        file:write(line .. '\n')
        file:close()
    end
end

-- ============================================================
-- Position helpers (adapted from AMM Util)
-- ============================================================

local function GetDirection(angle)
    return Vector4.RotateAxis(Game.GetPlayer():GetWorldForward(), Vector4.new(0, 0, 1, 0), angle / 180.0 * Pi())
end

local function GetSpawnPosition(distance, angle)
    local pos = Game.GetPlayer():GetWorldPosition()
    local heading = GetDirection(angle)
    return Vector4.new(pos.x + heading.x * distance, pos.y + heading.y * distance, pos.z + heading.z, pos.w + heading.w)
end

local function GetSpawnOrientation(angle)
    return EulerAngles.ToQuat(Vector4.ToRotation(GetDirection(angle)))
end

-- ============================================================
-- Spawn: Method A — exEntitySpawner.Spawn with .ent path
-- ============================================================

local function TrySpawnWithEntitySpawner()
    local player = Game.GetPlayer()
    if not player then
        Log('ERROR: No player found')
        return false
    end

    local spawnTransform = player:GetWorldTransform()
    local pos = GetSpawnPosition(3.0, 0.0)
    spawnTransform:SetPosition(pos)

    for i, entPath in ipairs(DRONE_ENT_PATHS) do
        Log(string.format('Method A: Trying [%d/%d]: %s', i, #DRONE_ENT_PATHS, entPath))
        local ok, entityID = pcall(function()
            return exEntitySpawner.Spawn(entPath, spawnTransform, '')
        end)
        if ok and entityID then
            state.entityID = entityID
            state.pendingSpawn = true
            state.spawnMethod = 'exEntitySpawner'
            state.spawnPath = entPath
            Log(string.format('Method A SUCCESS: entity ID: %s (pending...)', tostring(entityID)))
            return true
        end
        if ok and not entityID then
            Log(string.format('Method A: Path returned nil: %s', entPath))
        end
        if not ok then
            Log(string.format('Method A: Error for %s: %s', entPath, tostring(entityID)))
        end
    end

    Log('Method A: All .ent paths failed')
    return false
end

-- ============================================================
-- Spawn: Method B — DynamicEntitySpec + CreateEntity with TweakDB record
-- ============================================================

local function TrySpawnWithDynamicEntitySpec()
    local entitySystem = Game.GetDynamicEntitySystem()
    if not entitySystem then
        Log('ERROR: Game.GetDynamicEntitySystem() returned nil')
        return false
    end

    for i, recordPath in ipairs(DRONE_TWEAK_RECORDS) do
        Log(string.format('Method B: Trying [%d/%d]: %s', i, #DRONE_TWEAK_RECORDS, recordPath))
        local ok, result = pcall(function()
            local spec = DynamicEntitySpec.new()
            spec.persistState = false
            spec.persistSpawn = false
            spec.alwaysSpawned = false
            spec.spawnInView = true
            spec.recordID = TweakDBID.new(recordPath)
            spec.tags = { "CE1A_DRONE" }
            spec.position = GetSpawnPosition(3.0, 0.0)
            spec.orientation = GetSpawnOrientation(-180.0)
            return entitySystem:CreateEntity(spec)
        end)
        if ok and result then
            state.entityID = result
            state.pendingSpawn = true
            state.spawnMethod = 'DynamicEntitySpec'
            state.spawnPath = recordPath
            Log(string.format('Method B SUCCESS: entity ID: %s (pending...)', tostring(result)))
            return true
        end
        if ok and not result then
            Log(string.format('Method B: Record returned nil: %s', recordPath))
        end
        if not ok then
            Log(string.format('Method B: Error for %s: %s', recordPath, tostring(result)))
        end
    end

    Log('Method B: All TweakDB records failed')
    return false
end

-- ============================================================
-- Spawn Drone
-- ============================================================

local function SpawnDrone()
    Log(string.rep('=', 50))
    Log('SPAWN DRONE')

    if state.entity or state.pendingSpawn then
        Log('Drone exists, despawning first...')
        DespawnDrone()
    end

    state.entity = nil
    state.entityID = nil
    state.pendingSpawn = false
    state.spawnMethod = ''
    state.spawnPath = ''
    state.tickCount = 0

    -- Try Method A first (exEntitySpawner with .ent path)
    if exEntitySpawner then
        Log('Trying Method A: exEntitySpawner.Spawn with .ent paths...')
        if TrySpawnWithEntitySpawner() then
            Log(string.format('Drone spawn requested via %s. Polling for entity...', state.spawnMethod))
            return
        end
    else
        Log('exEntitySpawner not available, skipping Method A')
    end

    -- Fall back to Method B (DynamicEntitySpec with TweakDB record)
    Log('Trying Method B: DynamicEntitySpec + CreateEntity with TweakDB records...')
    if TrySpawnWithDynamicEntitySpec() then
        Log(string.format('Drone spawn requested via %s. Polling for entity...', state.spawnMethod))
        return
    end

    Log('ERROR: Both spawn methods failed. Check that drone paths/records exist in your game version.')
end

-- ============================================================
-- Despawn Drone
-- ============================================================

local function DespawnDrone()
    Log(string.rep('=', 50))
    Log('DESPAWN DRONE')

    if state.pendingSpawn and not state.entity then
        Log('Spawn still pending, cancelling...')
        state.pendingSpawn = false
    end

    if state.entityID then
        local ok, err = pcall(function()
            if exEntitySpawner and state.spawnMethod == 'exEntitySpawner' then
                -- exEntitySpawner.Despawn takes entity handle, not ID
                if state.entity then
                    exEntitySpawner.Despawn(state.entity)
                else
                    Game.GetDynamicEntitySystem():DeleteEntity(state.entityID)
                end
            else
                Game.GetDynamicEntitySystem():DeleteEntity(state.entityID)
            end
        end)
        if ok then
            Log(string.format('Despawned entity: %s', tostring(state.entityID)))
        else
            Log(string.format('Despawn error: %s', tostring(err)))
        end
    else
        Log('No entity to despawn')
    end

    state.entity = nil
    state.entityID = nil
    state.pendingSpawn = false
    state.spawnMethod = ''
    state.spawnPath = ''
    state.tickCount = 0
end

-- ============================================================
-- Hotkeys (MUST be at file root level — CET scans before onInit)
-- ============================================================

registerHotkey('CE1a_SpawnDrone', 'CE1a: Spawn Drone', function()
    SpawnDrone()
end)

registerHotkey('CE1a_DespawnDrone', 'CE1a: Despawn Drone', function()
    DespawnDrone()
end)

-- ============================================================
-- Events
-- ============================================================

registerForEvent('onInit', function()
    Log(string.rep('=', 50))
    Log('Custom Entity Tester 1a (CE1a) initialized')
    Log('CET-only mod — no redscript, no RED4ext required')
    Log(string.format('Drone .ent paths: %d candidates', #DRONE_ENT_PATHS))
    Log(string.format('Drone TweakDB records: %d candidates', #DRONE_TWEAK_RECORDS))
    Log('Bind hotkeys in Settings > Key Bindings:')
    Log('  CE1a: Spawn Drone')
    Log('  CE1a: Despawn Drone')
end)

registerForEvent('onUpdate', function(deltaTime)
    -- Poll for pending entity spawn
    if state.pendingSpawn and state.entityID then
        state.tickCount = state.tickCount + 1
        local entity = Game.FindEntityByID(state.entityID)
        if entity then
            state.entity = entity
            state.pendingSpawn = false
            local pos = entity:GetWorldPosition()
            Log(string.rep('=', 50))
            Log('DRONE SPAWNED SUCCESSFULLY!')
            Log(string.format('  Method: %s', state.spawnMethod))
            Log(string.format('  Path/Record: %s', state.spawnPath))
            Log(string.format('  Entity ID: %s', tostring(state.entityID)))
            Log(string.format('  Position: (%.2f, %.2f, %.2f)', pos.x, pos.y, pos.z))
            Log(string.format('  Ticks waited: %d', state.tickCount))
            Log(string.rep('=', 50))
        elseif state.tickCount > 300 then
            -- ~5 seconds at 60fps, give up
            Log('WARNING: Entity did not appear after 300 ticks. Spawn may have failed silently.')
            state.pendingSpawn = false
        end
    end
end)
