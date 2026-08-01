--===========================================================================
-- Hover Rot Tester Player 6b — PSM State Machine Manipulation + Teleport
--
-- Copy of tester 6a with safety re-teleport restored from tester 6:
--   1. SAFETY RE-TELEPORT RESTORED: When player falls below threshold, a
--      separate Teleport API call (never SWT) teleports player back to
--      targetZ with yaw-only orientation, resetting fall velocity. This
--      prevents fall damage (teleport resets velocity) and keeps player
--      airborne even when SetWorldTransform is the selected rotation method.
--   2. HEIGHT RESTORED TO 50: Initial teleport goes to pos.z + 50.
--   3. All names/IDs updated from Player6a/HRTP6A to Player6b/HRTP6B
--
-- Original tester 6a fixes (kept in 6b):
--   1. RE-TELEPORT BUG FIXED: teleport back to state.targetZ (not falling pos.z)
--   2. SM IDENTIFIER CONSTRUCTION IMPROVED: try multiple StateMachineIdentifier
--      construction approaches (different field names, contextTypes, etc.)
--   3. PSM RESET on mode switch: restore saved PSM values before switching modes
--
-- Original tester 6 steps (from player3 next steps.md):
--   Step 3: Access gamestateMachineComponent via FindComponentByType
--   Step 7: GetPlayerStateMachineBlackboard for PSM state manipulation
--
-- Hypothesis: The locomotion state machine enforces roll=0, pitch=0 every
-- frame. If we can write PSM blackboard variables to put the player into a
-- state that doesn't enforce upright orientation (Dead, Swimming, Scene,
-- Felled, Knockdown, Workspot, Mounted), then Teleport's EulerAngles
-- parameter might actually set full 3-axis rotation.
--
-- State modes (cycle with hotkey):
--   1. NONE      — no PSM manipulation (control, same as tester 4)
--   2. DEAD      — Vitals=Dead (dead bodies don't enforce upright)
--   3. SWIMMING  — HighLevel=Swimming (different physics)
--   4. SCENE     — HighLevel=SceneTier1 (cutscene/scene state)
--   5. FELLED    — Felled=true, LocomotionDetailed=Felled
--   6. KNOCKDOWN — LocomotionDetailed=Knockdown
--   7. WORKSPOT  — Locomotion=Workspot, IsInWorkspot=1
--   8. MOUNTED   — MountedToVehicle=true (without actual vehicle)
--   9. AIR_HOVER — LocomotionDetailed=AirHover (built-in hover state)
--
-- Hotkeys (bind in Settings > Key Bindings > HoverRotTesterPlayer6b):
--   1. Toggle Hover (Player6b)       — enable/disable the tester
--   2. Cycle State Mode (Player6b)   — cycle through PSM state modes
--   3. Toggle Rotation Method (P6b)  — switch between Teleport and SetWorldTransform
--   4. Dump PSM State (Player6b)     — print all PSM blackboard values
--   5. Probe SM Component (Player6b)— dump gamestateMachineComponent info
--   6. Yaw +30 (Player6b)           — rotate yaw +ROT_STEP
--   7. Yaw -30 (Player6b)           — rotate yaw -ROT_STEP
--   8. Pitch +30 (Player6b)         — rotate pitch +ROT_STEP
--   9. Pitch -30 (Player6b)         — rotate pitch -ROT_STEP
--  10. Roll +30 (Player6b)          — rotate roll +ROT_STEP
--  11. Roll -30 (Player6b)          — rotate roll -ROT_STEP
--
-- Install: Copy to bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player6b
--===========================================================================

local ModName  = "HoverRotTesterPlayer6b"
local ROT_STEP = 30    -- degrees per rotation press
local NUM_DIAG = 2     -- frames of debug output after a change (low to keep banners visible)

--===========================================================================
-- State Mode Definitions
--===========================================================================

local StateModes = {
    {
        name = "NONE",
        desc = "No PSM manipulation (control)",
        apply = function(psmBB, psmDef) end,
    },
    {
        name = "DEAD",
        desc = "Vitals=Dead — dead bodies don't enforce upright",
        apply = function(psmBB, psmDef)
            pcall(function() psmBB:SetInt(psmDef.Vitals, 1) end)       -- gamePSMVitals.Dead = 1
        end,
    },
    {
        name = "SWIMMING",
        desc = "HighLevel=Swimming — swimming has different physics",
        apply = function(psmBB, psmDef)
            pcall(function() psmBB:SetInt(psmDef.HighLevel, 6) end)    -- gamePSMHighLevel.Swimming = 6
            pcall(function() psmBB:SetInt(psmDef.Swimming, 1) end)
        end,
    },
    {
        name = "SCENE",
        desc = "HighLevel=SceneTier1 — cutscene/scene state",
        apply = function(psmBB, psmDef)
            pcall(function() psmBB:SetInt(psmDef.HighLevel, 1) end)    -- gamePSMHighLevel.SceneTier1 = 1
            pcall(function() psmBB:SetInt(psmDef.SceneTier, 1) end)
        end,
    },
    {
        name = "FELLED",
        desc = "Felled=true, LocomotionDetailed=Felled",
        apply = function(psmBB, psmDef)
            pcall(function() psmBB:SetBool(psmDef.Felled, true) end)
            pcall(function() psmBB:SetInt(psmDef.LocomotionDetailed, 31) end) -- gamePSMDetailedLocomotionStates.Felled = 31
        end,
    },
    {
        name = "KNOCKDOWN",
        desc = "LocomotionDetailed=Knockdown",
        apply = function(psmBB, psmDef)
            pcall(function() psmBB:SetInt(psmDef.LocomotionDetailed, 29) end) -- gamePSMDetailedLocomotionStates.Knockdown = 29
        end,
    },
    {
        name = "WORKSPOT",
        desc = "Locomotion=Workspot, IsInWorkspot=1 — workspot takes over transform",
        apply = function(psmBB, psmDef)
            pcall(function() psmBB:SetInt(psmDef.Locomotion, 8) end)    -- gamePSMLocomotionStates.Workspot = 8
            pcall(function() psmBB:SetInt(psmDef.IsInWorkspot, 1) end)
        end,
    },
    {
        name = "MOUNTED",
        desc = "MountedToVehicle=true — mounted state uses vehicle orientation",
        apply = function(psmBB, psmDef)
            pcall(function() psmBB:SetBool(psmDef.MountedToVehicle, true) end)
            pcall(function() psmBB:SetInt(psmDef.Vehicle, 1) end)       -- gamePSMVehicle.Driving = 1
        end,
    },
    {
        name = "AIR_HOVER",
        desc = "LocomotionDetailed=AirHover — built-in hover state",
        apply = function(psmBB, psmDef)
            pcall(function() psmBB:SetInt(psmDef.LocomotionDetailed, 16) end) -- gamePSMDetailedLocomotionStates.AirHover = 16
            pcall(function() psmBB:SetInt(psmDef.Locomotion, 4) end)    -- gamePSMLocomotionStates.Jump = 4 (air state)
        end,
    },
}

--===========================================================================
-- State
--===========================================================================

local state = {
    phase           = "IDLE",     -- IDLE | ACTIVE
    quat            = nil,        -- {w, x, y, z} current orientation
    initialZ        = 0,
    targetZ         = 0,
    reTeleportThreshold = 0,
    modeIndex       = 1,          -- current StateModes index
    useTeleport     = true,       -- true=Teleport, false=SetWorldTransform
    -- PSM blackboard refs
    psmBB           = nil,
    psmDef          = nil,
    -- SM component
    smComponent     = nil,
    -- Saved camera settings
    savedSensX      = nil,
    savedSensY      = nil,
    savedHeading    = nil,
    savedPitchMin   = nil,
    savedPitchMax   = nil,
    savedYawMaxLeft  = nil,
    savedYawMaxRight = nil,
    -- Saved PSM values (to restore on deactivate)
    savedPSM        = {},
    -- Diagnostic print throttle
    diagCounter     = 0,
    -- Re-teleport throttle (avoid log flooding)
    reTeleportCount  = 0,
    lastLoggedZ      = nil,
}

--===========================================================================
-- Quaternion Math (pure Lua)
--===========================================================================

local Quat = {}

function Quat.identity()
    return { w = 1, x = 0, y = 0, z = 0 }
end

function Quat.fromAxisAngle(ax, ay, az, deg)
    local rad = math.rad(deg)
    local half = rad * 0.5
    local s = math.sin(half)
    return {
        w = math.cos(half),
        x = ax * s,
        y = ay * s,
        z = az * s,
    }
end

function Quat.mul(q1, q2)
    return {
        w = q1.w * q2.w - q1.x * q2.x - q1.y * q2.y - q1.z * q2.z,
        x = q1.w * q2.x + q1.x * q2.w + q1.y * q2.z - q1.z * q2.y,
        y = q1.w * q2.y - q1.x * q2.z + q1.y * q2.w + q1.z * q2.x,
        z = q1.w * q2.z + q1.x * q2.y - q1.y * q2.x + q1.z * q2.w,
    }
end

function Quat.normalize(q)
    local len = math.sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z)
    if len < 0.0001 then return Quat.identity() end
    return { w = q.w / len, x = q.x / len, y = q.y / len, z = q.z / len }
end

-- Returns raw roll, pitch, yaw in degrees
function Quat.toEulerRaw(q)
    q = Quat.normalize(q)
    local w, x, y, z = q.w, q.x, q.y, q.z

    local sinr_cosp = 2 * (w * x + y * z)
    local cosr_cosp = 1 - 2 * (x * x + y * y)
    local roll = math.atan2(sinr_cosp, cosr_cosp)

    local sinp = 2 * (w * y - z * x)
    if math.abs(sinp) >= 1 then
        sinp = sinp > 0 and 1 or -1
    end
    local pitch = math.asin(sinp)

    local siny_cosp = 2 * (w * z + x * y)
    local cosy_cosp = 1 - 2 * (y * y + z * z)
    local yaw = math.atan2(siny_cosp, cosy_cosp)

    return math.deg(roll), math.deg(pitch), math.deg(yaw)
end

--===========================================================================
-- PSM Blackboard Helpers
--===========================================================================

local function initPSMBlackboard(player)
    -- Get PSM blackboard via player method
    local bb = nil
    pcall(function() bb = player:GetPlayerStateMachineBlackboard() end)
    if bb then
        print(string.format("[%s] GetPlayerStateMachineBlackboard() SUCCESS", ModName))
    else
        print(string.format("[%s] GetPlayerStateMachineBlackboard() returned nil — trying BlackboardSystem", ModName))
        -- Fallback: GetLocalInstanced via BlackboardSystem
        pcall(function()
            local bbSys = GameInstance.GetBlackboardSystem(player:GetGame())
            bb = bbSys:GetLocalInstanced(player:GetEntityID(), GetAllBlackboardDefs().PlayerStateMachine)
        end)
        if bb then
            print(string.format("[%s] BlackboardSystem fallback SUCCESS", ModName))
        else
            print(string.format("[%s] ERROR: Could not get PSM blackboard", ModName))
            return nil, nil
        end
    end

    -- Get blackboard definition
    local def = nil
    pcall(function() def = GetAllBlackboardDefs().PlayerStateMachine end)
    if def then
        print(string.format("[%s] GetAllBlackboardDefs().PlayerStateMachine SUCCESS", ModName))
    else
        print(string.format("[%s] ERROR: Could not get PlayerStateMachine blackboard def", ModName))
        return bb, nil
    end

    return bb, def
end

local function savePSMValues(psmBB, psmDef)
    local saved = {}
    -- Save all the variables we might modify
    local intVars = {
        "Locomotion", "LocomotionDetailed", "HighLevel", "UpperBody",
        "Vehicle", "SceneTier", "Swimming", "Vitals", "Combat",
        "Takedown", "Fall", "Landing", "Melee", "IsInWorkspot",
    }
    -- IsInWorkspot is an INT variable (WORKSPOT mode uses SetInt), not bool
    local boolVars = {
        "Felled", "MountedToVehicle", "MountedToVehicleInDriverSeat",
        "IsInteractingWithDevice", "IsOnGround",
        "IsMovingHorizontally", "IsMovingVertically",
    }

    for _, name in ipairs(intVars) do
        pcall(function()
            saved[name] = psmBB:GetInt(psmDef[name])
        end)
    end
    for _, name in ipairs(boolVars) do
        pcall(function()
            saved[name] = psmBB:GetBool(psmDef[name])
        end)
    end
    return saved
end

local function restorePSMValues(psmBB, psmDef, saved)
    if not saved then return end
    for name, val in pairs(saved) do
        pcall(function()
            if type(val) == "number" then
                psmBB:SetInt(psmDef[name], val)
            elseif type(val) == "boolean" then
                psmBB:SetBool(psmDef[name], val)
            end
        end)
    end
    print(string.format("[%s] PSM values restored", ModName))
end

local function dumpPSMValues(psmBB, psmDef)
    if not psmBB or not psmDef then
        print(string.format("[%s] Cannot dump — PSM blackboard not initialized", ModName))
        return
    end

    print(string.format("[%s] === PSM Blackboard Dump ===", ModName))

    local intVars = {
        {"Locomotion",            "gamePSMLocomotionStates"},
        {"LocomotionDetailed",    "gamePSMDetailedLocomotionStates"},
        {"HighLevel",             "gamePSMHighLevel"},
        {"UpperBody",             "gamePSMUpperBodyStates"},
        {"Vehicle",               "gamePSMVehicle"},
        {"SceneTier",             ""},
        {"Swimming",              ""},
        {"Vitals",                "gamePSMVitals"},
        {"Combat",                "gamePSMCombat"},
        {"Takedown",              "gamePSMTakedown"},
        {"Fall",                  "gamePSMFallStates"},
        {"Landing",               "gamePSMLandingState"},
        {"Melee",                 "gamePSMMelee"},
        {"Stamina",               "gamePSMStamina"},
        {"Zones",                 "gamePSMZones"},
    }

    local boolVars = {
        "Felled", "MountedToVehicle", "MountedToVehicleInDriverSeat",
        "MountedToCombatVehicle", "IsInWorkspot", "IsInteractingWithDevice",
        "IsOnGround", "IsMovingHorizontally", "IsMovingVertically",
        "Carrying", "UsingCover", "IsInMinigame",
        "IsInLoreAnimationScene", "IsInBodySlamState",
        "DisplayDeathMenu", "CanOnePunch",
    }

    for _, v in ipairs(intVars) do
        local name, enumName = v[1], v[2]
        local val = nil
        pcall(function() val = psmBB:GetInt(psmDef[name]) end)
        local suffix = ""
        if enumName and enumName ~= "" then
            suffix = " (" .. enumName .. ")"
        end
        print(string.format("[%s]   %s = %s%s", ModName, name, tostring(val), suffix))
    end

    for _, name in ipairs(boolVars) do
        local val = nil
        pcall(function() val = psmBB:GetBool(psmDef[name]) end)
        print(string.format("[%s]   %s = %s", ModName, name, tostring(val)))
    end

    print(string.format("[%s] === End PSM Dump ===", ModName))
end

--===========================================================================
-- SM Component Probe (IMPROVED: multiple identifier construction attempts)
--===========================================================================

local function probeSMComponent(player)
    print(string.format("[%s] === Probing gamestateMachineComponent ===", ModName))

    -- Try FindComponentByType
    local sm = nil
    pcall(function() sm = player:FindComponentByType(CName.new("gamestateMachineComponent")) end)
    if sm then
        print(string.format("[%s] FindComponentByType('gamestateMachineComponent') SUCCESS", ModName))
        state.smComponent = sm

        -- Try GetSnapshotContainer
        local snapshot = nil
        pcall(function() snapshot = sm:GetSnapshotContainer() end)
        if snapshot then
            print(string.format("[%s]   GetSnapshotContainer() SUCCESS: %s", ModName, tostring(snapshot)))
        else
            print(string.format("[%s]   GetSnapshotContainer() returned nil", ModName))
        end

        -- Try IsStateMachinePresent with multiple identifier construction approaches
        local knownSMs = {"Locomotion", "UpperBody", "HighLevel", "Combat", "Vehicle"}
        for _, smName in ipairs(knownSMs) do
            -- Approach 1: stateMachineName only (original tester 6 approach)
            local present1 = nil
            pcall(function()
                local smid = StateMachineIdentifier.new()
                smid.stateMachineName = CName.new(smName)
                present1 = sm:IsStateMachinePresent(smid)
            end)
            if present1 ~= nil then
                print(string.format("[%s]   IsStateMachinePresent('%s') [nameOnly] = %s", ModName, smName, tostring(present1)))
            end

            -- Approach 2: stateMachineName + contextType = gameplay
            local present2 = nil
            pcall(function()
                local smid = StateMachineIdentifier.new()
                smid.stateMachineName = CName.new(smName)
                smid.contextType = gameStateMachineContextType.Gameplay
                present2 = sm:IsStateMachinePresent(smid)
            end)
            if present2 ~= nil then
                print(string.format("[%s]   IsStateMachinePresent('%s') [gameplay] = %s", ModName, smName, tostring(present2)))
            end

            -- Approach 3: Try setting isOnOwner = true
            local present3 = nil
            pcall(function()
                local smid = StateMachineIdentifier.new()
                smid.stateMachineName = CName.new(smName)
                smid.isOnOwner = true
                present3 = sm:IsStateMachinePresent(smid)
            end)
            if present3 ~= nil then
                print(string.format("[%s]   IsStateMachinePresent('%s') [isOnOwner] = %s", ModName, smName, tostring(present3)))
            end

            -- Approach 4: Try with both contextType and isOnOwner
            local present4 = nil
            pcall(function()
                local smid = StateMachineIdentifier.new()
                smid.stateMachineName = CName.new(smName)
                smid.contextType = gameStateMachineContextType.Gameplay
                smid.isOnOwner = true
                present4 = sm:IsStateMachinePresent(smid)
            end)
            if present4 ~= nil then
                print(string.format("[%s]   IsStateMachinePresent('%s') [gameplay+owner] = %s", ModName, smName, tostring(present4)))
            end

            -- Approach 5: Try Dump() on the identifier to see available fields
            if present1 == false and present2 == false and present3 == false and present4 == false then
                pcall(function()
                    local smid = StateMachineIdentifier.new()
                    -- Print all fields of the identifier object
                    print(string.format("[%s]   StateMachineIdentifier fields for '%s':", ModName, smName))
                    pcall(function() print(string.format("[%s]     stateMachineName type = %s", ModName, tostring(smid.stateMachineName))) end)
                    pcall(function() print(string.format("[%s]     contextType type = %s", ModName, tostring(smid.contextType))) end)
                    pcall(function() print(string.format("[%s]     isOnOwner type = %s", ModName, tostring(smid.isOnOwner))) end)
                end)
            end
        end

        -- Also try Dump() on the SM component itself to see available methods
        pcall(function()
            print(string.format("[%s]   SM component Dump() attempt:", ModName))
            local dumpResult = sm:Dump()
            if dumpResult then
                print(string.format("[%s]   SM Dump: %s", ModName, tostring(dumpResult):sub(1, 500)))
            end
        end)

        -- Try GetStateMachineList or similar methods
        pcall(function()
            -- Some SM components have methods to list active state machines
            local list = nil
            pcall(function() list = sm:GetActiveStateMachines() end)
            if list then
                print(string.format("[%s]   GetActiveStateMachines() = %s", ModName, tostring(list)))
            end
        end)
        pcall(function()
            local list = nil
            pcall(function() list = sm:GetStateMachines() end)
            if list then
                print(string.format("[%s]   GetStateMachines() = %s", ModName, tostring(list)))
            end
        end)

    else
        print(string.format("[%s] FindComponentByType returned nil — trying GetComponents scan", ModName))
        -- Fallback: scan GetComponents for it
        pcall(function()
            local comps = player:GetComponents()
            if comps then
                for _, comp in ipairs(comps) do
                    local cn = nil
                    pcall(function() cn = comp:GetClassName() end)
                    if cn and tostring(cn) == "gamestateMachineComponent" then
                        sm = comp
                        print(string.format("[%s]   Found via GetComponents scan", ModName))
                        state.smComponent = sm
                        break
                    end
                end
            end
        end)
    end

    if not sm then
        print(string.format("[%s] Could not access gamestateMachineComponent", ModName))
    end

    print(string.format("[%s] === End SM Probe ===", ModName))
end

--===========================================================================
-- Teleport / Transform Helpers
--===========================================================================

local function teleportWithOrientation(player, pos, roll, pitch, yaw)
    local euler = EulerAngles.new(roll, pitch, yaw)
    local ok, err = pcall(function()
        Game.GetTeleportationFacility():Teleport(
            player,
            Vector4.new(pos.x, pos.y, pos.z, 1),
            euler
        )
    end)
    return ok, err
end

local function setWorldTransformWithOrientation(player, pos, roll, pitch, yaw)
    local euler = EulerAngles.new(roll, pitch, yaw)
    local quat = euler:ToQuat()
    local ok, err = pcall(function()
        local wt = WorldTransform.new()
        wt:SetPosition(Vector4.new(pos.x, pos.y, pos.z, 1))
        wt:SetOrientation(quat)
        player:SetWorldTransform(wt)
    end)
    return ok, err
end

--===========================================================================
-- Activation / Deactivation
--===========================================================================

local function activate()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        print(string.format("[%s] ERROR: Player not found", ModName))
        return
    end

    local pos = player:GetWorldPosition()
    local rot = player:GetWorldOrientation():ToEulerAngles()

    -- Store initial z and compute targets
    state.initialZ = pos.z
    state.targetZ  = pos.z + 50
    state.reTeleportThreshold = pos.z + 10

    -- Initialize quaternion from current yaw
    state.quat = Quat.fromAxisAngle(0, 0, 1, rot.yaw)

    -- Initialize PSM blackboard
    state.psmBB, state.psmDef = initPSMBlackboard(player)

    -- Save current PSM values
    if state.psmBB and state.psmDef then
        state.savedPSM = savePSMValues(state.psmBB, state.psmDef)
        print(string.format("[%s] PSM values saved", ModName))
    end

    -- Probe SM component
    probeSMComponent(player)

    -- Lock FPPCameraComponent
    pcall(function()
        local cam = player:GetFPPCameraComponent()
        if cam then
            state.savedSensX      = cam.sensitivityMultX
            state.savedSensY      = cam.sensitivityMultY
            state.savedHeading    = cam.headingLocked
            state.savedPitchMin   = cam.pitchMin
            state.savedPitchMax   = cam.pitchMax
            state.savedYawMaxLeft  = cam.yawMaxLeft
            state.savedYawMaxRight = cam.yawMaxRight

            cam.sensitivityMultX = 0
            cam.sensitivityMultY = 0
            cam.pitchMin = -180
            cam.pitchMax = 180
            cam.yawMaxLeft = 360
            cam.yawMaxRight = 360
            print(string.format("[%s] FPPCameraComponent locked", ModName))
        end
    end)

    -- Teleport player high up (to targetZ, not original pos.z)
    local highPos = Vector4.new(pos.x, pos.y, state.targetZ, 1)
    teleportWithOrientation(player, highPos, 0, 0, rot.yaw)

    state.phase = "ACTIVE"
    local mode = StateModes[state.modeIndex]
    print(string.format("[%s] === ACTIVE === mode=%s (%s)", ModName, mode.name, mode.desc))
    print(string.format("[%s] Rotation method: %s", ModName, state.useTeleport and "Teleport" or "SetWorldTransform"))
    print(string.format("[%s] target z=%.1f (initial z=%.1f)", ModName, state.targetZ, state.initialZ))
    print(string.format("[%s] Re-teleport when z < %.1f — safety teleport to z=%.1f via Teleport API", ModName, state.reTeleportThreshold, state.targetZ))
    print(string.format("[%s] Press 'Cycle State Mode' to try different PSM states", ModName))
    print(string.format("[%s] Press 'Dump PSM State' to see all PSM blackboard values", ModName))

    state.diagCounter = NUM_DIAG
end

local function deactivate()
    print(string.format("[%s] Deactivating...", ModName))

    local player = Game.GetPlayer()
    if player then
        -- Final teleport to safe height
        local pos = player:GetWorldPosition()
        local roll, pitch, yaw = Quat.toEulerRaw(state.quat or Quat.identity())
        teleportWithOrientation(player, pos, 0, 0, yaw)

        -- Restore PSM values
        if state.psmBB and state.psmDef then
            restorePSMValues(state.psmBB, state.psmDef, state.savedPSM)
        end

        -- Restore FPPCameraComponent
        pcall(function()
            local cam = player:GetFPPCameraComponent()
            if cam then
                if state.savedSensX      then cam.sensitivityMultX = state.savedSensX end
                if state.savedSensY      then cam.sensitivityMultY = state.savedSensY end
                if state.savedHeading    then cam.headingLocked = state.savedHeading end
                if state.savedPitchMin   then cam.pitchMin = state.savedPitchMin end
                if state.savedPitchMax   then cam.pitchMax = state.savedPitchMax end
                if state.savedYawMaxLeft  then cam.yawMaxLeft = state.savedYawMaxLeft end
                if state.savedYawMaxRight then cam.yawMaxRight = state.savedYawMaxRight end
            end
        end)
    end

    state.phase       = "IDLE"
    state.quat        = nil
    state.psmBB       = nil
    state.psmDef      = nil
    state.smComponent = nil
    state.savedPSM    = {}
    state.savedSensX  = nil
    state.savedSensY  = nil
    state.savedHeading = nil
    state.savedPitchMin = nil
    state.savedPitchMax = nil
    state.savedYawMaxLeft = nil
    state.savedYawMaxRight = nil
    state.diagCounter = 0
    state.reTeleportCount = 0
    state.lastLoggedZ = nil

    print(string.format("[%s] Deactivated (PSM + camera restored)", ModName))
end

local function applyRotation(ax, ay, az, deg)
    if state.phase ~= "ACTIVE" or not state.quat then return end
    local rot = Quat.fromAxisAngle(ax, ay, az, deg)
    state.quat = Quat.mul(state.quat, rot)
    state.diagCounter = NUM_DIAG
    local roll, pitch, yaw = Quat.toEulerRaw(state.quat)
    local mode = StateModes[state.modeIndex]
    print(string.format("[%s] [mode=%s] Rot -> roll=%.0f pitch=%.0f yaw=%.0f", ModName, mode.name, roll, pitch, yaw))
end

local function readPSMSummary()
    if not state.psmBB or not state.psmDef then return "PSM not init" end
    local s = {}
    pcall(function() s.Loc    = tostring(state.psmBB:GetInt(state.psmDef.Locomotion)) end)
    pcall(function() s.LocDet = tostring(state.psmBB:GetInt(state.psmDef.LocomotionDetailed)) end)
    pcall(function() s.HL     = tostring(state.psmBB:GetInt(state.psmDef.HighLevel)) end)
    pcall(function() s.Vit    = tostring(state.psmBB:GetInt(state.psmDef.Vitals)) end)
    pcall(function() s.Fel    = tostring(state.psmBB:GetBool(state.psmDef.Felled)) end)
    pcall(function() s.Mnt    = tostring(state.psmBB:GetBool(state.psmDef.MountedToVehicle)) end)
    pcall(function() s.Wk     = tostring(state.psmBB:GetInt(state.psmDef.IsInWorkspot)) end)
    pcall(function() s.Sc     = tostring(state.psmBB:GetInt(state.psmDef.SceneTier)) end)
    pcall(function() s.Sw     = tostring(state.psmBB:GetInt(state.psmDef.Swimming)) end)
    pcall(function() s.Veh    = tostring(state.psmBB:GetInt(state.psmDef.Vehicle)) end)
    return string.format("Loc=%s LocDet=%s HL=%s Vit=%s Fel=%s Mnt=%s Wk=%s Sc=%s Sw=%s Veh=%s",
        s.Loc or "?", s.LocDet or "?", s.HL or "?", s.Vit or "?", s.Fel or "?",
        s.Mnt or "?", s.Wk or "?", s.Sc or "?", s.Sw or "?", s.Veh or "?")
end

local function cycleStateMode()
    if state.phase ~= "ACTIVE" then
        print(string.format("[%s] Not active — press Toggle Hover first", ModName))
        return
    end
    -- Print PSM values BEFORE switching (shows what previous mode left)
    print(string.format("[%s] PSM BEFORE switch: %s", ModName, readPSMSummary()))
    -- CRITICAL: Restore saved PSM values before switching to new mode
    -- This prevents PSM values from stacking across modes (e.g., DEAD's Vit=1
    -- persisting into SWIMMING, FELLED, etc.) — each mode must be tested in isolation
    if state.psmBB and state.psmDef and state.savedPSM then
        restorePSMValues(state.psmBB, state.psmDef, state.savedPSM)
    end
    print(string.format("[%s] PSM RESET to saved: %s", ModName, readPSMSummary()))
    state.modeIndex = state.modeIndex + 1
    if state.modeIndex > #StateModes then
        state.modeIndex = 1
    end
    local mode = StateModes[state.modeIndex]
    local roll, pitch, yaw = Quat.toEulerRaw(state.quat)
    print(string.format("[%s] ########################################", ModName))
    print(string.format("[%s] # STATE MODE %d/%d: %s", ModName, state.modeIndex, #StateModes, mode.name))
    print(string.format("[%s] # %s", ModName, mode.desc))
    print(string.format("[%s] # Method: %s", ModName, state.useTeleport and "Teleport" or "SetWorldTransform"))
    print(string.format("[%s] # Current rotation: roll=%.0f pitch=%.0f yaw=%.0f", ModName, roll, pitch, yaw))
    print(string.format("[%s] ########################################", ModName))
    -- Apply the new mode once immediately so we can read back the values
    if state.psmBB and state.psmDef then
        mode.apply(state.psmBB, state.psmDef)
    end
    -- Print PSM values AFTER switching (shows what new mode set)
    print(string.format("[%s] PSM AFTER switch:  %s", ModName, readPSMSummary()))
    state.diagCounter = NUM_DIAG
end

local function toggleRotationMethod()
    if state.phase ~= "ACTIVE" then
        print(string.format("[%s] Not active — press Toggle Hover first", ModName))
        return
    end
    state.useTeleport = not state.useTeleport
    print(string.format("[%s] Rotation method: %s", ModName, state.useTeleport and "Teleport" or "SetWorldTransform"))
    state.diagCounter = NUM_DIAG
end

local function dumpPSM()
    if state.phase ~= "ACTIVE" then
        print(string.format("[%s] Not active — press Toggle Hover first", ModName))
        return
    end
    if state.psmBB and state.psmDef then
        dumpPSMValues(state.psmBB, state.psmDef)
    else
        print(string.format("[%s] PSM blackboard not initialized", ModName))
    end
end

local function probeSM()
    if state.phase ~= "ACTIVE" then
        print(string.format("[%s] Not active — press Toggle Hover first", ModName))
        return
    end
    local player = Game.GetPlayer()
    if player then
        probeSMComponent(player)
    end
end

--===========================================================================
-- Hotkeys (ROOT LEVEL — CET discovers these before onInit)
--===========================================================================

registerHotkey("HRTP6B_Toggle", "Toggle Hover (Player6b)", function()
    if state.phase == "IDLE" then
        activate()
    else
        deactivate()
    end
end)

registerHotkey("HRTP6B_CycleState", "Cycle State Mode (Player6b)", function()
    cycleStateMode()
end)

registerHotkey("HRTP6B_ToggleMethod", "Toggle Rotation Method (P6b)", function()
    toggleRotationMethod()
end)

registerHotkey("HRTP6B_DumpPSM", "Dump PSM State (Player6b)", function()
    dumpPSM()
end)

registerHotkey("HRTP6B_ProbeSM", "Probe SM Component (Player6b)", function()
    probeSM()
end)

registerHotkey("HRTP6B_YawPos", "Yaw +30 (Player6b)", function()
    applyRotation(0, 0, 1, ROT_STEP)
end)

registerHotkey("HRTP6B_YawNeg", "Yaw -30 (Player6b)", function()
    applyRotation(0, 0, 1, -ROT_STEP)
end)

registerHotkey("HRTP6B_PitchPos", "Pitch +30 (Player6b)", function()
    applyRotation(1, 0, 0, ROT_STEP)
end)

registerHotkey("HRTP6B_PitchNeg", "Pitch -30 (Player6b)", function()
    applyRotation(1, 0, 0, -ROT_STEP)
end)

registerHotkey("HRTP6B_RollPos", "Roll +30 (Player6b)", function()
    applyRotation(0, 1, 0, ROT_STEP)
end)

registerHotkey("HRTP6B_RollNeg", "Roll -30 (Player6b)", function()
    applyRotation(0, 1, 0, -ROT_STEP)
end)

--===========================================================================
-- Event Handlers
--===========================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized -- press toggle hotkey to start", ModName))
    print(string.format("[%s] 6a + safety re-teleport from 6: Teleport API (never SWT) resets velocity", ModName))
    print(string.format("[%s] Cycle through %d state modes to find one that allows full rotation", ModName, #StateModes))
end)

registerForEvent("onUpdate", function(delta)
    if state.phase ~= "ACTIVE" then return end

    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        deactivate()
        return
    end

    local printDiag = state.diagCounter > 0
    if printDiag then
        state.diagCounter = state.diagCounter - 1
    end

    local pos = player:GetWorldPosition()
    local mode = StateModes[state.modeIndex]

    -----------------------------------------------------------------------
    -- CHECK Z: Safety re-teleport if player has fallen below threshold
    -- Uses Teleport API ALWAYS (never SWT) to reset fall velocity and
    -- bring player back to targetZ. This prevents fall damage.
    -----------------------------------------------------------------------

    if pos.z < state.reTeleportThreshold then
        -- Throttle re-teleport logging: only log first occurrence or when z changes significantly
        state.reTeleportCount = state.reTeleportCount + 1
        local shouldLog = (state.reTeleportCount == 1) or
                          (state.lastLoggedZ and math.abs(pos.z - state.lastLoggedZ) > 5.0)
        if shouldLog then
            print(string.format("[%s] z=%.1f below threshold %.1f — safety teleport to z=%.1f (count=%d)",
                ModName, pos.z, state.reTeleportThreshold, state.targetZ, state.reTeleportCount))
            state.lastLoggedZ = pos.z
        end
        -- Only trigger diagnostics on first re-teleport, not every frame
        if state.reTeleportCount == 1 then
            state.diagCounter = NUM_DIAG
        end

        -- SAFETY RE-TELEPORT: Always use Teleport API (never SWT) to reset
        -- fall velocity and bring player back to targetZ height. This prevents
        -- fall damage (teleport resets velocity) and keeps player airborne.
        -- Must use Teleport API because SetWorldTransform fails to reposition.
        local safetyYaw = select(3, Quat.toEulerRaw(state.quat))
        local safetyPos = Vector4.new(pos.x, pos.y, state.targetZ, 1)
        teleportWithOrientation(player, safetyPos, 0, 0, safetyYaw)
        return
    else
        -- Reset counter when player is above threshold
        if state.reTeleportCount > 0 then
            print(string.format("[%s] z=%.1f above threshold — re-teleport stopped (count was %d)",
                ModName, pos.z, state.reTeleportCount))
            state.reTeleportCount = 0
            state.lastLoggedZ = nil
        end
    end

    -----------------------------------------------------------------------
    -- STEP 1: Apply PSM state manipulation every frame
    -- Write PSM blackboard variables to trick locomotion into a state
    -- that doesn't enforce roll=0, pitch=0
    -----------------------------------------------------------------------

    if state.psmBB and state.psmDef then
        mode.apply(state.psmBB, state.psmDef)
    end

    -----------------------------------------------------------------------
    -- STEP 2: Apply rotation via Teleport or SetWorldTransform
    -----------------------------------------------------------------------

    local roll, pitch, yaw = Quat.toEulerRaw(state.quat)

    -- Use targetZ for z so the teleport/SWT keeps the player
    -- airborne AND applies full rotation
    local curPos = player:GetWorldPosition()
    local rotPos = Vector4.new(curPos.x, curPos.y, state.targetZ, 1)

    if printDiag then
        local eulerBefore = player:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG mode=%s method=%s z=%.1f", ModName, mode.name, state.useTeleport and "Teleport" or "SWT", rotPos.z))
        print(string.format("[%s] DIAG target: roll=%.1f pitch=%.1f yaw=%.1f", ModName, roll, pitch, yaw))
        print(string.format("[%s] DIAG BEFORE: roll=%.1f pitch=%.1f yaw=%.1f", ModName, eulerBefore.roll, eulerBefore.pitch, eulerBefore.yaw))
    end

    local ok, err
    if state.useTeleport then
        ok, err = teleportWithOrientation(player, rotPos, roll, pitch, yaw)
    else
        ok, err = setWorldTransformWithOrientation(player, rotPos, roll, pitch, yaw)
    end

    if printDiag then
        if ok then
            print(string.format("[%s] DIAG %s SUCCESS", ModName, state.useTeleport and "Teleport" or "SWT"))
        else
            print(string.format("[%s] DIAG %s FAILED: %s", ModName, state.useTeleport and "Teleport" or "SWT", tostring(err)))
        end

        -- Check orientation AFTER
        local eulerAfter = player:GetWorldOrientation():ToEulerAngles()
        print(string.format("[%s] DIAG AFTER: roll=%.1f pitch=%.1f yaw=%.1f", ModName, eulerAfter.roll, eulerAfter.pitch, eulerAfter.yaw))

        -- Check which axes stuck
        local rollMatch  = math.abs(eulerAfter.roll  - roll)  < 1.0
        local pitchMatch = math.abs(eulerAfter.pitch - pitch) < 1.0
        local yawMatch   = math.abs(eulerAfter.yaw   - yaw)   < 1.0
        print(string.format("[%s] DIAG MATCH: roll=%s pitch=%s yaw=%s", ModName, tostring(rollMatch), tostring(pitchMatch), tostring(yawMatch)))

        -- Also read back PSM state to see if our writes stuck
        if state.psmBB and state.psmDef then
            local locDetailed = nil
            pcall(function() locDetailed = state.psmBB:GetInt(state.psmDef.LocomotionDetailed) end)
            local highLevel = nil
            pcall(function() highLevel = state.psmBB:GetInt(state.psmDef.HighLevel) end)
            local vitals = nil
            pcall(function() vitals = state.psmBB:GetInt(state.psmDef.Vitals) end)
            local felled = nil
            pcall(function() felled = state.psmBB:GetBool(state.psmDef.Felled) end)
            print(string.format("[%s] DIAG PSM: LocDetailed=%s HighLevel=%s Vitals=%s Felled=%s", ModName, tostring(locDetailed), tostring(highLevel), tostring(vitals), tostring(felled)))
        end

        local posAfter = player:GetWorldPosition()
        print(string.format("[%s] DIAG pos: (%.1f, %.1f, %.1f)", ModName, posAfter.x, posAfter.y, posAfter.z))
    end
end)

registerForEvent("onShutdown", function()
    if state.phase ~= "IDLE" then
        deactivate()
    end
end)
