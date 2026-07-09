---
type: System
title: Outfit Slot Matcher
description: TweakDB record slot mapping and matching system for outfit slot configuration.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Tweaks/OutfitSlotMatcher.reds"
tags: ['equipment-ex', 'redscript', 'tweaks', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

TweakDB record slot mapping and matching system for outfit slot configuration.

This concept covers 15 member declarations from 1 source file(s): Tweaks/OutfitSlotMatcher.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Struct | `RecordSlotMapping` | fields: slotID, recordIDs |
| Struct | `EntityNameSlotMapping` | fields: slotID, entityName |
| Struct | `AppearanceNameSlotMapping` | fields: slotID, appearanceTokens |
| Struct | `EquipmentAreaSlotMapping` | fields: slotID, equipmentAreas |
| Struct | `PriceModifierSlotMapping` | fields: slotID, priceModifiers |
| Struct | `SlotMappingMatch` | fields: slotID, score |
| Class | `OutfitSlotMatcher` | 8 methods |
| Method |  `MapRecords(mappings: array<RecordSlotMapping>)` | — |
| Method |  `MapEntities(mappings: array<EntityNameSlotMapping>)` | — |
| Method |  `MapAppearances(mappings: array<AppearanceNameSlotMapping>)` | — |
| Method |  `MapEquipmentAreas(mappings: array<EquipmentAreaSlotMapping>)` | — |
| Method |  `MapPrices(mappings: array<PriceModifierSlotMapping>)` | — |
| Method |  `IgnoreEntities(ignores: array<CName>)` | — |
| Method |  `Match(item: ref<Clothing_Record>)` -> `TweakDBID` | — |
| Method |  `Create()` -> `ref<OutfitSlotMatcher>` | — |

# Notable Methods

## OutfitSlotMatcher

| Method | Parameters | Returns |
|--------|------------|---------|
| `MapRecords` | `mappings: array<RecordSlotMapping>` | `` |
| `MapEntities` | `mappings: array<EntityNameSlotMapping>` | `` |
| `MapAppearances` | `mappings: array<AppearanceNameSlotMapping>` | `` |
| `MapEquipmentAreas` | `mappings: array<EquipmentAreaSlotMapping>` | `` |
| `MapPrices` | `mappings: array<PriceModifierSlotMapping>` | `` |
| `IgnoreEntities` | `ignores: array<CName>` | `` |
| `Match` | `item: ref<Clothing_Record>` | `TweakDBID` |
| `Create` | `` | `ref<OutfitSlotMatcher>` |

# Related Concepts

- "Works with [outfit tweak helper](/tweaks/helper.md) for record operations"

# Citations

- [Tweaks/OutfitSlotMatcher.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Tweaks/OutfitSlotMatcher.reds)
