--[[
   Status Effect Tester 2 - CET (Lua)
   Applies quickhack-style status effects directly to the target under crosshair.

   FIXES FROM TESTER 1:
   1. Target detection: use target.IsNPC(target) like Blackwall mod (IsA() fails silently in pcall)
   2. Effect IDs: use REAL base game IDs (QH_ prefixed IDs don't exist in TweakDB → silent no-op)
   3. Instigator: pass player as 3rd arg (GameEntityExaminerTool pattern)
   4. TweakDB validation: verify record exists before applying
   5. TweakDB enumeration: dump all BaseStatusEffect records to discover valid IDs
   6. Multiple API overloads: try 3-arg, 2-arg, and StatusEffectSystem variants

   Install: Copy this folder to:
     bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_tester2/

   Bind hotkeys in: Settings > Key Bindings > SETester2
--]]

local ModName = "SETester2"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    debug            = true,
    maxDistance      = 30.0,
    defaultDuration  = 10.0,
    selectedIndex    = 1,
}

--============================================================================
-- STATUS EFFECT CATALOG
-- Real base game effect IDs (confirmed from source mods).
-- No QH_ prefix, no _Lvl1 suffix — those were fake IDs that silently no-op.
--============================================================================
local StatusEffects = {
    -- NPC effects (confirmed real IDs from source mods)
    { name = "Overheat", id = "BaseStatusEffect.Overheat", desc = "Burns target, deals damage over time", target = "npc" },
    { name = "Burning", id = "BaseStatusEffect.Burning", desc = "Fire burning effect", target = "npc" },
    { name = "Blind (Reboot Optics)", id = "BaseStatusEffect.Blind", desc = "Blinds target (Reboot Optics effect)", target = "npc" },
    { name = "Stun", id = "BaseStatusEffect.Stun", desc = "Stuns target", target = "npc" },
    { name = "Ping", id = "BaseStatusEffect.Ping", desc = "Highlights target through walls", target = "npc" },
    { name = "Pain", id = "BaseStatusEffect.Pain", desc = "Pain effect", target = "npc" },
    { name = "NPCForceStagger", id = "BaseStatusEffect.NPCForceStagger", desc = "Forces stagger animation", target = "npc" },
    { name = "LocomotionMalfunction", id = "BaseStatusEffect.LocomotionMalfunction", desc = "Disables locomotion (Cyberware Malfunction-style)", target = "npc" },
    { name = "LocomotionMalfunction Lvl2", id = "BaseStatusEffect.LocomotionMalfunctionLevel2", desc = "Stronger locomotion disable", target = "npc" },
    { name = "CyberwareMalfunctionBlackwall", id = "BaseStatusEffect.CyberwareMalfunctionBlackwall", desc = "Blackwall-style cyberware malfunction", target = "npc" },
    -- Likely real IDs (need in-game TweakDB verification)
    { name = "ShortCircuit", id = "BaseStatusEffect.ShortCircuit", desc = "EMP stun (needs verification)", target = "npc" },
    { name = "Contagion", id = "BaseStatusEffect.Contagion", desc = "Poison damage (needs verification)", target = "npc" },
    { name = "Madness", id = "BaseStatusEffect.Madness", desc = "Target attacks allies (needs verification)", target = "npc" },
    { name = "CyberwareMalfunction", id = "BaseStatusEffect.CyberwareMalfunction", desc = "Disables cyberware (needs verification)", target = "npc" },
    { name = "RebootOptics", id = "BaseStatusEffect.RebootOptics", desc = "Blinds target (needs verification)", target = "npc" },
    { name = "Distraction", id = "BaseStatusEffect.Distraction", desc = "Distracts device (needs verification)", target = "device" },
    -- Quest effects (confirmed real from Blackwall mod)
    { name = "BlackwallHackUpload", id = "BaseStatusEffect.SoMi_Q306_BlackwallHackUpload", desc = "Blackwall hack upload (quest effect, confirmed working)", target = "npc" },
    -- Additional effects from GameEntityExaminerTool (confirmed real)
    { name = "LegendaryFragGrenade", id = "BaseStatusEffect.LegendaryFragGrenadeExplosion", desc = "Frag grenade explosion effect", target = "any" },
    { name = "RoyceForceStagger", id = "BaseStatusEffect.RoyceForceStagger", desc = "Royce force stagger", target = "npc" },
    { name = "Sandstorm", id = "BaseStatusEffect.Sandstorm", desc = "Sandstorm effect", target = "npc" },
    { name = "ReconGrenadeLegendaryPlus", id = "BaseStatusEffect.ReconGrenadeAttackLegendaryPlus", desc = "Recon grenade highlight", target = "any" },
    { name = "ForceDive", id = "BaseStatusEffect.ForceDive", desc = "Force dive effect", target = "npc" },
    { name = "JohnnySicknessHeavy", id = "BaseStatusEffect.JohnnySicknessHeavy", desc = "Johnny sickness heavy", target = "npc" },
}

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

--- Check if a TweakDB record exists
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

--- Get the target under the crosshair (fixed detection from tester1)
--- Uses target.IsNPC(target) like Blackwall mod instead of IsA() inside pcall
local function GetLookAtTarget()
    local player = Game.GetPlayer()
    if not player then return nil, false, false, nil end

    local target = nil

    -- Method 1: GetLookAtObject (simplest, used by Blackwall)
    pcall(function()
        target = Game.GetTargetingSystem():GetLookAtObject(player, false, false)
    end)

    -- Method 2: GetObjectClosestToCrosshair with search query
    if not target or not IsDefined(target) then
        pcall(function()
            local searchQuery = Game["TSQ_ALL;"]()
            target = Game.GetTargetingSystem():GetObjectClosestToCrosshair(player, searchQuery)
        end)
    end

    -- Method 3: GetComponentClosestToCrosshair (GameEntityExaminerTool pattern)
    if not target or not IsDefined(target) then
        pcall(function()
            local comp = Game.GetTargetingSystem():GetComponentClosestToCrosshair(player, nil)
            if comp and IsDefined(comp) then
                target = comp:GetEntity()
            end
        end)
    end

    if not target or not IsDefined(target) then
        dprint("No target found under crosshair")
        return nil, false, false, nil
    end

    -- Determine target type using Blackwall mod's approach:
    -- target.IsNPC(target) and ScriptedPuppet.IsActive(target)
    local isNPC = false
    local isDevice = false
    local isActive = false
    local targetClass = "<unknown>"

    -- Get class name for logging
    pcall(function()
        targetClass = target:GetClassName().value or "<unknown>"
    end)

    -- Check NPC using target.IsNPC(target) — Blackwall mod pattern
    pcall(function()
        isNPC = target.IsNPC and target:IsNPC(target)
    end)

    -- Also check via IsA without pcall swallowing errors
    if not isNPC then
        pcall(function()
            isNPC = target:IsA("ScriptedPuppet")
        end)
    end
    if not isNPC then
        pcall(function()
            isNPC = target:IsA("NPCPuppet")
        end)
    end

    -- Check if active
    pcall(function()
        isActive = ScriptedPuppet.IsActive(target)
    end)

    -- Check device
    if not isNPC then
        pcall(function()
            local ps = target:GetDevicePS()
            isDevice = ps ~= nil
        end)
    end

    -- Check vehicle
    local isVehicle = false
    pcall(function()
        isVehicle = GameObject.IsVehicle(target)
    end)

    dprint(string.format("Target: class=%s NPC=%s Device=%s Vehicle=%s Active=%s",
        targetClass, tostring(isNPC), tostring(isDevice), tostring(isVehicle), tostring(isActive)))

    return target, isNPC, isDevice, targetClass
end

local function GetSelectedEffect()
    if #StatusEffects == 0 then return nil end
    local idx = Config.selectedIndex
    if idx > #StatusEffects then idx = 1 end
    if idx < 1 then idx = #StatusEffects end
    return StatusEffects[idx]
end

local function IsEffectApplicable(effect, isNPC, isDevice)
    if effect.target == "npc" and isNPC then return true end
    if effect.target == "device" and isDevice then return true end
    if effect.target == "any" then return true end
    return false
end

--- Get target name for logging
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

--- Get entity ID hash for logging
local function GetEntityIDHash(target)
    local hash = "<none>"
    pcall(function()
        hash = tostring(target:GetEntityID().hash)
    end)
    return hash
end

--- Apply a status effect to a target using multiple API overloads
local function ApplyEffect(target, effect, duration)
    if not target or not IsDefined(target) then
        dprint("Cannot apply effect: target is nil or undefined")
        return false
    end
    if not effect or not effect.id then
        dprint("Cannot apply effect: effect is nil")
        return false
    end

    local player = Game.GetPlayer()
    local entityID = nil
    pcall(function() entityID = target:GetEntityID() end)
    local playerEntityID = nil
    pcall(function() playerEntityID = player:GetEntityID() end)

    dprint(string.format("Applying '%s' (%s) duration=%.1f instigator=%s",
        effect.name, effect.id, duration or 0, tostring(playerEntityID and playerEntityID.hash or "nil")))

    -- Validate TweakDB record exists
    local recordExists = ValidateRecord(effect.id)
    dprint(string.format("  TweakDB record '%s' exists: %s", effect.id, tostring(recordExists)))
    if not recordExists then
        dprint(string.format("  WARNING: Record '%s' does not exist in TweakDB! API will silently no-op.", effect.id))
        dprint("  Use the DUMP hotkey to enumerate valid BaseStatusEffect records.")
    end

    -- Method 1: StatusEffectHelper.ApplyStatusEffect(target, effectID, instigator) — 3-arg with instigator
    -- Pattern from GameEntityExaminerTool (confirmed working)
    local ok1, err1 = SafeCall(function()
        StatusEffectHelper.ApplyStatusEffect(target, effect.id, player)
    end)
    if ok1 then
        dprint(string.format("  [OK] Method 1 (3-arg with player instigator): SUCCESS"))
    else
        dprint(string.format("  [FAIL] Method 1 (3-arg with player): %s", tostring(err1)))
    end

    -- Method 2: StatusEffectHelper.ApplyStatusEffect(target, effectID) — 2-arg (Neuralware pattern)
    local ok2, err2 = SafeCall(function()
        StatusEffectHelper.ApplyStatusEffect(target, effect.id)
    end)
    if ok2 then
        dprint(string.format("  [OK] Method 2 (2-arg): SUCCESS"))
    else
        dprint(string.format("  [FAIL] Method 2 (2-arg): %s", tostring(err2)))
    end

    -- Method 3: StatusEffectHelper.ApplyStatusEffect(target, effectID, duration) — with duration (Blackwall pattern)
    local ok3, err3 = SafeCall(function()
        if duration and duration > 0 then
            StatusEffectHelper.ApplyStatusEffect(target, effect.id, duration)
        else
            StatusEffectHelper.ApplyStatusEffect(target, effect.id, 0.0)
        end
    end)
    if ok3 then
        dprint(string.format("  [OK] Method 3 (with duration %.1f): SUCCESS", duration or 0))
    else
        dprint(string.format("  [FAIL] Method 3 (with duration): %s", tostring(err3)))
    end

    -- Method 4: Game.GetStatusEffectSystem():ApplyStatusEffect(entityID, effectID) — entity ID based
    -- Pattern from Immersive Meditations mod
    if entityID then
        local ok4, err4 = SafeCall(function()
            local seSystem = Game.GetStatusEffectSystem()
            seSystem:ApplyStatusEffect(entityID, effect.id)
        end)
        if ok4 then
            dprint(string.format("  [OK] Method 4 (StatusEffectSystem entityID): SUCCESS"))
        else
            dprint(string.format("  [FAIL] Method 4 (StatusEffectSystem entityID): %s", tostring(err4)))
        end
    end

    -- Method 5: StatusEffectHelper with TweakDBID.new wrapper (GameEntityExaminerTool pattern)
    local ok5, err5 = SafeCall(function()
        local tdbid = TweakDBID.new(effect.id)
        StatusEffectHelper.ApplyStatusEffect(target, tdbid, player)
    end)
    if ok5 then
        dprint(string.format("  [OK] Method 5 (TweakDBID.new wrapper + instigator): SUCCESS"))
    else
        dprint(string.format("  [FAIL] Method 5 (TweakDBID.new): %s", tostring(err5)))
    end

    -- Verify if effect was actually applied
    local applied = false
    pcall(function()
        applied = StatusEffectSystem.ObjectHasStatusEffect(target, effect.id)
    end)
    dprint(string.format("  >>> VERIFICATION: ObjectHasStatusEffect = %s", tostring(applied)))

    if applied then
        dprint(string.format("  >>> CONFIRMED: '%s' is now active on target!", effect.name))
        return true
    end

    -- Return success if any method didn't error (even if verification fails,
    -- some effects may apply but not be queryable via ObjectHasStatusEffect)
    local anyOk = ok1 or ok2 or ok3 or ok4 or ok5
    if anyOk and recordExists then
        dprint(string.format("  >>> PARTIAL: API calls succeeded but ObjectHasStatusEffect=false. Effect may still be active."))
        return true
    end

    if not recordExists then
        dprint(string.format("  >>> FAILED: Record does not exist in TweakDB. Use DUMP hotkey to find valid IDs."))
    end

    return false
end

--- Remove a status effect from a target
local function RemoveEffect(target, effect)
    if not target or not IsDefined(target) then return false end
    if not effect or not effect.id then return false end

    dprint(string.format("Removing '%s' (%s)", effect.name, effect.id))

    local ok, err = SafeCall(function()
        StatusEffectHelper.RemoveStatusEffect(target, effect.id)
    end)
    if ok then
        dprint(string.format("  [OK] Removed '%s'", effect.name))
        return true
    else
        dprint(string.format("  [FAIL] RemoveStatusEffect: %s", tostring(err)))
    end

    return false
end

--- Check if target has a status effect
local function HasEffect(target, effectID)
    if not target or not IsDefined(target) then return false end
    local has = false
    pcall(function()
        has = StatusEffectSystem.ObjectHasStatusEffect(target, effectID)
    end)
    return has
end

--============================================================================
-- HOTKEY ACTIONS (root level per CET requirement)
--============================================================================

registerHotkey("SE2_APPLY", "Apply Selected Status Effect", function()
    local target, isNPC, isDevice, targetClass = GetLookAtTarget()
    if not target then dprint("No target found under crosshair") return end
    local effect = GetSelectedEffect()
    if not effect then dprint("No effect selected") return end
    local targetName = GetTargetName(target)
    local entityHash = GetEntityIDHash(target)
    dprint(string.format("=== APPLY: %s (class=%s, entityID=%s) ===", targetName, targetClass or "?", entityHash))
    if not IsEffectApplicable(effect, isNPC, isDevice) then
        dprint(string.format("  NOTE: Effect '%s' is for %s targets but target is NPC=%s Device=%s",
            effect.name, effect.target, tostring(isNPC), tostring(isDevice)))
    end
    ApplyEffect(target, effect, Config.defaultDuration)
end)

registerHotkey("SE2_APPLY_PERM", "Apply Selected Effect (Permanent/No Duration)", function()
    local target, isNPC, isDevice, targetClass = GetLookAtTarget()
    if not target then dprint("No target found under crosshair") return end
    local effect = GetSelectedEffect()
    if not effect then dprint("No effect selected") return end
    local targetName = GetTargetName(target)
    dprint(string.format("=== APPLY PERMANENT: %s ===", targetName))
    ApplyEffect(target, effect, 0)
end)

registerHotkey("SE2_CYCLE", "Cycle Status Effect", function()
    Config.selectedIndex = Config.selectedIndex + 1
    if Config.selectedIndex > #StatusEffects then Config.selectedIndex = 1 end
    local effect = GetSelectedEffect()
    if effect then
        local exists = ValidateRecord(effect.id)
        dprint(string.format("Selected [%d/%d]: %s (%s) — TweakDB exists: %s",
            Config.selectedIndex, #StatusEffects, effect.name, effect.id, tostring(exists)))
    end
end)

registerHotkey("SE2_CYCLE_BACK", "Cycle Status Effect (Back)", function()
    Config.selectedIndex = Config.selectedIndex - 1
    if Config.selectedIndex < 1 then Config.selectedIndex = #StatusEffects end
    local effect = GetSelectedEffect()
    if effect then
        local exists = ValidateRecord(effect.id)
        dprint(string.format("Selected [%d/%d]: %s (%s) — TweakDB exists: %s",
            Config.selectedIndex, #StatusEffects, effect.name, effect.id, tostring(exists)))
    end
end)

registerHotkey("SE2_REMOVE", "Remove Selected Status Effect", function()
    local target, isNPC, isDevice = GetLookAtTarget()
    if not target then dprint("No target found under crosshair") return end
    local effect = GetSelectedEffect()
    if not effect then dprint("No effect selected") return end
    RemoveEffect(target, effect)
end)

registerHotkey("SE2_LIST", "List All Status Effects (with TweakDB validation)", function()
    dprint("=== Status Effect Catalog (with TweakDB validation) ===")
    for i, effect in ipairs(StatusEffects) do
        local marker = (i == Config.selectedIndex) and " >>>" or "    "
        local exists = ValidateRecord(effect.id)
        local status = exists and "VALID" or "MISSING"
        dprint(string.format("%s[%d] %s (%s) [%s] — %s", marker, i, effect.name, effect.target, status, effect.desc))
    end
    dprint(string.format("Total: %d effects", #StatusEffects))
end)

registerHotkey("SE2_CHECK", "Check Target Status Effects", function()
    local target, isNPC, isDevice, targetClass = GetLookAtTarget()
    if not target then dprint("No target found under crosshair") return end
    local targetName = GetTargetName(target)
    local entityHash = GetEntityIDHash(target)
    dprint(string.format("=== Active Status Effects on %s (class=%s, entityID=%s) ===",
        targetName, targetClass or "?", entityHash))
    local anyActive = false
    for _, effect in ipairs(StatusEffects) do
        if HasEffect(target, effect.id) then
            dprint(string.format("  ACTIVE: %s (%s)", effect.name, effect.id))
            anyActive = true
        end
    end
    if not anyActive then dprint("  No tracked status effects active on target") end
end)

registerHotkey("SE2_REMOVE_ALL", "Remove All Tracked Effects", function()
    local target, isNPC, isDevice = GetLookAtTarget()
    if not target then dprint("No target found under crosshair") return end
    local targetName = GetTargetName(target)
    dprint(string.format("Removing all tracked effects from %s", targetName))
    local removed = 0
    for _, effect in ipairs(StatusEffects) do
        if HasEffect(target, effect.id) then
            if RemoveEffect(target, effect) then removed = removed + 1 end
        end
    end
    dprint(string.format("Removed %d effects from target", removed))
end)

registerHotkey("SE2_DUMP", "Dump All BaseStatusEffect TweakDB Records", function()
    dprint("=== Enumerating all BaseStatusEffect records in TweakDB ===")
    local count = 0
    local found = {}
    pcall(function()
        for _, record in ipairs(TweakDB:GetRecords("gamedataStatusEffect_Record")) do
            local id = record:GetID()
            if id and id.value and string.sub(id.value, 1, 17) == "BaseStatusEffect." then
                table.insert(found, id.value)
                count = count + 1
            end
        end
    end)
    table.sort(found)
    dprint(string.format("Found %d BaseStatusEffect records:", count))
    for i, id in ipairs(found) do
        dprint(string.format("  [%d] %s", i, id))
    end
    dprint(string.format("=== Total: %d records ===", count))
end)

registerHotkey("SE2_DUMP_QH", "Dump Quickhack-Related Status Effects", function()
    dprint("=== Quickhack-related BaseStatusEffect records ===")
    local count = 0
    local found = {}
    pcall(function()
        for _, record in ipairs(TweakDB:GetRecords("gamedataStatusEffect_Record")) do
            local id = record:GetID()
            if id and id.value and string.sub(id.value, 1, 17) == "BaseStatusEffect." then
                local lower = string.lower(id.value)
                if string.find(lower, "overheat") or string.find(lower, "shortcircuit") or
                   string.find(lower, "contagion") or string.find(lower, "ping") or
                   string.find(lower, "reboot") or string.find(lower, "madness") or
                   string.find(lower, "cyberware") or string.find(lower, "distraction") or
                   string.find(lower, "blind") or string.find(lower, "stun") or
                   string.find(lower, "burn") or string.find(lower, "emp") or
                   string.find(lower, "poison") or string.find(lower, "glitch") or
                   string.find(lower, "locomotion") or string.find(lower, "malfunction") then
                    table.insert(found, id.value)
                    count = count + 1
                end
            end
        end
    end)
    table.sort(found)
    dprint(string.format("Found %d quickhack-related records:", count))
    for i, id in ipairs(found) do
        dprint(string.format("  [%d] %s", i, id))
    end
    dprint(string.format("=== Total: %d records ===", count))
end)

registerHotkey("SE2_TARGET_INFO", "Show Target Info (Debug)", function()
    local target, isNPC, isDevice, targetClass = GetLookAtTarget()
    if not target then dprint("No target found under crosshair") return end
    local targetName = GetTargetName(target)
    local entityHash = GetEntityIDHash(target)
    dprint(string.format("=== TARGET INFO ==="))
    dprint(string.format("  Name: %s", targetName))
    dprint(string.format("  Class: %s", targetClass or "<unknown>"))
    dprint(string.format("  EntityID hash: %s", entityHash))
    dprint(string.format("  IsNPC: %s", tostring(isNPC)))
    dprint(string.format("  IsDevice: %s", tostring(isDevice)))

    -- Additional debug info
    local isActive = false
    pcall(function() isActive = ScriptedPuppet.IsActive(target) end)
    dprint(string.format("  IsActive: %s", tostring(isActive)))

    local isVehicle = false
    pcall(function() isVehicle = GameObject.IsVehicle(target) end)
    dprint(string.format("  IsVehicle: %s", tostring(isVehicle)))

    -- Check IsNPC method existence
    local hasIsNPC = false
    pcall(function() hasIsNPC = type(target.IsNPC) == "function" end)
    dprint(string.format("  Has IsNPC method: %s", tostring(hasIsNPC)))

    -- Check IsA results without pcall
    local isScriptedPuppet = false
    local isNPCPuppet = false
    pcall(function() isScriptedPuppet = target:IsA("ScriptedPuppet") end)
    pcall(function() isNPCPuppet = target:IsA("NPCPuppet") end)
    dprint(string.format("  IsA('ScriptedPuppet'): %s", tostring(isScriptedPuppet)))
    dprint(string.format("  IsA('NPCPuppet'): %s", tostring(isNPCPuppet)))

    -- Try target.IsNPC(target) directly
    local isNPCResult = false
    local npcErr = nil
    local ok, err = pcall(function()
        if target.IsNPC then
            isNPCResult = target:IsNPC(target)
        end
    end)
    if not ok then npcErr = tostring(err) end
    dprint(string.format("  target:IsNPC(target): %s (err: %s)", tostring(isNPCResult), tostring(npcErr)))
end)

--============================================================================
-- INIT
--============================================================================

registerForEvent("onInit", function()
    dprint("Status Effect Tester 2 initialized")
    dprint(string.format("Loaded %d status effects. Default duration: %.1fs", #StatusEffects, Config.defaultDuration))
    dprint("FIXES FROM TESTER 1:")
    dprint("  1. Target detection: uses target.IsNPC(target) (Blackwall pattern)")
    dprint("  2. Real effect IDs: no QH_ prefix (those were fake, caused silent no-ops)")
    dprint("  3. Instigator: passes player as 3rd arg (GameEntityExaminerTool pattern)")
    dprint("  4. TweakDB validation: checks record exists before applying")
    dprint("  5. Multiple API overloads: tries 5 different call patterns")
    dprint("  6. New hotkeys: DUMP (all BaseStatusEffect records), DUMP_QH (quickhack-related), TARGET_INFO (debug)")
    dprint("")
    dprint("IMPORTANT: Use SE2_DUMP or SE2_DUMP_QH hotkey first to discover valid effect IDs!")
    dprint("Some effect IDs in the catalog are marked 'needs verification' and may not exist.")
    local effect = GetSelectedEffect()
    if effect then
        local exists = ValidateRecord(effect.id)
        dprint(string.format("Default effect: %s (%s) — TweakDB exists: %s", effect.name, effect.id, tostring(exists)))
    end
end)

registerForEvent("onShutdown", function()
    dprint("Status Effect Tester 2 shut down")
end)
