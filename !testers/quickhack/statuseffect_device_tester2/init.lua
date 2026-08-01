--[[
  Status Effect Device Tester 2 - CET (Lua)
  Random device effect tester testing TWO unexplored execution paths:

    PATH 1: QuestForce Actions
      - Discovers quest actions via GetQuestActions() with requestType=Quest
      - Executes via random strategy: action chain / direct PS handler / DeviceSystem
      - QuestForce actions are designed for quest scripts, not scanner/breach context

    PATH 2: Direct StatusEffect on Devices
      - Applies status effects directly to device entities via StatusEffectHelper
      - Never tested on devices before (only NPCs in npc_tester1)
      - Uses quest-proven API (Blackwall mod pattern)

  Based on research from:
    statuseffect_device_tester1/research_effect_execution_paths.md

  Interface:
    - Toggle window hotkey
    - Apply random effect hotkey (randomly picks path, then random effect/action within path,
      then random execution method if applicable)

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester2/

  Bind hotkeys in: Settings > Key Bindings > SEDevT2
--]]

local ModName = "SEDevT2"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    debug            = true,
    maxDistance      = 20.0,
    maxDisplayItems  = 20,
}

--============================================================================
-- STATUS EFFECT CANDIDATES (Path 2)
-- These are TweakDB record IDs for status effects that might produce visible
-- results when applied directly to device entities.
--============================================================================
local StatusEffectCandidates = {
    { record = "BaseStatusEffect.QuickHackDistraction",        label = "QuickHack Distraction",      goal = "distract"  },
    { record = "BaseStatusEffect.QuickHackExplodeExplosive",  label = "QuickHack Explode Explosive", goal = "destruct" },
    { record = "BaseStatusEffect.QuickHackBlind",             label = "QuickHack Blind",           goal = "distract"  },
    { record = "BaseStatusEffect.QuickHackToggleOn",          label = "QuickHack Toggle ON",       goal = "activate" },
    { record = "BaseStatusEffect.OverloadDevice",             label = "Overload Device",            goal = "destruct" },
    { record = "BaseStatusEffect.HighPitchNoise",             label = "High Pitch Noise",          goal = "distract"  },
    { record = "BaseStatusEffect.EMP",                        label = "EMP",                        goal = "destruct" },
    { record = "BaseStatusEffect.BaseEMP",                    label = "Base EMP",                  goal = "destruct" },
    { record = "BaseStatusEffect.GlitchScreen",                label = "Glitch Screen",              goal = "distract"  },
    { record = "BaseStatusEffect.QuickHackOverload",          label = "QuickHack Overload",        goal = "destruct" },
    { record = "BaseStatusEffect.QuickHackMotive",            label = "QuickHack Motive",          goal = "distract"  },
    { record = "BaseStatusEffect.QuickHackCommitSuicide",     label = "QuickHack Suicide",         goal = "destruct" },
    { record = "BaseStatusEffect.QuickHackDisable",           label = "QuickHack Disable",         goal = "destruct" },
    { record = "BaseStatusEffect.QuickHackPing",              label = "QuickHack Ping",            goal = "detect"   },
    { record = "BaseStatusEffect.Ping_Cyberpsycho",           label = "Ping Cyberpsycho",          goal = "detect"   },
}

--============================================================================
-- REGISTRIES
-- Track coverage for both paths separately.
-- Keyed by action class name (Path 1) or effect record ID (Path 2).
--============================================================================
local QuestRegistry = {}   -- [className] = { name=, attempts=0, successes=0 }
local QuestOrder = {}

local EffectRegistry = {}  -- [record] = { name=, attempts=0, successes=0 }
local EffectOrder = {}

-- Track which path was tried how many times
local PathStats = {
    questForce   = { attempts = 0, successes = 0 },
    statusEffect = { attempts = 0, successes = 0 },
}

local reportedDeviceTypes = {}  -- keyed by className

--============================================================================
-- STATE
--============================================================================

local windowVisible = false

local Scan = {
    entity       = nil,
    typeName     = nil,
    targetName   = nil,
    className    = nil,
    distance     = nil,
    recordID     = nil,
    entityHash   = nil,
    questActions = nil,
}

local LastResult = {
    path        = nil,    -- "QuestForce" or "StatusEffect"
    effectName  = nil,
    effectClass = nil,
    record      = nil,
    success     = nil,
    resultText  = nil,
    strategy    = nil,
}

-- Cached quest actions for current target
local CachedTarget = {
    entity    = nil,
    className = "",
    actions   = {},
}

--============================================================================
-- HELPERS (reused from tester1)
--============================================================================

local function dprint(msg)
    if Config.debug then
        print(string.format("[%s] %s", ModName, msg))
    end
end

local function ErrorHandler(err)
    local info = debug.getinfo(2, "Sl")
    local loc = ""
    if info and info.short_src then
        loc = string.format(" at %s:%d", info.short_src, info.currentline or 0)
    end
    return string.format("%s%s", tostring(err), loc)
end

local function SafeCall(fn, ...)
    local results = table.pack(xpcall(fn, ErrorHandler, ...))
    local ok = results[1]
    if ok then
        return true, table.unpack(results, 2, results.n)
    else
        return false, results[2]
    end
end

local function CNameToString(cname)
    if not cname then return "<nil>" end
    local s = tostring(cname)
    if type(s) == "string" then
        local name = s:match("%-%-%[%[(.-)%]%]%-%-")
        if name and name ~= "" then return name end
        if not s:match("^ToCName") and #s < 64 then return s end
    end
    local fmt = nil
    pcall(function() fmt = string.format("%s", cname) end)
    if fmt and type(fmt) == "string" then
        local name = fmt:match("%-%-%[%[(.-)%]%]%-%-")
        if name and name ~= "" then return name end
        if not fmt:match("^ToCName") and #fmt < 64 then return fmt end
    end
    local concat = nil
    pcall(function() concat = "" .. cname end)
    if concat and type(concat) == "string" then
        local name = concat:match("%-%-%[%[(.-)%]%]%-%-")
        if name and name ~= "" then return name end
        if not concat:match("^ToCName") and #concat < 64 then return concat end
    end
    return s or "<unknown>"
end

local function GetTargetName(target)
    if not target or not IsDefined(target) then return "<nil>" end
    local name = "<unknown>"
    pcall(function()
        local record = target:GetRecord()
        if record then
            local id = record:GetID()
            if id then name = id.value end
        end
    end)
    if name == "<unknown>" then
        pcall(function()
            local recordID = target:GetRecordID()
            if recordID then name = recordID.value end
        end)
    end
    return name
end

local function GetEntityKey(target)
    local recordID = "<unknown>"
    local hash = "<none>"
    pcall(function()
        local rid = target:GetRecordID()
        if rid then recordID = rid.value or tostring(rid) end
    end)
    pcall(function()
        local eid = target:GetEntityID()
        if eid then hash = tostring(eid.hash) end
    end)
    return recordID, hash
end

local function GetDistance(target)
    local player = Game.GetPlayer()
    if not player or not target then return nil end
    local dist = nil
    pcall(function()
        local pPos = player:GetWorldPosition()
        local tPos = target:GetWorldPosition()
        local dx = pPos.x - tPos.x
        local dy = pPos.y - tPos.y
        local dz = pPos.z - tPos.z
        dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    end)
    return dist
end

--============================================================================
-- TARGETING (reused from tester1)
--============================================================================

local function GetLookAtDevice()
    local player = Game.GetPlayer()
    if not player then return nil, nil end

    local searchQuery = nil
    pcall(function() searchQuery = NewObject('gameTargetSearchQuery') end)
    if not searchQuery then
        dprint("Could not create gameTargetSearchQuery")
        return nil, nil
    end

    local filter = nil
    pcall(function() filter = Game["TSF_Quickhackable;"]() end)
    if not filter then
        pcall(function() filter = Game["TSF_Quickhackable;"] end)
    end
    if not filter then
        dprint("Could not create TSF_Quickhackable filter")
        return nil, nil
    end
    searchQuery.searchFilter = filter
    searchQuery.maxDistance = Config.maxDistance

    local target = nil
    pcall(function()
        target = Game.GetTargetingSystem():GetObjectClosestToCrosshair(player, searchQuery)
    end)

    if not target or not IsDefined(target) then
        return nil, nil
    end

    local ps = nil
    pcall(function() ps = target:GetDevicePS() end)
    if not ps then
        return nil, nil
    end

    return target, ps
end

--============================================================================
-- CONTEXT CREATION
--============================================================================

--- Create a GetActionsContext for QUEST actions (key difference from tester1: requestType=Quest)
local function MakeQuestContext(player)
    local context = nil
    pcall(function() context = NewObject('gameGetActionsContext') end)
    if not context then
        dprint("Could not create GetActionsContext")
        return nil
    end

    pcall(function() context.requestorID = player:GetEntityID() end)
    pcall(function() context.requestType = gamedeviceRequestType.Quest end)  -- KEY: Quest, not Remote
    pcall(function() context.ignoresRPG = true end)
    pcall(function() context.ignoresAuthorization = true end)
    pcall(function() context.processInitiatorObject = player end)

    return context
end

--============================================================================
-- PATH 1: QUESTFORCE ACTION DISCOVERY
--============================================================================

--- Get quest actions from device PS via GetQuestActions()
--- This is the UNTESTED API surface -- tester1 only used GetQuickHackActions()
local function GetQuestActions(ps, context)
    -- Convention 1: ps:GetQuestActions(context) returns array
    local ok1, result1 = SafeCall(function()
        return ps:GetQuestActions(context)
    end)
    if ok1 and result1 and type(result1) == "table" and #result1 > 0 then
        return result1
    end

    -- Convention 2: ps:GetQuestActions(outArray, context)
    local outArr = {}
    local ok2 = pcall(function()
        ps:GetQuestActions(outArr, context)
    end)
    if ok2 and #outArr > 0 then
        return outArr
    end

    -- Convention 3: device component GetQuestActions
    local ok3, result3 = SafeCall(function()
        local device = ps:GetOwnerEntity()
        if device then
            local component = device:GetDeviceComponent()
            if component then
                local arr = {}
                component:GetQuestActions(arr, context)
                return arr
            end
        end
        return nil
    end)
    if ok3 and result3 and type(result3) == "table" and #result3 > 0 then
        return result3
    end

    return nil
end

--- Get a human-readable name for an action
local function GetActionLabel(action)
    local label = ""
    pcall(function() label = action:GetActionName() end)
    if label and label ~= "" and tostring(label) ~= "None" then
        return CNameToString(label)
    end
    pcall(function()
        local rec = action:GetObjectActionRecord()
        if rec then
            local id = tostring(rec:GetID())
            if id and id ~= "" and id ~= "None" then label = id end
        end
    end)
    if label and label ~= "" and tostring(label) ~= "None" then
        return CNameToString(label)
    end
    pcall(function() label = action:GetClassName() end)
    if label and label ~= "" and tostring(label) ~= "None" then
        return CNameToString(label)
    end
    return "<unknown>"
end

--- Get the class name of an action
local function GetActionClassName(action)
    local name = ""
    pcall(function() name = action:GetClassName() end)
    if name and name ~= "" and tostring(name) ~= "None" then
        return CNameToString(name)
    end
    pcall(function()
        local rec = action:GetObjectActionRecord()
        if rec then name = tostring(rec:GetID()) end
    end)
    if name and name ~= "" and tostring(name) ~= "None" then
        return CNameToString(name)
    end
    return "<unknown>"
end

--- Get the TweakDB record ID of an action
local function GetActionRecordID(action)
    local id = ""
    pcall(function()
        local rec = action:GetObjectActionRecord()
        if rec then id = tostring(rec:GetID()) end
    end)
    if id and id ~= "" and id ~= "None" then
        return CNameToString(id)
    end
    return ""
end

--============================================================================
-- PATH 1: QUESTFORCE EXECUTION
--============================================================================

--- Map quest action class name to PS On* handler method name
local function GetQuestPSHandlerName(actionClassName)
    local mapping = {
        ["QuestForceON"]                  = "OnQuestForceON",
        ["QuestForceOFF"]                 = "OnQuestForceOFF",
        ["QuestStartGlitch"]              = "OnQuestStartGlitch",
        ["QuestStopGlitch"]               = "OnQuestStopGlitch",
        ["QuestForceActivate"]            = "OnQuestForceActivate",
        ["QuestForceDeactivate"]         = "OnQuestForceDeactivate",
        ["QuestForceEnabled"]             = "OnQuestForceEnabled",
        ["QuestForceDisabled"]            = "OnQuestForceDisabled",
        ["QuestForcePower"]               = "OnQuestForcePower",
        ["QuestForceUnpower"]             = "OnQuestForceUnpower",
        ["QuestForceDestructible"]        = "OnQuestForceDestructible",
        ["QuestForceDetonate"]            = "OnQuestForceDetonate",
        ["QuestForceSecuritySystemSafe"]   = "OnQuestForceSecuritySystemSafe",
        ["QuestForceSecuritySystemAlarmed"] = "OnQuestForceSecuritySystemAlarmed",
        ["QuestForceSecuritySystemArmed"]  = "OnQuestForceSecuritySystemArmed",
        ["QuestForceCameraZoom"]          = "OnQuestForceCameraZoom",
        ["QuestEnableFixing"]             = "OnQuestEnableFixing",
        ["QuestDisableFixing"]            = "OnQuestDisableFixing",
        ["QuestForceInvulnerable"]       = "OnQuestForceInvulnerable",
        ["QuestForceIndestructible"]     = "OnQuestForceIndestructible",
    }
    if mapping[actionClassName] then
        return mapping[actionClassName]
    end
    -- Try generic pattern: QuestXxx -> OnQuestXxx
    local prefix = actionClassName:match("^(Quest.+)$")
    if prefix then
        return "On" .. prefix
    end
    return nil
end

local function SetupAction(action, player, game)
    pcall(function() action:SetExecutor(player) end)
    pcall(function() action:SetRequesterID(player:GetEntityID()) end)
    pcall(function() action:SetCanSkipPayCost(true) end)
    pcall(function()
        local rec = action:GetObjectActionRecord()
        if rec then
            local recID = rec:GetID()
            if recID then
                action:SetObjectActionID(recID)
            end
        end
    end)
end

--- Strategy QA: Full action chain with Quest context
local function ApplyQuestForceFull(action, player, game)
    SetupAction(action, player, game)

    if game then
        pcall(function() action:IsPossible(game) end)
        pcall(function() action:ResolveAction(game) end)
    end

    local ok, err = SafeCall(function()
        action:StartAction(game)
    end)
    if ok then
        return true, "StartAction OK"
    end

    local ok2, err2 = SafeCall(function()
        action:ProcessRPGAction(game)
    end)
    if ok2 then
        return true, "ProcessRPGAction OK"
    end

    local ok3, err3 = SafeCall(function()
        action:CompleteAction(game)
    end)
    if ok3 then
        return true, "CompleteAction OK"
    end

    return false, tostring(err)
end

--- Strategy QB: Direct PS event handler call (quest variant)
local function ApplyQuestForceViaPS(action, ps, player, game, class)
    local handlerName = GetQuestPSHandlerName(class)
    if not handlerName then
        return false, "no PS handler for " .. class
    end

    -- Try with action arg
    local ok1 = pcall(function() ps[handlerName](ps, action) end)
    if ok1 then return true, "PS " .. handlerName .. " OK" end

    -- Try without args
    local ok2 = pcall(function() ps[handlerName](ps) end)
    if ok2 then return true, "PS " .. handlerName .. " OK (no args)" end

    -- Try QueuePSDeviceEvent
    local ok3 = pcall(function() ps:QueuePSDeviceEvent(action) end)
    if ok3 then return true, "QueuePSDeviceEvent OK" end

    return false, "PS strategies failed"
end

--- Strategy QC: DeviceSystem direct access
local function ApplyQuestForceViaDeviceSystem(target, player, game, action)
    local entityID = nil
    pcall(function() entityID = target:GetEntityID() end)
    if not entityID then return false, "no entityID" end

    local deviceSystem = nil
    pcall(function() deviceSystem = Game.GetDeviceSystem() end)
    if not deviceSystem then return false, "no DeviceSystem" end

    local device = nil
    local ok1, err1 = SafeCall(function()
        device = deviceSystem:GetDeviceById(game, entityID)
    end)
    if not ok1 or not device then return false, tostring(err1) end

    local ok2 = pcall(function() device:ExecuteAction(action) end)
    if ok2 then return true, "device:ExecuteAction OK" end

    local ok3 = pcall(function() device:ProcessAction(action) end)
    if ok3 then return true, "device:ProcessAction OK" end

    return false, "DeviceSystem strategies failed"
end

--- Full QuestForce execution: randomly pick strategy order, try each
local function ExecuteQuestForce(action, target, ps, player, game, class)
    -- Randomize strategy order for coverage
    local strategies = { "QA", "QB", "QC" }
    -- Shuffle
    for i = #strategies, 2, -1 do
        local j = math.random(1, i)
        strategies[i], strategies[j] = strategies[j], strategies[i]
    end

    for _, strat in ipairs(strategies) do
        local success, msg, stratLabel

        if strat == "QA" then
            success, msg = ApplyQuestForceFull(action, player, game)
            stratLabel = "QA:FullChain"
        elseif strat == "QB" then
            success, msg = ApplyQuestForceViaPS(action, ps, player, game, class)
            stratLabel = "QB:PSHandler"
        elseif strat == "QC" then
            success, msg = ApplyQuestForceViaDeviceSystem(target, player, game, action)
            stratLabel = "QC:DeviceSystem"
        end

        if success then
            return true, msg, stratLabel
        end
    end

    return false, "all QuestForce strategies failed", "NONE"
end

--============================================================================
-- PATH 2: DIRECT STATUS EFFECT EXECUTION
--============================================================================

--- Apply a status effect directly to a device entity
--- Tries multiple API variants for maximum coverage
local function ApplyStatusEffectToDevice(target, player, recordID)
    local results = {}

    -- Method 1: StatusEffectHelper.ApplyStatusEffect(target, recordID)
    local ok1, err1 = SafeCall(function()
        return StatusEffectHelper.ApplyStatusEffect(target, recordID)
    end)
    table.insert(results, { ok = ok1, msg = "Helper.Apply(target,record)", err = err1 })
    if ok1 then return true, "Helper.Apply(target,record) OK", "S1:Helper2Arg" end

    -- Method 2: StatusEffectHelper.ApplyStatusEffect(target, recordID, instigator)
    local ok2, err2 = SafeCall(function()
        return StatusEffectHelper.ApplyStatusEffect(target, recordID, player)
    end)
    table.insert(results, { ok = ok2, msg = "Helper.Apply(target,record,player)", err = err2 })
    if ok2 then return true, "Helper.Apply(target,record,player) OK", "S2:Helper3Arg" end

    -- Method 3: StatusEffectSystem.ObjectHasStatusEffect check + ApplyStatusEffect
    local ok3, err3 = SafeCall(function()
        local ses = Game.GetStatusEffectSystem()
        if ses then
            return ses:ApplyStatusEffect(target, recordID, player)
        end
        return nil
    end)
    table.insert(results, { ok = ok3, msg = "System.ApplyStatusEffect", err = err3 })
    if ok3 then return true, "System.ApplyStatusEffect OK", "S3:System" end

    -- Method 4: StatusEffectHelper with TweakDBID string variant
    local ok4, err4 = SafeCall(function()
        return StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new(recordID))
    end)
    table.insert(results, { ok = ok4, msg = "Helper.Apply(TweakDBID)", err = err4 })
    if ok4 then return true, "Helper.Apply(TweakDBID) OK", "S4:TweakDBID" end

    -- Method 5: Game.GetStatusEffectSystem():ApplyStatusEffect with gameEffect
    local ok5, err5 = SafeCall(function()
        local ses = Game.GetStatusEffectSystem()
        if ses then
            local eff = NewObject('gameEffect')
            eff:SetRecordID(recordID)
            eff:SetTarget(target)
            eff:SetInstigator(player)
            return eff:Execute()
        end
        return nil
    end)
    table.insert(results, { ok = ok5, msg = "gameEffect.Execute", err = err5 })
    if ok5 then return true, "gameEffect.Execute OK", "S5:GameEffect" end

    -- Log all failures for analysis
    local failMsgs = {}
    for _, r in ipairs(results) do
        if not r.ok then
            table.insert(failMsgs, r.msg .. ":" .. tostring(r.err or "?"))
        end
    end

    return false, table.concat(failMsgs, " | "), "NONE"
end

--============================================================================
-- REGISTRY MANAGEMENT
--============================================================================

local function RegisterQuestAction(className, name, recordID)
    if not QuestRegistry[className] then
        QuestRegistry[className] = {
            name      = name or className,
            class     = className,
            recordID  = recordID or "",
            attempts  = 0,
            successes = 0,
        }
        table.insert(QuestOrder, className)
        dprint(string.format("  [NEW QUEST ACTION] %s (class: %s, record: %s)", name, className, recordID or ""))
    end
end

local function RegisterEffect(record, label)
    if not EffectRegistry[record] then
        EffectRegistry[record] = {
            name      = label or record,
            record    = record,
            attempts  = 0,
            successes = 0,
        }
        table.insert(EffectOrder, record)
        dprint(string.format("  [NEW EFFECT] %s (record: %s)", label, record))
    end
end

local function GetQuestCoverageStats()
    local total = #QuestOrder
    local tried = 0
    for _, className in ipairs(QuestOrder) do
        if QuestRegistry[className].attempts > 0 then tried = tried + 1 end
    end
    return total, tried, total - tried, total > 0 and (tried / total) * 100 or 0
end

local function GetEffectCoverageStats()
    local total = #EffectOrder
    local tried = 0
    for _, record in ipairs(EffectOrder) do
        if EffectRegistry[record].attempts > 0 then tried = tried + 1 end
    end
    return total, tried, total - tried, total > 0 and (tried / total) * 100 or 0
end

--============================================================================
-- RANDOM SELECTION
--============================================================================

--- Pick a random quest action, weighting untried types higher
local function PickRandomQuestAction(actionList)
    if not actionList or #actionList == 0 then return nil, 0 end

    local maxAtt = 0
    for _, a in ipairs(actionList) do
        local reg = QuestRegistry[a.class]
        local att = reg and reg.attempts or 0
        if att > maxAtt then maxAtt = att end
    end

    local totalWeight = 0
    local weights = {}
    for i, a in ipairs(actionList) do
        local reg = QuestRegistry[a.class]
        local att = reg and reg.attempts or 0
        weights[i] = math.max(1, maxAtt + 1 - att)
        totalWeight = totalWeight + weights[i]
    end

    local r = math.random() * totalWeight
    local cumulative = 0
    for i, w in ipairs(weights) do
        cumulative = cumulative + w
        if r <= cumulative then
            return actionList[i], i
        end
    end

    return actionList[#actionList], #actionList
end

--- Pick a random status effect, weighting untried ones higher
local function PickRandomEffect()
    if #StatusEffectCandidates == 0 then return nil end

    local maxAtt = 0
    for _, e in ipairs(StatusEffectCandidates) do
        local reg = EffectRegistry[e.record]
        local att = reg and reg.attempts or 0
        if att > maxAtt then maxAtt = att end
    end

    local totalWeight = 0
    local weights = {}
    for i, e in ipairs(StatusEffectCandidates) do
        local reg = EffectRegistry[e.record]
        local att = reg and reg.attempts or 0
        weights[i] = math.max(1, maxAtt + 1 - att)
        totalWeight = totalWeight + weights[i]
    end

    local r = math.random() * totalWeight
    local cumulative = 0
    for i, w in ipairs(weights) do
        cumulative = cumulative + w
        if r <= cumulative then
            return StatusEffectCandidates[i], i
        end
    end

    return StatusEffectCandidates[#StatusEffectCandidates], #StatusEffectCandidates
end

--============================================================================
-- CACHED QUEST ACTIONS
--============================================================================

local function GetCachedQuestActions(target, ps)
    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)

    if CachedTarget.entity == target and #CachedTarget.actions > 0 then
        return CachedTarget.actions
    end

    local player = Game.GetPlayer()
    if not player then return nil end

    local context = MakeQuestContext(player)
    if not context then return nil end

    local rawActions = GetQuestActions(ps, context)
    if not rawActions or #rawActions == 0 then
        return nil
    end

    local actions = {}
    for _, action in ipairs(rawActions) do
        local class = GetActionClassName(action)
        local name = GetActionLabel(action)
        local recordID = GetActionRecordID(action)
        RegisterQuestAction(class, name, recordID)
        table.insert(actions, {
            action   = action,
            class    = class,
            name     = name,
            recordID = recordID,
        })
    end

    CachedTarget.entity = target
    CachedTarget.className = targetClass
    CachedTarget.actions = actions

    return actions
end

--============================================================================
-- REPORT GENERATION
--============================================================================

local function GenerateDeviceReport(target, targetClass, recordID, hash, questActions)
    local targetName = GetTargetName(target)
    local dist = GetDistance(target)

    dprint("========================================================")
    dprint("=== NEW DEVICE TYPE REPORT ===")
    dprint(string.format("  Name:       %s", targetName))
    dprint(string.format("  Class:      %s", targetClass or "<unknown>"))
    dprint(string.format("  RecordID:   %s", recordID))
    dprint(string.format("  EntityHash: %s", hash))
    if dist then
        dprint(string.format("  Distance:   %.2f m", dist))
    end
    dprint(string.format("  Available quest actions: %d", questActions and #questActions or 0))
    if questActions then
        for i, a in ipairs(questActions) do
            local reg = QuestRegistry[a.class]
            local att = reg and reg.attempts or 0
            dprint(string.format("    [%2d] %-30s (class: %s, record: %s) [attempts: %d]",
                i, a.name, a.class, a.recordID or "", att))
        end
    end
    dprint("========================================================")
end

--============================================================================
-- HOTKEYS (root level per CET hotkey registration rule)
--============================================================================

registerHotkey("SE_DEV2_TOGGLE_WINDOW", "Toggle Info Window", function()
    windowVisible = not windowVisible
    dprint(string.format("Info window %s", windowVisible and "ON" or "OFF"))
end)

registerHotkey("SE_DEV2_APPLY", "Apply Random Effect", function()
    local player = Game.GetPlayer()
    if not player then
        dprint("No player found")
        return
    end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        dprint("No hackable device targeted")
        LastResult.resultText = "No device"
        LastResult.success = false
        LastResult.path = nil
        return
    end

    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)
    local targetName = GetTargetName(target)
    local recordID, hash = GetEntityKey(target)

    local game = nil
    pcall(function() game = player:GetGame() end)

    -- First encounter report for this device type
    if not reportedDeviceTypes[targetClass] then
        local questActions = GetCachedQuestActions(target, ps)
        GenerateDeviceReport(target, targetClass, recordID, hash, questActions)
        reportedDeviceTypes[targetClass] = true
    end

    -- Randomly pick path: 50% QuestForce, 50% StatusEffect
    local useQuestForce = math.random() < 0.5

    if useQuestForce then
        -- PATH 1: QuestForce Actions
        dprint(">>> PATH 1: QuestForce Actions <<<")

        local actions = GetCachedQuestActions(target, ps)
        if not actions or #actions == 0 then
            dprint(string.format("No quest actions for %s -- falling back to StatusEffect", targetClass))
            useQuestForce = false
        else
            local picked, idx = PickRandomQuestAction(actions)
            if picked then
                local reg = QuestRegistry[picked.class]
                dprint(string.format("=== APPLY QUEST [%d/%d]: %s -> %s (class=%s) ===",
                    idx, #actions, picked.name, targetName, picked.class))

                local success, resultMsg, strategy = ExecuteQuestForce(
                    picked.action, target, ps, player, game, picked.class
                )

                if reg then
                    reg.attempts = reg.attempts + 1
                    if success then reg.successes = reg.successes + 1 end
                end
                PathStats.questForce.attempts = PathStats.questForce.attempts + 1
                if success then PathStats.questForce.successes = PathStats.questForce.successes + 1 end

                LastResult.path        = "QuestForce"
                LastResult.effectName  = picked.name
                LastResult.effectClass = picked.class
                LastResult.record      = picked.recordID
                LastResult.success     = success
                LastResult.resultText  = success and ("SUCCESS: " .. resultMsg) or ("FAIL: " .. resultMsg)
                LastResult.strategy    = strategy

                dprint(string.format("  Result: %s [%s]", LastResult.resultText, strategy))

                local total, tried, untried, pct = GetQuestCoverageStats()
                dprint(string.format("  QuestForce Coverage: %d/%d tried (%.0f%%)", tried, total, pct))
                return
            end
        end
    end

    if not useQuestForce then
        -- PATH 2: Direct StatusEffect on Device
        dprint(">>> PATH 2: Direct StatusEffect <<<")

        local picked, idx = PickRandomEffect()
        if picked then
            RegisterEffect(picked.record, picked.label)
            local reg = EffectRegistry[picked.record]

            dprint(string.format("=== APPLY EFFECT [%d/%d]: %s -> %s (record=%s) ===",
                idx, #StatusEffectCandidates, picked.label, targetName, picked.record))

            local success, resultMsg, strategy = ApplyStatusEffectToDevice(target, player, picked.record)

            if reg then
                reg.attempts = reg.attempts + 1
                if success then reg.successes = reg.successes + 1 end
            end
            PathStats.statusEffect.attempts = PathStats.statusEffect.attempts + 1
            if success then PathStats.statusEffect.successes = PathStats.statusEffect.successes + 1 end

            LastResult.path        = "StatusEffect"
            LastResult.effectName  = picked.label
            LastResult.effectClass = nil
            LastResult.record      = picked.record
            LastResult.success     = success
            LastResult.resultText  = success and ("SUCCESS: " .. resultMsg) or ("FAIL: " .. resultMsg)
            LastResult.strategy    = strategy

            dprint(string.format("  Result: %s [%s]", LastResult.resultText, strategy))

            local total, tried, untried, pct = GetEffectCoverageStats()
            dprint(string.format("  StatusEffect Coverage: %d/%d tried (%.0f%%)", tried, total, pct))
        end
    end
end)

--============================================================================
-- EVENTS
--============================================================================

registerForEvent("onInit", function()
    pcall(function() math.randomseed(os.time()) end)

    dprint("Status Effect Device Tester 2 initialized")
    dprint("  Testing TWO unexplored paths:")
    dprint("    Path 1: QuestForce Actions (GetQuestActions, requestType=Quest)")
    dprint("    Path 2: Direct StatusEffect on Devices (StatusEffectHelper)")
    dprint("  Hotkeys: SE_DEV2_TOGGLE_WINDOW, SE_DEV2_APPLY")
    dprint("  Bind in Settings > Key Bindings > SEDevT2")
    dprint("")
    dprint("Usage: Look at a device, press APPLY for random effect.")
    dprint("       Each press randomly picks a path, then a random effect/action,")
    dprint("       then a random execution method within that path.")
    dprint("       Log analysis after the fact will show what worked.")
end)

registerForEvent("onUpdate", function(delta)
    if not windowVisible then return end
    if not Game.GetPlayer() then return end

    local target, ps = GetLookAtDevice()

    Scan.entity       = nil
    Scan.typeName     = nil
    Scan.targetName   = nil
    Scan.className    = nil
    Scan.distance     = nil
    Scan.recordID     = nil
    Scan.entityHash   = nil
    Scan.questActions = nil

    if not target or not ps then return end

    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)

    Scan.entity     = target
    Scan.typeName   = "Device"
    Scan.targetName = GetTargetName(target)
    Scan.className  = targetClass
    Scan.distance   = GetDistance(target)

    local recordID, hash = GetEntityKey(target)
    Scan.recordID   = recordID
    Scan.entityHash = hash

    local actions = GetCachedQuestActions(target, ps)
    Scan.questActions = actions
end)

registerForEvent("onDraw", function()
    if not windowVisible then return end

    ImGui.SetNextWindowPos(10, 10, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(480, 520, ImGuiCond.FirstUseEver)

    local visible = ImGui.Begin("SE Device Tester 2", true, ImGuiWindowFlags.AlwaysAutoResize)
    if visible then
        -- Path stats summary
        ImGui.Text("Path Stats:")
        ImGui.Text(string.format("  QuestForce:   %d attempts, %d API-success",
            PathStats.questForce.attempts, PathStats.questForce.successes))
        ImGui.Text(string.format("  StatusEffect:  %d attempts, %d API-success",
            PathStats.statusEffect.attempts, PathStats.statusEffect.successes))
        ImGui.Separator()

        -- QuestForce coverage
        local qTotal, qTried, qUntried, qPct = GetQuestCoverageStats()
        ImGui.Text(string.format("QuestForce: %d/%d tried (%.0f%%)", qTried, qTotal, qPct))
        local qBarWidth = 100
        local qFilled = math.floor(qBarWidth * qPct / 100)
        ImGui.Text("[" .. string.rep("#", qFilled) .. string.rep("-", qBarWidth - qFilled) .. "]")

        -- StatusEffect coverage
        local eTotal, eTried, eUntried, ePct = GetEffectCoverageStats()
        ImGui.Text(string.format("StatusEffect: %d/%d tried (%.0f%%)", eTried, eTotal, ePct))
        local eFilled = math.floor(qBarWidth * ePct / 100)
        ImGui.Text("[" .. string.rep("#", eFilled) .. string.rep("-", qBarWidth - eFilled) .. "]")
        ImGui.Separator()

        if not Scan.entity then
            ImGui.Text("Looking at nothing (or non-device)...")
        else
            -- Target info
            ImGui.Text("Target:  " .. tostring(Scan.targetName or "Unknown"))
            ImGui.Text("Type:    " .. tostring(Scan.className or "?"))
            if Scan.distance then
                ImGui.Text(string.format("Dist:    %.1f m", Scan.distance))
            end
            if Scan.recordID then
                ImGui.Text("Record:  " .. Scan.recordID)
            end

            ImGui.Separator()

            -- Last result
            if LastResult.resultText then
                local prefix = LastResult.success and "[OK]  " or "[FAIL]"
                ImGui.Text("Last: " .. prefix .. " [" .. tostring(LastResult.path or "?") .. "] " .. (LastResult.effectName or "?"))
                if LastResult.effectClass then
                    ImGui.Text("  Class:  " .. tostring(LastResult.effectClass))
                end
                if LastResult.record then
                    ImGui.Text("  Record: " .. tostring(LastResult.record))
                end
                ImGui.Text("  Strat:  " .. tostring(LastResult.strategy or "?"))
                ImGui.Text("  -> " .. LastResult.resultText)
            else
                ImGui.Text("Last: (none yet)")
            end

            ImGui.Separator()

            -- Quest actions on current device
            if Scan.questActions and #Scan.questActions > 0 then
                ImGui.Text(string.format("Quest Actions (%d):", #Scan.questActions))
                local shown = math.min(#Scan.questActions, Config.maxDisplayItems)
                for i = 1, shown do
                    local a = Scan.questActions[i]
                    local reg = QuestRegistry[a.class]
                    local att = reg and reg.attempts or 0
                    local mark = att > 0 and "*" or " "
                    ImGui.Text(string.format(" %s %-30s [%d]", mark, a.name, att))
                end
            else
                ImGui.Text("No quest actions discovered for this device")
            end

            ImGui.Separator()

            -- Status effect candidates
            ImGui.Text(string.format("Status Effects (%d candidates):", #StatusEffectCandidates))
            local shown = math.min(#StatusEffectCandidates, Config.maxDisplayItems)
            for i = 1, shown do
                local e = StatusEffectCandidates[i]
                local reg = EffectRegistry[e.record]
                local att = reg and reg.attempts or 0
                local mark = att > 0 and "*" or " "
                ImGui.Text(string.format(" %s %-30s [%d]", mark, e.label, att))
            end

            ImGui.Separator()
            ImGui.Text("* = tried at least once")
            ImGui.Text("Press APPLY hotkey for random effect")
        end
    end
    ImGui.End()
end)

registerForEvent("onShutdown", function()
    dprint("=== Final Statistics ===")
    dprint("")
    dprint("--- Path Stats ---")
    dprint(string.format("  QuestForce:  %d attempts, %d API-success",
        PathStats.questForce.attempts, PathStats.questForce.successes))
    dprint(string.format("  StatusEffect: %d attempts, %d API-success",
        PathStats.statusEffect.attempts, PathStats.statusEffect.successes))
    dprint("")
    dprint("--- QuestForce Actions ---")
    for _, className in ipairs(QuestOrder) do
        local e = QuestRegistry[className]
        dprint(string.format("  %-35s (class: %s): %d attempts, %d success",
            e.name, e.class, e.attempts, e.successes))
    end
    dprint("")
    dprint("--- StatusEffect Candidates ---")
    for _, record in ipairs(EffectOrder) do
        local e = EffectRegistry[record]
        dprint(string.format("  %-40s (record: %s): %d attempts, %d success",
            e.name, e.record, e.attempts, e.successes))
    end
    dprint("")
    dprint(string.format("--- Device Types Encountered: %d ---", #reportedDeviceTypes))
    for className, _ in pairs(reportedDeviceTypes) do
        dprint(string.format("    %s", className))
    end
    dprint("")
    dprint("=== IMPORTANT: API success != visible in-game effect ===")
    dprint("=== Check log + game to see which (if any) produced visible results ===")
    dprint("=== End Statistics ===")
    dprint("Status Effect Device Tester 2 shut down")
end)
