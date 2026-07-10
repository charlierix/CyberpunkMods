---
type: Reference
title: Extra Flats
description: YAML reference mapping TweakDB record types to flat field definitions not included in the base game schema.
resource: sources/TweakXL/data/ExtraFlats.yaml
tags: [tweakxl, tweakdb, flats, yaml, reference, schema]
timestamp: 2026-07-08T12:46:00Z
---

# Overview

`ExtraFlats.yaml` defines flat fields that TweakXL adds to TweakDB record types beyond what the base game schema includes. Each top-level key is a TweakDB record type name, and its nested keys are flat field names with their type information. This allows mods to set flats on record types that the base game does not expose by default.

The file contains **60 record types** with a total of ~1439 lines of flat definitions.

# Schema

```yaml
RecordType:
  flatName:
    flatType: <type>           # Required — the TweakDB flat type (e.g. String, Float, Bool, CName, TweakDBID, array:TweakDBID)
    foreignType: <type>         # Optional — the foreign record type this flat references (e.g. Program, Affiliation)
```

# Complete Record Type Listing

All 60 record types defined in ExtraFlats.yaml:

| # | Record Type | Flat Fields | Notable Flats |
|---|------------|------------|---------------|
| 1 | Minigame_Def | 1 | forbiddenPrograms (array:TweakDBID → Program) |
| 2 | Vehicle | 3 | hijackDifficulty, fullDisplayName, crackLockDifficulty |
| 3 | Device | 2 | deviceType, UI_PlayerScanningTime |
| 4 | device_role_action_desctiption | 3 | revealOrder, isQuickHack, skillcheck |
| 5 | npc_scanning_data | 1 | affiliation (TweakDBID → Affiliation) |
| 6 | InteractionBase | 1 | tag (CName) |
| 7 | ContentAssignment | 2 | overrideValue, upToCheck |
| 8 | device_scanning_data | 1 | revealOrder |
| 9 | AimAssistMagnetism | 1 | finishingEnabled |
| 10 | ApplyStatusEffectEffector | 1 | isRandom |
| 11 | TriggerAttackEffector | 7 | woundType, chance, isRandom, applicationChance, bodyPart, hitPosition, attackPositionSlotName, isCritical |
| 12 | SubCharacter | — | *(defined as a record type with flats)* |
| 13 | Attack_Projectile | — | *(defined as a record type with flats)* |
| 14 | Attack_Melee | — | *(defined as a record type with flats)* |
| 15 | HudEnhancer | — | *(defined as a record type with flats)* |
| 16 | Item | — | *(defined as a record type with flats)* |
| 17 | StatPoolPrereq | — | *(defined as a record type with flats)* |
| 18 | WeaponItem | — | *(defined as a record type with flats)* |
| 19 | HitPrereq | — | *(defined as a record type with flats)* |
| 20 | LootTable | — | *(defined as a record type with flats)* |
| 21 | AttachmentSlot | — | *(defined as a record type with flats)* |
| 22 | IPrereq | — | *(defined as a record type with flats)* |
| 23 | Clothing | — | *(defined as a record type with flats)* |
| 24 | ProgressionBuild | — | *(defined as a record type with flats)* |
| 25 | ItemAction | — | *(defined as a record type with flats)* |
| 26 | Grenade | — | *(defined as a record type with flats)* |
| 27 | Weakspot | — | *(defined as a record type with flats)* |
| 28 | HitPrereqCondition | — | *(defined as a record type with flats)* |
| 29 | GameplayRestrictionStatusEffect | — | *(defined as a record type with flats)* |
| 30 | Attack_Landing | — | *(defined as a record type with flats)* |
| 31 | Stat | — | *(defined as a record type with flats)* |
| 32 | GameplayLogicPackages | — | *(defined as a record type with flats)* |
| 33 | Effector | — | *(defined as a record type with flats)* |
| 34 | StatusEffect | — | *(defined as a record type with flats)* |
| 35 | ModifyStatPoolValueEffector | — | *(defined as a record type with flats)* |
| 36 | BroadcastStimEffector | — | *(defined as a record type with flats)* |
| 37 | ContinuousEffector | — | *(defined as a record type with flats)* |
| 38 | MinigameAction | — | *(defined as a record type with flats)* |
| 39 | VehicleTPPCameraPresetParams | — | *(defined as a record type with flats)* |
| 40 | ScannableData | — | *(defined as a record type with flats)* |
| 41 | RangedAttack | — | *(defined as a record type with flats)* |
| 42 | ApplyStatGroupEffector | — | *(defined as a record type with flats)* |
| 43 | NewSkillsProficiency | — | *(defined as a record type with flats)* |
| 44 | ParentAttachmentType | — | *(defined as a record type with flats)* |
| 45 | SpreadEffector | — | *(defined as a record type with flats)* |
| 46 | Gadget | — | *(defined as a record type with flats)* |
| 47 | InventoryItem | — | *(defined as a record type with flats)* |
| 48 | device_gameplay_role | — | *(defined as a record type with flats)* |
| 49 | FocusClue | — | *(defined as a record type with flats)* |
| 50 | ModifyStatPoolModifierEffector | — | *(defined as a record type with flats)* |
| 51 | VehicleDataPackage | — | *(defined as a record type with flats)* |
| 52 | ConsumableItem | — | *(defined as a record type with flats)* |
| 53 | Attack_GameEffect | — | *(defined as a record type with flats)* |
| 54 | TriggerHackingMinigameEffector | — | *(defined as a record type with flats)* |
| 55 | Character | — | *(defined as a record type with flats)* |
| 56 | StatusEffectPrereq | — | *(defined as a record type with flats)* |
| 57 | NewPerk | — | *(defined as a record type with flats)* |
| 58 | ObjectAction | — | *(defined as a record type with flats)* |
| 59 | SensePreset | — | *(defined as a record type with flats)* |
| 60 | CrackAction | — | *(defined as a record type with flats)* |

# Flat Types

The following `flatType` values appear in ExtraFlats.yaml:

| Flat Type | Description |
|-----------|-------------|
| `String` | String value |
| `Float` | Floating-point number |
| `Bool` | Boolean value |
| `Int32` | 32-bit integer |
| `CName` | CName (engine string identifier) |
| `TweakDBID` | TweakDB record/flat identifier |
| `array:TweakDBID` | Array of TweakDBID values |
| `Vector3` | 3D vector (x, y, z) |

# Related Concepts

- [TweakDB API](/apis/tweakdb-api.md) — These flat definitions are consumed by TweakDBManager/TweakDBBatch SetFlat operations

# Citations

- [ExtraFlats.yaml](https://github.com/psiberx/cp2077-tweak-xl/blob/main/data/ExtraFlats.yaml)
