--===========================================================================
-- Hover Vehicle Tester
-- Tests hovering a vehicle using physics impulses instead of teleports.
-- Two hotkeys:
--   1. Toggle activate/deactivate — starts/stops impulse-based hover
--   2. Teleport nudge — single teleport to hover point (escape hatch)
--
-- IMPULSE MODEL (confirmed by testing):
--   PhysicalImpulseEvent.worldImpulse is a FORCE (N·s), NOT delta-v.
--   The physics engine divides by mass to get actual velocity change.
--   So we compute desired delta-v first (mass-independent), clamp it,
--   then multiply by mass to get the force value.
--
--   This is DIFFERENT from PSMImpulse (player-only) which IS delta-v.
--
-- Hovers at HOVER_HEIGHT above ground (raycasts down each frame).
--===========================================================================

local ModName    = "HoverVehicleTester"
local HOVER_HEIGHT = 6.0   -- meters above ground (re-evaluated each frame)
local GRAVITY      = 9.81  -- m/s²
local SPRING_K     = 0.5   -- delta-v per meter of position error (Kp)
local DAMPING_K    = 1.5   -- delta-v per m/s of velocity (Kd)
local MAX_DV       = 5.0   -- max delta-v per axis per frame (m/s)
local VEHICLE_HALF_LEN = 1.5 -- half vehicle length for front/rear split
local NUM_DIAG     = 10    -- frames of diagnostic output

--===========================================================================
-- State
--===========================================================================

local state = {
    phase      = "IDLE",
    vehicle    = nil,
    mass       = 1500.0,
    hasRealMass = false,
    prevX      = 0,
    prevY      = 0,
    prevZ      = 0,
    hasPrevPos = false,
    diagCounter = 0,
}

--===========================================================================
-- Helper Functions
--===========================================================================

local function getGroundZ(x, y, z)
    local origin = Vector4.new(x, y, z + 1.0, 1)
    local dir    = Vector4.new(0, 0, -1, 0)
    local maxDist = 50.0
    local hit, hitPos
    pcall(function()
        local result = Game.GetSpatialQueriesSystem():SyncRaycastByQueryPreset(
            origin, dir, maxDist, "Bullet logic", false, false
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

local function getMountedVehicle()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then return nil end
    local vehicle = nil
    pcall(function() vehicle = Game.GetMountedVehicle(player) end)
    if not vehicle then
        pcall(function() vehicle = player:GetMountedVehicle() end)
    end
    if not vehicle then
        pcall(function() vehicle = player.mountedVehicle end)
    end
    return vehicle
end

local function getVehicleMass(vehicle)
    local mass = nil
    pcall(function() mass = vehicle:GetTotalMass() end)
    if type(mass) == "number" and mass > 0 then
        return mass, true
    end
    return 1500.0, false
end

--- Forward direction from quaternion (Cyberpunk forward = +Y)
local function getForwardVector(vehicle)
    local quat = vehicle:GetWorldOrientation()
    local x, y, z, w = quat.i, quat.j, quat.k, quat.r
    local fx = 2 * (x * y + z * w)
    local fy = 1 - 2 * (x * x + z * z)
    local fz = 2 * (y * z - x * w)
    return fx, fy, fz
end

--- Apply force impulse at front + rear to cancel pitch torque.
--- dvX/Y/Z are desired delta-v values (m/s). We convert to force via mass.
local function applyImpulse(vehicle, mass, dvX, dvY, dvZ)
    -- Clamp delta-v to safe range
    dvX = math.max(-MAX_DV, math.min(MAX_DV, dvX))
    dvY = math.max(-MAX_DV, math.min(MAX_DV, dvY))
    dvZ = math.max(-MAX_DV, math.min(MAX_DV, dvZ))

    -- Convert delta-v to force (PhysicalImpulseEvent expects force, not delta-v)
    local forceX = dvX * mass
    local forceY = dvY * mass
    local forceZ = dvZ * mass

    local pos = vehicle:GetWorldPosition()
    local fx, fy, fz = getForwardVector(vehicle)
    local hl = VEHICLE_HALF_LEN

    local fX = pos.x + fx * hl
    local fY = pos.y + fy * hl
    local fZ = pos.z + fz * hl
    local rX = pos.x - fx * hl
    local rY = pos.y - fy * hl
    local rZ = pos.z - fz * hl

    local hX = forceX * 0.5
    local hY = forceY * 0.5
    local hZ = forceZ * 0.5

    pcall(function()
        local imp = PhysicalImpulseEvent.new()
        imp.radius = 1.0
        imp.worldPosition = Vector3.new(fX, fY, fZ)
        imp.worldImpulse = Vector3.new(hX, hY, hZ)
        vehicle:QueueEvent(imp)
    end)
    pcall(function()
        local imp = PhysicalImpulseEvent.new()
        imp.radius = 1.0
        imp.worldPosition = Vector3.new(rX, rY, rZ)
        imp.worldImpulse = Vector3.new(hX, hY, hZ)
        vehicle:QueueEvent(imp)
    end)
end

--===========================================================================
-- Activation / Deactivation
--===========================================================================

local function activate()
    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then return end

    local vehicle = getMountedVehicle()
    if not vehicle then
        print(string.format("[%s] No vehicle — sit in a vehicle first", ModName))
        return
    end

    state.vehicle = vehicle
    state.mass, state.hasRealMass = getVehicleMass(vehicle)

    local pos = vehicle:GetWorldPosition()
    state.prevX = pos.x
    state.prevY = pos.y
    state.prevZ = pos.z
    state.hasPrevPos = true

    state.phase = "ACTIVE"
    state.diagCounter = NUM_DIAG

    local massStr = state.hasRealMass and "(real)" or "(fallback)"
    print(string.format("[%s] ACTIVE — mass=%.0f %s  hover height=%.1f above ground",
        ModName, state.mass, massStr, HOVER_HEIGHT))
end

local function deactivate()
    if state.phase == "IDLE" then return end
    state.phase      = "IDLE"
    state.vehicle    = nil
    state.hasPrevPos = false
    state.diagCounter = 0
    print(string.format("[%s] Deactivated", ModName))
end

--===========================================================================
-- Teleport Nudge
--===========================================================================

local function teleportNudge()
    if state.phase ~= "ACTIVE" then
        print(string.format("[%s] Not active — activate first", ModName))
        return
    end

    local vehicle = state.vehicle
    if not vehicle or not vehicle:IsAttached() then
        print(string.format("[%s] Vehicle lost", ModName))
        return
    end

    local pos = vehicle:GetWorldPosition()
    local groundZ = getGroundZ(pos.x, pos.y, pos.z)
    local targetZ = groundZ + HOVER_HEIGHT
    local euler = vehicle:GetWorldOrientation():ToEulerAngles()

    local ok, err = pcall(function()
        Game.GetTeleportationFacility():Teleport(
            vehicle,
            Vector4.new(pos.x, pos.y, targetZ, 1),
            euler
        )
    end)

    pos = vehicle:GetWorldPosition()
    state.prevX = pos.x
    state.prevY = pos.y
    state.prevZ = pos.z
    state.hasPrevPos = true
    state.diagCounter = NUM_DIAG

    if ok then
        print(string.format("[%s] Teleport nudge to Z=%.1f", ModName, targetZ))
    else
        print(string.format("[%s] Teleport FAILED: %s", ModName, tostring(err)))
    end
end

--===========================================================================
-- Hotkeys (root level)
--===========================================================================

registerHotkey("HVT_Toggle", "Toggle Hover (Impulse Vehicle)", function()
    if state.phase == "IDLE" then activate() else deactivate() end
end)

registerHotkey("HVT_Nudge", "Teleport Nudge (Impulse Vehicle)", function()
    teleportNudge()
end)

--===========================================================================
-- Event Handlers
--===========================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized — sit in a vehicle, then press toggle hotkey", ModName))
end)

registerForEvent("onUpdate", function(delta)
    if state.phase ~= "ACTIVE" then return end

    local player = Game.GetPlayer()
    if not player or not player:IsAttached() then
        deactivate()
        return
    end

    local vehicle = state.vehicle
    if not vehicle or not vehicle:IsAttached() then
        print(string.format("[%s] Vehicle lost, deactivating", ModName))
        deactivate()
        return
    end

    local pos = vehicle:GetWorldPosition()

    -- Raycast down each frame for ground-following hover
    local groundZ = getGroundZ(pos.x, pos.y, pos.z)
    local targetZ = groundZ + HOVER_HEIGHT

    -- Estimate velocity from position delta
    local velX, velY, velZ = 0, 0, 0
    if state.hasPrevPos and delta > 0 then
        velX = (pos.x - state.prevX) / delta
        velY = (pos.y - state.prevY) / delta
        velZ = (pos.z - state.prevZ) / delta
    end

    -- =====================================================
    -- Compute desired delta-v (mass-independent, in m/s)
    -- =====================================================

    -- Anti-gravity: cancel one frame of gravitational acceleration
    -- delta-v needed = g * delta (same for all masses)
    local antiGravDV = GRAVITY * delta

    -- Spring-damper for height (Z only)
    local errZ = targetZ - pos.z
    local springDVz = SPRING_K * errZ - DAMPING_K * velZ

    -- Gentle horizontal damping (no position correction, just velocity damping)
    local dampDVx = -DAMPING_K * velX * 0.3
    local dampDVy = -DAMPING_K * velY * 0.3

    -- Total desired delta-v
    local dvX = dampDVx
    local dvY = dampDVy
    local dvZ = antiGravDV + springDVz

    -- Apply: convert delta-v to force via mass, split front/rear
    applyImpulse(vehicle, state.mass, dvX, dvY, dvZ)

    -- Update prev position
    state.prevX = pos.x
    state.prevY = pos.y
    state.prevZ = pos.z
    state.hasPrevPos = true

    -- Diagnostics
    if state.diagCounter > 0 then
        state.diagCounter = state.diagCounter - 1
        -- Show clamped delta-v (what the vehicle actually experiences)
        local cdvX = math.max(-MAX_DV, math.min(MAX_DV, dvX))
        local cdvY = math.max(-MAX_DV, math.min(MAX_DV, dvY))
        local cdvZ = math.max(-MAX_DV, math.min(MAX_DV, dvZ))
        print(string.format(
            "[%s] DIAG pos=(%.1f,%.1f,%.1f) groundZ=%.1f targetZ=%.1f errZ=%.2f" ..
            " dv=(%.2f,%.2f,%.2f) antiG=%.3f vel=(%.1f,%.1f,%.1f) mass=%.0f",
            ModName,
            pos.x, pos.y, pos.z,
            groundZ, targetZ, errZ,
            cdvX, cdvY, cdvZ,
            antiGravDV,
            velX, velY, velZ,
            state.mass
        ))
    end
end)

registerForEvent("onShutdown", function()
    if state.phase ~= "IDLE" then deactivate() end
end)
