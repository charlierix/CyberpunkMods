---
type: Mechanic Pattern
title: Action Input Handling
description: Wrapping PlayerPuppet.OnAction and input-related methods to intercept player input events.
tags: [player input actions]
timestamp: 2026-08-03T00:00:00Z
---

# Action Input Handling

Wrapping PlayerPuppet.OnAction and input-related methods to intercept player input events.

## Approach

Mods wrap `PlayerPuppet.OnAction` (16 instances) to intercept player input actions. This enables custom key bindings, modified input behavior, conditional action handling, or integration of custom actions into the input system. CET Observe is also used to monitor `QuickSlotsManager` for hotkey events.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Always First Equip-2557-2-1-5-1779632278 | `r6/scripts/alwaysFirstEquip.reds` | Hooks OnAction for input handling |
| Always Free Camera V1.5 31472 2 2026-07-16T09-54Z SlR4l6sf5 | `bin/x64/plugins/cyber_engine_tweaks/mods/AlwaysFreeCamera/init.lua` | CET Observe `PlayerPuppet.OnAction` |
| Anti-Tracking Breach-27505-2-0-1773756783 | `r6/scripts/Anti-TrackingBreach/AntiTrackingBreach.reds` | Wraps `PlayerPuppet.OnAction` |
| AutoAim1.20-28776-1-2-0-1776799767 | `r6/scripts/AutoAim/AutoAimHooks.reds` | Wraps `PlayerPuppet.OnAction` |
| AutoWalkToggle 31218 2 2026-07-06T19-28Z VquAqYzZD | `r6/scripts/AutoRunToggle/AutoRunToggle.reds` | Wraps `PlayerPuppet.OnAction` |

*47 more mods use this pattern.*

## Related Concepts

- [Player Lifecycle Hooks](/player/player-lifecycle-hooks.md) — Wrapping PlayerPuppet lifecycle methods (OnGameAttached, OnDetach, OnMakePlayerVisibleAfterSpawn) to run mod initialization and cleanup.
- [Movement State Events](/player/movement-state-events.md) — Wrapping SprintEvents, ClimbEvents, LadderEvents, and other movement state classes to modify movement behavior.
