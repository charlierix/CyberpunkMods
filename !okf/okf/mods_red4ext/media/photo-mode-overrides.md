---
type: Mechanic Pattern
title: Photo Mode Overrides
description: Intercepting photo mode activation and rendering to customize photo mode behavior.
tags: [media photo-mode camera]
timestamp: 2026-08-03T00:00:00Z
---

# Photo Mode Overrides

Intercepting photo mode activation and rendering to customize photo mode behavior.

## Approach

Mods wrap `gameuiPhotoModeMenuController` methods and observe photo mode events via CET to intercept photo mode activation/deactivation. This enables custom camera angles, unlocked movement, additional photo mode features, or removal of photo mode restrictions. Both REDScript `@wrapMethod` and CET `Observe` patterns are used.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Always Free Camera V1.5 31472 2 2026-07-16T09-54Z SlR4l6sf5 | `bin/x64/plugins/cyber_engine_tweaks/mods/AlwaysFreeCamera/init.lua` | CET Override `gamePhotoModeSystem.CanPhotoModeBeEnabled` |
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/AntiTheftMeasures/Spawn/VehicleSpawnSystem.reds` | References photo mode classes |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/AntiTheftMeasures/Spawn/VehicleSpawnSystem.reds` | References photo mode classes |
| BullseyesKnives 1.0.0 Beta 31418 1 2026-07-11T03-48Z 8ViLVPonV | `r6/scripts/BullseyeRicochet/BullseyeRicochet.reds` | References photo mode classes |
| CompassBar-22655-2-0-1770283479 | `r6/scripts/CompassBar/CompassBar.reds` | References photo mode classes |

*34 more mods use this pattern.*

## Related Concepts

- [Photo Mode Pose Tweaks](/media/photo-mode-poses.md) — Modifying PhotoModePoses.* TweakDB records to add or alter photo mode poses.
- [HUD Overlay Customization](/media/hud-overlay-customization.md) — Wrapping HUD overlay controllers like CompassController and hudCarController to customize HUD elements.
