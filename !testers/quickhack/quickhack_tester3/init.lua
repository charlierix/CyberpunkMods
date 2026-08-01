--[[
  Quickhack Tester 3 - CET (Lua)
  Applies quickhacks to the device you're looking at — no RAM cost, no XP gain.

  Combines the best of v1 and v2:
    - v1's working action discovery (return-value convention that actually finds hacks)
    - v2's improved execution (SetCanSkipPayCost + StartAction)
    - v2's caching and index-based cycling through device's actual available hacks
    - Cleaner CName display, richer debug output, more execution fallbacks

  Fixes from v2 carried forward:
    - Cycles through device's ACTUAL available quickhacks, not a hardcoded list
    - Uses SetCanSkipPayCost(true) + StartAction for proper no-RAM execution
    - StartAction auto-calls CompleteAction for quickhacks when canSkipPayCost is true
    - Action caching per target entity so Cycle Hack doesn't re-query each time

  Fix for v2's empty list bug:
    - v2 only used out-array convention ps:GetQuickHackActions(arr, ctx) which fails in CET
    - v3 restores v1's working return-value convention ps:GetQuickHackActions(ctx)
    - v3 tries BOTH conventions + GetActions fallback with quickhack filtering

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/quickhack_tester3/

  Bind hotkeys in: Settings > Key Bindings > QHTester3

  Hotkeys:
    Apply Quickhack  — applies the selected hack to the device under crosshair
    Cycle Hack       — rotate through the device's available quickhacks
    List Available   — print all quickhacks available on the current target
    Clear Cache      — force-clear the action cache (use if switching targets)
--]]

local ModName = "QHTester3"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    debug            = true,   -- print debug info to CET console
    maxDistance      = 20.0,   -- max targeting distance in meters
    selectedIndex    = 1,      -- which available hack to use (cycled by hotkey)
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

--- Extract readable name from a CName's tostring (which looks like:
--- ToCName{ hash_lo = 0x..., hash_hi = 0x... --[[ ActualName --]] })
local function CNameToString(cname)
    if not cname then return "<nil>" end
    local s = tostring(cname)
    -- Try to extract the name from --[[ ... --]]
    local name = s:match("%-%-%[%[(.-)%]%]%-%-")
    if name and name ~= "" then
        return name
    end
    -- If no name embedded, return the whole tostring
    return s
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
--- With ignoresRPG and ignoresAuthorization to bypass requirements
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
            -- Check HackCategory
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
    -- Also check by action class name if HackCategory didn't work
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
--- Tries multiple calling conventions:
---   1. Return value: ps:GetQuickHackActions(context) — WORKS in CET (proven by v1 logs)
---   2. Out-array: ps:GetQuickHackActions(outArray, context) — v2's approach (fails in CET)
---   3. Return value: ps:GetActions(context) — broader, filter to quickhacks
---   4. Out-array: ps:GetActions(outArray, context) — v2's fallback (also fails)
--- Returns: array of DeviceAction objects, or nil on failure
local function GetQuickHackActions(ps, context)
    -- Convention 1: ps:GetQuickHackActions(context) returns array
    -- This is the convention that WORKED in tester1
    local ok1, result1 = pcall(function()
        return ps:GetQuickHackActions(context)
    end)

    if ok1 and result1 and type(result1) == "table" and #result1 > 0 then
        dprint(string.format("  GetQuickHackActions(ctx) returned %d actions (return-value convention)", #result1))
        return result1
    end

    -- Convention 2: ps:GetQuickHackActions(outArray, context) fills out array
    -- This was v2's approach — fails in CET but try anyway for completeness
    local outArr = {}
    local ok2 = pcall(function()
        ps:GetQuickHackActions(outArr, context)
    end)
    if ok2 and #outArr > 0 then
        dprint(string.format("  GetQuickHackActions(arr, ctx) returned %d actions (out-array convention)", #outArr))
        return outArr
    end

    -- Convention 3: ps:GetActions(context) returns array (broader, includes quickhacks)
    local ok3, result3 = pcall(function()
        return ps:GetActions(context)
    end)
    if ok3 and result3 and type(result3) == "table" and #result3 > 0 then
        dprint(string.format("  GetActions(ctx) returned %d total actions — filtering for quickhacks", #result3))
        local qhActions = {}
        for _, action in ipairs(result3) do
            if IsQuickHackAction(action) then
                table.insert(qhActions, action)
            end
        end
        if #qhActions > 0 then
            dprint(string.format("  Filtered to %d quickhack actions", #qhActions))
            return qhActions
        end
        -- If filtering found nothing, return all actions as last resort
        dprint(string.format("  No quickhack-filtered actions, returning all %d actions", #result3))
        return result3
    end

    -- Convention 4: ps:GetActions(outArray, context) fills out array
    local allActions = {}
    local ok4 = pcall(function()
        ps:GetActions(allActions, context)
    end)
    if ok4 and #allActions > 0 then
        dprint(string.format("  GetActions(arr, ctx) returned %d total actions (out-array) — filtering for quickhacks", #allActions))
        local qhActions = {}
        for _, action in ipairs(allActions) do
            if IsQuickHackAction(action) then
                table.insert(qhActions, action)
            end
        end
        if #qhActions > 0 then
            dprint(string.format("  Filtered to %d quickhack actions", #qhActions))
            return qhActions
        end
        dprint(string.format("  No quickhack-filtered actions, returning all %d actions", #allActions))
        return allActions
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
    -- Fall back to ObjectActionRecord ID
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
    -- Fall back to class name
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
    -- Fall back to ObjectActionRecord ID
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
    if id and id ~= "" and tostring(id) ~= "None" then
        return CNameToString(id)
    end
    return ""
end

--- Get or refresh the cached available actions for a target
--- Returns: array of actions, or nil
local function GetCachedActions(target, ps)
    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)

    -- Check if we already have cached actions for this exact target
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

    -- Cache the results
    CachedTarget.entity = target
    CachedTarget.className = targetClass
    CachedTarget.actions = actions

    -- Clamp selection index
    if Config.selectedIndex > #actions then
        Config.selectedIndex = 1
    end

    dprint(string.format("Cached %d quickhack actions for %s", #actions, targetClass))
    return actions
end

--============================================================================
-- QUICKHACK EXECUTION
--============================================================================

--- Apply the selected quickhack to the device under the crosshair
--- Execution strategy (no RAM, no XP):
---   1. SetCanSkipPayCost(true) — skips PayCost entirely (no RAM used)
---   2. StartAction(game) — for quickhacks with canSkipPayCost,
---      StartAction auto-calls CompleteAction immediately
---   3. CompleteAction queues QueuePSDeviceEvent(this) which triggers
---      the actual device effect (distraction, toggle, explode, etc.)
---   4. Fallback: ProcessRPGAction (will cost RAM) if StartAction fails
---   5. Fallback: CompleteAction alone if ProcessRPGAction fails
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

    -- Get or refresh cached actions for this target
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

    -- Select the target action by index
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

    -- Set up the action: executor and requester
    pcall(function() targetAction:SetExecutor(player) end)
    pcall(function() targetAction:SetRequesterID(player:GetEntityID()) end)

    -- KEY FIX from v2: Set canSkipPayCost = true so PayCost is skipped (no RAM)
    -- and StartAction auto-calls CompleteAction for quickhacks
    pcall(function() targetAction:SetCanSkipPayCost(true) end)

    -- Execute: StartAction triggers the action
    -- For quickhacks with canSkipPayCost=true, StartAction calls CompleteAction immediately
    -- CompleteAction calls QueuePSDeviceEvent(this) which sends the action
    -- to the device PS, triggering the actual device effect
    local startOk = pcall(function()
        targetAction:StartAction(game)
    end)

    if startOk then
        dprint("  StartAction OK — hack should be applying")
    else
        dprint("  StartAction failed — trying fallbacks")

        -- Fallback 1: try ProcessRPGAction (this will cost RAM but should work)
        local rpgOk = pcall(function()
            targetAction:ProcessRPGAction(game)
        end)
        if rpgOk then
            dprint("  ProcessRPGAction OK (may have used RAM)")
        else
            dprint("  ProcessRPGAction failed — trying CompleteAction")

            -- Fallback 2: try CompleteAction alone
            local completeOk = pcall(function()
                targetAction:CompleteAction(game)
            end)
            if completeOk then
                dprint("  CompleteAction OK (may give small XP)")
            else
                dprint("  CompleteAction also failed — hack may not have applied")
            end
        end
    end

    dprint(string.format("Quickhack applied: %s", actionLabel))
end

--============================================================================
-- CYCLE HACK TYPE
--============================================================================

--- Cycle through the device's available quickhack actions
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
-- LIST AVAILABLE HACKS
--============================================================================

local function ListAvailableHacks()
    local player = Game.GetPlayer()
    if not player then return end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        print(string.format("[%s] No hackable device targeted", ModName))
        return
    end

    local targetClassName = ""
    pcall(function() targetClassName = CNameToString(target:GetClassName()) end)
    print(string.format("[%s] Target: %s", ModName, targetClassName))

    -- Force refresh cache
    CachedTarget.entity = nil
    CachedTarget.actions = {}

    local actions = GetCachedActions(target, ps)
    if not actions or #actions == 0 then
        print(string.format("[%s] No quickhack actions available", ModName))
        return
    end

    print(string.format("[%s] Available quickhacks (%d):", ModName, #actions))
    for i, action in ipairs(actions) do
        local label = GetActionLabel(action)
        local class = GetActionClassName(action)
        local recID = GetActionRecordID(action)
        local marker = (i == Config.selectedIndex) and " <-" or ""
        if recID ~= "" then
            print(string.format("  [%d] %s (class: %s, record: %s)%s", i, label, class, recID, marker))
        else
            print(string.format("  [%d] %s (class: %s)%s", i, label, class, marker))
        end
    end
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

registerHotkey("QHT3_Apply", "Apply Quickhack", function()
    ApplyQuickHack()
end)

registerHotkey("QHT3_Cycle", "Cycle Hack", function()
    CycleHack()
end)

registerHotkey("QHT3_List", "List Available Hacks", function()
    ListAvailableHacks()
end)

registerHotkey("QHT3_Clear", "Clear Cache", function()
    ClearCache()
end)

--============================================================================
-- INIT
--============================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized | debug: %s | maxDistance: %.1f",
        ModName, tostring(Config.debug), Config.maxDistance))
    print(string.format("[%s] Bind keys in: Settings > Key Bindings > %s", ModName, ModName))
    print(string.format("[%s] Hotkeys: Apply Quickhack, Cycle Hack, List Available Hacks, Clear Cache", ModName))
    print(string.format("[%s] Cycles through DEVICE's actual available quickhacks", ModName))
end)
