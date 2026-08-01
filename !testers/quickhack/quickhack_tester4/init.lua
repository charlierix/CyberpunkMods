--[[
  Quickhack Tester 4 - CET (Lua)
  Applies quickhacks to the device you're looking at — no RAM cost, no XP gain.

  Based on tester3 with all 6 next-step recommendations from log_summary.md:
    1. Investigate StartAction failure cause — uses xpcall with error handler to capture real errors
    2. Try calling device controller directly — via DeviceSystem:GetDeviceById
    3. Try QueuePSDeviceEvent manually — calls PS On* event handlers directly
    4. Check if actions need activation — tries ResolveAction/IsPossible/SetObjectActionID before StartAction
    5. Research how base game executes quickhacks — tries GetQuickHackActionsExternal discovery path
    6. Fix CNameToString — multiple fallback approaches

  New hotkeys vs tester3:
    Apply Quickhack   — tries full execution chain with xpcall error capture
    Cycle Hack        — rotate through device's available quickhacks
    List Available    — print all quickhacks available on current target
    Clear Cache       — force-clear the action cache
    Debug Action      — dump action properties, flags, and state for diagnosis
    Execute via PS    — bypass action object, call PS On* handler directly

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/quickhack_tester4/

  Bind hotkeys in: Settings > Key Bindings > QHTester4
--]]

local ModName = "QHTester4"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    debug            = true,   -- print debug info to CET console
    maxDistance      = 20.0,   -- max targeting distance in meters
    selectedIndex    = 1,      -- which available hack to use (cycled by hotkey)
    executionMode    = "full", -- "full" = try all methods, "ps" = direct PS only
}

-- Cache of the last target's available actions
local CachedTarget = {
    entity = nil,
    className = "",
    actions = {},
}

--============================================================================
-- HELPERS
--============================================================================

local function dprint(msg)
    if Config.debug then
        print(string.format("[%s] %s", ModName, msg))
    end
end

--- Extract readable name from a CName's tostring.
--- Fix #6: Multiple fallback approaches since tostring(cname) may return userdata.
local function CNameToString(cname)
    if not cname then return "<nil>" end

    -- Approach 1: Try tostring and regex extract from --[[ Name --]]
    local s = tostring(cname)
    if type(s) == "string" then
        local name = s:match("%-%-%[%[(.-)%]%]%-%-")
        if name and name ~= "" then
            return name
        end
        -- If the tostring is short and doesn't look like ToCName{...}, return it
        if not s:match("^ToCName") and #s < 64 then
            return s
        end
    end

    -- Approach 2: Try string.format with %s which may invoke __tostring differently
    local fmt = nil
    pcall(function() fmt = string.format("%s", cname) end)
    if fmt and type(fmt) == "string" then
        local name = fmt:match("%-%-%[%[(.-)%]%]%-%-")
        if name and name ~= "" then
            return name
        end
        if not fmt:match("^ToCName") and #fmt < 64 then
            return fmt
        end
    end

    -- Approach 3: Try concatenation which may also invoke metamethods
    local concat = nil
    pcall(function() concat = "" .. cname end)
    if concat and type(concat) == "string" then
        local name = concat:match("%-%-%[%[(.-)%]%]%-%-")
        if name and name ~= "" then
            return name
        end
        if not concat:match("^ToCName") and #concat < 64 then
            return concat
        end
    end

    -- Approach 4: Try Game.GetCNameHash or CName.id lookup if available
    local hashStr = nil
    pcall(function()
        -- Some CET versions expose CName as a table with hash fields
        if type(cname) == "table" then
            if cname.hash_lo and cname.hash_hi then
                hashStr = string.format("CName(0x%08X%08X)", cname.hash_hi or 0, cname.hash_lo or 0)
            end
        end
    end)
    if hashStr then return hashStr end

    -- Fallback: return whatever tostring gave us
    return s or "<unknown>"
end

--- Error handler for xpcall — captures full error info including stack trace
local function ErrorHandler(err)
    local info = debug.getinfo(2, "Sl")
    local loc = ""
    if info and info.short_src then
        loc = string.format(" at %s:%d", info.short_src, info.currentline or 0)
    end
    return string.format("%s%s", tostring(err), loc)
end

--- Safe call with error capture (xpcall wrapper)
--- Returns: ok (bool), result or error_string
local function SafeCall(fn, ...)
    local results = table.pack(xpcall(fn, ErrorHandler, ...))
    local ok = results[1]
    if ok then
        return true, table.unpack(results, 2, results.n)
    else
        return false, results[2]
    end
end

--- Get the quickhackable device under the crosshair
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
        dprint("No quickhackable target under crosshair")
        return nil, nil
    end

    local ps = nil
    pcall(function() ps = target:GetDevicePS() end)
    if not ps then
        dprint("Target has no DevicePS (not a device)")
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

--- Get quickhack actions from device PS
--- Recommendation #5: Also try GetQuickHackActionsExternal
--- Tries multiple calling conventions:
---   1. Return value: ps:GetQuickHackActions(context) — WORKS in CET (proven by tester1/3)
---   2. Return value: ps:GetQuickHackActionsExternal(context) — new discovery path
---   3. Out-array: ps:GetQuickHackActions(outArray, context) — fails in CET but try anyway
---   4. Return value: ps:GetActions(context) — broader, filter to quickhacks
--- Returns: array of DeviceAction objects, or nil on failure
local function GetQuickHackActions(ps, context)
    -- Convention 1: ps:GetQuickHackActions(context) returns array (proven working)
    local ok1, result1 = SafeCall(function()
        return ps:GetQuickHackActions(context)
    end)
    if ok1 and result1 and type(result1) == "table" and #result1 > 0 then
        dprint(string.format("  GetQuickHackActions(ctx) returned %d actions (return-value convention)", #result1))
        return result1
    end
    if not ok1 then
        dprint(string.format("  GetQuickHackActions(ctx) error: %s", tostring(result1)))
    end

    -- Convention 2: ps:GetQuickHackActionsExternal(context) — recommendation #5
    local ok2, result2 = SafeCall(function()
        return ps:GetQuickHackActionsExternal(context)
    end)
    if ok2 and result2 and type(result2) == "table" and #result2 > 0 then
        dprint(string.format("  GetQuickHackActionsExternal(ctx) returned %d actions", #result2))
        return result2
    end
    if not ok2 then
        dprint(string.format("  GetQuickHackActionsExternal(ctx) error: %s", tostring(result2)))
    end

    -- Convention 3: ps:GetQuickHackActions(outArray, context) — out-array (fails in CET)
    local outArr = {}
    local ok3 = pcall(function()
        ps:GetQuickHackActions(outArr, context)
    end)
    if ok3 and #outArr > 0 then
        dprint(string.format("  GetQuickHackActions(arr, ctx) returned %d actions (out-array)", #outArr))
        return outArr
    end

    -- Convention 4: ps:GetActions(context) returns array (broader, includes quickhacks)
    local ok4, result4 = SafeCall(function()
        return ps:GetActions(context)
    end)
    if ok4 and result4 and type(result4) == "table" and #result4 > 0 then
        dprint(string.format("  GetActions(ctx) returned %d total actions — filtering for quickhacks", #result4))
        local qhActions = {}
        for _, action in ipairs(result4) do
            if IsQuickHackAction(action) then
                table.insert(qhActions, action)
            end
        end
        if #qhActions > 0 then
            dprint(string.format("  Filtered to %d quickhack actions", #qhActions))
            return qhActions
        end
        dprint(string.format("  No quickhack-filtered actions, returning all %d actions", #result4))
        return result4
    end

    dprint("  Could not retrieve quickhack actions from device PS (tried 4 conventions)")
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

--- Get the TweakDB record ID of an action (for debugging)
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

--- Map an action's class name to the corresponding PS On* handler method name
--- This is used for recommendation #3: calling PS event handlers directly
local function GetPSHandlerName(actionClassName)
    -- Based on ScriptableDeviceComponentPS methods from okf docs:
    --   OnQuickHackDistraction, OnQuickHackAuthorization, OnQuickHackToggleOn,
    --   OnQuestRemoveQuickHacks, OnQuestRestoreQuickHacks, OnSetExposeQuickHacks
    -- Plus action class names from baseDeviceActions.swift
    local mapping = {
        ["QuickHackDistraction"]       = "OnQuickHackDistraction",
        ["MalfunctionClassHack"]       = "OnQuickHackDistraction",
        ["QuickHackAuthorization"]     = "OnQuickHackAuthorization",
        ["QuickHackToggleON"]          = "OnQuickHackToggleOn",
        ["GlitchScreen"]               = "OnQuickHackDistraction", -- closest match
        ["GlitchScreenSuicide"]        = "OnQuickHackDistraction",
        ["GlitchScreenBlind"]          = "OnQuickHackDistraction",
        ["GlitchScreenGrenade"]        = "OnQuickHackDistraction",
    }
    if mapping[actionClassName] then
        return mapping[actionClassName]
    end
    -- Try generic pattern: QuickHackFoo -> OnQuickHackFoo
    local prefix = actionClassName:match("^(QuickHack.+)$")
    if prefix then
        return "On" .. prefix
    end
    return nil
end

--- Get or refresh the cached available actions for a target
--- Returns: array of actions, or nil
local function GetCachedActions(target, ps)
    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)

    if CachedTarget.entity == target and #CachedTarget.actions > 0 then
        dprint(string.format("Cache hit for %s (%d actions)", targetClass, #CachedTarget.actions))
        return CachedTarget.actions
    end

    local player = Game.GetPlayer()
    if not player then return nil end

    local context = MakeContext(player)
    if not context then return nil end

    dprint(string.format("Querying %s for quickhack actions...", targetClass))
    local actions = GetQuickHackActions(ps, context)
    if not actions or #actions == 0 then
        dprint(string.format("No quickhack actions available for %s", targetClass))
        return nil
    end

    CachedTarget.entity = target
    CachedTarget.className = targetClass
    CachedTarget.actions = actions

    if Config.selectedIndex > #actions then
        Config.selectedIndex = 1
    end

    dprint(string.format("Cached %d quickhack actions for %s", #actions, targetClass))
    return actions
end

--============================================================================
-- EXECUTION STRATEGY A: Full chain with xpcall error capture
-- Recommendation #1: capture real StartAction error messages
-- Recommendation #4: try SetObjectActionID, ResolveAction, IsPossible before StartAction
--============================================================================

local function SetupAction(action, player, game)
    -- Set executor and requester
    local ok1, err1 = SafeCall(function() action:SetExecutor(player) end)
    if not ok1 then dprint(string.format("  SetExecutor error: %s", tostring(err1))) end

    local ok2, err2 = SafeCall(function() action:SetRequesterID(player:GetEntityID()) end)
    if not ok2 then dprint(string.format("  SetRequesterID error: %s", tostring(err2))) end

    -- Skip pay cost (no RAM)
    local ok3, err3 = SafeCall(function() action:SetCanSkipPayCost(true) end)
    if not ok3 then dprint(string.format("  SetCanSkipPayCost error: %s", tostring(err3))) end

    -- Recommendation #4: Set ObjectActionID from the record
    -- Root cause #1 was missing ObjectActionID — set it from the TweakDB record
    local ok4, err4 = SafeCall(function()
        local rec = action:GetObjectActionRecord()
        if rec then
            local recID = rec:GetID()
            if recID then
                action:SetObjectActionID(recID)
                dprint(string.format("  SetObjectActionID OK: %s", CNameToString(recID)))
            end
        end
    end)
    if not ok4 then dprint(string.format("  SetObjectActionID error: %s", tostring(err4))) end
end

local function ApplyQuickHackFull(action, player, game, label, class)
    -- Step 1: Setup action with all properties
    dprint("  Setting up action properties...")
    SetupAction(action, player, game)

    -- Step 2: Check if action is possible (recommendation #4)
    local isPossible = nil
    local okP, errP = SafeCall(function() isPossible = action:IsPossible(game) end)
    if okP then
        dprint(string.format("  IsPossible: %s", tostring(isPossible)))
    else
        dprint(string.format("  IsPossible error: %s", tostring(errP)))
    end

    -- Step 3: Try ResolveAction (recommendation #4 — may be needed before StartAction)
    local okR, errR = SafeCall(function() action:ResolveAction(game) end)
    if okR then
        dprint("  ResolveAction OK")
    else
        dprint(string.format("  ResolveAction error: %s", tostring(errR)))
    end

    -- Step 4: StartAction with xpcall to capture REAL error (recommendation #1)
    dprint("  Attempting StartAction...")
    local startOk, startErr = SafeCall(function()
        action:StartAction(game)
    end)

    if startOk then
        dprint("  StartAction OK — hack should be applying")
        return true
    else
        -- Recommendation #1: print the ACTUAL error message
        dprint(string.format("  StartAction FAILED: %s", tostring(startErr)))

        -- Fallback 1: ProcessRPGAction (will cost RAM but might work)
        dprint("  Trying ProcessRPGAction fallback...")
        local rpgOk, rpgErr = SafeCall(function()
            action:ProcessRPGAction(game)
        end)
        if rpgOk then
            dprint("  ProcessRPGAction OK (may have used RAM)")
            return true
        else
            dprint(string.format("  ProcessRPGAction FAILED: %s", tostring(rpgErr)))

            -- Fallback 2: CompleteAction alone
            dprint("  Trying CompleteAction fallback...")
            local completeOk, completeErr = SafeCall(function()
                action:CompleteAction(game)
            end)
            if completeOk then
                dprint("  CompleteAction OK")
                return true
            else
                dprint(string.format("  CompleteAction FAILED: %s", tostring(completeErr)))
                return false
            end
        end
    end
end

--============================================================================
-- EXECUTION STRATEGY B: Direct PS event handler call
-- Recommendation #3: Call PS On* handlers directly (bypass action object entirely)
--============================================================================

local function ApplyQuickHackViaPS(action, ps, player, game, label, class)
    local handlerName = GetPSHandlerName(class)
    if not handlerName then
        dprint(string.format("  No PS handler mapped for class: %s", class))
        dprint("  Available mappings: QuickHackDistraction, QuickHackAuthorization, QuickHackToggleON, GlitchScreen*")
        return false
    end

    dprint(string.format("  Attempting direct PS call: ps:%s(action)", handlerName))

    -- Try calling the PS handler directly with the action object
    local ok1, err1 = SafeCall(function()
        ps[handlerName](ps, action)
    end)
    if ok1 then
        dprint(string.format("  PS %s OK", handlerName))
        return true
    else
        dprint(string.format("  PS %s FAILED (with action): %s", handlerName, tostring(err1)))
    end

    -- Try without arguments (some handlers may take no args)
    local ok2, err2 = SafeCall(function()
        ps[handlerName](ps)
    end)
    if ok2 then
        dprint(string.format("  PS %s OK (no args)", handlerName))
        return true
    else
        dprint(string.format("  PS %s FAILED (no args): %s", handlerName, tostring(err2)))
    end

    -- Try QueuePSDeviceEvent directly if the method exists
    dprint("  Trying QueuePSDeviceEvent directly...")
    local ok3, err3 = SafeCall(function()
        ps:QueuePSDeviceEvent(action)
    end)
    if ok3 then
        dprint("  QueuePSDeviceEvent OK")
        return true
    else
        dprint(string.format("  QueuePSDeviceEvent FAILED: %s", tostring(err3)))
    end

    return false
end

--============================================================================
-- EXECUTION STRATEGY C: DeviceSystem direct access
-- Recommendation #2: Try DeviceSystem:GetDeviceById and call device methods directly
--============================================================================

local function ApplyQuickHackViaDeviceSystem(target, player, game, action, label, class)
    dprint("  Trying DeviceSystem direct access...")

    -- Get the entity ID of the target
    local entityID = nil
    pcall(function() entityID = target:GetEntityID() end)
    if not entityID then
        dprint("  Could not get target EntityID")
        return false
    end

    -- Try Game.GetDeviceSystem():GetDeviceById(game, entityID)
    local deviceSystem = nil
    pcall(function() deviceSystem = Game.GetDeviceSystem() end)
    if not deviceSystem then
        dprint("  Could not get DeviceSystem")
        return false
    end

    local device = nil
    local ok1, err1 = SafeCall(function()
        device = deviceSystem:GetDeviceById(game, entityID)
    end)
    if not ok1 or not device then
        dprint(string.format("  GetDeviceById FAILED: %s", tostring(err1)))
        return false
    end
    dprint("  GetDeviceById OK — got device controller")

    -- Try calling device methods directly
    -- The device controller may have methods like ExecuteAction, Toggle, etc.
    local ok2, err2 = SafeCall(function()
        device:ExecuteAction(action)
    end)
    if ok2 then
        dprint("  device:ExecuteAction OK")
        return true
    else
        dprint(string.format("  device:ExecuteAction FAILED: %s", tostring(err2)))
    end

    -- Try ProcessAction on the device
    local ok3, err3 = SafeCall(function()
        device:ProcessAction(action)
    end)
    if ok3 then
        dprint("  device:ProcessAction OK")
        return true
    else
        dprint(string.format("  device:ProcessAction FAILED: %s", tostring(err3)))
    end

    return false
end

--============================================================================
-- MAIN APPLY FUNCTION
--============================================================================

local function ApplyQuickHack()
    local player = Game.GetPlayer()
    if not player then
        dprint("No player found")
        return
    end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        dprint("No hackable device targeted")
        return
    end

    local targetClassName = ""
    pcall(function() targetClassName = CNameToString(target:GetClassName()) end)
    dprint(string.format("Target device: %s", targetClassName))

    local game = nil
    pcall(function() game = player:GetGame() end)
    if not game then
        dprint("Could not get GameInstance")
        return
    end

    local actions = GetCachedActions(target, ps)
    if not actions or #actions == 0 then
        dprint("No quickhack actions available for this device")
        return
    end

    dprint(string.format("Found %d quickhack actions:", #actions))
    for i, action in ipairs(actions) do
        local marker = (i == Config.selectedIndex) and " *" or "  "
        local label = GetActionLabel(action)
        local class = GetActionClassName(action)
        local recID = GetActionRecordID(action)
        if recID ~= "" then
            dprint(string.format("%s[%d] %s (class: %s, record: %s)", marker, i, label, class, recID))
        else
            dprint(string.format("%s[%d] %s (class: %s)", marker, i, label, class))
        end
    end

    local idx = Config.selectedIndex
    if idx < 1 or idx > #actions then
        idx = 1
        Config.selectedIndex = 1
    end

    local targetAction = actions[idx]
    if not targetAction then
        dprint("No suitable action found")
        return
    end

    local actionLabel = GetActionLabel(targetAction)
    local actionClass = GetActionClassName(targetAction)
    dprint(string.format("Selected: [%d] %s (class: %s)", idx, actionLabel, actionClass))

    -- === EXECUTION CHAIN ===
    -- Strategy A: Full action chain with xpcall error capture
    dprint("--- Strategy A: Full action chain ---")
    local success = ApplyQuickHackFull(targetAction, player, game, actionLabel, actionClass)

    if not success then
        -- Strategy B: Direct PS event handler
        dprint("--- Strategy B: Direct PS handler ---")
        success = ApplyQuickHackViaPS(targetAction, ps, player, game, actionLabel, actionClass)
    end

    if not success then
        -- Strategy C: DeviceSystem direct access
        dprint("--- Strategy C: DeviceSystem direct ---")
        success = ApplyQuickHackViaDeviceSystem(target, player, game, targetAction, actionLabel, actionClass)
    end

    if success then
        dprint(string.format("Quickhack applied: %s", actionLabel))
    else
        dprint(string.format("All strategies failed for: %s", actionLabel))
    end
end

--============================================================================
-- EXECUTE VIA PS ONLY (dedicated hotkey)
-- Bypasses action object entirely, goes straight to PS handlers
--============================================================================

local function ExecuteViaPS()
    local player = Game.GetPlayer()
    if not player then return end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        dprint("No hackable device targeted")
        return
    end

    local game = nil
    pcall(function() game = player:GetGame() end)

    local actions = GetCachedActions(target, ps)
    if not actions or #actions == 0 then
        dprint("No quickhack actions available")
        return
    end

    local idx = Config.selectedIndex
    if idx < 1 or idx > #actions then idx = 1; Config.selectedIndex = 1 end

    local action = actions[idx]
    local label = GetActionLabel(action)
    local class = GetActionClassName(action)
    dprint(string.format("PS Execute: [%d] %s (class: %s)", idx, label, class))

    -- Setup action first (executor, skip cost, etc.)
    if game then
        SetupAction(action, player, game)
    end

    local success = ApplyQuickHackViaPS(action, ps, player, game, label, class)

    if not success and game then
        -- Also try DeviceSystem as fallback
        dprint("--- PS failed, trying DeviceSystem ---")
        success = ApplyQuickHackViaDeviceSystem(target, player, game, action, label, class)
    end

    if success then
        dprint(string.format("PS execution succeeded: %s", label))
    else
        dprint(string.format("PS execution failed: %s", label))
    end
end

--============================================================================
-- GET REPORT — combined list + debug all + compact summary
--============================================================================

local function GetReport()
    local player = Game.GetPlayer()
    if not player then return end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        print(string.format("[%s] No hackable device targeted", ModName))
        return
    end

    local targetClassName = ""
    pcall(function() targetClassName = CNameToString(target:GetClassName()) end)
    print(string.format("[%s] === GET REPORT — Target: %s ===", ModName, targetClassName))

    -- Force refresh cache
    CachedTarget.entity = nil
    CachedTarget.actions = {}

    local actions = GetCachedActions(target, ps)
    if not actions or #actions == 0 then
        print(string.format("[%s] No quickhack actions available", ModName))
        return
    end

    local game = nil
    pcall(function() game = player:GetGame() end)

    local summaryNames = {}

    for idx, action in ipairs(actions) do
        local label = GetActionLabel(action)
        local class = GetActionClassName(action)
        local recID = GetActionRecordID(action)
        local handler = GetPSHandlerName(class)

        table.insert(summaryNames, label)

        print(string.format("[%s] --- Action [%d/%d] ---", ModName, idx, #actions))
        print(string.format("  Label:   %s", label))
        print(string.format("  Class:   %s", class))
        if recID ~= "" then
            print(string.format("  Record:  %s", recID))
        end
        if handler then
            print(string.format("  PS Handler: %s", handler))
        end

        local function dumpProp(propName, fn)
            local ok, val = SafeCall(fn)
            if ok then
                print(string.format("  %s: %s", propName, tostring(val)))
            else
                print(string.format("  %s: ERROR: %s", propName, tostring(val)))
            end
        end

        if game then
            dumpProp("IsPossible", function() return action:IsPossible(game) end)
        end
        dumpProp("CanInterrupt",      function() return action:CanInterrupt() end)
        dumpProp("IsVisible",         function() return action:IsVisible() end)
        dumpProp("GetActivationTime",  function() return action:GetActivationTime() end)
        dumpProp("GetDurationTime",   function() return action:GetDurationTime() end)
        dumpProp("GetCost",           function() return action:GetCost() end)
        dumpProp("GetBaseCost",       function() return action:GetBaseCost() end)

        local okRec, rec = SafeCall(function() return action:GetObjectActionRecord() end)
        if okRec and rec then
            print(string.format("  ObjectActionRecord: defined=%s", tostring(IsDefined(rec))))
            dumpProp("  Record:GetID", function() return CNameToString(rec:GetID()) end)
            dumpProp("  Record:HackCategory.Type", function()
                local cat = rec:HackCategory()
                if cat then return tostring(cat:Type()) end
                return nil
            end)
        else
            print(string.format("  ObjectActionRecord: ERROR: %s", tostring(rec)))
        end

        local okEID, eid = SafeCall(function() return target:GetEntityID() end)
        print(string.format("  Target EntityID: %s", tostring(eid)))
    end

    -- === COMPACT SUMMARY ===
    print(string.format("[%s] ============================================", ModName))
    print(string.format("[%s] REPORT SUMMARY: %d hacks on %s:", ModName, #actions, targetClassName))
    for idx, name in ipairs(summaryNames) do
        print(string.format("[%s]   [%d] %s", ModName, idx, name))
    end
    print(string.format("[%s] ============================================", ModName))
end

--============================================================================
-- CYCLE HACK TYPE
--============================================================================

local function CycleHack()
    local player = Game.GetPlayer()
    if not player then return end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        print(string.format("[%s] No hackable device targeted", ModName))
        return
    end

    local actions = GetCachedActions(target, ps)
    if not actions or #actions == 0 then
        print(string.format("[%s] No quickhack actions available on this device", ModName))
        return
    end

    Config.selectedIndex = (Config.selectedIndex % #actions) + 1
    local action = actions[Config.selectedIndex]
    local label = GetActionLabel(action)
    local class = GetActionClassName(action)
    print(string.format("[%s] Hack: %s (%d/%d) [class: %s]", ModName, label, Config.selectedIndex, #actions, class))
end

--============================================================================
-- CLEAR CACHE
--============================================================================

local function ClearCache()
    CachedTarget.entity = nil
    CachedTarget.className = ""
    CachedTarget.actions = {}
    Config.selectedIndex = 1
    print(string.format("[%s] Cache cleared", ModName))
end

--============================================================================
-- HOTKEYS (must be at root level per CET hotkey discovery rules)
--============================================================================

registerHotkey("QHT4_Report", "Get Report", function()
    GetReport()
end)

registerHotkey("QHT4_Apply", "Apply Quickhack", function()
    ApplyQuickHack()
end)

registerHotkey("QHT4_PsExec", "Execute via PS", function()
    ExecuteViaPS()
end)

registerHotkey("QHT4_Clear", "Clear Cache", function()
    ClearCache()
end)

registerHotkey("QHT4_Cycle", "Cycle Hack", function()
    CycleHack()
end)

--============================================================================
-- INIT
--============================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized | debug: %s | maxDistance: %.1f",
        ModName, tostring(Config.debug), Config.maxDistance))
    print(string.format("[%s] Bind keys in: Settings > Key Bindings > %s", ModName, ModName))
    print(string.format("[%s] Hotkeys: Apply Quickhack, Cycle Hack, Clear Cache, Execute via PS, Get Report", ModName))
    print(string.format("[%s] New in v4: xpcall error capture, SetObjectActionID, PS handler bypass, DeviceSystem direct, Get Report", ModName))
end)
