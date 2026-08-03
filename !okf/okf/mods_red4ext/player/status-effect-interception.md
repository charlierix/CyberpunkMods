---
type: Mechanic Pattern
title: Status Effect Interception
description: Wrapping OnStatusEffectApplied/OnStatusEffectRemoved on PlayerPuppet and NPCPuppet to intercept status effect events.
tags: [player status-effects combat]
timestamp: 2026-08-03T00:00:00Z
---

# Status Effect Interception

Wrapping OnStatusEffectApplied/OnStatusEffectRemoved on PlayerPuppet and NPCPuppet to intercept status effect events.

## Approach

Mods wrap `PlayerPuppet.OnStatusEffectApplied` (20 instances) and `OnStatusEffectRemoved` (13 instances) to intercept when status effects are applied to or removed from the player. NPCPuppet variants are also wrapped for NPC status effect handling. This enables custom status effect behavior, conditional effect stacking, or effect modification based on game state.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| ArmorUp-24801-1-0-4-1774830868 | `r6/scripts/ArmorUp/shieldPointsSystem.reds` | Wraps `PlayerPuppet.OnStatusEffectApplied` |
| AutoAim1.20-28776-1-2-0-1776799767 | `r6/scripts/AutoAim/AutoAimHooks.reds` | Wraps `PlayerPuppet.OnStatusEffectRemoved` |
| Consumable Animations-26762-1-1-3-for-2-31-1768709491 | `r6/scripts/Consumable Animations/Services/CAGameStateService.reds` | Wraps `PlayerPuppet.OnStatusEffectApplied` |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Gameplay/DFInteractionSystem.reds` | Wraps `PlayerPuppet.OnStatusEffectApplied` |
| Deadly Roads-7745-v2-31b-1701881641 | `r6/scripts/Deadly Roads/core/DeadlyRoads.reds` | Wraps `PlayerPuppet.OnStatusEffectRemoved` |

*37 more mods use this pattern.*

## Related Concepts

- [Player Lifecycle Hooks](/player/player-lifecycle-hooks.md) — Wrapping PlayerPuppet lifecycle methods (OnGameAttached, OnDetach, OnMakePlayerVisibleAfterSpawn) to run mod initialization and cleanup.
- [TweakDB Status Effect Records](/systems/tweakdb-status-effects.md) — Modifying BaseStatusEffect.* and StatusEffects.* TweakDB records to alter status effects.
- [Sandevistan State Manipulation](/combat/sandevistan-manipulation.md) — Intercepting Sandevistan activation/deactivation events to modify time dilation behavior.
