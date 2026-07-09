---
type: Mechanic Pattern
title: "Vehicle Feature Addition"
description: "Adding vehicle features like radio, lights, horn, turbo, and interactive components"
tags: [world, vehicles, features]
timestamp: 2026-07-04T00:00:00Z
---

# Vehicle Feature Addition

Adding vehicle features like radio, lights, horn, turbo, and interactive components.

## Approach

This technique involves adding vehicle features like radio, lights, horn, turbo, and interactive components. Mods use this to intercept, modify, or extend the game's vehicle systems system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua:676` | ['VehicleRadioPopupGameController'] = { |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua:412` | or not vehicle:GetVehicleComponent() |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/init.lua:515` | ObserveBefore("VehicleSummonWidgetGameController", "OnVehicleRadioSongChanged", function(_, evt) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameSession.lua:691` | ['VehicleRadioPopupGameController'] = { |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua:682` | ['VehicleRadioPopupGameController'] = { |
| Equipment-Ex unlocker-11444-2-1-1703019878 | `bin/x64/plugins/cyber_engine_tweaks/mods/Equipment-EX Unlocker/libs/GameSession.lua:676` | ['VehicleRadioPopupGameController'] = { |
| GameEntityExaminerTool-14711-2-2-1757088537 | `bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua:331` | Game.GetTargetingSystem():GetComponentClosestToCrosshair(Game.GetPlayer(), nil):GetEntity():GetVehic |
| Improved Neon Rims Controls - CET and UI only-5622-2-1-0-1685232197 | `bin/x64/plugins/cyber_engine_tweaks/mods/DWN_ToggleNeonRims/modules/neonControl.lua` | mod.scriptObjects.vehicleController = Game.GetMountedVehicle(GetPlayer()):GetVehicleComponent():GetV |

*152 more mods use this pattern.*


## Related Concepts

- [Vehicle Systems](./index.md) — parent concept
- [Vehicle Spawning](vehicle-spawning.md) — alternative approach
- [Driving Mechanics Modification](driving-mechanics.md) — alternative approach
- [Custom Vehicle Creation](custom-vehicle-creation.md) — alternative approach
