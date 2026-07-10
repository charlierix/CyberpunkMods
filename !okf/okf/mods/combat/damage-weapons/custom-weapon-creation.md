---
type: Mechanic Pattern
title: "Custom Weapon Creation"
description: "Creating new weapon items via TweakDB records with custom stats, appearances, and attachments"
tags: [combat, weapons, tweakdb]
timestamp: 2026-07-04T00:00:00Z
---

# Custom Weapon Creation

Creating new weapon items via TweakDB records with custom stats, appearances, and attachments.

## Approach

This technique involves creating new weapon items via tweakdb records with custom stats, appearances, and attachments. Mods use this to intercept, modify, or extend the game's damage & weapons system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_chimp.yaml:42` | itemPartPreset: Items.Misoru_ChimpWeaponMod # adds iconic mod to weapon |
| Baronz Chair 2.21 2.3 and 2.31 game versions-24785-1-1-0-1766786868 | `r6/tweaks/oranje3_baronz_chair/oranje3_baronz_chair.yaml:8` | item: oranje3_baronz_chair_Item_Power_Weapon_Left_C |
| Express Yourself - NC Pride-19880-1-0-1740804528 | `r6/tweaks/vxl_ncpride_tta/PvP_bat_rework_tta.yml` | $base: Items.IconicWeaponModBase #Items.IconicMeleeWeaponModBase? |
| FxEffects-11366-2-0-1702367992 | `r6/tweaks/FxCombatTweaks/Fx.WeaponEffects.yaml:2` | $type: gamedataWeaponItem_Record |
| Oranje 3 M9 Project Monowheel - 2.3 game version-21331-1-1-0-1766746627 | `r6/tweaks/m9_project/oranje3_m9_project.yaml:116` | $base: Items.Vehicle_Power_Weapon_Left_C |
| Phoebe_Sai_Weapon.zip-21624-1-1-1747869840 | `r6/tweaks/phoebe/phoebe_sai_weapon.yaml` | Items.sai_weapon_mod_ability: |
| Ronin - New Iconic Weapon-18595-1-0-1-1740377490 | `r6/tweaks/misoru_ronin/misoru_ronin_weapon.yaml:4` | blueprint: Items.Iconic_Ranged_Weapon_NoAttachments_Blueprint |
| 0-Engine Pure CET-27967-0-17-2-1773872517 | `bin/x64/plugins/cyber_engine_tweaks/mods/0-Engine/modules/DerivedState.lua:86` | -- Prefer WeaponType if available, otherwise fall back to ItemType (best effort). |

*146 more mods use this pattern.*


## Related Concepts

- [Damage & Weapons](./index.md) — parent concept
- [Hit Event Interception](hit-event-wrapping.md) — alternative approach
- [TweakDB Damage Records](tweakdb-damage-records.md) — alternative approach
- [Damage Calculation Overrides](damage-calc-overrides.md) — alternative approach
- [Firearm Behavior Modification](firearm-behavior.md) — alternative approach
- [Melee Mechanics](melee-mechanics.md) — alternative approach
- [Explosive & AoE Damage](explosive-aoe.md) — alternative approach
