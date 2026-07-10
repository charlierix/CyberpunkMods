---
type: Config
title: Outfit Configuration
description: Configuration structs for outfit slots and base slot config, plus event types for outfit updates.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/OutfitConfig.reds"
tags: ['equipment-ex', 'redscript', 'systems']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Configuration structs for outfit slots and base slot config, plus event types for outfit updates.

This concept covers 11 member declarations from 2 source file(s): OutfitConfig.reds, OutfitEvents.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Struct | `BaseSlotConfig` | fields: slotID, equipmentArea |
| Method |  `Create(slotID: TweakDBID, equipmentArea: gamedataEquipmentArea)` -> `BaseSlotConfig` | — |
| Struct | `ExtraSlotConfig` | fields: slotID, slotName, slotArea, garmentOffset, relatedSlotIDs, dependencySlotIDs, displayName |
| Method |  `Create(slotArea: CName, slotName: CName, garmentOffset: Int32, opt relatedIDs: array<TweakDBID>, opt dependencyIDs: array<TweakDBID>)` -> `ExtraSlotConfig` | — |
| Class | `OutfitConfig` | 2 methods |
| Method |  `BaseSlots()` -> `array<BaseSlotConfig>` | — |
| Method |  `OutfitSlots()` -> `array<ExtraSlotConfig>` | — |
| Event | `OutfitUpdated` extends Event | 0 methods |
| Event | `OutfitPartUpdated` extends Event | 0 methods |
| Event | `OutfitMappingUpdated` extends Event | 0 methods |
| Event | `OutfitListUpdated` extends Event | 0 methods |

# Related Concepts

- "Config consumed by [outfit state](/systems/outfit-state.md)"

# Citations

- [OutfitConfig.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/OutfitConfig.reds)
- [OutfitEvents.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/OutfitEvents.reds)
