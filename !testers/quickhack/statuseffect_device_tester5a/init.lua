--[[
  Status Effect Device Tester 5a - CET (Lua)
  EffectExecutor_Scripted Class Investigation

  Based on tester5 but with comprehensive print() logging at every step.
  All prints are unconditional (not gated behind Config.debug) so the
  CET log captures full diagnostic output for analysis.

  Strategy matrix:
    A. Construct effect objects via multiple CET approaches (A1-A9)
    B. Execute effects via status effect application (B1-B5)
    C. Investigate TweakDB linkage (C1-C3)

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester5a/

  Bind hotkeys in: Settings > Key Bindings > SEDevT5a
--]]

local ModName = "SEDevT5a"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    maxDistance = 20.0,
    windowWidth = 1000,
}

--============================================================================
-- LOGGING UTILITY
--============================================================================

local function Log(msg)
    print('[' .. ModName .. '] ' .. tostring(msg))
end

local function LogErr(msg)
    print('[' .. ModName .. '] ERR: ' .. tostring(msg))
end

local function LogPhase(phase, msg)
    print('[' .. ModName .. '] [' .. phase .. '] ' .. tostring(msg))
end

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
    Log('  SafeCall: invoking function...')
    local result = {pcall(fn, ...)}
    if result[1] then
        Log('  SafeCall: SUCCESS, returned: ' .. tostring(result[2]):sub(1, 150))
        return true, result[2]
    else
        local err = tostring(result[2] or 'unknown error')
        local short = err:sub(1, 200)
        LogErr('SafeCall failed: ' .. short)
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
    LogPhase('SCAN', 'GetLookAtDevice: starting target detection...')
    local player = Game.GetPlayer()
    if not player then
        LogErr('GetLookAtDevice: Game.GetPlayer() returned nil')
        return nil
    end
    LogPhase('SCAN', 'GetLookAtDevice: player found: ' .. tostring(player))

    local searchQuery = nil
    LogPhase('SCAN', 'GetLookAtDevice: creating gameTargetSearchQuery...')
    pcall(function() searchQuery = NewObject('gameTargetSearchQuery') end)
    if not searchQuery then
        LogErr('GetLookAtDevice: Could not create gameTargetSearchQuery')
        return nil
    end
    LogPhase('SCAN', 'GetLookAtDevice: searchQuery created: ' .. tostring(searchQuery))

    local filter = nil
    LogPhase('SCAN', 'GetLookAtDevice: creating TSF_Quickhackable filter...')
    pcall(function() filter = Game["TSF_Quickhackable;"]() end)
    if not filter then
        LogPhase('SCAN', 'GetLookAtDevice: first filter attempt failed, trying as property...')
        pcall(function() filter = Game["TSF_Quickhackable;"] end)
    end
    if not filter then
        LogErr('GetLookAtDevice: Could not create TSF_Quickhackable filter')
        return nil
    end
    LogPhase('SCAN', 'GetLookAtDevice: filter created: ' .. tostring(filter))
    searchQuery.searchFilter = filter
    searchQuery.maxDistance = Config.maxDistance
    LogPhase('SCAN', 'GetLookAtDevice: searchFilter and maxDistance set (maxDist=' .. tostring(Config.maxDistance) .. ')')

    local target = nil
    LogPhase('SCAN', 'GetLookAtDevice: calling GetObjectClosestToCrosshair...')
    pcall(function()
        target = Game.GetTargetingSystem():GetObjectClosestToCrosshair(player, searchQuery)
    end)

    if not target or not IsDefined(target) then
        LogPhase('SCAN', 'GetLookAtDevice: no target found (nil or not defined)')
        return nil
    end

    LogPhase('SCAN', 'GetLookAtDevice: target found: ' .. tostring(target))
    return target
end

local function ScanTarget(target)
    LogPhase('SCAN', 'ScanTarget: starting scan of target: ' .. tostring(target))
    if not target then
        LogErr('ScanTarget: target is nil, aborting')
        return nil
    end

    local scan = {}
    scan.entity = target

    LogPhase('SCAN', 'ScanTarget: reading GetWorldPosition...')
    local ok1, pos = SafeCall(function() return target:GetWorldPosition() end)
    LogPhase('SCAN', 'ScanTarget: position = ' .. (ok1 and tostring(pos) or 'FAILED'))

    LogPhase('SCAN', 'ScanTarget: reading GetDisplayName...')
    local ok2, name = SafeCall(function() return target:GetDisplayName() end)
    LogPhase('SCAN', 'ScanTarget: displayName = ' .. (ok2 and tostring(name) or 'FAILED'))

    LogPhase('SCAN', 'ScanTarget: reading GetClassName...')
    local ok3, cname = SafeCall(function() return target:GetClassName() end)
    LogPhase('SCAN', 'ScanTarget: className = ' .. (ok3 and tostring(cname) or 'FAILED'))

    LogPhase('SCAN', 'ScanTarget: reading GetEntityID...')
    local ok4, eid = SafeCall(function() return target:GetEntityID() end)
    LogPhase('SCAN', 'ScanTarget: entityID = ' .. (ok4 and tostring(eid) or 'FAILED'))

    local player = Game.GetPlayer()
    local ppos = player and player:GetWorldPosition() or Vector4.new(0, 0, 0, 1)
    LogPhase('SCAN', 'ScanTarget: player position = ' .. tostring(ppos))
    local dist = 0
    if ok1 and pos then
        local dx = pos.x - ppos.x
        local dy = pos.y - ppos.y
        local dz = pos.z - ppos.z
        dist = math.sqrt(dx*dx + dy*dy + dz*dz)
    end
    LogPhase('SCAN', 'ScanTarget: computed distance = ' .. string.format('%.2f', dist) .. 'm')

    scan.targetName = (ok2 and name) and tostring(name) or "unknown"
    scan.className = (ok3 and cname) and CNameToString(cname) or "unknown"
    scan.distance = dist
    scan.entityHash = (ok4 and eid) and tostring(eid) or "unknown"

    LogPhase('SCAN', 'ScanTarget: trying GetDevicePS...')
    local ok5, ps = SafeCall(function() return target:GetDevicePS() end)
    if not ok5 then
        LogPhase('SCAN', 'ScanTarget: GetDevicePS failed, trying GetPS...')
        ok5, ps = SafeCall(function() return target:GetPS() end)
    end
    scan.ps = (ok5 and ps) or nil
    LogPhase('SCAN', 'ScanTarget: PS = ' .. (scan.ps and tostring(scan.ps) or 'nil'))

    LogPhase('SCAN', 'ScanTarget: scan complete -- name=' .. scan.targetName .. ' class=' .. scan.className .. ' dist=' .. string.format('%.1f', scan.distance) .. 'm')
    return scan
end

--============================================================================
-- CONSTRUCTION PHASE (A1-A9)
--============================================================================

local function RunConstructionStrategy(key)
    LogPhase('CONSTRUCT', '--- Starting ' .. key .. ' ---')
    local registry = ConstructionRegistry
    Regen(key, registry, ConstructionOrder)

    local result = nil
    local success = false

    if key == "A1" then
        LogPhase('CONSTRUCT', key .. ': attempting NewObject("gameEffectData")')
        success, result = SafeCall(function() return NewObject("gameEffectData") end)

    elseif key == "A2" then
        LogPhase('CONSTRUCT', key .. ': attempting NewObject("EffectExecutor_VisualEffectAtTarget")')
        success, result = SafeCall(function() return NewObject("EffectExecutor_VisualEffectAtTarget") end)

    elseif key == "A3" then
        LogPhase('CONSTRUCT', key .. ': attempting NewObject("EMP")')
        success, result = SafeCall(function() return NewObject("EMP") end)

    elseif key == "A4" then
        LogPhase('CONSTRUCT', key .. ': attempting NewObject("EMPExplosion")')
        success, result = SafeCall(function() return NewObject("EMPExplosion") end)

    elseif key == "A5" then
        LogPhase('CONSTRUCT', key .. ': attempting gameEffectData.new()')
        success, result = SafeCall(function() return gameEffectData.new() end)

    elseif key == "A6" then
        LogPhase('CONSTRUCT', key .. ': attempting EffectExecutor_VisualEffectAtTarget.new()')
        success, result = SafeCall(function() return EffectExecutor_VisualEffectAtTarget.new() end)

    elseif key == "A7" then
        LogPhase('CONSTRUCT', key .. ': attempting Game.GetEffectSystem()')
        success, result = SafeCall(function() return Game.GetEffectSystem() end)

    elseif key == "A8" then
        LogPhase('CONSTRUCT', key .. ': attempting Game.GetScriptableSystem("EffectSystem")')
        success, result = SafeCall(function() return Game.GetScriptableSystem("EffectSystem") end)
        if not success or not result then
            LogPhase('CONSTRUCT', key .. ': first attempt failed/nil, trying Game.GetScriptableSystem("IEffectSystem")')
            success, result = SafeCall(function() return Game.GetScriptableSystem("IEffectSystem") end)
        end

    elseif key == "A9" then
        LogPhase('CONSTRUCT', key .. ': querying TweakDB for EMP/BaseEMP/OverloadEMP records')
        success, result = SafeCall(function()
            local found = {}
            for _, effectId in ipairs({"BaseStatusEffect.EMP", "BaseStatusEffect.BaseEMP", "BaseStatusEffect.OverloadEMP"}) do
                LogPhase('CONSTRUCT', key .. ': TweakDB:GetRecord("' .. effectId .. '")')
                local rec = TweakDB:GetRecord(effectId)
                if rec then
                    LogPhase('CONSTRUCT', key .. ':   record found: ' .. tostring(rec):sub(1, 100))
                    table.insert(found, { id = effectId, record = tostring(rec), found = true })
                else
                    LogPhase('CONSTRUCT', key .. ':   record NOT found (nil)')
                    table.insert(found, { id = effectId, record = nil, found = false })
                end
            end
            return found
        end)
    end

    if success then
        local resultStr = tostring(result):sub(1, 150)
        LogPhase('CONSTRUCT', key .. ': SUCCESS -- ' .. resultStr)
        MarkSuccess(key, registry, resultStr)
    else
        local resultStr = tostring(result):sub(1, 150)
        LogPhase('CONSTRUCT', key .. ': FAILED -- ' .. resultStr)
        MarkFail(key, registry, resultStr)
    end

    return success, result
end

local function RunAllConstruction()
    LogPhase('CONSTRUCT', '========== Running ALL construction strategies A1-A9 ==========')
    for _, strat in ipairs(ConstructionStrategies) do
        RunConstructionStrategy(strat.key)
    end

    -- Phase summary
    LogPhase('CONSTRUCT', '========== Construction Phase Summary ==========')
    for _, key in ipairs(ConstructionOrder) do
        local entry = ConstructionRegistry[key]
        if entry then
            LogPhase('CONSTRUCT', '  ' .. key .. ': attempts=' .. entry.attempts .. ' successes=' .. entry.successes .. ' lastResult=' .. entry.lastResult)
        end
    end

    LastResult.phase = "construction"
    LastResult.strategy = "ALL"
    LastResult.success = true
    LastResult.resultText = "All construction strategies attempted"
    LogPhase('CONSTRUCT', '========== Construction Phase Done ==========')
end

--============================================================================
-- EXECUTION PHASE (B1-B5)
--============================================================================

local function RunExecutionStrategy(key, target)
    LogPhase('EXECUTE', '--- Starting ' .. key .. ' ---')
    local registry = ExecutionRegistry
    Regen(key, registry, ExecutionOrder)

    local player = Game.GetPlayer()
    LogPhase('EXECUTE', key .. ': player = ' .. tostring(player))
    LogPhase('EXECUTE', key .. ': target = ' .. tostring(target))
    local result = nil
    local success = false

    if key == "B1" then
        LogPhase('EXECUTE', key .. ': ApplyStatusEffect(target, BaseStatusEffect.EMP, player)')
        success, result = SafeCall(function()
            return StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new("BaseStatusEffect.EMP"), player)
        end)

    elseif key == "B2" then
        LogPhase('EXECUTE', key .. ': ApplyStatusEffect(player, BaseStatusEffect.EMP, player) -- point-based at player pos')
        success, result = SafeCall(function()
            return StatusEffectHelper.ApplyStatusEffect(player, TweakDBID.new("BaseStatusEffect.EMP"), player)
        end)

    elseif key == "B3" then
        LogPhase('EXECUTE', key .. ': ApplyStatusEffect(target, BaseStatusEffect.OverloadEMP, player)')
        success, result = SafeCall(function()
            return StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new("BaseStatusEffect.OverloadEMP"), player)
        end)

    elseif key == "B4" then
        LogPhase('EXECUTE', key .. ': ApplyStatusEffect(target, BaseStatusEffect.BaseOverload, player)')
        success, result = SafeCall(function()
            return StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new("BaseStatusEffect.BaseOverload"), player)
        end)

    elseif key == "B5" then
        LogPhase('EXECUTE', key .. ': ApplyStatusEffect(target, BaseStatusEffect.BaseEMP, player)')
        success, result = SafeCall(function()
            return StatusEffectHelper.ApplyStatusEffect(target, TweakDBID.new("BaseStatusEffect.BaseEMP"), player)
        end)
    end

    LogPhase('EXECUTE', key .. ': ApplyStatusEffect returned success=' .. tostring(success) .. ' result=' .. tostring(result))

    -- Verification: check if target actually has the status effect
    if success and target then
        LogPhase('EXECUTE', key .. ': verifying with ObjectHasStatusEffect(target, BaseStatusEffect.EMP)...')
        local ok2, hasEffect = SafeCall(function()
            return StatusEffectSystem.ObjectHasStatusEffect(target, TweakDBID.new("BaseStatusEffect.EMP"))
        end)
        if ok2 then
            LogPhase('EXECUTE', key .. ': ObjectHasStatusEffect(EMP) = ' .. tostring(hasEffect))
            result = tostring(result) .. " | HasEffect=" .. tostring(hasEffect)
        else
            LogPhase('EXECUTE', key .. ': ObjectHasStatusEffect check FAILED')
        end

        -- Also check the specific effect for B3-B5
        local checkIds = {
            ["B3"] = "BaseStatusEffect.OverloadEMP",
            ["B4"] = "BaseStatusEffect.BaseOverload",
            ["B5"] = "BaseStatusEffect.BaseEMP",
        }
        if checkIds[key] then
            LogPhase('EXECUTE', key .. ': verifying with ObjectHasStatusEffect(target, ' .. checkIds[key] .. ')...')
            local ok3, hasEffect2 = SafeCall(function()
                return StatusEffectSystem.ObjectHasStatusEffect(target, TweakDBID.new(checkIds[key]))
            end)
            if ok3 then
                LogPhase('EXECUTE', key .. ': ObjectHasStatusEffect(' .. checkIds[key] .. ') = ' .. tostring(hasEffect2))
                result = tostring(result) .. " | HasEffect_Specific=" .. tostring(hasEffect2)
            else
                LogPhase('EXECUTE', key .. ': specific ObjectHasStatusEffect check FAILED')
            end
        end
    end

    if success then
        local resultStr = tostring(result):sub(1, 150)
        LogPhase('EXECUTE', key .. ': SUCCESS -- ' .. resultStr)
        MarkSuccess(key, registry, resultStr)
    else
        local resultStr = tostring(result):sub(1, 150)
        LogPhase('EXECUTE', key .. ': FAILED -- ' .. resultStr)
        MarkFail(key, registry, resultStr)
    end

    return success, result
end

local function RunAllExecution(target)
    LogPhase('EXECUTE', '========== Running ALL execution strategies B1-B5 ==========')
    LogPhase('EXECUTE', 'Target: ' .. tostring(target))
    for _, strat in ipairs(ExecutionStrategies) do
        RunExecutionStrategy(strat.key, target)
    end

    -- Phase summary
    LogPhase('EXECUTE', '========== Execution Phase Summary ==========')
    for _, key in ipairs(ExecutionOrder) do
        local entry = ExecutionRegistry[key]
        if entry then
            LogPhase('EXECUTE', '  ' .. key .. ': attempts=' .. entry.attempts .. ' successes=' .. entry.successes .. ' lastResult=' .. entry.lastResult)
        end
    end

    LastResult.phase = "execution"
    LastResult.strategy = "ALL"
    LastResult.success = true
    LastResult.resultText = "All execution strategies attempted"
    LogPhase('EXECUTE', '========== Execution Phase Done ==========')
end

--============================================================================
-- TWEAKDB LINKAGE PHASE (C1-C3)
--============================================================================

local function RunTweakDBStrategy(key)
    LogPhase('TWEAKDB', '--- Starting ' .. key .. ' ---')
    local registry = TweakDBRegistry
    Regen(key, registry, TweakDBOrder)

    local result = nil
    local success = false

    if key == "C1" then
        LogPhase('TWEAKDB', key .. ': dumping StatusEffect packages for all EmpEffectIDs')
        success, result = SafeCall(function()
            local found = {}
            for _, effectId in ipairs(EmpEffectIDs) do
                LogPhase('TWEAKDB', key .. ': TweakDB:GetRecord("' .. effectId .. '")')
                local rec = TweakDB:GetRecord(effectId)
                if rec then
                    LogPhase('TWEAKDB', key .. ':   record found, reading GetPackages()...')
                    local packages = {}
                    local ok, pkg = pcall(function() return rec:GetPackages() end)
                    if ok and pkg then
                        LogPhase('TWEAKDB', key .. ':   GetPackages() returned: ' .. tostring(pkg))
                        for i = 0, 19 do
                            local ok_pkg, pkg_val = pcall(function() return pkg[i] end)
                            if ok_pkg and pkg_val then
                                local pkgStr = tostring(pkg_val)
                                LogPhase('TWEAKDB', key .. ':     package[' .. i .. '] = ' .. pkgStr)
                                table.insert(packages, pkgStr)
                            end
                        end
                    else
                        LogPhase('TWEAKDB', key .. ':   GetPackages() failed or nil')
                    end
                    table.insert(found, { id = effectId, exists = true, packages = packages })
                else
                    LogPhase('TWEAKDB', key .. ':   record NOT found')
                    table.insert(found, { id = effectId, exists = false })
                end
            end
            return found
        end)

    elseif key == "C2" then
        LogPhase('TWEAKDB', key .. ': dumping Attack_GameEffect records')
        success, result = SafeCall(function()
            local found = {}
            for _, effectId in ipairs({"Attacks.QuickHack.EMP", "Attacks.QuickHack.EMPExplosion", "Attacks.QuickHack.Overload"}) do
                LogPhase('TWEAKDB', key .. ': TweakDB:GetRecord("' .. effectId .. '")')
                local rec = TweakDB:GetRecord(effectId)
                if rec then
                    local recStr = tostring(rec):sub(1, 100)
                    LogPhase('TWEAKDB', key .. ':   record found: ' .. recStr)
                    table.insert(found, { id = effectId, exists = true, record = recStr })
                else
                    LogPhase('TWEAKDB', key .. ':   record NOT found')
                    table.insert(found, { id = effectId, exists = false })
                end
            end
            return found
        end)

    elseif key == "C3" then
        LogPhase('TWEAKDB', key .. ': searching for StatusEffectExecutor records referencing EMP/VisualEffectAtTarget')
        success, result = SafeCall(function()
            local found = {}
            local searchTerms = {"EMP", "EMPExplosion", "VisualEffectAtTarget"}
            for _, term in ipairs(searchTerms) do
                local fullId = "BaseStatusEffect." .. term
                LogPhase('TWEAKDB', key .. ': TweakDB:GetRecord("' .. fullId .. '")')
                local rec = TweakDB:GetRecord(fullId)
                if rec then
                    local recStr = tostring(rec):sub(1, 100)
                    LogPhase('TWEAKDB', key .. ':   record found for term "' .. term .. '": ' .. recStr)
                    table.insert(found, { term = term, record = recStr })
                else
                    LogPhase('TWEAKDB', key .. ':   record NOT found for term "' .. term .. '"')
                end
            end
            return found
        end)
    end

    if success then
        local resultStr = tostring(result):sub(1, 150)
        LogPhase('TWEAKDB', key .. ': SUCCESS -- ' .. resultStr)
        MarkSuccess(key, registry, resultStr)
    else
        local resultStr = tostring(result):sub(1, 150)
        LogPhase('TWEAKDB', key .. ': FAILED -- ' .. resultStr)
        MarkFail(key, registry, resultStr)
    end

    return success, result
end

local function RunAllTweakDB()
    LogPhase('TWEAKDB', '========== Running ALL TweakDB strategies C1-C3 ==========')
    for _, strat in ipairs(TweakDBStrategies) do
        RunTweakDBStrategy(strat.key)
    end

    -- Phase summary
    LogPhase('TWEAKDB', '========== TweakDB Phase Summary ==========')
    for _, key in ipairs(TweakDBOrder) do
        local entry = TweakDBRegistry[key]
        if entry then
            LogPhase('TWEAKDB', '  ' .. key .. ': attempts=' .. entry.attempts .. ' successes=' .. entry.successes .. ' lastResult=' .. entry.lastResult)
        end
    end

    LastResult.phase = "tweakdb"
    LastResult.strategy = "ALL"
    LastResult.success = true
    LastResult.resultText = "All TweakDB strategies attempted"
    LogPhase('TWEAKDB', '========== TweakDB Phase Done ==========')
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
    Log('Initialized (tester5a with full print logging)')
end)

registerForEvent("onDraw", function()
    DrawWindow()
end)

--============================================================================
-- ROOT LEVEL HOTKEYS (MUST be at file root, not inside onInit)
--============================================================================

registerHotkey("SE_DEV5A_SCAN", "SEDevT5a: Scan Target Device", function()
    Log('======== HOTKEY: SCAN (F8) ========')
    local target = GetLookAtDevice()
    if target then
        Scan = ScanTarget(target) or Scan
        Log('Scanned: ' .. (Scan.className or "unknown") .. ' (name=' .. (Scan.targetName or "?") .. ')')
        LastResult.phase = "scan"
        LastResult.strategy = "SCAN"
        LastResult.success = true
        LastResult.resultText = "Scanned " .. (Scan.targetName or "unknown")
    else
        Log('SCAN: No target found')
        Scan = { entity = nil, typeName = nil, targetName = nil, className = nil, distance = nil, recordID = nil, entityHash = nil, ps = nil }
        LastResult.phase = "scan"
        LastResult.strategy = "SCAN"
        LastResult.success = false
        LastResult.resultText = "No target found"
    end
    Log('======== HOTKEY: SCAN DONE ========')
end)

registerHotkey("SE_DEV5A_CONSTRUCT", "SEDevT5a: Run Construction Strategies", function()
    Log('======== HOTKEY: CONSTRUCT (F9) ========')
    RunAllConstruction()
    Log('======== HOTKEY: CONSTRUCT DONE ========')
end)

registerHotkey("SE_DEV5A_EXECUTE", "SEDevT5a: Run Execution Strategies", function()
    Log('======== HOTKEY: EXECUTE (F10) ========')
    local target = Scan.entity or GetLookAtDevice()
    if not target then
        LogErr('EXECUTE: No target for execution -- scan first (F8)')
        LastResult.phase = "execution"
        LastResult.strategy = "NONE"
        LastResult.success = false
        LastResult.resultText = "No target found - scan first (F8)"
        Log('======== HOTKEY: EXECUTE ABORTED (no target) ========')
        return
    end
    Log('EXECUTE: using target: ' .. tostring(target))
    RunAllExecution(target)
    Log('======== HOTKEY: EXECUTE DONE ========')
end)

registerHotkey("SE_DEV5A_TWEAKDB", "SEDevT5a: Run TweakDB Strategies", function()
    Log('======== HOTKEY: TWEAKDB (F11) ========')
    RunAllTweakDB()
    Log('======== HOTKEY: TWEAKDB DONE ========')
end)

registerHotkey("SE_DEV5A_TOGGLE_WINDOW", "SEDevT5a: Toggle Info Window", function()
    Log('======== HOTKEY: TOGGLE WINDOW (F12) ========')
    windowVisible = not windowVisible
    Log('Window visibility toggled: ' .. tostring(windowVisible))
end)
