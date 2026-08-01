--[[
  Quickhack Tester 2 - CET (Lua)
  Applies quickhacks to the device you're looking at — no RAM cost, no XP gain.

  Improvements over v1:
    - Cycles through the device's ACTUAL available quickhacks, not a hardcoded list
    - Uses SetCanSkipPayCost(true) + StartAction for proper no-RAM execution
    - StartAction auto-calls CompleteAction for quickhacks when canSkipPayCost is true
    - CompleteAction queues QueuePSDeviceEvent which triggers the real device effect
    - Removes broken PS handler direct-call attempt

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/quickhack_tester2/

  Bind hotkeys in: Settings > Key Bindings > QHTester2

  Hotkeys:
    Apply Quickhack  — applies the selected hack to the device under crosshair
    Cycle Hack       — rotate through the device's available quickhacks
    List Available   — print all quickhacks available on the current target (debug)
--]]

local ModName = "QHTester2"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    debug            = true,   -- print debug info to CET console
    maxDistance      = 20.0,   -- max targeting distance in meters
    selectedIndex    = 1,      -- which available hack to use (cycled by hotkey)
}

-- Cache of the last target's available actions
-- so Cycle Hack doesn't need to re-query the device each time
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

--- Get quickhack actions from device PS
--- Returns: array of DeviceAction objects, or nil on failure
local function GetQuickHackActions(ps, context)
    local actions = {}

    -- Convention: ps:GetQuickHackActions(outArray, context) fills out array
    local ok = pcall(function()
        ps:GetQuickHackActions(actions, context)
    end)

    if ok and #actions > 0 then
        return actions
    end

    -- Fallback: try GetActions (broader, includes quickhacks)
    local allActions = {}
    ok = pcall(function()
        ps:GetActions(allActions, context)
    end)

    if ok and #allActions > 0 then
        -- Filter to only quickhack actions
        for _, action in ipairs(allActions) do
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
            if isQH then
                table.insert(actions, action)
            end
        end
        if #actions > 0 then
            return actions
        end
    end

    dprint("  Could not retrieve quickhack actions from device PS")
    return nil
end

--- Get a human-readable name for an action
local function GetActionLabel(action)
    local label = ""
    pcall(function() label = action:GetActionName() or "" end)
    if label == "" or label == "None" then
        pcall(function()
            local rec = action:GetObjectActionRecord()
            if rec then
                local id = tostring(rec:GetID())
                if id and id ~= "" then label = id end
            end
        end)
    end
    if label == "" then
        pcall(function() label = action:GetClassName() or "" end)
    end
    if label == "" then
        label = "<unknown>"
    end
    return tostring(label)
end

--- Get the class name of an action
local function GetActionClassName(action)
    local name = ""
    pcall(function() name = action:GetClassName() or "" end)
    if name == "" then
        pcall(function()
            local rec = action:GetObjectActionRecord()
            if rec then name = tostring(rec:GetID()) or "" end
        end)
    end
    return tostring(name)
end

--- Get or refresh the cached available actions for a target
--- Returns: array of actions, or nil
local function GetCachedActions(target, ps)
    local targetClass = ""
    pcall(function() targetClass = target:GetClassName() or "unknown" end)

    -- Check if we already have cached actions for this exact target
    if CachedTarget.entity == target and #CachedTarget.actions > 0 then
        return CachedTarget.actions
    end

    local player = Game.GetPlayer()
    if not player then return nil end

    local context = MakeContext(player)
    if not context then return nil end

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
---   4. No ProcessRPGAction is called, so no XP is awarded
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
    pcall(function() targetClassName = target:GetClassName() or "unknown" end)
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
        dprint(string.format("%s[%d] %s (class: %s)", marker, i, GetActionLabel(action), GetActionClassName(action)))
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

    -- KEY FIX: Set canSkipPayCost = true so PayCost is skipped (no RAM)
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
        dprint(string.format("  StartAction OK — hack should be applying"))
    else
        dprint(string.format("  StartAction failed — trying ProcessRPGAction fallback"))

        -- Fallback: try ProcessRPGAction (this will cost RAM but should work)
        local rpgOk = pcall(function()
            targetAction:ProcessRPGAction(game)
        end)
        if rpgOk then
            dprint("  ProcessRPGAction OK (may have used RAM)")
        else
            dprint("  ProcessRPGAction also failed — hack may not have applied")
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
    print(string.format("[%s] Hack: %s (%d/%d)", ModName, label, Config.selectedIndex, #actions))
end

--============================================================================
-- LIST AVAILABLE HACKS (debug helper)
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
    pcall(function() targetClassName = target:GetClassName() or "unknown" end)
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
        local marker = (i == Config.selectedIndex) and " <-" or ""
        print(string.format("  [%d] %s (class: %s)%s", i, label, class, marker))
    end
end

--============================================================================
-- HOTKEYS (must be at root level per CET hotkey discovery rules)
--============================================================================

registerHotkey("QHT2_Apply", "Apply Quickhack", function()
    ApplyQuickHack()
end)

registerHotkey("QHT2_Cycle", "Cycle Hack", function()
    CycleHack()
end)

registerHotkey("QHT2_List", "List Available Hacks", function()
    ListAvailableHacks()
end)

--============================================================================
-- INIT
--============================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized | debug: %s | maxDistance: %.1f",
        ModName, tostring(Config.debug), Config.maxDistance))
    print(string.format("[%s] Bind keys in: Settings > Key Bindings > %s", ModName, ModName))
    print(string.format("[%s] Hotkeys: Apply Quickhack, Cycle Hack, List Available Hacks", ModName))
    print(string.format("[%s] Cycle Hack now rotates through the DEVICE's available quickhacks", ModName))
end)
