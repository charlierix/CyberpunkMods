---
type: Mechanic Pattern
title: Combat State Transitions
description: Wrapping OnCombatStateChanged to intercept combat state changes and apply custom behavior.
tags: [player combat state-transitions]
timestamp: 2026-08-03T00:00:00Z
---

# Combat State Transitions

Wrapping OnCombatStateChanged to intercept combat state changes and apply custom behavior.

## Approach

Mods wrap `PlayerPuppet.OnCombatStateChanged` (9 instances) to detect when the player enters or exits combat. This enables conditional behavior based on combat state — such as modified movement speed, changed UI display, or custom effects triggered by combat engagement.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Services/DFPlayerStateService.reds` | Wraps `PlayerPuppet.OnCombatStateChanged` |
| Dynamic Movement-26963-2-6-1-1772108240 | `r6/scripts/Dynamic Movement/StateCallbacks/BlackboardCallbacks.reds` | Wraps `PlayerPuppet.OnCombatStateChanged` |
| Dynamic Wardrobe-27791-2-1-1773744332 | `r6/scripts/Dynamic Wardrobe/Core/OutfitManager.reds` | Hooks OnCombatStateChanged |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `r6/scripts/Enhanced Vehicle System/Enhanced Vehicle System.reds` | Wraps `PlayerPuppet.OnCombatStateChanged` |
| Gen Texting-28275-V6-1774838745 | `r6/scripts/GenerativeTexting/GenerativeTextingHooks.reds` | Wraps `PlayerPuppet.OnCombatStateChanged` |

*5 more mods use this pattern.*

## Related Concepts

- [Player Lifecycle Hooks](/player/player-lifecycle-hooks.md) — Wrapping PlayerPuppet lifecycle methods (OnGameAttached, OnDetach, OnMakePlayerVisibleAfterSpawn) to run mod initialization and cleanup.
- [Shoot Event Handling](/combat/shoot-events.md) — Wrapping ShootEvents to modify weapon firing behavior and combat state transitions.
- [Prevention System Overrides](/systems/prevention-system-overrides.md) — Wrapping PreventionSystem to modify police response and crime detection behavior.
