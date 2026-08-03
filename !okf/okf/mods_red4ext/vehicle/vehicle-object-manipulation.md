---
type: Mechanic Pattern
title: Vehicle Object Manipulation
description: Wrapping VehicleObject to modify vehicle entity properties and behavior.
tags: [vehicle vehicle-object properties]
timestamp: 2026-08-03T00:00:00Z
---

# Vehicle Object Manipulation

Wrapping VehicleObject to modify vehicle entity properties and behavior.

## Approach

Mods wrap `VehicleObject` (25 wraps, 28 @addMethod) to modify vehicle entity properties. This includes custom vehicle stats, modified radio behavior, or integration of vehicle-specific features. VehicleObject is the base vehicle entity class.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| (DriveCE) Mod Settings-10032-2-0-0-1697876886 | `r6/scripts/DriveCarefullyExpanded/DriveCarefullyExpanded.reds` | Wraps `VehicleObject.OnVehicleBumpEvent` |
| AldecaldosHighStakes-18023-1-3-2-1738265460 | `r6/scripts/AldecaldosHighStakes/Vehicle.reds` | References VehicleObject |
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/AntiTheftMeasures/CounterMeasure/Alarm/AlarmCallback.reds` | References VehicleObject |
| Anti-Theft Measures-27229-2-1-1-1778768828 (1) | `r6/scripts/AntiTheftMeasures/CounterMeasure/Alarm/AlarmCallback.reds` | References VehicleObject |
| Dark Future Core-26956-2-0-3-for-2-31-1768879964 | `r6/scripts/Dark Future/Gameplay/DFVehicleSleepSystem.reds` | Wraps `VehicleObject.OnMountingEvent` |

*27 more mods use this pattern.*

## Related Concepts

- [Vehicle Component Extensions](/vehicle/vehicle-component-extensions.md) — Extending VehicleComponent and VehicleComponentPS via wrapping and method addition to modify vehicle behavior.
- [TweakDB Vehicle Record Modification](/systems/tweakdb-vehicle-records.md) — Modifying Vehicle.* TweakDB records to alter vehicle definitions and properties.
