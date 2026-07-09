---
type: Override
title: Equipment System Override
description: Override of EquipmentSystem attachment and initialization logic to hook EquipmentEx into the base game equipment pipeline.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/EquipmentSystem.reds"
tags: ['equipment-ex', 'redscript', 'overrides', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Override of EquipmentSystem attachment and initialization logic to hook EquipmentEx into the base game equipment pipeline.

This concept covers 21 member declarations from 1 source file(s): Overrides/EquipmentSystem.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `EquipmentSystemReattachItem` extends DelayCallback | 2 methods |
| Method |  `Call()` | — |
| Method |  `Create(data: ref<EquipmentSystemPlayerData>, slotID: TweakDBID, itemID: ItemID)` -> `ref<EquipmentSystemReattachItem>` | — |
| Function | `OnAttach()` | — |
| Function | `LockVisualChanges()` | — |
| Function | `UnlockVisualChanges()` | — |
| Function | `IsVisualSetActive()` -> `Bool` | — |
| Function | `IsSlotOverriden(area: gamedataEquipmentArea)` -> `Bool` | — |
| Function | `ShouldUnderwearBeVisibleInSet()` -> `Bool` | — |
| Function | `ShouldUnderwearTopBeVisibleInSet()` -> `Bool` | — |
| Function | `OnRestored()` | — |
| Function | `OnQuestDisableWardrobeSetRequest(request: ref<QuestDisableWardrobeSetRequest>)` | — |
| Function | `OnQuestRestoreWardrobeSetRequest(request: ref<QuestRestoreWardrobeSetRequest>)` | — |
| Function | `OnQuestEnableWardrobeSetRequest(request: ref<QuestEnableWardrobeSetRequest>)` | — |
| Function | `EquipWardrobeSet(setID: gameWardrobeClothingSetIndex)` | — |
| Function | `UnequipWardrobeSet()` | — |
| Function | `QuestHideSlot(area: gamedataEquipmentArea)` | — |
| Function | `QuestRestoreSlot(area: gamedataEquipmentArea)` | — |
| Function | `ClearItemAppearanceEvent(area: gamedataEquipmentArea)` | — |
| Function | `ResetItemAppearanceEvent(area: gamedataEquipmentArea)` | — |
| Function | `ResetItemAppearance(area: gamedataEquipmentArea, opt force: Bool)` | — |

# Related Concepts

- "Hooks into the [outfit system](/systems/outfit-system.md) on attach"

# Citations

- [Overrides/EquipmentSystem.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/EquipmentSystem.reds)
