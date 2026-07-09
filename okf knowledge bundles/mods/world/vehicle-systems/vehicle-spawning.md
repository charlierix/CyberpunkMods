---
type: Mechanic Pattern
title: "Vehicle Spawning"
description: "Spawning custom vehicles via GetVehicleSystem and vehicle entity creation"
tags: [world, vehicles, spawning]
timestamp: 2026-07-04T00:00:00Z
---

# Vehicle Spawning

Spawning custom vehicles via GetVehicleSystem and vehicle entity creation.

## Approach

This technique involves spawning custom vehicles via getvehiclesystem and vehicle entity creation. Mods use this to intercept, modify, or extend the game's vehicle systems system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Baronz Chair 2.21 2.3 and 2.31 game versions-24785-1-1-0-1766786868 | `r6/tweaks/oranje3_baronz_chair/oranje3_baronz_chair.yaml:1` | # Game.GetVehicleSystem():EnablePlayerVehicle('Vehicle.oranje3_baronz_chair',true,false) |
| Batcycle Archive XL-14088-1-1-1715404706 | `r6/tweaks/ezio_archive_xl/batcycle_babs.yaml` | #Game.GetVehicleSystem():EnablePlayerVehicle('Vehicle.batcycle_babs', true, false) |
| Marlboro Livery-26008-1-1-1777223922 | `r6/tweaks/zzz_nutboy/zzz_NUT_void_supra_livery1.yaml` | # Game.GetVehicleSystem():EnablePlayerVehicle('Vehicle.yv_toyota_supra_ts_livery_marlboro', true, fa |
| Oranje 3 M9 Project Monowheel - 2.3 game version-21331-1-1-0-1766746627 | `r6/tweaks/m9_project/oranje3_m9_project.yaml:1` | # Game.GetVehicleSystem():EnablePlayerVehicle('Vehicle.oranje3_m9_project',true,false) |
| Oranje 3 The Wobbler Monowheel 2.3 2.31-21069-1-10-1766742137 | `r6/tweaks/monowheel/oranje3_monowheel.yaml:1` | # Game.GetVehicleSystem():EnablePlayerVehicle('Vehicle.oranje3_monowheel',true,false) |
| Oranje3 911 Turbo Trike 2.3 2.31 2.21-24365-1-1-0-1766783118 | `r6/tweaks/oranje3_johnnys_trike/oranje3_johnnys_trike.yaml:1` | # Game.GetVehicleSystem():EnablePlayerVehicle('Vehicle.oranje3_johnnys_trike',true,false) |
| Yaiba Kusanagi Persona Archive XL-13944-1-1-1712470624 | `r6/tweaks/ezio_archive_xl/yaiba_kusanagi_persona.yaml` | #Game.GetVehicleSystem():EnablePlayerVehicle('Vehicle.yaiba_kusanagi_persona', true, false) |
| void_Ferrari_Enzo-22122-1-4-1767179118 | `r6/tweaks/yellingintothevoid/void_Ferrari_Enzo.yaml:501` | # Game.GetVehicleSystem():EnablePlayerVehicle('Vehicle.yv_ferrari_enzo_black_glossy', true, false) |

*153 more mods use this pattern.*


## Related Concepts

- [Vehicle Systems](./index.md) — parent concept
- [Driving Mechanics Modification](driving-mechanics.md) — alternative approach
- [Custom Vehicle Creation](custom-vehicle-creation.md) — alternative approach
- [Vehicle Feature Addition](vehicle-features.md) — alternative approach
