---
type: Mechanic Pattern
title: "Stats System"
description: "Character stat modifiers and stat pool management manipulation patterns"
tags: [systems, stats]
timestamp: 2026-07-04T00:00:00Z
---

# Stats System

Character stat modifiers and stat pool management manipulation patterns.

## Stat Modifier Injection

Injecting custom StatModifiers to alter character attributes, health, armor, and derived stats.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_chimp.yaml:49` | $type: StatModifierGroup |
| Express Yourself - NC Pride-19880-1-0-1740804528 | `r6/tweaks/vxl_ncpride_tta/PvP_bat_rework_tta.yml` | - $type: gamedataConstantStatModifier_Record |
| Mayo - High Waist Leggings 3.0 - 4K Version-17045-3-0-4-1781009369 | `r6/tweaks/mayo/mayo_hw_leggings_v3.yaml` | $type: ConstantStatModifier |
| Mayo - Lace Trim Denim Shorts - 4k Textures-28428-1-0-1-1779278219 | `r6/tweaks/mayo/lace_denim_shorts.yaml` | $type: ConstantStatModifier |
| Ops-Core FAST Helmet-13557-3-4-1757020329 | `r6/tweaks/scorpiontank/scorpion_military_opscore_helmet.yaml:23` | - $type: gamedataConstantStatModifier_Record |
| Phoebe_Sai_Weapon.zip-21624-1-1-1747869840 | `r6/tweaks/phoebe/phoebe_sai_weapon.yaml` | - $type: ConstantStatModifier |
| Ronin - New Iconic Weapon-18595-1-0-1-1740377490 | `r6/tweaks/misoru_ronin/misoru_ronin_weapon.yaml:58` | $type: gamedataStatModifierGroup_Record |
| SCOFIL - Luv's Glasses-20890-1-0-1744498194 | `r6/tweaks/Scofil1996/SCOFIL_Luv_Glasses.yaml` | $type: ConstantStatModifier |

*166 more mods use this pattern.*

## TweakDB Stat Records

Modifying TweakDB stat records and base stat values via YAML tweak files.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_chimp.yaml:49` | $type: StatModifierGroup |
| Express Yourself - NC Pride-19880-1-0-1740804528 | `r6/tweaks/vxl_ncpride_tta/PvP_bat_rework_tta.yml` | - $type: gamedataConstantStatModifier_Record |
| Mayo - High Waist Leggings 3.0 - 4K Version-17045-3-0-4-1781009369 | `r6/tweaks/mayo/mayo_hw_leggings_v3.yaml` | $type: ConstantStatModifier |
| Mayo - Lace Trim Denim Shorts - 4k Textures-28428-1-0-1-1779278219 | `r6/tweaks/mayo/lace_denim_shorts.yaml` | $type: ConstantStatModifier |
| Ops-Core FAST Helmet-13557-3-4-1757020329 | `r6/tweaks/scorpiontank/scorpion_military_opscore_helmet.yaml:23` | - $type: gamedataConstantStatModifier_Record |
| Phoebe_Sai_Weapon.zip-21624-1-1-1747869840 | `r6/tweaks/phoebe/phoebe_sai_weapon.yaml` | - $type: ConstantStatModifier |
| Ronin - New Iconic Weapon-18595-1-0-1-1740377490 | `r6/tweaks/misoru_ronin/misoru_ronin_weapon.yaml:58` | $type: gamedataStatModifierGroup_Record |
| SCOFIL - Luv's Glasses-20890-1-0-1744498194 | `r6/tweaks/Scofil1996/SCOFIL_Luv_Glasses.yaml` | $type: ConstantStatModifier |

*169 more mods use this pattern.*

## Custom Stat Systems

Creating entirely new stat types or stat systems with custom calculation logic.

### Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Immersive Relic English-30028-1-4-1780279387 | `bin/x64/plugins/cyber_engine_tweaks/mods/Immersive Relic/init.lua:381` | Game.GetStatsSystem():AddModifier(p:GetEntityID(), RPGManager.CreateStatModifier("CarryCapacity", ga |
| Sprintware-29163-1-0-0-1777156169 | `bin/x64/plugins/cyber_engine_tweaks/mods/sprintware/modules/Core.lua` | local modifier = RPGManager.CreateStatModifier( |
| jetpack | `core/gameobj_accessor.lua:301` | self.wrappers.AddModifier(self.stats, entityID, RPGManager.CreateStatModifier(gamedataStatType.Cycle |
| davidsapogee-16784-v2-25-3-1741706742 | `bin/x64/plugins/cyber_engine_tweaks/mods/DavidsApogee/martinez.lua:261` | self:CreateStatModifierGroup(self.Equip3_SMG, { false, false, {}, false, Equip3_Records, -1, '' }) |
| Better Flashlight-27721-1-32-1777321233 | `r6/scripts/BetterFlashlight/BetterFlashlight.reds:202` | this.bf_visibilityMod = RPGManager.CreateStatModifier(gamedataStatType.Visibility, gameStatModifierT |
| CustomHackingSystem v1.3.0-5091-1-3-0-1704395205 | `r6/scripts/CustomHackingSystem/Main/Quickhacks/CustomQuickhackAccessBreach.reds` | let statMod: ref<gameStatModifierData> = RPGManager.CreateStatModifier(gamedataStatType.QuickHackUpl |
| EasyTrainer-23227-Beta1-3-2-1768453258 | `EasyTrainer/bin/x64/plugins/cyber_engine_tweaks/mods/EasyTrainer/Features/Self/Abilities/AdvancedMobility.lua` | stats:AddModifier(entityID, RPGManager.CreateStatModifier(statName, gameStatModifierType.Additive, v |
| GoodFeelings-26874-1-0-5-1768609317 | `GoodFeelings/bin/x64/plugins/cyber_engine_tweaks/mods/GoodFeelings/Features/Self/Abilities/AdvancedMobility.lua` | stats:AddModifier(entityID, RPGManager.CreateStatModifier(statName, gameStatModifierType.Additive, v |

*38 more mods use this pattern.*


## Related Concepts

- [Status Effects](..//systems/status-effects.md) — related manipulation pattern
- [Damage & Weapons](..//combat/damage-weapons/index.md) — related manipulation pattern
