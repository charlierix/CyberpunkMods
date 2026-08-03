---
type: Mechanic Pattern
title: Movement State Events
description: Wrapping SprintEvents, ClimbEvents, LadderEvents, and other movement state classes to modify movement behavior.
tags: [player movement sprint climb]
timestamp: 2026-08-03T00:00:00Z
---

# Movement State Events

Wrapping SprintEvents, ClimbEvents, LadderEvents, and other movement state classes to modify movement behavior.

## Approach

Mods wrap state event classes like `SprintEvents`, `ClimbEvents`, `LadderEvents`, `CarriedObjectEvents`, and `CoolExitingEvents` to intercept movement state transitions. This enables custom sprint mechanics, modified climbing behavior, or conditional movement restrictions. These classes are part of the player state machine and wrapping their `OnEnter`/`OnExit` methods allows intercepting state changes.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Always First Equip-2557-2-1-5-1779632278 | `r6/scripts/alwaysFirstEquip.reds` | Wraps `ClimbEvents.OnEnter` |
| Dynamic Movement-26963-2-6-1-1772108240 | `r6/scripts/Dynamic Movement/StateCallbacks/StateMachineWraps.reds` | Wraps `LadderEvents.OnEnter` |
| Omni Combat v1.0 FabledFoundry-24008-1-0-1756973720 | `r6/scripts/Omni-Combat/OmniCombat_Pack.reds` | Wraps `SprintEvents.OnEnter` |
| Running Man 26611 1.2.0 2026-07-29T21-57Z Q6xF6lvEu | `r6/scripts/RunningMan/double_sprint.reds` | Wraps `SprintEvents.OnUpdate` |
| Time Dilation Overhaul 4931 2.32 2026-07-28T22-51Z q7jg7fhKQ | `r6/scripts/TDO/Sandy/Juggernaut.reds` | Wraps `ClimbEvents.OnEnter` |

*1 more mods use this pattern.*

## Related Concepts

- [Action Input Handling](/player/action-input-handling.md) — Wrapping PlayerPuppet.OnAction and input-related methods to intercept player input events.
- [Movement Action Tweaks](/player/movement-action-tweaks.md) — Modifying MovementActions.* TweakDB records to alter movement mechanics.
