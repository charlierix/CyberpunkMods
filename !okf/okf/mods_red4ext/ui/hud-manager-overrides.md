---
type: Mechanic Pattern
title: HUD Manager Overrides
description: Wrapping HUDManager to modify HUD element visibility, style, and compatibility.
tags: [ui hud hud-manager]
timestamp: 2026-08-03T00:00:00Z
---

# HUD Manager Overrides

Wrapping HUDManager to modify HUD element visibility, style, and compatibility.

## Approach

Mods wrap `HUDManager` methods (45 wraps, 35 @addMethod) to modify HUD behavior. Key methods include `ApplyFilterCompatibility` (11 wraps), `ApplyStyleCompatibility` (10 wraps), and `ApplyMappinCompatibility` (9 wraps). These methods are called when HUD elements need to check compatibility with active mods. The `@addMethod(HUDManager)` pattern is used to add custom HUD management logic.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| CompassBar-22655-2-0-1770283479 | `r6/scripts/CompassBar/CompassBar.reds` | Adds `HUDManager.OnFactChanged` |
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/External/GameHUD.lua` | CET Override `WarningMessageGameController.UpdateWidgets` |
| Enhanced DualSense Support - Update 2.3-4156-4-62-1753534659 | `bin/x64/plugins/cyber_engine_tweaks/mods/DualSense Support/modules/GameUI.lua` | CET Observe `gameuiGameSystemUI.PushGameContext` |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `r6/scripts/Enhanced Vehicle System/Enhanced Vehicle System.reds` | References HUDManager |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/external/GameUI.lua` | CET Observe `gameuiGameSystemUI.PushGameContext` |

*26 more mods use this pattern.*

## Related Concepts

- [Ink Widget Extensions](/ui/ink-widget-extensions.md) — Using @addMethod on inkGameController and inkWidget to extend UI widget functionality.
- [HUD Overlay Customization](/media/hud-overlay-customization.md) — Wrapping HUD overlay controllers like CompassController and hudCarController to customize HUD elements.
- [Damage Number Display](/combat/damage-display.md) — Customizing how damage numbers are rendered in the HUD via DamageDigitsGameController.
