--[[
  Status Effect Tester 3 - CET (Lua)
  Random quickhack-style status effect tester with live info window.

  Improvements from Tester 2:
  1. ImGui info window with toggle hotkey (target info, hack result, available hacks)
  2. Random weighted hack selection (untested hacks weighted higher)
  3. Smart target-type awareness (NPC effects for NPCs, device effects for devices)
  4. Auto-report on first encounter with each entity (no repeat reports)
  5. Corrected effect IDs from TweakDB dump data (Contagion->ContagionPoison, etc.)
  6. Only 2 hotkeys needed: toggle window, apply hack

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_tester3/

  Bind hotkeys in: Settings > Key Bindings > SETester3
--]]

local ModName = "SETester3"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    debug            = true,
    defaultDuration  = 10.0,
    maxDisplayHacks  = 15,
}

--============================================================================
-- STATUS EFFECT CATALOGS
-- IDs corrected using TweakDB dump data from Tester 2.
-- Each effect tracks attempt count for weighted random selection.
--============================================================================

local NPCEffects = {
    -- Core quickhack effects (confirmed valid from tester 2)
    { name = "Overheat",                 id = "BaseStatusEffect.Overheat",                        attempts = 0 },
    { name = "Burning",                  id = "BaseStatusEffect.Burning",                         attempts = 0 },
    { name = "Blind",                    id = "BaseStatusEffect.Blind",                           attempts = 0 },
    { name = "Stun",                     id = "BaseStatusEffect.Stun",                            attempts = 0 },
    { name = "Ping",                     id = "BaseStatusEffect.Ping",                            attempts = 0 },
    { name = "Pain",                     id = "BaseStatusEffect.Pain",                            attempts = 0 },
    { name = "NPCForceStagger",          id = "BaseStatusEffect.NPCForceStagger",                 attempts = 0 },
    { name = "LocomotionMalfunction",    id = "BaseStatusEffect.LocomotionMalfunction",           attempts = 0 },
    { name = "CyberwareMalfunction",     id = "BaseStatusEffect.CyberwareMalfunction",            attempts = 0 },
    { name = "CW Malfunction Blackwall", id = "BaseStatusEffect.CyberwareMalfunctionBlackwall",   attempts = 0 },
    { name = "Madness",                  id = "BaseStatusEffect.Madness",                         attempts = 0 },
    { name = "BlackwallHackUpload",      id = "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload",   attempts = 0 },
    -- Corrected IDs (replaced missing IDs from tester 2 with real ones from dump)
    { name = "Contagion Poison",         id = "BaseStatusEffect.ContagionPoison",                 attempts = 0 },
    { name = "Base Contagion Poison",    id = "BaseStatusEffect.BaseContagionPoison",             attempts = 0 },
    { name = "EMP",                      id = "BaseStatusEffect.EMP",                             attempts = 0 },
    { name = "Base EMP",                 id = "BaseStatusEffect.BaseEMP",                         attempts = 0 },
    { name = "QuickHack Blind",          id = "BaseStatusEffect.QuickHackBlind",                  attempts = 0 },
    { name = "Base QuickHack Blind",     id = "BaseStatusEffect.BaseQuickHackBlind",              attempts = 0 },
    { name = "Poisoned",                 id = "BaseStatusEffect.Poisoned",                        attempts = 0 },
    { name = "Base BrainMelt",           id = "BaseStatusEffect.BaseBrainMelt",                   attempts = 0 },
    { name = "Base CommsNoise",          id = "BaseStatusEffect.BaseCommsNoise",                  attempts = 0 },
    { name = "Base Overheat",            id = "BaseStatusEffect.BaseOverheat",                    attempts = 0 },
    -- Locomotion Malfunction leveled variants
    { name = "Locomotion Lvl2",          id = "BaseStatusEffect.LocomotionMalfunctionLevel2",     attempts = 0 },
    { name = "Locomotion Lvl3",          id = "BaseStatusEffect.LocomotionMalfunctionLevel3",     attempts = 0 },
    { name = "Locomotion Lvl4",          id = "BaseStatusEffect.LocomotionMalfunctionLevel4",     attempts = 0 },
    -- Cyberware Malfunction leveled variants
    { name = "CW Malfunction Lvl1",      id = "BaseStatusEffect.CyberwareMalfunctionLvl1",        attempts = 0 },
    { name = "CW Malfunction Lvl2",      id = "BaseStatusEffect.CyberwareMalfunctionLvl2",        attempts = 0 },
    { name = "CW Malfunction Lvl3",      id = "BaseStatusEffect.CyberwareMalfunctionLvl3",        attempts = 0 },
    { name = "CW Malfunction Lvl4",      id = "BaseStatusEffect.CyberwareMalfunctionLvl4",        attempts = 0 },
    -- Overheat leveled variants
    { name = "Overheat Lvl1",            id = "BaseStatusEffect.OverheatLevel1",                  attempts = 0 },
    { name = "Overheat Lvl2",            id = "BaseStatusEffect.OverheatLevel2",                  attempts = 0 },
    { name = "Overheat Lvl3",            id = "BaseStatusEffect.OverheatLevel3",                  attempts = 0 },
    { name = "Overheat Lvl4",            id = "BaseStatusEffect.OverheatLevel4",                  attempts = 0 },
    -- Ping leveled variants
    { name = "Ping Lvl2",                id = "BaseStatusEffect.PingLevel2",                      attempts = 0 },
    { name = "Ping Lvl3",                id = "BaseStatusEffect.PingLevel3",                      attempts = 0 },
    { name = "Ping Lvl4",                id = "BaseStatusEffect.PingLevel4",                      attempts = 0 },
    -- Blind variants
    { name = "Moderate Blind",           id = "BaseStatusEffect.ModerateBlind",                   attempts = 0 },
    { name = "Major Blind",              id = "BaseStatusEffect.MajorBlind",                      attempts = 0 },
    { name = "Minor Blind",              id = "BaseStatusEffect.MinorBlind",                      attempts = 0 },
    { name = "Legendary Blind",          id = "BaseStatusEffect.LegendaryEffectBlind",            attempts = 0 },
    { name = "Major QH Blind",           id = "BaseStatusEffect.MajorQuickHackBlind",             attempts = 0 },
}

local DeviceEffects = {
    { name = "Distraction Duration",     id = "BaseStatusEffect.DistractionDuration",             attempts = 0 },
    { name = "EMP",                      id = "BaseStatusEffect.EMP",                             attempts = 0 },
    { name = "Base EMP",                 id = "BaseStatusEffect.BaseEMP",                         attempts = 0 },
    { name = "Overload EMP",             id = "BaseStatusEffect.OverloadEMP",                     attempts = 0 },
    { name = "Base Overload",            id = "BaseStatusEffect.BaseOverload",                    attempts = 0 },
}

--============================================================================
-- STATE
--============================================================================

local windowVisible = false
local searchQuery = nil

-- Current scan data (updated each frame in onUpdate when window is visible)
local Scan = {
    entity     = nil,
    typeName   = nil,
    targetName = nil,
    className  = nil,
    isNPC      = false,
    isDevice   = false,
    distance   = nil,
    recordID   = nil,
    entityHash = nil,
    availHacks = nil,  -- reference to NPCEffects or DeviceEffects
}

-- Last hack result (updated when apply hotkey is pressed)
local LastHack = {
    effectName  = nil,
    effectID    = nil,
    success     = nil,
    resultText  = nil,
}

-- Track reported entities to avoid duplicate reports
-- Keyed by recordID:hash (composite) and recordID (fallback)
local reportedEntities = {}

--============================================================================
-- HELPERS
--============================================================================

local function dprint(msg)
    if Config.debug then
        print(string.format("[%s] %s", ModName, msg))
    end
end

local function SafeCall(fn, ...)
    local results = table.pack(pcall(fn, ...))
    local ok = results[1]
    if ok then
        return true, table.unpack(results, 2, results.n)
    else
        return false, results[2]
    end
end

local function ValidateRecord(recordID)
    local exists = false
    pcall(function()
        local record = TweakDB:GetRecord(recordID)
        exists = record ~= nil
    end)
    if not exists then
        pcall(function()
            local flat = TweakDB:GetFlat(recordID)
            exists = flat ~= nil
        end)
    end
    return exists
end

--- Get the entity under the crosshair
--- Uses GetLookAtObject (confirmed working in tester 2) with fallback
local function GetLookAtTarget()
    local player = Game.GetPlayer()
    if not player then return nil, false, false, nil end

    local target = nil

    -- Method 1: GetLookAtObject (simplest, confirmed working in tester 2)
    pcall(function()
        target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)
    end)

    -- Method 2: GetComponentClosestToCrosshair (entity scanner pattern)
    if not target or not IsDefined(target) then
        pcall(function()
            if searchQuery then
                local comp = Game.GetTargetingSystem():GetComponentClosestToCrosshair(player, searchQuery)
                if comp and IsDefined(comp) then
                    target = comp:GetEntity()
                end
            end
        end)
    end

    if not target or not IsDefined(target) then
        return nil, false, false, nil
    end

    -- Determine target type (Blackwall mod pattern from tester 2)
    local isNPC = false
    local isDevice = false
    local targetClass = "<unknown>"

    pcall(function()
        targetClass = target:GetClassName().value or "<unknown>"
    end)

    -- Check NPC using target.IsNPC(target) — Blackwall mod pattern
    pcall(function()
        isNPC = target.IsNPC and target:IsNPC(target)
    end)
    if not isNPC then
        pcall(function() isNPC = target:IsA("ScriptedPuppet") end)
    end
    if not isNPC then
        pcall(function() isNPC = target:IsA("NPCPuppet") end)
    end

    -- Check device via GetDevicePS
    if not isNPC then
        pcall(function()
            local ps = target:GetDevicePS()
            isDevice = ps ~= nil
        end)
    end

    return target, isNPC, isDevice, targetClass
end

--- Get target name for logging and display
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

--- Get entity identifiers for uniqueness tracking
--- Uses recordID (stable per entity type) and entityID.hash (per instance)
--- User warned entityID may change every frame — recordID fallback handles that
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

--- Check if entity has already been reported
local function IsEntityReported(recordID, hash)
    if reportedEntities[recordID .. ":" .. hash] then return true end
    if reportedEntities[recordID] then return true end
    return false
end

--- Mark entity as reported (both composite and recordID-only keys)
local function MarkEntityReported(recordID, hash)
    reportedEntities[recordID .. ":" .. hash] = true
    reportedEntities[recordID] = true
end

--- Calculate distance from player to target
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
-- RANDOM WEIGHTED SELECTION
--============================================================================

--- Pick a random effect from the list, weighting untested effects higher.
--- Effects with fewer attempts get higher selection probability.
local function PickRandomEffect(effectList)
    if not effectList or #effectList == 0 then return nil, 0 end

    -- Find max attempts in the list
    local maxAtt = 0
    for _, e in ipairs(effectList) do
        if e.attempts > maxAtt then maxAtt = e.attempts end
    end

    -- Build weights: untested (0 attempts) get highest weight
    local totalWeight = 0
    local weights = {}
    for i, e in ipairs(effectList) do
        weights[i] = (maxAtt + 1 - e.attempts)
        if weights[i] < 1 then weights[i] = 1 end
        totalWeight = totalWeight + weights[i]
    end

    -- Weighted random pick
    local r = math.random() * totalWeight
    local cumulative = 0
    for i, w in ipairs(weights) do
        cumulative = cumulative + w
        if r <= cumulative then
            return effectList[i], i
        end
    end

    return effectList[#effectList], #effectList
end

--============================================================================
-- APPLY EFFECT
--============================================================================

--- Apply a status effect to target.
--- Uses 3-arg method with instigator (confirmed working in tester 2).
--- Also tries duration variant for completeness.
--- Returns success=true if API call succeeded and TweakDB record exists.
local function ApplyEffect(target, effect, duration)
    if not target or not IsDefined(target) then return false, "no target" end
    if not effect or not effect.id then return false, "no effect" end

    local player = Game.GetPlayer()

    -- Validate TweakDB record exists
    local recordExists = ValidateRecord(effect.id)
    if not recordExists then
        return false, "TweakDB record missing"
    end

    -- Apply using 3-arg method with instigator (GameEntityExaminerTool pattern)
    local ok, err = SafeCall(function()
        StatusEffectHelper.ApplyStatusEffect(target, effect.id, player)
    end)

    if not ok then
        return false, tostring(err)
    end

    -- Also try with duration (Blackwall pattern)
    if duration and duration > 0 then
        pcall(function()
            StatusEffectHelper.ApplyStatusEffect(target, effect.id, duration)
        end)
    end

    return true, "OK"
end

--============================================================================
-- REPORT GENERATION
--============================================================================

--- Generate a detailed report for a newly encountered entity.
--- Only fires once per entity (tracked by recordID + hash).
local function GenerateReport(target, isNPC, isDevice, targetClass, recordID, hash)
    local targetName = GetTargetName(target)
    local dist = GetDistance(target)

    dprint("========================================================")
    dprint("=== NEW ENTITY REPORT ===")
    dprint(string.format("  Name:       %s", targetName))
    dprint(string.format("  Class:      %s", targetClass or "<unknown>"))
    dprint(string.format("  RecordID:   %s", recordID))
    dprint(string.format("  EntityHash: %s", hash))
    dprint(string.format("  Type:       NPC=%s Device=%s", tostring(isNPC), tostring(isDevice)))
    if dist then
        dprint(string.format("  Distance:   %.2f m", dist))
    end

    local availHacks = nil
    if isNPC then
        availHacks = NPCEffects
        dprint(string.format("  Available NPC hacks: %d", #NPCEffects))
    elseif isDevice then
        availHacks = DeviceEffects
        dprint(string.format("  Available device hacks: %d", #DeviceEffects))
    else
        dprint("  No applicable hacks for this target type")
    end

    if availHacks then
        for i, e in ipairs(availHacks) do
            local valid = ValidateRecord(e.id)
            dprint(string.format("    [%2d] %-30s (%s) [%s]", i, e.name, e.id, valid and "VALID" or "MISSING"))
        end
    end

    dprint("========================================================")
end

--============================================================================
-- HOTKEYS (root level per CET hotkey registration rule)
--============================================================================

registerHotkey("SE3_TOGGLE_WINDOW", "Toggle Info Window", function()
    windowVisible = not windowVisible
    dprint(string.format("Info window %s", windowVisible and "ON" or "OFF"))
end)

registerHotkey("SE3_APPLY", "Apply Random Hack", function()
    local target, isNPC, isDevice, targetClass = GetLookAtTarget()
    if not target then
        dprint("No target found under crosshair")
        LastHack.resultText = "No target"
        LastHack.success = false
        LastHack.effectName = nil
        return
    end

    local recordID, hash = GetEntityKey(target)
    local targetName = GetTargetName(target)

    -- Determine which effect list to use based on target type
    local effectList = nil
    if isNPC then
        effectList = NPCEffects
    elseif isDevice then
        effectList = DeviceEffects
    else
        dprint(string.format("Target '%s' is neither NPC nor Device (class=%s)", targetName, targetClass or "?"))
        LastHack.resultText = "Not NPC/Device"
        LastHack.success = false
        LastHack.effectName = nil
        return
    end

    -- Generate report on first encounter with this entity
    if not IsEntityReported(recordID, hash) then
        GenerateReport(target, isNPC, isDevice, targetClass, recordID, hash)
        MarkEntityReported(recordID, hash)
    end

    -- Pick random weighted effect (untested weighted higher)
    local effect, idx = PickRandomEffect(effectList)
    if not effect then
        dprint("No effects available for this target type")
        LastHack.resultText = "No effects"
        LastHack.success = false
        LastHack.effectName = nil
        return
    end

    -- Apply the effect
    dprint(string.format("=== APPLY [%d/%d]: %s -> %s (class=%s, recordID=%s) ===",
        idx, #effectList, effect.name, targetName, targetClass or "?", recordID))

    local success, resultMsg = ApplyEffect(target, effect, Config.defaultDuration)

    -- Increment attempt counter for weighted selection
    effect.attempts = effect.attempts + 1

    -- Update last hack display data
    LastHack.effectName = effect.name
    LastHack.effectID   = effect.id
    LastHack.success    = success
    LastHack.resultText = success and "SUCCESS" or ("FAIL: " .. resultMsg)

    dprint(string.format("  Result: %s (%s)", LastHack.resultText, effect.id))
    dprint(string.format("  Attempts on '%s': %d", effect.name, effect.attempts))
end)

--============================================================================
-- EVENTS
--============================================================================

registerForEvent("onInit", function()
    -- Construct targeting query (empty query = match everything)
    searchQuery = NewObject("gameTargetSearchQuery")

    -- Seed random number generator
    pcall(function() math.randomseed(os.time()) end)

    dprint("Status Effect Tester 3 initialized")
    dprint(string.format("  NPC effects:    %d", #NPCEffects))
    dprint(string.format("  Device effects: %d", #DeviceEffects))
    dprint("  Hotkeys: SE3_TOGGLE_WINDOW, SE3_APPLY")
    dprint("  Bind in Settings > Key Bindings > SETester3")
    dprint("")
    dprint("Usage: Look at NPC/device, press APPLY HACK for random weighted hack.")
    dprint("       Toggle info window to see target details and hack list.")
end)

registerForEvent("onUpdate", function(delta)
    -- Only scan when window is visible (save performance)
    if not windowVisible then return end
    if not Game.GetPlayer() then return end

    local target, isNPC, isDevice, targetClass = GetLookAtTarget()

    -- Reset scan data
    Scan.entity     = nil
    Scan.typeName   = nil
    Scan.targetName = nil
    Scan.className  = nil
    Scan.isNPC      = false
    Scan.isDevice   = false
    Scan.distance   = nil
    Scan.recordID   = nil
    Scan.entityHash = nil
    Scan.availHacks = nil

    if not target or not IsDefined(target) then
        return
    end

    Scan.entity     = target
    Scan.typeName   = isNPC and "NPC" or (isDevice and "Device" or "Entity")
    Scan.targetName = GetTargetName(target)
    Scan.className  = targetClass
    Scan.isNPC      = isNPC
    Scan.isDevice   = isDevice
    Scan.distance   = GetDistance(target)

    local recordID, hash = GetEntityKey(target)
    Scan.recordID   = recordID
    Scan.entityHash = hash

    if isNPC then
        Scan.availHacks = NPCEffects
    elseif isDevice then
        Scan.availHacks = DeviceEffects
    end
end)

registerForEvent("onDraw", function()
    if not windowVisible then return end

    ImGui.SetNextWindowPos(10, 10, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(440, 400, ImGuiCond.FirstUseEver)

    local visible = ImGui.Begin("SE Tester 3", true, ImGuiWindowFlags.AlwaysAutoResize)
    if visible then
        if not Scan.entity then
            ImGui.Text("Looking at nothing...")
        else
            -- Target info section
            ImGui.Text("Target:  " .. tostring(Scan.targetName or "Unknown"))
            ImGui.Text("Type:    " .. tostring(Scan.typeName or "?") .. " (" .. tostring(Scan.className or "?") .. ")")
            if Scan.distance then
                ImGui.Text(string.format("Dist:    %.1f m", Scan.distance))
            end
            if Scan.recordID then
                ImGui.Text("Record:  " .. Scan.recordID)
            end

            ImGui.Separator()

            -- Last hack result section
            if LastHack.resultText then
                local prefix = LastHack.success and "[OK]  " or "[FAIL]"
                ImGui.Text("Last Hack: " .. prefix .. " " .. (LastHack.effectName or "?"))
                ImGui.Text("  -> " .. LastHack.resultText)
            else
                ImGui.Text("Last Hack: (none yet)")
            end

            ImGui.Separator()

            -- Available hacks section
            if Scan.availHacks then
                local total = #Scan.availHacks
                local shown = math.min(total, Config.maxDisplayHacks)

                ImGui.Text(string.format("Available Hacks (%d total):", total))

                for i = 1, shown do
                    local e = Scan.availHacks[i]
                    local label = string.format("  %-30s [%d]", e.name, e.attempts)
                    ImGui.Text(label)
                end

                if total > shown then
                    ImGui.Text(string.format("  ... +%d more not shown", total - shown))
                end

                -- Total attempts summary
                local totalAttempts = 0
                for _, e in ipairs(Scan.availHacks) do
                    totalAttempts = totalAttempts + e.attempts
                end
                ImGui.Separator()
                ImGui.Text(string.format("Total hack attempts this session: %d", totalAttempts))
            else
                ImGui.Text("No applicable hacks for this target")
            end

            ImGui.Separator()
            ImGui.Text("Press APPLY HACK hotkey for random hack")
        end
    end
    ImGui.End()
end)

registerForEvent("onShutdown", function()
    -- Print final attempt statistics for coverage analysis
    dprint("=== Final Hack Attempt Statistics ===")
    dprint("-- NPC Effects --")
    for _, e in ipairs(NPCEffects) do
        dprint(string.format("  %-30s %s: %d attempts", e.name, e.id, e.attempts))
    end
    dprint("-- Device Effects --")
    for _, e in ipairs(DeviceEffects) do
        dprint(string.format("  %-30s %s: %d attempts", e.name, e.id, e.attempts))
    end

    local totalNPC = 0
    for _, e in ipairs(NPCEffects) do totalNPC = totalNPC + e.attempts end
    local totalDev = 0
    for _, e in ipairs(DeviceEffects) do totalDev = totalDev + e.attempts end
    dprint(string.format("-- Totals: NPC=%d Device=%d --", totalNPC, totalDev))
    dprint("=== End Statistics ===")
    dprint("Status Effect Tester 3 shut down")
end)
