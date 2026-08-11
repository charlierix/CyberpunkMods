# Custom Entity Tester 1b (CE1b)

## Shell Entity Spawn + REDscript Bridge Quickhack Test

### Purpose

Second attempt at `customentity1`, incorporating all lessons learned from `customentity1a`. Spawns a drone near the player using proven entity paths, then executes a ping quickhack on a targeted device via a REDscript bridge — using both the player and the spawned drone as executors.

### Lineage

| Tester | Result | Key Lesson |
|---|---|---|
| `customentity1` | Failed | Invalid entity paths (`base\_ieee\ieee_XX_km.ent` all returned nil); OrbHackingBridge compilation issue (`Device.GetInteractionClearance()` called as static) |
| `customentity1a` | Success | Valid paths (`base\vehicles\special\av_zetatech_bombus__basic.ent`); exEntitySpawner works on first try; DynamicEntitySpec as fallback; correct despawn API per spawn method |
| `customentity1b` | Testing | Merges 1a's proven spawning with 1's bridge/quickhack test; fixes bridge compilation issue |

### What It Does

1. Press **Spawn/Despawn Drone** hotkey — spawns a drone near the player:
   - **Method A**: `exEntitySpawner.Spawn()` with valid `.ent` file paths
   - **Method B**: `DynamicEntitySpec` + `Game.GetDynamicEntitySystem():CreateEntity()` with TweakDB character records
2. Polls `Game.FindEntityByID()` in `onUpdate` until the async entity appears
3. Press **Run Ping Quickhack Test** hotkey — executes a ping quickhack on the device the player is looking at:
   - Tries **player** as executor first (known good)
   - Then tries **drone** as executor (the shell entity test)
   - Logs all results
4. Press **Spawn/Despawn Drone** again — despawns the drone

### Files

| File | Language | Install Path |
|---|---|---|
| `init.lua` | CET Lua | `bin/x64/plugins/cyber_engine_tweaks/mods/customentity1b/init.lua` |
| `redscript/OrbHackingBridge.reds` | REDscript | `r6/scripts/OrbHackingBridge.reds` |

### Hotkeys (2 total)

| # | Label | Action |
|---|---|---|
| 1 | `CE1b: Spawn/Despawn Drone` | Spawn or despawn the drone near player |
| 2 | `CE1b: Run Ping Quickhack Test` | Execute ping quickhack on targeted device via bridge |

Bind these in **Settings > Key Bindings** after launching the game.

### Drone Entity Paths (Method A)

Verified valid paths from Cyberscript Core (proven in customentity1a):

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

### Bridge Fix (from customentity1)

The original `OrbHackingBridge.reds` had a compilation issue: `Device.GetInteractionClearance()` was called as if it were a static method, but it is an **instance method** on `Device`. The fix:

```reds
// WRONG (original customentity1):
let context: GetActionsContext = ps.GenerateContext(
  gamedeviceRequestType.Remote,
  Device.GetInteractionClearance(),  // static call, fails compilation
  ...
);

// FIXED (customentity1b):
let context: GetActionsContext = ps.GenerateContext(
  gamedeviceRequestType.Remote,
  deviceObj.GetInteractionClearance(),  // instance call on the device
  ...
);
```

### Architecture

```
CET Lua (init.lua)
    |
    +--> Spawn drone (exEntitySpawner.Spawn with valid .ent path)
    +--> Poll Game.FindEntityByID until entity ready
    +--> Target device (player:GetLookAtObject)
    +--> Call bridge:ExecuteDeviceActionByName(device, "PingDevice", executor)
         |
         v
    REDscript (OrbHackingBridge.reds)
         |
         +--> deviceObj.GetDevicePS() as ScriptableDeviceComponentPS
         +--> ps.GenerateContext(Remote, deviceObj.GetInteractionClearance(), executor, entityID)
         +--> ps.GetQuickHackActions(actions, context)
         +--> Find action by name in actions array
         +--> action:SetUp(ps)           -- THE CRITICAL STEP
         +--> action:SetExecutor(executor)
         +--> action:IsPossible(executor)
         +--> action:CompleteAction(game)
         |
         v
    Device PS (ScriptableDeviceComponentPS)
         |
         +--> On* handler fires
         +--> DeviceOperations execute
         +--> VISIBLE EFFECT
```

### Logging

All actions logged as print statements
They get automatically saved in `Cyberpunk 2077\bin\x64\plugins\cyber_engine_tweaks\scripting.log`

### Expected Results

| Scenario | Expected Result |
|---|---|
| Drone spawns | `DRONE SPAWNED SUCCESSFULLY!` with position and tick count |
| Bridge loaded | `Bridge loaded: OrbHackingBridge` in onInit |
| Ping with player executor | `SUCCESS` — Device receives ping (visible in game) |
| Ping with drone executor | `SUCCESS` or `NOT_POSSIBLE` — Depends on device validation |
| Bridge not loaded | `WARNING: OrbHackingBridge not found` — Check REDscript installation |
| No target device | `NO_TARGET: Player not looking at a hackable device` |

### Differences from customentity1 and customentity1a

| Aspect | customentity1 | customentity1a | customentity1b |
|---|---|---|---|
| Entity paths | `base\_ieee\ieee_XX_km.ent` (invalid) | `base\vehicles\special\av_zetatech_bombus__basic.ent` (valid) | Same as 1a (valid) |
| Spawn methods | exEntitySpawner + WorldFunctionalTests | exEntitySpawner + DynamicEntitySpec | Same as 1a |
| Redscript bridge | Required but broken | Not needed | Required, fixed |
| Quickhack test | Yes (ping) | No | Yes (ping) |
| ImGui window | Yes (4 hotkeys) | No (2 hotkeys) | No (2 hotkeys) |
| Bridge fix | N/A | N/A | `deviceObj.GetInteractionClearance()` instead of `Device.GetInteractionClearance()` |
| Complexity | 554 lines | ~302 lines | 414 lines |

### References

- [Proposal: Shell Entity for Device Hacking](../../../docs/device%20hacks/proposal%20-%20shell%20entity%20for%20device%20hacking.md)
- [Class Hierarchy: Device Hack Perspective](../../../docs/device%20hacks/class%20hierarchy%20-%20device%20hack%20perspective.md)
- Previous testers: `customentity1/`, `customentity1a/`
- Reference mod: CustomHackingSystem (HackingBridge.reds pattern)
