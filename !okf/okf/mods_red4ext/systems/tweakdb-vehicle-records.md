---
type: Mechanic Pattern
title: TweakDB Vehicle Record Modification
description: Modifying Vehicle.* TweakDB records to alter vehicle definitions and properties.
tags: [systems tweakdb vehicles]
timestamp: 2026-08-03T00:00:00Z
---

# TweakDB Vehicle Record Modification

Modifying Vehicle.* TweakDB records to alter vehicle definitions and properties.

## Approach

Mods modify `Vehicle.*` TweakDB records to change vehicle stats, add custom vehicles, or alter vehicle behavior parameters. This includes speed, handling, durability, or visual properties defined as TweakDB data.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| AldecaldosHighStakes-18023-1-3-2-1738265460 | `r6/tweaks/AldecaldosHighStakes/tweaks.yaml` | Modifies Vehicle.* TweakDB records |
| Devel Sixteen ver. B-19407-1-2-1754530569 | `r6/tweaks/_devel_sixteen/devel_sixteen.yaml` | Modifies Vehicle.* TweakDB records |
| Disable Mounted Car Guns-10850-1-0-1699521648 | `r6/tweaks/UnmountedGuns/vehicles.yaml` | Modifies Vehicle.* TweakDB records |
| Disable Visual Car Damage-10646-1-3-1735260528 | `r6/tweaks/DisableVisualDmg.yaml` | Modifies Vehicle.* TweakDB records |
| Drive an Aerial Vehicle 13842 3.2.1 2026-06-15T16-52Z rxs7xR59h | `r6/tweaks/DriveAerialVehicle/dav_default_model.yaml` | Modifies Vehicle.* TweakDB records |

*18 more mods use this pattern.*

## Related Concepts

- [Vehicle Object Manipulation](/vehicle/vehicle-object-manipulation.md) — Wrapping VehicleObject to modify vehicle entity properties and behavior.
- [TweakDB Item Record Modification](/systems/tweakdb-item-records.md) — Modifying Items.* TweakDB records to add, alter, or remove item definitions.
