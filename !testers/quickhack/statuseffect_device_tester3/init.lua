--[[
  Status Effect Device Tester 3 - CET (Lua)
  Device-only QuestForce tester with dual execution methods + per-hotkey latch.

  Focus: distract, overload, break chains on devices (NOT NPCs).
  Based on tester2 findings:
    - QuestForce actions WORK (QuestForceDetonate confirmed on ExplosiveDevice)
    - Direct StatusEffect on devices FAILS (dropped)

  Two execution methods, each on its own hotkey:
    F9  = Full Action Chain (QA: Setup -> IsPossible -> Resolve -> StartAction -> ProcessRPG)
    F10 = Direct PS Handler  (QB: call ps:OnQuestForceXxx() directly)

  Latch system (per-hotkey):
    Each hotkey stores its own last action.
    When pressed, check the OTHER hotkey's latch first.
    If the other's latched action hasn't been tried via this hotkey's method, reuse it.
    Otherwise pick random.

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester3/

  Bind hotkeys in: Settings > Key Bindings > SEDevT3
--]]

local ModName = "SEDevT3"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    debug           = true,
    maxDistance     = 20.0,
    windowWidth     = 1000,
}

--============================================================================
-- GOAL CATEGORIES
--============================================================================
local ActionGoals = {
    ["QuestStartGlitch"]              = "distract",
    ["QuestForceStartGlitch"]         = "distract",
    ["QuestForceON"]                  = "distract",
    ["QuestForceActivate"]            = "distract",
    ["QuestForcePower"]               = "distract",
    ["QuestEnableInteraction"]        = "distract",
    ["QuestForceOFF"]                 = "overload",
    ["QuestForceDeactivate"]          = "overload",
    ["QuestForceUnpower"]             = "overload",
    ["QuestForceDestructible"]        = "overload",
    ["QuestForceDetonate"]            = "overload",
    ["QuestForceStopGlitch"]          = "distract",
    ["QuestStopGlitch"]               = "distract",
    ["QuestForceSecuritySystemSafe"]   = "security",
    ["QuestForceSecuritySystemAlarmed"] = "security",
    ["QuestForceSecuritySystemArmed"]  = "security",
    ["QuestDisableInteraction"]       = "overload",
    ["QuestNextStation"]              = "distract",
    ["QuestPreviousStation"]          = "distract",
    ["QuestDefaultStation"]           = "distract",
    ["QuestMuteSounds"]               = "overload",
    ["QuestUnMuteSounds"]             = "distract",
}

-- Blacklist: actions that aren't useful for this testing
local ActionBlacklist = {
    ["QuestEnableFixing"]     = true,
    ["QuestDisableFixing"]    = true,
    ["QuestForceInvulnerable"] = true,
    ["QuestForceIndestructible"] = true,
}

--============================================================================
-- REGISTRY
--============================================================================
local Registry = {}     -- [className] = { name=, class=, goal=, recordID=, chain={attempts=,successes=}, ps={attempts=,successes=} }
local Order = {}        -- array of class names in first-encounter order

local reportedDeviceTypes = {}

--============================================================================
-- STATE
--============================================================================

local windowVisible = false

local Scan = {
    entity     = nil,
    typeName   = nil,
    targetName = nil,
    className  = nil,
    distance   = nil,
    recordID   = nil,
    entityHash = nil,
    actions    = nil,
}

-- Per-hotkey latch: each hotkey stores its own last action class
local ChainLatch = { actionClass = nil }  -- F9's latch
local PSLatch    = { actionClass = nil }  -- F10's latch

local LastResult = {
    actionName  = nil,
    actionClass = nil,
    goal        = nil,
    method      = nil,
    success     = nil,
    resultText  = nil,
}

-- Cached quest actions for current target
local CachedTarget = {
    entity    = nil,
    className = "",
    actions   = {},
}

--============================================================================
-- HELPERS
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
-- TARGETING
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

local function MakeQuestContext(player)
    local context = nil
    pcall(function() context = NewObject('gameGetActionsContext') end)
    if not context then
        dprint("Could not create GetActionsContext")
        return nil
    end

    pcall(function() context.requestorID = player:GetEntityID() end)
    pcall(function() context.requestType = gamedeviceRequestType.Quest end)
    pcall(function() context.ignoresRPG = true end)
    pcall(function() context.ignoresAuthorization = true end)
    pcall(function() context.processInitiatorObject = player end)

    return context
end

--============================================================================
-- QUEST ACTION DISCOVERY
--============================================================================

local function GetQuestActions(ps, context)
    local ok1, result1 = SafeCall(function()
        return ps:GetQuestActions(context)
    end)
    if ok1 and result1 and type(result1) == "table" and #result1 > 0 then
        return result1
    end

    local outArr = {}
    local ok2 = pcall(function()
        ps:GetQuestActions(outArr, context)
    end)
    if ok2 and #outArr > 0 then
        return outArr
    end

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
-- ACTION REGISTRATION
--============================================================================

local function RegisterAction(className, name, recordID)
    if ActionBlacklist[className] then return false end
    if not Registry[className] then
        Registry[className] = {
            name     = name or className,
            class    = className,
            goal     = ActionGoals[className] or "?",
            recordID = recordID or "",
            chain    = { attempts = 0, successes = 0 },
            ps      = { attempts = 0, successes = 0 },
        }
        table.insert(Order, className)
        dprint(string.format("  [NEW ACTION] %s (class: %s, goal: %s, record: %s)",
            name, className, Registry[className].goal, recordID or ""))
    end
    return true
end

--============================================================================
-- PS HANDLER MAPPING
--============================================================================

local function GetQuestPSHandlerName(actionClassName)
    local mapping = {
        ["QuestForceON"]                  = "OnQuestForceON",
        ["QuestForceOFF"]                 = "OnQuestForceOFF",
        ["QuestStartGlitch"]              = "OnQuestStartGlitch",
        ["QuestStopGlitch"]               = "OnQuestStopGlitch",
        ["QuestForceStartGlitch"]         = "OnQuestForceStartGlitch",
        ["QuestForceStopGlitch"]          = "OnQuestForceStopGlitch",
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
        ["QuestEnableInteraction"]        = "OnQuestEnableInteraction",
        ["QuestDisableInteraction"]       = "OnQuestDisableInteraction",
        ["QuestEnableFixing"]             = "OnQuestEnableFixing",
        ["QuestDisableFixing"]            = "OnQuestDisableFixing",
        ["QuestForceInvulnerable"]       = "OnQuestForceInvulnerable",
        ["QuestForceIndestructible"]     = "OnQuestForceIndestructible",
        ["QuestNextStation"]              = "OnQuestNextStation",
        ["QuestPreviousStation"]          = "OnQuestPreviousStation",
        ["QuestDefaultStation"]           = "OnQuestDefaultStation",
        ["QuestMuteSounds"]               = "OnQuestMuteSounds",
        ["QuestUnMuteSounds"]             = "OnQuestUnMuteSounds",
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

--============================================================================
-- EXECUTION: METHOD A - FULL ACTION CHAIN
--============================================================================

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

local function ExecuteViaFullChain(action, player, game)
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

--============================================================================
-- EXECUTION: METHOD B - DIRECT PS HANDLER
--============================================================================

local function ExecuteViaPSHandler(action, ps, className)
    local handlerName = GetQuestPSHandlerName(className)
    if not handlerName then
        return false, "no PS handler for " .. className
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
        local accepted = RegisterAction(class, name, recordID)
        if accepted then
            table.insert(actions, {
                action   = action,
                class    = class,
                name     = name,
                recordID = recordID,
                goal     = ActionGoals[class] or "?",
            })
        end
    end

    CachedTarget.entity = target
    CachedTarget.className = targetClass
    CachedTarget.actions = actions

    return actions
end

--============================================================================
-- RANDOM SELECTION (weighted: untried actions picked more often)
--============================================================================

local function PickRandomAction(actionList, method)
    if not actionList or #actionList == 0 then return nil, 0 end

    local maxAtt = 0
    for _, a in ipairs(actionList) do
        local reg = Registry[a.class]
        local att = reg and reg[method].attempts or 0
        if att > maxAtt then maxAtt = att end
    end

    local totalWeight = 0
    local weights = {}
    for i, a in ipairs(actionList) do
        local reg = Registry[a.class]
        local att = reg and reg[method].attempts or 0
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

-- Find an action by class name in the list
local function FindActionByClass(actionList, className)
    for _, a in ipairs(actionList) do
        if a.class == className then return a end
    end
    return nil
end

--============================================================================
-- DEVICE REPORT
--============================================================================

local function GenerateDeviceReport(target, targetClass, recordID, hash, actions)
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
    dprint(string.format("  Available quest actions: %d", actions and #actions or 0))
    if actions then
        for i, a in ipairs(actions) do
            local reg = Registry[a.class]
            local cAtt = reg and reg.chain.attempts or 0
            local pAtt = reg and reg.ps.attempts or 0
            dprint(string.format("    [%2d] %-30s (class: %s, goal: %s) [chain:%d ps:%d]",
                i, a.name, a.class, a.goal, cAtt, pAtt))
        end
    end
    dprint("========================================================")
end

--============================================================================
-- APPLY LOGIC (shared by both hotkeys)
--============================================================================

local function ApplyAction(method, target, ps, player, game)
    -- method = "chain" or "ps"
    local actions = GetCachedQuestActions(target, ps)
    if not actions or #actions == 0 then
        dprint("No quest actions for this device")
        LastResult.resultText = "No quest actions"
        LastResult.success = false
        return
    end

    local picked = nil
    local latchUsed = false

    -- Per-hotkey latch: check the OTHER hotkey's latch first.
    -- If the other's latched action hasn't been tried via this method, reuse it.
    local otherLatch = (method == "chain") and PSLatch or ChainLatch
    if otherLatch.actionClass then
        local reg = Registry[otherLatch.actionClass]
        local alreadyTried = reg and reg[method].attempts > 0 or false
        if not alreadyTried then
            picked = FindActionByClass(actions, otherLatch.actionClass)
            if picked then
                latchUsed = true
                dprint(string.format("[LATCH] Reusing %s from %s latch via %s",
                    picked.class, (method == "chain") and "PS(F10)" or "Chain(F9)", method))
            end
        end
    end

    -- If no latch reuse, pick random
    if not picked then
        picked = PickRandomAction(actions, method)
    end

    if not picked then return end

    local reg = Registry[picked.class]
    local methodLabel = (method == "chain") and "FullChain" or "DirectPS"
    local targetName = GetTargetName(target)

    dprint(string.format("=== APPLY [%s] %s -> %s (class=%s, goal=%s) %s ===",
        methodLabel, picked.name, targetName, picked.class, picked.goal,
        latchUsed and "[LATCHED]" or "[RANDOM]"))

    local success, resultMsg
    if method == "chain" then
        success, resultMsg = ExecuteViaFullChain(picked.action, player, game)
    else
        success, resultMsg = ExecuteViaPSHandler(picked.action, ps, picked.class)
    end

    -- Update registry
    if reg then
        reg[method].attempts = reg[method].attempts + 1
        if success then reg[method].successes = reg[method].successes + 1 end
    end

    -- Update this hotkey's latch
    if method == "chain" then
        ChainLatch.actionClass = picked.class
    else
        PSLatch.actionClass = picked.class
    end

    -- Update last result
    LastResult.actionName  = picked.name
    LastResult.actionClass = picked.class
    LastResult.goal        = picked.goal
    LastResult.method      = methodLabel
    LastResult.success     = success
    LastResult.resultText  = success and ("SUCCESS: " .. resultMsg) or ("FAIL: " .. resultMsg)

    dprint(string.format("  Result: %s", LastResult.resultText))
end

--============================================================================
-- HOTKEYS (root level per CET hotkey registration rule)
--============================================================================

registerHotkey("SE_DEV3_TOGGLE_WINDOW", "Toggle Info Window", function()
    windowVisible = not windowVisible
    dprint(string.format("Info window %s", windowVisible and "ON" or "OFF"))
end)

registerHotkey("SE_DEV3_FULL_CHAIN", "Apply via Full Chain", function()
    local player = Game.GetPlayer()
    if not player then return end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        dprint("No hackable device targeted")
        LastResult.resultText = "No device"
        LastResult.success = false
        return
    end

    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)
    local recordID, hash = GetEntityKey(target)

    local game = nil
    pcall(function() game = player:GetGame() end)

    if not reportedDeviceTypes[targetClass] then
        local actions = GetCachedQuestActions(target, ps)
        GenerateDeviceReport(target, targetClass, recordID, hash, actions)
        reportedDeviceTypes[targetClass] = true
    end

    dprint(">>> METHOD A: Full Action Chain <<<")
    ApplyAction("chain", target, ps, player, game)
end)

registerHotkey("SE_DEV3_DIRECT_PS", "Apply via Direct PS", function()
    local player = Game.GetPlayer()
    if not player then return end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        dprint("No hackable device targeted")
        LastResult.resultText = "No device"
        LastResult.success = false
        return
    end

    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)
    local recordID, hash = GetEntityKey(target)

    local game = nil
    pcall(function() game = player:GetGame() end)

    if not reportedDeviceTypes[targetClass] then
        local actions = GetCachedQuestActions(target, ps)
        GenerateDeviceReport(target, targetClass, recordID, hash, actions)
        reportedDeviceTypes[targetClass] = true
    end

    dprint(">>> METHOD B: Direct PS Handler <<<")
    ApplyAction("ps", target, ps, player, game)
end)

--============================================================================
-- EVENTS
--============================================================================

registerForEvent("onInit", function()
    pcall(function() math.randomseed(os.time()) end)

    dprint("Status Effect Device Tester 3 initialized")
    dprint("  Focus: distract, overload, break chains (devices only)")
    dprint("  Two execution methods:")
    dprint("    F9  = Full Action Chain (QA)")
    dprint("    F10 = Direct PS Handler (QB)")
    dprint("  Latch: per-hotkey, cross-check other's latch first")
    dprint("  Hotkeys: SE_DEV3_TOGGLE_WINDOW, SE_DEV3_FULL_CHAIN, SE_DEV3_DIRECT_PS")
    dprint("  Bind in Settings > Key Bindings > SEDevT3")
end)

registerForEvent("onUpdate", function(delta)
    if not windowVisible then return end
    if not Game.GetPlayer() then return end

    local target, ps = GetLookAtDevice()

    Scan.entity     = nil
    Scan.typeName   = nil
    Scan.targetName = nil
    Scan.className  = nil
    Scan.distance   = nil
    Scan.recordID   = nil
    Scan.entityHash = nil
    Scan.actions    = nil

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
    Scan.actions = actions
end)

registerForEvent("onDraw", function()
    if not windowVisible then return end

    ImGui.SetNextWindowPos(10, 10, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(Config.windowWidth, 400, ImGuiCond.FirstUseEver)

    local visible = ImGui.Begin("SE Dev Tester 3", true)
    if visible then
        -- Wrap all text to window width
        ImGui.PushTextWrapPos(Config.windowWidth - 10)

        if not Scan.entity then
            ImGui.Text("Looking at nothing...")
        else
            -- Target info (compact)
            ImGui.Text("Target: " .. tostring(Scan.targetName or "?"))
            ImGui.Text("Class:  " .. tostring(Scan.className or "?"))
            if Scan.distance then
                ImGui.Text(string.format("Dist:   %.1fm", Scan.distance))
            end

            ImGui.Separator()

            -- Last result (compact)
            if LastResult.resultText then
                local prefix = LastResult.success and "[OK] " or "[X] "
                local goalStr = LastResult.goal and ("(" .. LastResult.goal .. ") ") or ""
                ImGui.Text(prefix .. goalStr .. (LastResult.actionName or "?"))
                ImGui.Text("  via " .. tostring(LastResult.method or "?"))
                ImGui.Text("  -> " .. (LastResult.resultText or ""))
            else
                ImGui.Text("Last: (none)")
            end

            -- Latch indicators
            ImGui.Separator()
            local f9Latch = ChainLatch.actionClass or "(empty)"
            local f10Latch = PSLatch.actionClass or "(empty)"
            if #f9Latch > 25 then f9Latch = f9Latch:sub(1, 22) .. "..." end
            if #f10Latch > 25 then f10Latch = f10Latch:sub(1, 22) .. "..." end
            ImGui.Text("F9 latch:  " .. f9Latch)
            ImGui.Text("F10 latch: " .. f10Latch)

            ImGui.Separator()

            -- Quest actions on current device
            if Scan.actions and #Scan.actions > 0 then
                ImGui.Text(string.format("Actions (%d):", #Scan.actions))
                for i = 1, #Scan.actions do
                    local a = Scan.actions[i]
                    local reg = Registry[a.class]
                    local cAtt = reg and reg.chain.attempts or 0
                    local pAtt = reg and reg.ps.attempts or 0
                    local mark = " "
                    if cAtt > 0 and pAtt > 0 then mark = "*"
                    elseif cAtt > 0 or pAtt > 0 then mark = "." end
                    local goalTag = a.goal ~= "?" and a.goal:sub(1, 4) or "?"
                    local name = a.name
                    if #name > 18 then name = name:sub(1, 15) .. "..." end
                    local classShort = a.class
                    if #classShort > 20 then classShort = classShort:sub(1, 17) .. "..." end
                    ImGui.Text(string.format("%s[%s] %s", mark, goalTag, name))
                    ImGui.Text(string.format("     %s c:%d p:%d", classShort, cAtt, pAtt))
                end
            else
                ImGui.Text("No quest actions found")
            end

            ImGui.Separator()
            ImGui.Text("F9=Chain F10=DirectPS")
            ImGui.Text("* = both tried")
            ImGui.Text(". = one tried")
        end

        ImGui.PopTextWrapPos()
    end
    ImGui.End()
end)

registerForEvent("onShutdown", function()
    dprint("=== Final Statistics ===")
    dprint("")
    dprint("--- QuestForce Actions ---")
    for _, className in ipairs(Order) do
        local e = Registry[className]
        dprint(string.format("  %-35s (goal: %s) chain:%d/%d ps:%d/%d",
            e.name, e.goal,
            e.chain.successes, e.chain.attempts,
            e.ps.successes, e.ps.attempts))
    end
    dprint("")
    dprint(string.format("--- Device Types Encountered: %d ---", #reportedDeviceTypes))
    for className, _ in pairs(reportedDeviceTypes) do
        dprint(string.format("    %s", className))
    end
    dprint("")
    dprint("=== API success != visible effect -- check game ===")
    dprint("=== End Statistics ===")
    dprint("Status Effect Device Tester 3 shut down")
end)
