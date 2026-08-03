---
type: Mechanic Pattern
title: Callback System Registration
description: Using RegisterCallback and CET RegisterHook to register for game events like Session/Ready, Resource/PostLoad, and Input/Key.
tags: [systems callbacks events initialization]
timestamp: 2026-08-03T00:00:00Z
---

# Callback System Registration

Using RegisterCallback and CET RegisterHook to register for game events like Session/Ready, Resource/PostLoad, and Input/Key.

## Approach

Mods register callbacks via REDScript `RegisterCallback` or CET `RegisterHook`/`RegisterForEvent` to listen for game lifecycle events. The most common events are `Resource/PostLoad` (7245 instances), `Resource/Ready`, `Session/Ready`, `Input/Key`, and `Entity/Attached`. This is the primary initialization pattern — mods register callbacks to know when the game has loaded, when the session starts, or when input events occur.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 1st Night City Bank 29412 1.6 2026-06-29T12-18Z PYMIYqXtV | `r6/scripts/1stncbank/Core/Config.reds` | Registers callback for `Session/Ready` |
| AldecaldosHighStakes-18023-1-3-2-1738265460 | `r6/scripts/AldecaldosHighStakes/Main.reds` | Registers callback for `Session/Ready` |
| Audioware-12001-v1-9-2-1775355328 | `r6/scripts/Audioware/Codeware.reds` | Registers callback for `Session/Ready` |
| Cutscene Weapon Swapper-20743-1-4-1-1745154157 | `r6/scripts/CutsceneWeaponSwapper.reds` | Registers callback for `Resource/PostLoad` |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Settings/DFSettings.reds` | Registers callback for `Session/Start` |

*48 more mods use this pattern.*

## Related Concepts

- [Player Lifecycle Hooks](/player/player-lifecycle-hooks.md) — Wrapping PlayerPuppet lifecycle methods (OnGameAttached, OnDetach, OnMakePlayerVisibleAfterSpawn) to run mod initialization and cleanup.
- [ScriptableService Registration](/systems/scriptable-service-registration.md) — Using the ScriptableService pattern to create persistent background services that run throughout the game session.
