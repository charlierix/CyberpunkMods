---
type: Mechanic Pattern
title: "Melee Mechanics"
description: "Modifying melee weapon attack patterns, combo systems, and close-combat mechanics"
tags: [combat, melee, combos]
timestamp: 2026-07-04T00:00:00Z
---

# Melee Mechanics

Modifying melee weapon attack patterns, combo systems, and close-combat mechanics.

## Approach

This technique involves modifying melee weapon attack patterns, combo systems, and close-combat mechanics. Mods use this to intercept, modify, or extend the game's damage & weapons system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_chimp.yaml:4` | audioWeaponConfiguration: audio_melee_metadata_fists_normal |
| Express Yourself - NC Pride-19880-1-0-1740804528 | `r6/tweaks/vxl_ncpride_tta/PvP_bat_rework_tta.yml` | slot: AttachmentSlots.IconicMeleeWeaponMod1 |
| FxEffects-11366-2-0-1702367992 | `r6/tweaks/FxCombatTweaks/Fx.WeaponEffects.yaml:166` | - base\fx\weapons\melee\mantisblades\mtb_slash_character_flesh.effect |
| Ops-Core FAST Helmet-13557-3-4-1757020329 | `r6/tweaks/scorpiontank/scorpion_military_opscore_helmet.yaml:161` | statType: BaseStats.DamageReductionMelee |
| Phoebe_Sai_Weapon.zip-21624-1-1-1747869840 | `archive/pc/mod/phoebe_sai_weapon.archive.xl` | - phoebe\weapons\melee\sai\ops\phoebe_sai_weapon.csv |
| Zenitex Assault Helmet | `r6/tweaks/scorpiontank/scorpion_zenitex_assault_helmet.yaml:206` | statType: BaseStats.DamageReductionMelee |
| Zenitex Ballistic Mask-12422-4-1-1780618307 | `r6/tweaks/scorpiontank/scorpion_zenitex_ballistic_mask.yaml:196` | statType: BaseStats.DamageReductionMelee |
| Arrest-22114-1-0-4-1755437024 | `Arrest/r6/tweaks/Campo Orta/Items.Preset_Ashura_Twitch.yaml:11` | fxPackageQuickMelee: WeaponFxPackage.QuickMeleeFxPackage |

*90 more mods use this pattern.*


## Related Concepts

- [Damage & Weapons](./index.md) — parent concept
- [Hit Event Interception](hit-event-wrapping.md) — alternative approach
- [TweakDB Damage Records](tweakdb-damage-records.md) — alternative approach
- [Custom Weapon Creation](custom-weapon-creation.md) — alternative approach
- [Damage Calculation Overrides](damage-calc-overrides.md) — alternative approach
- [Firearm Behavior Modification](firearm-behavior.md) — alternative approach
- [Explosive & AoE Damage](explosive-aoe.md) — alternative approach
