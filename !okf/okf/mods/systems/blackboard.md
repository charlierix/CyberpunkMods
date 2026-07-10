---
type: Mechanic Pattern
title: "Blackboard System"
description: "Game state blackboard definitions and data sharing manipulation patterns"
tags: [systems, blackboard]
timestamp: 2026-07-04T00:00:00Z
---

# Blackboard System

Game state blackboard definitions and data sharing manipulation patterns.

## Blackboard Read/Write

Reading and writing game state variables via GetBlackboardSystem and BlackboardDef definitions.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameHUD.lua` | local blackboardDefs = Game.GetAllBlackboardDefs() |
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/Arrest.lua:130` | Game.GetBlackboardSystem():Get(GetAllBlackboardDefs().UI_Notifications):SetVariant( |
| Better Vehicle Radio-8864-2-3-1716736144 | `bin/x64/plugins/cyber_engine_tweaks/mods/better_vehicle_radio/modules/util.lua` | local ui_notifications_def = GetAllBlackboardDefs().UI_Notifications |
| ClockWidget-20572-1-6-1781010500 | `bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua:174` | local bbSystem = Game.GetBlackboardSystem() |
| CrowdScheduler-30232-0-92-1780508208 | `bin/x64/plugins/cyber_engine_tweaks/mods/CrowdScheduler/init.lua:161` | local defs = Game.GetAllBlackboardDefs() |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameSession.lua:132` | local blackboardDefs = Game.GetAllBlackboardDefs() |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:1355` | local blackboardDefs = Game.GetAllBlackboardDefs() |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua:132` | local blackboardDefs = Game.GetAllBlackboardDefs() |

*248 more mods use this pattern.*


## Related Concepts

- [World State](..//systems/world-state.md) — related manipulation pattern
- [Quest System](..//systems/quest-system.md) — related manipulation pattern
