# OrbHackingBridge -- RED4ext Plugin

## Purpose

Hooks `BaseScriptableAction::IsPossible` to bypass executor validation for drones tagged with `CE2_DRONE`. This allows spawned drones to be accepted as valid executors for device quickhack actions.

## The Problem

The device action system's `IsPossible()` check rejects spawned drones as executors for quickhack actions, even though drones are valid GameObjects (`Drone -> ScriptablePuppet -> ScriptableEntity -> GameObject`). The check likely fails because drones lack player-specific clearance or capabilities.

## The Solution

Hook `IsPossible` to return `true` when the executor is our `CE2_DRONE`-tagged drone, bypassing the validation gate. For all other executors, call the original function normally.

## Architecture

```
CET Lua (init.lua)
    |
    +--> Spawn drone with CE2_DRONE tag
    +--> Call bridge:ExecuteDeviceActionByName(device, "PingDevice", drone)
         |
         v
    Redscript (OrbHackingBridge.reds)
         |
         +--> pipeline: GetDevicePS -> GenerateContext -> GetQuickHackActions
         +--> action.SetUp(ps) -> action.SetExecutor(drone)
         +--> action.IsPossible(drone)  <-- HOOKED BY RED4EXT
         |       |
         |       v
         |    Red4ext checks: does drone have CE2_DRONE tag?
         |       |
         |       +-- YES --> return true (bypass validation)
         |       +-- NO  --> call original IsPossible
         |
         +--> action.CompleteAction(game)  -- executes the hack
         |
         v
    Device receives ping -- VISIBLE EFFECT
```

## Files

| File | Purpose |
|---|---|
| `src/Main.cpp` | Plugin entry point, IsPossible hook, PluginListener lifecycle |
| `src/OrbHackingBridge.hpp` | Helper class declaration (tag checking, entity info) |
| `src/OrbHackingBridge.cpp` | Helper implementation (tag checking, diagnostics) |
| `CMakeLists.txt` | CMake build configuration |
| `red4ext.manifest.json` | Plugin manifest for RED4ext loader |

## Hook Details

| Hook | Target | Behavior |
|---|---|---|
| `IsPossible_Hook` | `BaseScriptableAction::IsPossible` | Returns `true` for CE2_DRONE-tagged executors, calls original for all others |

### How CE2_DRONE Tag Works

The CET Lua mod tags the spawned drone with `CE2_DRONE` when using DynamicEntitySpec (Method B):
```lua
spec.tags = { "CE2_DRONE" }
```

The Red4ext hook checks for this tag to identify our drone and bypass validation.

## Build Instructions

### Prerequisites

- CMake 3.15+
- C++20 compiler (MSVC for Windows DLL)
- RED4ext SDK headers

### Build Steps

```bash
mkdir build && cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release
```

Output: `OrbHackingBridge.dll`

## Deployment

Copy the built DLL and manifest to:
```
<game_root>/bin/x64/plugins/red4ext/plugins/OrbHackingBridge/
    OrbHackingBridge.dll
    red4ext.manifest.json
```

## Implementation Status

The hook registration requires the actual RED4ext SDK hook API to resolve and register the native function address for `BaseScriptableAction::IsPossible`. The code documents the hook pattern and logic but needs the actual SDK API calls to be functional.

Key TODOs:
- Implement `HasCE2DroneTag()` using RED4ext RTTI to check entity tags
- Register hook using actual RED4ext hook API in `OnReady()`
- Resolve native function address for `IsPossible` via RTTI system
