---
type: Mechanic Pattern
title: "Firearm Behavior Modification"
description: "Modifying firearm recoil, spread, firing modes, and projectile mechanics"
tags: [combat, firearms, projectiles]
timestamp: 2026-07-04T00:00:00Z
---

# Firearm Behavior Modification

Modifying firearm recoil, spread, firing modes, and projectile mechanics.

## Approach

This technique involves modifying firearm recoil, spread, firing modes, and projectile mechanics. Mods use this to intercept, modify, or extend the game's damage & weapons system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| IWR - Roadkill-18647-1-0-1735344715 | `archive/pc/mod/misoru_iwr_dezerter_roadkill.archive.xl` | - base\weapons\firearms\shotgun_dual\rostovic_satara\entities\meshes\w_shotgun_dual__rostovic_satara |
| Oranje 3 M9 Project Monowheel - 2.3 game version-21331-1-1-0-1766746627 | `r6/tweaks/m9_project/oranje3_m9_project.yaml:190` | ##------------------Standard power weapon projectile |
| Phoebe_Sai_Weapon.zip-21624-1-1-1747869840 | `r6/tweaks/phoebe/phoebe_sai_weapon.yaml` | projectileTemplateName: sai_weapon_knife |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/modules/BlackboardCache2.lua:272` | Trigger("WeaponStateChanged", weapon) |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/entities.lua:29716` | ["entity_entrigs"] = "base\\weapons\\firearms\\special\\w_special_heavy_railgun\\meshes\\w_special_h |
| Random Outfit Destruction (cp2077 v2.3)-22660-1-5-1769976819 | `ROD/bin/x64/plugins/cyber_engine_tweaks/mods/Random Outfit Destruction/init.lua:32` | " damagetrigger = "..damagetrigger, |
| Shift-22340-1-11-1-1772169176 | `bin/x64/plugins/cyber_engine_tweaks/mods/Shift/init.lua:3354` | -- For first equip: only triggers on actual weapon switches, not re-equips after locomotion |
| Simple Selective Fire-16469-1-3-1747718476 | `bin/x64/plugins/cyber_engine_tweaks/mods/SimpleSelectiveFire/init.lua:95` | isWeapFullAuto = weapRecord:PrimaryTriggerMode():Type() == gamedataTriggerMode.FullAuto -- check if  |

*55 more mods use this pattern.*


## Related Concepts

- [Damage & Weapons](./index.md) — parent concept
- [Hit Event Interception](hit-event-wrapping.md) — alternative approach
- [TweakDB Damage Records](tweakdb-damage-records.md) — alternative approach
- [Custom Weapon Creation](custom-weapon-creation.md) — alternative approach
- [Damage Calculation Overrides](damage-calc-overrides.md) — alternative approach
- [Melee Mechanics](melee-mechanics.md) — alternative approach
- [Explosive & AoE Damage](explosive-aoe.md) — alternative approach
