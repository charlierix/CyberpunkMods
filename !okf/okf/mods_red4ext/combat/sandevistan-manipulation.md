---
type: Mechanic Pattern
title: Sandevistan State Manipulation
description: Intercepting Sandevistan activation/deactivation events to modify time dilation behavior.
tags: [combat sandevistan cyberware time-dilation]
timestamp: 2026-08-03T00:00:00Z
---

# Sandevistan State Manipulation

Intercepting Sandevistan activation/deactivation events to modify time dilation behavior.

## Approach

Mods wrap `SandevistanEvents.OnEnter`, `OnExit`, and `OnForcedExit` to intercept when the player activates or deactivates the Sandevistan. This allows custom time dilation modifiers, extended duration, conditional effects, or modified stamina drain during Sandevistan use.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Time Dilation Overhaul 4931 2.32 2026-07-28T22-51Z q7jg7fhKQ | `r6/scripts/TDO/Core/RangedFireRateFix.reds` | Wraps `SandevistanEvents.OnEnter` |

## Related Concepts

- [Status Effect Interception](/player/status-effect-interception.md) — Wrapping OnStatusEffectApplied/OnStatusEffectRemoved on PlayerPuppet and NPCPuppet to intercept status effect events.
- [Shoot Event Handling](/combat/shoot-events.md) — Wrapping ShootEvents to modify weapon firing behavior and combat state transitions.
