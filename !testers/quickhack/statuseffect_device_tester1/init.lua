--[[
  Status Effect Device Tester 1 - CET (Lua)
  Random quickhack action tester for devices with live info window.

  Based on research from statuseffect_tester3/research_device_hacks.md:
    - Uses dynamic action discovery via DevicePS:GetQuickHackActions()
    - Executes via full action chain (StartAction -> PS handler -> DeviceSystem)
    - No static effect list -- queries each device for its available hacks
    - Different device types expose different quickhack actions

  Interface (same simplicity as tester3 / npc_tester1):
    - Toggle window hotkey
    - Apply random hack hotkey (weighted: untried action types picked more often)
    - ImGui window with tried/untried coverage percentage indicator

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester1/

  Bind hotkeys in: Settings > Key Bindings > SEDevT1
--]]

local ModName = "SEDevT1"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    debug            = true,
    maxDistance      = 20.0,
    maxDisplayHacks  = 20,
}

--============================================================================
-- GLOBAL ACTION REGISTRY
-- Tracks all unique quickhack action types encountered across all devices.
-- Keyed by action class name for cross-device coverage tracking.
-- When a new device type is targeted, its actions are merged into the registry.
-- Coverage = tried action types / total known action types.
--============================================================================
local ActionRegistry = {}   -- [className] = { name=, class=, recordID=, attempts=0 }
local ActionOrder = {}      -- array of class names in first-encounter order

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
    availActions = nil,  -- array of { action=, class=, name=, recordID= } for current target
}

local LastHack = {
    actionName  = nil,
    actionClass = nil,
    success     = nil,
    resultText  = nil,
    strategy    = nil,
}

local reportedDeviceTypes = {}  -- keyed by className for first-encounter reports

-- Cached actions for current target (avoid re-querying every frame)
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

--- Extract readable name from a CName's tostring.
--- Multiple fallback approaches since tostring(cname) may return userdata.
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

--- Get the quickhackable device under the crosshair
--- Uses TSF_Quickhackable filter + GetObjectClosestToCrosshair (from tester4)
--- Returns: entity, devicePS or nil, nil
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

--- Create a GetActionsContext for quickhack actions
local function MakeContext(player)
    local context = nil
    pcall(function() context = NewObject('gameGetActionsContext') end)
    if not context then
        dprint("Could not create GetActionsContext")
        return nil
    end

    pcall(function() context.requestorID = player:GetEntityID() end)
    pcall(function() context.requestType = gamedeviceRequestType.Remote end)
    pcall(function() context.ignoresRPG = true end)
    pcall(function() context.ignoresAuthorization = true end)
    pcall(function() context.processInitiatorObject = player end)

    return context
end

--============================================================================
-- ACTION DISCOVERY
--============================================================================

--- Check if an action is a quickhack action by examining its ObjectActionRecord
local function IsQuickHackAction(action)
    local isQH = false
    pcall(function()
        local record = nil
        pcall(function() record = action:GetObjectActionRecord() end)
        if record then
            local cat = nil
            pcall(function() cat = record:HackCategory() end)
            if cat then
                local catType = nil
                pcall(function() catType = cat:Type() end)
                if catType and catType.value ~= 0 then
                    isQH = true
                end
            end
        end
    end)
    if not isQH then
        pcall(function()
            local className = action:GetClassName()
            if className then
                local nameStr = CNameToString(className)
                if nameStr:match("^QuickHack") or nameStr:match("^GlitchScreen")
                   or nameStr:match("^MalfunctionClassHack") then
                    isQH = true
                end
            end
        end)
    end
    return isQH
end

--- Get quickhack actions from device PS (from tester4, proven working)
--- Tries multiple calling conventions, returns array of DeviceAction objects
local function GetQuickHackActions(ps, context)
    -- Convention 1: ps:GetQuickHackActions(context) returns array (proven working)
    local ok1, result1 = SafeCall(function()
        return ps:GetQuickHackActions(context)
    end)
    if ok1 and result1 and type(result1) == "table" and #result1 > 0 then
        return result1
    end

    -- Convention 2: ps:GetQuickHackActionsExternal(context)
    local ok2, result2 = SafeCall(function()
        return ps:GetQuickHackActionsExternal(context)
    end)
    if ok2 and result2 and type(result2) == "table" and #result2 > 0 then
        return result2
    end

    -- Convention 3: ps:GetQuickHackActions(outArray, context) -- out-array
    local outArr = {}
    local ok3 = pcall(function()
        ps:GetQuickHackActions(outArr, context)
    end)
    if ok3 and #outArr > 0 then
        return outArr
    end

    -- Convention 4: ps:GetActions(context) -- broader, filter to quickhacks
    local ok4, result4 = SafeCall(function()
        return ps:GetActions(context)
    end)
    if ok4 and result4 and type(result4) == "table" and #result4 > 0 then
        local qhActions = {}
        for _, action in ipairs(result4) do
            if IsQuickHackAction(action) then
                table.insert(qhActions, action)
            end
        end
        if #qhActions > 0 then
            return qhActions
        end
        return result4
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
-- ACTION EXECUTION (from tester4, condensed logging)
--============================================================================

--- Map an action's class name to the corresponding PS On* handler method name
local function GetPSHandlerName(actionClassName)
    local mapping = {
        ["QuickHackDistraction"]       = "OnQuickHackDistraction",
        ["MalfunctionClassHack"]       = "OnQuickHackDistraction",
        ["QuickHackAuthorization"]     = "OnQuickHackAuthorization",
        ["QuickHackToggleON"]          = "OnQuickHackToggleOn",
        ["GlitchScreen"]               = "OnQuickHackDistraction",
        ["GlitchScreenSuicide"]        = "OnQuickHackDistraction",
        ["GlitchScreenBlind"]          = "OnQuickHackDistraction",
        ["GlitchScreenGrenade"]        = "OnQuickHackDistraction",
    }
    if mapping[actionClassName] then
        return mapping[actionClassName]
    end
    local prefix = actionClassName:match("^(QuickHack.+)$")
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

--- Strategy A: Full action chain (StartAction with fallbacks)
local function ApplyQuickHackFull(action, player, game)
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

    -- Fallback: ProcessRPGAction
    local ok2, err2 = SafeCall(function()
        action:ProcessRPGAction(game)
    end)
    if ok2 then
        return true, "ProcessRPGAction OK"
    end

    -- Fallback: CompleteAction
    local ok3, err3 = SafeCall(function()
        action:CompleteAction(game)
    end)
    if ok3 then
        return true, "CompleteAction OK"
    end

    return false, tostring(err)
end

--- Strategy B: Direct PS event handler call
local function ApplyQuickHackViaPS(action, ps, player, game, class)
    local handlerName = GetPSHandlerName(class)
    if not handlerName then
        return false, "no PS handler for " .. class
    end

    local ok1 = pcall(function() ps[handlerName](ps, action) end)
    if ok1 then return true, "PS " .. handlerName .. " OK" end

    local ok2 = pcall(function() ps[handlerName](ps) end)
    if ok2 then return true, "PS " .. handlerName .. " OK (no args)" end

    local ok3 = pcall(function() ps:QueuePSDeviceEvent(action) end)
    if ok3 then return true, "QueuePSDeviceEvent OK" end

    return false, "PS strategies failed"
end

--- Strategy C: DeviceSystem direct access
local function ApplyQuickHackViaDeviceSystem(target, player, game, action)
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

--- Full execution chain: A -> B -> C
local function ExecuteAction(action, target, ps, player, game, class)
    local success, msg, strategy

    success, msg = ApplyQuickHackFull(action, player, game)
    if success then return true, msg, "A:FullChain" end

    success, msg = ApplyQuickHackViaPS(action, ps, player, game, class)
    if success then return true, msg, "B:PSHandler" end

    success, msg = ApplyQuickHackViaDeviceSystem(target, player, game, action)
    if success then return true, msg, "C:DeviceSystem" end

    return false, msg or "all strategies failed", "NONE"
end

--============================================================================
-- REGISTRY MANAGEMENT
--============================================================================

--- Register an action type in the global registry (if new)
local function RegisterAction(className, name, recordID)
    if not ActionRegistry[className] then
        ActionRegistry[className] = {
            name      = name or className,
            class     = className,
            recordID  = recordID or "",
            attempts  = 0,
        }
        table.insert(ActionOrder, className)
        dprint(string.format("  [NEW ACTION TYPE] %s (class: %s, record: %s)", name, className, recordID or ""))
    end
end

--- Get or refresh cached actions for a target, and merge into registry
--- Returns: array of { action=, class=, name=, recordID= } or nil
local function GetCachedActions(target, ps)
    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)

    if CachedTarget.entity == target and #CachedTarget.actions > 0 then
        return CachedTarget.actions
    end

    local player = Game.GetPlayer()
    if not player then return nil end

    local context = MakeContext(player)
    if not context then return nil end

    local rawActions = GetQuickHackActions(ps, context)
    if not rawActions or #rawActions == 0 then
        return nil
    end

    local actions = {}
    for _, action in ipairs(rawActions) do
        local class = GetActionClassName(action)
        local name = GetActionLabel(action)
        local recordID = GetActionRecordID(action)
        RegisterAction(class, name, recordID)
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

--- Coverage stats across all known action types
local function GetCoverageStats()
    local total = #ActionOrder
    local tried = 0
    for _, className in ipairs(ActionOrder) do
        if ActionRegistry[className].attempts > 0 then
            tried = tried + 1
        end
    end
    local untried = total - tried
    local pct = total > 0 and (tried / total) * 100 or 0
    return total, tried, untried, pct
end

--============================================================================
-- RANDOM WEIGHTED SELECTION
--============================================================================

--- Pick a random action from the list, weighting untried types higher.
--- Uses global attempt count from ActionRegistry.
local function PickRandomAction(actionList)
    if not actionList or #actionList == 0 then return nil, 0 end

    local maxAtt = 0
    for _, a in ipairs(actionList) do
        local reg = ActionRegistry[a.class]
        local att = reg and reg.attempts or 0
        if att > maxAtt then maxAtt = att end
    end

    local totalWeight = 0
    local weights = {}
    for i, a in ipairs(actionList) do
        local reg = ActionRegistry[a.class]
        local att = reg and reg.attempts or 0
        weights[i] = (maxAtt + 1 - att)
        if weights[i] < 1 then weights[i] = 1 end
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

--============================================================================
-- REPORT GENERATION (first encounter per device type)
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
    dprint(string.format("  Available quickhack actions: %d", #actions))
    for i, a in ipairs(actions) do
        local reg = ActionRegistry[a.class]
        local att = reg and reg.attempts or 0
        dprint(string.format("    [%2d] %-30s (class: %s, record: %s) [global attempts: %d]",
            i, a.name, a.class, a.recordID or "", att))
    end
    dprint("========================================================")
end

--============================================================================
-- HOTKEYS (root level per CET hotkey registration rule)
--============================================================================

registerHotkey("SE_DEV1_TOGGLE_WINDOW", "Toggle Info Window", function()
    windowVisible = not windowVisible
    dprint(string.format("Info window %s", windowVisible and "ON" or "OFF"))
end)

registerHotkey("SE_DEV1_APPLY", "Apply Random Hack", function()
    local player = Game.GetPlayer()
    if not player then
        dprint("No player found")
        return
    end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        dprint("No hackable device targeted")
        LastHack.resultText = "No device"
        LastHack.success = false
        LastHack.actionName = nil
        return
    end

    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)
    local targetName = GetTargetName(target)
    local recordID, hash = GetEntityKey(target)

    local game = nil
    pcall(function() game = player:GetGame() end)

    local actions = GetCachedActions(target, ps)
    if not actions or #actions == 0 then
        dprint(string.format("No quickhack actions for %s", targetClass))
        LastHack.resultText = "No actions"
        LastHack.success = false
        LastHack.actionName = nil
        return
    end

    -- First encounter report for this device type
    if not reportedDeviceTypes[targetClass] then
        GenerateDeviceReport(target, targetClass, recordID, hash, actions)
        reportedDeviceTypes[targetClass] = true
    end

    -- Pick random weighted action
    local picked, idx = PickRandomAction(actions)
    if not picked then
        dprint("Could not pick an action")
        return
    end

    local reg = ActionRegistry[picked.class]
    dprint(string.format("=== APPLY [%d/%d]: %s -> %s (class=%s) ===",
        idx, #actions, picked.name, targetName, picked.class))

    -- Execute via full chain
    local success, resultMsg, strategy = ExecuteAction(
        picked.action, target, ps, player, game, picked.class
    )

    -- Increment global attempt count
    if reg then
        reg.attempts = reg.attempts + 1
    end

    -- Update last hack display
    LastHack.actionName  = picked.name
    LastHack.actionClass = picked.class
    LastHack.success     = success
    LastHack.resultText  = success and ("SUCCESS: " .. resultMsg) or ("FAIL: " .. resultMsg)
    LastHack.strategy    = strategy

    dprint(string.format("  Result: %s [%s]", LastHack.resultText, strategy))
    dprint(string.format("  Attempts on '%s': %d", picked.class, reg and reg.attempts or 0))

    local total, tried, untried, pct = GetCoverageStats()
    dprint(string.format("  Coverage: %d/%d tried (%.0f%%)", tried, total, pct))
end)

--============================================================================
-- EVENTS
--============================================================================

registerForEvent("onInit", function()
    pcall(function() math.randomseed(os.time()) end)

    dprint("Status Effect Device Tester 1 initialized")
    dprint("  Uses dynamic action discovery (no static effect list)")
    dprint("  Hotkeys: SE_DEV1_TOGGLE_WINDOW, SE_DEV1_APPLY")
    dprint("  Bind in Settings > Key Bindings > SEDevT1")
    dprint("")
    dprint("Usage: Look at a device, press APPLY for random weighted quickhack.")
    dprint("       Toggle window to see target details and coverage stats.")
    dprint("       Walk around hitting APPLY on different device types.")
end)

registerForEvent("onUpdate", function(delta)
    if not windowVisible then return end
    if not Game.GetPlayer() then return end

    local target, ps = GetLookAtDevice()

    -- Reset scan data
    Scan.entity       = nil
    Scan.typeName     = nil
    Scan.targetName   = nil
    Scan.className    = nil
    Scan.distance     = nil
    Scan.recordID     = nil
    Scan.entityHash   = nil
    Scan.availActions = nil

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

    -- Refresh action cache if target changed
    local actions = GetCachedActions(target, ps)
    Scan.availActions = actions
end)

registerForEvent("onDraw", function()
    if not windowVisible then return end

    ImGui.SetNextWindowPos(10, 10, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(440, 420, ImGuiCond.FirstUseEver)

    local visible = ImGui.Begin("SE Device Tester 1", true, ImGuiWindowFlags.AlwaysAutoResize)
    if visible then
        -- Coverage bar (always visible at top)
        local total, tried, untried, pct = GetCoverageStats()
        ImGui.Text(string.format("Coverage: %d/%d tried (%.0f%%) -- %d untried", tried, total, pct, untried))

        local barWidth = 100
        local filled = math.floor(barWidth * pct / 100)
        local barStr = string.rep("#", filled) .. string.rep("-", barWidth - filled)
        ImGui.Text("[" .. barStr .. "]")
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

            -- Last hack result
            if LastHack.resultText then
                local prefix = LastHack.success and "[OK]  " or "[FAIL]"
                ImGui.Text("Last: " .. prefix .. " " .. (LastHack.actionName or "?"))
                ImGui.Text("  Class:  " .. tostring(LastHack.actionClass or "?"))
                ImGui.Text("  Strat:  " .. tostring(LastHack.strategy or "?"))
                ImGui.Text("  -> " .. LastHack.resultText)
            else
                ImGui.Text("Last: (none yet)")
            end

            ImGui.Separator()

            -- Available hacks on current device
            if Scan.availActions then
                local devTotal = #Scan.availActions
                ImGui.Text(string.format("Device Hacks (%d available):", devTotal))

                local shown = math.min(devTotal, Config.maxDisplayHacks)
                for i = 1, shown do
                    local a = Scan.availActions[i]
                    local reg = ActionRegistry[a.class]
                    local att = reg and reg.attempts or 0
                    local mark = att > 0 and "*" or " "
                    local label = string.format(" %s %-30s [%d]", mark, a.name, att)
                    ImGui.Text(label)
                end
                if devTotal > shown then
                    ImGui.Text(string.format("  ... +%d more not shown", devTotal - shown))
                end
            else
                ImGui.Text("No quickhack actions on this device")
            end

            ImGui.Separator()

            -- Global action type list
            if total > 0 then
                ImGui.Text(string.format("All Known Action Types (%d):", total))
                local shown = math.min(total, Config.maxDisplayHacks)
                for i = 1, shown do
                    local className = ActionOrder[i]
                    local entry = ActionRegistry[className]
                    local mark = entry.attempts > 0 and "*" or " "
                    local label = string.format(" %s %-30s [%d]", mark, entry.name, entry.attempts)
                    ImGui.Text(label)
                end
                if total > shown then
                    ImGui.Text(string.format("  ... +%d more not shown", total - shown))
                end
            end

            ImGui.Separator()
            ImGui.Text("* = tried at least once")
            ImGui.Text("Press APPLY hotkey for random hack")
        end
    end
    ImGui.End()
end)

registerForEvent("onShutdown", function()
    dprint("=== Final Action Statistics ===")
    for _, className in ipairs(ActionOrder) do
        local e = ActionRegistry[className]
        dprint(string.format("  %-30s (class: %s, record: %s): %d attempts",
            e.name, e.class, e.recordID or "", e.attempts))
    end

    local total, tried, untried, pct = GetCoverageStats()
    dprint(string.format("-- Coverage: %d/%d tried (%.0f%%) --", tried, total, pct))
    dprint(string.format("-- Device types encountered: %d --", #reportedDeviceTypes))
    for className, _ in pairs(reportedDeviceTypes) do
        dprint(string.format("    %s", className))
    end
    dprint("=== End Statistics ===")
    dprint("Status Effect Device Tester 1 shut down")
end)
