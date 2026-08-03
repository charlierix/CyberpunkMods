---
type: Mechanic Pattern
title: Vehicle Mount Events
description: Wrapping vehicle mount/unmount event methods to intercept player entering and exiting vehicles.
tags: [vehicle mount enter exit]
timestamp: 2026-08-03T00:00:00Z
---

# Vehicle Mount Events

Wrapping vehicle mount/unmount event methods to intercept player entering and exiting vehicles.

## Approach

Mods wrap `VehicleComponent.OnVehicleFinishedMountingEvent` (20 wraps), `OnVehicleStartedMountingEvent` (14 wraps), `OnUnmountingEvent` (12 wraps), and `OnGameAttach` (12 wraps) to intercept vehicle mounting events. This enables custom behavior when entering/exiting vehicles, conditional mounting restrictions, or integration with other systems during vehicle transitions.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/AntiTheftMeasures/Hacking/VehicleHackRegistration.reds` | Wraps `VehicleComponent.OnVehicleFinishedMountingEvent` |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/AntiTheftMeasures/Hacking/VehicleHackRegistration.reds` | Wraps `VehicleComponent.OnVehicleFinishedMountingEvent` |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Gameplay/DFVehicleSleepSystem.reds` | Wraps `VehicleComponent.OnVehicleFinishedMountingEvent` |
| Dynamic Movement-26963-2-6-1-1772108240 | `r6/scripts/Dynamic Movement/StateCallbacks/StateMachineWraps.reds` | Wraps `VehicleComponent.OnUnmountingEvent` |
| Enhanced Vehicle System v17.8 11765 17.8 2026-06-21T09-19Z gMz5MuDD8 | `r6/scripts/Enhanced Vehicle System/Enhanced Vehicle System.reds` | Wraps `VehicleComponent.OnMountingEvent` |

*8 more mods use this pattern.*

## Related Concepts

- [Vehicle Component Extensions](/vehicle/vehicle-component-extensions.md) — Extending VehicleComponent and VehicleComponentPS via wrapping and method addition to modify vehicle behavior.
- [Action Input Handling](/player/action-input-handling.md) — Wrapping PlayerPuppet.OnAction and input-related methods to intercept player input events.
