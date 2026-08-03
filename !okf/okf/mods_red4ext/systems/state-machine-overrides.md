---
type: Mechanic Pattern
title: State Machine Overrides
description: Wrapping gamestateMachineComponent to modify player state machine behavior.
tags: [systems state-machine player]
timestamp: 2026-08-03T00:00:00Z
---

# State Machine Overrides

Wrapping gamestateMachineComponent to modify player state machine behavior.

## Approach

Mods use `@replaceMethod(gamestateMachineComponent)` to replace state machine logic for the player. This enables custom state transitions, modified state behavior, or entirely new states. The state machine controls movement, combat, and interaction states.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Always First Equip-2557-2-1-5-1779632278 | `r6/scripts/alwaysFirstEquip.reds` | Wraps `gamestateMachineComponent.OnStartTakedownEvent` |

## Related Concepts

- [Movement State Events](/player/movement-state-events.md) — Wrapping SprintEvents, ClimbEvents, LadderEvents, and other movement state classes to modify movement behavior.
- [Action Input Handling](/player/action-input-handling.md) — Wrapping PlayerPuppet.OnAction and input-related methods to intercept player input events.
