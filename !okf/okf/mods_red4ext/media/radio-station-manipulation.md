---
type: Mechanic Pattern
title: Radio Station Manipulation
description: Wrapping radio controller classes to modify in-vehicle radio behavior.
tags: [media radio vehicle audio]
timestamp: 2026-08-03T00:00:00Z
---

# Radio Station Manipulation

Wrapping radio controller classes to modify in-vehicle radio behavior.

## Approach

Mods wrap `RadioControllerPS`, `RadioInkGameController`, `PocketRadio`, and `VehicleRadioPopupGameController` to modify radio station behavior. This includes custom station switching, default station setting, radio toggle interception, or adding custom radio streams. Both CET Override and REDScript @wrapMethod patterns are used.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Consumable Animations-26762-1-1-3-for-2-31-1768709491 | `r6/scripts/Consumable Animations/Services/CAAnimationService.reds` | References radio system classes |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Gameplay/DFVehicleSleepSystem.reds` | References radio system classes |
| Limited HUD 2592 2.22.4 2026-07-26T18-22Z LACBAIyo3 | `r6/scripts/LHUD/core/listeners.reds` | References radio system classes |
| Logitech Wheel Support-29172-2-31-2-1780181543 | `gwheel_reds/gwheel_vehicle_signals.reds` | Wraps `VehicleComponent.OnRadioToggleEvent` |
| Metro Pocket Guide-11882-1-2-12-1769330167 | `r6/scripts/MetroPocketGuide/widgetdisplay/TrackMetroEnterExit.reds` | References radio system classes |

*3 more mods use this pattern.*

## Related Concepts

- [Custom Radio Streams](/media/custom-radio-streams.md) — Adding custom radio stations via Channels.* TweakDB records and audio archive files.
- [Vehicle Component Extensions](/vehicle/vehicle-component-extensions.md) — Extending VehicleComponent and VehicleComponentPS via wrapping and method addition to modify vehicle behavior.
