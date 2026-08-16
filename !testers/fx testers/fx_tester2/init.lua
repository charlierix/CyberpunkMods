--[[
   FX Tester 2 - CET (Lua)
   Spawns a Zetatech Bombus drone, then applies visual effects to that drone.

   This combines:
     - customentity4's proven drone spawn pattern (exEntitySpawner + polling)
     - fx_tester's effect application pattern (GameObjectEffectHelper + entSpawnEffectEvent)

   Key insight from fx_tester research: effects only fire on entities that have
   FxResourceMapperComponent with matching CName tag mappings. Generic props
   (sponge.ent, workspot_anim.ent) don't have these. The Bombus drone IS a
   complex vehicle entity with effect mappings, so this should actually work.

   Install: Copy this folder to:
     bin/x64/plugins/cyber_engine_tweaks/mods/fx_tester2/

   Bind hotkeys in: Settings > Key Bindings > FxTester2

   Hotkeys:
     FxTester2 Spawn/Despawn Drone  -- spawns/despawns the drone (toggle)
     FxTester2 Play Effect          -- plays current effect on the drone
     FxTester2 Stop Effect          -- stops current effect on the drone
     FxTester2 Cycle Effect         -- cycle to next effect in the list
     FxTester2 Dump Components      -- diagnostic: dump drone's components to console

   CET-only. No REDscript or RED4ext required.
]]

local MOD_NAME = "FxTester2"

--============================================================================
-- CONFIGURATION
--============================================================================
local Config = {
    spawnDistance  = 3.0,    -- meters in front of player for drone spawn
    effectDuration  = 5.0,   -- seconds before auto-stopping effect
    currentEffect   = 1,     -- index into EffectList (cycle with hotkey)
    autoStop        = true,  -- auto-stop effect after effectDuration
    debug           = true,  -- print debug info to CET console
}

--============================================================================
-- EFFECT LIST
--============================================================================
-- CName effect tags looked up in the entity's FxResourceMapperComponent.
-- The Bombus drone is a vehicle entity; vehicle-relevant tags are listed first,
-- then device/generic tags, then player-only tags as fallback.
--
-- Not all of these will work — the drone only has mappings for tags defined
-- in its entity template. Use "Dump Components" hotkey + trial-and-error to
-- find which tags actually fire visible effects.

local EffectList = {
    -- Vehicle / damage / destruction tags (most likely to work on a drone)
    { name = "explosion",                 label = "Explosion",              onPlayer = false },
    { name = "destroyed",                 label = "Destroyed",              onPlayer = false },
    { name = "damage",                     label = "Damage",                 onPlayer = false },
    { name = "damage_smoke",               label = "Damage Smoke",           onPlayer = false },
    { name = "destruction",               label = "Destruction",            onPlayer = false },
    { name = "destruction_small",          label = "Destruction Small",      onPlayer = false },
    { name = "destruction_big",            label = "Destruction Big",        onPlayer = false },
    { name = "engine_fire",                label = "Engine Fire",             onPlayer = false },
    { name = "engine_smoke",               label = "Engine Smoke",           onPlayer = false },
    { name = "fire",                       label = "Fire",                   onPlayer = false },
    { name = "smoke",                      label = "Smoke",                  onPlayer = false },
    { name = "thrust",                     label = "Thrust",                 onPlayer = false },
    { name = "hover",                      label = "Hover",                  onPlayer = false },
    { name = "afterburner",                label = "Afterburner",            onPlayer = false },
    { name = "exhaust",                    label = "Exhaust",                onPlayer = false },
    { name = "turn_signal",                label = "Turn Signal",            onPlayer = false },
    { name = "headlight",                  label = "Headlight",              onPlayer = false },
    { name = "siren",                      label = "Siren",                  onPlayer = false },
    { name = "muzzle_flash",              label = "Muzzle Flash",           onPlayer = false },
    { name = "weapon_fire",                label = "Weapon Fire",             onPlayer = false },

    -- Device / generic tags
    { name = "broken",                     label = "Broken",                onPlayer = false },
    { name = "active",                     label = "Active",                 onPlayer = false },
    { name = "glitchEffect",              label = "Glitch Effect",          onPlayer = false },
    { name = "frameEffect",               label = "Frame Effect",           onPlayer = false },
    { name = "light_on_destr",            label = "Light On Destroyed",     onPlayer = false },
    { name = "e_vfx_flare_smoke_red_1",    label = "Flare Smoke Red 1",     onPlayer = false },
    { name = "e_vfx_flare_smoke_red_2",    label = "Flare Smoke Red 2",     onPlayer = false },
    { name = "fx_empty",                   label = "FX Empty",               onPlayer = false },
    { name = "fx_checked",                 label = "FX Checked",             onPlayer = false },
    { name = "fx_candles",                label = "Candles",               onPlayer = false },
    { name = "mine_laser_green",            label = "Mine Laser Green",       onPlayer = false },
    { name = "mine_laser_red",             label = "Mine Laser Red",          onPlayer = false },

    -- Player-only tags (fallback — only work on PlayerPuppet)
    { name = "blackwall_use_force",        label = "Blackwall Force",        onPlayer = true  },
    { name = "charge",                    label = "Charge",                 onPlayer = true  },
    { name = "dash",                      label = "Dash",                   onPlayer = true  },
    { name = "cloak_on",                  label = "Cloak On",               onPlayer = true  },
    { name = "cloak_off",                 label = "Cloak Off",              onPlayer = true  },
    { name = "cyberware_explosion",        label = "Cyberware Explosion",    onPlayer = true  },
}

--============================================================================
-- DRONE ENTITY PATHS (verified in customentity4)
--============================================================================
local DRONE_ENT_PATHS = {
    "base\\vehicles\\special\\av_zetatech_bombus__basic.ent",
    "ep1\\vehicles\\special\\av_militech_wyvern__basic_01_ep1.ent",
    "ep1\\vehicles\\special\\av_zetatech_octant__basic_01_ep1.ent",
}

local MAX_TICKS = 300

--============================================================================
-- STATE
--============================================================================
local state = {
    -- Drone
    entity    = nil,
    entityID  = nil,
    pendingSpawn = false,
    spawnMethod = "",
    spawnPath    = "",
    tickCount   = 0,

    -- Active effects
    activeEffects = {},  -- { { entity = ref, effectName = string, timer = float } }

    -- Window
    windowVisible = false,

    -- Messages
    messages = {},
}

local MAX_MESSAGES = 12

--============================================================================
-- LOGGING
--============================================================================

local function dprint(msg)
    if Config.debug then
        print(string.format("[%s] %s", MOD_NAME, msg))
    end
end

local function Log(msg)
    print(string.format("[%s] %s", MOD_NAME, msg))
end

local function AddMessage(msg)
    local ts = os.date("%H:%M:%S")
    local entry = string.format("[%s] %s", ts, msg)
    table.insert(state.messages, entry)
    if #state.messages > MAX_MESSAGES then
        table.remove(state.messages, 1)
    end
    Log(msg)
end

--============================================================================
-- POSITION HELPERS (from customentity4)
--============================================================================

local function GetDirection(angle)
    return Vector4.RotateAxis(Game.GetPlayer():GetWorldForward(), Vector4.new(0, 0, 1, 0), angle / 180.0 * Pi())
end

local function GetSpawnPosition(distance, angle)
    local pos = Game.GetPlayer():GetWorldPosition()
    local heading = GetDirection(angle)
    return Vector4.new(pos.x + heading.x * distance, pos.y + heading.y * distance, pos.z + heading.z, pos.w + heading.w)
end

--============================================================================
-- DRONE SPAWNING (from customentity4 — proven working)
--============================================================================

local function TrySpawnWithEntitySpawner()
    local player = Game.GetPlayer()
    if not player then return false end

    local spawnTransform = player:GetWorldTransform()
    local pos = GetSpawnPosition(Config.spawnDistance, 0.0)
    spawnTransform:SetPosition(pos)

    for i, entPath in ipairs(DRONE_ENT_PATHS) do
        Log(string.format("Trying [%d/%d]: %s", i, #DRONE_ENT_PATHS, entPath))
        local ok, entityID = pcall(function()
            return exEntitySpawner.Spawn(entPath, spawnTransform, "")
        end)
        if ok and entityID then
            state.entityID = entityID
            state.pendingSpawn = true
            state.spawnMethod = "exEntitySpawner"
            state.spawnPath = entPath
            Log(string.format("Spawn SUCCESS: entity ID: %s (pending...)", tostring(entityID)))
            return true
        end
    end

    Log("All .ent paths failed")
    return false
end

local function DespawnDrone()
    Log(string.rep("=", 50))
    Log("DESPAWN DRONE")

    -- Stop all active effects first
    for _, active in ipairs(state.activeEffects) do
        if active.entity and IsDefined(active.entity) then
            pcall(function() GameObjectEffectHelper.StopEffectEvent(active.entity, active.effectName) end)
            pcall(function() GameObjectEffectHelper.BreakEffectLoopEvent(active.entity, active.effectName) end)
        end
    end
    state.activeEffects = {}

    if state.entity then
        pcall(function() exEntitySpawner.Despawn(state.entity) end)
        state.entity = nil
        state.entityID = nil
        state.pendingSpawn = false
        Log("Drone despawned")
    else
        Log("No drone to despawn")
    end

    state.windowVisible = false
end

local function SpawnDrone()
    Log(string.rep("=", 50))
    Log("SPAWN DRONE")

    if state.entity then
        DespawnDrone()
        return
    end

    if TrySpawnWithEntitySpawner() then
        Log("Drone spawning via exEntitySpawner...")
    else
        Log("ERROR: All spawn methods failed")
        return
    end

    state.windowVisible = true
    AddMessage("Drone spawning...")
end

--============================================================================
-- EFFECT APPLICATION (from fx_tester — adapted for drone)
--============================================================================

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

local function StopEffectOnEntity(entity, effectName)
    if not entity or not IsDefined(entity) then return end

    pcall(function() GameObjectEffectHelper.StopEffectEvent(entity, effectName) end)
    pcall(function() GameObjectEffectHelper.BreakEffectLoopEvent(entity, effectName) end)
end

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

--============================================================================
-- PLAY / STOP / CYCLE
--============================================================================

local function PlayEffect()
    if not state.entity or not IsDefined(state.entity) then
        AddMessage("No drone spawned — spawn drone first")
        return
    end

    local effect = EffectList[Config.currentEffect]
    if not effect then
        AddMessage("Invalid effect index")
        return
    end

    Log(string.format("--- Playing Effect: '%s' (%s) ---", effect.name, effect.label))

    local target = state.entity

    -- For player-only effects, use the player instead of the drone
    if effect.onPlayer then
        target = Game.GetPlayer()
        if not target then
            AddMessage("Could not get player entity")
            return
        end
        dprint("  Using player as target (player-only effect)")
    end

    -- Try GameObjectEffectHelper first
    local success = PlayEffectOnEntity(target, effect.name)

    -- Fallback: entSpawnEffectEvent
    if not success then
        dprint("  StartEffectEvent failed, trying entSpawnEffectEvent...")
        success = QueueSpawnEffectEvent(target, effect.name)
    end

    if success then
        table.insert(state.activeEffects, {
            entity = target,
            effectName = effect.name,
            timer = Config.autoStop and Config.effectDuration or -1,
        })
        AddMessage(string.format("Effect '%s' started%s", effect.label,
            Config.autoStop and string.format(" (auto-stop %.0fs)", Config.effectDuration) or ""))
    else
        AddMessage(string.format("Failed to play '%s' — tag not mapped on drone", effect.label))
    end
end

local function StopCurrentEffect()
    if #state.activeEffects == 0 then
        AddMessage("No active effects to stop")
        return
    end

    for i = #state.activeEffects, 1, -1 do
        local active = state.activeEffects[i]
        StopEffectOnEntity(active.entity, active.effectName)
        dprint(string.format("  Stopped effect '%s'", active.effectName))
    end
    state.activeEffects = {}
    AddMessage("All effects stopped")
end

local function CycleEffect()
    Config.currentEffect = (Config.currentEffect % #EffectList) + 1
    local effect = EffectList[Config.currentEffect]
    local tag = effect.onPlayer and " [player-only]" or ""
    AddMessage(string.format("Effect: %s (%d/%d)%s", effect.label, Config.currentEffect, #EffectList, tag))
end

--============================================================================
-- DIAGNOSTIC: DUMP COMPONENTS
--============================================================================

local function DumpComponents()
    if not state.entity or not IsDefined(state.entity) then
        AddMessage("No drone spawned — spawn drone first")
        return
    end

    Log(string.rep("=", 50))
    Log("DRONE COMPONENT DUMP")

    local components = nil
    pcall(function() components = state.entity:GetComponents() end)
    if not components then
        AddMessage("Could not get components")
        return
    end

    local fxFound = false
    for _, comp in ipairs(components) do
        local className = ""
        pcall(function() className = NameToString(comp:GetClassName()) end)
        Log(string.format("  Component: %s", className))

        -- Highlight FxResourceMapperComponent
        if string.find(className, "FxResource") or string.find(className, "Effect") then
            fxFound = true
            Log(string.format("  *** FX component: %s ***", className))

            -- Try to dump its properties
            pcall(function()
                -- Try getting the effect map if exposed
                if comp.GetFxResourceMap then
                    local fxMap = comp:GetFxResourceMap()
                    if fxMap then
                        Log(string.format("    FxMap entries: %d", #fxMap))
                        for _, entry in ipairs(fxMap) do
                            local tag = ""
                            pcall(function() tag = NameToString(entry.tag) end)
                            Log(string.format("      tag: '%s'", tag))
                        end
                    end
                end
            end)
        end
    end

    if not fxFound then
        Log("  No FxResourceMapper or Effect components found")
    end

    AddMessage(string.format("Components dumped (%d) — check CET console", #components))
end

--============================================================================
-- IMGUI WINDOW
--============================================================================

local function DrawWindow()
    if not state.windowVisible then return end

    ImGui.SetNextWindowPos(10, 10, ImGuiCond.FirstUseEver)
    ImGui.SetNextWindowSize(460, 440, ImGuiCond.FirstUseEver)

    local visible, open = ImGui.Begin("FxTester2##fx2", true, ImGuiWindowFlags.AlwaysAutoResize)
    if not visible then
        ImGui.End()
        return
    end

    -- Drone status
    ImGui.Text("Drone:")
    ImGui.SameLine()
    if state.entity then
        ImGui.TextColored(0, 1, 0, 1, "Spawned")
        ImGui.Text(string.format("  Path: %s", state.spawnPath))
    elseif state.pendingSpawn then
        ImGui.TextColored(1, 0.5, 0, 1, "Pending...")
    else
        ImGui.TextColored(0.5, 0.5, 0.5, 1, "Not spawned")
    end

    ImGui.Separator()

    -- Current effect
    local effect = EffectList[Config.currentEffect]
    if effect then
        ImGui.Text("Current Effect:")
        ImGui.Text(string.format("  [%d/%d] %s", Config.currentEffect, #EffectList, effect.label))
        ImGui.Text(string.format("  Tag:  %s", effect.name))
        if effect.onPlayer then
            ImGui.TextColored(1, 0.5, 0, 1, "  [player-only — applies to player, not drone]")
        end
    end

    ImGui.Separator()

    -- Active effects
    if #state.activeEffects > 0 then
        ImGui.Text(string.format("Active Effects (%d):", #state.activeEffects))
        for i, active in ipairs(state.activeEffects) do
            local timeLeft = active.timer > 0 and string.format(" (%.1fs)", active.timer) or ""
            ImGui.TextColored(0, 1, 0, 1, string.format("  %d. %s%s", i, active.effectName, timeLeft))
        end
    else
        ImGui.TextColored(0.5, 0.5, 0.5, 1, "No active effects")
    end

    ImGui.Separator()

    -- Config
    ImGui.Text("Config:")
    ImGui.Text(string.format("  Spawn dist:   %.1fm", Config.spawnDistance))
    ImGui.Text(string.format("  Duration:     %.1fs", Config.effectDuration))
    ImGui.Text(string.format("  Auto-stop:    %s", Config.autoStop and "ON" or "OFF"))
    ImGui.Text(string.format("  Debug:        %s", Config.debug and "ON" or "OFF"))

    ImGui.Separator()

    -- Messages
    if #state.messages > 0 then
        ImGui.Text("Messages:")
        ImGui.BeginChild("Fx2Messages", 440, 100, true)
        for _, msg in ipairs(state.messages) do
            local r, g, b = 0.8, 0.8, 0.8
            if msg:match("%[OK%]") or msg:match("started") then r, g, b = 0, 1, 0
            elseif msg:match("%[FAIL%]") or msg:match("Failed") or msg:match("ERROR") then r, g, b = 1, 0.3, 0.3
            elseif msg:match("No drone") or msg:match("No active") then r, g, b = 1, 0.5, 0
            end
            ImGui.TextColored(r, g, b, 1, msg)
        end
        ImGui.EndChild()
    end

    ImGui.Separator()
    ImGui.TextDisabled("Hotkeys: Spawn/Despawn | Play | Stop | Cycle | Dump")
    ImGui.End()
end

--============================================================================
-- SAFE CALL HELPER
--============================================================================

local function SafeCall(name, fn)
    local ok, err = pcall(fn)
    if not ok then
        Log(string.format("ERROR in %s: %s", name, tostring(err)))
        AddMessage(string.format("ERROR in %s: %s", name, tostring(err)))
    end
end

--============================================================================
-- HOTKEYS  (MUST be at file root level — CET scans for these before onInit)
--============================================================================

registerHotkey("FxTester2SpawnDespawn", "Fx2: Spawn/Despawn Drone", function()
    SafeCall("SpawnDrone", SpawnDrone)
end)

registerHotkey("FxTester2Play", "Fx2: Play Effect", function()
    SafeCall("PlayEffect", PlayEffect)
end)

registerHotkey("FxTester2Stop", "Fx2: Stop Effect", function()
    SafeCall("StopCurrentEffect", StopCurrentEffect)
end)

registerHotkey("FxTester2Cycle", "Fx2: Cycle Effect", function()
    SafeCall("CycleEffect", CycleEffect)
end)

registerHotkey("FxTester2Dump", "Fx2: Dump Components", function()
    SafeCall("DumpComponents", DumpComponents)
end)

--============================================================================
-- EVENTS
--============================================================================

registerForEvent("onInit", function()
    Log("Initialized — FX Tester 2 (drone + effects)")
    Log(string.format("Effects: %d  |  Spawn dist: %.1fm  |  Duration: %.1fs", #EffectList, Config.spawnDistance, Config.effectDuration))
    Log(string.format("Current effect: %s (%d/%d)", EffectList[Config.currentEffect].label, Config.currentEffect, #EffectList))
    Log("Bind keys in: Settings > Key Bindings > FxTester2")
    Log("")
    Log("Usage:")
    Log("  1. Spawn drone (hotkey)")
    Log("  2. Play effect (hotkey) — applies current effect to the drone")
    Log("  3. Cycle effect (hotkey) — switch to next effect")
    Log("  4. Dump components (hotkey) — diagnostic: see what FX components the drone has")
    Log("  5. Despawn drone (same spawn hotkey)")
end)

registerForEvent("onUpdate", function(delta)
    -- Poll for pending spawn completion (from customentity4)
    if state.pendingSpawn and state.entityID then
        state.tickCount = state.tickCount + 1
        local ok, entity = pcall(function()
            return Game.FindEntityByID(state.entityID)
        end)
        if ok and entity then
            state.entity = entity
            state.pendingSpawn = false
            Log(string.format("DRONE SPAWNED! Tick: %d, Path: %s", state.tickCount, state.spawnPath))
            AddMessage("Drone spawned — ready for effects")
        elseif state.tickCount > MAX_TICKS then
            Log(string.format("SPAWN TIMEOUT: Entity not found after %d ticks", state.tickCount))
            AddMessage("SPAWN TIMEOUT — drone not found")
            state.pendingSpawn = false
        end
    end

    -- Process active effect timers
    for i = #state.activeEffects, 1, -1 do
        local active = state.activeEffects[i]
        if active.timer > 0 then
            active.timer = active.timer - delta
            if active.timer <= 0 then
                StopEffectOnEntity(active.entity, active.effectName)
                dprint(string.format("  Auto-stopped effect '%s'", active.effectName))
                table.remove(state.activeEffects, i)
            end
        end
    end
end)

registerForEvent("onDraw", function()
    DrawWindow()
end)

registerForEvent("onShutdown", function()
    -- Stop effects and despawn
    for _, active in ipairs(state.activeEffects) do
        StopEffectOnEntity(active.entity, active.effectName)
    end
    state.activeEffects = {}
    if state.entity then
        DespawnDrone()
    end
    Log("Stopped")
end)
