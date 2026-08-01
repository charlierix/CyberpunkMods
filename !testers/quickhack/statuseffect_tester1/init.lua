--[[
    Status Effect Tester 1 - CET (Lua)
    Applies quickhack-style status effects directly to the target under crosshair.
    No RAM cost, no XP, no trace/threat, no quickhack UI — just raw status effects.

    This tester was created after analysis showed that the quickhack action pipeline
    (StartAction, ProcessRPGAction, etc.) cannot be used programmatically from CET.
    Instead, we use StatusEffectHelper.ApplyStatusEffect() — the same approach used
    by the Blackwall mod to apply quickhack-like effects without the full pipeline.

    Install: Copy this folder to:
      bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_tester1/

    Bind hotkeys in: Settings > Key Bindings > SETester1
--]]

local ModName = "SETester1"

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
--============================================================================
local StatusEffects = {
    { name = "Overheat (Lvl1)", id = "BaseStatusEffect.QH_Overheat_Lvl1", desc = "Burns target, deals damage over time", target = "npc" },
    { name = "Overheat (Lvl2)", id = "BaseStatusEffect.QH_Overheat_Lvl2", desc = "Stronger burning damage", target = "npc" },
    { name = "Overheat (Lvl3)", id = "BaseStatusEffect.QH_Overheat_Lvl3", desc = "Maximum burning damage", target = "npc" },
    { name = "Short Circuit (Lvl1)", id = "BaseStatusEffect.QH_ShortCircuit_Lvl1", desc = "EMP stun, disables cyberware briefly", target = "npc" },
    { name = "Short Circuit (Lvl2)", id = "BaseStatusEffect.QH_ShortCircuit_Lvl2", desc = "Stronger EMP", target = "npc" },
    { name = "Short Circuit (Lvl3)", id = "BaseStatusEffect.QH_ShortCircuit_Lvl3", desc = "Maximum EMP", target = "npc" },
    { name = "Cyberware Malfunction (Lvl1)", id = "BaseStatusEffect.QH_CyberwareMalfunction_Lvl1", desc = "Disables target cyberware", target = "npc" },
    { name = "Cyberware Malfunction (Lvl2)", id = "BaseStatusEffect.QH_CyberwareMalfunction_Lvl2", desc = "Longer cyberware disable", target = "npc" },
    { name = "Cyberware Malfunction (Lvl3)", id = "BaseStatusEffect.QH_CyberwareMalfunction_Lvl3", desc = "Maximum cyberware disable", target = "npc" },
    { name = "Contagion (Lvl1)", id = "BaseStatusEffect.QH_Contagion_Lvl1", desc = "Poison damage, can spread", target = "npc" },
    { name = "Contagion (Lvl2)", id = "BaseStatusEffect.QH_Contagion_Lvl2", desc = "Stronger poison", target = "npc" },
    { name = "Contagion (Lvl3)", id = "BaseStatusEffect.QH_Contagion_Lvl3", desc = "Maximum poison", target = "npc" },
    { name = "Ping (Lvl1)", id = "BaseStatusEffect.QH_Ping_Lvl1", desc = "Highlights target through walls", target = "npc" },
    { name = "Ping (Lvl2)", id = "BaseStatusEffect.QH_Ping_Lvl2", desc = "Highlights more enemies", target = "npc" },
    { name = "Ping (Lvl3)", id = "BaseStatusEffect.QH_Ping_Lvl3", desc = "Maximum highlighting", target = "npc" },
    { name = "Reboot Optics (Lvl1)", id = "BaseStatusEffect.QH_RebootOptics_Lvl1", desc = "Blinds target", target = "npc" },
    { name = "Reboot Optics (Lvl2)", id = "BaseStatusEffect.QH_RebootOptics_Lvl2", desc = "Longer blindness", target = "npc" },
    { name = "Reboot Optics (Lvl3)", id = "BaseStatusEffect.QH_RebootOptics_Lvl3", desc = "Maximum blindness", target = "npc" },
    { name = "Madness (Lvl1)", id = "BaseStatusEffect.QH_Madness_Lvl1", desc = "Target attacks allies", target = "npc" },
    { name = "Madness (Lvl2)", id = "BaseStatusEffect.QH_Madness_Lvl2", desc = "Longer madness", target = "npc" },
    { name = "Madness (Lvl3)", id = "BaseStatusEffect.QH_Madness_Lvl3", desc = "Maximum madness", target = "npc" },
    { name = "Distraction (Lvl1)", id = "BaseStatusEffect.QH_Distraction_Lvl1", desc = "Distracts device", target = "device" },
    { name = "Distraction (Lvl2)", id = "BaseStatusEffect.QH_Distraction_Lvl2", desc = "Longer distraction", target = "device" },
    { name = "Distraction (Lvl3)", id = "BaseStatusEffect.QH_Distraction_Lvl3", desc = "Maximum distraction", target = "device" },
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

--- Get the target under the crosshair
local function GetLookAtTarget()
    local player = Game.GetPlayer()
    if not player then return nil, false, false end

    local target = nil
    local searchQuery = nil
    pcall(function() searchQuery = NewObject('gameTargetSearchQuery') end)
    if searchQuery then
        local filter = nil
        pcall(function() filter = Game["TSF_Quickhackable;"]() end)
        if not filter then
            pcall(function() filter = Game["TSF_Quickhackable;"] end)
        end
        if filter then
            searchQuery.searchFilter = filter
            searchQuery.maxDistance = Config.maxDistance
            pcall(function()
                target = Game.GetTargetingSystem():GetObjectClosestToCrosshair(player, searchQuery)
            end)
        end
    end

    if not target or not IsDefined(target) then
        pcall(function()
            target = Game.GetTargetingSystem():GetLookAtObject(player, false)
        end)
        if not target or not IsDefined(target) then
            dprint("No target under crosshair")
            return nil, false, false
        end
    end

    local isNPC = false
    local isDevice = false
    pcall(function() isNPC = target:IsA("ScriptedPuppet") end)
    if not isNPC then
        pcall(function() isNPC = target:IsA("NPCPuppet") end)
    end
    if not isNPC then
        pcall(function() isDevice = target:GetDevicePS() ~= nil end)
    end
    if not isNPC and not isDevice then
        local hasPS = false
        pcall(function() hasPS = target.GetDevicePS ~= nil end)
        if hasPS then isDevice = true end
    end

    return target, isNPC, isDevice
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

--- Apply a status effect to a target
local function ApplyEffect(target, effect, duration)
    if not target or not IsDefined(target) then
        dprint("Cannot apply effect: target is nil or undefined")
        return false
    end
    if not effect or not effect.id then
        dprint("Cannot apply effect: effect is nil")
        return false
    end

    dprint(string.format("Applying '%s' (%s) with duration %.1f", effect.name, effect.id, duration or 0))

    -- Method 1: StatusEffectHelper.ApplyStatusEffect (proven by Blackwall mod)
    local ok, err = SafeCall(function()
        if duration and duration > 0 then
            StatusEffectHelper.ApplyStatusEffect(target, effect.id, duration)
        else
            StatusEffectHelper.ApplyStatusEffect(target, effect.id)
        end
    end)

    if ok then
        dprint(string.format("SUCCESS: Applied '%s' via StatusEffectHelper", effect.name))
        return true
    else
        dprint(string.format("StatusEffectHelper failed: %s", tostring(err)))
    end

    -- Method 2: Game.GetStatusEffectSystem():ApplyStatusEffect (entity ID based)
    local ok2, err2 = SafeCall(function()
        local entityID = target:GetEntityID()
        local seSystem = Game.GetStatusEffectSystem()
        if duration and duration > 0 then
            seSystem:ApplyStatusEffect(entityID, effect.id, duration)
        else
            seSystem:ApplyStatusEffect(entityID, effect.id)
        end
    end)

    if ok2 then
        dprint(string.format("SUCCESS: Applied '%s' via StatusEffectSystem", effect.name))
        return true
    else
        dprint(string.format("StatusEffectSystem failed: %s", tostring(err2)))
    end

    dprint(string.format("FAILED: Could not apply '%s'", effect.name))
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
        dprint(string.format("SUCCESS: Removed '%s'", effect.name))
        return true
    else
        dprint(string.format("RemoveStatusEffect failed: %s", tostring(err)))
        local ok2, err2 = SafeCall(function()
            StatusEffectHelper.RemoveStatusEffect(target, effect.id, 1.0)
        end)
        if ok2 then
            dprint(string.format("SUCCESS: Removed '%s' (alternate)", effect.name))
            return true
        else
            dprint(string.format("Alternate remove also failed: %s", tostring(err2)))
        end
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

--============================================================================
-- HOTKEY ACTIONS (root level per CET requirement)
--============================================================================

registerHotkey("SE1_APPLY", "Apply Selected Status Effect", function()
    local target, isNPC, isDevice = GetLookAtTarget()
    if not target then dprint("No target found under crosshair") return end
    local effect = GetSelectedEffect()
    if not effect then dprint("No effect selected") return end
    local targetName = GetTargetName(target)
    dprint(string.format("Target: %s (NPC=%s, Device=%s)", targetName, tostring(isNPC), tostring(isDevice)))
    if not IsEffectApplicable(effect, isNPC, isDevice) then
        dprint(string.format("Effect '%s' is for %s targets but target is NPC=%s Device=%s",
            effect.name, effect.target, tostring(isNPC), tostring(isDevice)))
    end
    ApplyEffect(target, effect, Config.defaultDuration)
end)

registerHotkey("SE1_CYCLE", "Cycle Status Effect", function()
    Config.selectedIndex = Config.selectedIndex + 1
    if Config.selectedIndex > #StatusEffects then Config.selectedIndex = 1 end
    local effect = GetSelectedEffect()
    if effect then
        dprint(string.format("Selected effect [%d/%d]: %s — %s",
            Config.selectedIndex, #StatusEffects, effect.name, effect.desc))
    end
end)

registerHotkey("SE1_CYCLE_BACK", "Cycle Status Effect (Back)", function()
    Config.selectedIndex = Config.selectedIndex - 1
    if Config.selectedIndex < 1 then Config.selectedIndex = #StatusEffects end
    local effect = GetSelectedEffect()
    if effect then
        dprint(string.format("Selected effect [%d/%d]: %s — %s",
            Config.selectedIndex, #StatusEffects, effect.name, effect.desc))
    end
end)

registerHotkey("SE1_REMOVE", "Remove Selected Status Effect", function()
    local target, isNPC, isDevice = GetLookAtTarget()
    if not target then dprint("No target found under crosshair") return end
    local effect = GetSelectedEffect()
    if not effect then dprint("No effect selected") return end
    RemoveEffect(target, effect)
end)

registerHotkey("SE1_LIST", "List All Status Effects", function()
    dprint("=== Available Status Effects ===")
    for i, effect in ipairs(StatusEffects) do
        local marker = (i == Config.selectedIndex) and " >>>" or "    "
        dprint(string.format("%s[%d] %s (%s) — %s", marker, i, effect.name, effect.target, effect.desc))
    end
    dprint(string.format("Total: %d effects", #StatusEffects))
end)

registerHotkey("SE1_CHECK", "Check Target Status Effects", function()
    local target, isNPC, isDevice = GetLookAtTarget()
    if not target then dprint("No target found under crosshair") return end
    local targetName = GetTargetName(target)
    dprint(string.format("=== Active Status Effects on %s ===", targetName))
    local anyActive = false
    for _, effect in ipairs(StatusEffects) do
        if HasEffect(target, effect.id) then
            dprint(string.format("  ACTIVE: %s (%s)", effect.name, effect.id))
            anyActive = true
        end
    end
    if not anyActive then dprint("  No tracked status effects active on target") end
end)

registerHotkey("SE1_APPLY_PERM", "Apply Selected Effect (Permanent)", function()
    local target, isNPC, isDevice = GetLookAtTarget()
    if not target then dprint("No target found under crosshair") return end
    local effect = GetSelectedEffect()
    if not effect then dprint("No effect selected") return end
    local targetName = GetTargetName(target)
    dprint(string.format("Applying PERMANENT '%s' to %s", effect.name, targetName))
    ApplyEffect(target, effect, 0)
end)

registerHotkey("SE1_REMOVE_ALL", "Remove All Tracked Effects", function()
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

--============================================================================
-- INIT
--============================================================================

registerForEvent("onInit", function()
    dprint("Status Effect Tester 1 initialized")
    dprint(string.format("Loaded %d status effects. Default duration: %.1fs", #StatusEffects, Config.defaultDuration))
    local effect = GetSelectedEffect()
    if effect then
        dprint(string.format("Default effect: %s — %s", effect.name, effect.desc))
    end
end)

registerForEvent("onShutdown", function()
    dprint("Status Effect Tester 1 shut down")
end)
