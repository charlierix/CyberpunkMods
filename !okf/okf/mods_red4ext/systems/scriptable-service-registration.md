---
type: Mechanic Pattern
title: ScriptableService Registration
description: Using the ScriptableService pattern to create persistent background services that run throughout the game session.
tags: [systems services architecture]
timestamp: 2026-08-03T00:00:00Z
---

# ScriptableService Registration

Using the ScriptableService pattern to create persistent background services that run throughout the game session.

## Approach

Mods create classes extending `ScriptableService` and register them with the game scriptable service container. These services persist throughout the game session and can register callbacks, maintain state, and provide APIs to other mod components. The `OnLoad` method is used for initialization, registering callbacks for `Session/Ready` or other lifecycle events. This is the modern architectural pattern for mod systems in REDScript.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| AldecaldosHighStakes-18023-1-3-2-1738265460 | `r6/scripts/AldecaldosHighStakes/Main.reds` | Uses ScriptableService pattern |
| Audioware-12001-v1-9-2-1775355328 | `r6/scripts/Audioware/Codeware.reds` | Uses ScriptableService pattern |
| Better Leveling V2 (Finalise)-22784-2-3-3-1759851280 | `r6/scripts/Better Leveling (Revamp of Custom Level Cap)/BTL_02_TweakDB.reds` | Uses ScriptableService pattern |
| Consumable Animations-26762-1-1-3-for-2-31-1768709491 | `r6/scripts/Consumable Animations/Main/CAMainSystem.reds` | Uses ScriptableService pattern |
| Craft All-23494-1-0-0-1755273337 | `r6/scripts/Craft All/Craft All.reds` | Uses ScriptableService pattern |

*56 more mods use this pattern.*

## Related Concepts

- [Callback System Registration](/systems/callback-system-registration.md) — Using RegisterCallback and CET RegisterHook to register for game events like Session/Ready, Resource/PostLoad, and Input/Key.
- [Player Lifecycle Hooks](/player/player-lifecycle-hooks.md) — Wrapping PlayerPuppet lifecycle methods (OnGameAttached, OnDetach, OnMakePlayerVisibleAfterSpawn) to run mod initialization and cleanup.
