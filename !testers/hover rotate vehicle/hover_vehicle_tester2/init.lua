--===========================================================================
-- Hover Vehicle Tester 2
-- Tests hovering a vehicle using physics impulses — revised approach.
--
-- KEY CHANGES FROM TESTER 1:
--   1. Single impulse at vehicle CENTER (not front/rear split)
--      → Eliminates pitch torque (zero torque arm from center of mass)
--      → Always inside collision body regardless of rotation
--   2. Large radius (5.0) instead of 1.0
--      → Sphere always encompasses the collision body → consistent strength
--      → Fixes rotation-dependent strength (was: strongest upright, weakest upside down)
--   3. 10% stronger impulse (STRENGTH_MULT = 1.1)
--
-- PHYSICS ANALYSIS:
--   PhysicalImpulseEvent applies a spherical impulse at worldPosition with radius.
--   It only affects collision shapes that overlap the sphere (worldPosition, radius).
--   worldImpulse is a FORCE (N·s) in WORLD coordinates, NOT model/local coordinates.
--   The engine divides by mass to get actual delta-v.
--
--   There is NO separate translation-only impulse function. The only way to avoid
--   torque is to apply the impulse at the center of mass (zero torque arm).
--   Applying above/below center of mass WOULD create torque (like a rocket nozzle).
--
--   Tester 1's front/rear split (±1.5m, radius=1.0) caused two problems:
--     a) Torque: offset application points create a torque arm → pitch rotation
--     b) Rotation-dependent strength: when vehicle rotates, the small radius
--        spheres at offset points may not fully overlap the (now rotated) collision
--        body, reducing effective force. Single center impulse with large radius
--        fixes this because the center is always inside the collision body.
--
-- Two hotkeys:
--   1. Toggle activate/deactivate — starts/stops impulse-based hover
--   2. Teleport nudge — single teleport to hover point (escape hatch)
--===========================================================================

local ModName       = "HoverVehicleTester2"
local HOVER_HEIGHT   = 6.0   -- meters above ground (re-evaluated each frame)
local GRAVITY        = 9.81  -- m/s²
local SPRING_K       = 0.5   -- delta-v per meter of position error (Kp)
local DAMPING_K      = 1.5   -- delta-v per m/s of velocity (Kd)
local MAX_DV         = 5.0   -- max delta-v per axis per frame (m/s)
local STRENGTH_MULT  = 1.1   -- 10% stronger than tester 1
local IMPULSE_RADIUS = 5.0   -- large radius to always encompass collision body
local NUM_DIAG       = 10    -- frames of diagnostic output

--===========================================================================
-- State
--===========================================================================

local state = {
    phase       = "IDLE",
    vehicle     = nil,
    mass        = 1500.0,
    hasRealMass = false,
    prevX       = 0,
    prevY       = 0,
    prevZ       = 0,
    hasPrevPos  = false,
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

--- Apply a single impulse at the vehicle's center of mass.
--- dvX/Y/Z are desired delta-v values (m/s). We convert to force via mass.
--- Single point = zero torque arm = pure translation (no pitch/roll/yaw coupling).
--- Large radius = consistent strength regardless of vehicle rotation.
local function applyImpulse(vehicle, mass, dvX, dvY, dvZ)
    -- Clamp delta-v to safe range
    dvX = math.max(-MAX_DV, math.min(MAX_DV, dvX))
    dvY = math.max(-MAX_DV, math.min(MAX_DV, dvY))
    dvZ = math.max(-MAX_DV, math.min(MAX_DV, dvZ))

    -- Convert delta-v to force (PhysicalImpulseEvent expects force, not delta-v)
    -- Apply 10% strength multiplier
    local forceX = dvX * mass * STRENGTH_MULT
    local forceY = dvY * mass * STRENGTH_MULT
    local forceZ = dvZ * mass * STRENGTH_MULT

    -- Single impulse at vehicle center — no offset, no torque
    local pos = vehicle:GetWorldPosition()

    pcall(function()
        local imp = PhysicalImpulseEvent.new()
        imp.radius = IMPULSE_RADIUS
        imp.worldPosition = Vector3.new(pos.x, pos.y, pos.z)
        imp.worldImpulse = Vector3.new(forceX, forceY, forceZ)
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
    print(string.format("[%s] ACTIVE — mass=%.0f %s  hover height=%.1f above ground  strength=%.2fx  radius=%.1f",
        ModName, state.mass, massStr, HOVER_HEIGHT, STRENGTH_MULT, IMPULSE_RADIUS))
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

registerHotkey("HVT2_Toggle", "Toggle Hover v2 (Center Impulse)", function()
    if state.phase == "IDLE" then activate() else deactivate() end
end)

registerHotkey("HVT2_Nudge", "Teleport Nudge v2 (Center Impulse)", function()
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

    -- Apply: single center impulse (no front/rear split)
    applyImpulse(vehicle, state.mass, dvX, dvY, dvZ)

    -- Update prev position
    state.prevX = pos.x
    state.prevY = pos.y
    state.prevZ = pos.z
    state.hasPrevPos = true

    -- Diagnostics
    if state.diagCounter > 0 then
        state.diagCounter = state.diagCounter - 1
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
