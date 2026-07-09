---
type: Mechanic Pattern
title: "Teleportation"
description: "Player and entity teleportation via TeleportationFacility manipulation patterns"
tags: [player, teleport]
timestamp: 2026-07-04T00:00:00Z
---

# Teleportation

Player and entity teleportation via TeleportationFacility manipulation patterns.

## Teleport Facility Usage

Using GetTeleportationFacility and TeleportPlayer for instant player relocation.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:689` | if Game.GetTeleportationFacility() and Game.GetPlayer() and Game.GetPlayer():GetWorldTransform() and |
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/Arrest.lua:83` | Game.GetTeleportationFacility():Teleport(GetPlayer(), ToVector4 { x = x, y = y, z = z, w = 1 }, |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/core.lua:390` | tp = Game.GetTeleportationFacility() |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:752` | -- Fallback: TeleportationFacility |
| GameEntityExaminerTool-14711-2-2-1757088537 | `bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua:416` | local tpFacility = GetSingleton('gameTeleportationFacility') |
| Simple_CET_Teleport_Manager-23248-1-5-1756182210 | `bin/x64/plugins/cyber_engine_tweaks/mods/Simple_CET_Teleport_Manager/init.lua:305` | local tpFacility = Game.GetTeleportationFacility() |
| Weather Switcher CHS-21957-1-7-6-patch-1778993230 | `bin/x64/plugins/cyber_engine_tweaks/mods/WeatherSwitcher/Modules/ControlPanel.lua:145` | "Game.GetTeleportationFacility():Teleport(GetPlayer(), Vector4.new(%.2f, %.2f, %.2f, %.2f), EulerAng |
| Weather Switcher Traduction FR-27952-1-6-1-1772488397 | `bin/x64/plugins/cyber_engine_tweaks/mods/WeatherSwitcher/init.lua:780` | "Game.GetTeleportationFacility():Teleport(GetPlayer(), Vector4.new(%.2f, %.2f, %.2f, %.2f), EulerAng |

*57 more mods use this pattern.*


## Related Concepts

- [Vehicle Systems](..//world/vehicle-systems/index.md) — related manipulation pattern
