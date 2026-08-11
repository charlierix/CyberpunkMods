-- ============================================================
-- Custom Entity Tester 1 (CE1)
-- Shell Entity Creation + REDscript Bridge Validation
-- ============================================================
--
-- Purpose: Test creating and instantiating a custom entity
--   that can serve as a cyberware proxy for device hacking.
--   Phase 1: prove the REDscript bridge (SetUp + native
--   pipeline) produces visible effects.
--
-- File: init.lua
-- Install: bin/x64/plugins/cyber_engine_tweaks/mods/customentity1/init.lua
-- Target: Cyberpunk 2077 v2.2+
-- Requires: CET 1.39.1+, REDscript, RED4ext
--
-- Hotkeys (bind in Settings > Key Bindings):
--   CE1: Spawn/Despawn Shell Entity
--   CE1: Run Ping Quickhack Test
--   CE1: Toggle ImGui Window
--   CE1: Reset State
--
-- ============================================================

local MOD_NAME = 'customentity1'
local LOG_FILE = 'customentity1/log.txt'
local BRIDGE_NAME = 'OrbHackingBridge'
local LOG_PREFIX = '[CE1]'

-- Entity template paths. exEntitySpawner.Spawn returns nil silently
-- when the entity path is not found by the engine. We try multiple
-- paths and fall back to WorldFunctionalTests.SpawnEntity if all fail.
local ENTITY_PATHS = {
    "base\\_ieee\\ieee_03_km.ent",
    "base\\_ieee\\ieee_04_km.ent",
    "base\\_ieee\\ieee_05_km.ent",
    "base\\_ieee\\ieee_06_km.ent",
    "base\\_ieee\\ieee_07_km.ent",
    "base\\_ieee\\ieee_08_km.ent",
    "base\\_ieee\\init_spawner_demo.ent",
}
local ENTITY_APPEARANCE = ''

-- ============================================================
-- State
-- ============================================================

local state = {
    shellEntity = nil,
    shellEntityID = nil,
    shellEntityValid = false,
    bridge = nil,
    bridgeLoaded = false,
    targetDevice = nil,
    targetDeviceName = '',
    testCount = 0,
    testResults = {},
    lastTestResult = '',
    lastTestTime = '',
    windowVisible = false,
    logEntries = {},
    initialized = false,
    pendingSpawn = false,
    currentEntityPath = '',
}

-- ============================================================
-- Logging
-- ============================================================

local function Log(msg)
    local ts = os.date('%Y-%m-%d %H:%M:%S')
    local line = string.format('[%s] %s %s', ts, LOG_PREFIX, msg)
    print(line)
    table.insert(state.logEntries, line)
    if #state.logEntries > 200 then
        table.remove(state.logEntries, 1)
    end
    local file = io.open(LOG_FILE, 'a')
    if file then
        file:write(line .. '\n')
        file:close()
    end
end

local function LogSection(title)
    Log(string.rep('=', 60))
    Log(title)
    Log(string.rep('=', 60))
end

-- ============================================================
-- SafeCall
-- ============================================================

local function SafeCall(name, func, ...)
    local args = {...}
    local ok, result = pcall(function()
        return func(table.unpack(args))
    end)
    if not ok then
        Log(string.format('ERROR in %s: %s', name, tostring(result)))
        return nil, tostring(result)
    end
    return result, nil
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
-- Entity Management
-- ============================================================

local function GetPlayer()
    return Game.GetPlayer()
end

local function SpawnShellEntity()
    LogSection('SPAWN SHELL ENTITY')
    if state.shellEntity then
        Log('Entity exists, despawning first...')
        DespawnShellEntity()
    end
    local player = GetPlayer()
    if not player then
        Log('ERROR: No player found')
        return false
    end
    local pos = player:GetWorldPosition()
    pos.z = pos.z + 2.0
    pos.y = pos.y + 2.0
    Log(string.format('Spawn pos: (%.2f, %.2f, %.2f)', pos.x, pos.y, pos.z))

    local spawnTransform = player:GetWorldTransform()
    spawnTransform:SetPosition(pos)

    -- Check if exEntitySpawner exists (note: it is userdata, not a table, in CET)
    if not exEntitySpawner then
        Log('ERROR: exEntitySpawner is not available in this CET version')
        Log('Trying WorldFunctionalTests.SpawnEntity as fallback...')
        for i, entityPath in ipairs(ENTITY_PATHS) do
            Log(string.format('Trying entity path [%d/%d]: %s', i, #ENTITY_PATHS, entityPath))
            local ok, entityID = SafeCall('WorldFunctionalTests.SpawnEntity', function()
                return WorldFunctionalTests.SpawnEntity(entityPath, spawnTransform, ENTITY_APPEARANCE)
            end)
            if ok and entityID then
                state.shellEntityID = entityID
                state.pendingSpawn = true
                state.shellEntityValid = false
                state.shellEntity = nil
                state.currentEntityPath = entityPath
                Log(string.format('Spawn requested via WorldFunctionalTests, entity ID: %s (pending...)', tostring(entityID)))
                return true
            end
            if ok and not entityID then
                Log(string.format('Path not found (returned nil): %s', entityPath))
            end
        end
        Log('ERROR: Spawn failed - exEntitySpawner missing and WorldFunctionalTests fallback failed')
        return false
    end

    -- Try each entity path with exEntitySpawner.Spawn until one works
    for i, entityPath in ipairs(ENTITY_PATHS) do
        Log(string.format('Trying entity path [%d/%d]: %s', i, #ENTITY_PATHS, entityPath))
        local ok, entityID = SafeCall('exEntitySpawner.Spawn', function()
            return exEntitySpawner.Spawn(entityPath, spawnTransform, ENTITY_APPEARANCE)
        end)
        if ok and entityID then
            state.shellEntityID = entityID
            state.pendingSpawn = true
            state.shellEntityValid = false
            state.shellEntity = nil
            state.currentEntityPath = entityPath
            Log(string.format('Spawn requested, entity ID: %s (pending...)', tostring(entityID)))
            Log(string.format('Using entity path: %s', entityPath))
            return true
        end
        if ok and not entityID then
            Log(string.format('Path not found (returned nil): %s', entityPath))
        end
    end

    -- All paths failed with exEntitySpawner, try WorldFunctionalTests as fallback
    Log('All entity paths failed with exEntitySpawner.Spawn')
    Log('Trying WorldFunctionalTests.SpawnEntity as fallback...')
    for i, entityPath in ipairs(ENTITY_PATHS) do
        Log(string.format('Trying fallback [%d/%d]: %s', i, #ENTITY_PATHS, entityPath))
        local ok, entityID = SafeCall('WorldFunctionalTests.SpawnEntity', function()
            return WorldFunctionalTests.SpawnEntity(entityPath, spawnTransform, ENTITY_APPEARANCE)
        end)
        if ok and entityID then
            state.shellEntityID = entityID
            state.pendingSpawn = true
            state.shellEntityValid = false
            state.shellEntity = nil
            state.currentEntityPath = entityPath
            Log(string.format('Spawn requested via WorldFunctionalTests, entity ID: %s (pending...)', tostring(entityID)))
            return true
        end
        if ok and not entityID then
            Log(string.format('Fallback path not found (returned nil): %s', entityPath))
        end
    end

    Log('ERROR: Spawn failed - no entity path worked with any spawn API')
    Log('Check that the entity paths exist in your game version')
    return false
end

function DespawnShellEntity()
    LogSection('DESPAWN SHELL ENTITY')
    if state.pendingSpawn then
        Log('Spawn still pending, cancelling...')
        state.pendingSpawn = false
        state.shellEntityID = nil
        Log('Pending spawn cancelled')
        return true
    end
    if not state.shellEntity then
        Log('No entity to despawn')
        return false
    end
    local bridge = GetBridge()
    if bridge then
        local ok = SafeCall('DespawnEntity', function()
            return bridge:DespawnEntity(state.shellEntity)
        end)
        if ok then
            Log('Entity despawned via bridge')
            state.shellEntity = nil
            state.shellEntityValid = false
            state.shellEntityID = nil
            return true
        end
    end
    SafeCall('CET_Despawn', function()
        exEntitySpawner.Despawn(state.shellEntity)
    end)
    state.shellEntity = nil
    state.shellEntityValid = false
    state.shellEntityID = nil
    Log('Entity despawned (CET fallback)')
    return true
end

-- ============================================================
-- Target Device Acquisition
-- ============================================================

local function GetTargetedDevice()
    local player = GetPlayer()
    if not player then return nil end
    local tOk, target = SafeCall('GetTarget', function()
        return player:GetLookAtObject()
    end)
    if tOk and target then
        return target
    end
    return nil
end

-- ============================================================
-- Ping Quickhack Test
-- ============================================================

local function RunPingTest()
    LogSection('PING QUICKHACK TEST')
    state.testCount = state.testCount + 1
    local testNum = state.testCount
    Log(string.format('Test #%d starting...', testNum))
    Log('Step 1: Acquiring target device...')
    local target = GetTargetedDevice()
    if not target then
        Log('ERROR: No target device. Look at a hackable device.')
        state.lastTestResult = 'NO_TARGET'
        state.lastTestTime = os.date('%H:%M:%S')
        table.insert(state.testResults, {
            action = 'PingDevice', target = 'none',
            result = 'NO_TARGET', timestamp = os.date('%H:%M:%S')
        })
        return false
    end
    state.targetDevice = target
    local cOk, className = SafeCall('GetClassName', function()
        return target:GetClassName()
    end)
    if cOk and className then
        state.targetDeviceName = tostring(className)
        Log(string.format('Target class: %s', state.targetDeviceName))
    else
        state.targetDeviceName = 'Unknown'
        Log('Target class: Unknown')
    end
    Log('Step 2: Getting device PS...')
    local psOk, ps = SafeCall('GetDevicePS', function()
        return target:GetDevicePS()
    end)
    if not psOk or not ps then
        Log('ERROR: No device PS found')
        state.lastTestResult = 'NO_DEVICE_PS'
        state.lastTestTime = os.date('%H:%M:%S')
        table.insert(state.testResults, {
            action = 'PingDevice', target = state.targetDeviceName,
            result = 'NO_DEVICE_PS', timestamp = os.date('%H:%M:%S')
        })
        return false
    end
    Log('Device PS acquired')
    Log('Step 3: Determining executor...')
    local executor = state.shellEntity or GetPlayer()
    if not executor then
        Log('ERROR: No executor available')
        state.lastTestResult = 'NO_EXECUTOR'
        state.lastTestTime = os.date('%H:%M:%S')
        return false
    end
    local executorType = state.shellEntity and 'ShellEntity' or 'Player'
    Log(string.format('Executor: %s', executorType))
    Log('Step 4: Executing via REDscript bridge...')
    local bridge = GetBridge()
    if not bridge then
        Log('ERROR: Bridge not loaded. Install OrbHackingBridge.reds')
        state.lastTestResult = 'NO_BRIDGE'
        state.lastTestTime = os.date('%H:%M:%S')
        table.insert(state.testResults, {
            action = 'PingDevice', target = state.targetDeviceName,
            result = 'NO_BRIDGE', timestamp = os.date('%H:%M:%S')
        })
        return false
    end
    local rOk, result = SafeCall('ExecuteDeviceAction', function()
        return bridge:ExecuteDeviceActionByName(target, 'PingDevice', executor)
    end)
    local resultStr = 'ERROR'
    if rOk and result then
        resultStr = tostring(result)
    end
    Log(string.format('PingDevice result: %s', resultStr))
    state.lastTestResult = resultStr
    state.lastTestTime = os.date('%H:%M:%S')
    table.insert(state.testResults, {
        action = 'PingDevice', target = state.targetDeviceName,
        result = resultStr, timestamp = os.date('%H:%M:%S')
    })
    Log('Step 5: Trying QuickHack.Ping variant...')
    local r2Ok, result2 = SafeCall('ExecuteDeviceAction_QH', function()
        return bridge:ExecuteDeviceActionByName(target, 'QuickHack.Ping', executor)
    end)
    if r2Ok and result2 then
        Log(string.format('QuickHack.Ping result: %s', tostring(result2)))
        table.insert(state.testResults, {
            action = 'QuickHack.Ping', target = state.targetDeviceName,
            result = tostring(result2), timestamp = os.date('%H:%M:%S')
        })
    end
    LogSection(string.format('TEST #%d COMPLETE: %s', testNum, resultStr))
    return true
end

-- ============================================================
-- Reset
-- ============================================================

local function ResetState()
    LogSection('RESET STATE')
    state.testCount = 0
    state.testResults = {}
    state.lastTestResult = ''
    state.lastTestTime = ''
    state.targetDevice = nil
    state.targetDeviceName = ''
    Log('State reset complete')
end

-- ============================================================
-- ImGui Window
-- ============================================================

local function DrawWindow()
    if not state.windowVisible then return end
    local flags = ImGuiWindowFlags.AlwaysAutoResize
    local visible, open = ImGui.Begin('CE1: Custom Entity Tester v1##ce1', true, flags)
    if not visible then
        ImGui.End()
        return
    end
    ImGui.Text('Bridge:')
    ImGui.SameLine()
    if state.bridgeLoaded then
        ImGui.TextColored(0, 1, 0, 1, 'Loaded')
    else
        ImGui.TextColored(1, 0, 0, 1, 'NOT LOADED')
    end
    ImGui.SameLine()
    ImGui.TextDisabled('(OrbHackingBridge.reds)')
    ImGui.Separator()
    ImGui.Text('Shell Entity:')
    ImGui.SameLine()
    if state.shellEntity then
        ImGui.TextColored(0, 1, 0, 1, 'Spawned')
    elseif state.pendingSpawn then
        ImGui.TextColored(1, 0.5, 0, 1, 'Pending...')
    else
        ImGui.TextColored(0.5, 0.5, 0.5, 1, 'Not spawned')
    end
    if state.shellEntity then
        ImGui.Text(string.format('  Valid: %s', state.shellEntityValid and 'Yes' or 'No'))
        if state.shellEntityID then
            ImGui.Text(string.format('  Entity ID: %s', tostring(state.shellEntityID)))
        end
    end
    if state.currentEntityPath ~= '' then
        ImGui.Text(string.format('  Path: %s', state.currentEntityPath))
    end
    ImGui.Separator()
    ImGui.Text('Target Device:')
    ImGui.SameLine()
    if state.targetDevice then
        ImGui.TextColored(0, 1, 0, 1, state.targetDeviceName or 'Unknown')
    else
        ImGui.TextColored(0.5, 0.5, 0.5, 1, 'None')
    end
    ImGui.Separator()
    ImGui.Text('Tests Run: ' .. state.testCount)
    if state.lastTestResult ~= '' then
        ImGui.SameLine()
        local r, g, b = 1, 0, 0
        if state.lastTestResult == 'SUCCESS' then r, g, b = 0, 1, 0
        elseif state.lastTestResult == 'NOT_POSSIBLE' then r, g, b = 1, 0.5, 0 end
        ImGui.TextColored(r, g, b, 1,
            string.format('Last: %s (%s)', state.lastTestResult, state.lastTestTime))
    end
    if #state.testResults > 0 then
        ImGui.Separator()
        ImGui.Text('Test History:')
        ImGui.BeginChild('TestHistory', 400, 150, true)
        for i, result in ipairs(state.testResults) do
            local r, g, b = 1, 0, 0
            if result.result == 'SUCCESS' then r, g, b = 0, 1, 0
            elseif result.result == 'NOT_POSSIBLE' then r, g, b = 1, 0.5, 0 end
            ImGui.TextColored(r, g, b, 1,
                string.format('[%s] %s -> %s: %s',
                    result.timestamp, result.action, result.target or '?', result.result))
        end
        ImGui.EndChild()
    end
    ImGui.Separator()
    ImGui.Text('Log Preview:')
    ImGui.BeginChild('LogPreview', 800, 400, true)
    local startIdx = math.max(1, #state.logEntries - 7)
    for i = startIdx, #state.logEntries do
        ImGui.Text(state.logEntries[i])
    end
    ImGui.EndChild()
    ImGui.Separator()
    ImGui.TextDisabled('Hotkeys: Spawn Entity | Run Ping Test | Toggle Window | Reset')
    ImGui.End()
end

-- ============================================================
-- Hotkeys (ROOT LEVEL -- CET discovers during initial scan)
-- ============================================================

registerHotkey('CE1_SpawnEntity', 'CE1: Spawn/Despawn Shell Entity', function()
    if state.shellEntity or state.pendingSpawn then
        DespawnShellEntity()
    else
        SpawnShellEntity()
    end
end)

registerHotkey('CE1_RunPingTest', 'CE1: Run Ping Quickhack Test', function()
    RunPingTest()
end)

registerHotkey('CE1_ToggleWindow', 'CE1: Toggle ImGui Window', function()
    state.windowVisible = not state.windowVisible
end)

registerHotkey('CE1_ResetState', 'CE1: Reset State', function()
    ResetState()
end)

-- ============================================================
-- Events
-- ============================================================

registerForEvent('onInit', function()
    LogSection('CUSTOM ENTITY TESTER 1 -- INITIALIZING')
    Log(string.format('Mod: %s', MOD_NAME))
    Log(string.format('Entity paths configured: %d candidates', #ENTITY_PATHS))
    for i, path in ipairs(ENTITY_PATHS) do
        Log(string.format('  [%d] %s', i, path))
    end
    local bridge = GetBridge()
    if not bridge then
        Log('WARNING: OrbHackingBridge not found. Is REDscript mod installed?')
        Log('Entity spawning will work but action execution tests will fail.')
    end
    state.initialized = true
    Log('Initialization complete.')
    LogSection('READY')
end)

registerForEvent('onDraw', function()
    DrawWindow()
end)

registerForEvent('onUpdate', function(deltaTime)
    -- Poll for pending spawn completion
    if state.pendingSpawn and state.shellEntityID then
        local ok, entity = pcall(function()
            return Game.FindEntityByID(state.shellEntityID)
        end)
        if ok and entity then
            state.shellEntity = entity
            state.shellEntityValid = true
            state.pendingSpawn = false
            Log(string.format('Entity ready: %s (ID: %s)', tostring(entity), tostring(state.shellEntityID)))
            local pOk, ePos = pcall(function()
                return entity:GetWorldPosition()
            end)
            if pOk and ePos then
                Log(string.format('Entity position: (%.2f, %.2f, %.2f)', ePos.x, ePos.y, ePos.z))
            end
        end
    end
    -- Check validity of existing entity
    if state.shellEntity and state.shellEntityValid then
        local ok, valid = pcall(function()
            return state.shellEntity:IsValid()
        end)
        if ok and not valid then
            Log('WARNING: Shell entity no longer valid')
            state.shellEntityValid = false
        end
    end
end)
