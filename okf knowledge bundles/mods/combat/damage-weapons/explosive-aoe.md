---
type: Mechanic Pattern
title: "Explosive & AoE Damage"
description: "Creating or modifying explosive damage, AoE effects, and blast radius mechanics"
tags: [combat, explosives, aoe]
timestamp: 2026-07-04T00:00:00Z
---

# Explosive & AoE Damage

Creating or modifying explosive damage, AoE effects, and blast radius mechanics.

## Approach

This technique involves creating or modifying explosive damage, aoe effects, and blast radius mechanics. Mods use this to intercept, modify, or extend the game's damage & weapons system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_stampede.yaml:104` | - !remove ExplosivePowerWeapon # remove explosive tag |
| Cyberscript Core-6475-5-1-4-1747724577 | `bin/x64/plugins/cyber_engine_tweaks/mods/cyberscript/mod/data/fact.lua:1527` | [0x0000001E49695215] = { id = "Items.GrenadeIncendiaryRegular", name = "CHAR INCENDIARY GRENADE", ki |
| grappling_hook | `init.lua:169` | unlockType = CreateEnum("shotgun", "knife", "silencer", "grenade", "weapon_mod", "clothes", "money") |
| PLR2.0-6925-2-01-1689771887 | `bin/x64/plugins/cyber_engine_tweaks/mods/PLR2.0/modules/Native Settings Integration.lua:799` | nativeSettings.addRangeFloat("/PLR/SpecialRounds", "UNCOMMON EXPLOSIVE ROUND DAMAGE VALUE - BY LEVEL |
| CustomHackingSystem v1.3.0-5091-1-3-0-1704395205 | `r6/scripts/CustomHackingSystem/CodewareExtensions/UI/Atlas/InkAtlasPaths.reds:4283` | AtlasDamageTypesIcons.GetIconGrenadePath(), |
| EasyTrainer-23227-Beta1-3-2-1768453258 | `EasyTrainer/bin/x64/plugins/cyber_engine_tweaks/mods/EasyTrainer/Features/Items/ItemModRecipes.lua:29` | "Recipe_ExplosiveDamageRound", |
| FieldItems V-2-0-2.zip-12367-2-0-2-1775478370 | `bin/x64/plugins/cyber_engine_tweaks/mods/fielditems/data/ItemList.lua:2826` | "Items.ExplosiveDamageRound", |
| GoodFeelings-26874-1-0-5-1768609317 | `GoodFeelings/bin/x64/plugins/cyber_engine_tweaks/mods/GoodFeelings/Features/Items/ItemModRecipes.lua:29` | "Recipe_ExplosiveDamageRound", |

*41 more mods use this pattern.*


## Related Concepts

- [Damage & Weapons](./index.md) — parent concept
- [Hit Event Interception](hit-event-wrapping.md) — alternative approach
- [TweakDB Damage Records](tweakdb-damage-records.md) — alternative approach
- [Custom Weapon Creation](custom-weapon-creation.md) — alternative approach
- [Damage Calculation Overrides](damage-calc-overrides.md) — alternative approach
- [Firearm Behavior Modification](firearm-behavior.md) — alternative approach
- [Melee Mechanics](melee-mechanics.md) — alternative approach
