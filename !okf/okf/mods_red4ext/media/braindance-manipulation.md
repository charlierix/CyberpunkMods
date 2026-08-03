---
type: Mechanic Pattern
title: Braindance Manipulation
description: Intercepting BraindanceGameController to modify braindance mode behavior.
tags: [media braindance scanning]
timestamp: 2026-08-03T00:00:00Z
---

# Braindance Manipulation

Intercepting BraindanceGameController to modify braindance mode behavior.

## Approach

Mods observe `BraindanceGameController.OnIsActiveUpdated` via CET to intercept braindance activation/deactivation. This enables custom braindance scanning behavior, modified visual effects, or integration with other gameplay systems during braindance mode.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| CompassBar-22655-2-0-1770283479 | `r6/scripts/CompassBar/CompassBar.reds` | References BraindanceGameController |
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/External/GameUI.lua` | CET Observe `BraindanceGameController.OnIsActiveUpdated` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `bin/x64/plugins/cyber_engine_tweaks/mods/DualSense Support/modules/GameUI.lua` | CET Observe `BraindanceGameController.OnIsActiveUpdated` |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enhanced Vehicle System/GameUI.lua` | CET Observe `BraindanceGameController.OnIsActiveUpdated` |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/external/GameUI.lua` | CET Observe `BraindanceGameController.OnIsActiveUpdated` |

*18 more mods use this pattern.*

## Related Concepts

- [Player Vision Mode](/player/player-vision-mode.md) — Intercepting PlayerVisionModeController to modify scanning and vision modes.
- [HUD Overlay Customization](/media/hud-overlay-customization.md) — Wrapping HUD overlay controllers like CompassController and hudCarController to customize HUD elements.
