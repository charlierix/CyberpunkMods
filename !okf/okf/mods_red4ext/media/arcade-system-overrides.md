---
type: Mechanic Pattern
title: Arcade System Overrides
description: Intercepting arcade minigame controllers to customize arcade gameplay.
tags: [media arcade minigame]
timestamp: 2026-08-03T00:00:00Z
---

# Arcade System Overrides

Intercepting arcade minigame controllers to customize arcade gameplay.

## Approach

Mods observe arcade minigame controllers like `gameuiPanzerHUDGameController` and `ArcadeMachineControllerPS` via CET to intercept arcade minigame events. This enables custom arcade behavior, modified scoring, or additional arcade features.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Doom2077 31634 1 2026-07-17T20-07Z 4rpqrKUEh | `Doom2077/bin/x64/plugins/cyber_engine_tweaks/mods/Doom2077/init.lua` | CET Override `ArcadeMachineControllerPS.OnBeginArcadeMinigameUI` |
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/External/GameUI.lua` | CET Observe `gameuiPanzerHUDGameController.OnUninitialize` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `bin/x64/plugins/cyber_engine_tweaks/mods/DualSense Support/modules/GameUI.lua` | CET Observe `gameuiPanzerHUDGameController.OnUninitialize` |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enhanced Vehicle System/GameUI.lua` | CET Observe `gameuiPanzerHUDGameController.OnUninitialize` |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/external/GameUI.lua` | CET Observe `gameuiPanzerHUDGameController.OnUninitialize` |

*18 more mods use this pattern.*

## Related Concepts

- [Callback System Registration](/systems/callback-system-registration.md) — Using RegisterCallback and CET RegisterHook to register for game events like Session/Ready, Resource/PostLoad, and Input/Key.
- [Device Interaction Extensions](/world/device-interaction-extensions.md) — Extending ScriptableDeviceComponentPS and InteractiveDevice to modify device interaction behavior.
