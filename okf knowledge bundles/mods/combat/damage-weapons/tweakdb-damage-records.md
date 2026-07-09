---
type: Mechanic Pattern
title: "TweakDB Damage Records"
description: "Modifying TweakDB weapon damage records and attack values via YAML tweak files"
tags: [combat, damage, tweakdb]
timestamp: 2026-07-04T00:00:00Z
---

# TweakDB Damage Records

Modifying TweakDB weapon damage records and attack values via YAML tweak files.

## Approach

This technique involves modifying tweakdb weapon damage records and attack values via yaml tweak files. Mods use this to intercept, modify, or extend the game's damage & weapons system at specific points in the processing pipeline.

## Representative Examples

| Mod | File | Notes |
|-----|------|-------|
| Animals Cache - New Iconic Weapons-23129-1-0-3-1754808337 | `r6/tweaks/misoru_cache_animals/misoru_cache_animals_chimp.yaml:4` | audioWeaponConfiguration: audio_melee_metadata_fists_normal |
| Back Katana Clothing Set-22513-1-2-1767746257 | `r6/tweaks/s10_katanaeq_back.yaml:16` | tags: [Clothing, OuterChest, IconicWeapon, VisualHolster, Katana, Katana_E3] |
| Baronz Chair 2.21 2.3 and 2.31 game versions-24785-1-1-0-1766786868 | `r6/tweaks/oranje3_baronz_chair/oranje3_baronz_chair.yaml:5` | ############################ Weapons ##################################################### |
| Emmjay's FF NSFW Threesome Pose Pack - PM 2.3-21744-2-0-1753681489 | `r6/tweaks/emmjay_threesome_nsfw_poses/emmjay_threesome_nsfw_poses.yaml:11` | acceptedWeaponConfig: POSE_HIDE_WEAPON |
| Express Yourself - NC Pride-19880-1-0-1740804528 | `r6/tweaks/vxl_ncpride_tta/PvP_bat_rework_tta.yml` | - !append-once IconicWeapon |
| FxEffects-11366-2-0-1702367992 | `r6/tweaks/FxCombatTweaks/Fx.WeaponEffects.yaml:2` | $type: gamedataWeaponItem_Record |
| IWR - Roadkill-18647-1-0-1735344715 | `archive/pc/mod/misoru_iwr_dezerter_roadkill.archive.xl` | - base\weapons\firearms\shotgun_dual\rostovic_satara\entities\meshes\w_shotgun_dual__rostovic_satara |
| Ops-Core FAST Helmet-13557-3-4-1757020329 | `r6/tweaks/scorpiontank/scorpion_military_opscore_helmet.yaml:149` | statType: BaseStats.DamageReductionExplosion |

*297 more mods use this pattern.*


## Related Concepts

- [Damage & Weapons](./index.md) — parent concept
- [Hit Event Interception](hit-event-wrapping.md) — alternative approach
- [Custom Weapon Creation](custom-weapon-creation.md) — alternative approach
- [Damage Calculation Overrides](damage-calc-overrides.md) — alternative approach
- [Firearm Behavior Modification](firearm-behavior.md) — alternative approach
- [Melee Mechanics](melee-mechanics.md) — alternative approach
- [Explosive & AoE Damage](explosive-aoe.md) — alternative approach
