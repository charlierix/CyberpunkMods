---
type: Mechanic Pattern
title: Vehicle Component Extensions
description: Extending VehicleComponent and VehicleComponentPS via wrapping and method addition to modify vehicle behavior.
tags: [vehicle vehicle-component extensions]
timestamp: 2026-08-03T00:00:00Z
---

# Vehicle Component Extensions

Extending VehicleComponent and VehicleComponentPS via wrapping and method addition to modify vehicle behavior.

## Approach

Mods wrap `VehicleComponent` (115 wraps, 400 @addMethod) and `VehicleComponentPS` (17 wraps, 33 @addMethod) to extend vehicle behavior. This is the primary pattern for vehicle-modifying mods — VehicleComponent is the core vehicle entity component. Wrapping its methods enables custom vehicle behavior, modified mounting logic, or integration with other systems. The high @addMethod count (400) reflects how many mods add custom methods to the vehicle component.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| (DriveCE) Mod Settings-10032-2-0-0-1697876886 | `r6/scripts/DriveCarefullyExpanded/DriveCarefullyExpanded.reds` | References VehicleComponent |
| 1st Night City Bank 29412 1.6 2026-06-29T12-18Z PYMIYqXtV | `r6/scripts/1stncbank/DebtCollector/DebtCollector.reds` | References VehicleComponent |
| AldecaldosHighStakes-18023-1-3-2-1738265460 | `r6/scripts/AldecaldosHighStakes/Vehicle.reds` | Wraps `VehicleComponent.EvaluateDamageLevel` |
| Always First Equip-2557-2-1-5-1779632278 | `r6/scripts/alwaysFirstEquip.reds` | References VehicleComponent |
| Anti-Theft Measures-27229-2-1-1-1778768828 | `r6/scripts/AntiTheftMeasures/CounterMeasure/CounterMeasure.reds` | References VehicleComponent |

*46 more mods use this pattern.*

## Related Concepts

- [Vehicle Mount Events](/vehicle/vehicle-mount-events.md) — Wrapping vehicle mount/unmount event methods to intercept player entering and exiting vehicles.
- [Vehicle Quickhack Interception](/vehicle/vehicle-quickhack-interception.md) — Wrapping VehicleComponentPS.GetQuickHackActions to intercept and modify vehicle quickhack options.
- [Radio Station Manipulation](/media/radio-station-manipulation.md) — Wrapping radio controller classes to modify in-vehicle radio behavior.
