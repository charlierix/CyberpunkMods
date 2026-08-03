---
type: Mechanic Pattern
title: HUD Overlay Customization
description: Wrapping HUD overlay controllers like CompassController and hudCarController to customize HUD elements.
tags: [media hud compass overlay]
timestamp: 2026-08-03T00:00:00Z
---

# HUD Overlay Customization

Wrapping HUD overlay controllers like CompassController and hudCarController to customize HUD elements.

## Approach

Mods wrap `CompassController`, `hudCarController`, and other HUD overlay controllers to customize HUD rendering. This includes compass modifications, vehicle HUD customization, or hiding/showing HUD elements conditionally. CET `Observe` is commonly used to react to HUD state changes.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| CompassBar-22655-2-0-1770283479 | `r6/scripts/CompassBar/LHUDCompat.reds` | References HUD overlay controllers |
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/External/GameUI.lua` | CET Observe `hudCarController.OnCameraModeChanged` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `bin/x64/plugins/cyber_engine_tweaks/mods/DualSense Support/modules/GameUI.lua` | CET Observe `hudCarController.OnCameraModeChanged` |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `r6/scripts/Enhanced Vehicle System/Enhanced Vehicle System.reds` | References HUD overlay controllers |
| Eye-Tracked HUD 30603 1.0.0 2026-06-20T15-56Z AgoGgivIA | `r6/scripts/Eye-Tracked HUD/EyeTrackedHUDController.reds` | References HUD overlay controllers |

*25 more mods use this pattern.*

## Related Concepts

- [HUD Manager Overrides](/ui/hud-manager-overrides.md) — Wrapping HUDManager to modify HUD element visibility, style, and compatibility.
- [Braindance Manipulation](/media/braindance-manipulation.md) — Intercepting BraindanceGameController to modify braindance mode behavior.
