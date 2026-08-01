--[[
   FX Tester Mod - CET (Lua)
   Spawns a visual FX animation a few meters along the player's look direction.
   Plays effects like smoke, sparks, EMP bursts, sandevistan, etc.

   Install: Copy this folder to:
     bin/x64/plugins/cyber_engine_tweaks/mods/fx_tester/

   Bind hotkeys in: Settings > Key Bindings > FxTester

   Methods (tried in order):
     1. Spawn a prop entity at target position, play effect on it via GameObjectEffectHelper
     2. Queue entSpawnEffectEvent on the spawned prop
     3. Fallback: play effect on the player directly
]]

local ModName = "FxTester"

--============================================================================
-- CONFIGURATION  (edit these values directly)
--============================================================================
local Config = {
    spawnDistance   = 5.0,    -- meters along look direction
    effectDuration   = 3.0,    -- seconds before stopping/cleaning up the effect
    currentEffect    = 1,      -- index into EffectList (cycle with hotkey)
    debug            = true,   -- print debug info to CET console
}

--============================================================================
-- EFFECT LIST
--============================================================================
-- Each entry: { name = CName effect tag, label = display label, onPlayer = only works on player puppet }
--
-- Effect names come from the game's effect system. These are CName tags looked
-- up in the entity's effect map. Entity-playable effects work on any GameObject;
-- player-only effects only work on the player puppet.
--
-- Sources: adamsmasher game scripts, Legion Firmware CET mod, device VFX tags.

local EffectList = {
    -- Entity-playable effects (work on spawned props)
    { name = "e_vfx_flare_smoke_red_1",     label = "Flare Smoke Red 1",   onPlayer = false },
    { name = "e_vfx_flare_smoke_red_2",     label = "Flare Smoke Red 2",   onPlayer = false },
    { name = "fx_empty",                    label = "FX Empty",             onPlayer = false },
    { name = "fx_checked",                  label = "FX Checked",           onPlayer = false },
    { name = "broken",                      label = "Broken",              onPlayer = false },
    { name = "active",                      label = "Active",              onPlayer = false },
    { name = "destroyed",                   label = "Destroyed",           onPlayer = false },
    { name = "glitchEffect",               label = "Glitch Effect",        onPlayer = false },
    { name = "frameEffect",                label = "Frame Effect",         onPlayer = false },
    { name = "mine_laser_green",            label = "Mine Laser Green",     onPlayer = false },
    { name = "mine_laser_red",              label = "Mine Laser Red",       onPlayer = false },
    { name = "light_on_destr",             label = "Light On Destroyed",   onPlayer = false },
    { name = "fx_candles",                 label = "Candles",             onPlayer = false },
    { name = "fx_candles_lightup",         label = "Candles Light Up",    onPlayer = false },
    { name = "fish_eye",                   label = "Fish Eye",            onPlayer = false },
    { name = "disabling_connectivity_glitch", label = "Disable Glitch",   onPlayer = false },
    -- Player-only effects (need player puppet)
    { name = "blackwall_use_force",         label = "Blackwall Force",     onPlayer = true  },
    { name = "charge",                     label = "Charge",              onPlayer = true  },
    { name = "dash",                       label = "Dash",               onPlayer = true  },
    { name = "cloak_on",                   label = "Cloak On",            onPlayer = true  },
    { name = "cloak_off",                  label = "Cloak Off",           onPlayer = true  },
    { name = "blood_headshot",             label = "Blood Headshot",      onPlayer = true  },
    { name = "cyberware_explosion",        label = "Cyberware Explosion", onPlayer = true  },
    { name = "detonation_warning",         label = "Detonation Warning",  onPlayer = true  },
    { name = "deflection",                 label = "Deflection",          onPlayer = true  },
    { name = "camo_intro_vfx",             label = "Camo Intro VFX",      onPlayer = true  },
    { name = "screen_scanning_loop",       label = "Scanning Loop",       onPlayer = true  },
    { name = "screen_scanning_red_loop",   label = "Scanning Red Loop",   onPlayer = true  },
}

--============================================================================
-- HELPERS
--============================================================================

local function dprint(msg)
    if Config.debug then
        print(string.format("[%s] %s", ModName, msg))
    end
end

--- Get player position and camera forward vector
local function GetPlayerView()
    local player = Game.GetPlayer()
    if not player then return nil, nil, nil end

    local pos = nil
    pcall(function() pos = player:GetWorldPosition() end)
    if not pos then return nil, nil, nil end

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

--- Build a WorldTransform from a position
--- CET Lua doesn't expose WorldTransform.Create(); use GetPlayer():GetWorldTransform()
--- and :SetPosition() instead (pattern from Cyberscript, MarmurBank mods)
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
    local pos3 = Vector3.new(pos.x, pos.y, pos.z)
    transform:SetPosition(pos3)
    return transform
end

--============================================================================
-- EFFECT SPAWNING
--============================================================================

--- Active effects being tracked for cleanup
local ActiveEffects = {}  -- { entity = ref, effectName = string, timer = float, isProp = bool }

--- Play an effect on an entity using GameObjectEffectHelper
--- Confirmed working in CET Lua via Legion Firmware mod
local function PlayEffectOnEntity(entity, effectName)
    if not entity or not IsDefined(entity) then
        dprint("  PlayEffectOnEntity: entity not defined")
        return false
    end

    local ok, err = pcall(function()
        GameObjectEffectHelper.StartEffectEvent(entity, effectName, false)
    end)
    if ok then
        dprint(string.format("  StartEffectEvent('%s') on entity OK", effectName))
        return true
    else
        dprint(string.format("  StartEffectEvent failed: %s", tostring(err)))
        return false
    end
end

--- Stop an effect on an entity
local function StopEffectOnEntity(entity, effectName)
    if not entity or not IsDefined(entity) then return end

    pcall(function() GameObjectEffectHelper.StopEffectEvent(entity, effectName) end)
    pcall(function() GameObjectEffectHelper.BreakEffectLoopEvent(entity, effectName) end)
end

--- Try to queue entSpawnEffectEvent on an entity
--- This is the native event approach used by the game's AI system
local function QueueSpawnEffectEvent(entity, effectName)
    if not entity or not IsDefined(entity) then return false end

    local ok, err = pcall(function()
        local evt = entSpawnEffectEvent.new()
        evt.effectName = effectName
        evt.persistOnDetach = true
        evt.breakAllLoops = false
        evt.breakAllOnDestroy = true
        entity:QueueEvent(evt)
    end)
    if ok then
        dprint(string.format("  QueueEvent entSpawnEffectEvent('%s') OK", effectName))
        return true
    else
        dprint(string.format("  QueueEvent failed: %s", tostring(err)))
        return false
    end
end

--- Valid entity paths confirmed in CET Lua mods (Cyberscript, MarmurBank)
local PropPaths = {
    "base\\items\\interactive\\dining_accessories\\int_dining_accessories_001__bar_asset_h_sponge.ent",
    "base\\cyberscript\\entity\\workspot_anim.ent",
}

--- Try to spawn a prop entity at the target position and play the effect on it
--- Uses exEntitySpawner.Spawn (confirmed working in Cyberscript/MarmurBank mods)
local function SpawnPropAndPlayEffect(targetPos, effectName)
    local transform = MakeTransform(targetPos)

    for _, path in ipairs(PropPaths) do
        local spawnedEntity = nil
        local ok, err = pcall(function()
            spawnedEntity = exEntitySpawner.Spawn(path, transform, "")
        end)
        if ok and spawnedEntity and IsDefined(spawnedEntity) then
            dprint(string.format("  Spawned prop: %s", path))
            -- Try GameObjectEffectHelper first
            if PlayEffectOnEntity(spawnedEntity, effectName) then
                return spawnedEntity, true
            end
            -- Try entSpawnEffectEvent as fallback
            if QueueSpawnEffectEvent(spawnedEntity, effectName) then
                return spawnedEntity, true
            end
            -- Effect not found on this entity, despawn and try next path
            pcall(function() exEntitySpawner.Despawn(spawnedEntity) end)
            dprint("  Effect not found on this entity, trying next...")
        else
            dprint(string.format("  SpawnEntity failed for %s: %s", path, tostring(err)))
        end
    end

    return nil, false
end

--- Main: spawn FX at target position
local function SpawnFx()
    local player, targetPos = GetTargetPosition()
    if not player or not targetPos then
        dprint("Could not get player view / target position")
        return
    end

    local effect = EffectList[Config.currentEffect]
    if not effect then
        dprint("Invalid effect index")
        return
    end

    local pos = player:GetWorldPosition()
    dprint(string.format("--- Spawning FX: '%s' (%s) ---", effect.name, effect.label))
    dprint(string.format("Player:  (%.1f, %.1f, %.1f)", pos.x, pos.y, pos.z))
    dprint(string.format("Target:  (%.1f, %.1f, %.1f)", targetPos.x, targetPos.y, targetPos.z))
    dprint(string.format("Distance: %.1fm  Duration: %.1fs", Config.spawnDistance, Config.effectDuration))

    local entity = nil
    local isProp = false

    if not effect.onPlayer then
        -- Try to spawn a prop at the target position and play effect on it
        entity, isProp = SpawnPropAndPlayEffect(targetPos, effect.name)
    end

    if not entity then
        -- Fallback: play effect on the player directly
        dprint("  Falling back to player-attached effect")
        if PlayEffectOnEntity(player, effect.name) then
            entity = player
            isProp = false
        end
    end

    if entity then
        table.insert(ActiveEffects, {
            entity = entity,
            effectName = effect.name,
            timer = Config.effectDuration,
            isProp = isProp,
        })
        dprint(string.format("Effect '%s' spawned, will clean up in %.1fs", effect.label, Config.effectDuration))
    else
        dprint(string.format("Failed to spawn effect '%s'", effect.label))
    end
end

--============================================================================
-- CYCLE EFFECT
--============================================================================

local function CycleEffect()
    Config.currentEffect = (Config.currentEffect % #EffectList) + 1
    local effect = EffectList[Config.currentEffect]
    print(string.format("[%s] Effect: %s (%d/%d)", ModName, effect.label, Config.currentEffect, #EffectList))
end

--============================================================================
-- INIT & UPDATE
--============================================================================

registerForEvent("onInit", function()
    print(string.format("[%s] Initialized  |  dist: %.1fm  |  duration: %.1fs  |  effects: %d",
        ModName, Config.spawnDistance, Config.effectDuration, #EffectList))
    print(string.format("[%s] Current effect: %s (%d/%d)",
        ModName, EffectList[Config.currentEffect].label, Config.currentEffect, #EffectList))
    print(string.format("[%s] Bind keys in: Settings > Key Bindings > FxTester", ModName))
    print(string.format("[%s] Uses exEntitySpawner + GameObjectEffectHelper + entSpawnEffectEvent", ModName))
end)

registerForEvent("onUpdate", function(delta)
    -- Process active effect timers
    for i = #ActiveEffects, 1, -1 do
        local active = ActiveEffects[i]
        active.timer = active.timer - delta

        if active.timer <= 0 then
            -- Stop effect and clean up
            StopEffectOnEntity(active.entity, active.effectName)
            dprint(string.format("  Cleaned up effect '%s'", active.effectName))

            -- Despawn prop entities (confirmed working via exEntitySpawner.Despawn)
            if active.isProp and active.entity and IsDefined(active.entity) then
                pcall(function() exEntitySpawner.Despawn(active.entity) end)
                dprint("  Despawned prop entity")
            end

            table.remove(ActiveEffects, i)
        end
    end
end)

--============================================================================
-- HOTKEYS  (MUST be at file root level — CET scans for these before onInit)
--============================================================================

registerHotkey("FxTesterSpawn", "Spawn Test FX", function()
    SpawnFx()
end)

registerHotkey("FxTesterCycle", "Cycle FX Type", function()
    CycleEffect()
end)
