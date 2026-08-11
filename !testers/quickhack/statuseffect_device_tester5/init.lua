--[[
  Status Effect Device Tester 5 - CET (Lua)
  EffectExecutor_Scripted Class Investigation

  Focus: Test EffectExecutor_Scripted classes and gameEffect construction API.
  Based on device hack summary.md suggestion #3:
    "Test EffectExecutor_Scripted classes
     Research gameEffect construction API
     Try EffectExecutor_VisualEffectAtTarget for point-based visual effects
     Try EMP/EMPExplosion for area effects at arbitrary positions"

  Strategy matrix:
    A. Construct effect objects via multiple CET approaches (A1-A9)
    B. Execute effects via status effect application (B1-B5)
    C. Investigate TweakDB linkage (C1-C3)

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester5/

  Bind hotkeys in: Settings > Key Bindings > SEDevT5
--]]

local ModName = "SEDevT5"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    debug           = true,
    maxDistance     = 20.0,
    windowWidth     = 1000,
}

--============================================================================
-- REGISTRY
--============================================================================
local ConstructionRegistry = {}
local ConstructionOrder = {}

local ExecutionRegistry = {}
local ExecutionOrder = {}

local TweakDBRegistry = {}
local TweakDBOrder = {}

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
    ps         = nil,
}

local LastResult = {
    phase      = nil,
    strategy   = nil,
    success    = nil,
    resultText = nil,
}

--============================================================================
-- EFFECT EXECUTOR CLASS CATALOG
-- From okf/adamsmasher device core.md and effect-executor-scripted API docs
--============================================================================

local EffectExecutorClasses = {
    { className = "EMP",                                 fields = 0, methods = 2, source = "137687.json", label = "EMP Effect Executor" },
    { className = "EMPExplosion",                        fields = 0, methods = 1, source = "137697.json", label = "EMP Explosion Executor" },
    { className = "EffectExecutor_VisualEffectAtTarget", fields = 2, methods = 2, source = "137914.json", label = "Visual Effect At Target" },
    { className = "EffectExecutor_SetDeviceON",          fields = 0, methods = 1, source = "137833.json", label = "Set Device ON" },
    { className = "EffectExecutor_SetDeviceOFF",         fields = 0, methods = 1, source = "137751.json", label = "Set Device OFF" },
    { className = "EffectExecutor_ToggleDevice",         fields = 0, methods = 1, source = "137840.json", label = "Toggle Device" },
    { className = "ApplyJammer",                         fields = 0, methods = 1, source = "137673.json", label = "Apply Jammer" },
    { className = "ApplyJammerFromCw",                  fields = 0, methods = 1, source = "137679.json", label = "Apply Jammer From Cyberware" },
    { className = "EffectExecutor_PingNetwork",         fields = 1, methods = 6, source = "137703.json", label = "Ping Network" },
    { className = "EffectExecutor_MuteBubble",           fields = 0, methods = 4, source = "137731.json", label = "Mute Bubble" },
    { className = "StrikeExecutor_Heal",                 fields = 1, methods = 1, source = "151346.json", label = "Strike: Heal" },
    { className = "StrikeExecutor_Kill",                 fields = 0, methods = 1, source = "151353.json", label = "Strike: Kill" },
    { className = "EffectExecutor_ApplyEffector",        fields = 1, methods = 1, source = "151332.json", label = "Apply Effector" },
    { className = "EffectExecutor_GameObjectOutline",    fields = 1, methods = 1, source = "95427.json",  label = "Game Object Outline" },
    { className = "EffectExecutor_SlashEffect",          fields = 1, methods = 1, source = "151457.json", label = "Slash Effect" },
    { className = "EffectExecutor_Spread",               fields = 4, methods = 2, source = "100193.json", label = "Spread Effect" },
}

--============================================================================
-- CONSTRUCTION STRATEGIES (A1-A9)
--============================================================================

local ConstructionStrategies = {
    { key = "A1", label = "NewObject(\"gameEffectData\")",                 desc = "Construct gameEffectData via NewObject" },
    { key = "A2", label = "NewObject(\"EffectExecutor_VisualEffectAtTarget\")", desc = "Construct VisualEffectAtTarget via NewObject" },
    { key = "A3", label = "NewObject(\"EMP\")",                          desc = "Construct EMP executor via NewObject" },
    { key = "A4", label = "NewObject(\"EMPExplosion\")",                 desc = "Construct EMPExplosion via NewObject" },
    { key = "A5", label = "gameEffectData.new()",                       desc = "Construct gameEffectData via .new()" },
    { key = "A6", label = "EffectExecutor_VisualEffectAtTarget.new()",     desc = "Construct VisualEffectAtTarget via .new()" },
    { key = "A7", label = "Game.GetEffectSystem()",                     desc = "Access EffectSystem via Game.GetEffectSystem()" },
    { key = "A8", label = "GetScriptableSystem(\"EffectSystem\")",        desc = "Access EffectSystem via GetScriptableSystem" },
    { key = "A9", label = "TweakDB: GetStatusEffectRecord executor list",  desc = "Find StatusEffect records embedding these executors" },
}

--============================================================================
-- EXECUTION STRATEGIES (B1-B5)
--============================================================================

local ExecutionStrategies = {
    { key = "B1", label = "Apply EMP StatusEffect to device",     desc = "StatusEffectHelper.ApplyStatusEffect(target, BaseStatusEffect.EMP)" },
    { key = "B2", label = "Apply EMP StatusEffect to player pos", desc = "Apply EMP at player position for point-based effect" },
    { key = "B3", label = "Apply OverloadEMP to device",         desc = "StatusEffectHelper.ApplyStatusEffect(target, BaseStatusEffect.OverloadEMP)" },
    { key = "B4", label = "Apply BaseOverload to device",        desc = "StatusEffectHelper.ApplyStatusEffect(target, BaseStatusEffect.BaseOverload)" },
    { key = "B5", label = "Apply BaseEMP to device",             desc = "StatusEffectHelper.ApplyStatusEffect(target, BaseStatusEffect.BaseEMP)" },
}

--============================================================================
-- TWEAKDB LINKAGE STRATEGIES (C1-C3)
--============================================================================

local TweakDBStrategies = {
    { key = "C1", label = "Dump StatusEffect packages",       desc = "Read status effect packages from TweakDB for EMP/visual records" },
    { key = "C2", label = "Dump Attack_GameEffect records",   desc = "Read Attacks.QuickHack.* records that embed game effects" },
    { key = "C3", label = "Search StatusEffectExecutor records", desc = "Find TweakDB records referencing EffectExecutor classes" },
}

--============================================================================
-- EMP / VISUAL STATUS EFFECT IDS
--============================================================================

local EmpEffectIDs = {
    "BaseStatusEffect.EMP",
    "BaseStatusEffect.BaseEMP",
    "BaseStatusEffect.OverloadEMP",
    "BaseStatusEffect.BaseOverload",
    "Attacks.QuickHack.EMP",
    "Attacks.QuickHack.EMPExplosion",
    "Attacks.QuickHack.Overload",
    "BaseStatusEffect.QuickHackEMP",
    "BaseStatusEffect.EMPExplosion",
}

--============================================================================
-- UTILITIES
--============================================================================

local function SafeCall(fn, ...)
    local result = {pcall(fn, ...)}
    if result[1] then
        return true, result[2]
    else
        local err = tostring(result[2] or 'unknown error')
        local short = err:sub(1, 200)
        if Config.debug then print('[' .. ModName .. '] ERR: ' .. short) end
        return false, short
    end
end

local function CNameToString(cn)
    local s = tostring(cn)
    s = s:gsub("CName:", "")
    s = s:gsub("'", "")
    return s:match("^%s*(.-)%s*$") or s
end

local function Regen(key, registry, order)
    if not registry[key] then
        registry[key] = { attempts = 0, successes = 0, lastResult = "not tried" }
        table.insert(order, key)
    end
    registry[key].attempts = registry[key].attempts + 1
end

local function MarkSuccess(key, registry, resultText)
    if registry[key] then
        registry[key].successes = registry[key].successes + 1
        registry[key].lastResult = resultText or "success"
    end
end

local function MarkFail(key, registry, resultText)
    if registry[key] then
        registry[key].lastResult = resultText or "failed"
    end
end

--============================================================================
-- TARGET DETECTION
--============================================================================

local function GetLookAtDevice()
    local player = Game.GetPlayer()
    if not player then return nil end

    local searchQuery = nil
    pcall(function() searchQuery = NewObject('gameTargetSearchQuery') end)
    if not searchQuery then
        if Config.debug then print('[' .. ModName .. '] Could not create gameTargetSearchQuery') end
        return nil
    end

    local filter = nil
    pcall(function() filter = Game["TSF_Quickhackable;"]() end)
    if not filter then
        pcall(function() filter = Game["TSF_Quickhackable;"] end)
    end
    if not filter then
        if Config.debug then print('[' .. ModName .. '] Could not create TSF_Quickhackable filter') end
        return nil
    end
    searchQuery.searchFilter = filter
    searchQuery.maxDistance = Config.maxDistance

    local target = nil
    pcall(function()
        target = Game.GetTargetingSystem():GetObjectClosestToCrosshair(player, searchQuery)
    end)

    if not target or not IsDefined(target) then
        return nil
    end

    return target
end

local function ScanTarget(target)
    if not target then return nil end

    local scan = {}
    scan.entity = target

    local ok1, pos = SafeCall(function() return target:GetWorldPosition() end)
    local ok2, name = SafeCall(function() return target:GetDisplayName() end)
    local ok3, cname = SafeCall(function() return target:GetClassName() end)
    local ok4, eid = SafeCall(function() return target:GetEntityID() end)

    local player = Game.GetPlayer()
    local ppos = player and player:GetWorldPosition() or Vector4.new(0, 0, 0, 1)
    local dist = 0
    if ok1 and pos then
        local dx = pos.x - ppos.x
        local dy = pos.y - ppos.y
        local dz = pos.z - ppos.z
        dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    end

    scan.targetName = (ok2 and name) and tostring(name) or "unknown"
    scan.className = (ok3 and cname) and CNameToString(cname) or "unknown"
    scan.distance = dist
    scan.entityHash = (ok4 and eid) and tostring(eid) or "unknown"

    local ok5, ps = SafeCall(function() return target:GetDevicePS() end)
    if not ok5 then
        ok5, ps = SafeCall(function() return target:GetPS() end)
    end
    scan.ps = (ok5 and ps) or nil

    return scan
end

--============================================================================
-- CONSTRUCTION PHASE (A1-A9)
--============================================================================

local function RunConstructionStrategy(key)
    local registry = ConstructionRegistry
    Regen(key, registry, ConstructionOrder)

    local result = nil
    local success = false

    if key == "A1" then
        success, result = SafeCall(function() return NewObject("gameEffectData") end)

    elseif key == "A2" then
        success, result = SafeCall(function() return NewObject("EffectExecutor_VisualEffectAtTarget") end)

    elseif key == "A3" then
        success, result = SafeCall(function() return NewObject("EMP") end)

    elseif key == "A4" then
        success, result = SafeCall(function() return NewObject("EMPExplosion") end)

    elseif key == "A5" then
        success, result = SafeCall(function() return gameEffectData.new() end)

    elseif key == "A6" then
        success, result = SafeCall(function() return EffectExecutor_VisualEffectAtTarget.new() end)

    elseif key == "A7" then
        success, result = SafeCall(function() return Game.GetEffectSystem() end)

    elseif key == "A8" then
        success, result = SafeCall(function() return Game.GetScriptableSystem("EffectSystem") end)
        if not success or not result then
            success, result = SafeCall(function() return Game.GetScriptableSystem("IEffectSystem") end)
        end

    elseif key == "A9" then
        success, result = SafeCall(function()
            local found = {}
            for _, effectId in ipairs({"BaseStatusEffect.EMP", "BaseStatusEffect.BaseEMP", "BaseStatusEffect.OverloadEMP"}) do
                local rec = TweakDB:GetRecord(effectId)
                if rec then
                    table.insert(found, { id = effectId, record = tostring(rec), found = true })
                else
                    table.insert(found, { id = effectId, record = nil, found = false })
                end
            end
            return found
        end)
    end

    if success then
        MarkSuccess(key, registry, tostring(result):sub(1, 100))
    else
        MarkFail(key, registry, tostring(result):sub(1, 100))
    end

    return success, result
end

local function RunAllConstruction()
    for _, strat in ipairs(ConstructionStrategies) do
        RunConstructionStrategy(strat.key)
    end
    LastResult.phase = "construction"
    LastResult.strategy = "ALL"
    LastResult.success = true
    LastResult.resultText = "All construction strategies attempted"
end

--============================================================================
-- EXECUTION PHASE (B1-B5)
--============================================================================

local function RunExecutionStrategy(key, target)
    local registry = ExecutionRegistry
    Regen(key, registry, ExecutionOrder)

    local player = Game.GetPlayer()
    local result = nil
    local success = false

    if key == "B1" then
        success, result = SafeCall(function()
            return StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new("BaseStatusEffect.EMP"), player)
        end)

    elseif key == "B2" then
        success, result = SafeCall(function()
            return StatusEffectHelper.ApplyStatusEffect(player, TweakDBID.new("BaseStatusEffect.EMP"), player)
        end)

    elseif key == "B3" then
        success, result = SafeCall(function()
            return StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new("BaseStatusEffect.OverloadEMP"), player)
        end)

    elseif key == "B4" then
        success, result = SafeCall(function()
            return StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new("BaseStatusEffect.BaseOverload"), player)
        end)

    elseif key == "B5" then
        success, result = SafeCall(function()
            return StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new("BaseStatusEffect.BaseEMP"), player)
        end)
    end

    if success and target then
        local ok2, hasEffect = SafeCall(function()
            return StatusEffectSystem.ObjectHasStatusEffect(target, TweakDBID.new("BaseStatusEffect.EMP"))
        end)
        if ok2 then
            result = tostring(result) .. " | HasEffect=" .. tostring(hasEffect)
        end
    end

    if success then
        MarkSuccess(key, registry, tostring(result):sub(1, 100))
    else
        MarkFail(key, registry, tostring(result):sub(1, 100))
    end

    return success, result
end

local function RunAllExecution(target)
    for _, strat in ipairs(ExecutionStrategies) do
        RunExecutionStrategy(strat.key, target)
    end
    LastResult.phase = "execution"
    LastResult.strategy = "ALL"
    LastResult.success = true
    LastResult.resultText = "All execution strategies attempted"
end

--============================================================================
-- TWEAKDB LINKAGE PHASE (C1-C3)
--============================================================================

local function RunTweakDBStrategy(key)
    local registry = TweakDBRegistry
    Regen(key, registry, TweakDBOrder)

    local result = nil
    local success = false

    if key == "C1" then
        success, result = SafeCall(function()
            local found = {}
            for _, effectId in ipairs(EmpEffectIDs) do
                local rec = TweakDB:GetRecord(effectId)
                if rec then
                    local packages = {}
                    local ok, pkg = pcall(function() return rec:GetPackages() end)
                    if ok and pkg then
                        for i = 0, 19 do
                            local ok_pkg, pkg_val = pcall(function() return pkg[i] end)
                            if ok_pkg and pkg_val then
                                table.insert(packages, tostring(pkg_val))
                            end
                        end
                    end
                    table.insert(found, { id = effectId, exists = true, packages = packages })
                else
                    table.insert(found, { id = effectId, exists = false })
                end
            end
            return found
        end)

    elseif key == "C2" then
        success, result = SafeCall(function()
            local found = {}
            for _, effectId in ipairs({"Attacks.QuickHack.EMP", "Attacks.QuickHack.EMPExplosion", "Attacks.QuickHack.Overload"}) do
                local rec = TweakDB:GetRecord(effectId)
                if rec then
                    table.insert(found, { id = effectId, exists = true, record = tostring(rec):sub(1, 100) })
                else
                    table.insert(found, { id = effectId, exists = false })
                end
            end
            return found
        end)

    elseif key == "C3" then
        success, result = SafeCall(function()
            local found = {}
            local searchTerms = {"EMP", "EMPExplosion", "VisualEffectAtTarget"}
            for _, term in ipairs(searchTerms) do
                local rec = TweakDB:GetRecord("BaseStatusEffect." .. term)
                if rec then
                    table.insert(found, { term = term, record = tostring(rec):sub(1, 100) })
                end
            end
            return found
        end)
    end

    if success then
        MarkSuccess(key, registry, tostring(result):sub(1, 150))
    else
        MarkFail(key, registry, tostring(result):sub(1, 150))
    end

    return success, result
end

local function RunAllTweakDB()
    for _, strat in ipairs(TweakDBStrategies) do
        RunTweakDBStrategy(strat.key)
    end
    LastResult.phase = "tweakdb"
    LastResult.strategy = "ALL"
    LastResult.success = true
    LastResult.resultText = "All TweakDB strategies attempted"
end

--============================================================================
-- IMGUI WINDOW
--============================================================================

local function DrawRegistryTable(title, registry, order, strategies)
    ImGui.Text(title)
    ImGui.Separator()

    if #order == 0 then
        ImGui.Text("  (no strategies attempted yet)")
        return
    end

    for _, key in ipairs(order) do
        local entry = registry[key]
        if entry then
            local strat = nil
            for _, s in ipairs(strategies) do
                if s.key == key then strat = s break end
            end

            local mark = "?"
            if entry.successes > 0 then mark = "*" elseif entry.attempts > 0 then mark = "." end

            local label = strat and strat.label or key
            local line = string.format("  [%s] %-55s | att=%d ok=%d | %s",
                mark, label:sub(1, 55), entry.attempts, entry.successes,
                entry.lastResult:sub(1, 60))

            if entry.successes > 0 then
                ImGui.PushStyleColor(ImGuiCol.Text, 0xFF00FF00)
            else
                ImGui.PushStyleColor(ImGuiCol.Text, 0xFF888888)
            end
            ImGui.Text(line)
            ImGui.PopStyleColor()
        end
    end
    ImGui.Separator()
end

local function DrawWindow()
    if not windowVisible then return end

    ImGui.SetNextWindowSize(Config.windowWidth, 720, ImGuiCond.FirstUseEver)
    ImGui.Begin(ModName .. " - EffectExecutor_Scripted Tester", windowVisible)

    if Scan.entity then
        ImGui.Text("Target: " .. (Scan.targetName or "unknown"))
        ImGui.Text("  Class: " .. (Scan.className or "unknown") .. "  Distance: " .. string.format("%.1fm", Scan.distance or 0))
        ImGui.Text("  EntityID: " .. (Scan.entityHash or "unknown"))
    else
        ImGui.Text("No target detected. Look at a device and press F8 to scan.")
    end
    ImGui.Separator()

    ImGui.Text("EffectExecutor_Scripted Class Catalog:")
    for i, cls in ipairs(EffectExecutorClasses) do
        local line = string.format("  %-2d %-45s F=%d M=%d %s", i, cls.className:sub(1, 45), cls.fields, cls.methods, cls.label)
        ImGui.Text(line)
    end
    ImGui.Separator()

    DrawRegistryTable("Construction Strategies (A1-A9):", ConstructionRegistry, ConstructionOrder, ConstructionStrategies)
    DrawRegistryTable("Execution Strategies (B1-B5):", ExecutionRegistry, ExecutionOrder, ExecutionStrategies)
    DrawRegistryTable("TweakDB Linkage Strategies (C1-C3):", TweakDBRegistry, TweakDBOrder, TweakDBStrategies)

    if LastResult.strategy then
        ImGui.Separator()
        ImGui.Text("Last Result:")
        ImGui.Text(string.format("  Phase: %s  Strategy: %s  Success: %s",
            LastResult.phase or "-", LastResult.strategy or "-", tostring(LastResult.success)))
        ImGui.Text("  " .. (LastResult.resultText or "-"))
    end

    ImGui.Separator()
    ImGui.Text("Hotkeys: F8=Scan  F9=Construction  F10=Execution  F11=TweakDB  F12=Toggle Window")

    ImGui.End()
end

--============================================================================
-- UPDATE / INIT
--============================================================================

registerForEvent("onInit", function()
    if Config.debug then print('[' .. ModName .. '] Initialized') end
end)

registerForEvent("onDraw", function()
    DrawWindow()
end)

--============================================================================
-- ROOT LEVEL HOTKEYS (MUST be at file root, not inside onInit)
--============================================================================

registerHotkey("SE_DEV5_SCAN", "Scan Target Device", function()
    local target = GetLookAtDevice()
    if target then
        Scan = ScanTarget(target) or Scan
        if Config.debug then print('[' .. ModName .. '] Scanned: ' .. (Scan.className or "unknown")) end
        LastResult.phase = "scan"
        LastResult.strategy = "SCAN"
        LastResult.success = true
        LastResult.resultText = "Scanned " .. (Scan.targetName or "unknown")
    else
        Scan = { entity = nil, typeName = nil, targetName = nil, className = nil, distance = nil, recordID = nil, entityHash = nil, ps = nil }
        LastResult.phase = "scan"
        LastResult.strategy = "SCAN"
        LastResult.success = false
        LastResult.resultText = "No target found"
        if Config.debug then print('[' .. ModName .. '] No target found') end
    end
end)

registerHotkey("SE_DEV5_CONSTRUCT", "Run Construction Strategies", function()
    RunAllConstruction()
    if Config.debug then print('[' .. ModName .. '] Construction strategies done') end
end)

registerHotkey("SE_DEV5_EXECUTE", "Run Execution Strategies", function()
    local target = Scan.entity or GetLookAtDevice()
    if not target then
        if Config.debug then print('[' .. ModName .. '] No target for execution') end
        LastResult.phase = "execution"
        LastResult.strategy = "NONE"
        LastResult.success = false
        LastResult.resultText = "No target found - scan first (F8)"
        return
    end
    RunAllExecution(target)
    if Config.debug then print('[' .. ModName .. '] Execution strategies done') end
end)

registerHotkey("SE_DEV5_TWEAKDB", "Run TweakDB Strategies", function()
    RunAllTweakDB()
    if Config.debug then print('[' .. ModName .. '] TweakDB strategies done') end
end)

registerHotkey("SE_DEV5_TOGGLE_WINDOW", "Toggle Info Window", function()
    windowVisible = not windowVisible
end)
