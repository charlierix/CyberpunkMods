--===========================================================================
-- HoverRotTesterPlayer9.1a - Diagnostic Logging with RED4ext C++ Support
--
-- Strategy: Pure observation -- no transform overrides
-- Goal: Identify which transform/bone/component the renderer reads for player
--        body orientation, AND fill the 2 unmet goals from tester 9.1:
--          1. Bone/skeleton access (CET's GetSkeleton() returned nil -> C++ reads anim::Rig)
--          2. Render-source identification (C++ reads bone transforms + entity transform)
--
-- Architecture: CET + Redscript + RED4ext (full 3-language pipeline, proven from T8)
--   CET Lua:   hotkeys, hover impulse, quaternion math, ImGui, logging, CET-level probes
--   Redscript: ScriptableSystem bridge wrapping native function calls
--   RED4ext:   native C++ functions that read bone/skeleton/component data from memory
--
-- References:
--   goals 1 - logging.md (tester 9 -- original logging goals)
--   hover_rot_tester_player8/cet/init.lua (CET->Redscript->RED4ext bridge pattern)
--   hover_rot_tester_player9.1/cet/init.lua (logging/snapshot/hover pattern)
--===========================================================================

local ModName = "HoverRotPlayer9_1a"

--===========================================================================
-- LOGGING
--===========================================================================

local function Log(msg)
    print("[" .. ModName .. "] " .. tostring(msg))
end

local function LogBoneDump(msg)
    print("[" .. ModName .. "-BoneDump] " .. tostring(msg))
end

local function LogSnap(msg)
    print("[" .. ModName .. "-Snap] " .. tostring(msg))
end

local function LogCpp(msg)
    print("[" .. ModName .. "-Cpp] " .. tostring(msg))
end

--===========================================================================
-- CONFIGURATION
--===========================================================================

local HOVER_HEIGHT    = 3.0
local SPRING_K       = 0.8
local DAMPING_K      = 2.0
local MAX_DV         = 3.0
local GROUND_RAY_DIST = 50.0
local GRAVITY        = 9.81

--===========================================================================
-- STATE
--===========================================================================

local state = {
    loggingActive   = false,
    logInterval     = 60,
    tickCount       = 0,

    snapshotA       = nil,
    snapshotB       = nil,
    hasSnapA        = false,
    hasSnapB        = false,

    componentCount  = 0,
    placedCount     = 0,
    boneCount       = -1,
    lastComponents  = nil,

    hoverActive     = false,
    hoverTargetZ    = 0.0,
    hoverGroundZ    = 0.0,
    hoverCurrentZ   = 0.0,
    prevZ           = 0.0,
    hasPrevZ        = false,
    hoverVelocity   = 0.0,

    playerPos       = {x=0, y=0, z=0},
    playerYaw       = 0.0,
    playerPitch     = 0.0,
    playerRoll      = 0.0,

    nativeAvailable = false,
    nativeChecked   = false,
    cppCompDump     = "",
    cppSkelDump     = "",
    cppEntityDump   = "",
    cppStatus       = "",

    lastError       = "",
}

--===========================================================================
-- BRIDGE ACCESS (proven pattern from Tester 8)
--===========================================================================

local bridge = nil

local function GetBridge()
    if bridge then return bridge end
    pcall(function()
        local container = Game.GetScriptableSystemsContainer()
        if container then
            bridge = container:Get("HoverRotPlayer9_1aBridge")
        end
    end)
    return bridge
end

local function CheckNativeAvailable()
    local b = GetBridge()
    if not b then
        Log("CheckNativeAvailable: bridge not found")
        state.nativeAvailable = false
        return false
    end
    local ok, result = pcall(function()
        return b:CheckNativeAvailable()
    end)
    if ok then
        state.nativeAvailable = result
        Log("CheckNativeAvailable: native functions " .. (result and "AVAILABLE" or "NOT AVAILABLE"))
        return result
    else
        state.nativeAvailable = false
        state.lastError = "CheckNativeAvailable failed: " .. tostring(result)
        Log(state.lastError)
        return false
    end
end

--===========================================================================
-- HELPER: Quaternion to Euler (for readable logging)
--===========================================================================

local function QuatToEulerString(quat)
    if not quat then return "nil" end
    local ok, euler = pcall(function()
        return quat:ToEulerAngles()
    end)
    if ok and euler then
        return string.format("yaw=%.2f pitch=%.2f roll=%.2f",
            euler.yaw or euler.Yaw or 0,
            euler.pitch or euler.Pitch or 0,
            euler.roll or euler.Roll or 0)
    end
    local ok2, i, j, k, r = pcall(function()
        return quat.i, quat.j, quat.k, quat.r
    end)
    if ok2 then
        return string.format("quat(i=%.3f j=%.3f k=%.3f r=%.3f)", i or 0, j or 0, k or 0, r or 0)
    end
    return tostring(quat)
end

local function QuatToEulerVals(quat)
    if not quat then return 0, 0, 0 end
    local ok, euler = pcall(function()
        return quat:ToEulerAngles()
    end)
    if ok and euler then
        return (euler.yaw or euler.Yaw or 0),
               (euler.pitch or euler.Pitch or 0),
               (euler.roll or euler.Roll or 0)
    end
    return 0, 0, 0
end

local function PosString(pos)
    if not pos then return "nil" end
    return string.format("(%.2f, %.2f, %.2f)", pos.x or 0, pos.y or 0, pos.z or 0)
end

--===========================================================================
-- C++ NATIVE LOGGING (fills 9.1 gaps)
--===========================================================================

local function DoCppComponentDump()
    local b = GetBridge()
    if not b or not state.nativeAvailable then
        LogCpp("DumpComponents: native not available")
        return
    end
    local ok, result = pcall(function()
        return b:DumpComponents()
    end)
    if ok and result then
        state.cppCompDump = result
        LogCpp("=== C++ Component Dump ===")
        for line in string.gmatch(result, "[^\n]+") do
            LogCpp("  " .. line)
        end
        LogCpp("=== End C++ Component Dump ===")
    else
        state.lastError = "CppComponentDump failed: " .. tostring(result)
        LogCpp(state.lastError)
    end
end

local function DoCppSkeletonDump()
    local b = GetBridge()
    if not b or not state.nativeAvailable then
        LogCpp("DumpSkeleton: native not available")
        return
    end
    local ok, result = pcall(function()
        return b:DumpSkeleton()
    end)
    if ok and result then
        state.cppSkelDump = result
        LogCpp("=== C++ Skeleton Dump ===")
        local lineCount = 0
        for line in string.gmatch(result, "[^\n]+") do
            if lineCount < 100 then
                LogCpp("  " .. line)
            end
            lineCount = lineCount + 1
        end
        if lineCount > 100 then
            LogCpp("  ... (" .. (lineCount - 100) .. " more lines truncated)")
        end
        LogCpp("=== End C++ Skeleton Dump (" .. lineCount .. " total lines) ===")

        local boneCountMatch = string.match(result, "=== Skeleton Dump %((%d+) bones%)")
        if boneCountMatch then
            state.boneCount = tonumber(boneCountMatch) or -1
            LogCpp("  Bone count from C++: " .. state.boneCount)
        end
    else
        state.lastError = "CppSkeletonDump failed: " .. tostring(result)
        LogCpp(state.lastError)
    end
end

local function DoCppEntityTransformDump()
    local b = GetBridge()
    if not b or not state.nativeAvailable then
        LogCpp("DumpEntityTransform: native not available")
        return
    end
    local ok, result = pcall(function()
        return b:DumpEntityTransform()
    end)
    if ok and result then
        state.cppEntityDump = result
        LogCpp("=== C++ Entity Transform ===")
        LogCpp("  " .. result)
        LogCpp("=== End C++ Entity Transform ===")
    else
        state.lastError = "CppEntityDump failed: " .. tostring(result)
        LogCpp(state.lastError)
    end
end

local function DoCppStatusDump()
    local b = GetBridge()
    if not b then
        LogCpp("GetStatus: bridge not found")
        return
    end
    local ok, result = pcall(function()
        return b:GetStatus()
    end)
    if ok and result then
        state.cppStatus = result
        LogCpp("=== C++ Plugin Status ===")
        LogCpp("  " .. result)
        LogCpp("=== End C++ Plugin Status ===")
    else
        LogCpp("GetStatus failed: " .. tostring(result))
    end
end

--===========================================================================
-- COMPONENT ENUMERATION (CET-level, same as 9.1)
--===========================================================================

local function EnumerateComponents(player)
    local components = {}
    local total = 0
    local placed = 0

    local ok, compList = pcall(function()
        return player:GetComponents()
    end)
    if not ok or not compList then
        return 0, 0, {}
    end

    for _, comp in ipairs(compList) do
        total = total + 1
        local entry = {
            name = "",
            className = "",
            isPlaced = false,
            pos = nil,
            yaw = 0, pitch = 0, roll = 0,
        }

        pcall(function()
            local cls = comp:GetClassName()
            if cls then entry.name = tostring(cls) end
        end)
        if entry.name == "" then
            pcall(function()
                entry.name = comp:GetType():GetName() and tostring(comp:GetType():GetName()) or ""
            end)
        end
        if entry.name == "" then entry.name = "unknown" end
        entry.className = entry.name

        local isPlaced = false
        pcall(function() isPlaced = comp:IsA("IPlacedComponent") end)
        if not isPlaced then
            pcall(function()
                local wt = comp:GetWorldTransform()
                if wt then isPlaced = true end
            end)
        end
        entry.isPlaced = isPlaced

        if isPlaced then
            placed = placed + 1
            pcall(function()
                local wt = comp:GetWorldTransform()
                if wt then
                    local pos = wt:GetPosition()
                    if pos then entry.pos = {x = pos.x, y = pos.y, z = pos.z} end
                    local orient = wt:GetOrientation()
                    if orient then entry.yaw, entry.pitch, entry.roll = QuatToEulerVals(orient) end
                end
            end)
        end

        table.insert(components, entry)
    end

    return total, placed, components
end

--===========================================================================
-- CAMERA LOGGING (same as 9.1)
--===========================================================================

local function LogCameraTransforms(player)
    local cam = nil
    pcall(function() cam = player:GetFPPCameraComponent() end)
    if not cam then
        Log("  Camera: GetFPPCameraComponent() returned nil")
        return
    end

    pcall(function()
        local l2w = cam:GetLocalToWorld()
        if l2w then
            local mat = GetSingleton("Matrix")
            if mat then
                local pos = mat:GetTranslation(l2w)
                Log(string.format("  Camera LocalToWorld: pos=%s", PosString(pos)))
            end
        else
            Log("  Camera LocalToWorld: nil")
        end
    end)

    pcall(function()
        local pos = cam:GetWorldPosition()
        if pos then Log(string.format("  Camera WorldPos: %s", PosString(pos))) end
    end)
    pcall(function()
        local orient = cam:GetWorldOrientation()
        if orient then Log(string.format("  Camera WorldOrient: %s", QuatToEulerString(orient))) end
    end)
    pcall(function()
        local orient = cam:GetLocalOrientation()
        if orient then Log(string.format("  Camera LocalOrient: %s", QuatToEulerString(orient))) end
    end)
    pcall(function()
        local wt = cam:GetWorldTransform()
        if wt then
            local pos = wt:GetPosition()
            local orient = wt:GetOrientation()
            Log(string.format("  Camera WorldTransform: pos=%s orient=%s",
                PosString(pos), QuatToEulerString(orient)))
        end
    end)
end

--===========================================================================
-- ANIMATION / SKELETON PROBING (CET-level, same as 9.1 -- logs nil results)
--===========================================================================

local function ProbeAnimationComponents(player)
    Log("--- Animation / Skeleton Probing (CET) ---")

    local typeNames = {
        "entAnimationControllerComponent",
        "AnimationControllerComponent",
        "AnimatedComponent",
        "ISkinableComponent",
        "gameHumanoidBody",
        "gameAnimationControllerComponent",
        "entSkinableComponent",
        "entAnimatedComponent",
    }

    for _, typeName in ipairs(typeNames) do
        local found = nil
        local ok = pcall(function() found = player:FindComponentByType(typeName) end)
        if ok and found then
            Log(string.format("  Found component: %s", typeName))
            pcall(function()
                local boneCount = found:GetBoneCount()
                if boneCount then
                    state.boneCount = boneCount
                    Log(string.format("    GetBoneCount() = %d", boneCount))
                end
            end)
            pcall(function()
                local skeleton = found:GetSkeleton()
                if skeleton then
                    Log(string.format("    GetSkeleton() = %s", tostring(skeleton)))
                else
                    Log("    GetSkeleton() returned nil (expected -- CET limitation)")
                end
            end)
        end
    end

    Log("  Note: CET bone access is nil -- use C++ Skeleton Dump hotkey for real data")
end

--===========================================================================
-- STATE MACHINE PROBING (same as 9.1)
--===========================================================================

local function ProbeStateMachine(player)
    Log("--- State Machine Probing ---")

    local sm = nil
    pcall(function() sm = player:FindComponentByType("gamestateMachineComponent") end)
    if not sm then
        pcall(function() sm = player:FindComponentByType("gameStateMachineComponent") end)
    end
    if not sm then
        Log("  gamestateMachineComponent: not found")
        return
    end

    Log("  gamestateMachineComponent: found")

    pcall(function()
        local stateName = sm:GetCurrentStateName()
        if stateName then Log(string.format("    CurrentState: %s", tostring(stateName))) end
    end)
    pcall(function()
        local enabled = sm:IsTransformUpdateEnabled()
        if enabled ~= nil then Log(string.format("    IsTransformUpdateEnabled: %s", tostring(enabled))) end
    end)
    pcall(function()
        local bb = player:GetPlayerStateMachineBlackboard()
        if bb then
            Log("  PlayerStateMachineBlackboard: accessible")
            pcall(function() Log(string.format("    HighLevel: %s", tostring(bb:GetInt("HighLevel")))) end)
            pcall(function() Log(string.format("    Vision: %s", tostring(bb:GetInt("Vision")))) end)
        end
    end)
    pcall(function() Log(string.format("  CanRagdoll: %s", tostring(player:CanRagdoll()))) end)
    pcall(function()
        local ragdoll = player:FindComponentByType("ragdollComponent")
        if ragdoll then Log("  ragdollComponent: found")
        else Log("  ragdollComponent: not found") end
    end)
end

--===========================================================================
-- FULL LOG DUMP (CET-level, same as 9.1 + C++ entity transform)
--===========================================================================

local function DoFullLogDump(player)
    Log("=== Full Transform Dump (tick " .. state.tickCount .. ") ===")

    local pos = player:GetWorldPosition()
    local orient = player:GetWorldOrientation()
    if pos then state.playerPos = {x = pos.x, y = pos.y, z = pos.z} end
    if orient then state.playerYaw, state.playerPitch, state.playerRoll = QuatToEulerVals(orient) end
    Log(string.format("Entity WorldPos: %s", PosString(pos)))
    Log(string.format("Entity WorldOrient: %s", QuatToEulerString(orient)))

    pcall(function()
        local wt = player:GetWorldTransform()
        if wt then
            local wtPos = wt:GetPosition()
            local wtOrient = wt:GetOrientation()
            Log(string.format("Entity WorldTransform: pos=%s orient=%s",
                PosString(wtPos), QuatToEulerString(wtOrient)))
        end
    end)

    if state.nativeAvailable then
        DoCppEntityTransformDump()
    end

    LogCameraTransforms(player)

    local total, placed, comps = EnumerateComponents(player)
    state.componentCount = total
    state.placedCount = placed
    state.lastComponents = comps
    Log(string.format("Components: total=%d placed=%d", total, placed))

    Log("=== End Transform Dump ===")
end

--===========================================================================
-- BONE HIERARCHY DUMP (CET-level fallback + C++ real dump)
--===========================================================================

local function DoBoneDump(player)
    LogBoneDump("=== Full Skeleton Hierarchy Dump ===")

    local animComp = nil
    pcall(function() animComp = player:FindComponentByType("entAnimatedComponent") end)
    if not animComp then
        pcall(function() animComp = player:FindComponentByType("entAnimationControllerComponent") end)
    end

    if animComp then
        LogBoneDump("Animation component: " .. tostring(animComp))
        local skeleton = nil
        pcall(function() skeleton = animComp:GetSkeleton() end)
        if not skeleton then
            LogBoneDump("GetSkeleton() returned nil (CET limitation -- use C++ dump)")
        else
            LogBoneDump("GetSkeleton() returned: " .. tostring(skeleton))
        end
    else
        LogBoneDump("No animation component found via CET")
    end

    LogBoneDump("=== End CET Bone Dump ===")

    if state.nativeAvailable then
        LogBoneDump("=== C++ Bone Dump (via RED4ext native) ===")
        DoCppSkeletonDump()
        LogBoneDump("=== End C++ Bone Dump ===")
    else
        LogBoneDump("C++ dump skipped -- native plugin not available")
    end
end

--===========================================================================
-- SNAPSHOT CAPTURE & COMPARE (same as 9.1 + C++ entity transform)
--===========================================================================

local function CaptureSnapshot(player)
    local snap = {
        pos = nil, yaw = 0, pitch = 0, roll = 0,
        components = {}, camera = {}, cppEntity = "",
    }

    pcall(function()
        local pos = player:GetWorldPosition()
        if pos then snap.pos = {x = pos.x, y = pos.y, z = pos.z} end
    end)
    pcall(function()
        local orient = player:GetWorldOrientation()
        if orient then snap.yaw, snap.pitch, snap.roll = QuatToEulerVals(orient) end
    end)

    pcall(function()
        local cam = player:GetFPPCameraComponent()
        if cam then
            local l2w = cam:GetLocalToWorld()
            if l2w then
                local mat = GetSingleton("Matrix")
                if mat then
                    local camPos = mat:GetTranslation(l2w)
                    snap.camera.pos = {x = camPos.x, y = camPos.y, z = camPos.z}
                end
            end
            local camOrient = cam:GetWorldOrientation()
            if camOrient then
                snap.camera.yaw, snap.camera.pitch, snap.camera.roll = QuatToEulerVals(camOrient)
            end
        end
    end)

    if state.nativeAvailable then
        local b = GetBridge()
        if b then
            pcall(function()
                snap.cppEntity = b:DumpEntityTransform()
            end)
        end
    end

    local total, placed, comps = EnumerateComponents(player)
    for _, comp in ipairs(comps) do
        if comp.isPlaced then
            table.insert(snap.components, {
                name = comp.name,
                pos = comp.pos and {x=comp.pos.x, y=comp.pos.y, z=comp.pos.z} or nil,
                yaw = comp.yaw, pitch = comp.pitch, roll = comp.roll,
            })
        end
    end

    return snap
end

local function CompareSnapshots()
    if not state.hasSnapA or not state.hasSnapB then
        LogSnap("Need both snapshots A and B to compare")
        return
    end

    local a = state.snapshotA
    local b = state.snapshotB

    LogSnap("=== Snapshot Comparison (A vs B) ===")

    if a.pos and b.pos then
        LogSnap(string.format("Entity Pos: A=%s B=%s  dPos=(%.3f, %.3f, %.3f)",
            PosString(a.pos), PosString(b.pos),
            b.pos.x - a.pos.x, b.pos.y - a.pos.y, b.pos.z - a.pos.z))
    end

    LogSnap(string.format("Entity Orient: A(yaw=%.2f pitch=%.2f roll=%.2f) B(yaw=%.2f pitch=%.2f roll=%.2f)",
        a.yaw, a.pitch, a.roll, b.yaw, b.pitch, b.roll))
    LogSnap(string.format("  dYaw=%.2f dPitch=%.2f dRoll=%.2f",
        b.yaw - a.yaw, b.pitch - a.pitch, b.roll - a.roll))

    if a.camera and b.camera then
        LogSnap(string.format("Camera Orient: A(yaw=%.2f pitch=%.2f roll=%.2f) B(yaw=%.2f pitch=%.2f roll=%.2f)",
            a.camera.yaw or 0, a.camera.pitch or 0, a.camera.roll or 0,
            b.camera.yaw or 0, b.camera.pitch or 0, b.camera.roll or 0))
        LogSnap(string.format("  dYaw=%.2f dPitch=%.2f dRoll=%.2f",
            (b.camera.yaw or 0) - (a.camera.yaw or 0),
            (b.camera.pitch or 0) - (a.camera.pitch or 0),
            (b.camera.roll or 0) - (a.camera.roll or 0)))
    end

    if a.cppEntity and b.cppEntity and a.cppEntity ~= "" and b.cppEntity ~= "" then
        LogSnap("--- C++ Entity Transform Comparison ---")
        LogSnap("  A: " .. a.cppEntity)
        LogSnap("  B: " .. b.cppEntity)
        if a.cppEntity == b.cppEntity then
            LogSnap("  Result: IDENTICAL (C++ entity transform unchanged)")
        else
            LogSnap("  Result: CHANGED (see above for deltas)")
        end
    end

    LogSnap("--- Component Orientation Changes ---")
    for i, compA in ipairs(a.components) do
        local compB = b.components[i]
        if compB and compA.name == compB.name then
            local dYaw = compB.yaw - compA.yaw
            local dPitch = compB.pitch - compA.pitch
            local dRoll = compB.roll - compA.roll
            local orientChanged = math.abs(dYaw) > 0.5 or math.abs(dPitch) > 0.5 or math.abs(dRoll) > 0.5
            if orientChanged then
                LogSnap(string.format("  %s: dYaw=%.2f dPitch=%.2f dRoll=%.2f",
                    compA.name, dYaw, dPitch, dRoll))
            end
        end
    end

    LogSnap("=== End Comparison ===")
end

--===========================================================================
-- HOVER PD CONTROLLER (same as 9.1)
--===========================================================================

local function GetGroundZ(x, y, z)
    local origin = Vector4.new(x, y, z + 1.0, 1)
    local dir = Vector4.new(0, 0, -1, 0)
    local hit, hitPos
    pcall(function()
        local result = Game.GetSpatialQueriesSystem():SyncRaycastByQueryPreset(
            origin, dir, GROUND_RAY_DIST, "Bullet logic", false, false
        )
        if result then hit = true; hitPos = result end
    end)
    if hit and hitPos then return hitPos.z end
    return z
end

local function ApplyHoverImpulse(player, dvZ)
    dvZ = math.max(-MAX_DV, math.min(MAX_DV, dvZ))
    pcall(function()
        local imp = PSMImpulse.new()
        imp.id = "impulse"
        imp.impulse = Vector4.new(0, 0, dvZ, 0)
        player:QueueEvent(imp)
    end)
end

local function HoverUpdate(player, delta)
    if not state.hoverActive then return end
    local pos = player:GetWorldPosition()
    if not pos then return end

    state.hoverCurrentZ = pos.z
    state.hoverGroundZ = GetGroundZ(pos.x, pos.y, pos.z)
    state.hoverTargetZ = state.hoverGroundZ + HOVER_HEIGHT

    local velZ = 0
    if state.hasPrevZ and delta > 0 then
        velZ = (pos.z - state.prevZ) / delta
    end

    local antiGravDV = GRAVITY * delta
    local errZ = state.hoverTargetZ - pos.z
    local springDVz = SPRING_K * errZ - DAMPING_K * velZ
    local dvZ = antiGravDV + springDVz

    ApplyHoverImpulse(player, dvZ)
    state.prevZ = pos.z
    state.hasPrevZ = true
end

--===========================================================================
-- HOTKEYS (ROOT LEVEL -- per cet-hotkeys.promptinclude.md)
--===========================================================================

registerHotkey("HoverRotPlayer9_1a_ToggleLog", "HoverRot 9.1a: Toggle Logging", function()
    state.loggingActive = not state.loggingActive
    if state.loggingActive then
        state.tickCount = 0
        Log("Logging ACTIVATED (interval=" .. state.logInterval .. " ticks)")
    else
        Log("Logging DEACTIVATED")
    end
end)

registerHotkey("HoverRotPlayer9_1a_DumpAll", "HoverRot 9.1a: Dump All (Full Diagnostics)", function()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        Log("No player available")
        return
    end
    Log("========== DUMP ALL START ==========")
    -- CET-level full transform dump
    DoFullLogDump(player)
    -- CET animation/skeleton probing (documents nil results)
    ProbeAnimationComponents(player)
    -- State machine probing
    ProbeStateMachine(player)
    -- CET bone dump attempt + C++ bone dump
    DoBoneDump(player)
    -- C++ component enumeration
    DoCppComponentDump()
    -- C++ entity transform readback
    DoCppEntityTransformDump()
    -- C++ plugin status
    DoCppStatusDump()
    Log("========== DUMP ALL END ==========")
end)

registerHotkey("HoverRotPlayer9_1a_SnapA", "HoverRot 9.1a: Snapshot A (Before)", function()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        LogSnap("No player available")
        return
    end
    state.snapshotA = CaptureSnapshot(player)
    state.hasSnapA = true
    LogSnap("Snapshot A captured")
    if state.snapshotA.pos then
        LogSnap(string.format("  pos=%s yaw=%.2f pitch=%.2f roll=%.2f",
            PosString(state.snapshotA.pos),
            state.snapshotA.yaw, state.snapshotA.pitch, state.snapshotA.roll))
    end
end)

registerHotkey("HoverRotPlayer9_1a_SnapB", "HoverRot 9.1a: Snapshot B (After + Compare)", function()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        LogSnap("No player available")
        return
    end
    state.snapshotB = CaptureSnapshot(player)
    state.hasSnapB = true
    LogSnap("Snapshot B captured")
    if state.snapshotB.pos then
        LogSnap(string.format("  pos=%s yaw=%.2f pitch=%.2f roll=%.2f",
            PosString(state.snapshotB.pos),
            state.snapshotB.yaw, state.snapshotB.pitch, state.snapshotB.roll))
    end
    -- Auto-compare if Snap A exists
    if state.hasSnapA then
        LogSnap("Auto-comparing A vs B...")
        CompareSnapshots()
    else
        LogSnap("No Snapshot A to compare against -- take Snap A first")
    end
end)

registerHotkey("HoverRotPlayer9_1a_HoverToggle", "HoverRot 9.1a: Toggle Hover", function()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        Log("No player available")
        return
    end
    state.hoverActive = not state.hoverActive
    if state.hoverActive then
        local pos = player:GetWorldPosition()
        if pos then state.prevZ = pos.z; state.hasPrevZ = true end
        Log(string.format("Hover ACTIVATED - target height=%.1f above ground", HOVER_HEIGHT))
    else
        Log("Hover DEACTIVATED")
    end
end)

registerHotkey("HoverRotPlayer9_1a_HoverUp", "HoverRot 9.1a: Hover Up (+1m)", function()
    HOVER_HEIGHT = HOVER_HEIGHT + 1.0
    Log(string.format("Hover height increased to %.1f", HOVER_HEIGHT))
end)

registerHotkey("HoverRotPlayer9_1a_HoverDown", "HoverRot 9.1a: Hover Down (-1m)", function()
    HOVER_HEIGHT = HOVER_HEIGHT - 1.0
    Log(string.format("Hover height decreased to %.1f", HOVER_HEIGHT))
end)

registerHotkey("HoverRotPlayer9_1a_HoverStop", "HoverRot 9.1a: Hover Stop", function()
    state.hoverActive = false
    Log("Hover stopped")
end)

--===========================================================================
-- EVENT HANDLERS
--===========================================================================

registerForEvent("onInit", function()
    Log("=== onInit ===")

    state.loggingActive = false
    state.hoverActive = false
    state.hasSnapA = false
    state.hasSnapB = false
    state.boneCount = -1
    state.tickCount = 0
    state.lastError = ""

    Log("Crash safeguard: all modes reset to inactive")

    state.nativeAvailable = CheckNativeAvailable()
    state.nativeChecked = true
    Log("Native plugin: " .. (state.nativeAvailable and "LOADED" or "NOT LOADED"))

    Log("=== onInit complete ===")
end)

registerForEvent("onUpdate", function(delta)
    state.tickCount = state.tickCount + 1

    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then return end

    HoverUpdate(player, delta)

    if state.loggingActive and state.tickCount % state.logInterval == 0 then
        DoFullLogDump(player)

        if (state.tickCount / state.logInterval) % 5 == 0 then
            ProbeAnimationComponents(player)
            ProbeStateMachine(player)
        end
    end
end)

registerForEvent("onDraw", function()
    local visible = ImGui.Begin("HoverRot Player 9.1a##hoverrot91a", true, ImGuiWindowFlags.AlwaysAutoResize)
    if not visible then
        ImGui.End()
        return
    end

    ImGui.Text("Strategy: Diagnostic Logging (CET + RED4ext C++)")
    ImGui.Text("C++ Native: " .. (state.nativeAvailable and "LOADED" or "NOT LOADED"))
    ImGui.Separator()

    ImGui.Text("Logging: " .. (state.loggingActive and "ACTIVE" or "inactive"))
    local iv = {state.logInterval}
    local changed = ImGui.SliderInt("Log Interval (ticks)", iv, 10, 300)
    if changed then state.logInterval = iv[1] end
    ImGui.Text(string.format("Tick: %d", state.tickCount))

    ImGui.Separator()

    ImGui.Text("Snapshot A: " .. (state.hasSnapA and "taken" or "not taken"))
    ImGui.Text("Snapshot B: " .. (state.hasSnapB and "taken" or "not taken"))

    ImGui.Separator()

    ImGui.Text("Hover: " .. (state.hoverActive and "ACTIVE" or "inactive"))
    ImGui.Text(string.format("Target height: %.1f m", HOVER_HEIGHT))
    if state.hoverActive then
        ImGui.Text(string.format("Current Z: %.2f", state.hoverCurrentZ))
        ImGui.Text(string.format("Ground Z:  %.2f", state.hoverGroundZ))
        ImGui.Text(string.format("Target Z:  %.2f", state.hoverTargetZ))
    end

    ImGui.Separator()

    ImGui.Text(string.format("Components: %d total, %d placed", state.componentCount, state.placedCount))
    ImGui.Text("Bones: " .. (state.boneCount < 0 and "not probed" or tostring(state.boneCount)))

    ImGui.Separator()

    ImGui.Text(string.format("Player pos: (%.1f, %.1f, %.1f)",
        state.playerPos.x, state.playerPos.y, state.playerPos.z))
    ImGui.Text(string.format("Player orient: yaw=%.1f pitch=%.1f roll=%.1f",
        state.playerYaw, state.playerPitch, state.playerRoll))

    if state.cppStatus ~= "" then
        ImGui.Separator()
        ImGui.Text("C++ Status: " .. state.cppStatus)
    end

    if state.lastError ~= "" then
        ImGui.Separator()
        ImGui.PushStyleColor(ImGuiCol.Text, 1.0, 0.3, 0.3, 1.0)
        ImGui.Text("Error: " .. state.lastError)
        ImGui.PopStyleColor()
    end

    ImGui.Separator()
    ImGui.Text("Hotkeys:")
    ImGui.Text("  Toggle Log | Dump All | Snap A | Snap B (+compare)")
    ImGui.Text("  Hover Toggle | Up | Down | Stop")

    ImGui.End()
end)

registerForEvent("onShutdown", function()
    Log("=== onShutdown ===")
    state.loggingActive = false
    state.hoverActive = false
    Log("All modes deactivated")
end)
