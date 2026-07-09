---
type: Mechanic Pattern
title: "Time Dilation"
description: "Game time scale manipulation including Sandevistan effects patterns"
tags: [systems, time, dilation]
timestamp: 2026-07-04T00:00:00Z
---

# Time Dilation

Game time scale manipulation including Sandevistan effects patterns.

## Sandevistan Time Manipulation

Creating Sandevistan-like slow-motion effects via GetTimeSystem and timeDilation properties.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua:139` | local tutorialActive = Game.GetTimeSystem():IsTimeDilationActive('UI_TutorialPopup') |
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:226` | if ModLogger.userSettings.includeGameTime and Game.GetTimeSystem() then |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua:161` | S.hours = Game.GetTimeSystem():GetGameTime():Hours() |
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/gamedataStatPoolType.lua` | SandevistanCharge = 34, |
| ClockWidget-20572-1-6-1781010500 | `bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua:285` | local gameTime = Game.GetTimeSystem():GetGameTime() |
| CrowdScheduler-30232-0-92-1780508208 | `bin/x64/plugins/cyber_engine_tweaks/mods/CrowdScheduler/init.lua:70` | local ts = Game.GetTimeSystem() |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/fact.lua:1245` | [0x000000167BDFF0E5] = { id = "Items.SandevistanC2MK1", name = "DYNALAR SANDEVISTAN MK.1", kind = "C |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:766` | TimeDilationHelper.SetIndividualTimeDilation(handle, CName.new("radialMenu"), 0.0) |

*225 more mods use this pattern.*

## Day/Night Cycle Modification

Modifying day/night cycle speed, game time progression, and clock mechanics.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/modules/DerivedState.lua:226` | local gameTime = timeSystem:GetGameTime() |
| A CET Mod Logger-23208-1-5-1755463327 | `bin/x64/plugins/cyber_engine_tweaks/mods/aCETModLogger/init.lua:226` | if ModLogger.userSettings.includeGameTime and Game.GetTimeSystem() then |
| Adaptive Traffic Headlights-24020-2-1-0-1758756478 | `bin/x64/plugins/cyber_engine_tweaks/mods/AdaptiveTrafficHeadlights/init.lua:161` | S.hours = Game.GetTimeSystem():GetGameTime():Hours() |
| ClockWidget-20572-1-6-1781010500 | `bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua:285` | local gameTime = Game.GetTimeSystem():GetGameTime() |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/modules/scripting.lua:831` | --Game.GetTimeSystem():SetTimeDilation("cyberscript", 0) |
| GameEntityExaminerTool-14711-2-2-1757088537 | `bin/x64/plugins/cyber_engine_tweaks/mods/GameEntityExaminerTool/init.lua:617` | ImGui.Text(' /   Game Time: ' .. tostring(Game.GetTimeSystem():GetGameTime():Hours()) .. ':' .. tost |
| Immersive Meditations - Dark Future version-23336-4-0-1767955577 | `bin/x64/plugins/cyber_engine_tweaks/mods/Dedrameditate_mod/init.lua:94` | local day = Game.GetTimeSystem():GetGameTime():Days() |
| Immersive Relic English-30028-1-4-1780279387 | `bin/x64/plugins/cyber_engine_tweaks/mods/Immersive Relic/init.lua:341` | local days = Game.GetTimeSystem():GetGameTime():Days() |

*95 more mods use this pattern.*


## Related Concepts

- [Damage & Weapons](..//combat/damage-weapons/index.md) — related manipulation pattern
