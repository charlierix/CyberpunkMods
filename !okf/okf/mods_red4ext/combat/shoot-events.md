---
type: Mechanic Pattern
title: Shoot Event Handling
description: Wrapping ShootEvents to modify weapon firing behavior and combat state transitions.
tags: [combat weapons shooting]
timestamp: 2026-08-03T00:00:00Z
---

# Shoot Event Handling

Wrapping ShootEvents to modify weapon firing behavior and combat state transitions.

## Approach

Mods wrap `ShootEvents.OnEnter` to intercept when the player enters a shooting state. This enables custom recoil patterns, weapon handling modifications, or conditional firing behavior based on game state.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Always First Equip-2557-2-1-5-1779632278 | `r6/scripts/alwaysFirstEquip.reds` | Wraps `ShootEvents.OnEnter` |
| Time Dilation Overhaul 4931 2.32 2026-07-28T22-51Z q7jg7fhKQ | `r6/scripts/TDO/Core/RangedFireRateFix.reds` | Wraps `ShootEvents.OnEnter` |
| Trigger Mode Control-13077-2-8-1-1757088209 | `r6/scripts/TriggerModeControl/TriggerModeControl.reds` | Wraps `ShootEvents.OnExit` |

## Related Concepts

- [Action Input Handling](/player/action-input-handling.md) — Wrapping PlayerPuppet.OnAction and input-related methods to intercept player input events.
- [Combat State Transitions](/player/combat-state-transitions.md) — Wrapping OnCombatStateChanged to intercept combat state changes and apply custom behavior.
