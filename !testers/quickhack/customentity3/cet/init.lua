-- ============================================================
-- Custom Entity Tester 3 (CE3)
-- OrbHackingBridge Quickhack Test -- No Red4ext
-- ============================================================
--
-- Purpose: Test the REDscript OrbHackingBridge bridge WITHOUT Red4ext.
--   CE2e proved the bridge pipeline works end-to-end with just CET + REDscript.
--   CE3 removes Red4ext entirely to confirm it is not needed.
--
--   CE3 is a direct copy of CE2e with:
--     1. No Red4ext dependency (no DLL, no red4ext/ folder)
--     2. All Red4ext references removed from comments and requirements
--
--   Uses phased testing:
--     Phase 1: Player as executor (proves bridge + SetUp + native pipeline)
--     Phase 2: Drone as executor (tests IsPossible gate)
--
-- Ships its own REDscript (OrbHackingBridge.reds).
-- No Red4ext required.
--
-- File: init.lua
-- Install: bin/x64/plugins/cyber_engine_tweaks/mods/customentity3/init.lua
-- Target: Cyberpunk 2077 v2.2+
-- Requires: CET 1.39.1+, REDscript
--
-- Hotkeys (bind in Settings > Key Bindings):
--   CE3: Spawn/Despawn Drone
--   CE3: Run Ping Quickhack Test
--   CE3: List Device Actions
--
-- ============================================================

local MOD_NAME = 'customentity3'
local BRIDGE_NAME = 'OrbHackingBridge'
local LOG_PREFIX = '[CE3]'

-- Drone entity paths (verified valid in customentity1a/2)
local DRONE_ENT_PATHS = {
    "base\\vehicles\\special\\av_zetatech_bombus__basic.ent",
    "ep1\\vehicles\\special\\av_militech_wyvern__basic_01_ep1.ent",
    "ep1\\vehicles\\special\\av_zetatech_octant__basic_01_ep1.ent",
}

-- Drone TweakDB character records (fallback)
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
}

-- ============================================================
-- Logging
-- ============================================================

local function Log(msg)
    local ts = os.date('%Y-%m-%d %H:%M:%S')
    print(string.format('[%s] %s %s', ts, LOG_PREFIX, msg))
end

-- ============================================================
-- Position helpers (adapted from AMM Util, proven in 1a/2)
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
-- Bridge Access -- GetScriptableSystemsContainer():Get()
-- ============================================================

local function GetBridge()
    if state.bridge then return state.bridge end

    -- Attempt 1: String name via GetScriptableSystemsContainer
    local ok1, bridge1 = pcall(function()
        return Game.GetScriptableSystemsContainer():Get(BRIDGE_NAME)
    end)
    if ok1 and bridge1 then
        state.bridge = bridge1
        state.bridgeLoaded = true
        Log(string.format('Bridge loaded via GetScriptableSystemsContainer():Get("%s")', BRIDGE_NAME))
        return bridge1
    end
    Log(string.format('GetScriptableSystemsContainer():Get("%s") -> ok=%s bridge=%s',
        BRIDGE_NAME, tostring(ok1), tostring(bridge1 ~= nil)))

    -- Attempt 2: CName via GetScriptableSystemsContainer
    local ok2, bridge2 = pcall(function()
        return Game.GetScriptableSystemsContainer():Get(CName.new(BRIDGE_NAME))
    end)
    if ok2 and bridge2 then
        state.bridge = bridge2
        state.bridgeLoaded = true
        Log(string.format('Bridge loaded via GetScriptableSystemsContainer():Get(CName.new("%s"))', BRIDGE_NAME))
        return bridge2
    end
    Log(string.format('GetScriptableSystemsContainer():Get(CName.new("%s")) -> ok=%s bridge=%s',
        BRIDGE_NAME, tostring(ok2), tostring(bridge2 ~= nil)))

    -- Attempt 3: Old API (for diagnostic -- expected to fail, wrapped in pcall)
    local ok3, bridge3 = pcall(function()
        return Game.GetScriptableSystem(BRIDGE_NAME)
    end)
    Log(string.format('GetScriptableSystem("%s") [old API] -> ok=%s bridge=%s',
        BRIDGE_NAME, tostring(ok3), tostring(bridge3 ~= nil)))

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
            spec.tags = { "CE3_DRONE" }
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
-- Despawn Drone
-- ============================================================

local function DespawnDrone()
    Log(string.rep('=', 50))
    Log('DESPAWN DRONE')

    if state.entity then
        if state.spawnMethod == 'exEntitySpawner' then
            pcall(function() exEntitySpawner.Despawn(state.entity) end)
        elseif state.spawnMethod == 'DynamicEntitySpec' then
            pcall(function() Game.GetDynamicEntitySystem():DeleteEntity(state.entityID) end)
        end
        state.entity = nil
        state.entityID = nil
        state.pendingSpawn = false
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
-- Target Acquisition
-- ============================================================

local function AcquireTarget()
    local player = Game.GetPlayer()
    if not player then
        Log('ERROR: No player found')
        return nil
    end

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
            Log(string.format('Target found with args %s', args[3]))
            return result
        end
    end

    local pPos = player:GetWorldPosition()
    Log(string.format('NO_TARGET: Player not looking at a device (pos: %.1f, %.1f, %.1f)',
        pPos.x, pPos.y, pPos.z))
    return nil
end

-- ============================================================
-- List Device Actions -- diagnostic hotkey
-- ============================================================

local function ListDeviceActions()
    Log(string.rep('=', 50))
    Log('LIST DEVICE ACTIONS')

    local player = Game.GetPlayer()
    if not player then
        Log('ERROR: No player found')
        return
    end

    local target = AcquireTarget()
    if not target then return end

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
        Log('ERROR: OrbHackingBridge not found -- check REDscript deployment')
        return
    end

    -- List actions available for player as executor
    Log('--- Actions for Player as executor ---')
    local ok1, result1 = pcall(function()
        return bridge:ListAvailableActions(target, player)
    end)
    if ok1 then
        Log(string.format('Player actions: %s', tostring(result1)))
    else
        Log(string.format('Player actions error: %s', tostring(result1)))
    end

    -- List actions available for drone as executor (if spawned)
    if state.entity then
        Log('--- Actions for Drone as executor ---')
        local ok2, result2 = pcall(function()
            return bridge:ListAvailableActions(target, state.entity)
        end)
        if ok2 then
            Log(string.format('Drone actions: %s', tostring(result2)))
        else
            Log(string.format('Drone actions error: %s', tostring(result2)))
        end
    else
        Log('--- Drone actions: Skipped (no drone spawned) ---')
    end
end

-- ============================================================
-- Run Ping Quickhack Test -- Phased: Phase 1 (player) + Phase 2 (drone)
-- ============================================================

local function RunPingTest()
    Log(string.rep('=', 50))
    Log('PING QUICKHACK TEST')
    state.testCount = state.testCount + 1

    local player = Game.GetPlayer()
    if not player then
        Log('ERROR: No player found')
        return
    end

    -- Acquire target device
    local target = AcquireTarget()
    if not target then return end

    local cOk, className = pcall(function() return target:GetClassName() end)
    Log(string.format('Target: %s', cOk and tostring(className) or 'Unknown'))
    local tOk, tPos = pcall(function() return target:GetWorldPosition() end)
    if tOk and tPos then
        local pPos = player:GetWorldPosition()
        local dist = math.sqrt((tPos.x - pPos.x)^2 + (tPos.y - pPos.y)^2 + (tPos.z - pPos.z)^2)
        Log(string.format('Target distance: %.1f m', dist))
    end

    -- Get bridge (fixed REDscript with quickhack clearance)
    local bridge = GetBridge()
    if not bridge then
        Log('ERROR: OrbHackingBridge not found -- check REDscript deployment')
        Log('Ensure r6/scripts/OrbHackingBridge.reds is the CE3 version (with GetInteractionClearance)')
        return
    end

    -- ============================================================
    -- PHASE 1: Player as executor
    -- ============================================================
    Log('--- PHASE 1: Player as executor ---')

    -- Dump available actions first for diagnostics
    local dumpOk, dumpResult = pcall(function()
        return bridge:ListAvailableActions(target, player)
    end)
    if dumpOk then
        Log(string.format('Available actions: %s', tostring(dumpResult)))
    else
        Log(string.format('Available actions dump error: %s', tostring(dumpResult)))
    end

    -- Try specific action (Ping)
    local ok1, result1 = pcall(function()
        return bridge:ExecuteDeviceActionByName(target, "Ping", player)
    end)
    if ok1 then
        Log(string.format('Phase 1 result (Ping): %s', tostring(result1)))

        -- If NO_ACTION, try fallback: first available action
        if tostring(result1):match('^NO_ACTION') then
            Log('Phase 1 Ping not found -- trying first available action as fallback')
            local ok1b, result1b = pcall(function()
                return bridge:ExecuteFirstAvailableAction(target, player)
            end)
            if ok1b then
                Log(string.format('Phase 1 fallback result: %s', tostring(result1b)))
            else
                Log(string.format('Phase 1 fallback error: %s', tostring(result1b)))
            end
        end
    else
        Log(string.format('Phase 1 error: %s', tostring(result1)))
    end

    -- ============================================================
    -- PHASE 2: Drone as executor (only if drone is spawned)
    -- ============================================================
    if state.entity then
        Log('--- PHASE 2: Drone as executor ---')

        -- Dump available actions for drone
        local dumpOk2, dumpResult2 = pcall(function()
            return bridge:ListAvailableActions(target, state.entity)
        end)
        if dumpOk2 then
            Log(string.format('Drone available actions: %s', tostring(dumpResult2)))
        else
            Log(string.format('Drone actions dump error: %s', tostring(dumpResult2)))
        end

        local ok2, result2 = pcall(function()
            return bridge:ExecuteDeviceActionByName(target, "Ping", state.entity)
        end)
        if ok2 then
            Log(string.format('Phase 2 result (Ping): %s', tostring(result2)))

            if tostring(result2):match('^NO_ACTION') then
                Log('Phase 2 Ping not found -- trying first available action as fallback')
                local ok2b, result2b = pcall(function()
                    return bridge:ExecuteFirstAvailableAction(target, state.entity)
                end)
                if ok2b then
                    Log(string.format('Phase 2 fallback result: %s', tostring(result2b)))
                else
                    Log(string.format('Phase 2 fallback error: %s', tostring(result2b)))
                end
            end
        else
            Log(string.format('Phase 2 error: %s', tostring(result2)))
        end
    else
        Log('--- PHASE 2: Skipped (no drone spawned) ---')
        Log('Spawn a drone first with CE3: Spawn/Despawn Drone, then re-run this test')
    end

    Log(string.format('Test #%d complete', state.testCount))
end

-- ============================================================
-- Hotkeys (MUST be at file root level, before registerForEvent)
-- ============================================================

local function SafeCall(name, fn)
    local ok, err = pcall(fn)
    if not ok then
        Log(string.format('ERROR in %s: %s', name, tostring(err)))
    end
    return ok
end

registerHotkey("CE3_SpawnDespawnDrone", "CE3: Spawn/Despawn Drone", function()
    SafeCall('SpawnDrone', SpawnDrone)
end)

registerHotkey("CE3_RunPingTest", "CE3: Run Ping Quickhack Test", function()
    SafeCall('RunPingTest', RunPingTest)
end)

registerHotkey("CE3_ListDeviceActions", "CE3: List Device Actions", function()
    SafeCall('ListDeviceActions', ListDeviceActions)
end)

-- ============================================================
-- Events
-- ============================================================

registerForEvent("onInit", function()
    state.bridge = nil
    state.bridgeLoaded = false

    Log('CE3 initialized -- quickhack clearance fix + action dump')
    Log('Fixes: GetInteractionClearance + pcall diagnostic + action dump + fallback')

    -- Diagnostic: log which APIs exist (wrapped in pcall to prevent crash)
    local gsOk, gsExists = pcall(function()
        return Game.GetScriptableSystemsContainer ~= nil
    end)
    Log(string.format('API check: GetScriptableSystemsContainer = %s', tostring(gsOk and gsExists or false)))

    -- Old API check (wrapped in pcall -- CE2b crashed here because
    -- accessing Game.GetScriptableSystem throws when it doesn't exist)
    local oldOk, oldExists = pcall(function()
        return Game.GetScriptableSystem ~= nil
    end)
    Log(string.format('API check: GetScriptableSystem = %s', tostring(oldOk and oldExists or false)))

    -- Try to load bridge early
    GetBridge()
end)

registerForEvent("onUpdate", function(dt)
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
    Log('CE3 stopped')
end)
