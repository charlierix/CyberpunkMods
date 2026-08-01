--[[
   Hover & Rotation Tester Mod - CET (Lua)

   Toggles a hover mode that locks the player a few meters above ground
   (continuous teleport to the same position, like wall hang / jetpack).
   6 hotkeys adjust yaw / pitch / roll by 30 degrees per press.

   Install: Copy this folder to:
     bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester/

   Bind hotkeys in: Settings > Key Bindings > HoverRotTester

   Pattern source: Overclocked Lynx Paws wall-running mod
     - Hover  = Game.GetTeleportationFacility():Teleport() every frame
     - Yaw    = EulerAngles Z (3rd param) via Teleport
     - Pitch  = FPP camera component SetLocalOrientation, Y axis
     - Roll   = FPP camera component SetLocalOrientation, X axis (negated)
     - Zero vel = PSMImpulse with zero vector via QueueEvent
]]

local ModName = "HoverRotTester"

--===========================================================================
-- CONFIG
--===========================================================================

local HOVER_HEIGHT = 3.0   -- meters above ground
local ROT_STEP     = 30     -- degrees per rotation hotkey press

--===========================================================================
-- STATE
--===========================================================================

local state = {
    active = false,
    hoverX = 0,
    hoverY = 0,
    hoverZ = 0,
    yaw   = 0,    -- Z rotation (facing direction)  -> Teleport
    pitch = 0,    -- look up/down                   -> FPP camera Y
    roll  = 0,    -- tilt sideways                  -> FPP camera X (negated)
}

--===========================================================================
-- HELPERS
--===========================================================================

--- Raycast straight down to find ground Z height beneath a position.
--- @param pos Vector4 Player world position.
--- @return number Ground Z height, or pos.z if raycast fails.
local function findGroundZ(pos)
    local sqs = Game.GetSpatialQueriesSystem()
    if not sqs then return pos.z end

    local origin = Vector4.new(pos.x, pos.y, pos.z + 0.1, 0)
    local to     = Vector4.new(pos.x, pos.y, pos.z - 100.0, 0)

    local ok, hit, trace = pcall(function()
        return sqs:SyncRaycastByQueryPreset(
            origin, to, CName.new("Bullet logic"), true, false
        )
    end)

    if ok and hit and trace then
        return trace.position.z
    end
    return pos.z
end

--- Zero out the player's velocity via PSM impulse to prevent physics drift.
--- @param player GameObject The player puppet.
local function zeroVelocity(player)
    pcall(function()
        local imp = PSMImpulse.new()
        imp.id = "impulse"
        imp.impulse = Vector4.new(0, 0, 0, 0)
        player:QueueEvent(imp)
    end)
end

--- Reset the FPP camera orientation back to neutral (no pitch / roll offset).
--- @param player GameObject The player puppet.
local function resetCamera(player)
    pcall(function()
        local camComp = player:GetFPPCameraComponent()
        if camComp then
            camComp:SetLocalOrientation(
                EulerAngles.ToQuat(EulerAngles.new(0, 0, 0))
            )
        end
    end)
end

--===========================================================================
-- ROOT-LEVEL HOTKEYS
-- (MUST be at file root — CET discovers these during its initial scan,
--  before onInit fires. See CET hotkey registration rule.)
--===========================================================================

registerHotkey("HRT_ToggleHover", "Toggle Hover Mode", function()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then return end

    if state.active then
        -- Deactivate
        state.active = false
        resetCamera(player)
        print(string.format("[%s] Hover deactivated", ModName))
    else
        -- Activate: capture position, find ground, init rotation
        local pos = player:GetWorldPosition()
        local groundZ = findGroundZ(pos)
        state.hoverX = pos.x
        state.hoverY = pos.y
        state.hoverZ = groundZ + HOVER_HEIGHT
        state.yaw   = player:GetWorldYaw()
        state.pitch = 0
        state.roll  = 0
        state.active = true
        print(string.format(
            "[%s] Hover ON  pos=(%.1f, %.1f, %.1f)  ground=%.1f  height=%.1f",
            ModName, state.hoverX, state.hoverY, state.hoverZ, groundZ, HOVER_HEIGHT
        ))
    end
end)

registerHotkey("HRT_YawPos", "Yaw +30", function()
    if state.active then
        --state.yaw = state.yaw + ROT_STEP
        state.yaw = state.yaw - ROT_STEP        -- need to subtract so that it rotates the expected direction (+ should be right)
        print(string.format("[%s] Yaw:   %.0f deg", ModName, state.yaw))
    end
end)

registerHotkey("HRT_YawNeg", "Yaw -30", function()
    if state.active then
        --state.yaw = state.yaw - ROT_STEP
        state.yaw = state.yaw + ROT_STEP        -- need to add so that it rotates the expected direction (- should be left)
        print(string.format("[%s] Yaw:   %.0f deg", ModName, state.yaw))
    end
end)

registerHotkey("HRT_PitchPos", "Pitch +30", function()
    if state.active then
        state.pitch = state.pitch + ROT_STEP
        print(string.format("[%s] Pitch: %.0f deg", ModName, state.pitch))
    end
end)

registerHotkey("HRT_PitchNeg", "Pitch -30", function()
    if state.active then
        state.pitch = state.pitch - ROT_STEP
        print(string.format("[%s] Pitch: %.0f deg", ModName, state.pitch))
    end
end)

registerHotkey("HRT_RollPos", "Roll +30", function()
    if state.active then
        --state.roll = state.roll + ROT_STEP
        state.roll = state.roll - ROT_STEP      -- add roll should be clockwise
        print(string.format("[%s] Roll:  %.0f deg", ModName, state.roll))
    end
end)

registerHotkey("HRT_RollNeg", "Roll -30", function()
    if state.active then
        --state.roll = state.roll - ROT_STEP
        state.roll = state.roll + ROT_STEP      -- subtract roll should be counter clockwise
        print(string.format("[%s] Roll:  %.0f deg", ModName, state.roll))
    end
end)

--===========================================================================
-- EVENT HANDLERS
--===========================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized — bind hotkeys in Settings > Key Bindings", ModName))
end)

registerForEvent("onUpdate", function(delta)
    if not state.active then return end

    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then return end

    -- Kill velocity so gravity / momentum can't pull the player off the hover point
    zeroVelocity(player)

    -- Continuous teleport to hold position (same pattern as wall hang / jetpack)
    -- Yaw (facing direction) is the Z rotation in Teleport's EulerAngles
    Game.GetTeleportationFacility():Teleport(
        player,
        Vector4.new(state.hoverX, state.hoverY, state.hoverZ, 1),
        EulerAngles.new(0, 0, state.yaw)
    )

    -- Pitch (Y) and roll (X, negated) via the FPP camera component
    -- Pattern from Overclocked Lynx Paws: EulerAngles.new(-roll, pitch, 0)
    pcall(function()
        local camComp = player:GetFPPCameraComponent()
        if camComp then
            local quat = EulerAngles.ToQuat(
                EulerAngles.new(-state.roll, state.pitch, 0)
            )
            camComp:SetLocalOrientation(quat)
        end
    end)
end)

registerForEvent("onShutdown", function()
    state.active = false
    local player = Game.GetPlayer()
    if player then
        resetCamera(player)
    end
end)
