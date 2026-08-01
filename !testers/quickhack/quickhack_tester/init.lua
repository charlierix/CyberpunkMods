--[[
   Quickhack Tester Mod - CET (Lua)
   Applies quickhacks to the device you're looking at — no RAM cost, no XP gain.

   Install: Copy this folder to:
     bin/x64/plugins/cyber_engine_tweaks/mods/quickhack_tester/

   Bind hotkeys in: Settings > Key Bindings > QHTester

   Hotkeys:
     Apply Quickhack  — applies the selected hack to the device under crosshair
     Cycle Hack Type  — rotate through the predefined hack list
     List Available   — print all quickhacks available on the current target (debug)
]]

local ModName = "QHTester"

--============================================================================
-- CONFIGURATION  (edit these values directly)
--============================================================================
local Config = {
    debug            = true,   -- print debug info to CET console
    currentHack      = 1,      -- index into HackList (cycle with hotkey)
    maxDistance      = 20.0,   -- max targeting distance in meters
    useFirstAvailable = false,  -- if true, always use first available hack (ignore selection)
}

--============================================================================
-- QUICKHACK LIST
--============================================================================
-- Each entry: { action = CET class name, handler = PS handler method, label = display }
--
-- These are the common device quickhack action classes found in the game source.
-- Most hackable devices support Distraction. Explosives support Self-Destruct.
-- Doors support ToggleOpen. Elevators support CallElevator.
-- Not all devices support all hacks — the mod will fall back to the first
-- available hack if the selected one isn't supported.

local HackList = {
    { action = "QuickHackDistraction",       handler = "OnQuickHackDistraction",        label = "Distraction" },
    { action = "QuickHackToggleON",         handler = "OnQuickHackToggleOn",            label = "Toggle On/Off" },
    { action = "QuickHackToggleOpen",       handler = "OnQuickHackToggleOpen",         label = "Toggle Open (Doors)" },
    { action = "QuickHackCallElevator",     handler = "OnQuickHackCallElevator",       label = "Call Elevator" },
    { action = "QuickHackExplodeExplosive",  handler = "OnQuickHackExplodeExplosive",    label = "Self-Destruct (Explosives)" },
    { action = "QuickHackDistractExplosive", handler = "OnQuickHackDistractExplosive",   label = "Distract (Explosives)" },
    { action = "QuickHackAuthorization",    handler = "OnQuickHackAuthorization",      label = "Authorization" },
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

    -- Set targeting filter: Quickhackable objects (devices + NPCs that can be hacked)
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

    -- Get device persistent state
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

    -- Convention 1: ps:GetQuickHackActions(context) returns array
    local ok1, result1 = pcall(function()
        return ps:GetQuickHackActions(context)
    end)

    if ok1 and result1 and type(result1) == "table" and #result1 > 0 then
        return result1
    end

    -- Convention 2: ps:GetQuickHackActions(outArray, context) fills out array
    if ok1 and type(result1) == "table" then
        -- Maybe it returned the filled table differently
        for k, v in pairs(result1) do
            if type(k) == "number" then
                actions[k] = v
            end
        end
        if #actions > 0 then
            return actions
        end
    end

    local outArr = {}
    local ok2 = pcall(function()
        ps:GetQuickHackActions(outArr, context)
    end)
    if ok2 and #outArr > 0 then
        return outArr
    end

    -- Convention 3: Try GetActions instead (broader, includes quickhacks)
    local ok3, result3 = pcall(function()
        return ps:GetActions(context)
    end)
    if ok3 and result3 and type(result3) == "table" and #result3 > 0 then
        dprint("  GetQuickHackActions failed, GetActions returned " .. #result3 .. " actions")
        return result3
    end

    dprint("  Could not retrieve actions from device PS")
    return nil
end

--- Get the class name of an action safely
local function GetActionClassName(action)
    local name = ""
    pcall(function() name = action:GetClassName() or "" end)
    if name == "" then
        pcall(function()
            -- Try getting the TweakDB record name
            local rec = action:GetObjectActionRecord()
            if rec then name = tostring(rec:GetID()) or "" end
        end)
    end
    return name
end

--- Get a human-readable name for an action
local function GetActionLabel(action)
    local label = ""
    pcall(function() label = action:GetActionName() or "" end)
    if label == "" or label == "None" then
        label = GetActionClassName(action)
    end
    if label == "" then
        label = "<unknown>"
    end
    return tostring(label)
end

--============================================================================
-- QUICKHACK EXECUTION
--============================================================================

--- Apply the selected quickhack to the device under the crosshair
--- Execution strategy (avoids RAM and XP):
---   1. Skip ProcessRPGAction entirely (no PayCost = no RAM)
---   2. Call StartAction for start effects (visuals, no XP)
---   3. Try calling the PS handler directly (triggers device effect, no XP)
---   4. Fall back to CompleteAction if PS handler not callable (gives small XP)
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

    local context = MakeContext(player)
    if not context then
        dprint("Could not create action context")
        return
    end

    -- Get available quickhack actions
    local actions = GetQuickHackActions(ps, context)
    if not actions or #actions == 0 then
        dprint("No quickhack actions available for this device")
        return
    end

    dprint(string.format("Found %d quickhack actions:", #actions))
    for i, action in ipairs(actions) do
        dprint(string.format("  [%d] %s (class: %s)", i, GetActionLabel(action), GetActionClassName(action)))
    end

    -- Select the target action
    local selectedHack = HackList[Config.currentHack]
    local targetAction = nil

    if not Config.useFirstAvailable then
        -- Try to match by class name
        for _, action in ipairs(actions) do
            local className = GetActionClassName(action)
            if className == selectedHack.action then
                targetAction = action
                dprint(string.format("Matched selected hack: %s", selectedHack.label))
                break
            end
        end
    end

    -- Fallback: use first available action
    if not targetAction then
        targetAction = actions[1]
        dprint(string.format("Selected hack '%s' not available, using first: %s",
            selectedHack.label, GetActionLabel(targetAction)))
    end

    if not targetAction then
        dprint("No suitable action found")
        return
    end

    -- Set up the action: executor and requester
    pcall(function() targetAction:SetExecutor(player) end)
    pcall(function() targetAction:SetRequesterID(player:GetEntityID()) end)

    local actionClass = GetActionClassName(targetAction)
    local actionLabel = GetActionLabel(targetAction)
    dprint(string.format("Executing: %s (class: %s)", actionLabel, actionClass))

    -- Step 1: StartAction (applies start effects, cooldowns — no RAM, no XP)
    local startOk = pcall(function()
        targetAction:StartAction(game)
    end)
    if startOk then
        dprint("  StartAction OK")
    else
        dprint("  StartAction failed (continuing anyway)")
    end

    -- Step 2: Try to call PS handler directly (device effect without XP)
    -- Find the handler name for this action class
    local handlerName = nil
    for _, hack in ipairs(HackList) do
        if hack.action == actionClass then
            handlerName = hack.handler
            break
        end
    end

    local handlerCalled = false

    if handlerName then
        -- Try calling the PS handler directly
        -- This triggers the actual device effect (distraction, toggle, explode, etc.)
        -- without going through CompleteAction (which gives XP)
        local ok1 = pcall(function()
            local fn = ps[handlerName]
            if fn and type(fn) == "function" then
                fn(ps, targetAction)
                handlerCalled = true
            end
        end)

        if not handlerCalled then
            -- Try alternative method call syntax
            pcall(function()
                ps[handlerName](ps, targetAction)
                handlerCalled = true
            end)
        end

        if handlerCalled then
            dprint(string.format("  PS handler '%s' called directly (no XP gain)", handlerName))
        else
            dprint(string.format("  PS handler '%s' not directly callable", handlerName))
        end
    end

    -- Step 3: Fall back to CompleteAction if PS handler failed
    -- CompleteAction triggers the device effect via QueuePSDeviceEvent,
    -- but also gives XP via AwardExperienceFromQuickhack
    if not handlerCalled then
        dprint("  Falling back to CompleteAction (may give small XP)")
        local completeOk = pcall(function()
            targetAction:CompleteAction(game)
        end)
        if completeOk then
            dprint("  CompleteAction OK")
        else
            dprint("  CompleteAction failed — hack may not have applied")
        end
    end

    dprint(string.format("Quickhack applied: %s", actionLabel))
end

--============================================================================
-- CYCLE HACK TYPE
--============================================================================

local function CycleHack()
    Config.currentHack = (Config.currentHack % #HackList) + 1
    local hack = HackList[Config.currentHack]
    print(string.format("[%s] Hack type: %s (%d/%d)", ModName, hack.label, Config.currentHack, #HackList))
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

    local context = MakeContext(player)
    if not context then return end

    local actions = GetQuickHackActions(ps, context)
    if not actions or #actions == 0 then
        print(string.format("[%s] No quickhack actions available", ModName))
        return
    end

    print(string.format("[%s] Available quickhacks (%d):", ModName, #actions))
    for i, action in ipairs(actions) do
        local label = GetActionLabel(action)
        local class = GetActionClassName(action)
        print(string.format("  [%d] %s (class: %s)", i, label, class))
    end
end

--============================================================================
-- INIT
--============================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized | hacks: %d | debug: %s", ModName, #HackList, tostring(Config.debug)))
    print(string.format("[%s] Current hack: %s (%d/%d)",
        ModName, HackList[Config.currentHack].label, Config.currentHack, #HackList))
    print(string.format("[%s] Bind keys in: Settings > Key Bindings > QHTester", ModName))
    print(string.format("[%s] Hotkeys: Apply Quickhack, Cycle Hack Type, List Available", ModName))
end)

--============================================================================
-- HOTKEYS  (MUST be at file root level — CET scans for these before onInit)
--============================================================================

registerHotkey("QHTesterApply", "Apply Quickhack", function()
    ApplyQuickHack()
end)

registerHotkey("QHTesterCycle", "Cycle Hack Type", function()
    CycleHack()
end)

registerHotkey("QHTesterList", "List Available Hacks", function()
    ListAvailableHacks()
end)
