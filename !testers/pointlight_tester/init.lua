--[[
   Point Light Tester Mod - CET (Lua)
   Two modes for testing dynamic lighting:

   Mode 1 — Player Flashlight (confirmed working):
     Toggles and configures the player's built-in Flashlight LightComponent.
     Pattern from Better Flashlight mod (player:FindComponentByName("Flashlight")).

   Mode 2 — Spawn Light Entity (experimental):
     Spawns an entity at a world position and tries to find/configure its
     LightComponent. Tries multiple spawn APIs and entity paths.

   Install: Copy this folder to:
     bin/x64/plugins/cyber_engine_tweaks/mods/pointlight_tester/

   Bind hotkeys in: Settings > Key Bindings > PointLightTester
]]

local ModName = "PointLightTester"

--============================================================================
-- CONFIGURATION  (edit these values directly)
--============================================================================
local Config = {
    mode            = 1,      -- 1 = Player Flashlight, 2 = Spawn Entity
    spawnDistance   = 5.0,    -- meters along look direction (mode 2)
    intensity       = 10.0,   -- light strength (mode 1 uses SetStrength = intensity/15)
    radius          = 15.0,   -- light radius in meters
    innerAngle      = 30.0,  -- inner cone angle (spot lights)
    outerAngle      = 60.0,  -- outer cone angle (spot lights)
    currentColor    = 1,      -- index into PresetColors
    currentTemplate = 1,      -- index into LightTemplates (mode 2)
    autoDespawn     = true,   -- auto-despawn previous entity when spawning new
    debug           = true,   -- print debug info to CET console
}

--============================================================================
-- PRESET COLORS (R, G, B, A — 0-255 range)
--============================================================================

local PresetColors = {
    { name = "Warm White",   r = 255, g = 240, b = 200, a = 255 },
    { name = "Pure White",   r = 255, g = 255, b = 255, a = 255 },
    { name = "Red",          r = 255, g = 50,  b = 50,  a = 255 },
    { name = "Green",        r = 50,  g = 255, b = 50,  a = 255 },
    { name = "Blue",         r = 50,  g = 50,  b = 255, a = 255 },
    { name = "Cyan",         r = 50,  g = 255, b = 255, a = 255 },
    { name = "Magenta",      r = 255, g = 50,  b = 255, a = 255 },
    { name = "Yellow",       r = 255, g = 255, b = 50,  a = 255 },
    { name = "Orange",       r = 255, g = 150, b = 50,  a = 255 },
    { name = "Purple",       r = 150, g = 50,  b = 200, a = 255 },
}

--============================================================================
-- LIGHT TEMPLATES (mode 2)
--============================================================================
-- Entity templates that may have LightComponent.
-- These are best-guess paths; many base game device entities may not be
-- dynamically spawnable. We try them in order and report which work.

local LightTemplates = {
    -- AMM custom props (require AMM installed)
    { path = "base\\amm_props\\collab\\entity\\neokitsch_ceiling_light_a.ent", label = "AMM Neokitsch Ceiling Light" },
    { path = "base\\amm_props\\collab\\entity\\corridor_light_e.ent", label = "AMM Corridor Light E" },
    { path = "base\\amm_props\\collab\\entity\\int_nkt_apartment_a_neon_light_1300_aa.ent", label = "AMM Neon Light" },
    { path = "base\\amm_props\\collab\\entity\\light_panel_falling_a_h800_w100_a.ent", label = "AMM Light Panel" },
    { path = "base\\amm_props\\collab\\entity\\hologram_light_beam.ent", label = "AMM Hologram Light Beam" },
    -- Base game lighting devices (may fail — world-building entities)
    { path = "base\\gameplay\\devices\\lights\\indestructible\\lch_hanging_lamp_a.ent", label = "Hanging Lamp" },
    { path = "base\\gameplay\\devices\\lights\\indestructible\\lch_fluorescent_lamp_b.ent", label = "Fluorescent Lamp B" },
    { path = "base\\gameplay\\devices\\lights\\indestructible\\jpn_wall_lamp_d.ent", label = "JPN Wall Lamp D" },
    { path = "base\\items\\interactive\\lighting\\int_lighting_001__chinese_lantern_a.ent", label = "Chinese Lantern" },
}

--============================================================================
-- HELPERS
--============================================================================

local function dprint(msg)
    if Config.debug then
        print(string.format("[%s] %s", ModName, msg))
    end
end

local function GetColor(colorIdx)
    local c = PresetColors[colorIdx] or PresetColors[1]
    local color = NewObject("Color")
    color.Red = c.r
    color.Green = c.g
    color.Blue = c.b
    color.Alpha = c.a
    return color
end

--- Get player position and camera forward vector
local function GetPlayerView()
    local player = Game.GetPlayer()
    if not player then return nil, nil, nil end

    local pos = nil
    pcall(function() pos = player:GetWorldPosition() end)
    if not pos then return player, nil, nil end

    local camSys = Game.GetCameraSystem()
    if not camSys then return player, pos, nil end

    local forward = nil
    pcall(function() forward = camSys:GetActiveCameraForward() end)
    if not forward then return player, pos, nil end

    return player, pos, forward
end

--- Calculate target position N meters along look direction
local function GetTargetPosition()
    local player, pos, forward = GetPlayerView()
    if not player or not pos or not forward then return nil, nil end

    local targetPos = Vector4.new(
        pos.x + forward.x * Config.spawnDistance,
        pos.y + forward.y * Config.spawnDistance,
        pos.z + forward.z * Config.spawnDistance,
        1.0
    )
    return player, targetPos
end

--- Build a WorldTransform from a Vector4 position
--- SetPosition expects Vector4 (confirmed by user error report)
local function MakeTransform(pos)
    local player = Game.GetPlayer()
    local transform = nil
    if player then
        pcall(function() transform = player:GetWorldTransform() end)
    end
    if not transform then
        dprint("  MakeTransform: could not get player WorldTransform")
        return nil
    end
    -- pos is already Vector4 — pass directly (NOT Vector3)
    transform:SetPosition(pos)
    return transform
end

--- Get the LightComponent from an entity by iterating components
--- Pattern from Appearance Menu Mod (confirmed working)
local function GetLightComponent(entity)
    if not entity or not IsDefined(entity) then return nil end

    local components = nil
    pcall(function() components = entity:GetComponents() end)
    if not components then return nil end

    for _, comp in ipairs(components) do
        local className = nil
        pcall(function() className = NameToString(comp:GetClassName()) end)
        if className and string.find(className, "LightComponent") then
            return comp
        end
    end

    return nil
end

--- Configure a LightComponent with current settings
local function ConfigureLight(component, colorIdx, intensity, radius, inner, outer)
    if not component then return false end

    -- Set color
    pcall(function()
        component:SetColor(GetColor(colorIdx))
    end)

    -- Set intensity/strength
    -- Player Flashlight uses SetStrength (0-1 range, intensity/15)
    -- Spawned entities use SetIntensity (raw cd value)
    pcall(function()
        if component.SetStrength then
            component:SetStrength(intensity / 15.0)
        elseif component.SetIntensity then
            component:SetIntensity(intensity)
        end
    end)

    -- Set radius
    pcall(function()
        if component.SetRadius then
            component:SetRadius(radius)
        end
    end)

    -- Set angles (spot light cone)
    pcall(function()
        if component.SetAngles then
            component:SetAngles(inner, math.min(140, outer))
        end
    end)

    -- Turn on
    pcall(function()
        if component.ToggleLight then
            component:ToggleLight(true)
        end
    end)
    pcall(function()
        if component.Toggle then
            component:Toggle(true)
        end
    end)

    return true
end

--============================================================================
-- MODE 1: PLAYER FLASHLIGHT (confirmed working)
--============================================================================
-- Pattern from Better Flashlight mod:
--   comp = player:FindComponentByName(CName.new("Flashlight"))
--   comp:Toggle(true) / comp:ToggleLight(true)
--   comp:SetStrength(val) / comp:SetRadius(val) / comp:SetAngles(i,o)
--   comp:SetColor(Color.new({...})) / comp:IsOn()

local FlashlightComp = nil
local FlashlightOn = false

local function FindPlayerFlashlight()
    local player = Game.GetPlayer()
    if not player then return nil end

    local comp = nil
    pcall(function()
        comp = player:FindComponentByName(CName.new("Flashlight"))
    end)
    return comp
end

local function FlashlightToggle()
    if not FlashlightComp then
        FlashlightComp = FindPlayerFlashlight()
    end
    if not FlashlightComp then
        dprint("No Flashlight component found on player")
        return false
    end

    FlashlightOn = not FlashlightOn

    if FlashlightOn then
        pcall(function() FlashlightComp:Toggle(true) end)
        pcall(function() FlashlightComp:ToggleLight(true) end)
        ConfigureLight(FlashlightComp, Config.currentColor, Config.intensity,
                       Config.radius, Config.innerAngle, Config.outerAngle)
        dprint(string.format("Flashlight ON  |  color: %s  |  strength: %.2f  |  radius: %.1fm",
            PresetColors[Config.currentColor].name, Config.intensity / 15.0, Config.radius))
    else
        pcall(function() FlashlightComp:ToggleLight(false) end)
        pcall(function() FlashlightComp:Toggle(false) end)
        dprint("Flashlight OFF")
    end

    return true
end

local function FlashlightUpdate()
    if not FlashlightComp or not FlashlightOn then return end
    ConfigureLight(FlashlightComp, Config.currentColor, Config.intensity,
                   Config.radius, Config.innerAngle, Config.outerAngle)
    dprint(string.format("Flashlight updated  |  color: %s  |  strength: %.2f  |  radius: %.1fm",
        PresetColors[Config.currentColor].name, Config.intensity / 15.0, Config.radius))
end

local function FlashlightTurnOff()
    if FlashlightComp then
        pcall(function() FlashlightComp:ToggleLight(false) end)
        pcall(function() FlashlightComp:Toggle(false) end)
    end
    FlashlightOn = false
end

--============================================================================
-- MODE 2: SPAWN LIGHT ENTITY (experimental)
--============================================================================

local SpawnedEntity = nil  -- { entity = ref, template = string, entityID = id }

-- Poll state for async entity init (replaces Cron dependency)
local LightPoll = nil  -- { entityID = id, template = table, attempts = 0, maxAttempts = 30, accum = 0.0 }

--- Despawn the currently spawned entity
local function DespawnSpawned()
    if SpawnedEntity then
        if SpawnedEntity.entity and IsDefined(SpawnedEntity.entity) then
            pcall(function() exEntitySpawner.Despawn(SpawnedEntity.entity) end)
            dprint(string.format("  Despawned: %s", SpawnedEntity.template))
        end
        SpawnedEntity = nil
    end
end

--- Try spawning via exEntitySpawner (AMM pattern)
--- Returns entityID (not entity!) — need Game.FindEntityByID to get entity
local function TrySpawnExEntitySpawner(path, transform)
    local entityID = nil
    local ok, err = pcall(function()
        entityID = exEntitySpawner.Spawn(path, transform, "")
    end)
    if not ok then
        dprint(string.format("  exEntitySpawner.Spawn error: %s", tostring(err)))
        return nil
    end
    -- entityID can be nil if path is invalid
    if not entityID then
        dprint("  exEntitySpawner.Spawn returned nil (invalid path?)")
        return nil
    end
    return entityID
end

--- Try spawning via WorldFunctionalTests.SpawnEntity (Cyberscript/MarmurBank pattern)
local function TrySpawnWorldFunctional(path, transform)
    local entityID = nil
    local ok, err = pcall(function()
        entityID = WorldFunctionalTests.SpawnEntity(path, transform, "")
    end)
    if not ok then
        dprint(string.format("  WorldFunctionalTests.SpawnEntity error: %s", tostring(err)))
        return nil
    end
    if not entityID then
        dprint("  WorldFunctionalTests.SpawnEntity returned nil")
        return nil
    end
    return entityID
end

--- Try spawning via StaticEntitySystem:SpawnEntity (Gambling System pattern)
local function TrySpawnStaticEntity(path, pos)
    local entityID = nil
    local ok, err = pcall(function()
        local spec = StaticEntitySpec.new()
        spec.templatePath = path
        spec.position = pos
        spec.orientation = GetSingleton('Quaternion'):ToQuat(EulerAngles.new(0, 0, 0))
        spec.tags = {"PointLightTester"}
        entityID = Game.GetStaticEntitySystem():SpawnEntity(spec)
    end)
    if not ok then
        dprint(string.format("  StaticEntitySystem.SpawnEntity error: %s", tostring(err)))
        return nil
    end
    if not entityID then
        dprint("  StaticEntitySystem.SpawnEntity returned nil")
        return nil
    end
    return entityID
end

--- Main spawn function — tries multiple APIs and entity paths
local function SpawnLightEntity()
    local player, targetPos = GetTargetPosition()
    if not player or not targetPos then
        dprint("Could not get player view / target position")
        return
    end

    local template = LightTemplates[Config.currentTemplate]
    if not template then
        dprint("Invalid template index")
        return
    end

    if Config.autoDespawn then
        DespawnSpawned()
    end

    local pos = player:GetWorldPosition()
    dprint(string.format("--- Spawning Light Entity: '%s' ---", template.label))
    dprint(string.format("Player:  (%.1f, %.1f, %.1f)", pos.x, pos.y, pos.z))
    dprint(string.format("Target:  (%.1f, %.1f, %.1f)", targetPos.x, targetPos.y, targetPos.z))
    dprint(string.format("Color:   %s", PresetColors[Config.currentColor].name))

    local transform = MakeTransform(targetPos)
    if not transform then
        dprint("Could not create transform")
        return
    end

    -- Try spawn APIs in order
    local entityID = nil

    -- 1. exEntitySpawner.Spawn (AMM pattern)
    dprint("  Trying exEntitySpawner.Spawn...")
    entityID = TrySpawnExEntitySpawner(template.path, transform)

    -- 2. WorldFunctionalTests.SpawnEntity (Cyberscript pattern)
    if not entityID then
        dprint("  Trying WorldFunctionalTests.SpawnEntity...")
        entityID = TrySpawnWorldFunctional(template.path, transform)
    end

    -- 3. StaticEntitySystem:SpawnEntity (Gambling System pattern)
    if not entityID then
        dprint("  Trying StaticEntitySystem:SpawnEntity...")
        entityID = TrySpawnStaticEntity(template.path, targetPos)
    end

    if not entityID then
        dprint(string.format("  All spawn APIs failed for '%s'", template.path))
        dprint("  Try cycling to a different template, or use Player Flashlight mode.")
        return
    end

    dprint("  Spawn returned entityID — polling for entity init...")

    -- Poll for entity to be ready, then find and configure LightComponent
    -- Uses CET native onUpdate instead of external Cron module
    LightPoll = {
        entityID   = entityID,
        template   = template,
        attempts   = 0,
        maxAttempts = 30,
        accum      = 0.0,
    }
    dprint("  Polling will start next frame via onUpdate...")
end

--- Called from onUpdate to poll spawned entity for LightComponent
local function PollSpawnedEntity(delta)
    if not LightPoll then
        return
    end

    -- Throttle to ~10 checks/sec (matches original 0.1s Cron interval)
    LightPoll.accum = LightPoll.accum + delta
    if LightPoll.accum < 0.1 then
        return
    end
    LightPoll.accum = 0.0
    LightPoll.attempts = LightPoll.attempts + 1

    local entityID = LightPoll.entityID
    local template = LightPoll.template
    local attempts = LightPoll.attempts

    local entity = nil
    pcall(function() entity = Game.FindEntityByID(entityID) end)

    if entity and IsDefined(entity) then
        local component = GetLightComponent(entity)

        if component then
            dprint(string.format("  LightComponent found (attempt %d)", attempts))

            -- Read original values
            local origIntensity, origRadius = nil, nil
            pcall(function() origIntensity = component.intensity end)
            pcall(function() origRadius = component.radius end)
            dprint(string.format("  Original: intensity=%s  radius=%s",
                tostring(origIntensity), tostring(origRadius)))

            -- Apply settings
            ConfigureLight(component, Config.currentColor, Config.intensity,
                           Config.radius, Config.innerAngle, Config.outerAngle)

            -- Verify
            local newIntensity, newRadius = nil, nil
            pcall(function() newIntensity = component.intensity end)
            pcall(function() newRadius = component.radius end)
            dprint(string.format("  Applied:  intensity=%s  radius=%s",
                tostring(newIntensity), tostring(newRadius)))

            SpawnedEntity = {
                entity = entity,
                entityID = entityID,
                template = template.path,
            }

            dprint(string.format("Light '%s' active with color '%s'",
                template.label, PresetColors[Config.currentColor].name))
            LightPoll = nil
            return
        end
    end

    if attempts >= LightPoll.maxAttempts then
        dprint(string.format("  No LightComponent found after %d attempts", LightPoll.maxAttempts))
        -- Keep entity anyway so user can see what spawned
        SpawnedEntity = {
            entity = entity,
            entityID = entityID,
            template = template.path,
        }
        if entity and IsDefined(entity) then
            dprint("  Entity spawned but has no LightComponent — visible as a prop.")
            dprint("  Try cycling to a different template.")
        else
            dprint("  Entity not found — spawn may have failed silently.")
        end
        LightPoll = nil
    end
end

--- Update properties on the spawned entity's light
local function UpdateSpawnedLight()
    if not SpawnedEntity or not SpawnedEntity.entity or not IsDefined(SpawnedEntity.entity) then
        dprint("No spawned light to update")
        return
    end

    local component = GetLightComponent(SpawnedEntity.entity)
    if not component then
        dprint("No LightComponent on spawned entity")
        return
    end

    ConfigureLight(component, Config.currentColor, Config.intensity,
                   Config.radius, Config.innerAngle, Config.outerAngle)
    dprint(string.format("Spawned light updated  |  color: %s  |  intensity: %.1f  |  radius: %.1fm",
        PresetColors[Config.currentColor].name, Config.intensity, Config.radius))
end

--============================================================================
-- UNIFIED ACTIONS
--============================================================================

local function Activate()
    if Config.mode == 1 then
        FlashlightToggle()
    else
        SpawnLightEntity()
    end
end

local function Deactivate()
    if Config.mode == 1 then
        FlashlightTurnOff()
    else
        DespawnSpawned()
    end
end

local function UpdateProperties()
    if Config.mode == 1 then
        if FlashlightOn then
            FlashlightUpdate()
        end
    else
        UpdateSpawnedLight()
    end
end

--============================================================================
-- CYCLE FUNCTIONS
--============================================================================

local function CycleMode()
    -- Turn off current mode before switching
    Deactivate()
    Config.mode = (Config.mode % 2) + 1
    local modeName = Config.mode == 1 and "Player Flashlight" or "Spawn Entity"
    print(string.format("[%s] Mode: %s (%d/2)", ModName, modeName, Config.mode))
end

local function CycleColor()
    Config.currentColor = (Config.currentColor % #PresetColors) + 1
    print(string.format("[%s] Color: %s (%d/%d)", ModName,
        PresetColors[Config.currentColor].name, Config.currentColor, #PresetColors))
    UpdateProperties()
end

local function CycleTemplate()
    Config.currentTemplate = (Config.currentTemplate % #LightTemplates) + 1
    print(string.format("[%s] Template: %s (%d/%d)", ModName,
        LightTemplates[Config.currentTemplate].label, Config.currentTemplate, #LightTemplates))
end

local function IncreaseIntensity()
    Config.intensity = Config.intensity + 5.0
    print(string.format("[%s] Intensity: %.1f", ModName, Config.intensity))
    UpdateProperties()
end

local function DecreaseIntensity()
    Config.intensity = math.max(0.0, Config.intensity - 5.0)
    print(string.format("[%s] Intensity: %.1f", ModName, Config.intensity))
    UpdateProperties()
end

local function IncreaseRadius()
    Config.radius = Config.radius + 2.0
    print(string.format("[%s] Radius: %.1fm", ModName, Config.radius))
    UpdateProperties()
end

local function DecreaseRadius()
    Config.radius = math.max(1.0, Config.radius - 2.0)
    print(string.format("[%s] Radius: %.1fm", ModName, Config.radius))
    UpdateProperties()
end

local function ToggleLight()
    if Config.mode == 1 then
        FlashlightToggle()
    else
        if not SpawnedEntity or not SpawnedEntity.entity or not IsDefined(SpawnedEntity.entity) then
            dprint("No spawned light to toggle")
            return
        end
        local component = GetLightComponent(SpawnedEntity.entity)
        if not component then return end

        local isOn = true
        pcall(function()
            if component.IsOn then isOn = component:IsOn() end
        end)
        local newState = not isOn
        pcall(function()
            if component.ToggleLight then component:ToggleLight(newState)
            elseif component.Toggle then component:Toggle(newState) end
        end)
        dprint(string.format("Light %s", newState and "ON" or "OFF"))
    end
end

--============================================================================
-- INIT & SHUTDOWN
--============================================================================

registerForEvent("onInit", function()
    -- Pre-find the player's flashlight component
    FlashlightComp = FindPlayerFlashlight()

    local modeName = Config.mode == 1 and "Player Flashlight" or "Spawn Entity"
    print(string.format("[%s] Initialized  |  mode: %s  |  intensity: %.1f  |  radius: %.1fm",
        ModName, modeName, Config.intensity, Config.radius))
    print(string.format("[%s] Current color: %s (%d/%d)",
        ModName, PresetColors[Config.currentColor].name, Config.currentColor, #PresetColors))
    if FlashlightComp then
        print(string.format("[%s] Player Flashlight component found OK", ModName))
    else
        print(string.format("[%s] Player Flashlight component NOT found — will retry on use", ModName))
    end
    print(string.format("[%s] Templates: %d  |  Bind keys in: Settings > Key Bindings > PointLightTester",
        ModName, #LightTemplates))
end)

registerForEvent("onUpdate", function(delta)
    -- Poll spawned entity for LightComponent (replaces Cron module)
    PollSpawnedEntity(delta)
end)

registerForEvent("onShutdown", function()
    FlashlightTurnOff()
    DespawnSpawned()
end)

--============================================================================
-- HOTKEYS  (MUST be at file root level — CET scans for these before onInit)
--============================================================================

registerHotkey("PointLightTesterActivate", "Activate / Toggle Light", function()
    Activate()
end)

registerHotkey("PointLightTesterDeactivate", "Deactivate / Despawn", function()
    Deactivate()
end)

registerHotkey("PointLightTesterCycleMode", "Cycle Mode (Flashlight/Spawn)", function()
    CycleMode()
end)

registerHotkey("PointLightTesterCycleColor", "Cycle Color", function()
    CycleColor()
end)

registerHotkey("PointLightTesterCycleTemplate", "Cycle Entity Template", function()
    CycleTemplate()
end)

registerHotkey("PointLightTesterIntensityUp", "Increase Intensity (+5)", function()
    IncreaseIntensity()
end)

registerHotkey("PointLightTesterIntensityDown", "Decrease Intensity (-5)", function()
    DecreaseIntensity()
end)

registerHotkey("PointLightTesterRadiusUp", "Increase Radius (+2m)", function()
    IncreaseRadius()
end)

registerHotkey("PointLightTesterRadiusDown", "Decrease Radius (-2m)", function()
    DecreaseRadius()
end)

registerHotkey("PointLightTesterToggle", "Toggle Light On/Off", function()
    ToggleLight()
end)
