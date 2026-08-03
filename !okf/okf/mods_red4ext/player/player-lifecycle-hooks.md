---
type: Mechanic Pattern
title: Player Lifecycle Hooks
description: Wrapping PlayerPuppet lifecycle methods (OnGameAttached, OnDetach, OnMakePlayerVisibleAfterSpawn) to run mod initialization and cleanup.
tags: [player lifecycle initialization playerpuppet]
timestamp: 2026-08-03T00:00:00Z
---

# Player Lifecycle Hooks

Wrapping PlayerPuppet lifecycle methods (OnGameAttached, OnDetach, OnMakePlayerVisibleAfterSpawn) to run mod initialization and cleanup.

## Approach

Mods wrap `PlayerPuppet.OnGameAttached` (the most common hook, 87 instances) to initialize mod state when the player entity is created. `OnDetach` is wrapped for cleanup. `OnMakePlayerVisibleAfterSpawn` is wrapped for post-spawn initialization. This is the foundational pattern for player-modifying mods — it provides the entry point for registering listeners, setting up systems, and injecting custom behavior. Both REDScript @wrapMethod and CET Observe patterns are used.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| AldecaldosHighStakes-18023-1-3-2-1738265460 | `r6/scripts/AldecaldosHighStakes/Main.reds` | Adds `PlayerPuppet.TestPopup` |
| Always First Equip-2557-2-1-5-1779632278 | `r6/scripts/alwaysFirstEquip.reds` | Wraps `PlayerPuppet.OnGameAttached` |
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/CustomHackingSystem/CodewareExtensions/TickManager.reds` | Wraps `PlayerPuppet.OnGameAttached` |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/CustomHackingSystem/CodewareExtensions/TickManager.reds` | Wraps `PlayerPuppet.OnGameAttached` |
| Anti-Tracking Breach-27505-2-0-1773756783 | `r6/scripts/Anti-TrackingBreach/AntiTrackingBreach.reds` | Wraps `PlayerPuppet.SetIsBeingRevealed` |

*99 more mods use this pattern.*

## Related Concepts

- [Status Effect Interception](/player/status-effect-interception.md) — Wrapping OnStatusEffectApplied/OnStatusEffectRemoved on PlayerPuppet and NPCPuppet to intercept status effect events.
- [Action Input Handling](/player/action-input-handling.md) — Wrapping PlayerPuppet.OnAction and input-related methods to intercept player input events.
- [Callback System Registration](/systems/callback-system-registration.md) — Using RegisterCallback and CET RegisterHook to register for game events like Session/Ready, Resource/PostLoad, and Input/Key.
