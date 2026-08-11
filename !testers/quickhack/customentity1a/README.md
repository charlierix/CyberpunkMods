# Custom Entity Tester 1a (CE1a)

## Minimal Drone Spawn — CET Only

### Purpose

Spawn a drone near the player using the simplest possible CET mod. No redscript, no RED4ext, no ImGui, no bridge — just spawn and despawn.

### Why customentity1a Exists

`customentity1` failed because all entity paths returned `nil` — the `base\_ieee\ieee_XX_km.ent` paths don't exist in the game archives. This tester uses **verified valid paths** from [Cyberscript Core](../../sources/mods/lua/Cyberscript%20Core-6475-5-1-4-1747724577/) and [AMM (Appearance Menu Mod)](../../sources/mods/lua,%20arch/Appearance%20Menu%20Mod-790-2-12-5-1749642728/).

### What It Does

1. Press **Spawn Drone** hotkey → tries two methods:
   - **Method A**: `exEntitySpawner.Spawn()` with valid `.ent` file paths
   - **Method B**: `DynamicEntitySpec` + `Game.GetDynamicEntitySystem():CreateEntity()` with TweakDB character records
2. Polls `Game.FindEntityByID()` in `onUpdate` until the async entity appears
3. Logs the result (method, path, position, ticks waited)
4. Press **Despawn Drone** hotkey → despawns the entity

### Files

| File | Install Path |
|---|---|
| `cet/init.lua` | `bin/x64/plugins/cyber_engine_tweaks/mods/customentity1a/init.lua` |

### Hotkeys (2 total)

| # | Label | Action |
|---|---|---|
| 1 | `CE1a: Spawn Drone` | Spawn a drone near the player |
| 2 | `CE1a: Despawn Drone` | Despawn the spawned drone |

Bind these in **Settings > Key Bindings** after launching the game.

### Drone Entity Paths (Method A)

Valid `.ent` paths from Cyberscript Core:

| # | Path | Source |
|---|---|---|
| 1 | `base\vehicles\special\av_zetatech_bombus__basic.ent` | Aldecaldos Bombus drone |
| 2 | `ep1\vehicles\special\av_militech_wyvern__basic_01_ep1.ent` | Militech Wyvern drone (Phantom Liberty) |
| 3 | `ep1\vehicles\special\av_zetatech_octant__basic_01_ep1.ent` | Zetatech Octant drone (Phantom Liberty) |

### Drone TweakDB Records (Method B)

Valid character records from Cyberscript Core (used by AMM's SpawnNPC):

| # | Record | Source |
|---|---|---|
| 1 | `Character.aldecaldos_base_drone_bombus` | Aldecaldos Bombus drone |
| 2 | `Character.aldecaldos_base_drone_wyvern` | Aldecaldos Wyvern drone |
| 3 | `Character.arasaka_base_drone_octant` | Arasaka Octant drone |
| 4 | `Character.arasaka_base_drone_wyvern` | Arasaka Wyvern drone |

### Spawn API Reference

This tester uses two spawn patterns studied from AMM and other mods:

#### Method A: exEntitySpawner.Spawn (file path)
```lua
local entityID = exEntitySpawner.Spawn(entPath, spawnTransform, '')
-- Returns EntityID (async) or nil if path not found
```

#### Method B: DynamicEntitySpec + CreateEntity (TweakDB record)
```lua
local spec = DynamicEntitySpec.new()
spec.recordID = TweakDBID.new("Character.aldecaldos_base_drone_bombus")
spec.position = playerPos + heading * 3.0
spec.orientation = EulerAngles.ToQuat(Vector4.ToRotation(heading))
spec.tags = { "CE1A_DRONE" }
spec.spawnInView = true
local entityID = Game.GetDynamicEntitySystem():CreateEntity(spec)
```

Both APIs are **asynchronous** — they return an EntityID, not an entity object. The `onUpdate` handler polls `Game.FindEntityByID(entityID)` until the entity is ready.

### Logging

All actions logged to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/customentity1a/log.txt
```

### Expected Results

| Scenario | Expected Result |
|---|---|
| Method A succeeds | Drone spawns via `.ent` path, logs position |
| Method A fails, Method B succeeds | Drone spawns via TweakDB record, logs position |
| Both fail | ERROR logged — check game version / DLC |
| Phantom Liberty not installed | `ep1\` paths/records may fail — Method A path #1 (base game) should still work |

### Differences from customentity1

| Aspect | customentity1 | customentity1a |
|---|---|---|
| Entity paths | `base\_ieee\ieee_XX_km.ent` (invalid) | `base\vehicles\special\av_zetatech_bombus__basic.ent` (valid) |
| Spawn methods | exEntitySpawner + WorldFunctionalTests fallback | exEntitySpawner + DynamicEntitySpec/CreateEntity |
| Redscript | Required (OrbHackingBridge) | Not needed |
| ImGui window | Yes (4 hotkeys) | No (2 hotkeys only) |
| Complexity | 554 lines | ~200 lines |
| Bridge | Required | Not needed |
