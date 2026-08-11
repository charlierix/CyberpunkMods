-- ============================================================
-- Custom Entity Tester 1b (CE1b)
-- Shell Entity Spawn + REDscript Bridge Quickhack Test
-- ============================================================
--
-- Purpose: Spawn a drone near the player and use it as executor
--   for device quickhack actions via a REDscript bridge.
--   Second attempt at customentity1, incorporating lessons from
--   customentity1a (proven entity paths + spawn methods).
--
-- File: init.lua
-- Install: bin/x64/plugins/cyber_engine_tweaks/mods/customentity1b/init.lua
-- Target: Cyberpunk 2077 v2.2+
-- Requires: CET 1.39.1+, REDscript (for OrbHackingBridge)
--
-- Hotkeys (bind in Settings > Key Bindings):
--   CE1b: Spawn/Despawn Drone
--   CE1b: Run Ping Quickhack Test
--
-- ============================================================

local MOD_NAME = 'customentity1b'
local LOG_FILE = 'customentity1b/log.txt'
local BRIDGE_NAME = 'OrbHackingBridge'
local LOG_PREFIX = '[CE1b]'

-- Drone entity paths (verified valid in customentity1a)
local DRONE_ENT_PATHS = {
    "base\\vehicles\\special\\av_zetatech_bombus__basic.ent",
    "ep1\\vehicles\\special\\av_militech_wyvern__basic_01_ep1.ent",
    "ep1\\vehicles\\special\\av_zetatech_octant__basic_01_ep1.ent",
}

-- Drone TweakDB character records (fallback from customentity1a)
local DRONE_TWEAK_RECORDS = {
    "Character.aldecaldos_base_drone_bombus",
    "Character.aldecaldos_base_drone_wyvern",
    "Character.arasaka_base_drone_octant",
    "Character.arasaka_base_drone_wyvern",
}

-- ============================================================
-- State
-- ============================================================

local state = {
    entity = nil,
    entityID = nil,
    pendingSpawn = false,
    spawnMethod = '',
    spawnPath = '',
    tickCount = 0,
    bridge = nil,
    bridgeLoaded = false,
    testCount = 0,
    lastTestResult = '',
}

-- ============================================================
-- Logging
-- ============================================================

local function Log(msg)
    local ts = os.date('%Y-%m-%d %H:%M:%S')
    local line = string.format('[%s] %s %s', ts, LOG_PREFIX, msg)
    print(line)
    -- local file = io.open(LOG_FILE, 'a')
    -- if file then
    --     file:write(line .. '\n')
    --     file:close()
    -- end
end

-- ============================================================
-- Position helpers (adapted from AMM Util, proven in 1a)
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
-- Bridge Access
-- ============================================================

local function GetBridge()
    if state.bridge then return state.bridge end
    local ok, bridge = pcall(function()
        return Game.GetScriptableSystem(BRIDGE_NAME)
    end)
    if ok and bridge then
        state.bridge = bridge
        state.bridgeLoaded = true
        Log(string.format('Bridge loaded: %s', BRIDGE_NAME))
        return bridge
    end
    return nil
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
            spec.tags = { "CE1B_DRONE" }
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

    Log('ERROR: All spawn methods failed')
end

-- ============================================================
-- Despawn Drone
-- ============================================================

local function DespawnDrone()
    Log(string.rep('=', 50))
    Log('DESPAWN DRONE')

    if state.entity then
        -- Despawn using the correct API based on spawn method
        if state.spawnMethod == 'DynamicEntitySpec' then
            Game.GetDynamicEntitySystem():RemoveEntity(state.entityID)
        else
            exEntitySpawner.Despawn(state.entity)
        end

        Log(string.format('Despawned entity: %s', tostring(state.entityID)))
        state.entity = nil
        state.entityID = nil
        state.pendingSpawn = false
    else
        Log('No drone to despawn')
    end
end

-- ============================================================
-- Get Target Device
-- ============================================================

local function GetTargetDevice()
    local player = Game.GetPlayer()
    if not player then return nil end
    local target = player:GetLookAtObject()
    return target
end

local function GetClassName(obj)
    local ok, name = pcall(function() return obj:GetClassName() end)
    if ok then return tostring(name) end
    return 'unknown'
end

-- ============================================================
-- Run Ping Quickhack Test
-- ============================================================

local function RunPingTest()
    Log(string.rep('=', 50))
    Log('RUN PING QUICKHACK TEST')

    -- Load bridge if not loaded
    if not state.bridgeLoaded then
        GetBridge()
    end

    if not state.bridgeLoaded then
        Log('WARNING: OrbHackingBridge not loaded -- cannot run ping test')
        Log('Ensure OrbHackingBridge.reds is installed at r6/scripts/OrbHackingBridge.reds')
        return
    end

    if not state.entity and not state.pendingSpawn then
        Log('ERROR: No drone spawned -- spawn one first')
        return
    end

    if state.pendingSpawn then
        Log('ERROR: Entity still pending -- wait for spawn to complete')
        return
    end

    if not state.entity then
        Log('ERROR: No drone entity -- spawn one first')
        return
    end

    -- Target device -- look at object
    local target = GetTargetDevice()
    if not target then
        Log('NO_TARGET: Player not looking at a hackable device')
        return
    end

    local targetClass = GetClassName(target)
    Log(string.format('Target device: %s (class: %s)', tostring(target), targetClass))

    -- Try with player as executor first (known good), then drone entity
    local executors = { GetPlayer(), state.entity }
    local executorNames = { 'player', 'drone' }

    for i, executor in ipairs(executors) do
        if executor then
            Log(string.format('Executor [%d]: %s', i, executorNames[i]))
            local ok, result = pcall(function()
                return state.bridge:ExecuteDeviceActionByName(target, 'PingDevice', executor)
            end)
            if ok then
                Log(string.format('Bridge result: %s', tostring(result)))
                state.lastTestResult = tostring(result)
                state.testCount = state.testCount + 1
            else
                Log(string.format('Bridge call failed: %s', tostring(result)))
            end
        end
    end
end

-- ============================================================
-- onUpdate -- Poll for entity appearance
-- ============================================================

registerForEvent("onUpdate", function()
    if not state.pendingSpawn then return end
    state.tickCount = state.tickCount + 1

    if not state.entityID then return end

    local entity = Game.FindEntityByID(state.entityID)
    if entity then
        state.pendingSpawn = false
        state.entity = entity

        Log(string.rep('=', 50))
        Log('DRONE SPAWNED SUCCESSFULLY!')
        Log(string.format('  Method: %s', state.spawnMethod))
        Log(string.format('  Path/Record: %s', state.spawnPath))
        Log(string.format('  Entity ID: %s', tostring(state.entityID)))

        local pos = entity:GetWorldPosition()
        Log(string.format('  Position: (%.2f, %.2f, %.2f)', pos.x, pos.y, pos.z))
        Log(string.format('  Ticks waited: %d', state.tickCount))
        Log(string.rep('=', 50))
    end
end)

-- ============================================================
-- onInit
-- ============================================================

registerForEvent("onInit", function()
    Log(string.rep('=', 50))
    Log('Custom Entity Tester 1b (CE1b) initialized')
    Log('Spawn drone + REDscript bridge quickhack test')
    Log(string.format('Drone .ent paths: %d candidates', #DRONE_ENT_PATHS))
    Log(string.format('Drone TweakDB records: %d candidates', #DRONE_TWEAK_RECORDS))
    Log('Bind hotkeys in Settings > Key Bindings:')
    Log('  CE1b: Spawn/Despawn Drone')
    Log('  CE1b: Run Ping Quickhack Test')

    -- Try to load bridge
    GetBridge()

    if not state.bridgeLoaded then
        Log('WARNING: OrbHackingBridge not found. Is REDscript mod installed?')
        Log('Drone spawning will work but quickhack tests will fail.')
    end

    state.tickCount = 0
end)

-- ============================================================
-- Hotkeys (root level -- CET scans before onInit)
-- ============================================================

registerHotkey("CE1b_SpawnDespawnDrone", "CE1b: Spawn/Despawn Drone", function()
    if state.entity or state.pendingSpawn then
        DespawnDrone()
    else
        SpawnDrone()
    end
end)

registerHotkey("CE1b_RunPingTest", "CE1b: Run Ping Quickhack Test", function()
    RunPingTest()
end)

-- ============================================================
-- EOF
-- ============================================================
