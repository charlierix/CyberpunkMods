# Custom Entity Tester 1 (CE1)

## Shell Entity Creation + REDscript Bridge Validation

### Purpose

This tester validates **Phase 1** of the [Shell Entity Proposal](../../docs/device%20hacks/proposal%20-%20shell%20entity%20for%20device%20hacking.md):

> Can a REDscript bridge that calls `SetUp(ps)` + native pipeline execution produce visible device hack effects?

### What It Tests

1. **Entity Creation** — Spawns an entity (AV vehicle) near the player using `exEntitySpawner.Spawn` with multiple candidate entity paths
2. **Entity Validation** — Polls `Game.FindEntityByID` in `onUpdate` until the async entity is ready, then checks entity ID, position, and validity
3. **Bridge Connection** — Verifies the `OrbHackingBridge` ScriptableSystem is accessible from CET via `Game.GetScriptableSystem()`
4. **Ping Quickhack** — Executes a ping quickhack on a targeted device via the bridge, using the shell entity (or player) as executor

### Architecture

```
CET Lua (init.lua)
    |
    +--> Spawn entity (exEntitySpawner.Spawn with path)
    +--> Poll Game.FindEntityByID until entity ready
    +--> Target device (player:GetLookAtObject)
    +--> Call bridge:ExecuteDeviceActionByName(device, "PingDevice", executor)
         |
         v
    REDscript (OrbHackingBridge.reds)
         |
         +--> ps:GetAction(actionRecordID)  -- creates initialized action
         +--> action:SetUp(ps)                -- THE CRITICAL STEP (not exposed to CET)
         +--> action:SetExecutor(entity)     -- shell entity or player
         +--> action:SetCanSkipPayCost(true)  -- bypass RAM cost
         +--> IsPossible -> ResolveAction -> StartAction -> CompleteAction
         |
         v
    Device PS (ScriptableDeviceComponentPS)
         |
         +--> On* handler fires
         +--> DeviceOperations execute
         +--> VISIBLE EFFECT
```

### Files

| File | Language | Install Path |
|---|---|---|
| `cet/init.lua` | CET Lua | `bin/x64/plugins/cyber_engine_tweaks/mods/customentity1/init.lua` |
| `redscript/OrbHackingBridge.reds` | REDscript | `r6/scripts/OrbHackingBridge.reds` |
| `red4ext/README.md` | (placeholder) | Not needed for v1 |

See [deploy.md](deploy.md) for full deployment instructions.

### Hotkeys (4 total)

| # | Label | Action |
|---|---|---|
| 1 | `CE1: Spawn/Despawn Shell Entity` | Spawn or despawn the shell entity near player |
| 2 | `CE1: Run Ping Quickhack Test` | Execute ping quickhack on targeted device via bridge |
| 3 | `CE1: Toggle ImGui Window` | Show/hide the companion ImGui window |
| 4 | `CE1: Reset State` | Clear test results and state |

Bind these in **Settings > Key Bindings** after launching the game.

### ImGui Window

The companion ImGui window shows:

- **Bridge status** — Loaded / not loaded
- **Entity status** — Spawned / Pending / Not spawned, entity ID, validity, path
- **Target device** — Current targeted device class name
- **Test results** — Test count, last result, color-coded history table
- **Log preview** — Last 20 log lines

### Logging

All actions are logged to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/customentity1/log.txt
```

The log file is the primary tool for post-hoc analysis. Each entry is timestamped.

### Entity Details

**Current entity:** AV vehicle — the tester tries multiple candidate paths from FlightControl_cet comments:
- `base\vehicles\av\_ieee\ieee_03_km.ent`
- `base\vehicles\av\_ieee\ieee_04_km.ent`
- `base\vehicles\av\_ieee\ieee_05_km.ent`
- `base\vehicles\av\_ieee\ieee_06_km.ent`
- `base\vehicles\av\_ieee\ieee_07_km.ent`
- `base\vehicles\av\_ieee\ieee_08_km.ent`

The spawn function iterates through these paths and uses the first one that returns a non-nil EntityID. If all paths fail with `exEntitySpawner.Spawn`, it falls back to `WorldFunctionalTests.SpawnEntity`.

> **Note:** `exEntitySpawner.Spawn` returns `nil` silently when an entity path is not found by the engine. The previous version used only one path (`ieee_03_km.ent`) which returned nil. The fix adds multiple candidate paths and a fallback spawn API.

**Position:** Spawned 2m above and 2m in front of the player using `player:GetWorldPosition()` modified directly (`pos.z += 2.0`, `pos.y += 2.0`).

**Changing the entity:** Edit `ENTITY_PATHS` at the top of `cet/init.lua` to add or modify entity paths.

### Spawn API

The tester uses two CET spawn APIs:

1. **Primary:** `exEntitySpawner.Spawn(entityPath, transform, appearance)` — returns EntityID or nil
2. **Fallback:** `WorldFunctionalTests.SpawnEntity(entityPath, transform, appearance)` — returns EntityID or nil

Both APIs are **asynchronous** — they return an EntityID, not an entity object. The entity is created in a subsequent frame. The `onUpdate` handler polls `Game.FindEntityByID(entityID)` until the entity is ready.

### Expected Results

| Scenario | Expected Result |
|---|---|
| Bridge loaded | `SUCCESS` — OrbHackingBridge found via GetScriptableSystem |
| Entity spawned | `SUCCESS` — Entity has valid EntityID (at least one path works) |
| Ping with player executor | `SUCCESS` — Device receives ping (visible in game) |
| Ping with shell entity executor | `SUCCESS` or `NOT_POSSIBLE` — Depends on device validation |
| Bridge not loaded | `NO_BRIDGE` — REDscript mod not installed |
| No target device | `NO_TARGET` — Player not looking at a hackable device |
| All entity paths fail | `ERROR` — Check entity paths exist in your game version |

### Key Unknowns This Tester Addresses

From the proposal Risks and Unknowns:

1. **Does `SetUp(ps)` fix action execution?** — This is the primary question
2. **Does device validation accept non-player executor?** — Tested with shell entity
3. **Does `ps:GetAction(recordID)` return initialized actions?** — Tested via bridge
4. **Is `exEntitySpawner.Spawn` usable from CET?** — Tested directly with multiple paths

### References

- [Proposal: Shell Entity for Device Hacking](../../docs/device%20hacks/proposal%20-%20shell%20entity%20for%20device%20hacking.md)
- [Class Hierarchy: Device Hack Perspective](../../docs/device%20hacks/class%20hierarchy%20-%20device%20hack%20perspective.md)
- Previous testers: `statuseffect_device_tester5/` (ImGui window pattern)
