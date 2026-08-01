# Player 3 — Entity Interrogation Tester

## Goal

Dead simple: **no rotation attempts, no hover**. Just interrogate the player entity on a hotkey to discover what it actually supports — components, ragdoll, state machine, methods, physics, etc.

This will help us decide what approach to try next for body rotation.

## Background

| Tester | Finding |
|--------|---------|
| Player 1 | `SetWorldTransform` is a complete no-op — position and orientation never change |
| Player 2 | Impulse hover works, but `SetWorldTransform` orientation is always overridden back to `roll=0 pitch=0` by the locomotion system |

Player 3 takes a step back: **instead of trying to rotate, let's first understand what the player entity is and what APIs it exposes.**

## How It Works

One hotkey (`Interrogate Player (P3)`) triggers a single dump of everything to the CET console:

1. **Identity & class hierarchy** — `IsA()` checks, class name, entity ID, record ID
2. **Transform state** — position, orientation, velocity, local vs world
3. **Component getters** — tries ~25+ known component getter methods
4. **Component lookup by name/type** — `FindComponentByName`, `GetComponent` with ragdoll/physics names
5. **Component enumeration** — `GetAllComponents()` / `GetComponents()` if available
6. **Ragdoll events** — tries queueing `CreateForceRagdollEvent`, `RagdollActivationRequestEvent`, `RagdollApplyImpulseEvent`, `RagdollDisableEvent`
7. **Ragdoll method probes** — checks for `CanRagdoll`, `IsRagdolling`, `ForceRagdoll`, etc.
8. **State machine / blackboard** — PSM state, blackboard access
9. **Appearance / mesh** — appearance name, display name
10. **SetWorldTransform identity test** — confirms the no-op with the player's own current transform
11. **Teleport probe** — checks if `TeleportationFacility` has orientation-setting methods
12. **Comprehensive method existence check** — checks ~50+ method names for existence on the player object
13. **Game systems** — probes for animation, stats, damage, time, delay, and other systems
14. **Component deep examination** — for any found components, checks for transform/setter methods
15. **CET reflection dump** — tries `Dump()` and `GetClass()` globals if CET exposes them

Everything is wrapped in `pcall()` so nothing can crash — errors are just logged.

## Install

Copy this folder to:
```
bin/x64/plugins/cyber_engine_tweaks/mods/hover_rot_tester_player3
```

## Usage

1. Load the game with CET installed
2. Go to **Settings > Key Bindings > PlayerInterrogator3**
3. Bind **Interrogate Player (P3)** to a key
4. Press the key in-game
5. Check the CET console for the full dump

## What to Look For

### Key questions the dump answers:

- **Does the player have a ragdoll component?** — If `GetRagdollComponent` or `FindComponentByName('ragdoll')` returns something, ragdoll-based rotation might be possible
- **Can we enumerate all components?** — If `GetAllComponents()` works, we can discover components we didn't know about
- **Which methods exist?** — The method existence check reveals what APIs are actually available on the player object
- **Do ragdoll events queue successfully?** — If `CreateForceRagdollEvent` queues without error, we might be able to use ragdoll physics for rotation
- **Does TeleportationFacility have orientation methods?** — Teleport might set orientation where SetWorldTransform can't
- **What does the state machine expose?** — PSM state might reveal locomotion constraints we need to work around

### Decision tree after results:

- If **ragdoll works** → try ragdoll-based body orientation (force ragdoll, apply angular impulse)
- If **component enumeration works** → look for unnamed physics/mesh components with transform setters
- If **teleport has orientation** → use TeleportationFacility instead of SetWorldTransform
- If **none of the above** → consider external DLL (RED4ext) approach like LTBF does for vehicles
