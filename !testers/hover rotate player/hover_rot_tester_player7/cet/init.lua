-- HoverRotTesterPlayer7 - Hybrid CET + RED4ext Player Body Rotation Tester
-- Goal: Freely rotate the player's body (full 6DOF: pitch, yaw, roll) while airborne
--
-- Strategies (cycle with hotkey):
--   1. Camera-only rotation (known working - visual only, body stays upright)
--   2. Teleport with EulerAngles (known: yaw only)
--   3. RED4ext native transform override (requires compiled plugin)
--   4. Vehicle mount hybrid (spawn invisible vehicle, mount player, rotate vehicle)

local state = {
    active = false,
    strategy = 1,
    strategyNames = {
        [1] = "Camera Only (visual)",
        [2] = "Teleport (yaw only)",
        [3] = "RED4ext Native Override",
        [4] = "Vehicle Mount Hybrid",
    },
    pitch = 0.0,
    yaw = 0.0,
    roll = 0.0,
    rotSpeed = 2.0,
    hoverVelocity = 0.0,
    tickCount = 0,
    saved = {
        cameraSensX = nil,
        cameraSensY = nil,
    },
    red4extLoaded = false,
    vehicle = nil,
    vehicleSpawned = false,
    lastTeleportResult = "",
    lastError = "",
}

local TWEAKDB_PREFIX = "HoverRotPlayer7"

-- ============================================================
-- ROOT-LEVEL HOTKEYS (CET requires these at file root, NOT inside onInit)
-- ============================================================

registerHotkey('HoverRotPlayer7_Toggle', 'HoverRot Player7: Toggle Active', function()
    state.active = not state.active
    if state.active then
        ActivateMode()
    else
        DeactivateMode()
    end
end)

registerHotkey('HoverRotPlayer7_PitchUp', 'HoverRot Player7: Pitch Up', function()
    state.pitch = state.pitch + state.rotSpeed
end)

registerHotkey('HoverRotPlayer7_PitchDown', 'HoverRot Player7: Pitch Down', function()
    state.pitch = state.pitch - state.rotSpeed
end)

registerHotkey('HoverRotPlayer7_RollLeft', 'HoverRot Player7: Roll Left', function()
    state.roll = state.roll - state.rotSpeed
end)

registerHotkey('HoverRotPlayer7_RollRight', 'HoverRot Player7: Roll Right', function()
    state.roll = state.roll + state.rotSpeed
end)

registerHotkey('HoverRotPlayer7_YawLeft', 'HoverRot Player7: Yaw Left', function()
    state.yaw = state.yaw - state.rotSpeed
end)

registerHotkey('HoverRotPlayer7_YawRight', 'HoverRot Player7: Yaw Right', function()
    state.yaw = state.yaw + state.rotSpeed
end)

registerHotkey('HoverRotPlayer7_Reset', 'HoverRot Player7: Reset Rotation', function()
    state.pitch = 0.0
    state.yaw = 0.0
    state.roll = 0.0
end)

registerHotkey('HoverRotPlayer7_CycleStrategy', 'HoverRot Player7: Cycle Strategy', function()
    state.strategy = state.strategy + 1
    if state.strategy > 4 then
        state.strategy = 1
    end
    state.lastError = ""
    if state.strategy == 4 then
        SpawnVehicleForMount()
    end
end)

registerHotkey('HoverRotPlayer7_HoverUp', 'HoverRot Player7: Hover Up', function()
    state.hoverVelocity = 3.0
end)

registerHotkey('HoverRotPlayer7_HoverDown', 'HoverRot Player7: Hover Down', function()
    state.hoverVelocity = -3.0
end)

registerHotkey('HoverRotPlayer7_HoverStop', 'HoverRot Player7: Hover Stop', function()
    state.hoverVelocity = 0.0
end)

-- ============================================================
-- UTILITY FUNCTIONS
-- ============================================================

local function Deg2Rad(deg)
    return deg * 3.141592653589793 / 180.0
end

local function EulerToQuat(pitchDeg, yawDeg, rollDeg)
    local p = Deg2Rad(pitchDeg) * 0.5
    local y = Deg2Rad(yawDeg) * 0.5
    local r = Deg2Rad(rollDeg) * 0.5

    local cp = math.cos(p)
    local sp = math.sin(p)
    local cy = math.cos(y)
    local sy = math.sin(y)
    local cr = math.cos(r)
    local sr = math.sin(r)

    -- ZYX order: yaw * pitch * roll
    local qw = cr * cp * cy + sr * sp * sy
    local qx = cr * sp * cy - sr * cp * sy
    local qy = cr * cp * sy + sr * sp * cy
    local qz = sr * cp * cy - cr * sp * sy

    return Quaternion.new(qw, qx, qy, qz)
end

-- Write desired orientation to TweakDB for RED4ext plugin to read
local function WriteOrientationToTweakDB()
    -- TweakDB is a CET global singleton; do NOT use GetSingleton('TweakDB')
    pcall(function()
        TweakDB:SetFlat(TWEAKDB_PREFIX .. "_active", state.active and 1 or 0)
        TweakDB:SetFlat(TWEAKDB_PREFIX .. "_pitch", state.pitch)
        TweakDB:SetFlat(TWEAKDB_PREFIX .. "_yaw", state.yaw)
        TweakDB:SetFlat(TWEAKDB_PREFIX .. "_roll", state.roll)
        TweakDB:SetFlat(TWEAKDB_PREFIX .. "_strategy", state.strategy)
    end)
end

-- Check if RED4ext plugin is loaded
local function CheckRed4extStatus()
    -- TweakDB is a CET global singleton; do NOT use GetSingleton('TweakDB')
    local ok, result = pcall(function()
        return TweakDB:GetFlat(TWEAKDB_PREFIX .. "_red4ext_loaded")
    end)
    if ok and result then
        return result == 1
    end
    return false
end

-- ============================================================
-- VEHICLE MOUNT HYBRID (Strategy 4)
-- ============================================================

local function SpawnVehicleForMount()
    local player = Game.GetPlayer()
    if not player then
        state.lastError = "No player found"
        return
    end

    local transform = player:GetWorldTransform()
    local vehiclePath = "base\\vehicles\\v_sportbike2_arch__basic.ent"

    local ok, result = pcall(function()
        return exEntitySpawner.Spawn(vehiclePath, transform, '')
    end)

    if ok and result then
        state.vehicle = result
        state.vehicleSpawned = true
        state.lastTeleportResult = "Vehicle spawned"
    else
        ok, result = pcall(function()
            local spec = DynamicEntitySpec.new()
            spec.entityPath = vehiclePath
            spec.spawnInView = true
            spec.persistState = false
            spec.transform = transform
            return exEntitySpawner.SpawnDynamic(spec)
        end)

        if ok and result then
            state.vehicle = result
            state.vehicleSpawned = true
            state.lastTeleportResult = "Vehicle spawned (dynamic)"
        else
            state.lastError = "Vehicle spawn failed"
        end
    end
end

local function DespawnVehicle()
    if state.vehicle then
        pcall(function()
            exEntitySpawner.Despawn(state.vehicle)
        end)
        state.vehicle = nil
        state.vehicleSpawned = false
    end
end

local function TryMountVehicle()
    if not state.vehicle then return false end

    local player = Game.GetPlayer()
    if not player then return false end

    -- Try various mounting approaches
    local ok, result = pcall(function()
        local mountSystem = Game.GetMountingSystem()
        if mountSystem and mountSystem.Mount then
            return true
        end
        return false
    end)

    if not (ok and result) then
        -- Try via Redscript bridge if available
        ok, result = pcall(function()
            local bridge = Game.GetScriptableSystemsContainer():Get('HoverRotPlayer7Bridge')
            if bridge then
                return bridge:MountPlayerToVehicle()
            end
            return false
        end)
    end

    return ok and result
end

local function RotateVehicle()
    if not state.vehicle then return end

    local pos = state.vehicle:GetWorldPosition()
    local euler = EulerAngles.new(state.pitch, state.yaw, state.roll)

    local ok, result = pcall(function()
        GetSingleton('gameTeleportationFacility'):Teleport(state.vehicle, pos, euler)
    end)

    if not ok then
        state.lastError = "Vehicle teleport failed"
    end
end

-- ============================================================
-- ROTATION STRATEGIES
-- ============================================================

local function ApplyCameraRotation(player)
    local cam = player:GetFPPCameraComponent()
    if not cam then return end

    cam.sensitivityMultX = 0
    cam.sensitivityMultY = 0

    local quat = EulerToQuat(state.pitch, state.yaw, state.roll)
    cam:SetLocalOrientation(quat)
end

local function ApplyTeleportRotation(player)
    local pos = player:GetWorldPosition()
    local euler = EulerAngles.new(state.pitch, state.yaw, state.roll)

    local ok, result = pcall(function()
        GetSingleton('gameTeleportationFacility'):Teleport(player, pos, euler)
    end)

    if ok then
        state.lastTeleportResult = "Teleport OK"
    else
        state.lastError = "Teleport failed"
    end
end

local function ApplyRed4extOverride(player)
    WriteOrientationToTweakDB()
    ApplyCameraRotation(player)
end

local function ApplyVehicleMountRotation(player)
    if not state.vehicleSpawned then
        SpawnVehicleForMount()
    end
    TryMountVehicle()
    RotateVehicle()
    ApplyCameraRotation(player)
end

-- ============================================================
-- HOVER MECHANICS
-- ============================================================

local function ApplyHover(player)
    -- CET does NOT have player:GetPSMComponent(). Use QueueEvent with PSMImpulse instead.
    -- Correct field is imp.impulse (Vector4), NOT imp.linearVelocity (Vector3).
    pcall(function()
        local imp = PSMImpulse.new()
        imp.id = "impulse"
        imp.impulse = Vector4.new(0, 0, state.hoverVelocity, 0)
        player:QueueEvent(imp)
    end)

    if state.hoverVelocity == 0 then
        -- Small upward impulse to counteract gravity when hovering stationary
        pcall(function()
            local antiGrav = PSMImpulse.new()
            antiGrav.id = "impulse"
            antiGrav.impulse = Vector4.new(0, 0, 0.1, 0)
            player:QueueEvent(antiGrav)
        end)
    end
end

-- ============================================================
-- MODE ACTIVATION/DEACTIVATION
-- ============================================================

function ActivateMode()
    local player = Game.GetPlayer()
    if not player then return end

    local cam = player:GetFPPCameraComponent()
    if cam then
        state.saved.cameraSensX = cam.sensitivityMultX
        state.saved.cameraSensY = cam.sensitivityMultY
    end

    state.red4extLoaded = CheckRed4extStatus()
    state.pitch = 0.0
    state.yaw = 0.0
    state.roll = 0.0
    state.hoverVelocity = 0.0
    state.tickCount = 0
    state.lastError = ""
    state.lastTeleportResult = ""

    WriteOrientationToTweakDB()

    if state.strategy == 4 then
        SpawnVehicleForMount()
    end
end

function DeactivateMode()
    local player = Game.GetPlayer()
    if not player then return end

    local cam = player:GetFPPCameraComponent()
    if cam and state.saved.cameraSensX ~= nil then
        cam.sensitivityMultX = state.saved.cameraSensX
        cam.sensitivityMultY = state.saved.cameraSensY
        state.saved.cameraSensX = nil
        state.saved.cameraSensY = nil
    end

    state.active = false
    WriteOrientationToTweakDB()
    DespawnVehicle()
end

-- ============================================================
-- EVENT HANDLERS
-- ============================================================

registerForEvent('onInit', function()
    state.red4extLoaded = CheckRed4extStatus()
    pcall(function()
        WriteOrientationToTweakDB()
    end)
end)

registerForEvent('onUpdate', function(delta)
    if not state.active then return end

    state.tickCount = state.tickCount + 1

    local player = Game.GetPlayer()
    if not player then return end

    ApplyHover(player)

    if state.strategy == 1 then
        ApplyCameraRotation(player)
    elseif state.strategy == 2 then
        ApplyTeleportRotation(player)
    elseif state.strategy == 3 then
        ApplyRed4extOverride(player)
    elseif state.strategy == 4 then
        ApplyVehicleMountRotation(player)
    end
end)

registerForEvent('onDraw', function()
    if not state.active then return end

    ImGui.Begin('HoverRot Player7##hoverrot7', true, ImGuiWindowFlags.AlwaysAutoResize)

    ImGui.Text('Strategy: ' .. (state.strategyNames[state.strategy] or 'Unknown'))
    ImGui.Text('RED4ext: ' .. (state.red4extLoaded and 'LOADED' or 'NOT LOADED'))
    ImGui.Separator()
    ImGui.Text(string.format('Pitch: %.1f deg', state.pitch))
    ImGui.Text(string.format('Yaw:   %.1f deg', state.yaw))
    ImGui.Text(string.format('Roll:  %.1f deg', state.roll))
    ImGui.Separator()
    ImGui.Text(string.format('Hover velocity: %.1f', state.hoverVelocity))
    ImGui.Text(string.format('Tick: %d', state.tickCount))

    if state.lastError ~= "" then
        ImGui.Separator()
        ImGui.PushStyleColor(ImGuiCol.Text, 1.0, 0.3, 0.3, 1.0)
        ImGui.Text('Error: ' .. state.lastError)
        ImGui.PopStyleColor()
    end

    if state.lastTeleportResult ~= "" then
        ImGui.Text('Teleport: ' .. state.lastTeleportResult)
    end

    if state.strategy == 4 then
        ImGui.Separator()
        ImGui.Text('Vehicle: ' .. (state.vehicleSpawned and 'spawned' or 'not spawned'))
    end

    ImGui.Separator()
    ImGui.Text('Hotkeys:')
    ImGui.Text('  Toggle | Pitch U/D | Roll L/R | Yaw L/R')
    ImGui.Text('  Reset | Cycle Strategy | Hover U/D/Stop')

    ImGui.End()
end)
