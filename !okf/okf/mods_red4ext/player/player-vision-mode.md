---
type: Mechanic Pattern
title: Player Vision Mode
description: Intercepting PlayerVisionModeController to modify scanning and vision modes.
tags: [player vision scanning]
timestamp: 2026-08-03T00:00:00Z
---

# Player Vision Mode

Intercepting PlayerVisionModeController to modify scanning and vision modes.

## Approach

Mods observe `PlayerVisionModeController.OnRestrictedSceneChanged` (45 instances) via CET to intercept vision mode changes. This enables custom scanning behavior, modified vision mode effects, or conditional vision restrictions based on game context.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| CompassBar-22655-2-0-1770283479 | `r6/scripts/CompassBar/CompassBar.reds` | References PlayerVisionModeController |
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/External/GameUI.lua` | CET Observe `PlayerVisionModeController.OnRestrictedSceneChanged` |
| DynamicEnemyMultiplier_1.1 31555 1.1 2026-07-17T00-18Z k8Iw8mCTa | `bin/x64/plugins/cyber_engine_tweaks/mods/DynamicEnemyMultiplier/init.lua` | CET Observe `PlayerVisionModeController.OnRestrictedSceneChanged` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `bin/x64/plugins/cyber_engine_tweaks/mods/DualSense Support/modules/GameUI.lua` | CET Observe `PlayerVisionModeController.OnRestrictedSceneChanged` |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enhanced Vehicle System/GameUI.lua` | CET Observe `PlayerVisionModeController.OnRestrictedSceneChanged` |

*19 more mods use this pattern.*

## Related Concepts

- [Braindance Manipulation](/media/braindance-manipulation.md) — Intercepting BraindanceGameController to modify braindance mode behavior.
- [Hacking System Extensions](/systems/hacking-system-extensions.md) — Extending quickhack and hacking system classes to modify network breach and quickhack behavior.
