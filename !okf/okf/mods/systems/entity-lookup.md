---
type: Mechanic Pattern
title: "Entity Lookup"
description: "Finding entities by ID and entity reference resolution manipulation patterns"
tags: [systems, entity, lookup]
timestamp: 2026-07-04T00:00:00Z
---

# Entity Lookup

Finding entities by ID and entity reference resolution manipulation patterns.

## Entity ID Resolution

Finding entities by EntityID using FindEntityByID and GetEntity for targeted manipulation.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/external/GameSession.lua:748` | if self:GetEntityID().hash ~= 1ULL then |
| 3D World Map Explorer-21208-1-5-0-1776474737 | `bin/x64/plugins/cyber_engine_tweaks/mods/3DWorldMapExplorer/init.lua:1212` | worldMapEntityPreview = this:GetEntityPreview() |
| Appearance Creator Mod-10795-1-0-1-1699493978 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceCreatorMod/init.lua:120` | if ACM.target and not Game.FindEntityByID(ACM.target.entityID) then |
| Arrest-22114-1-0-4-1755437024 | `Arrest/bin/x64/plugins/cyber_engine_tweaks/mods/Arrest/Modules/Arrest.lua:104` | Game.GetStatusEffectSystem():ApplyStatusEffect(GetPlayer():GetEntityID(), |
| ClockWidget-20572-1-6-1781010500 | `bin/x64/plugins/cyber_engine_tweaks/mods/ClockWidget/init.lua:175` | local psmBB = bbSystem:GetLocalInstanced(player:GetEntityID(), GetAllBlackboardDefs().PlayerStateMac |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/GameSession.lua:763` | if self:GetEntityID().hash ~= 1ULL then |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:324` | local function GetEntityIdString(entity) |
| Enterable Interiors 2.6.0-13209-2-6-0-1763996310 | `bin/x64/plugins/cyber_engine_tweaks/mods/Enterable Interiors/external/GameSession.lua:754` | if self:GetEntityID().hash ~= 1ULL then |

*298 more mods use this pattern.*


## Related Concepts

- [Entity Spawning](..//systems/entity-spawning.md) — related manipulation pattern
