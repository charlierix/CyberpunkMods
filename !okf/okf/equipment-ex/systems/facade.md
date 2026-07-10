---
type: API
title: EquipmentEx Facade
description: Public API facade abstract EquipmentEx class exposing core operations for other modules and overrides.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Facade.reds"
tags: ['equipment-ex', 'redscript', 'systems', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Public API facade abstract EquipmentEx class exposing core operations for other modules and overrides.

This concept covers 18 member declarations from 1 source file(s): Facade.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `EquipmentEx` | 17 methods |
| Method |  `Version()` -> `String` | — |
| Method |  `Activate(game: GameInstance)` | — |
| Method |  `Reactivate(game: GameInstance)` | — |
| Method |  `Deactivate(game: GameInstance)` | — |
| Method |  `EquipItem(game: GameInstance, itemID: TweakDBID)` | — |
| Method |  `EquipItem(game: GameInstance, itemID: TweakDBID, slotID: TweakDBID)` | — |
| Method |  `UnequipItem(game: GameInstance, itemID: TweakDBID)` | — |
| Method |  `UnequipSlot(game: GameInstance, slotID: TweakDBID)` | — |
| Method |  `UnequipAll(game: GameInstance)` | — |
| Method |  `PrintItems(game: GameInstance)` | — |
| Method |  `ExportItems(game: GameInstance)` | — |
| Method |  `LoadOutfit(game: GameInstance, name: CName)` | — |
| Method |  `SaveOutfit(game: GameInstance, name: String)` | — |
| Method |  `CopyOutfit(game: GameInstance, name: String, from: CName)` | — |
| Method |  `DeleteOutfit(game: GameInstance, name: CName)` | — |
| Method |  `DeleteAllOutfits(game: GameInstance)` | — |
| Method |  `PrintOutfits(game: GameInstance)` | — |

# Notable Methods

## EquipmentEx

| Method | Parameters | Returns |
|--------|------------|---------|
| `Version` | `` | `String` |
| `Activate` | `game: GameInstance` | `` |
| `Reactivate` | `game: GameInstance` | `` |
| `Deactivate` | `game: GameInstance` | `` |
| `EquipItem` | `game: GameInstance, itemID: TweakDBID` | `` |
| `EquipItem` | `game: GameInstance, itemID: TweakDBID, slotID: TweakDBID` | `` |
| `UnequipItem` | `game: GameInstance, itemID: TweakDBID` | `` |
| `UnequipSlot` | `game: GameInstance, slotID: TweakDBID` | `` |
| `UnequipAll` | `game: GameInstance` | `` |
| `PrintItems` | `game: GameInstance` | `` |
| `ExportItems` | `game: GameInstance` | `` |
| `LoadOutfit` | `game: GameInstance, name: CName` | `` |
| `SaveOutfit` | `game: GameInstance, name: String` | `` |
| `CopyOutfit` | `game: GameInstance, name: String, from: CName` | `` |
| `DeleteOutfit` | `game: GameInstance, name: CName` | `` |
| `DeleteAllOutfits` | `game: GameInstance` | `` |
| `PrintOutfits` | `game: GameInstance` | `` |

# Related Concepts

- "Checks [compatibility manager](/systems/compatibility.md) before operations"
- "Called from [inventory UI overrides](/overrides/inventory-ui.md)"

# Citations

- [Facade.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Facade.reds)
