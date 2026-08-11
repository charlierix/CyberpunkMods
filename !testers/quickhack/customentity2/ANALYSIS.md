# Why Red4ext Is Needed -- Executor Validation Hook

## The Problem

The device action system's `IsPossible()` check rejects spawned drones as executors for quickhack actions. Even though drones are valid GameObjects (`Drone -> ScriptablePuppet -> ScriptableEntity -> GameObject`), the check fails because drones lack player-specific clearance or capabilities.

## Why Redscript Alone Can't Fix This

Redscript can call `IsPossible()` but cannot **hook** it to change its return value. The native C++ function runs its internal validation logic and returns `false` for drones. Only Red4ext can hook native C++ functions and modify their behavior.

## The Solution: Hook IsPossible

customentity2 uses a Red4ext C++ plugin to hook `BaseScriptableAction::IsPossible`. When the executor is our `CE2_DRONE`-tagged drone, the hook returns `true`, bypassing the validation gate. For all other executors, the original function is called normally.

```cpp
static bool IsPossible_Hook(void* this_, void* executor) {
    if (executor && HasCE2DroneTag(executor)) {
        RED4ext::Log::Info("[OrbHackingBridge] Bypassing IsPossible for CE2_DRONE");
        return true;
    }
    auto original = reinterpret_cast<IsPossible_t>(g_OriginalIsPossible);
    return original(this_, executor);
}
```

## The CE2_DRONE Tag

The CET Lua mod tags the spawned drone with `CE2_DRONE` when using DynamicEntitySpec (Method B):
```lua
spec.tags = { "CE2_DRONE" }
```

The Red4ext hook checks for this tag to identify our drone and bypass validation.

## Architecture

```
CET Lua -> Redscript Bridge -> Device Action Pipeline
                                        |
                                        v
                               IsPossible(drone) <-- hooked by Red4ext
                                        |
                                CE2_DRONE tag? -> return true
                                No tag?        -> call original
```

## Why Not Register a Custom Drone Subclass?

The original analysis suggested creating a C++ class that inherits from `Drone` via RTTI registration. While this is the theoretically correct approach, it requires:
- Deep knowledge of the RED4ext RTTI registration API
- TweakDB record creation for the custom type
- Proper entity template (.ent) setup

The executor validation hook approach is more pragmatic:
- Uses the already-proven drone spawning from customentity1a/1b
- Only requires hooking one function
- Works with the existing Redscript bridge
- Minimal complexity

## Implementation Status

The hook logic and pattern are documented in the C++ code. The actual hook registration requires:
1. Resolving the native function address for `BaseScriptableAction::IsPossible` via the RED4ext RTTI system
2. Registering the hook using the RED4ext hook API
3. Implementing `HasCE2DroneTag()` using RED4ext RTTI to check entity tags

These require the actual RED4ext SDK API which needs to be verified against clean SDK headers.
