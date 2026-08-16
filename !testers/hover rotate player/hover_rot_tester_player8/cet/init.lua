-- ============================================================
-- HoverRotTesterPlayer8 - CET Entry Point
-- ============================================================
-- Hybrid player body rotation tester using CET + Redscript + RED4ext.
--
-- Architecture:
--   CET Lua:   hotkeys, hover impulse, quaternion computation, ImGui, logging
--   Redscript: ScriptableSystem bridge wrapping native function calls
--   RED4ext:   native C++ functions that write quaternion to player transform
--
-- Key improvement over 7b:
--   - No TweakDB communication for rotation data (that was plumbing only)
--   - CET computes quaternion via EulerAngles.new(roll, pitch, yaw):ToQuat()
--   - CET calls bridge:ApplyRotation(quat) every frame via onUpdate
--   - C++ writes quaternion directly to player transformComponent
--   - No camera manipulation (camera is child of body)
--
-- Crash safeguard: active flag reset to false on init
-- ============================================================

-- ============================================================
-- LOGGING
-- ============================================================

local function Log(msg)
    print("[HoverRotPlayer8] " .. tostring(msg))
end

-- ============================================================
-- STATE
-- ============================================================

local state = {
    active = false,
    pitch = 0.0,
    yaw = 0.0,
    roll = 0.0,
    rotSpeed = 2.0,
    hoverVelocity = 0.0,
    tickCount = 0,
    nativeAvailable = false,
    lastApplyResult = false,
    lastError = "",
    applyCallCount = 0,
    applySuccessCount = 0,
    applyFailCount = 0,
    lastQuatStr = "",
    lastReadbackStr = "",
    bridgeChecked = false,
}

local LOG_INTERVAL = 60 -- log status every N ticks (~1s at 60fps)

-- ============================================================
-- BRIDGE ACCESS
-- ============================================================

local bridge = nil

local function GetBridge()
    if bridge then return bridge end
    pcall(function()
        local container = Game.GetScriptableSystemsContainer()
        if container then
            bridge = container:Get("HoverRotPlayer8Bridge")
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

-- ============================================================
-- QUATERNION COMPUTATION
-- ============================================================

-- Compute quaternion from Euler angles using the game's native conversion.
-- EulerAngles constructor order is (roll, pitch, yaw) — NOT (pitch, yaw, roll).
-- This avoids the axis mapping issues from tester 7's custom EulerToQuat().
local function ComputeQuaternion(pitch, yaw, roll)
    local euler = EulerAngles.new(roll, pitch, yaw)
    local quat = euler:ToQuat()
    return quat
end

-- Apply rotation to player body via the redscript bridge -> C++ native function
local function ApplyBodyRotation()
    if not state.active then return end

    local b = GetBridge()
    if not b then
        if state.tickCount % LOG_INTERVAL == 0 then
            Log("ApplyBodyRotation: bridge not found")
        end
        state.lastApplyResult = false
        return
    end

    local quat = ComputeQuaternion(state.pitch, state.yaw, state.roll)

    local ok, result = pcall(function()
        return b:ApplyRotation(quat)
    end)

    state.applyCallCount = state.applyCallCount + 1

    if ok then
        state.lastApplyResult = result
        if result then
            state.applySuccessCount = state.applySuccessCount + 1
        else
            state.applyFailCount = state.applyFailCount + 1
        end
    else
        state.lastApplyResult = false
        state.applyFailCount = state.applyFailCount + 1
        state.lastError = "ApplyRotation call failed: " .. tostring(result)
        if state.tickCount % LOG_INTERVAL == 0 then
            Log(state.lastError)
        end
    end
end

-- ============================================================
-- HOVER MECHANICS
-- ============================================================

local function ApplyHover(player)
    local hoverOk = false
    pcall(function()
        local imp = PSMImpulse.new()
        imp.id = "impulse"
        imp.impulse = Vector4.new(0, 0, state.hoverVelocity, 0)
        player:QueueEvent(imp)
        hoverOk = true
    end)

    if not hoverOk and state.hoverVelocity ~= 0 then
        state.lastError = "ApplyHover: PSMImpulse QueueEvent failed"
    end

    -- Small upward impulse to counteract gravity when hovering stationary
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
-- STATUS QUERIES (for ImGui)
-- ============================================================

local function UpdateStatusStrings()
    local b = GetBridge()
    if not b then
        state.lastQuatStr = "NO_BRIDGE"
        state.lastReadbackStr = "NO_BRIDGE"
        return
    end

    pcall(function()
        state.lastQuatStr = b:GetStatus()
    end)

    pcall(function()
        state.lastReadbackStr = b:ReadPlayerOrientation()
    end)
end

-- ============================================================
-- MODE ACTIVATION/DEACTIVATION
-- ============================================================

function ActivateMode()
    Log("=== ActivateMode ===")
    local player = Game.GetPlayer()
    if not player then
        Log("ActivateMode: No player found!")
        return
    end
    Log("ActivateMode: player found")

    -- Reset state
    state.pitch = 0.0
    state.yaw = 0.0
    state.roll = 0.0
    state.hoverVelocity = 0.0
    state.tickCount = 0
    state.lastError = ""
    state.applyCallCount = 0
    state.applySuccessCount = 0
    state.applyFailCount = 0
    state.lastApplyResult = false

    -- Check if native functions are available (plugin loaded)
    state.nativeAvailable = CheckNativeAvailable()
    Log("Native functions available: " .. tostring(state.nativeAvailable))

    Log("=== ActivateMode complete ===")
end

function DeactivateMode()
    Log("=== DeactivateMode ===")

    Log(string.format("Final stats: applyCalls=%d ok=%d fail=%d",
        state.applyCallCount, state.applySuccessCount, state.applyFailCount))

    if state.lastError ~= "" then
        Log("LastError: " .. state.lastError)
    end

    Log("=== DeactivateMode complete ===")
end

-- ============================================================
-- ROOT-LEVEL HOTKEYS (CET requires these at file root, NOT inside onInit)
-- ============================================================

registerHotkey("HoverRotPlayer8_Toggle", "HoverRot Player8: Toggle Active", function()
    state.active = not state.active
    if state.active then
        Log("Hotkey: Toggle -> ACTIVATE")
        ActivateMode()
    else
        Log("Hotkey: Toggle -> DEACTIVATE")
        DeactivateMode()
    end
end)

registerHotkey("HoverRotPlayer8_PitchUp", "HoverRot Player8: Pitch Up", function()
    state.pitch = state.pitch + state.rotSpeed
    Log(string.format("Hotkey: PitchUp -> pitch=%.1f", state.pitch))
end)

registerHotkey("HoverRotPlayer8_PitchDown", "HoverRot Player8: Pitch Down", function()
    state.pitch = state.pitch - state.rotSpeed
    Log(string.format("Hotkey: PitchDown -> pitch=%.1f", state.pitch))
end)

registerHotkey("HoverRotPlayer8_RollLeft", "HoverRot Player8: Roll Left", function()
    state.roll = state.roll - state.rotSpeed
    Log(string.format("Hotkey: RollLeft -> roll=%.1f", state.roll))
end)

registerHotkey("HoverRotPlayer8_RollRight", "HoverRot Player8: Roll Right", function()
    state.roll = state.roll + state.rotSpeed
    Log(string.format("Hotkey: RollRight -> roll=%.1f", state.roll))
end)

registerHotkey("HoverRotPlayer8_YawLeft", "HoverRot Player8: Yaw Left", function()
    state.yaw = state.yaw - state.rotSpeed
    Log(string.format("Hotkey: YawLeft -> yaw=%.1f", state.yaw))
end)

registerHotkey("HoverRotPlayer8_YawRight", "HoverRot Player8: Yaw Right", function()
    state.yaw = state.yaw + state.rotSpeed
    Log(string.format("Hotkey: YawRight -> yaw=%.1f", state.yaw))
end)

registerHotkey("HoverRotPlayer8_Reset", "HoverRot Player8: Reset Rotation", function()
    state.pitch = 0.0
    state.yaw = 0.0
    state.roll = 0.0
    Log("Hotkey: Reset -> pitch=0.0 yaw=0.0 roll=0.0")
end)

registerHotkey("HoverRotPlayer8_HoverUp", "HoverRot Player8: Hover Up", function()
    state.hoverVelocity = 3.0
    Log(string.format("Hotkey: HoverUp -> velocity=%.1f", state.hoverVelocity))
end)

registerHotkey("HoverRotPlayer8_HoverDown", "HoverRot Player8: Hover Down", function()
    state.hoverVelocity = -3.0
    Log(string.format("Hotkey: HoverDown -> velocity=%.1f", state.hoverVelocity))
end)

registerHotkey("HoverRotPlayer8_HoverStop", "HoverRot Player8: Hover Stop", function()
    state.hoverVelocity = 0.0
    Log(string.format("Hotkey: HoverStop -> velocity=%.1f", state.hoverVelocity))
end)

registerHotkey("HoverRotPlayer8_DumpStatus", "HoverRot Player8: Dump Status", function()
    Log("=== Status Dump ===")
    Log(string.format("  active=%s pitch=%.1f yaw=%.1f roll=%.1f hover=%.1f",
        tostring(state.active), state.pitch, state.yaw, state.roll, state.hoverVelocity))
    Log(string.format("  native=%s bridgeChecked=%s",
        tostring(state.nativeAvailable), tostring(state.bridgeChecked)))
    Log(string.format("  apply: calls=%d ok=%d fail=%d lastResult=%s",
        state.applyCallCount, state.applySuccessCount, state.applyFailCount, tostring(state.lastApplyResult)))
    Log("  C++ status: " .. state.lastQuatStr)
    Log("  Readback:   " .. state.lastReadbackStr)
    if state.lastError ~= "" then
        Log("  LastError: " .. state.lastError)
    end
    Log("=== End Dump ===")
end)

-- ============================================================
-- EVENT HANDLERS
-- ============================================================

registerForEvent("onInit", function()
    Log("=== onInit ===")

    -- Crash safeguard: reset active state on startup
    state.active = false
    Log("Crash safeguard: active reset to false")

    -- Check if native functions are available (plugin loaded)
    -- This also verifies the redscript bridge is accessible
    state.nativeAvailable = CheckNativeAvailable()
    state.bridgeChecked = true

    Log("=== onInit complete ===")
end)

registerForEvent("onUpdate", function(delta)
    if not state.active then return end

    state.tickCount = state.tickCount + 1

    local player = Game.GetPlayer()
    if not player then return end

    -- Apply hover impulse
    ApplyHover(player)

    -- Apply body rotation via C++ native function through bridge
    ApplyBodyRotation()

    -- Throttled logging (every ~1 second)
    if state.tickCount % LOG_INTERVAL == 0 then
        Log(string.format("Tick %d | pitch=%.1f yaw=%.1f roll=%.1f | hover=%.1f | apply: calls=%d ok=%d fail=%d last=%s",
            state.tickCount, state.pitch, state.yaw, state.roll, state.hoverVelocity,
            state.applyCallCount, state.applySuccessCount, state.applyFailCount, tostring(state.lastApplyResult)))

        -- Update status strings from C++ for display
        UpdateStatusStrings()

        Log("  C++ status: " .. state.lastQuatStr)
        Log("  Readback:   " .. state.lastReadbackStr)

        if state.lastError ~= "" then
            Log("  LastError: " .. state.lastError)
        end
    end
end)

registerForEvent("onDraw", function()
    if not state.active then return end

    ImGui.Begin("HoverRot Player8##hoverrot8", true, ImGuiWindowFlags.AlwaysAutoResize)

    ImGui.Text("Strategy: C++ Native Transform Write")
    ImGui.Text("Native: " .. (state.nativeAvailable and "LOADED" or "NOT LOADED"))
    ImGui.Separator()
    ImGui.Text(string.format("Pitch: %.1f deg", state.pitch))
    ImGui.Text(string.format("Yaw:   %.1f deg", state.yaw))
    ImGui.Text(string.format("Roll:  %.1f deg", state.roll))
    ImGui.Separator()
    ImGui.Text(string.format("Hover velocity: %.1f", state.hoverVelocity))
    ImGui.Text(string.format("Tick: %d", state.tickCount))
    ImGui.Separator()
    ImGui.Text("Apply rotation:")
    ImGui.Text(string.format("  Calls:   %d", state.applyCallCount))
    ImGui.Text(string.format("  Success: %d", state.applySuccessCount))
    ImGui.Text(string.format("  Fail:    %d", state.applyFailCount))
    ImGui.Text(string.format("  Last:    %s", tostring(state.lastApplyResult)))
    ImGui.Separator()
    if state.lastReadbackStr ~= "" then
        ImGui.Text("Readback: " .. state.lastReadbackStr)
    end

    if state.lastError ~= "" then
        ImGui.Separator()
        ImGui.PushStyleColor(ImGuiCol.Text, 1.0, 0.3, 0.3, 1.0)
        ImGui.Text("Error: " .. state.lastError)
        ImGui.PopStyleColor()
    end

    ImGui.Separator()
    ImGui.Text("Hotkeys:")
    ImGui.Text("  Toggle | Pitch U/D | Roll L/R | Yaw L/R")
    ImGui.Text("  Reset | Hover U/D/Stop | Dump Status")

    ImGui.End()
end)
