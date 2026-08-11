-- ============================================================
-- Custom Entity Tester 2 (CE2)
-- Red4ext-Backed OrbHackingBridge Quickhack Test
-- ============================================================
--
-- Purpose: Spawn a drone near the player and use it as executor
--   for device quickhack actions via a Red4ext-backed REDscript bridge.
--   Third attempt at customentity, using Red4ext for native pipeline support.
--
-- File: init.lua
-- Install: bin/x64/plugins/cyber_engine_tweaks/mods/customentity2/init.lua
-- Target: Cyberpunk 2077 v2.2+
-- Requires: CET 1.39.1+, REDscript, RED4ext (for native hook support)
--
-- Hotkeys (bind in Settings > Key Bindings):
--   CE2: Spawn/Despawn Drone
--   CE2: Run Ping Quickhack Test
--
-- ============================================================

local MOD_NAME = 'customentity2'
local LOG_FILE = 'customentity2/log.txt'
local BRIDGE_NAME = 'OrbHackingBridge'
local LOG_PREFIX = '[CE2]'

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
-- Spawn: Method A -- exEntitySpawner.Spawn with .ent path
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
-- Spawn: Method B -- DynamicEntitySpec + CreateEntity with TweakDB record
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
            spec.tags = { "CE2_DRONE" }
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
-- Despawn Drone (MUST be defined before SpawnDrone — Lua locals
-- are not visible before their declaration point)
-- ============================================================

local function DespawnDrone()
    Log(string.rep('=', 50))
    Log('DESPAWN DRONE')

    if state.entity then
        if state.spawnMethod == 'exEntitySpawner' then
            local ok = pcall(function() exEntitySpawner.Despawn(state.entity) end)
        elseif state.spawnMethod == 'DynamicEntitySpec' then
            local ok = pcall(function() Game.GetDynamicEntitySystem():DeleteEntity(state.entityID) end)
        end
        state.entity = nil
        state.entityID = nil
        state.pendingSpawn = false
        state.bridge = nil
        state.bridgeLoaded = false
        Log('Drone despawned')
    else
        Log('No drone to despawn')
    end
end

-- ============================================================
-- Spawn Drone
-- ============================================================

local function SpawnDrone()
    Log(string.rep('=', 50))
    Log('SPAWN DRONE')

    if state.entity then
        DespawnDrone()
    end

    if TrySpawnWithEntitySpawner() then
        Log('Drone spawned via Method A (exEntitySpawner)')
    elseif TrySpawnWithDynamicEntitySpec() then
        Log('Drone spawned via Method B (DynamicEntitySpec)')
    else
        Log('ERROR: All spawn methods failed')
    end
end

-- ============================================================
-- Run Ping Quickhack Test
-- ============================================================

local function RunPingTest()
    Log(string.rep('=', 50))
    Log('PING QUICKHACK TEST')

    if not state.entity then
        Log('NO_DRONE: No drone spawned -- press Spawn/Despawn Drone first')
        return
    end

    local player = Game.GetPlayer()
    if not player then
        Log('ERROR: No player found')
        return
    end

    -- FIX: GetLookAtObject(player) with no flags has restrictive defaults that miss
    -- distant devices. All working mods use the 3-arg version with a fallback.
    -- Try (player, true, false) first, then (player, false, false), then (player, false, true).
    local target
    local ts = Game.GetTargetingSystem()
    local tryArgs = {
        { true,  false, '(true, false)' },
        { false, false, '(false, false)' },
        { false, true,  '(false, true)' },
    }
    for _, args in ipairs(tryArgs) do
        local ok, result = pcall(function()
            return ts:GetLookAtObject(player, args[1], args[2])
        end)
        if ok and result then
            target = result
            Log(string.format('Target found with args %s', args[3]))
            break
        end
        if not ok then
            Log(string.format('Targeting attempt %s error: %s', args[3], tostring(result)))
        end
    end
    if not target then
        local pPos = player:GetWorldPosition()
        Log(string.format('NO_TARGET: Player not looking at a device (pos: %.1f, %.1f, %.1f) — tried 3 arg combos',
            pPos.x, pPos.y, pPos.z))
        return
    end

    local cOk, className = pcall(function() return target:GetClassName() end)
    Log(string.format('Target: %s', cOk and tostring(className) or 'Unknown'))
    local tOk, tPos = pcall(function() return target:GetWorldPosition() end)
    if tOk and tPos then
        local pPos = player:GetWorldPosition()
        local dist = math.sqrt((tPos.x - pPos.x)^2 + (tPos.y - pPos.y)^2 + (tPos.z - pPos.z)^2)
        Log(string.format('Target distance: %.1f m', dist))
    end

    local bridge = GetBridge()
    if not bridge then
        Log('WARNING: OrbHackingBridge not found -- check Redscript + Red4ext installation')
        return
    end

    -- Test 1: Player as executor (known good)
    Log('Test 1: Player as executor')
    local ok1, result1 = pcall(function()
        return bridge:ExecuteDeviceActionByName(target, "PingDevice", player)
    end)
    if ok1 then
        Log(string.format('Bridge result (player): %s', tostring(result1)))
    else
        Log(string.format('Bridge error (player): %s', tostring(result1)))
    end

    -- Test 2: Drone as executor (shell entity test)
    Log('Test 2: Drone as executor')
    local ok2, result2 = pcall(function()
        return bridge:ExecuteDeviceActionByName(target, "PingDevice", state.entity)
    end)
    if ok2 then
        Log(string.format('Bridge result (drone): %s', tostring(result2)))
    else
        Log(string.format('Bridge error (drone): %s', tostring(result2)))
    end

    state.testCount = state.testCount + 1
    Log(string.format('Test #%d complete', state.testCount))
end

-- ============================================================
-- Hotkeys (MUST be at file root level, before registerForEvent)
-- ============================================================

-- FIX: Wrap hotkey callbacks in SafeCall to prevent cascading crashes.
-- Without pcall, an uncaught error in a hotkey callback poisons CET's
-- Lua state and breaks all subsequent hotkey presses.
local function SafeCall(name, fn)
    local ok, err = pcall(fn)
    if not ok then
        Log(string.format('ERROR in %s: %s', name, tostring(err)))
    end
    return ok
end

registerHotkey("CE2_SpawnDespawnDrone", "CE2: Spawn/Despawn Drone", function()
    SafeCall('SpawnDrone', SpawnDrone)
end)

registerHotkey("CE2_RunPingTest", "CE2: Run Ping Quickhack Test", function()
    SafeCall('RunPingTest', RunPingTest)
end)

-- ============================================================
-- Events
-- ============================================================

registerForEvent("onInit", function()
    state.bridge = nil
    state.bridgeLoaded = false
    Log('CE2 initialized -- requires Red4ext + Redscript + CET')
    Log('Red4ext plugin: bin/x64/plugins/red4ext/plugins/OrbHackingBridge/OrbHackingBridge.dll')
    Log('Redscript: r6/scripts/OrbHackingBridge.reds')
end)

registerForEvent("onUpdate", function(dt)
    -- Poll for pending spawn entity
    if state.pendingSpawn and state.entityID then
        state.tickCount = state.tickCount + 1
        local ok, entity = pcall(function()
            return Game.FindEntityByID(state.entityID)
        end)
        if ok and entity then
            state.entity = entity
            state.pendingSpawn = false
            Log(string.format('DRONE SPAWNED SUCCESSFULLY! Tick: %d, Method: %s, Path: %s',
                state.tickCount, state.spawnMethod, state.spawnPath))
            Log(string.format('Entity: %s', tostring(entity)))

            -- Try to get bridge on spawn
            GetBridge()
        elseif state.tickCount > 300 then
            Log(string.format('SPAWN TIMEOUT: Entity not found after %d ticks', state.tickCount))
            state.pendingSpawn = false
        end
    end
end)

registerForEvent("onShutdown", function()
    if state.entity then
        DespawnDrone()
    end
    Log('CE2 stopped')
end)
