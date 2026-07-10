---
type: Mechanic Pattern
title: "Attitude System"
description: "NPC attitude and faction relationship management manipulation patterns"
tags: [systems, attitude]
timestamp: 2026-07-04T00:00:00Z
---

# Attitude System

NPC attitude and faction relationship management manipulation patterns.

## Gang & Faction Attitude

Modifying gang/faction attitude states to change NPC hostility toward player or other factions.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/actiontemplate.lua:377` | ["attitude_group_against_entity"] = { |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:173` | -- Copies hostile attitude from original enemy to clones |
| Legion THE FIRMWARE-27399-1-1a-1771536241 | `bin/x64/plugins/cyber_engine_tweaks/mods/LEGION Firmware/init.lua:261` | local playerAttAgent = player:GetAttitudeAgent() |
| MarmurBank V-1-0-5.zip-12470-1-0-5-1749792719 | `bin/x64/plugins/cyber_engine_tweaks/mods/marmurbank/module/SpawnUtil.lua:49` | fromEnt:GetAttitudeAgent():SetAttitudeTowards( |
| Minimap Widgets-17477-3-1-5-3-1780226155 | `bin/x64/plugins/cyber_engine_tweaks/mods/Minimap Widgets/init.lua:4882` | local attitude = this.stealthMappin:GetAttitudeTowardsPlayer() |
| Appearance Menu Mod-790-2-12-5-1749642728 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/init.lua:6374` | entity:GetAttitudeAgent():SetAttitudeGroup(CName.new("friendly")) |
| Circlemap Widgets-20416-2-7-3-3-1780226074 | `bin/x64/plugins/cyber_engine_tweaks/mods/CirclemapWidgets/init.lua:4789` | local attitude = this.stealthMappin:GetAttitudeTowardsPlayer() |
| Flying Tank-16138-1-2-4-1770820062 | `bin/x64/plugins/cyber_engine_tweaks/mods/FlyingTank/Modules/hud.lua:135` | local attitude_indicator = root_widget:GetWidget(CName.new("ruler_right")):GetWidget(CName.new("valu |

*53 more mods use this pattern.*

## Dynamic Attitude Changes

Dynamically changing NPC attitudes at runtime based on game events or conditions.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/external/AIControl.lua:29` | targetPuppet:GetAttitudeAgent():SetAttitudeGroup(friendPuppet:GetAttitudeAgent():GetAttitudeGroup()) |
| EnemyMultipier-27637-1-0-1771338458 | `bin/x64/plugins/cyber_engine_tweaks/mods/EnemyMultiplier/init.lua:177` | local function GetAttitudeGroup(entity) |
| MarmurBank V-1-0-5.zip-12470-1-0-5-1749792719 | `bin/x64/plugins/cyber_engine_tweaks/mods/marmurbank/module/SpawnUtil.lua:49` | fromEnt:GetAttitudeAgent():SetAttitudeTowards( |
| Appearance Menu Mod-790-2-12-5-1749642728 | `bin/x64/plugins/cyber_engine_tweaks/mods/AppearanceMenuMod/init.lua:6374` | entity:GetAttitudeAgent():SetAttitudeGroup(CName.new("friendly")) |
| CombatArena-Vortex.zip-27580-0-2-1771142680 | `r6/scripts/CombatArena/arena_spawner.reds:334` | attAgent.SetAttitudeTowards(player.GetAttitudeAgent(), EAIAttitude.AIA_Hostile); |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/module/SpawnUtil.lua:71` | fromEnt:GetAttitudeAgent():SetAttitudeTowards( |
| NightCityEstate V-1-1-0.zip-12857-1-1-0-1771081334 | `bin/x64/plugins/cyber_engine_tweaks/mods/NCestate/module/SpawnUtil.lua:49` | fromEnt:GetAttitudeAgent():SetAttitudeTowards( |
| Revengers V-2-0-3.zip-12276-2-0-3-1775461203 | `bin/x64/plugins/cyber_engine_tweaks/mods/revengers/module/SpawnUtil.lua:59` | fromEnt:GetAttitudeAgent():SetAttitudeTowards( |

*30 more mods use this pattern.*


## Related Concepts

- [NPCs & Puppets](..//world/npcs.md) — related manipulation pattern
