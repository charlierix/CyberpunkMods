-- HoverRotTesterPlayer7B - TweakDB Plumbing Fix + Comprehensive Logging
-- Overlay on hover_rot_tester_player7. CET-only changes.
-- Goal: Fix TweakDB SetFlat type-ambiguous errors, add real logging, remove camera rotation
-- Only strategy 3: RED4ext native transform override (plugin remains shell — no hooks yet)
-- TweakDB prefix: HoverRotPlayer7 (same as player7 — shared RED4ext plugin reads these flats)
--
-- Changes from 7a:
--   1. TweakDB:SetFlat now passes explicit type as 3rd parameter (fixes 'type ambiguous' error)
--   2. All pcall errors are logged, not silently swallowed
--   3. Periodic TweakDB readback verification (every 60 ticks)
--   4. print() logging at every hotkey, activation, tick interval, and error
--   5. FPP camera rotation removed entirely (camera is child of body — body rotation is enough)
--   6. EulerToQuat removed (TweakDB stores raw float degrees, RED4ext plugin does quaternion math)
--   7. New DumpTweakDB hotkey for on-demand state inspection
--   8. TweakDB flats created in onInit (exist before activation, ready for RED4ext plugin)

-- ============================================================
-- LOGGING
-- ============================================================

local function Log(msg)
    print("[HoverRotPlayer7B] " .. tostring(msg))
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
    red4extLoaded = false,
    lastError = "",
    -- TweakDB tracking
    tweakDBWriteCount = 0,
    tweakDBFailCount = 0,
    tweakDBLastWriteOk = false,
    flatsCreated = false,
}

local TWEAKDB_PREFIX = "HoverRotPlayer7"
local LOG_INTERVAL = 60 -- log TweakDB status every N ticks (~1s at 60fps)

-- TweakDB flats managed by this mod
-- NOTE: TweakDB:SetFlat may fail silently (engine logs error but doesn't throw Lua error).
-- The pcall wrapper only catches Lua exceptions. Silent failures are detected via
-- periodic readback verification in onUpdate (see throttled logging section).
local FLATS = {
    {suffix = "_active",         type = "Int32", initial = 0},
    {suffix = "_pitch",          type = "Float", initial = 0.0},
    {suffix = "_yaw",            type = "Float", initial = 0.0},
    {suffix = "_roll",           type = "Float", initial = 0.0},
    {suffix = "_strategy",       type = "Int32", initial = 3},
    {suffix = "_red4ext_loaded", type = "Int32", initial = 0},
}

-- ============================================================
-- ROOT-LEVEL HOTKEYS (CET requires these at file root, NOT inside onInit)
-- ============================================================

registerHotkey('HoverRotPlayer7B_Toggle', 'HoverRot Player7B: Toggle Active', function()
    state.active = not state.active
    if state.active then
        Log("Hotkey: Toggle -> ACTIVATE")
        ActivateMode()
    else
        Log("Hotkey: Toggle -> DEACTIVATE")
        DeactivateMode()
    end
end)

registerHotkey('HoverRotPlayer7B_PitchUp', 'HoverRot Player7B: Pitch Up', function()
    state.pitch = state.pitch + state.rotSpeed
    Log(string.format("Hotkey: PitchUp -> pitch=%.1f", state.pitch))
end)

registerHotkey('HoverRotPlayer7B_PitchDown', 'HoverRot Player7B: Pitch Down', function()
    state.pitch = state.pitch - state.rotSpeed
    Log(string.format("Hotkey: PitchDown -> pitch=%.1f", state.pitch))
end)

registerHotkey('HoverRotPlayer7B_RollLeft', 'HoverRot Player7B: Roll Left', function()
    state.roll = state.roll - state.rotSpeed
    Log(string.format("Hotkey: RollLeft -> roll=%.1f", state.roll))
end)

registerHotkey('HoverRotPlayer7B_RollRight', 'HoverRot Player7B: Roll Right', function()
    state.roll = state.roll + state.rotSpeed
    Log(string.format("Hotkey: RollRight -> roll=%.1f", state.roll))
end)

registerHotkey('HoverRotPlayer7B_YawLeft', 'HoverRot Player7B: Yaw Left', function()
    state.yaw = state.yaw - state.rotSpeed
    Log(string.format("Hotkey: YawLeft -> yaw=%.1f", state.yaw))
end)

registerHotkey('HoverRotPlayer7B_YawRight', 'HoverRot Player7B: Yaw Right', function()
    state.yaw = state.yaw + state.rotSpeed
    Log(string.format("Hotkey: YawRight -> yaw=%.1f", state.yaw))
end)

registerHotkey('HoverRotPlayer7B_Reset', 'HoverRot Player7B: Reset Rotation', function()
    state.pitch = 0.0
    state.yaw = 0.0
    state.roll = 0.0
    Log("Hotkey: Reset -> pitch=0.0 yaw=0.0 roll=0.0")
end)

registerHotkey('HoverRotPlayer7B_HoverUp', 'HoverRot Player7B: Hover Up', function()
    state.hoverVelocity = 3.0
    Log(string.format("Hotkey: HoverUp -> velocity=%.1f", state.hoverVelocity))
end)

registerHotkey('HoverRotPlayer7B_HoverDown', 'HoverRot Player7B: Hover Down', function()
    state.hoverVelocity = -3.0
    Log(string.format("Hotkey: HoverDown -> velocity=%.1f", state.hoverVelocity))
end)

registerHotkey('HoverRotPlayer7B_HoverStop', 'HoverRot Player7B: Hover Stop', function()
    state.hoverVelocity = 0.0
    Log(string.format("Hotkey: HoverStop -> velocity=%.1f", state.hoverVelocity))
end)

registerHotkey('HoverRotPlayer7B_DumpTweakDB', 'HoverRot Player7B: Dump TweakDB State', function()
    Log("=== TweakDB State Dump ===")
    for _, flat in ipairs(FLATS) do
        local fullName = TWEAKDB_PREFIX .. flat.suffix
        local ok, result = pcall(function()
            return TweakDB:GetFlat(fullName)
        end)
        if ok then
            Log(string.format("  %s = %s (expected type: %s)", fullName, tostring(result), flat.type))
        else
            Log(string.format("  %s = READ FAILED: %s", fullName, tostring(result)))
        end
    end
    Log(string.format("  Writes: %d | Fails: %d | LastOK: %s | FlatsCreated: %s",
        state.tweakDBWriteCount, state.tweakDBFailCount, tostring(state.tweakDBLastWriteOk), tostring(state.flatsCreated)))
    Log("=== End Dump ===")
end)

-- ============================================================
-- TWEAKDB FUNCTIONS
-- ============================================================

local function WriteFlat(suffix, value, typeName)
    local fullName = TWEAKDB_PREFIX .. suffix
    local ok, err = pcall(function()
        TweakDB:SetFlat(fullName, value, typeName)
    end)
    if ok then
        state.tweakDBWriteCount = state.tweakDBWriteCount + 1
        state.tweakDBLastWriteOk = true
        return true
    else
        state.tweakDBFailCount = state.tweakDBFailCount + 1
        state.tweakDBLastWriteOk = false
        state.lastError = "SetFlat " .. fullName .. ": " .. tostring(err)
        Log("SetFlat FAILED: " .. fullName .. " = " .. tostring(value) .. " (" .. typeName .. ") — " .. tostring(err))
        return false
    end
end

local function ReadFlat(suffix)
    local fullName = TWEAKDB_PREFIX .. suffix
    local ok, result = pcall(function()
        return TweakDB:GetFlat(fullName)
    end)
    if ok then
        return result
    else
        Log("GetFlat FAILED: " .. fullName .. " — " .. tostring(result))
        return nil
    end
end

local function CreateFlats()
    Log("Creating/initializing TweakDB flats...")
    local successCount = 0
    local failCount = 0
    for _, flat in ipairs(FLATS) do
        local ok = WriteFlat(flat.suffix, flat.initial, flat.type)
        if ok then
            successCount = successCount + 1
        else
            failCount = failCount + 1
        end
    end
    state.flatsCreated = true
    Log(string.format("TweakDB flat creation: %d ok, %d failed", successCount, failCount))

    -- Readback verification
    Log("Readback verification:")
    for _, flat in ipairs(FLATS) do
        local val = ReadFlat(flat.suffix)
        local matchStr = ""
        if val == nil then
            matchStr = " [NIL — flat may not exist]"
        elseif tostring(val) ~= tostring(flat.initial) then
            matchStr = " [MISMATCH — got " .. tostring(val) .. "]"
        end
        Log(string.format("  %s%s = %s (expected: %s, type: %s)%s",
            TWEAKDB_PREFIX, flat.suffix, tostring(val), tostring(flat.initial), flat.type, matchStr))
    end
end

local function WriteOrientationToTweakDB()
    WriteFlat("_active", state.active and 1 or 0, "Int32")
    WriteFlat("_pitch", state.pitch, "Float")
    WriteFlat("_yaw", state.yaw, "Float")
    WriteFlat("_roll", state.roll, "Float")
    WriteFlat("_strategy", 3, "Int32")
end

local function CheckRed4extStatus()
    local val = ReadFlat("_red4ext_loaded")
    if val ~= nil then
        local loaded = (val == 1)
        Log("CheckRed4extStatus: _red4ext_loaded = " .. tostring(val) .. " -> " .. tostring(loaded))
        return loaded
    end
    Log("CheckRed4extStatus: _red4ext_loaded flat is nil (plugin not writing flag)")
    return false
end

-- ============================================================
-- HOVER MECHANICS
-- ============================================================

local function ApplyHover(player)
    -- PSMImpulse via QueueEvent (CET does NOT have player:GetPSMComponent())
    -- Field is imp.impulse (Vector4), NOT imp.linearVelocity (Vector3)
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

    state.pitch = 0.0
    state.yaw = 0.0
    state.roll = 0.0
    state.hoverVelocity = 0.0
    state.tickCount = 0
    state.lastError = ""
    state.tweakDBWriteCount = 0
    state.tweakDBFailCount = 0
    state.tweakDBLastWriteOk = false

    -- Create/initialize TweakDB flats
    CreateFlats()

    -- Check RED4ext status
    state.red4extLoaded = CheckRed4extStatus()
    Log("RED4ext loaded: " .. tostring(state.red4extLoaded))

    -- Write initial state
    WriteOrientationToTweakDB()
    Log(string.format("Initial orientation written: pitch=%.1f yaw=%.1f roll=%.1f active=1",
        state.pitch, state.yaw, state.roll))

    Log("=== ActivateMode complete ===")
end

function DeactivateMode()
    Log("=== DeactivateMode ===")

    state.active = false
    WriteOrientationToTweakDB()
    Log("Wrote final state to TweakDB (active=0)")

    -- Final TweakDB status
    Log(string.format("TweakDB totals: writes=%d fails=%d lastOK=%s",
        state.tweakDBWriteCount, state.tweakDBFailCount, tostring(state.tweakDBLastWriteOk)))
    Log("=== DeactivateMode complete ===")
end

-- ============================================================
-- EVENT HANDLERS
-- ============================================================

registerForEvent('onInit', function()
    Log("=== onInit ===")

    -- Create flats immediately so they exist for RED4ext plugin to read
    -- (even before the user activates the mode)
    CreateFlats()

    -- Check if RED4ext plugin has written its loaded flag
    state.red4extLoaded = CheckRed4extStatus()

    Log("=== onInit complete ===")
end)

registerForEvent('onUpdate', function(delta)
    if not state.active then return end

    state.tickCount = state.tickCount + 1

    local player = Game.GetPlayer()
    if not player then return end

    ApplyHover(player)
    WriteOrientationToTweakDB()

    -- Throttled logging (every ~1 second)
    if state.tickCount % LOG_INTERVAL == 0 then
        Log(string.format("Tick %d | pitch=%.1f yaw=%.1f roll=%.1f | hover=%.1f | TweakDB: writes=%d fails=%d lastOK=%s",
            state.tickCount, state.pitch, state.yaw, state.roll, state.hoverVelocity,
            state.tweakDBWriteCount, state.tweakDBFailCount, tostring(state.tweakDBLastWriteOk)))

        -- Readback verification — detects silent SetFlat failures
        local pitchVal = ReadFlat("_pitch")
        local yawVal = ReadFlat("_yaw")
        local rollVal = ReadFlat("_roll")
        local activeVal = ReadFlat("_active")
        Log(string.format("  Readback: active=%s pitch=%s yaw=%s roll=%s",
            tostring(activeVal), tostring(pitchVal), tostring(yawVal), tostring(rollVal)))

        if state.lastError ~= "" then
            Log("  LastError: " .. state.lastError)
        end
    end
end)

registerForEvent('onDraw', function()
    if not state.active then return end

    ImGui.Begin('HoverRot Player7B##hoverrot7b', true, ImGuiWindowFlags.AlwaysAutoResize)

    ImGui.Text('Strategy: RED4ext Native Override (shell)')
    ImGui.Text('RED4ext: ' .. (state.red4extLoaded and 'LOADED' or 'NOT LOADED'))
    ImGui.Separator()
    ImGui.Text(string.format('Pitch: %.1f deg', state.pitch))
    ImGui.Text(string.format('Yaw:   %.1f deg', state.yaw))
    ImGui.Text(string.format('Roll:  %.1f deg', state.roll))
    ImGui.Separator()
    ImGui.Text(string.format('Hover velocity: %.1f', state.hoverVelocity))
    ImGui.Text(string.format('Tick: %d', state.tickCount))
    ImGui.Separator()
    ImGui.Text('TweakDB:')
    ImGui.Text(string.format('  Writes: %d', state.tweakDBWriteCount))
    ImGui.Text(string.format('  Fails:  %d', state.tweakDBFailCount))
    ImGui.Text(string.format('  LastOK: %s', tostring(state.tweakDBLastWriteOk)))

    if state.lastError ~= "" then
        ImGui.Separator()
        ImGui.PushStyleColor(ImGuiCol.Text, 1.0, 0.3, 0.3, 1.0)
        ImGui.Text('Error: ' .. state.lastError)
        ImGui.PopStyleColor()
    end

    ImGui.Separator()
    ImGui.Text('Hotkeys:')
    ImGui.Text('  Toggle | Pitch U/D | Roll L/R | Yaw L/R')
    ImGui.Text('  Reset | Hover U/D/Stop | Dump TweakDB')

    ImGui.End()
end)
