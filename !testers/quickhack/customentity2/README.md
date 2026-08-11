# Custom Entity Tester 2 (CE2)

## Red4ext Executor Validation Hook for Drone Quickhack

### Purpose

Third attempt at customentity. Spawns a drone near the player using proven entity paths, then executes a ping quickhack on a targeted device using the drone as executor. A **Red4ext C++ plugin** hooks `IsPossible()` to bypass executor validation, allowing the spawned drone to be accepted by the device action system.

### Lineage

| Tester | Result | Key Lesson |
|---|---|---|
| `customentity1` | Failed | Invalid entity paths; OrbHackingBridge compilation issue |
| `customentity1a` | Success | Valid paths; exEntitySpawner works; DynamicEntitySpec as fallback |
| `customentity1b` | Testing | Redscript bridge compiles as ScriptableSystem; drone spawns but device action system rejects drone as executor |
| `customentity2` | Testing | Red4ext hooks IsPossible() to bypass executor validation for CE2_DRONE-tagged drones |

### The Problem

The device action system's `IsPossible()` check rejects spawned drones as executors for quickhack actions. Drones are valid GameObjects (`Drone -> ScriptablePuppet -> ScriptableEntity -> GameObject`), but the check likely fails because drones lack player-specific clearance or capabilities.

### The Solution

A Red4ext C++ plugin hooks `BaseScriptableAction::IsPossible` to return `true` when the executor is our `CE2_DRONE`-tagged drone, bypassing the validation gate.

### Architecture

```
CET Lua (init.lua)
    |
    +--> Spawn drone with CE2_DRONE tag (Method A or B)
    +--> Poll Game.FindEntityByID until entity ready
    +--> Target device (player:GetLookAtObject)
    +--> Call bridge:ExecuteDeviceActionByName(device, "PingDevice", drone)
         |
         v
    REDscript (OrbHackingBridge.reds)
         |
         +--> deviceObj.GetDevicePS() as ScriptableDeviceComponentPS
         +--> ps.GenerateContext(Remote, deviceObj.GetInteractionClearance(), drone, entityID)
         +--> ps.GetQuickHackActions(actions, context)
         +--> Find action by name ("PingDevice")
         +--> action.SetUp(ps)
         +--> action.SetExecutor(drone)
         +--> action.IsPossible(drone)  <-- HOOKED BY RED4EXT
         |       |
         |       +-- CE2_DRONE tag? --> return true (bypass)
         |       +-- No tag?      --> call original IsPossible
         |
         +--> action.CompleteAction(game)  -- executes the hack
         |
         v
    Device PS -- On* handler fires -- VISIBLE EFFECT
```

### Files

| File | Language | Install Path |
|---|---|---|
| `cet/init.lua` | CET Lua | `bin/x64/plugins/cyber_engine_tweaks/mods/customentity2/init.lua` |
| `redscript/OrbHackingBridge.reds` | REDscript | `r6/scripts/OrbHackingBridge.reds` |
| `red4ext/src/Main.cpp` | C++ | Build to `OrbHackingBridge.dll` |
| `red4ext/src/OrbHackingBridge.cpp` | C++ | Build to `OrbHackingBridge.dll` |
| `red4ext/src/OrbHackingBridge.hpp` | C++ | Build to `OrbHackingBridge.dll` |
| `red4ext/CMakeLists.txt` | CMake | Build system |
| `red4ext/red4ext.manifest.json` | JSON | `bin/x64/plugins/red4ext/plugins/OrbHackingBridge/` |

### Hotkeys (2 total)

| # | Label | Action |
|---|---|---|
| 1 | `CE2: Spawn/Despawn Drone` | Spawn or despawn the drone near player |
| 2 | `CE2: Run Ping Quickhack Test` | Execute ping quickhack on targeted device using drone as executor |

### Drone Entity Paths (Method A)

| # | Path | Source |
|---|---|---|
| 1 | `base\vehicles\special\av_zetatech_bombus__basic.ent` | Aldecaldos Bombus drone |
| 2 | `ep1\vehicles\special\av_militech_wyvern__basic_01_ep1.ent` | Militech Wyvern drone (Phantom Liberty) |
| 3 | `ep1\vehicles\special\av_zetatech_octant__basic_01_ep1.ent` | Zetatech Octant drone (Phantom Liberty) |

### Drone TweakDB Records (Method B)

| # | Record | Source |
|---|---|---|
| 1 | `Character.aldecaldos_base_drone_bombus` | Aldecaldos Bombus drone |
| 2 | `Character.aldecaldos_base_drone_wyvern` | Aldecaldos Wyvern drone |
| 3 | `Character.arasaka_base_drone_octant` | Arasaka Octant drone |
| 4 | `Character.arasaka_base_drone_wyvern` | Arasaka Wyvern drone |

> Method B tags the drone with `CE2_DRONE` which the Red4ext hook uses to identify our drone.

### Red4ext Plugin Build

```bash
cd testers/quickhack/customentity2/red4ext
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release
```

Output: `OrbHackingBridge.dll`

### Expected Results

| Scenario | Expected Result |
|---|---|
| Drone spawns | `DRONE SPAWNED SUCCESSFULLY!` with position and tick count |
| Bridge loaded | `Bridge loaded: OrbHackingBridge` in CET log |
| Red4ext plugin loaded | `[OrbHackingBridge] Plugin loaded -- executor validation hook` in RED4ext log |
| IsPossible hook active | `[OrbHackingBridge] IsPossible: bypassing validation for CE2_DRONE executor` |
| Ping with drone executor | `SUCCESS` -- Device receives ping (visible in game) |
| Bridge not loaded | `WARNING: OrbHackingBridge not found` -- Check Redscript installation |
| No target device | `NO_TARGET: Player not looking at a hackable device` |

### Differences from customentity1b

| Aspect | customentity1b | customentity2 |
|---|---|---|
| Red4ext plugin | None | Hooks IsPossible for CE2_DRONE-tagged drones |
| Executor validation | Fails -- drone rejected by IsPossible | Bypassed -- hook returns true for CE2_DRONE drones |
| CE2_DRONE tag | Not used | Set by CET when spawning via Method B |
| Build complexity | No build needed | CMake + C++ compiler required |
| Deployment | 2 files (Lua + Redscript) | 4 files (Lua + Redscript + DLL + manifest) |
| Hotkeys | 2 | 2 (same interface) |

### References

- [ANALYSIS.md](ANALYSIS.md) -- Why Red4ext is needed
- [deploy.md](deploy.md) -- Deployment instructions
- [red4ext/README.md](red4ext/README.md) -- Red4ext plugin details
- Previous testers: `customentity1/`, `customentity1a/`, `customentity1b/`
