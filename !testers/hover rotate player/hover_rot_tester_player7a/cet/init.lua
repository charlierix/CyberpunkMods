-- HoverRotTesterPlayer7A - RED4ext-Only Overlay
-- This is an overlay on hover_rot_tester_player7. Only CET changes. Red4ext and Redscript are shared from player7.
-- Goal: Freely rotate the player's body (full 6DOF: pitch, yaw, roll) while airborne
-- Only strategy 3: RED4ext native transform override (requires compiled plugin)
-- TweakDB prefix: HoverRotPlayer7 (same as player7 — shared RED4ext plugin reads these flats)

local state = {
    active = false,
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
    lastError = "",
}

local TWEAKDB_PREFIX = "HoverRotPlayer7"

-- ============================================================
-- ROOT-LEVEL HOTKEYS (CET requires these at file root, NOT inside onInit)
-- ============================================================

registerHotkey('HoverRotPlayer7A_Toggle', 'HoverRot Player7A: Toggle Active', function()
    state.active = not state.active
    if state.active then
        ActivateMode()
    else
        DeactivateMode()
    end
end)

registerHotkey('HoverRotPlayer7A_PitchUp', 'HoverRot Player7A: Pitch Up', function()
    state.pitch = state.pitch + state.rotSpeed
end)

registerHotkey('HoverRotPlayer7A_PitchDown', 'HoverRot Player7A: Pitch Down', function()
    state.pitch = state.pitch - state.rotSpeed
end)

registerHotkey('HoverRotPlayer7A_RollLeft', 'HoverRot Player7A: Roll Left', function()
    state.roll = state.roll - state.rotSpeed
end)

registerHotkey('HoverRotPlayer7A_RollRight', 'HoverRot Player7A: Roll Right', function()
    state.roll = state.roll + state.rotSpeed
end)

registerHotkey('HoverRotPlayer7A_YawLeft', 'HoverRot Player7A: Yaw Left', function()
    state.yaw = state.yaw - state.rotSpeed
end)

registerHotkey('HoverRotPlayer7A_YawRight', 'HoverRot Player7A: Yaw Right', function()
    state.yaw = state.yaw + state.rotSpeed
end)

registerHotkey('HoverRotPlayer7A_Reset', 'HoverRot Player7A: Reset Rotation', function()
    state.pitch = 0.0
    state.yaw = 0.0
    state.roll = 0.0
end)

registerHotkey('HoverRotPlayer7A_HoverUp', 'HoverRot Player7A: Hover Up', function()
    state.hoverVelocity = 3.0
end)

registerHotkey('HoverRotPlayer7A_HoverDown', 'HoverRot Player7A: Hover Down', function()
    state.hoverVelocity = -3.0
end)

registerHotkey('HoverRotPlayer7A_HoverStop', 'HoverRot Player7A: Hover Stop', function()
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
        TweakDB:SetFlat(TWEAKDB_PREFIX .. "_strategy", 3)
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
-- ROTATION STRATEGY (RED4ext Native Override only)
-- ============================================================

local function ApplyCameraRotation(player)
    local cam = player:GetFPPCameraComponent()
    if not cam then return end

    cam.sensitivityMultX = 0
    cam.sensitivityMultY = 0

    local quat = EulerToQuat(state.pitch, state.yaw, state.roll)
    cam:SetLocalOrientation(quat)
end

local function ApplyRed4extOverride(player)
    WriteOrientationToTweakDB()
    ApplyCameraRotation(player)
end

-- ============================================================
-- HOVER MECHANICS
-- ============================================================

local function ApplyHover(player)
    pcall(function()
        local imp = PSMImpulse.new()
        imp.id = "impulse"
        imp.impulse = Vector4.new(0, 0, state.hoverVelocity, 0)
        player:QueueEvent(imp)
    end)

    if state.hoverVelocity == 0 then
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

    WriteOrientationToTweakDB()
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
    ApplyRed4extOverride(player)
end)

registerForEvent('onDraw', function()
    if not state.active then return end

    ImGui.Begin('HoverRot Player7A##hoverrot7a', true, ImGuiWindowFlags.AlwaysAutoResize)

    ImGui.Text('Strategy: RED4ext Native Override')
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

    ImGui.Separator()
    ImGui.Text('Hotkeys:')
    ImGui.Text('  Toggle | Pitch U/D | Roll L/R | Yaw L/R')
    ImGui.Text('  Reset | Hover U/D/Stop')

    ImGui.End()
end)
