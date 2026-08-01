--[[
  Player Entity Interrogation Tester (Player 3)

  Dead simple: NO rotation, NO hover. Just interrogate what the player
  entity supports — components, ragdoll, state machine, methods, etc.

  This will help us decide what to try next for body rotation.

  Install: Copy this folder to:
    bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player3

  Bind hotkey in: Settings > Key Bindings > PlayerInterrogator3
  Then press the key in-game to dump everything to the CET console.
]]

local ModName = "PlayerInterrogator3"

--===========================================================================
-- Helpers
--===========================================================================

--- Safely call a no-arg method on an object and return (ok, result)
local function safeCall(label, obj, methodName)
    local ok, result = pcall(function()
        return obj[methodName](obj)
    end)
    if ok then
        print(string.format("[%s] %s: %s", ModName, label, tostring(result)))
    else
        print(string.format("[%s] %s: ERROR: %s", ModName, label, tostring(result)))
    end
    return ok, result
end

--- Safely call a method with args
local function safeCallArgs(label, obj, methodName, ...)
    local args = {...}
    local ok, result = pcall(function()
        return obj[methodName](obj, unpack(args))
    end)
    if ok then
        print(string.format("[%s] %s: %s", ModName, label, tostring(result)))
    else
        print(string.format("[%s] %s: ERROR: %s", ModName, label, tostring(result)))
    end
    return ok, result
end

--- Check if an object has a method (doesn't call it)
local function hasMethod(obj, methodName)
    local ok, has = pcall(function()
        return type(obj[methodName]) == "function"
    end)
    return ok and has
end

--- Format a Vector4/Vector3-ish table
local function fmtVec(v)
    if not v then return "nil" end
    local ok, s = pcall(function()
        return string.format("(%.3f, %.3f, %.3f, %.3f)", v.x or 0, v.y or 0, v.z or 0, v.w or 0)
    end)
    if ok then return s end
    return tostring(v)
end

--===========================================================================
-- Main Interrogation Function
--===========================================================================

local function interrogate()
    local player = Game.GetPlayer()
    if not player then
        print(string.format("[%s] ERROR: No player entity found", ModName))
        return
    end

    print(string.format("[%s] =========================================", ModName))
    print(string.format("[%s] ===== PLAYER ENTITY INTERROGATION =====", ModName))
    print(string.format("[%s] =========================================", ModName))

    -----------------------------------------------------------------------
    -- 1. IDENTITY & CLASS HIERARCHY
    -----------------------------------------------------------------------
    print(string.format("[%s] --- IDENTITY ---", ModName))

    local eid = nil
    pcall(function() eid = player:GetEntityID() end)
    print(string.format("[%s] GetEntityID: %s", ModName, tostring(eid)))

    local rid = nil
    pcall(function() rid = player:GetRecordID() end)
    print(string.format("[%s] GetRecordID: %s", ModName, tostring(rid)))

    local record = nil
    pcall(function() record = player:GetRecord() end)
    if record then
        print(string.format("[%s] GetRecord: %s", ModName, tostring(record)))
        local okName, rName = pcall(function() return record:GetName() end)
        if okName and rName then
            print(string.format("[%s] Record name: %s", ModName, tostring(rName)))
        end
    else
        print(string.format("[%s] GetRecord: nil/error", ModName))
    end

    safeCall("IsAttached", player, "IsAttached")

    -- Class hierarchy checks via IsA
    print(string.format("[%s] --- CLASS HIERARCHY (IsA) ---", ModName))
    local classes = {
        "PlayerPuppet", "ScriptedPuppet", "gamePuppet", "gamePuppetBase",
        "GameObject", "GameEntity", "Entity", "TimeDilatable",
        "IScriptable", "PersistentState",
    }
    for _, cls in ipairs(classes) do
        local ok, result = pcall(function() return player:IsA(cls) end)
        if ok then
            print(string.format("[%s] IsA(%s): %s", ModName, cls, tostring(result)))
        else
            print(string.format("[%s] IsA(%s): ERROR: %s", ModName, cls, tostring(result)))
        end
    end

    -- Try to get the class name
    print(string.format("[%s] --- CLASS NAME ---", ModName))
    local okCN, cn = pcall(function() return player:GetClassName() end)
    if okCN and cn then
        print(string.format("[%s] GetClassName(): %s", ModName, tostring(cn)))
    else
        print(string.format("[%s] GetClassName(): not available", ModName))
    end

    -- Try Game.GetClassName global
    local okGCN, gcn = pcall(function() return GetClassName(player) end)
    if okGCN and gcn then
        print(string.format("[%s] GetClassName(player): %s", ModName, tostring(gcn)))
    else
        print(string.format("[%s] GetClassName(player): not available", ModName))
    end

    -----------------------------------------------------------------------
    -- 2. TRANSFORM
    -----------------------------------------------------------------------
    print(string.format("[%s] --- TRANSFORM ---", ModName))

    local pos = nil
    pcall(function() pos = player:GetWorldPosition() end)
    if pos then
        print(string.format("[%s] Position: %s", ModName, fmtVec(pos)))
    else
        print(string.format("[%s] GetWorldPosition: nil/error", ModName))
    end

    local orient = nil
    pcall(function() orient = player:GetWorldOrientation() end)
    if orient then
        print(string.format("[%s] GetWorldOrientation: %s", ModName, tostring(orient)))
        local okE, euler = pcall(function() return orient:ToEulerAngles() end)
        if okE and euler then
            print(string.format("[%s] Orientation Euler: roll=%.2f pitch=%.2f yaw=%.2f",
                ModName, euler.roll, euler.pitch, euler.yaw))
        end
    else
        print(string.format("[%s] GetWorldOrientation: nil/error", ModName))
    end

    safeCall("GetWorldYaw", player, "GetWorldYaw")

    local vel = nil
    pcall(function() vel = player:GetVelocity() end)
    if vel then
        print(string.format("[%s] Velocity: %s", ModName, fmtVec(vel)))
    else
        print(string.format("[%s] GetVelocity: nil/error", ModName))
    end

    -- Try GetLocalPosition / GetLocalOrientation too
    safeCall("GetLocalPosition", player, "GetLocalPosition")
    safeCall("GetLocalOrientation", player, "GetLocalOrientation")

    -----------------------------------------------------------------------
    -- 3. COMPONENTS — try every known component getter
    -----------------------------------------------------------------------
    print(string.format("[%s] --- COMPONENT GETTERS ---", ModName))

    local componentGetters = {
        -- Camera
        "GetFPPCameraComponent",
        "GetCameraComponent",
        -- Animation
        "GetAnimationController",
        "GetAnimatedComponent",
        -- Mesh / visual
        "GetMorphedMesh",
        "GetMeshComponent",
        "GetMeshComponents",
        -- AI
        "GetAIComponent",
        -- Movement / state
        "GetPlayerControlledComponent",
        "GetStateMachineComponent",
        "GetMovementComponent",
        "GetLocomotionComponent",
        -- Targeting / senses
        "GetTargetTrackerComponent",
        "GetSenseComponent",
        -- Stats / pools
        "GetHealthStatPoolComponent",
        "GetStaminaStatPoolComponent",
        -- Combat
        "GetCombatController",
        "GetVisionModeController",
        -- Inventory / equipment
        "GetInventoryComponent",
        "GetEquipmentComponent",
        "GetAttachmentSlotsComponent",
        -- Vehicle
        "GetVehicleComponent",
        "GetMountedVehicle",
        -- PSM
        "GetPSM",
        -- Other
        "GetMappinComponent",
        "GetCrowdMemberComponent",
        "GetSquadMemberComponent",
        "GetHitReactionComponent",
        "GetStatusEffectManagerComponent",
        "GetSoundComponent",
        -- Physics / ragdoll
        "GetRagdollComponent",
        "GetPhysicsComponent",
        "GetPhysicalMeshComponent",
        -- Script components
        "GetScriptableComponents",
    }

    local foundComponents = {}
    for _, getter in ipairs(componentGetters) do
        local ok, comp = pcall(function() return player[getter](player) end)
        if ok and comp then
            print(string.format("[%s] %s: FOUND -> %s", ModName, getter, tostring(comp)))
            foundComponents[#foundComponents + 1] = { name = getter, comp = comp }
        else
            print(string.format("[%s] %s: nil/not available", ModName, getter))
        end
    end

    -----------------------------------------------------------------------
    -- 4. COMPONENT LOOKUP BY NAME / TYPE
    -----------------------------------------------------------------------
    print(string.format("[%s] --- FIND COMPONENT BY NAME ---", ModName))

    local componentNames = {
        "ragdoll", "Ragdoll", "RagdollComponent", "gameRagdollComponent",
        "physics", "Physics", "PhysicsComponent",
        "AnimatedComponent", "AnimationController",
        "MorphedMesh", "MeshComponent", "PhysicalMeshComponent",
        "FPPCameraComponent",
        "gamePlayerControlledComponent",
        "gameStateMachineComponent",
        "gameTargetTrackerComponent",
        "gameSenseManagerComponent",
        "NPCPuppet",
        "PlayerPuppet",
        "gamePuppet",
    }

    for _, name in ipairs(componentNames) do
        local ok, comp = pcall(function() return player:FindComponentByName(name) end)
        if ok and comp then
            print(string.format("[%s] FindComponentByName('%s'): FOUND -> %s", ModName, name, tostring(comp)))
        else
            print(string.format("[%s] FindComponentByName('%s'): nil/error", ModName, name))
        end
    end

    -- Try GetComponent (by class/type)
    print(string.format("[%s] --- GET COMPONENT BY TYPE ---", ModName))

    local typeNames = {
        "gameRagdollComponent",
        "entAnimatedComponent",
        "gameAnimationController",
        "entMeshComponent",
        "entPhysicalMeshComponent",
        "gameFPPCameraComponent",
        "gameAIComponent",
        "gamePlayerControlledComponent",
        "gameStateMachineComponent",
    }

    for _, tn in ipairs(typeNames) do
        local ok, comp = pcall(function() return player:GetComponent(tn) end)
        if ok and comp then
            print(string.format("[%s] GetComponent('%s'): FOUND -> %s", ModName, tn, tostring(comp)))
        else
            print(string.format("[%s] GetComponent('%s'): nil/error", ModName, tn))
        end
    end

    -- Try GetAllComponents / GetComponents (may not exist in CET)
    print(string.format("[%s] --- ENUMERATE ALL COMPONENTS ---", ModName))

    local okAll, allComps = pcall(function() return player:GetAllComponents() end)
    if okAll and allComps then
        print(string.format("[%s] GetAllComponents() returned %d items", ModName, #allComps))
        for i, comp in ipairs(allComps) do
            local okCN, cn = pcall(function() return comp:GetClassName() end)
            print(string.format("[%s]   [%d] %s (className=%s)", ModName, i, tostring(comp), okCN and tostring(cn) or "?"))
        end
    else
        print(string.format("[%s] GetAllComponents(): not available (%s)", ModName, tostring(allComps)))
    end

    local okComps, comps = pcall(function() return player:GetComponents() end)
    if okComps and comps then
        print(string.format("[%s] GetComponents() returned %d items", ModName, #comps))
        for i, comp in ipairs(comps) do
            local okCN, cn = pcall(function() return comp:GetClassName() end)
            print(string.format("[%s]   [%d] %s (className=%s)", ModName, i, tostring(comp), okCN and tostring(cn) or "?"))
        end
    else
        print(string.format("[%s] GetComponents(): not available (%s)", ModName, tostring(comps)))
    end

    -----------------------------------------------------------------------
    -- 5. RAGDOLL EVENTS — try queueing them
    -----------------------------------------------------------------------
    print(string.format("[%s] --- RAGDOLL EVENT ATTEMPTS ---", ModName))

    -- Try CreateForceRagdollEvent (static constructor from animCommunication)
    local okFR, resultFR = pcall(function()
        local evt = CreateForceRagdollEvent()
        player:QueueEvent(evt)
        return true
    end)
    if okFR then
        print(string.format("[%s] CreateForceRagdollEvent: QUEUED OK", ModName))
    else
        print(string.format("[%s] CreateForceRagdollEvent: ERROR: %s", ModName, tostring(resultFR)))
    end

    -- Try RagdollActivationRequestEvent
    local okRA, resultRA = pcall(function()
        local evt = RagdollActivationRequestEvent.new()
        player:QueueEvent(evt)
        return true
    end)
    if okRA then
        print(string.format("[%s] RagdollActivationRequestEvent: QUEUED OK", ModName))
    else
        print(string.format("[%s] RagdollActivationRequestEvent: ERROR: %s", ModName, tostring(resultRA)))
    end

    -- Try RagdollApplyImpulseEvent
    local okAI, resultAI = pcall(function()
        local evt = RagdollApplyImpulseEvent.new()
        evt.impulse = Vector4.new(0, 0, 5, 0)
        player:QueueEvent(evt)
        return true
    end)
    if okAI then
        print(string.format("[%s] RagdollApplyImpulseEvent: QUEUED OK", ModName))
    else
        print(string.format("[%s] RagdollApplyImpulseEvent: ERROR: %s", ModName, tostring(resultAI)))
    end

    -- Try RagdollDisableEvent
    local okRD, resultRD = pcall(function()
        local evt = RagdollDisableEvent.new()
        player:QueueEvent(evt)
        return true
    end)
    if okRD then
        print(string.format("[%s] RagdollDisableEvent: QUEUED OK", ModName))
    else
        print(string.format("[%s] RagdollDisableEvent: ERROR: %s", ModName, tostring(resultRD)))
    end

    -----------------------------------------------------------------------
    -- 6. RAGDOLL METHOD PROBES
    -----------------------------------------------------------------------
    print(string.format("[%s] --- RAGDOLL METHOD PROBES ---", ModName))

    local ragdollMethods = {
        "IsRagdolling",
        "CanRagdoll",
        "ForceRagdoll",
        "DisableRagdoll",
        "IsRagdolled",
        "GetRagdollComponent",
        "EnableRagdoll",
        "ToggleRagdoll",
    }

    for _, methodName in ipairs(ragdollMethods) do
        local has = hasMethod(player, methodName)
        print(string.format("[%s] has %s(): %s", ModName, methodName, tostring(has)))
        if has then
            local ok, result = pcall(function() return player[methodName](player) end)
            if ok then
                print(string.format("[%s]   %s() -> %s", ModName, methodName, tostring(result)))
            else
                print(string.format("[%s]   %s() -> ERROR: %s", ModName, methodName, tostring(result)))
            end
        end
    end

    -----------------------------------------------------------------------
    -- 7. STATE MACHINE / BLACKBOARD
    -----------------------------------------------------------------------
    print(string.format("[%s] --- STATE MACHINE / BLACKBOARD ---", ModName))

    safeCall("GetBlackboard", player, "GetBlackboard")
    safeCall("GetActiveState", player, "GetActiveState")
    safeCall("GetPSM", player, "GetPSM")
    safeCall("GetStateMachine", player, "GetStateMachine")
    safeCall("GetStateMachineComponent", player, "GetStateMachineComponent")

    -- Try reading PSM public state
    local okPSM, psm = pcall(function() return player:GetPSM() end)
    if okPSM and psm then
        local okState, state = pcall(function() return psm:GetCurrentPublicState() end)
        if okState and state then
            print(string.format("[%s] PSM GetCurrentPublicState: %s", ModName, tostring(state)))
        else
            print(string.format("[%s] PSM GetCurrentPublicState: error", ModName))
        end
        -- Try enumerating what methods PSM has
        local psmMethods = {
            "GetCurrentState", "GetState", "GetStateName",
            "GetCurrentPublicState", "GetPreviousState",
            "GetBlackboard", "GetBlackboardId",
        }
        for _, m in ipairs(psmMethods) do
            local has = hasMethod(psm, m)
            if has then
                local ok2, r2 = pcall(function() return psm[m](psm) end)
                print(string.format("[%s] PSM.%s(): %s", ModName, m, ok2 and tostring(r2) or "error"))
            end
        end
    end

    -----------------------------------------------------------------------
    -- 8. APPEARANCE / MESH
    -----------------------------------------------------------------------
    print(string.format("[%s] --- APPEARANCE / MESH ---", ModName))

    safeCall("GetCurrentAppearanceName", player, "GetCurrentAppearanceName")
    safeCall("GetAppearanceName", player, "GetAppearanceName")
    safeCall("GetDisplayName", player, "GetDisplayName")
    safeCall("GetTweakDBDisplayName", player, "GetTweakDBDisplayName")

    -----------------------------------------------------------------------
    -- 9. SET WORLD TRANSFORM TEST (identity — confirm the no-op)
    -----------------------------------------------------------------------
    print(string.format("[%s] --- SETWORLDTRANSFORM IDENTITY TEST ---", ModName))

    pcall(function()
        local pos = player:GetWorldPosition()
        local orient = player:GetWorldOrientation()

        local wt = WorldTransform.new()
        wt:SetPosition(Vector4.new(pos.x, pos.y, pos.z, 1))
        wt:SetOrientation(orient)

        local swtOk = player:SetWorldTransform(wt)
        print(string.format("[%s] SetWorldTransform(identity) returned: %s", ModName, tostring(swtOk)))

        local pos2 = player:GetWorldPosition()
        local orient2 = player:GetWorldOrientation()
        local okE, euler2 = pcall(function() return orient2:ToEulerAngles() end)

        print(string.format("[%s] Position before: (%.2f, %.2f, %.2f)  after: (%.2f, %.2f, %.2f)",
            ModName, pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z))

        if okE and euler2 then
            print(string.format("[%s] Orientation after: roll=%.2f pitch=%.2f yaw=%.2f",
                ModName, euler2.roll, euler2.pitch, euler2.yaw))
        end
    end)

    -----------------------------------------------------------------------
    -- 10. TELEPORT TEST (does Teleport exist? It might set orientation)
    -----------------------------------------------------------------------
    print(string.format("[%s] --- TELEPORT PROBE ---", ModName))

    local okTP, resultTP = pcall(function()
        local tpFac = Game.GetTeleportationFacility()
        if tpFac then
            print(string.format("[%s] GetTeleportationFacility: FOUND -> %s", ModName, tostring(tpFac)))

            -- Try to see what methods it has
            local tpMethods = {"Teleport", "TeleportWithOrientation", "TeleportEntity"}
            for _, m in ipairs(tpMethods) do
                local has = hasMethod(tpFac, m)
                if has then
                    print(string.format("[%s]   TPFacility.%s(): EXISTS", ModName, m))
                end
            end
        else
            print(string.format("[%s] GetTeleportationFacility: nil", ModName))
        end
        return true
    end)
    if not okTP then
        print(string.format("[%s] Teleport probe ERROR: %s", ModName, tostring(resultTP)))
    end

    -----------------------------------------------------------------------
    -- 11. COMPREHENSIVE METHOD EXISTENCE CHECK
    -----------------------------------------------------------------------
    print(string.format("[%s] --- METHOD EXISTENCE CHECK ---", ModName))

    local methodsToCheck = {
        -- Transform
        "GetWorldPosition", "GetWorldOrientation", "GetWorldYaw", "GetVelocity",
        "SetWorldTransform", "SetWorldPosition", "SetWorldOrientation",
        "GetLocalPosition", "GetLocalOrientation", "SetLocalPosition", "SetLocalOrientation",
        -- Entity
        "GetEntityID", "GetRecordID", "GetRecord", "IsAttached", "QueueEvent",
        -- Components
        "GetFPPCameraComponent", "FindComponentByName", "GetComponent", "GetComponents",
        "GetAllComponents", "HasComponent", "GetComponentByClassName",
        -- Ragdoll
        "CanRagdoll", "IsRagdolling", "ForceRagdoll", "DisableRagdoll",
        "GetRagdollComponent", "EnableRagdoll",
        -- Animation
        "GetAnimationController", "GetAnimatedComponent", "GetMorphedMesh",
        -- State
        "GetBlackboard", "GetPSM", "GetActiveState", "GetStateMachine",
        "GetStateMachineComponent",
        -- Stats
        "GetHealth", "GetStatValue", "GetStatPoolValue",
        -- Movement / physics
        "GetMovementComponent", "GetLocomotionComponent",
        "GetPhysicsComponent", "GetPhysicalMeshComponent",
        -- Vehicle
        "GetVehicleComponent", "GetMountedVehicle",
        -- Other
        "GetCurrentAppearanceName", "GetDisplayName",
        "Kill", "Resurrect", "Teleport",
        "OnGameAttached", "GetEntity", "GetGame",
        "GetGameInstance", "GetEntityHandle",
        -- Scriptable system
        "GetScriptableSystem", "GetScriptableSystemsContainer",
        -- Physics impulses
        "ApplyImpulse", "AddImpulse", "ApplyForce",
    }

    local foundMethods = {}
    for _, methodName in ipairs(methodsToCheck) do
        local has = hasMethod(player, methodName)
        if has then
            foundMethods[#foundMethods + 1] = methodName
            print(string.format("[%s] HAS: %s", ModName, methodName))
        end
    end

    print(string.format("[%s] --- FOUND %d METHODS ---", ModName, #foundMethods))

    -----------------------------------------------------------------------
    -- 12. GAME SYSTEMS RELEVANT TO ROTATION
    -----------------------------------------------------------------------
    print(string.format("[%s] --- GAME SYSTEMS ---", ModName))

    local systemGetters = {
        { name = "GetStatsSystem",          game = true },
        { name = "GetStatPoolsSystem",      game = true },
        { name = "GetStatusEffectSystem",   game = true },
        { name = "GetSpatialQueriesSystem", game = true },
        { name = "GetTeleportationFacility", game = true },
        { name = "GetTargetingSystem",      game = true },
        { name = "GetVehicleSystem",        game = true },
        { name = "GetAnimationSystem",     game = true },
        { name = "GetFxSystem",             game = true },
        { name = "GetGodModeSystem",        game = true },
        { name = "GetDamageSystem",         game = true },
        { name = "GetTimeSystem",           game = true },
        { name = "GetDelaySystem",          game = true },
        { name = "GetPlayerSystem",         game = true },
        { name = "GetScriptableSystemsContainer", game = true },
    }

    for _, sys in ipairs(systemGetters) do
        local obj = nil
        if sys.game then
            local ok, result = pcall(function() return Game[sys.name](Game) end)
            if ok and result then
                print(string.format("[%s] Game.%s(): FOUND -> %s", ModName, sys.name, tostring(result)))
            else
                print(string.format("[%s] Game.%s(): nil/error", ModName, sys.name))
            end
        end
    end

    -----------------------------------------------------------------------
    -- 13. EXAMINE FOUND COMPONENTS DEEPER
    -----------------------------------------------------------------------
    print(string.format("[%s] --- COMPONENT DETAILS ---", ModName))

    for _, fc in ipairs(foundComponents) do
        print(string.format("[%s] Examining %s (%s)", ModName, fc.name, tostring(fc.comp)))

        -- Try to get class name
        local okCN, cn = pcall(function() return fc.comp:GetClassName() end)
        if okCN and cn then
            print(string.format("[%s]   ClassName: %s", ModName, tostring(cn)))
        end

        -- Check for orientation/transform methods on the component
        local compMethods = {
            "GetWorldPosition", "GetWorldOrientation", "GetLocalPosition", "GetLocalOrientation",
            "SetWorldPosition", "SetWorldOrientation", "SetLocalPosition", "SetLocalOrientation",
            "SetWorldTransform", "GetWorldTransform",
            "GetClassName", "GetName",
            "IsEnabled", "IsActive",
            "GetEntity",
        }

        for _, m in ipairs(compMethods) do
            local has = hasMethod(fc.comp, m)
            if has then
                print(string.format("[%s]   HAS: %s", ModName, m))
            end
        end
    end

    -----------------------------------------------------------------------
    -- 14. DUMP PLAYER AS TABLE (CET reflection if available)
    -----------------------------------------------------------------------
    print(string.format("[%s] --- CET REFLECTION DUMP ---", ModName))

    -- Try to iterate over player's methods using CET's built-in reflection
    local okDump, dumpResult = pcall(function()
        -- CET may expose a global Dump or GetClassInfo
        if type(Dump) == "function" then
            return Dump(player)
        end
        return nil
    end)
    if okDump and dumpResult then
        print(string.format("[%s] Dump(player): %s", ModName, tostring(dumpResult)))
    else
        print(string.format("[%s] Dump(player): not available", ModName))
    end

    -- Try GetClass
    local okClass, classResult = pcall(function()
        if type(GetClass) == "function" then
            return GetClass(player)
        end
        return nil
    end)
    if okClass and classResult then
        print(string.format("[%s] GetClass(player): %s", ModName, tostring(classResult)))
    else
        print(string.format("[%s] GetClass(player): not available", ModName))
    end

    print(string.format("[%s] =========================================", ModName))
    print(string.format("[%s] ===== INTERROGATION COMPLETE =====", ModName))
    print(string.format("[%s] =========================================", ModName))
end

--===========================================================================
-- Root-Level Hotkey
-- (MUST be at file root level — CET discovers these during its initial
--  scan pass, before onInit fires. See CET hotkey registration rule.)
--===========================================================================

registerHotkey("PI3_Interrogate", "Interrogate Player (P3)", function()
    interrogate()
end)

--===========================================================================
-- Event Handlers
--===========================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized — bind 'Interrogate Player (P3)' in Settings > Key Bindings", ModName))
end)

registerForEvent("onShutdown", function()
    -- Nothing to clean up — this mod only logs on hotkey
end)
