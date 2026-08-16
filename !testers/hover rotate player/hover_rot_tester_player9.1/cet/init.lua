--===========================================================================
-- HoverRotTesterPlayer9.1 - Diagnostic Logging
--
-- Strategy: Pure observation -- no transform overrides
-- Goal: Identify which transform/bone/component the renderer reads for player
--        body orientation, and document the full transform chain.
--
-- CET-only mod. All logging, snapshots, hover PD controller, and ImGui live here.
-- No rotation overrides, no bone writes, no camera manipulation.
--
-- References:
--   goals 1 - logging.md (tester 9)
--   hover_vehicle_tester2/init.lua (PD controller pattern)
--   hover_rot_tester_player7b/cet/init.lua (logging/hotkey pattern)
--   hover_rot_tester_player8/cet/init.lua (PSMImpulse hover pattern)
--===========================================================================

local ModName = "HoverRotPlayer9_1"

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

--===========================================================================
-- CONFIGURATION
--===========================================================================

local HOVER_HEIGHT    = 3.0    -- meters above ground
local SPRING_K       = 0.8    -- Kp: spring constant for height correction
local DAMPING_K      = 2.0    -- Kd: damping to prevent oscillation
local MAX_DV         = 3.0    -- max delta-v per axis per frame
local GROUND_RAY_DIST = 50.0  -- max raycast distance
local GRAVITY        = 9.81   -- m/s^2

--===========================================================================
-- STATE
--===========================================================================

local state = {
    -- Logging
    loggingActive   = false,
    logInterval     = 60,    -- ticks between log dumps (default ~1s)
    tickCount       = 0,

    -- Snapshots
    snapshotA       = nil,   -- table of transform data
    snapshotB       = nil,
    hasSnapA        = false,
    hasSnapB        = false,

    -- Component cache
    componentCount  = 0,
    placedCount     = 0,
    boneCount       = -1,    -- -1 = not probed, 0+ = probed result
    lastComponents  = nil,   -- cached list from last enumeration

    -- Hover
    hoverActive     = false,
    hoverTargetZ    = 0.0,
    hoverGroundZ    = 0.0,
    hoverCurrentZ   = 0.0,
    prevZ           = 0.0,
    hasPrevZ        = false,
    hoverVelocity   = 0.0,

    -- Player position/orientation (updated each tick when logging active)
    playerPos       = {x=0, y=0, z=0},
    playerYaw       = 0.0,
    playerPitch     = 0.0,
    playerRoll      = 0.0,

    -- Errors
    lastError       = "",
}

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
    -- Fallback: raw quaternion components
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
-- COMPONENT ENUMERATION
--===========================================================================

--- Collect all components from player entity, classify placed vs non-placed.
--- Returns: total count, placed count, list of {name, className, isPlaced, pos, yaw, pitch, roll}
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

    -- compList is typically a table we can iterate
    for _, comp in ipairs(compList) do
        total = total + 1
        local entry = {
            name = "",
            className = "",
            isPlaced = false,
            pos = nil,
            yaw = 0,
            pitch = 0,
            roll = 0,
        }

        -- Get class name
        pcall(function()
            local cls = comp:GetClassName()
            if cls then
                entry.name = tostring(cls)
            end
        end)
        if entry.name == "" then
            pcall(function()
                entry.name = comp:GetType():GetName() and tostring(comp:GetType():GetName()) or ""
            end)
        end
        if entry.name == "" then
            entry.name = "unknown"
        end
        entry.className = entry.name

        -- Check if placed component (has world transform)
        local isPlaced = false
        pcall(function()
            isPlaced = comp:IsA("IPlacedComponent")
        end)
        if not isPlaced then
            -- Fallback: try to read world position
            pcall(function()
                local wt = comp:GetWorldTransform()
                if wt then isPlaced = true end
            end)
        end

        entry.isPlaced = isPlaced

        if isPlaced then
            placed = placed + 1
            -- Read world transform
            pcall(function()
                local wt = comp:GetWorldTransform()
                if wt then
                    local pos = wt:GetPosition()
                    if pos then
                        entry.pos = {x = pos.x, y = pos.y, z = pos.z}
                    end
                    local orient = wt:GetOrientation()
                    if orient then
                        entry.yaw, entry.pitch, entry.roll = QuatToEulerVals(orient)
                    end
                end
            end)
            -- Fallback: GetWorldPosition / GetWorldOrientation
            if not entry.pos then
                pcall(function()
                    local pos = comp:GetWorldPosition()
                    if pos then
                        entry.pos = {x = pos.x, y = pos.y, z = pos.z}
                    end
                end)
            end
            if entry.yaw == 0 and entry.pitch == 0 and entry.roll == 0 then
                pcall(function()
                    local orient = comp:GetWorldOrientation()
                    if orient then
                        entry.yaw, entry.pitch, entry.roll = QuatToEulerVals(orient)
                    end
                end)
            end
        end

        table.insert(components, entry)
    end

    return total, placed, components
end

--===========================================================================
-- CAMERA LOGGING
--===========================================================================

local function LogCameraTransforms(player)
    local cam = nil
    pcall(function() cam = player:GetFPPCameraComponent() end)
    if not cam then
        Log("  Camera: GetFPPCameraComponent() returned nil")
        return
    end

    -- GetLocalToWorld
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

    -- GetWorldPosition
    pcall(function()
        local pos = cam:GetWorldPosition()
        if pos then
            Log(string.format("  Camera WorldPos: %s", PosString(pos)))
        end
    end)

    -- GetWorldOrientation
    pcall(function()
        local orient = cam:GetWorldOrientation()
        if orient then
            Log(string.format("  Camera WorldOrient: %s", QuatToEulerString(orient)))
        end
    end)

    -- GetLocalOrientation
    pcall(function()
        local orient = cam:GetLocalOrientation()
        if orient then
            Log(string.format("  Camera LocalOrient: %s", QuatToEulerString(orient)))
        end
    end)

    -- GetWorldTransform
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
-- ANIMATION / SKELETON PROBING
--===========================================================================

local function ProbeAnimationComponents(player)
    Log("--- Animation / Skeleton Probing ---")

    -- Try finding components by type name
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
        local ok = pcall(function()
            found = player:FindComponentByType(typeName)
        end)
        if ok and found then
            Log(string.format("  Found component: %s", typeName))

            -- Try to get bone count
            pcall(function()
                local boneCount = found:GetBoneCount()
                if boneCount then
                    state.boneCount = boneCount
                    Log(string.format("    GetBoneCount() = %d", boneCount))
                end
            end)

            -- Try to get bone names
            pcall(function()
                for i = 0, 5 do
                    local boneName = found:GetBoneName(i)
                    if boneName then
                        Log(string.format("    Bone[%d] = %s", i, tostring(boneName)))
                    end
                end
            end)

            -- Try to get bone transforms
            pcall(function()
                for i = 0, 2 do
                    local boneXf = found:GetBoneTransform(i)
                    if boneXf then
                        local pos = boneXf:GetPosition()
                        local orient = boneXf:GetOrientation()
                        Log(string.format("    BoneTransform[%d]: pos=%s orient=%s",
                            i, PosString(pos), QuatToEulerString(orient)))
                    end
                end
            end)

            -- Try GetSkeleton
            pcall(function()
                local skeleton = found:GetSkeleton()
                if skeleton then
                    Log(string.format("    GetSkeleton() = %s", tostring(skeleton)))
                    pcall(function()
                        local count = skeleton:GetBonesCount()
                        if count then
                            state.boneCount = count
                            Log(string.format("    skeleton:GetBonesCount() = %d", count))
                        end
                    end)
                end
            end)

            -- Try ListBones / GetBones
            pcall(function()
                local bones = found:GetBones()
                if bones then
                    Log(string.format("    GetBones() returned table with %d entries", #bones))
                end
            end)
        elseif ok and not found then
            -- Quietly skip not-found types
        end
    end

    -- Try static class exploration
    pcall(function()
        local static = GetSingleton("AnimationControllerComponent")
        if static then
            Log("  Static AnimationControllerComponent singleton found")
        end
    end)

    -- If bone count still unknown, try via AnimatedComponent specifically
    if state.boneCount < 0 then
        pcall(function()
            local anim = player:FindComponentByType("AnimatedComponent")
            if anim then
                -- Try various bone access patterns
                pcall(function()
                    local skel = anim:GetSkeleton()
                    if skel then
                        state.boneCount = skel:GetBonesCount() or -1
                    end
                end)
            end
        end)
    end

    if state.boneCount < 0 then
        Log("  No bone access found via CET API")
    end
end

--===========================================================================
-- STATE MACHINE PROBING
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

    -- Try to get current state
    pcall(function()
        local stateName = sm:GetCurrentStateName()
        if stateName then
            Log(string.format("    CurrentState: %s", tostring(stateName)))
        end
    end)

    -- Try to get current state type
    pcall(function()
        local currentState = sm:GetCurrentState()
        if currentState then
            Log(string.format("    GetCurrentState: %s", tostring(currentState)))
        end
    end)

    -- Try EnableTransformUpdates
    pcall(function()
        local enabled = sm:IsTransformUpdateEnabled()
        if enabled ~= nil then
            Log(string.format("    IsTransformUpdateEnabled: %s", tostring(enabled)))
        end
    end)

    -- Try to access blackboard
    pcall(function()
        local bb = player:GetPlayerStateMachineBlackboard()
        if bb then
            Log("  PlayerStateMachineBlackboard: accessible")
            pcall(function()
                local hl = bb:GetInt("LocomotionMode")
                Log(string.format("    LocomotionMode: %s", tostring(hl)))
            end)
            pcall(function()
                local hl = bb:GetInt("HighLevel")
                Log(string.format("    HighLevel: %s", tostring(hl)))
            end)
            pcall(function()
                local vision = bb:GetInt("Vision")
                Log(string.format("    Vision: %s", tostring(vision)))
            end)
        end
    end)

    -- Check for ragdoll-related components
    pcall(function()
        local canRagdoll = player:CanRagdoll()
        Log(string.format("  CanRagdoll: %s", tostring(canRagdoll)))
    end)

    pcall(function()
        local ragdoll = player:FindComponentByType("ragdollComponent")
        if ragdoll then
            Log("  ragdollComponent: found")
        else
            Log("  ragdollComponent: not found")
        end
    end)
end

--===========================================================================
-- FULL LOG DUMP
--===========================================================================

local function DoFullLogDump(player)
    Log("=== Full Transform Dump (tick " .. state.tickCount .. ") ===")

    -- Entity-level transforms
    local pos = player:GetWorldPosition()
    local orient = player:GetWorldOrientation()
    if pos then
        state.playerPos = {x = pos.x, y = pos.y, z = pos.z}
    end
    if orient then
        state.playerYaw, state.playerPitch, state.playerRoll = QuatToEulerVals(orient)
    end
    Log(string.format("Entity WorldPos: %s", PosString(pos)))
    Log(string.format("Entity WorldOrient: %s", QuatToEulerString(orient)))

    -- Entity WorldTransform
    pcall(function()
        local wt = player:GetWorldTransform()
        if wt then
            local wtPos = wt:GetPosition()
            local wtOrient = wt:GetOrientation()
            Log(string.format("Entity WorldTransform: pos=%s orient=%s",
                PosString(wtPos), QuatToEulerString(wtOrient)))
        end
    end)

    -- Camera transforms
    LogCameraTransforms(player)

    -- Component enumeration
    local total, placed, comps = EnumerateComponents(player)
    state.componentCount = total
    state.placedCount = placed
    state.lastComponents = comps
    Log(string.format("Components: total=%d placed=%d", total, placed))

    for i, comp in ipairs(comps) do
        if comp.isPlaced then
            Log(string.format("  [%d] %s (PLACED) pos=%s yaw=%.1f pitch=%.1f roll=%.1f",
                i, comp.name, PosString(comp.pos), comp.yaw, comp.pitch, comp.roll))
        else
            Log(string.format("  [%d] %s (non-placed)", i, comp.name))
        end
    end

    Log("=== End Transform Dump ===")
end

--===========================================================================
-- BONE HIERARCHY DUMP
--===========================================================================

local function DoBoneDump(player)
    LogBoneDump("=== Full Skeleton Hierarchy Dump ===")

    local animComp = nil
    pcall(function() animComp = player:FindComponentByType("AnimatedComponent") end)
    if not animComp then
        pcall(function() animComp = player:FindComponentByType("entAnimationControllerComponent") end)
    end
    if not animComp then
        pcall(function() animComp = player:FindComponentByType("AnimationControllerComponent") end)
    end

    if not animComp then
        LogBoneDump("No animation component found for bone access")
        LogBoneDump("=== End Bone Dump ===")
        return
    end

    LogBoneDump("Animation component: " .. tostring(animComp))

    -- Attempt skeleton access
    local skeleton = nil
    pcall(function() skeleton = animComp:GetSkeleton() end)
    if not skeleton then
        LogBoneDump("GetSkeleton() returned nil")
        LogBoneDump("=== End Bone Dump ===")
        return
    end

    LogBoneDump("Skeleton: " .. tostring(skeleton))

    local boneCount = 0
    pcall(function() boneCount = skeleton:GetBonesCount() end)
    if not boneCount or boneCount == 0 then
        LogBoneDump("GetBonesCount() returned 0 or nil")
        LogBoneDump("=== End Bone Dump ===")
        return
    end

    state.boneCount = boneCount
    LogBoneDump(string.format("Bone count: %d", boneCount))

    -- Iterate all bones
    for i = 0, boneCount - 1 do
        local boneName = ""
        local parentIdx = -1
        local bonePos = nil
        local boneOrient = nil

        pcall(function() boneName = tostring(skeleton:GetBoneName(i)) end)
        pcall(function() parentIdx = skeleton:GetBoneParent(i) end)

        pcall(function()
            local bt = skeleton:GetBoneTransform(i)
            if bt then
                bonePos = bt:GetPosition()
                boneOrient = bt:GetOrientation()
            end
        end)

        LogBoneDump(string.format("  [%d] %s parent=%s pos=%s orient=%s",
            i, boneName, tostring(parentIdx),
            PosString(bonePos), QuatToEulerString(boneOrient)))
    end

    LogBoneDump("=== End Bone Dump ===")
end

--===========================================================================
-- SNAPSHOT CAPTURE & COMPARE
--===========================================================================

local function CaptureSnapshot(player)
    local snap = {
        pos = nil,
        yaw = 0,
        pitch = 0,
        roll = 0,
        components = {},
        camera = {},
    }

    -- Entity transform
    pcall(function()
        local pos = player:GetWorldPosition()
        if pos then
            snap.pos = {x = pos.x, y = pos.y, z = pos.z}
        end
    end)
    pcall(function()
        local orient = player:GetWorldOrientation()
        if orient then
            snap.yaw, snap.pitch, snap.roll = QuatToEulerVals(orient)
        end
    end)

    -- Camera transform
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

    -- Placed components transforms
    local total, placed, comps = EnumerateComponents(player)
    for _, comp in ipairs(comps) do
        if comp.isPlaced then
            table.insert(snap.components, {
                name = comp.name,
                pos = comp.pos and {x=comp.pos.x, y=comp.pos.y, z=comp.pos.z} or nil,
                yaw = comp.yaw,
                pitch = comp.pitch,
                roll = comp.roll,
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

    -- Entity position
    if a.pos and b.pos then
        LogSnap(string.format("Entity Pos: A=%s B=%s  dPos=(%.3f, %.3f, %.3f)",
            PosString(a.pos), PosString(b.pos),
            b.pos.x - a.pos.x, b.pos.y - a.pos.y, b.pos.z - a.pos.z))
    end

    -- Entity orientation
    LogSnap(string.format("Entity Orient: A(yaw=%.2f pitch=%.2f roll=%.2f) B(yaw=%.2f pitch=%.2f roll=%.2f)",
        a.yaw, a.pitch, a.roll, b.yaw, b.pitch, b.roll))
    LogSnap(string.format("  dYaw=%.2f dPitch=%.2f dRoll=%.2f",
        b.yaw - a.yaw, b.pitch - a.pitch, b.roll - a.roll))

    -- Camera
    if a.camera and b.camera then
        LogSnap(string.format("Camera Orient: A(yaw=%.2f pitch=%.2f roll=%.2f) B(yaw=%.2f pitch=%.2f roll=%.2f)",
            a.camera.yaw or 0, a.camera.pitch or 0, a.camera.roll or 0,
            b.camera.yaw or 0, b.camera.pitch or 0, b.camera.roll or 0))
        LogSnap(string.format("  dYaw=%.2f dPitch=%.2f dRoll=%.2f",
            (b.camera.yaw or 0) - (a.camera.yaw or 0),
            (b.camera.pitch or 0) - (a.camera.pitch or 0),
            (b.camera.roll or 0) - (a.camera.roll or 0)))
        if a.camera.pos and b.camera.pos then
            LogSnap(string.format("Camera Pos: A=%s B=%s", PosString(a.camera.pos), PosString(b.camera.pos)))
        end
    end

    -- Components comparison
    LogSnap("--- Component Orientation Changes ---")
    for i, compA in ipairs(a.components) do
        local compB = b.components[i]
        if compB and compA.name == compB.name then
            local dYaw = compB.yaw - compA.yaw
            local dPitch = compB.pitch - compA.pitch
            local dRoll = compB.roll - compA.roll
            local posChanged = false
            if compA.pos and compB.pos then
                local dx = compB.pos.x - compA.pos.x
                local dy = compB.pos.y - compA.pos.y
                local dz = compB.pos.z - compA.pos.z
                if math.abs(dx) > 0.01 or math.abs(dy) > 0.01 or math.abs(dz) > 0.01 then
                    posChanged = true
                end
            end
            local orientChanged = math.abs(dYaw) > 0.5 or math.abs(dPitch) > 0.5 or math.abs(dRoll) > 0.5
            if orientChanged or posChanged then
                LogSnap(string.format("  %s: dYaw=%.2f dPitch=%.2f dRoll=%.2f posChanged=%s",
                    compA.name, dYaw, dPitch, dRoll, tostring(posChanged)))
            end
        end
    end

    LogSnap("=== End Comparison ===")
end

--===========================================================================
-- HOVER PD CONTROLLER
--===========================================================================

local function GetGroundZ(x, y, z)
    local origin = Vector4.new(x, y, z + 1.0, 1)
    local dir = Vector4.new(0, 0, -1, 0)
    local hit, hitPos
    pcall(function()
        local result = Game.GetSpatialQueriesSystem():SyncRaycastByQueryPreset(
            origin, dir, GROUND_RAY_DIST, "Bullet logic", false, false
        )
        if result then
            hit = true
            hitPos = result
        end
    end)
    if hit and hitPos then
        return hitPos.z
    end
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

    -- Estimate velocity
    local velZ = 0
    if state.hasPrevZ and delta > 0 then
        velZ = (pos.z - state.prevZ) / delta
    end

    -- Anti-gravity
    local antiGravDV = GRAVITY * delta

    -- Spring-damper
    local errZ = state.hoverTargetZ - pos.z
    local springDVz = SPRING_K * errZ - DAMPING_K * velZ

    -- Total
    local dvZ = antiGravDV + springDVz

    ApplyHoverImpulse(player, dvZ)

    state.prevZ = pos.z
    state.hasPrevZ = true
end

--===========================================================================
-- HOTKEYS (ROOT LEVEL)
--===========================================================================

registerHotkey("HoverRotPlayer9_1_ToggleLog", "HoverRot 9.1: Toggle Logging", function()
    state.loggingActive = not state.loggingActive
    if state.loggingActive then
        state.tickCount = 0
        Log("Logging ACTIVATED (interval=" .. state.logInterval .. " ticks)")
    else
        Log("Logging DEACTIVATED")
    end
end)

registerHotkey("HoverRotPlayer9_1_BoneDump", "HoverRot 9.1: Bone Dump", function()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        LogBoneDump("No player available")
        return
    end
    DoBoneDump(player)
end)

registerHotkey("HoverRotPlayer9_1_SnapA", "HoverRot 9.1: Snapshot A (Before)", function()
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

registerHotkey("HoverRotPlayer9_1_SnapB", "HoverRot 9.1: Snapshot B (After)", function()
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
end)

registerHotkey("HoverRotPlayer9_1_Compare", "HoverRot 9.1: Compare Snapshots", function()
    CompareSnapshots()
end)

registerHotkey("HoverRotPlayer9_1_HoverToggle", "HoverRot 9.1: Toggle Hover", function()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        Log("No player available")
        return
    end
    state.hoverActive = not state.hoverActive
    if state.hoverActive then
        local pos = player:GetWorldPosition()
        if pos then
            state.prevZ = pos.z
            state.hasPrevZ = true
        end
        Log(string.format("Hover ACTIVATED - target height=%.1f above ground", HOVER_HEIGHT))
    else
        Log("Hover DEACTIVATED")
    end
end)

registerHotkey("HoverRotPlayer9_1_HoverUp", "HoverRot 9.1: Hover Up (+1m)", function()
    HOVER_HEIGHT = HOVER_HEIGHT + 1.0
    Log(string.format("Hover height increased to %.1f", HOVER_HEIGHT))
end)

registerHotkey("HoverRotPlayer9_1_HoverDown", "HoverRot 9.1: Hover Down (-1m)", function()
    HOVER_HEIGHT = HOVER_HEIGHT - 1.0
    Log(string.format("Hover height decreased to %.1f", HOVER_HEIGHT))
end)

registerHotkey("HoverRotPlayer9_1_HoverStop", "HoverRot 9.1: Hover Stop", function()
    state.hoverActive = false
    Log("Hover stopped")
end)

registerHotkey("HoverRotPlayer9_1_DumpNow", "HoverRot 9.1: Dump Now (One-Shot)", function()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        Log("No player available")
        return
    end
    DoFullLogDump(player)
    ProbeAnimationComponents(player)
    ProbeStateMachine(player)
end)

--===========================================================================
-- EVENT HANDLERS
--===========================================================================

registerForEvent("onInit", function()
    Log("=== onInit ===")

    -- Crash safeguard: all modes inactive on startup
    state.loggingActive = false
    state.hoverActive = false
    state.hasSnapA = false
    state.hasSnapB = false
    state.boneCount = -1
    state.tickCount = 0
    state.lastError = ""

    Log("Crash safeguard: all modes reset to inactive")
    Log("=== onInit complete ===")
end)

registerForEvent("onUpdate", function(delta)
    state.tickCount = state.tickCount + 1

    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then return end

    -- Hover PD controller runs every frame when active
    HoverUpdate(player, delta)

    -- Periodic logging
    if state.loggingActive and state.tickCount % state.logInterval == 0 then
        DoFullLogDump(player)

        -- Probe animation and state machine every 5th log cycle
        if (state.tickCount / state.logInterval) % 5 == 0 then
            ProbeAnimationComponents(player)
            ProbeStateMachine(player)
        end
    end
end)

registerForEvent("onDraw", function()
    -- Always show ImGui panel (even when inactive, for status)
    local visible = ImGui.Begin("HoverRot Player 9.1##hoverrot91", true, ImGuiWindowFlags.AlwaysAutoResize)
    if not visible then
        ImGui.End()
        return
    end

    ImGui.Text("Strategy: Diagnostic Logging (no overrides)")
    ImGui.Separator()

    -- Logging status
    ImGui.Text("Logging: " .. (state.loggingActive and "ACTIVE" or "inactive"))
    local iv = {state.logInterval}
    local changed = ImGui.SliderInt("Log Interval (ticks)", iv, 10, 300)
    if changed then
        state.logInterval = iv[1]
    end
    ImGui.Text(string.format("Tick: %d", state.tickCount))

    ImGui.Separator()

    -- Snapshot status
    ImGui.Text("Snapshot A: " .. (state.hasSnapA and "taken" or "not taken"))
    ImGui.Text("Snapshot B: " .. (state.hasSnapB and "taken" or "not taken"))

    ImGui.Separator()

    -- Hover status
    ImGui.Text("Hover: " .. (state.hoverActive and "ACTIVE" or "inactive"))
    ImGui.Text(string.format("Target height: %.1f m", HOVER_HEIGHT))
    if state.hoverActive then
        ImGui.Text(string.format("Current Z: %.2f", state.hoverCurrentZ))
        ImGui.Text(string.format("Ground Z:  %.2f", state.hoverGroundZ))
        ImGui.Text(string.format("Target Z:  %.2f", state.hoverTargetZ))
    end

    ImGui.Separator()

    -- Component info
    ImGui.Text(string.format("Components: %d total, %d placed", state.componentCount, state.placedCount))
    ImGui.Text("Bones: " .. (state.boneCount < 0 and "not probed" or tostring(state.boneCount)))

    ImGui.Separator()

    -- Player transform
    ImGui.Text(string.format("Player pos: (%.1f, %.1f, %.1f)",
        state.playerPos.x, state.playerPos.y, state.playerPos.z))
    ImGui.Text(string.format("Player orient: yaw=%.1f pitch=%.1f roll=%.1f",
        state.playerYaw, state.playerPitch, state.playerRoll))

    if state.lastError ~= "" then
        ImGui.Separator()
        ImGui.PushStyleColor(ImGuiCol.Text, 1.0, 0.3, 0.3, 1.0)
        ImGui.Text("Error: " .. state.lastError)
        ImGui.PopStyleColor()
    end

    ImGui.Separator()
    ImGui.Text("Hotkeys:")
    ImGui.Text("  Toggle Log | Dump Now | Bone Dump")
    ImGui.Text("  Snap A | Snap B | Compare")
    ImGui.Text("  Hover Toggle | Up | Down | Stop")

    ImGui.End()
end)

registerForEvent("onShutdown", function()
    Log("=== onShutdown ===")
    state.loggingActive = false
    state.hoverActive = false
    Log("All modes deactivated")
end)
