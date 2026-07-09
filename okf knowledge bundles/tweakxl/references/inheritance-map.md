---
type: Reference
title: Inheritance Map
description: YAML reference mapping TweakDB record names to their inherited child record names for inheritance resolution.
resource: sources/TweakXL/data/InheritanceMap.yaml
tags: [tweakxl, tweakdb, inheritance, yaml, reference, mapping]
timestamp: 2026-07-08T12:46:00Z
---

# Overview

`InheritanceMap.yaml` maps TweakDB record names to arrays of record names that inherit from them. This mapping is used by TweakXL to resolve inheritance chains when performing `CloneRecord` operations — ensuring that cloned records maintain correct inheritance relationships and that flat modifications propagate to child records.

The file contains **8,492 entries** across ~69,300 lines, covering items, characters, attacks, conditions, cameras, actions, and other TweakDB record categories.

# Schema

```yaml
RecordName:
  - ChildRecordName1
  - ChildRecordName2
  - ChildRecordName3
```

Each top-level key is a TweakDB record ID (using dot notation, e.g. `Items.BasePistol`). The value is a list of record IDs that inherit from the parent record.

# Record Categories

The 8,492 entries span multiple TweakDB domains, identifiable by their key prefixes:

| Prefix | Domain | Example |
|--------|--------|---------|
| `Items.` | Game items (weapons, armor, consumables) | `Items.BaseDeckTier5` → `[Items.FuyutsuiTinkererLegendaryMKIII, ...]` |
| `Character.` | NPC character records | `Character.AnimalsPrimaryHandgunPool` → `[Character.animals_bouncer2_ranged2_burya_mb_inline1, ...]` |
| `Attack_` / `MeleeActions.` / `RangedAttack` | Attack definitions | `MeleeActions.Combo02MeleeAttackLight03RecoverMissDefinition` |
| `Condition.` | Gameplay conditions | `Condition.StrafeCooldownHit` |
| `Prereqs.` | Prerequisite records | `Prereqs.PostProcessHitTriggered` |
| `Camera.` | Camera presets | `Camera.VehicleTPP_4w_Shion_High_Medium` |
| `UIMaps.` | UI map records | `UIMaps.Inhaler` → `[UIMaps.Con_Inhaler]` |
| `Weakspots.` | Weakspot definitions | `Weakspots.Engine_Zetatech_Av_Weakspot_Base` |
| `StrongArmsAttacks.` | Strong arms attack definitions | `StrongArmsAttacks.OnePunchSpecialAttack` |
| `NetrunnerActions.` | Netrunner action records | `NetrunnerActions.CoverHackAction` |
| `DashAndDodgeActions.` | Dodge action definitions | `DashAndDodgeActions.GrenadeDodgeKerenzikovLeftFrontDefinition` |
| `BaseStats.` | Base stat modifiers | `BaseStats.SmartGunSpiralRampDistanceEndModifier` |

# Sample Entries

```yaml
Items.EmptySlotsHelmet_Intrinsic:
  - Items.Helmet_04_old_01
  - Items.Helmet_01_basic_01
  - Items.Helmet_01_rich_01
  - Items.Helmet_02_old_01
  - Items.Helmet_02_basic_04
  - Items.Helmet_02_old_02
  - Items.Helmet_02_basic_02
  - Items.Helmet_04_rich_02
  - Items.Helmet_02_rich_04
  - Items.Helmet_02_rich_02

Items.AdvancedKiroshiOpticsSensorRarePlus:
  - Items.AdvancedKiroshiOptics_Tutorial_RarePlus

UIMaps.Inhaler:
  - UIMaps.Con_Inhaler
```

# Usage

This map is used internally by TweakXL when processing declarative tweaks that involve record inheritance. When a mod clones a record via the [TweakDB API](/apis/tweakdb-api.md), TweakXL consults this map to determine which child records should inherit the clone's properties.

# Related Concepts

- [TweakDB API](/apis/tweakdb-api.md) — CloneRecord operations use this map for inheritance resolution
- [Extra Flats](/references/extra-flats.md) — Defines flat fields on the record types referenced here

# Citations

- [InheritanceMap.yaml](https://github.com/psiberx/cp2077-tweak-xl/blob/main/data/InheritanceMap.yaml)
