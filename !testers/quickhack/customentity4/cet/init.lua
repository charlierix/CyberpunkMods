-- ============================================================
-- Custom Entity Tester 4 (CE4)
-- All Quickhack Tester with ImGui Info Window
-- ============================================================
--
-- Purpose: Test ALL available quickhacks on any device using a
--   spawned drone as executor. Combines:
--     CE3  -- proven drone spawn + bridge execution (no Red4ext)
--     CE1  -- ImGui info window (onDraw)
--     SEDevT1 -- per-action attempt tracking + weighted random
--
-- Features:
--   - Spawns a Zetatech Bombus drone as the quickhack executor
--   - ImGui window shows target device name/type, available hacks,
--     per-device attempt counts, and success/error messages
--   - Weighted random selection favors untried hacks
--   - Per-device, per-action attempt tracking
--
-- File: init.lua
-- Install: bin/x64/plugins/cyber_engine_tweaks/mods/customentity4/init.lua
-- Target: Cyberpunk 2077 v2.2+
-- Requires: CET 1.39.1+, REDscript (OrbHackingBridge.reds CE4 version)
--
-- Hotkeys (bind in Settings > Key Bindings):
--   CE4: Spawn/Despawn Drone     -- also shows/hides ImGui window
--   CE4: List Available Quickhacks -- for looked-at device
--   CE4: Apply Random Quickhack  -- from current list
--
-- ============================================================

local MOD_NAME = 'customentity4'
local BRIDGE_NAME = 'OrbHackingBridge'
local LOG_PREFIX = '[CE4]'

-- Drone entity paths (verified valid in customentity1a/2/3)
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

local MAX_MESSAGES = 12
local MAX_TICKS = 300

-- ============================================================
-- State
-- ============================================================

local state = {
    -- Drone
    entity = nil,
    entityID = nil,
    pendingSpawn = false,
    spawnMethod = '',
    spawnPath = '',
    tickCount = 0,

    -- Bridge
    bridge = nil,
    bridgeLoaded = false,

    -- Window
    windowVisible = false,

    -- Current target
    targetEntity = nil,
    targetClass = '',
    targetName = '',
    targetKey = '',
    targetDistance = 0,

    -- Action list for current target
    currentActions = {},  -- array of action name strings
    lastTargetKey = '',   -- track target changes for auto-refresh

    -- Per-device, per-action attempt tracking
    -- { [deviceKey] = { [actionName] = count } }
    deviceAttempts = {},

    -- Last result
    lastResult = '',
    lastResultAction = '',
    lastResultTime = '',

    -- Message log (circular buffer)
    messages = {},
}

-- ============================================================
-- Logging
-- ============================================================

local function Log(msg)
    local ts = os.date('%Y-%m-%d %H:%M:%S')
    print(string.format('[%s] %s %s', ts, LOG_PREFIX, msg))
end

local function AddMessage(msg)
    local ts = os.date('%H:%M:%S')
    local entry = string.format('[%s] %s', ts, msg)
    table.insert(state.messages, entry)
    if #state.messages > MAX_MESSAGES then
        table.remove(state.messages, 1)
    end
    Log(msg)
end

-- ============================================================
-- Position helpers (adapted from CE3, proven in 1a/2/3)
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
-- Bridge Access (from CE3, proven working)
-- ============================================================

local function GetBridge()
    if state.bridge then return state.bridge end

    local ok1, bridge1 = pcall(function()
        return Game.GetScriptableSystemsContainer():Get(BRIDGE_NAME)
    end)
    if ok1 and bridge1 then
        state.bridge = bridge1
        state.bridgeLoaded = true
        Log(string.format('Bridge loaded via GetScriptableSystemsContainer():Get("%s")', BRIDGE_NAME))
        return bridge1
    end

    local ok2, bridge2 = pcall(function()
        return Game.GetScriptableSystemsContainer():Get(CName.new(BRIDGE_NAME))
    end)
    if ok2 and bridge2 then
        state.bridge = bridge2
        state.bridgeLoaded = true
        Log('Bridge loaded via CName')
        return bridge2
    end

    Log(string.format('ERROR: Could not load bridge "%s" -- check REDscript deployment', BRIDGE_NAME))
    return nil
end

-- ============================================================
-- Spawn: Method A -- exEntitySpawner.Spawn with .ent path
-- ============================================================

local function TrySpawnWithEntitySpawner()
    local player = Game.GetPlayer()
    if not player then return false end

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
    end

    Log('Method A: All .ent paths failed')
    return false
end

-- ============================================================
-- Spawn: Method B -- DynamicEntitySpec + CreateEntity with TweakDB record
-- ============================================================

local function TrySpawnWithDynamicEntitySpec()
    local entitySystem = Game.GetDynamicEntitySystem()
    if not entitySystem then return false end

    for i, recordPath in ipairs(DRONE_TWEAK_RECORDS) do
        Log(string.format('Method B: Trying [%d/%d]: %s', i, #DRONE_TWEAK_RECORDS, recordPath))
        local ok, result = pcall(function()
            local spec = DynamicEntitySpec.new()
            spec.persistState = false
            spec.persistSpawn = false
            spec.alwaysSpawned = false
            spec.spawnInView = true
            spec.recordID = TweakDBID.new(recordPath)
            spec.tags = { "CE4_DRONE" }
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

    -- Hide window when drone is despawned
    state.windowVisible = false

    -- Clear target/action state
    state.targetEntity = nil
    state.currentActions = {}
    state.lastTargetKey = ''
end

-- ============================================================
-- Spawn Drone (also shows window)
-- ============================================================

local function SpawnDrone()
    Log(string.rep('=', 50))
    Log('SPAWN DRONE')

    if state.entity then
        DespawnDrone()
        return
    end

    if TrySpawnWithEntitySpawner() then
        Log('Drone spawned via Method A (exEntitySpawner)')
    elseif TrySpawnWithDynamicEntitySpec() then
        Log('Drone spawned via Method B (DynamicEntitySpec)')
    else
        Log('ERROR: All spawn methods failed')
        return
    end

    -- Show window when drone is spawned
    state.windowVisible = true
    AddMessage('Drone spawning... window enabled')
end

-- ============================================================
-- Target Acquisition (from CE3)
-- ============================================================

local function AcquireTarget()
    local player = Game.GetPlayer()
    if not player then return nil end

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
            return result
        end
    end

    return nil
end

-- ============================================================
-- Device Key -- unique key for per-device attempt tracking
-- ============================================================

local function GetDeviceKey(target)
    local key = '<unknown>'
    pcall(function()
        local eid = target:GetEntityID()
        if eid then key = tostring(eid.hash) end
    end)
    return key
end

-- ============================================================
-- Attempt tracking
-- ============================================================

local function GetAttempts(deviceKey, actionName)
    if not state.deviceAttempts[deviceKey] then return 0 end
    return state.deviceAttempts[deviceKey][actionName] or 0
end

local function IncrementAttempt(deviceKey, actionName)
    if not state.deviceAttempts[deviceKey] then
        state.deviceAttempts[deviceKey] = {}
    end
    state.deviceAttempts[deviceKey][actionName] =
        (state.deviceAttempts[deviceKey][actionName] or 0) + 1
end

-- ============================================================
-- Parse action names from bridge pipe-delimited string
-- ============================================================

local function ParseActionNames(pipeString)
    local actions = {}
    if not pipeString or pipeString == '' then return actions end
    -- Check for error strings
    if pipeString:match('^ERROR:') or pipeString:match('^NO_DEVICE_PS') then
        return actions
    end
    for name in string.gmatch(pipeString, '[^|]+') do
        table.insert(actions, name)
    end
    return actions
end

-- ============================================================
-- Refresh action list for current target
-- ============================================================

local function RefreshActions(target, executor)
    local bridge = GetBridge()
    if not bridge then return {} end

    local ok, result = pcall(function()
        return bridge:GetActionNames(target, executor)
    end)
    if not ok or not result then
        return {}
    end

    return ParseActionNames(tostring(result))
end

-- ============================================================
-- List Available Quickhacks -- hotkey handler
-- ============================================================

local function ListQuickhacks()
    Log(string.rep('=', 50))
    Log('LIST AVAILABLE QUICKHACKS')

    if not state.entity then
        AddMessage('No drone spawned -- spawn drone first')
        return
    end

    local target = AcquireTarget()
    if not target then
        AddMessage('No device targeted -- look at a hackable device')
        return
    end

    local cOk, className = pcall(function() return target:GetClassName() end)
    state.targetEntity = target
    state.targetClass = cOk and tostring(className) or 'Unknown'
    state.targetKey = GetDeviceKey(target)

    local bridge = GetBridge()
    if not bridge then
        AddMessage('ERROR: Bridge not loaded')
        return
    end

    state.currentActions = RefreshActions(target, state.entity)
    state.lastTargetKey = state.targetKey

    if #state.currentActions == 0 then
        AddMessage(string.format('No quickhack actions on %s', state.targetClass))
    else
        AddMessage(string.format('%d quickhacks on %s:', #state.currentActions, state.targetClass))
        for i, name in ipairs(state.currentActions) do
            local attempts = GetAttempts(state.targetKey, name)
            Log(string.format('  [%d] %s (tried: %d)', i, name, attempts))
        end
    end
end

-- ============================================================
-- Weighted Random Selection -- favors untried actions
-- ============================================================

local function PickRandomAction(actions, deviceKey)
    if not actions or #actions == 0 then return nil, 0 end

    local maxAtt = 0
    for _, name in ipairs(actions) do
        local att = GetAttempts(deviceKey, name)
        if att > maxAtt then maxAtt = att end
    end

    local totalWeight = 0
    local weights = {}
    for i, name in ipairs(actions) do
        local att = GetAttempts(deviceKey, name)
        weights[i] = math.max(1, maxAtt + 1 - att)
        totalWeight = totalWeight + weights[i]
    end

    local r = math.random() * totalWeight
    local cumulative = 0
    for i, w in ipairs(weights) do
        cumulative = cumulative + w
        if r <= cumulative then
            return actions[i], i
        end
    end

    return actions[#actions], #actions
end

-- ============================================================
-- Apply Random Quickhack -- hotkey handler
-- ============================================================

local function ApplyRandomQuickhack()
    Log(string.rep('=', 50))
    Log('APPLY RANDOM QUICKHACK')

    if not state.entity then
        AddMessage('No drone spawned -- spawn drone first')
        return
    end

    local target = AcquireTarget()
    if not target then
        AddMessage('No device targeted -- look at a hackable device')
        return
    end

    local cOk, className = pcall(function() return target:GetClassName() end)
    state.targetEntity = target
    state.targetClass = cOk and tostring(className) or 'Unknown'
    state.targetKey = GetDeviceKey(target)

    -- Refresh actions if target changed or list is empty
    if state.lastTargetKey ~= state.targetKey or #state.currentActions == 0 then
        state.currentActions = RefreshActions(target, state.entity)
        state.lastTargetKey = state.targetKey
    end

    if #state.currentActions == 0 then
        AddMessage(string.format('No quickhack actions on %s', state.targetClass))
        return
    end

    local bridge = GetBridge()
    if not bridge then
        AddMessage('ERROR: Bridge not loaded')
        return
    end

    -- Pick weighted random action
    local pickedName, pickedIndex = PickRandomAction(state.currentActions, state.targetKey)
    if not pickedName then
        AddMessage('Could not pick an action')
        return
    end

    -- Use 0-based index for bridge
    local bridgeIndex = pickedIndex - 1

    Log(string.format('Applying [%d/%d]: %s -> %s',
        pickedIndex, #state.currentActions, pickedName, state.targetClass))

    local ok, result = pcall(function()
        return bridge:ExecuteActionByIndex(target, state.entity, bridgeIndex)
    end)

    local resultStr = 'ERROR'
    if ok and result then
        resultStr = tostring(result)
    elseif not ok then
        resultStr = 'ERROR: ' .. tostring(result)
    end

    -- Track attempt
    IncrementAttempt(state.targetKey, pickedName)
    local attempts = GetAttempts(state.targetKey, pickedName)

    -- Update last result
    state.lastResult = resultStr
    state.lastResultAction = pickedName
    state.lastResultTime = os.date('%H:%M:%S')

    -- Determine success/fail for message
    local isSuccess = resultStr:match('^SUCCESS')
    local prefix = isSuccess and '[OK]' or '[FAIL]'
    AddMessage(string.format('%s %s -> %s (attempt #%d)', prefix, pickedName, resultStr, attempts))

    Log(string.format('Result: %s (attempt #%d on this device)', resultStr, attempts))
end

-- ============================================================
-- ImGui Window
-- ============================================================

local function DrawWindow()
    if not state.windowVisible then return end

    ImGui.SetNextWindowPos(10, 10, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(480, 520, ImGuiCond.FirstUseEver)

    local visible, open = ImGui.Begin('CE4: All Quickhack Tester##ce4', true, ImGuiWindowFlags.AlwaysAutoResize)
    if not visible then
        ImGui.End()
        return
    end

    -- Bridge status
    ImGui.Text('Bridge:')
    ImGui.SameLine()
    if state.bridgeLoaded then
        ImGui.TextColored(0, 1, 0, 1, 'Loaded')
    else
        ImGui.TextColored(1, 0, 0, 1, 'NOT LOADED')
    end
    ImGui.SameLine()
    ImGui.TextDisabled('(OrbHackingBridge.reds CE4)')

    ImGui.Separator()

    -- Drone status
    ImGui.Text('Drone:')
    ImGui.SameLine()
    if state.entity then
        ImGui.TextColored(0, 1, 0, 1, 'Spawned')
        ImGui.Text(string.format('  Method: %s', state.spawnMethod))
        ImGui.Text(string.format('  Path:   %s', state.spawnPath))
    elseif state.pendingSpawn then
        ImGui.TextColored(1, 0.5, 0, 1, 'Pending...')
    else
        ImGui.TextColored(0.5, 0.5, 0.5, 1, 'Not spawned')
    end

    ImGui.Separator()

    -- Target device info
    if state.targetEntity then
        ImGui.Text('Target Device:')
        ImGui.Text(string.format('  Name: %s', state.targetName ~= '' and state.targetName or state.targetClass))
        ImGui.Text(string.format('  Type: %s', state.targetClass))
        if state.targetDistance > 0 then
            ImGui.Text(string.format('  Dist: %.1f m', state.targetDistance))
        end
    else
        ImGui.TextColored(0.5, 0.5, 0.5, 1, 'No device targeted -- look at a hackable device')
    end

    ImGui.Separator()

    -- Available hacks table
    if #state.currentActions > 0 then
        ImGui.Text(string.format('Available Hacks (%d):', #state.currentActions))
        ImGui.Separator()

        -- Column header
        ImGui.TextDisabled(string.format('  %-32s %s', 'Hack Name', 'Tried'))
        ImGui.Separator()

        for i, name in ipairs(state.currentActions) do
            local attempts = GetAttempts(state.targetKey, name)
            local mark = attempts > 0 and '*' or ' '
            local color = attempts > 0 and {0, 1, 0, 1} or {0.7, 0.7, 0.7, 1}
            ImGui.TextColored(color[1], color[2], color[3], color[4],
                string.format('%s [%d] %-30s %d', mark, i, name, attempts))
        end
    else
        ImGui.TextColored(0.5, 0.5, 0.5, 1, 'No quickhack actions listed')
        ImGui.TextDisabled('Press List Quickhacks hotkey while looking at a device')
    end

    ImGui.Separator()

    -- Last result
    if state.lastResult ~= '' then
        ImGui.Text('Last Result:')
        local r, g, b = 1, 0, 0
        if state.lastResult:match('^SUCCESS') then r, g, b = 0, 1, 0
        elseif state.lastResult:match('^NOT_POSSIBLE') then r, g, b = 1, 0.5, 0 end
        ImGui.TextColored(r, g, b, 1,
            string.format('  %s -> %s', state.lastResultAction, state.lastResult))
        ImGui.TextDisabled(string.format('  Time: %s', state.lastResultTime))
    else
        ImGui.TextDisabled('Last Result: (none yet)')
    end

    ImGui.Separator()

    -- Message log
    if #state.messages > 0 then
        ImGui.Text('Messages:')
        ImGui.BeginChild('CE4Messages', 460, 120, true)
        for i, msg in ipairs(state.messages) do
            -- Color based on content
            local r, g, b = 0.8, 0.8, 0.8
            if msg:match('%[OK%]') then r, g, b = 0, 1, 0
            elseif msg:match('%[FAIL%]') then r, g, b = 1, 0.3, 0.3
            elseif msg:match('ERROR') then r, g, b = 1, 0.3, 0.3
            elseif msg:match('No drone') or msg:match('No device') then r, g, b = 1, 0.5, 0
            end
            ImGui.TextColored(r, g, b, 1, msg)
        end
        ImGui.EndChild()
    end

    ImGui.Separator()
    ImGui.TextDisabled('Hotkeys: Spawn/Despawn | List Quickhacks | Apply Random')
    ImGui.End()
end

-- ============================================================
-- SafeCall helper
-- ============================================================

local function SafeCall(name, fn)
    local ok, err = pcall(fn)
    if not ok then
        Log(string.format('ERROR in %s: %s', name, tostring(err)))
        AddMessage(string.format('ERROR in %s: %s', name, tostring(err)))
    end
    return ok
end

-- ============================================================
-- Hotkeys (MUST be at file root level, before registerForEvent)
-- ============================================================

registerHotkey("CE4_SpawnDespawnDrone", "CE4: Spawn/Despawn Drone", function()
    SafeCall('SpawnDrone', SpawnDrone)
end)

registerHotkey("CE4_ListQuickhacks", "CE4: List Available Quickhacks", function()
    SafeCall('ListQuickhacks', ListQuickhacks)
end)

registerHotkey("CE4_ApplyRandom", "CE4: Apply Random Quickhack", function()
    SafeCall('ApplyRandomQuickhack', ApplyRandomQuickhack)
end)

-- ============================================================
-- Events
-- ============================================================

registerForEvent("onInit", function()
    state.bridge = nil
    state.bridgeLoaded = false

    Log('CE4 initialized -- All Quickhack Tester with ImGui window')
    Log('Combines CE3 drone+bridge, CE1 ImGui, SEDevT1 action tracking')
    Log('')
    Log('Usage:')
    Log('  1. Spawn drone (hotkey) -- window appears')
    Log('  2. Look at a hackable device')
    Log('  3. List quickhacks (hotkey) -- populates action list')
    Log('  4. Apply random quickhack (hotkey) -- executes weighted random')
    Log('  5. Repeat step 4 to test all available hacks')

    -- Diagnostic API checks
    local gsOk, gsExists = pcall(function()
        return Game.GetScriptableSystemsContainer ~= nil
    end)
    Log(string.format('API check: GetScriptableSystemsContainer = %s', tostring(gsOk and gsExists or false)))

    GetBridge()
end)

registerForEvent("onUpdate", function(dt)
    -- Poll for pending spawn completion
    if state.pendingSpawn and state.entityID then
        state.tickCount = state.tickCount + 1
        local ok, entity = pcall(function()
            return Game.FindEntityByID(state.entityID)
        end)
        if ok and entity then
            state.entity = entity
            state.pendingSpawn = false
            Log(string.format('DRONE SPAWNED! Tick: %d, Method: %s, Path: %s',
                state.tickCount, state.spawnMethod, state.spawnPath))
            AddMessage(string.format('Drone spawned (%s)', state.spawnMethod))
        elseif state.tickCount > MAX_TICKS then
            Log(string.format('SPAWN TIMEOUT: Entity not found after %d ticks', state.tickCount))
            AddMessage('SPAWN TIMEOUT -- drone not found')
            state.pendingSpawn = false
        end
    end

    -- Auto-scan target when drone is spawned and window is visible
    if state.entity and state.windowVisible then
        local target = AcquireTarget()

        if target then
            local cOk, className = pcall(function() return target:GetClassName() end)
            local newClass = cOk and tostring(className) or 'Unknown'
            local newKey = GetDeviceKey(target)

            -- Update target info
            state.targetEntity = target
            state.targetClass = newClass
            state.targetKey = newKey

            -- Get target name
            local nOk, tName = pcall(function()
                local record = target:GetRecord()
                if record then
                    local id = record:GetID()
                    if id then return id.value end
                end
                return nil
            end)
            state.targetName = (nOk and tName) and tName or ''

            -- Get distance
            local dOk, dist = pcall(function()
                local pPos = Game.GetPlayer():GetWorldPosition()
                local tPos = target:GetWorldPosition()
                return math.sqrt((tPos.x - pPos.x)^2 + (tPos.y - pPos.y)^2 + (tPos.z - pPos.z)^2)
            end)
            state.targetDistance = (dOk and dist) and dist or 0

            -- Refresh action list if target changed
            if state.lastTargetKey ~= newKey then
                state.currentActions = RefreshActions(target, state.entity)
                state.lastTargetKey = newKey
                if #state.currentActions > 0 then
                    Log(string.format('Auto-detected %d quickhacks on %s', #state.currentActions, newClass))
                end
            end
        else
            -- No target -- clear if we had one
            if state.targetEntity then
                state.targetEntity = nil
                state.currentActions = {}
                state.lastTargetKey = ''
            end
        end
    end
end)

registerForEvent("onDraw", function()
    DrawWindow()
end)

registerForEvent("onShutdown", function()
    if state.entity then
        DespawnDrone()
    end
    Log('CE4 stopped')
end)
