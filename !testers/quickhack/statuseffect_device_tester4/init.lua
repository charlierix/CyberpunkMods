--[[
  Status Effect Device Tester 4 - CET (Lua)
  DeviceOperations Pipeline Investigation

  Focus: Access and trigger DeviceOperations directly from CET.
  Based on device hack summary.md suggestion #2:
    "Investigate DeviceOperations pipeline access from CET
     Research DeviceOperationsComponent API in okf
     Try accessing device operations container and triggering operations directly
     Key operations: PlayEffectDeviceOperation, ApplyDamageDeviceOperation, StimDeviceOperation"

  Strategy matrix:
    A. Access DeviceOperationsContainer from PS (ps:GetDeviceOperations, field access)
    B. Access DeviceOperationsComponent from entity (FindComponentByName, GetComponent)
    C. Enumerate operations array on container
    D. Execute operations via multiple methods:
       D1. ToggleOperation on component (index, enable)
       D2. Execute on operation object directly
       D3. ToggleOperationEvent dispatch via QueuePSDeviceEvent
       D4. SetDelayIdOnOperation + trigger

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/statuseffect_device_tester4/

  Bind hotkeys in: Settings > Key Bindings > SEDevT4
--]]

local ModName = "SEDevT4"

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
-- [accessStrategy] = { attempts=, successes=, lastResult= }
local AccessRegistry = {}
local AccessOrder = {}

-- [opIndex_className] = { attempts=, successes=, lastResult= }
local OpRegistry = {}
local OpOrder = {}

local reportedDeviceTypes = {}

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
    container  = nil,   -- DeviceOperationsContainer if found
    component  = nil,   -- DeviceOperationsComponent if found
    operations = {},     -- enumerated operation descriptors
}

local SelectedOpIndex = 1  -- currently selected operation for F10 execution

local LastResult = {
    strategy  = nil,
    opLabel   = nil,
    success   = nil,
    resultText = nil,
}

-- Cached operations for current target
local CachedTarget = {
    entity    = nil,
    className = "",
    container = nil,
    component = nil,
    operations = {},
}

--============================================================================
-- HELPERS
--============================================================================

local function dprint(msg)
    if Config.debug then
        print(string.format("[%s] %s", ModName, msg))
    end
end

local function ErrorHandler(err)
    local info = debug.getinfo(2, "Sl")
    local loc = ""
    if info and info.short_src then
        loc = string.format(" at %s:%d", info.short_src, info.currentline or 0)
    end
    return string.format("%s%s", tostring(err), loc)
end

local function SafeCall(fn, ...)
    local results = table.pack(xpcall(fn, ErrorHandler, ...))
    local ok = results[1]
    if ok then
        return true, table.unpack(results, 2, results.n)
    else
        return false, results[2]
    end
end

local function CNameToString(cname)
    if not cname then return "<nil>" end
    local s = tostring(cname)
    if type(s) == "string" then
        local name = s:match("%-%-%[%[(.-)%]%]%-%-")
        if name and name ~= "" then return name end
        if not s:match("^ToCName") and #s < 64 then return s end
    end
    local fmt = nil
    pcall(function() fmt = string.format("%s", cname) end)
    if fmt and type(fmt) == "string" then
        local name = fmt:match("%-%-%[%[(.-)%]%]%-%-")
        if name and name ~= "" then return name end
        if not fmt:match("^ToCName") and #fmt < 64 then return fmt end
    end
    local concat = nil
    pcall(function() concat = "" .. cname end)
    if concat and type(concat) == "string" then
        local name = concat:match("%-%-%[%[(.-)%]%]%-%-")
        if name and name ~= "" then return name end
        if not concat:match("^ToCName") and #concat < 64 then return concat end
    end
    return s or "<unknown>"
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
-- TARGETING
--============================================================================

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
        return nil, nil
    end

    local ps = nil
    pcall(function() ps = target:GetDevicePS() end)
    if not ps then
        return nil, nil
    end

    return target, ps
end

--============================================================================
-- STRATEGY A: ACCESS DeviceOperationsContainer FROM PS
--============================================================================

local function TryGetContainerFromPS(ps)
    -- Strategy A1: ps:GetDeviceOperations()
    local ok1, result1 = SafeCall(function() return ps:GetDeviceOperations() end)
    if ok1 and result1 and IsDefined(result1) then
        return result1, "A1:GetDeviceOperations()"
    end

    -- Strategy A2: ps:GetOperations()
    local ok2, result2 = SafeCall(function() return ps:GetOperations() end)
    if ok2 and result2 and IsDefined(result2) then
        return result2, "A2:GetOperations()"
    end

    -- Strategy A3: ps.operationsContainer field
    local ok3, result3 = SafeCall(function() return ps.operationsContainer end)
    if ok3 and result3 and IsDefined(result3) then
        return result3, "A3:ps.operationsContainer"
    end

    -- Strategy A4: ps.deviceOperations field
    local ok4, result4 = SafeCall(function() return ps.deviceOperations end)
    if ok4 and result4 and IsDefined(result4) then
        return result4, "A4:ps.deviceOperations"
    end

    -- Strategy A5: ps:GetComponentByName("DeviceOperationsComponent")
    local ok5, result5 = SafeCall(function()
        return ps:GetComponentByName("DeviceOperationsComponent")
    end)
    if ok5 and result5 and IsDefined(result5) then
        return result5, "A5:ps:GetComponentByName"
    end

    return nil, nil
end

--============================================================================
-- STRATEGY B: ACCESS DeviceOperationsComponent FROM ENTITY
--============================================================================

local function TryGetComponentFromEntity(entity)
    -- Strategy B1: entity:FindComponentByName("DeviceOperationsComponent")
    local ok1, result1 = SafeCall(function()
        return entity:FindComponentByName("DeviceOperationsComponent")
    end)
    if ok1 and result1 and IsDefined(result1) then
        return result1, "B1:FindComponentByName"
    end

    -- Strategy B2: entity:FindComponentByClassName("DeviceOperationsComponent")
    local ok2, result2 = SafeCall(function()
        return entity:FindComponentByClassName("DeviceOperationsComponent")
    end)
    if ok2 and result2 and IsDefined(result2) then
        return result2, "B2:FindComponentByClassName"
    end

    -- Strategy B3: entity:GetComponent("DeviceOperationsComponent")
    local ok3, result3 = SafeCall(function()
        return entity:GetComponent("DeviceOperationsComponent")
    end)
    if ok3 and result3 and IsDefined(result3) then
        return result3, "B3:GetComponent"
    end

    -- Strategy B4: entity:GetDeviceComponent() then query operations
    local ok4, result4 = SafeCall(function()
        local comp = entity:GetDeviceComponent()
        if comp then
            -- Try to get operations from the device component
            local ops = comp:GetDeviceOperations()
            if ops and IsDefined(ops) then return ops end
        end
        return nil
    end)
    if ok4 and result4 and IsDefined(result4) then
        return result4, "B4:DeviceComp:GetDeviceOperations"
    end

    -- Strategy B5: entity:GetComponentByClassName CName
    local ok5, result5 = SafeCall(function()
        local cname = CName.new("DeviceOperationsComponent")
        return entity:FindComponentByClassName(cname)
    end)
    if ok5 and result5 and IsDefined(result5) then
        return result5, "B5:FindComponentByClassName(CName)"
    end

    return nil, nil
end

--============================================================================
-- STRATEGY C: ENUMERATE OPERATIONS FROM CONTAINER
--============================================================================

local function EnumerateOperations(container)
    if not container or not IsDefined(container) then return {} end

    local ops = {}

    -- Strategy C1: container.operations field (CArray<CHandle<DeviceOperationBase>>)
    local ok1, operationsArr = SafeCall(function() return container.operations end)
    if ok1 and operationsArr and type(operationsArr) == "table" then
        for i = 1, #operationsArr do
            local op = operationsArr[i]
            if op and IsDefined(op) then
                local className = "<unknown>"
                pcall(function() className = CNameToString(op:GetClassName()) end)
                local opName = "<none>"
                pcall(function()
                    -- Try to get operation name if available
                    local n = op:GetName()
                    if n then opName = CNameToString(n) end
                end)
                table.insert(ops, {
                    index     = i - 1,  -- 0-based for game API
                    className = className,
                    name      = opName,
                    operation = op,
                    source    = "C1:container.operations",
                })
            end
        end
        if #ops > 0 then return ops end
    end

    -- Strategy C2: container:GetOperations()
    local ok2, result2 = SafeCall(function() return container:GetOperations() end)
    if ok2 and result2 and type(result2) == "table" then
        for i = 1, #result2 do
            local op = result2[i]
            if op and IsDefined(op) then
                local className = "<unknown>"
                pcall(function() className = CNameToString(op:GetClassName()) end)
                table.insert(ops, {
                    index     = i - 1,
                    className = className,
                    name      = "<none>",
                    operation = op,
                    source    = "C2:container:GetOperations()",
                })
            end
        end
        if #ops > 0 then return ops end
    end

    -- Strategy C3: container:GetByIndex(0..19) brute-force scan
    for i = 0, 19 do
        local ok3, result3 = SafeCall(function() return container:GetByIndex(i) end)
        if ok3 and result3 and IsDefined(result3) then
            local className = "<unknown>"
            pcall(function() className = CNameToString(result3:GetClassName()) end)
            local opName = "<none>"
            pcall(function()
                local n = result3:GetName()
                if n then opName = CNameToString(n) end
            end)
            table.insert(ops, {
                index     = i,
                className = className,
                name      = opName,
                operation = result3,
                source    = "C3:GetByIndex",
            })
        else
            -- If index 0 fails, likely no operations
            if i == 0 then break end
        end
    end
    if #ops > 0 then return ops end

    -- Strategy C4: container:HasItem(i) + GetByIndex(i) pair scan
    for i = 0, 19 do
        local hasIt = false
        pcall(function()
            local ok, found = container:HasItem(i)
            if ok and found then hasIt = true end
        end)
        if hasIt then
            local ok4, result4 = SafeCall(function() return container:GetByIndex(i) end)
            if ok4 and result4 and IsDefined(result4) then
                local className = "<unknown>"
                pcall(function() className = CNameToString(result4:GetClassName()) end)
                table.insert(ops, {
                    index     = i,
                    className = className,
                    name      = "<none>",
                    operation = result4,
                    source    = "C4:HasItem+GetByIndex",
                })
            end
        end
    end

    return ops
end

--============================================================================
-- STRATEGY D: EXECUTE OPERATIONS
--============================================================================

-- D1: ToggleOperation on component (index, enable)
local function ExecuteToggleOperation(component, opIndex)
    if not component or not IsDefined(component) then return false, "no component" end

    -- Try ToggleOperation(index, true)
    local ok1, err1 = SafeCall(function() component:ToggleOperation(opIndex, true) end)
    if ok1 then return true, "ToggleOperation(idx, true) OK" end

    -- Try ToggleOperation(index, false)
    local ok2, err2 = SafeCall(function() component:ToggleOperation(opIndex, false) end)
    if ok2 then return true, "ToggleOperation(idx, false) OK" end

    return false, tostring(err1)
end

-- D2: Execute on operation object directly
local function ExecuteOperationDirect(op, game)
    if not op or not IsDefined(op) then return false, "no operation" end

    local className = "<unknown>"
    pcall(function() className = CNameToString(op:GetClassName()) end)

    -- Try Execute(game) — DeviceOperations base method
    local ok1, err1 = SafeCall(function() op:Execute(game) end)
    if ok1 then return true, "Execute(game) OK (" .. className .. ")" end

    -- Try Execute() with no args
    local ok2, err2 = SafeCall(function() op:Execute() end)
    if ok2 then return true, "Execute() OK (" .. className .. ")" end

    -- Try Restore(game)
    local ok3, err3 = SafeCall(function() op:Restore(game) end)
    if ok3 then return true, "Restore(game) OK (" .. className .. ")" end

    -- Try IsPossible / ResolveAction / StartAction lifecycle (DeviceOperationBase)
    local ok4 = SafeCall(function() op:IsPossible(game) end)
    if ok4 then
        local ok5 = SafeCall(function() op:ResolveAction(game) end)
        if ok5 then
            local ok6, err6 = SafeCall(function() op:StartAction(game) end)
            if ok6 then return true, "StartAction OK (" .. className .. ")" end
        end
    end

    return false, tostring(err1)
end

-- D3: ToggleOperationEvent dispatch
local function ExecuteToggleOperationEvent(ps, opIndex)
    if not ps or not IsDefined(ps) then return false, "no PS" end

    -- Create ToggleOperationEvent
    local event = nil
    local ok0, err0 = SafeCall(function()
        event = NewObject('ToggleOperationEvent')
    end)
    if not ok0 or not event then
        return false, "cannot create ToggleOperationEvent: " .. tostring(err0)
    end

    -- Set fields: enable=true, index=opIndex, type=EOperationClassType
    pcall(function() event.enable = true end)
    pcall(function() event.index = opIndex end)
    pcall(function() event.type = 0 end)  -- EOperationClassType default

    -- Dispatch via QueuePSDeviceEvent
    local ok1, err1 = SafeCall(function() ps:QueuePSDeviceEvent(event) end)
    if ok1 then return true, "QueuePSDeviceEvent(ToggleOpEvent) OK" end

    -- Try sending event to entity
    local ok2, err2 = SafeCall(function()
        local entity = ps:GetOwnerEntity()
        if entity then
            entity:QueueEvent(event)
        end
    end)
    if ok2 then return true, "entity:QueueEvent(ToggleOpEvent) OK" end

    return false, tostring(err1)
end

-- D4: SetDelayIdOnOperation + trigger
local function ExecuteWithDelay(component, opIndex)
    if not component or not IsDefined(component) then return false, "no component" end

    -- Try SetDelayIdOnOperation
    local ok1, err1 = SafeCall(function()
        local delayId = NewObject('gameDelayID')
        component:SetDelayIdOnOperation(opIndex, delayId)
    end)
    if not ok1 then
        -- Fallback: just try ToggleOperation
        return ExecuteToggleOperation(component, opIndex)
    end

    -- Then try ToggleOperation
    local ok2, err2 = SafeCall(function() component:ToggleOperation(opIndex, true) end)
    if ok2 then return true, "SetDelayId+ToggleOperation OK" end

    -- Clear delay
    pcall(function() component:ClearDelayIdOnOperation(opIndex) end)

    return false, tostring(err2 or err1)
end

-- D5: OperationExecutionData construction + container trigger
local function ExecuteViaOperationData(container, opIndex, game)
    if not container or not IsDefined(container) then return false, "no container" end

    -- Create OperationExecutionData
    local execData = nil
    local ok0, err0 = SafeCall(function()
        execData = NewObject('OperationExecutionData')
    end)
    if not ok0 or not execData then
        return false, "cannot create OperationExecutionData: " .. tostring(err0)
    end

    -- Set operationName to the operation's name if available
    pcall(function() execData.operationName = CName.new("operation_" .. tostring(opIndex)) end)
    pcall(function() execData.delay = 0.0 end)
    pcall(function() execData.resetDelay = false end)

    -- Try container:Execute(execData, game)
    local ok1, err1 = SafeCall(function() container:Execute(execData, game) end)
    if ok1 then return true, "container:Execute(execData, game) OK" end

    -- Try container:TriggerOperation(execData)
    local ok2, err2 = SafeCall(function() container:TriggerOperation(execData) end)
    if ok2 then return true, "container:TriggerOperation(execData) OK" end

    return false, tostring(err1)
end

--============================================================================
-- REGISTRATION HELPERS
--============================================================================

local function RegisterAccess(strategy, success, resultText)
    if not AccessRegistry[strategy] then
        AccessRegistry[strategy] = { attempts = 0, successes = 0, lastResult = "" }
        table.insert(AccessOrder, strategy)
    end
    AccessRegistry[strategy].attempts = AccessRegistry[strategy].attempts + 1
    if success then
        AccessRegistry[strategy].successes = AccessRegistry[strategy].successes + 1
    end
    AccessRegistry[strategy].lastResult = resultText or ""
end

local function RegisterOp(key, success, resultText)
    if not OpRegistry[key] then
        OpRegistry[key] = { attempts = 0, successes = 0, lastResult = "" }
        table.insert(OpOrder, key)
    end
    OpRegistry[key].attempts = OpRegistry[key].attempts + 1
    if success then
        OpRegistry[key].successes = OpRegistry[key].successes + 1
    end
    OpRegistry[key].lastResult = resultText or ""
end

--============================================================================
-- FULL DISCOVERY PIPELINE
--============================================================================

local function DiscoverDeviceOperations(target, ps)
    local results = {
        container = nil,
        containerSource = nil,
        component = nil,
        componentSource = nil,
        operations = {},
        accessLog = {},
    }

    -- Strategy A: Get container from PS
    local container, cSource = TryGetContainerFromPS(ps)
    if container then
        results.container = container
        results.containerSource = cSource
        table.insert(results.accessLog, "PASS " .. cSource)
        dprint(string.format("  [CONTAINER] Found via %s", cSource))
        RegisterAccess(cSource, true, "container found")
    else
        table.insert(results.accessLog, "FAIL all PS strategies")
        dprint("  [CONTAINER] All PS strategies failed")
        for _, s in ipairs({"A1:GetDeviceOperations()", "A2:GetOperations()", "A3:ps.operationsContainer", "A4:ps.deviceOperations", "A5:ps:GetComponentByName"}) do
            RegisterAccess(s, false, "no result")
        end
    end

    -- Strategy B: Get component from entity
    local component, compSource = TryGetComponentFromEntity(target)
    if component then
        results.component = component
        results.componentSource = compSource
        table.insert(results.accessLog, "PASS " .. compSource)
        dprint(string.format("  [COMPONENT] Found via %s", compSource))
        RegisterAccess(compSource, true, "component found")

        -- If we don't have a container yet, try to get it from the component
        if not results.container then
            local ok, ops = SafeCall(function() return component:GetDeviceOperations() end)
            if ok and ops and IsDefined(ops) then
                results.container = ops
                results.containerSource = "B->comp:GetDeviceOperations"
                dprint("  [CONTAINER] Found via component:GetDeviceOperations()")
            end
            -- Try operations field on component
            local ok2, ops2 = SafeCall(function() return component.operations end)
            if ok2 and ops2 and type(ops2) == "table" and #ops2 > 0 then
                results.container = component  -- use component as container proxy
                results.containerSource = "B->comp.operations"
                dprint("  [CONTAINER] Found via component.operations field")
            end
        end
    else
        table.insert(results.accessLog, "FAIL all entity strategies")
        dprint("  [COMPONENT] All entity strategies failed")
        for _, s in ipairs({"B1:FindComponentByName", "B2:FindComponentByClassName", "B3:GetComponent", "B4:DeviceComp:GetDeviceOperations", "B5:FindComponentByClassName(CName)"}) do
            RegisterAccess(s, false, "no result")
        end
    end

    -- Strategy C: Enumerate operations from container
    if results.container then
        results.operations = EnumerateOperations(results.container)
        dprint(string.format("  [OPS] Found %d operations", #results.operations))
        for _, op in ipairs(results.operations) do
            dprint(string.format("    [%d] %s (name: %s, src: %s)",
                op.index, op.className, op.name, op.source))
        end
    else
        -- Fallback: try to enumerate from PS directly (some PS classes may have operations inline)
        dprint("  [OPS] No container — cannot enumerate operations")
    end

    return results
end

local function GetCachedOperations(target, ps)
    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)

    if CachedTarget.entity == target and #CachedTarget.operations > 0 then
        return CachedTarget
    end

    local results = DiscoverDeviceOperations(target, ps)

    CachedTarget.entity = target
    CachedTarget.className = targetClass
    CachedTarget.container = results.container
    CachedTarget.component = results.component
    CachedTarget.operations = results.operations

    return CachedTarget
end

--============================================================================
-- DEVICE REPORT
--============================================================================

local function GenerateDeviceReport(target, targetClass, recordID, hash, results)
    local targetName = GetTargetName(target)
    local dist = GetDistance(target)

    dprint("========================================================")
    dprint("=== NEW DEVICE TYPE REPORT ===")
    dprint(string.format("  Name:       %s", targetName))
    dprint(string.format("  Class:      %s", targetClass or "<unknown>"))
    dprint(string.format("  RecordID:   %s", recordID))
    dprint(string.format("  EntityHash: %s", hash))
    if dist then
        dprint(string.format("  Distance:   %.2f m", dist))
    end
    dprint(string.format("  Container:  %s (%s)",
        results.container and "YES" or "NO",
        results.containerSource or "none"))
    dprint(string.format("  Component:  %s (%s)",
        results.component and "YES" or "NO",
        results.componentSource or "none"))
    dprint(string.format("  Operations: %d", #results.operations))
    if results.operations then
        for _, op in ipairs(results.operations) do
            dprint(string.format("    [%d] %-40s (name: %s)",
                op.index, op.className, op.name))
        end
    end
    dprint(string.format("  Access Log:"))
    for _, log in ipairs(results.accessLog) do
        dprint(string.format("    %s", log))
    end
    dprint("========================================================")
end

--============================================================================
-- APPLY: EXECUTE SELECTED OPERATION
--============================================================================

local function ApplyOperation(target, ps, player, game)
    local cached = GetCachedOperations(target, ps)
    if not cached or #cached.operations == 0 then
        dprint("No operations found for this device")
        LastResult.resultText = "No operations"
        LastResult.success = false
        return
    end

    if SelectedOpIndex > #cached.operations then
        SelectedOpIndex = 1
    end

    local op = cached.operations[SelectedOpIndex]
    local targetName = GetTargetName(target)
    local opLabel = string.format("[%d] %s", op.index, op.className)

    dprint(string.format("=== APPLY %s -> %s ===", opLabel, targetName))

    local success = false
    local resultMsg = ""
    local strategyUsed = ""

    -- Strategy D1: ToggleOperation on component
    if cached.component then
        success, resultMsg = ExecuteToggleOperation(cached.component, op.index)
        strategyUsed = "D1:ToggleOperation"
        dprint(string.format("  [D1 ToggleOp] %s -> %s", tostring(success), resultMsg))
        RegisterOp(opLabel .. "/D1", success, resultMsg)
        if success then goto done end
    end

    -- Strategy D2: Execute on operation object directly
    if op.operation then
        success, resultMsg = ExecuteOperationDirect(op.operation, game)
        strategyUsed = "D2:Execute"
        dprint(string.format("  [D2 Execute] %s -> %s", tostring(success), resultMsg))
        RegisterOp(opLabel .. "/D2", success, resultMsg)
        if success then goto done end
    end

    -- Strategy D3: ToggleOperationEvent dispatch
    success, resultMsg = ExecuteToggleOperationEvent(ps, op.index)
    strategyUsed = "D3:ToggleOpEvent"
    dprint(string.format("  [D3 ToggleOpEvent] %s -> %s", tostring(success), resultMsg))
    RegisterOp(opLabel .. "/D3", success, resultMsg)
    if success then goto done end

    -- Strategy D4: SetDelayIdOnOperation + trigger
    if cached.component then
        success, resultMsg = ExecuteWithDelay(cached.component, op.index)
        strategyUsed = "D4:Delay+Toggle"
        dprint(string.format("  [D4 Delay+Toggle] %s -> %s", tostring(success), resultMsg))
        RegisterOp(opLabel .. "/D4", success, resultMsg)
        if success then goto done end
    end

    -- Strategy D5: OperationExecutionData via container
    if cached.container then
        success, resultMsg = ExecuteViaOperationData(cached.container, op.index, game)
        strategyUsed = "D5:ExecData"
        dprint(string.format("  [D5 ExecData] %s -> %s", tostring(success), resultMsg))
        RegisterOp(opLabel .. "/D5", success, resultMsg)
    end

    ::done::

    LastResult.strategy = strategyUsed
    LastResult.opLabel = opLabel
    LastResult.success = success
    LastResult.resultText = success and ("SUCCESS: " .. resultMsg) or ("FAIL: " .. resultMsg)

    dprint(string.format("  Result: %s", LastResult.resultText))
end

--============================================================================
-- HOTKEYS (root level per CET hotkey registration rule)
--============================================================================

registerHotkey("SE_DEV4_TOGGLE_WINDOW", "Toggle Info Window", function()
    windowVisible = not windowVisible
    dprint(string.format("Info window %s", windowVisible and "ON" or "OFF"))
end)

registerHotkey("SE_DEV4_ENUMERATE", "Enumerate Operations", function()
    local player = Game.GetPlayer()
    if not player then return end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        dprint("No hackable device targeted")
        LastResult.resultText = "No device"
        LastResult.success = false
        return
    end

    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)
    local recordID, hash = GetEntityKey(target)

    if not reportedDeviceTypes[targetClass] then
        local results = DiscoverDeviceOperations(target, ps)
        GenerateDeviceReport(target, targetClass, recordID, hash, results)
        reportedDeviceTypes[targetClass] = true
    else
        -- Re-discover and log briefly
        local cached = GetCachedOperations(target, ps)
        dprint(string.format("  [RE-ENUM] %s: %d ops (container: %s, component: %s)",
            targetClass, #cached.operations,
            cached.container and "YES" or "NO",
            cached.component and "YES" or "NO"))
    end

    -- Force cache update
    CachedTarget.entity = nil
    local cached = GetCachedOperations(target, ps)

    dprint(">>> ENUMERATION COMPLETE <<<")
end)

registerHotkey("SE_DEV4_EXECUTE", "Execute Selected Operation", function()
    local player = Game.GetPlayer()
    if not player then return end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        dprint("No hackable device targeted")
        LastResult.resultText = "No device"
        LastResult.success = false
        return
    end

    local game = nil
    pcall(function() game = player:GetGame() end)

    dprint(">>> EXECUTE SELECTED OPERATION <<<")
    ApplyOperation(target, ps, player, game)
end)

registerHotkey("SE_DEV4_CYCLE_OP", "Cycle Operation Selection", function()
    local player = Game.GetPlayer()
    if not player then return end

    local target, ps = GetLookAtDevice()
    if not target or not ps then
        dprint("No hackable device targeted")
        return
    end

    local cached = GetCachedOperations(target, ps)
    if #cached.operations == 0 then
        dprint("No operations to cycle")
        return
    end

    SelectedOpIndex = SelectedOpIndex + 1
    if SelectedOpIndex > #cached.operations then
        SelectedOpIndex = 1
    end

    local op = cached.operations[SelectedOpIndex]
    dprint(string.format("  [SELECT] -> [%d] %s", op.index, op.className))
end)

--============================================================================
-- EVENTS
--============================================================================

registerForEvent("onInit", function()
    pcall(function() math.randomseed(os.time()) end)

    dprint("Status Effect Device Tester 4 initialized")
    dprint("  Focus: DeviceOperations pipeline investigation")
    dprint("  Strategies:")
    dprint("    A = Access DeviceOperationsContainer from PS")
    dprint("    B = Access DeviceOperationsComponent from entity")
    dprint("    C = Enumerate operations from container")
    dprint("    D1 = ToggleOperation on component")
    dprint("    D2 = Execute on operation object")
    dprint("    D3 = ToggleOperationEvent dispatch")
    dprint("    D4 = SetDelayIdOnOperation + trigger")
    dprint("    D5 = OperationExecutionData via container")
    dprint("  Hotkeys: SE_DEV4_TOGGLE_WINDOW, SE_DEV4_ENUMERATE, SE_DEV4_EXECUTE, SE_DEV4_CYCLE_OP")
    dprint("  Bind in Settings > Key Bindings > SEDevT4")
end)

registerForEvent("onUpdate", function(delta)
    if not windowVisible then return end
    if not Game.GetPlayer() then return end

    local target, ps = GetLookAtDevice()

    Scan.entity     = nil
    Scan.typeName   = nil
    Scan.targetName = nil
    Scan.className  = nil
    Scan.distance   = nil
    Scan.recordID   = nil
    Scan.entityHash = nil
    Scan.ps         = nil
    Scan.container  = nil
    Scan.component  = nil
    Scan.operations = {}

    if not target or not ps then return end

    local targetClass = ""
    pcall(function() targetClass = CNameToString(target:GetClassName()) end)

    Scan.entity     = target
    Scan.typeName   = "Device"
    Scan.targetName = GetTargetName(target)
    Scan.className  = targetClass
    Scan.distance   = GetDistance(target)
    Scan.ps         = ps

    local recordID, hash = GetEntityKey(target)
    Scan.recordID   = recordID
    Scan.entityHash = hash

    local cached = GetCachedOperations(target, ps)
    Scan.container  = cached.container
    Scan.component  = cached.component
    Scan.operations = cached.operations
end)

registerForEvent("onDraw", function()
    if not windowVisible then return end

    ImGui.SetNextWindowPos(10, 10, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(Config.windowWidth, 500, ImGuiCond.FirstUseEver)

    local visible = ImGui.Begin("SE Dev Tester 4 - DeviceOps", true)
    if visible then
        ImGui.PushTextWrapPos(Config.windowWidth - 10)

        if not Scan.entity then
            ImGui.Text("Looking at nothing...")
        else
            -- Target info
            ImGui.Text("Target: " .. tostring(Scan.targetName or "?"))
            ImGui.Text("Class:  " .. tostring(Scan.className or "?"))
            if Scan.distance then
                ImGui.Text(string.format("Dist:   %.1fm", Scan.distance))
            end

            ImGui.Separator()

            -- Container / Component status
            local containerStr = Scan.container and "YES" or "NO"
            local componentStr = Scan.component and "YES" or "NO"
            ImGui.Text("Container: " .. containerStr)
            ImGui.Text("Component: " .. componentStr)

            ImGui.Separator()

            -- Last result
            if LastResult.resultText then
                local prefix = LastResult.success and "[OK] " or "[X] "
                ImGui.Text(prefix .. (LastResult.opLabel or "?"))
                ImGui.Text("  via " .. tostring(LastResult.strategy or "?"))
                ImGui.Text("  -> " .. (LastResult.resultText or ""))
            else
                ImGui.Text("Last: (none)")
            end

            ImGui.Separator()

            -- Operations list
            if Scan.operations and #Scan.operations > 0 then
                ImGui.Text(string.format("Operations (%d):", #Scan.operations))
                for i = 1, #Scan.operations do
                    local op = Scan.operations[i]
                    local key = string.format("[%d] %s", op.index, op.className)
                    local reg = OpRegistry[key .. "/D1"] or OpRegistry[key .. "/D2"]
                        or OpRegistry[key .. "/D3"] or OpRegistry[key .. "/D4"]
                        or OpRegistry[key .. "/D5"]
                    local mark = " "
                    if reg and reg.attempts > 0 then
                        mark = reg.successes > 0 and "*" or "."
                    end
                    local selected = (i == SelectedOpIndex) and ">" or " "
                    local name = op.className
                    if #name > 25 then name = name:sub(1, 22) .. "..." end
                    ImGui.Text(string.format("%s%s[%d] %s", selected, mark, op.index, name))
                end
            else
                ImGui.Text("No operations found")
                ImGui.Text("Press F9 to enumerate")
            end

            ImGui.Separator()

            -- Access strategy results
            if #AccessOrder > 0 then
                ImGui.Text("Access Strategies:")
                for _, s in ipairs(AccessOrder) do
                    local reg = AccessRegistry[s]
                    local status = reg.successes > 0 and "OK" or "FAIL"
                    local short = s
                    if #short > 40 then short = short:sub(1, 37) .. "..." end
                    ImGui.Text(string.format("  %-40s %s (%d/%d)", short, status,
                        reg.successes, reg.attempts))
                end
            end

            ImGui.Separator()
            ImGui.Text("F8=Window F9=Enum F10=Exec F11=Cycle")
            ImGui.Text("> = selected  * = success  . = tried")
        end

        ImGui.PopTextWrapPos()
    end
    ImGui.End()
end)

registerForEvent("onShutdown", function()
    dprint("=== Final Statistics ===")
    dprint("")
    dprint("--- Access Strategies ---")
    for _, s in ipairs(AccessOrder) do
        local e = AccessRegistry[s]
        dprint(string.format("  %-40s %d/%d  %s",
            s, e.successes, e.attempts, e.lastResult))
    end
    dprint("")
    dprint("--- Operations ---")
    for _, key in ipairs(OpOrder) do
        local e = OpRegistry[key]
        dprint(string.format("  %-45s %d/%d  %s",
            key, e.successes, e.attempts, e.lastResult))
    end
    dprint("")
    dprint(string.format("--- Device Types Encountered: %d ---", #reportedDeviceTypes))
    for className, _ in pairs(reportedDeviceTypes) do
        dprint(string.format("    %s", className))
    end
    dprint("")
    dprint("=== API success != visible effect -- check game ===")
    dprint("=== End Statistics ===")
    dprint("Status Effect Device Tester 4 shut down")
end)
