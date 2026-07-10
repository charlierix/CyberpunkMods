---
type: Mechanic Pattern
title: "Custom Vehicle Creation"
description: "Creating entirely new vehicle models with custom appearances, stats, and components"
tags: [world, vehicles, custom]
timestamp: 2026-07-04T00:00:00Z
---

# Custom Vehicle Creation

Creating entirely new vehicle models with custom appearances, stats, and components.

## Approach

This technique involves creating entirely new vehicle models with custom appearances, stats, and components. Mods use this to intercept, modify, or extend the game's vehicle systems system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua:451` | TweakDB:SetFlat(vehicle:GetRecord():GetID().value .. ".headlightColor", applycolorTbd) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/core.lua:576` | function TweakManager() -- Load vehicles and change some TweakDB |
| GameEntityExaminerTool-14711-2-2-1757088537 | `bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua:353` | local targetVehicleTweakDbId = TweakDBID.new(tweakID1) |
| Legion THE FIRMWARE-27399-1-1a-1771536241 | `bin/x64/plugins/cyber_engine_tweaks/mods/LEGION Firmware/init.lua:535` | self.legionRecord = TweakDBID.new("Vehicle.dwa_delorean_ii") |
| Manual Transmission-15562-1-1-7-1753008511 | `bin/x64/plugins/cyber_engine_tweaks/mods/ManualTransmission/modules/utils.lua:20` | local vehicleRecords = TweakDB:GetRecords("gamedataVehicle_Record") |
| Minimap Widgets-17477-3-1-5-3-1780226155 | `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/init.lua:4646` | return MappinUIProfile.Create('base\\gameplay\\gui\\widgets\\minimap\\minimap_poi_mappin.inkwidget', |
| Mod My Traffic-24470-1-3-1759967698 | `bin/x64/plugins/cyber_engine_tweaks/mods/Mod My Traffic/init.lua:186` | local vehicleRecords = TweakDB:GetRecords("gamedataVehicle_Record") |
| No More Duplicate Vehicles-24064-1-0-1-1757288024 | `bin/x64/plugins/cyber_engine_tweaks/mods/No More Duplicate Vehicles/init.lua:206` | local vehicleRecords = TweakDB:GetRecords("gamedataVehicle_Record") |

*97 more mods use this pattern.*


## Related Concepts

- [Vehicle Systems](./index.md) — parent concept
- [Vehicle Spawning](vehicle-spawning.md) — alternative approach
- [Driving Mechanics Modification](driving-mechanics.md) — alternative approach
- [Vehicle Feature Addition](vehicle-features.md) — alternative approach
