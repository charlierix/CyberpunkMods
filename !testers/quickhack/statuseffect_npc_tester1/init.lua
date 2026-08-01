--[[
  Status Effect NPC Tester 1 - CET (Lua)
  Multi-method NPC damage testing with live info window.

  Based on research from statuseffect_tester3/research_npc_damage_system.md.
  Tests 5 damage methods on NPCs:
    1. Quickhack attack records (Attacks.QuickHack.*) -- contain DealDamageModule
    2. Base status effects (BaseStatusEffect.*) -- visual only (control group)
    3. Blackwall quest effects -- known instant-kill reference
    4. Direct HitEvent damage -- constructed damage via DamageSystem
    5. Direct StatPool kill -- health pool manipulation + Collapse state

  Interface: Same simplicity as tester3:
    - Toggle window hotkey
    - Apply random effect hotkey (weighted: untested effects picked more often)
    - ImGui window with tried/untried percentage indicator

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_npc_tester1/

  Bind hotkeys in: Settings > Key Bindings > SENpcT1
--]]

local ModName = "SENpcT1"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    debug            = true,
    defaultDuration  = 10.0,
    maxDisplayHacks  = 20,
}

--============================================================================
-- EFFECT CATALOG
-- Each effect has a "method" field that determines how it is applied:
--   "qh_attack"  - Apply quickhack attack record (Attacks.QuickHack.*)
--   "base_se"    - Apply base status effect (BaseStatusEffect.*)
--   "blackwall"  - Apply quest-specific instant-kill effect
--   "hit_event"  - Construct HitEvent with damageValues, ProcessHitEvent
--   "statpool"   - Direct health pool manipulation + Collapse state
--============================================================================

local NPCEffects = {
    -- Category 1: Quickhack Attack Records (contain DealDamageModule)
    { name = "QH Overheat",         method = "qh_attack", id = "Attacks.QuickHack.Overheat",       attempts = 0 },
    { name = "QH Contagion",        method = "qh_attack", id = "Attacks.QuickHack.Contagion",      attempts = 0 },
    { name = "QH ShortCircuit",    method = "qh_attack", id = "Attacks.QuickHack.ShortCircuit",   attempts = 0 },
    { name = "QH Suicide",          method = "qh_attack", id = "Attacks.QuickHack.Suicide",        attempts = 0 },
    { name = "QH CyberPsychosis",   method = "qh_attack", id = "Attacks.QuickHack.CyberPsychosis", attempts = 0 },

    -- Category 2: Base Status Effects (control group -- visual only, no damage)
    { name = "Base Overheat",       method = "base_se",   id = "BaseStatusEffect.Overheat",              attempts = 0 },
    { name = "Base Burning",        method = "base_se",   id = "BaseStatusEffect.Burning",               attempts = 0 },
    { name = "Base ContagionPoison", method = "base_se",  id = "BaseStatusEffect.ContagionPoison",       attempts = 0 },
    { name = "Base EMP",            method = "base_se",   id = "BaseStatusEffect.EMP",                   attempts = 0 },
    { name = "Base Stun",           method = "base_se",   id = "BaseStatusEffect.Stun",                 attempts = 0 },
    { name = "Base Blind",          method = "base_se",   id = "BaseStatusEffect.Blind",                attempts = 0 },
    { name = "Base Madness",        method = "base_se",   id = "BaseStatusEffect.Madness",              attempts = 0 },
    { name = "Base Ping",           method = "base_se",   id = "BaseStatusEffect.Ping",                 attempts = 0 },
    { name = "Base LocomotionMalfunction", method = "base_se", id = "BaseStatusEffect.LocomotionMalfunction", attempts = 0 },
    { name = "Base CyberwareMalfunction", method = "base_se", id = "BaseStatusEffect.CyberwareMalfunction", attempts = 0 },
    { name = "Base NPCForceStagger", method = "base_se",  id = "BaseStatusEffect.NPCForceStagger",       attempts = 0 },

    -- Category 3: Blackwall Quest Effects (known instant-kill)
    { name = "Blackwall HackUpload", method = "blackwall", id = "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload", attempts = 0 },
    { name = "Blackwall CWMalfunction", method = "blackwall", id = "BaseStatusEffect.CyberwareMalfunctionBlackwall", attempts = 0 },

    -- Category 4: Direct HitEvent Damage (constructed in code)
    -- damageValues = {Physical, NonPhysical, Thermal, Chemical, EMP}
    { name = "Hit Physical 100",    method = "hit_event", dmgValues = {100, 0, 0, 0, 0},    attempts = 0 },
    { name = "Hit Thermal 100",     method = "hit_event", dmgValues = {0, 0, 100, 0, 0},    attempts = 0 },
    { name = "Hit Chemical 100",    method = "hit_event", dmgValues = {0, 0, 0, 100, 0},    attempts = 0 },
    { name = "Hit EMP 100",         method = "hit_event", dmgValues = {0, 0, 0, 0, 100},    attempts = 0 },
    { name = "Hit Mixed 50each",    method = "hit_event", dmgValues = {50, 0, 50, 50, 50},   attempts = 0 },
    { name = "Hit Physical 500",    method = "hit_event", dmgValues = {500, 0, 0, 0, 0},    attempts = 0 },

    -- Category 5: Direct StatPool Kill
    { name = "StatPool Health 0 + Collapse", method = "statpool", attempts = 0 },
}

--============================================================================
-- STATE
--============================================================================

local windowVisible = false
local searchQuery = nil

local Scan = {
    entity     = nil,
    typeName   = nil,
    targetName = nil,
    className  = nil,
    distance   = nil,
    recordID   = nil,
    entityHash = nil,
}

local LastHack = {
    effectName  = nil,
    effectID    = nil,
    method      = nil,
    success     = nil,
    resultText  = nil,
}

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

local function GetLookAtTarget()
    local player = Game.GetPlayer()
    if not player then return nil, false, nil end

    local target = nil
    pcall(function()
        target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)
    end)

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
        return nil, false, nil
    end

    local isNPC = false
    local targetClass = "<unknown>"

    pcall(function()
        targetClass = target:GetClassName().value or "<unknown>"
    end)

    pcall(function()
        isNPC = target.IsNPC and target:IsNPC(target)
    end)
    if not isNPC then
        pcall(function() isNPC = target:IsA("ScriptedPuppet") end)
    end
    if not isNPC then
        pcall(function() isNPC = target:IsA("NPCPuppet") end)
    end

    return target, isNPC, targetClass
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

local function IsEntityReported(recordID, hash)
    if reportedEntities[recordID .. ":" .. hash] then return true end
    if reportedEntities[recordID] then return true end
    return false
end

local function MarkEntityReported(recordID, hash)
    reportedEntities[recordID .. ":" .. hash] = true
    reportedEntities[recordID] = true
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
-- RANDOM WEIGHTED SELECTION
--============================================================================

local function PickRandomEffect(effectList)
    if not effectList or #effectList == 0 then return nil, 0 end

    local maxAtt = 0
    for _, e in ipairs(effectList) do
        if e.attempts > maxAtt then maxAtt = e.attempts end
    end

    local totalWeight = 0
    local weights = {}
    for i, e in ipairs(effectList) do
        weights[i] = (maxAtt + 1 - e.attempts)
        if weights[i] < 1 then weights[i] = 1 end
        totalWeight = totalWeight + weights[i]
    end

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
-- APPLY METHODS (per method type)
--============================================================================

local function ApplyStatusEffectMethod(target, effectID, player)
    local ok, err = SafeCall(function()
        StatusEffectHelper.ApplyStatusEffect(target, effectID, player)
    end)
    if not ok then return false, tostring(err) end

    pcall(function()
        StatusEffectHelper.ApplyStatusEffect(target, effectID, Config.defaultDuration)
    end)

    return true, "OK"
end

local function ApplyHitEventDamage(target, dmgValues, player)
    local ok, err = SafeCall(function()
        local hitEvent = HitEvent.new()
        hitEvent.damageValues = dmgValues
        hitEvent.hitPosition = target:GetWorldPosition()
        hitEvent.source = player
        hitEvent.hitEntity = target
        Game.GetDamageSystem():ProcessHitEvent(hitEvent)
    end)
    if not ok then return false, tostring(err) end
    return true, "OK"
end

local function ApplyStatPoolKill(target)
    local ok1, err1 = SafeCall(function()
        Game.GetQuestSystem():GetQuestLogSystem():GetStatPoolsSystem():RequestSettingMinValue(target:GetID(), "Health", 0.0)
    end)
    local ok2, err2 = SafeCall(function()
        target:SetCurrentState(gamedataNPCEncounterState.Collapse)
    end)
    if not ok1 then return false, "StatPool: " .. tostring(err1) end
    if not ok2 then return false, "Collapse: " .. tostring(err2) end
    return true, "OK"
end

local function ApplyEffect(target, effect, player)
    if not target or not IsDefined(target) then return false, "no target" end

    local method = effect.method

    if method == "qh_attack" or method == "base_se" or method == "blackwall" then
        if not effect.id then return false, "no effect ID" end
        local recordExists = ValidateRecord(effect.id)
        if not recordExists then
            return false, "TweakDB record missing"
        end
        return ApplyStatusEffectMethod(target, effect.id, player)
    elseif method == "hit_event" then
        if not effect.dmgValues then return false, "no damage values" end
        return ApplyHitEventDamage(target, effect.dmgValues, player)
    elseif method == "statpool" then
        return ApplyStatPoolKill(target)
    end

    return false, "unknown method: " .. tostring(method)
end

--============================================================================
-- REPORT GENERATION
--============================================================================

local function GenerateReport(target, targetClass, recordID, hash)
    local targetName = GetTargetName(target)
    local dist = GetDistance(target)

    dprint("========================================================")
    dprint("=== NEW ENTITY REPORT ===")
    dprint(string.format("  Name:       %s", targetName))
    dprint(string.format("  Class:      %s", targetClass or "<unknown>"))
    dprint(string.format("  RecordID:   %s", recordID))
    dprint(string.format("  EntityHash: %s", hash))
    if dist then
        dprint(string.format("  Distance:   %.2f m", dist))
    end
    dprint(string.format("  Effects to test: %d", #NPCEffects))
    dprint("========================================================")
end

--============================================================================
-- COVERAGE STATS
--============================================================================

local function GetCoverageStats()
    local total = #NPCEffects
    local tried = 0
    for _, e in ipairs(NPCEffects) do
        if e.attempts > 0 then tried = tried + 1 end
    end
    local untried = total - tried
    local pct = total > 0 and (tried / total) * 100 or 0
    return total, tried, untried, pct
end

--============================================================================
-- HOTKEYS (root level per CET hotkey registration rule)
--============================================================================

registerHotkey("SE_NPC1_TOGGLE_WINDOW", "Toggle Info Window", function()
    windowVisible = not windowVisible
    dprint(string.format("Info window %s", windowVisible and "ON" or "OFF"))
end)

registerHotkey("SE_NPC1_APPLY", "Apply Random Effect", function()
    local target, isNPC, targetClass = GetLookAtTarget()
    if not target then
        dprint("No target found under crosshair")
        LastHack.resultText = "No target"
        LastHack.success = false
        LastHack.effectName = nil
        return
    end

    if not isNPC then
        local targetName = GetTargetName(target)
        dprint(string.format("Target '%s' is not an NPC (class=%s)", targetName, targetClass or "?"))
        LastHack.resultText = "Not NPC"
        LastHack.success = false
        LastHack.effectName = nil
        return
    end

    local recordID, hash = GetEntityKey(target)
    local targetName = GetTargetName(target)
    local player = Game.GetPlayer()

    if not IsEntityReported(recordID, hash) then
        GenerateReport(target, targetClass, recordID, hash)
        MarkEntityReported(recordID, hash)
    end

    local effect, idx = PickRandomEffect(NPCEffects)
    if not effect then
        dprint("No effects available")
        LastHack.resultText = "No effects"
        LastHack.success = false
        LastHack.effectName = nil
        return
    end

    dprint(string.format("=== APPLY [%d/%d]: %s (%s) -> %s (class=%s, recordID=%s) ===",
        idx, #NPCEffects, effect.name, effect.method, targetName, targetClass or "?", recordID))

    local success, resultMsg = ApplyEffect(target, effect, player)

    effect.attempts = effect.attempts + 1

    LastHack.effectName = effect.name
    LastHack.effectID   = effect.id or "(code)"
    LastHack.method     = effect.method
    LastHack.success    = success
    LastHack.resultText = success and "SUCCESS" or ("FAIL: " .. resultMsg)

    dprint(string.format("  Result: %s", LastHack.resultText))
    dprint(string.format("  Attempts on '%s': %d", effect.name, effect.attempts))

    local total, tried, untried, pct = GetCoverageStats()
    dprint(string.format("  Coverage: %d/%d tried (%.0f%%)", tried, total, pct))
end)

--============================================================================
-- EVENTS
--============================================================================

registerForEvent("onInit", function()
    searchQuery = NewObject("gameTargetSearchQuery")
    pcall(function() math.randomseed(os.time()) end)

    dprint("Status Effect NPC Tester 1 initialized")
    dprint(string.format("  Effects to test: %d", #NPCEffects))
    dprint("  Hotkeys: SE_NPC1_TOGGLE_WINDOW, SE_NPC1_APPLY")
    dprint("  Bind in Settings > Key Bindings > SENpcT1")
    dprint("")
    dprint("Usage: Look at NPC, press APPLY for random weighted effect.")
    dprint("       Toggle window to see target details and coverage stats.")
end)

registerForEvent("onUpdate", function(delta)
    if not windowVisible then return end
    if not Game.GetPlayer() then return end

    local target, isNPC, targetClass = GetLookAtTarget()

    Scan.entity     = nil
    Scan.typeName   = nil
    Scan.targetName = nil
    Scan.className  = nil
    Scan.distance   = nil
    Scan.recordID   = nil
    Scan.entityHash = nil

    if not target or not IsDefined(target) then return end
    if not isNPC then return end

    Scan.entity     = target
    Scan.typeName   = "NPC"
    Scan.targetName = GetTargetName(target)
    Scan.className  = targetClass
    Scan.distance   = GetDistance(target)

    local recordID, hash = GetEntityKey(target)
    Scan.recordID   = recordID
    Scan.entityHash = hash
end)

registerForEvent("onDraw", function()
    if not windowVisible then return end

    ImGui.SetNextWindowPos(10, 10, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(440, 420, ImGuiCond.FirstUseEver)

    local visible = ImGui.Begin("SE NPC Tester 1", true, ImGuiWindowFlags.AlwaysAutoResize)
    if visible then
        local total, tried, untried, pct = GetCoverageStats()
        ImGui.Text(string.format("Coverage: %d/%d tried (%.0f%%) -- %d untried", tried, total, pct, untried))

        local barWidth = 100
        local filled = math.floor(barWidth * pct / 100)
        local barStr = string.rep("#", filled) .. string.rep("-", barWidth - filled)
        ImGui.Text("[" .. barStr .. "]")
        ImGui.Separator()

        if not Scan.entity then
            ImGui.Text("Looking at nothing (or non-NPC)...")
        else
            ImGui.Text("Target:  " .. tostring(Scan.targetName or "Unknown"))
            ImGui.Text("Type:    " .. tostring(Scan.typeName or "?") .. " (" .. tostring(Scan.className or "?") .. ")")
            if Scan.distance then
                ImGui.Text(string.format("Dist:    %.1f m", Scan.distance))
            end
            if Scan.recordID then
                ImGui.Text("Record:  " .. Scan.recordID)
            end

            ImGui.Separator()

            if LastHack.resultText then
                local prefix = LastHack.success and "[OK]  " or "[FAIL]"
                ImGui.Text("Last: " .. prefix .. " " .. (LastHack.effectName or "?"))
                ImGui.Text("  Method: " .. tostring(LastHack.method or "?"))
                ImGui.Text("  -> " .. LastHack.resultText)
            else
                ImGui.Text("Last: (none yet)")
            end

            ImGui.Separator()

            ImGui.Text(string.format("Effects (%d total):", total))
            local shown = math.min(total, Config.maxDisplayHacks)
            for i = 1, shown do
                local e = NPCEffects[i]
                local mark = e.attempts > 0 and "*" or " "
                local label = string.format(" %s %-32s [%s:%d]", mark, e.name, e.method, e.attempts)
                ImGui.Text(label)
            end
            if total > shown then
                ImGui.Text(string.format("  ... +%d more not shown", total - shown))
            end

            ImGui.Separator()
            ImGui.Text("* = tried at least once")
            ImGui.Text("Press APPLY hotkey for random effect")
        end
    end
    ImGui.End()
end)

registerForEvent("onShutdown", function()
    dprint("=== Final Effect Statistics ===")
    for _, e in ipairs(NPCEffects) do
        local idStr = e.id or "(code)"
        dprint(string.format("  %-32s [%s] %s: %d attempts", e.name, e.method, idStr, e.attempts))
    end

    local total, tried, untried, pct = GetCoverageStats()
    dprint(string.format("-- Coverage: %d/%d tried (%.0f%%) --", tried, total, pct))
    dprint("=== End Statistics ===")
    dprint("Status Effect NPC Tester 1 shut down")
end)
