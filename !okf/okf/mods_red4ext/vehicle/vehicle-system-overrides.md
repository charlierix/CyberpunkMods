---
type: Mechanic Pattern
title: Vehicle System Overrides
description: Overriding VehicleSystem methods via CET to modify vehicle spawning and management.
tags: [vehicle vehicle-system spawn]
timestamp: 2026-08-03T00:00:00Z
---

# Vehicle System Overrides

Overriding VehicleSystem methods via CET to modify vehicle spawning and management.

## Approach

Mods use CET `Override` on `VehicleSystem.SpawnActivePlayerVehicle` to modify vehicle spawning behavior. This enables custom vehicle spawn locations, modified spawn conditions, or integration with other vehicle management systems.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `bin/x64/plugins/cyber_engine_tweaks/mods/DriveAerialVehicle/Modules/core.lua` | CET Override `VehicleSystem.SpawnActivePlayerVehicle` |
| Flying Tank-16138-1-2-4-1770820062 | `bin/x64/plugins/cyber_engine_tweaks/mods/FlyingTank/Modules/core.lua` | CET Override `VehicleSystem.SpawnActivePlayerVehicle` |
| Much Better Eddies 30532 1.3 2026-07-12T02-46Z LACBAIygB | `r6/scripts/BetterEddies/DeadChannel/DeadChannelSummonWatch.reds` | Wraps `VehicleSystem.OnSummonVehicleFailed` |
| Vehicle Summon Tweaks - Dismiss-4658-2-3-4-1779350650 | `r6/scripts/vehicleSummonTweaksDismiss.reds` | Wraps `VehicleSystem.IsSummoningVehiclesRestricted` |

## Related Concepts

- [Vehicle Component Extensions](/vehicle/vehicle-component-extensions.md) — Extending VehicleComponent and VehicleComponentPS via wrapping and method addition to modify vehicle behavior.
- [Vehicle Management UI](/vehicle/vehicle-management-ui.md) — Wrapping VehiclesManagerPopupGameController to modify the vehicle management interface.
