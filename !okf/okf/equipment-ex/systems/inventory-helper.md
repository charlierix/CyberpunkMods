---
type: System
title: Inventory Helper
description: ScriptableSystem providing inventory query and manipulation utilities for equipment slot operations.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/InventoryHelper.reds"
tags: ['equipment-ex', 'redscript', 'systems']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

ScriptableSystem providing inventory query and manipulation utilities for equipment slot operations.

This concept covers 11 member declarations from 1 source file(s): InventoryHelper.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `InventoryHelper` extends ScriptableSystem | 10 methods |
| Method |  `OnPlayerAttach(request: ref<PlayerAttachRequest>)` | — |
| Method |  `IsValidItem(itemID: ItemID)` -> `Bool` | — |
| Method |  `GetStash()` -> `wref<Stash>` | — |
| Method |  `AddStash(stash: ref<Stash>)` | — |
| Method |  `GetStashItems(out items: array<InventoryItemData>)` | — |
| Method |  `GetPlayerItems(out items: array<InventoryItemData>, opt excludes: array<ItemModParams>)` | — |
| Method |  `GetWardrobeItems(out items: array<InventoryItemData>)` | — |
| Method |  `GetAvailableItems(opt excludes: array<ItemModParams>)` -> `array<InventoryItemData>` | — |
| Method |  `DiscardItem(itemID: ItemID)` | — |
| Method |  `GetInstance(game: GameInstance)` -> `ref<InventoryHelper>` | — |

# Notable Methods

## InventoryHelper

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnPlayerAttach` | `request: ref<PlayerAttachRequest>` | `` |
| `IsValidItem` | `itemID: ItemID` | `Bool` |
| `GetStash` | `` | `wref<Stash>` |
| `AddStash` | `stash: ref<Stash>` | `` |
| `GetStashItems` | `out items: array<InventoryItemData>` | `` |
| `GetPlayerItems` | `out items: array<InventoryItemData>, opt excludes: array<ItemModParams>` | `` |
| `GetWardrobeItems` | `out items: array<InventoryItemData>` | `` |
| `GetAvailableItems` | `opt excludes: array<ItemModParams>` | `array<InventoryItemData>` |
| `DiscardItem` | `itemID: ItemID` | `` |
| `GetInstance` | `game: GameInstance` | `ref<InventoryHelper>` |

# Related Concepts

- "Used by [inventory UI overrides](/overrides/inventory-ui.md) for slot operations"

# Citations

- [InventoryHelper.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/InventoryHelper.reds)
