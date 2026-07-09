---
type: UI
title: Inventory Grid UI
description: Inventory grid slot, data, and item controllers for rendering the extended inventory grid with EquipmentEx slots.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/InventoryGridSlot.reds"
tags: ['equipment-ex', 'redscript', 'ui', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Inventory grid slot, data, and item controllers for rendering the extended inventory grid with EquipmentEx slots.

This concept covers 34 member declarations from 3 source file(s): UI/InventoryGridSlot.reds, UI/InventoryGridData.reds, UI/InventoryGridItem.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Event | `InventoryGridSlotClick` extends Event | 0 methods |
| Event | `InventoryGridSlotHoverOver` extends Event | 0 methods |
| Event | `InventoryGridSlotHoverOut` extends Event | 0 methods |
| Class | `InventoryGridSlotController` extends inkVirtualCompoundItemController | 13 methods |
| Method |  `OnInitialize()` | — |
| Method |  `OnDataChanged(value: Variant)` | — |
| Method |  `OnOutfitUpdated(evt: ref<OutfitUpdated>)` | — |
| Method |  `OnOutfitPartUpdated(evt: ref<OutfitPartUpdated>)` | — |
| Method |  `OnClick(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOver(evt: ref<inkPointerEvent>)` | — |
| Method |  `OnHoverOut(evt: ref<inkPointerEvent>)` | — |
| Method |  `UpdateSlotInfo()` | — |
| Method |  `UpdateActiveItem()` | — |
| Method |  `UpdateState()` | — |
| Method |  `TriggerClickEvent(action: ref<inkActionName>)` | — |
| Method |  `TriggerHoverOverEvent()` | — |
| Method |  `TriggerHoverOutEvent()` | — |
| Class | `InventoryGridItemData` extends VendorUIInventoryItemData | 0 methods |
| Class | `InventoryGridSlotData` extends VendorUIInventoryItemData | 1 methods |
| Method |  `GetActiveItem()` -> `wref<InventoryGridItemData>` | — |
| Class | `InventoryGridDataView` extends BackpackDataView | 7 methods |
| Method |  `SetViewManager(viewManager: wref<ViewManager>)` | — |
| Method |  `SetCollapsed(state: Bool)` | — |
| Method |  `ToggleCollapsed()` | — |
| Method |  `ToggleCollapsed(slotID: TweakDBID)` | — |
| Method |  `SetSearchQuery(searchQuery: String)` | — |
| Method |  `UpdateView()` | — |
| Method |  `FilterItem(data: ref<IScriptable>)` -> `Bool` | — |
| Class | `InventoryGridTemplateClassifier` extends inkVirtualItemTemplateClassifier | 1 methods |
| Method |  `ClassifyItem(data: Variant)` -> `Uint32` | — |
| Class | `InventoryGridItemController` extends VendorItemVirtualController | 3 methods |
| Method |  `OnOutfitUpdated(evt: ref<OutfitUpdated>)` | — |
| Method |  `OnOutfitPartUpdated(evt: ref<OutfitPartUpdated>)` | — |
| Method |  `UpdateEquippedState()` | — |

# Notable Methods

## InventoryGridSlotController

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnInitialize` | `` | `` |
| `OnDataChanged` | `value: Variant` | `` |
| `OnOutfitUpdated` | `evt: ref<OutfitUpdated>` | `` |
| `OnOutfitPartUpdated` | `evt: ref<OutfitPartUpdated>` | `` |
| `OnClick` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOver` | `evt: ref<inkPointerEvent>` | `` |
| `OnHoverOut` | `evt: ref<inkPointerEvent>` | `` |
| `UpdateSlotInfo` | `` | `` |
| `UpdateActiveItem` | `` | `` |
| `UpdateState` | `` | `` |
| `TriggerClickEvent` | `action: ref<inkActionName>` | `` |
| `TriggerHoverOverEvent` | `` | `` |
| `TriggerHoverOutEvent` | `` | `` |

## InventoryGridDataView

| Method | Parameters | Returns |
|--------|------------|---------|
| `SetViewManager` | `viewManager: wref<ViewManager>` | `` |
| `SetCollapsed` | `state: Bool` | `` |
| `ToggleCollapsed` | `` | `` |
| `ToggleCollapsed` | `slotID: TweakDBID` | `` |
| `SetSearchQuery` | `searchQuery: String` | `` |
| `UpdateView` | `` | `` |
| `FilterItem` | `data: ref<IScriptable>` | `Bool` |

# Citations

- [UI/InventoryGridSlot.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/InventoryGridSlot.reds)
- [UI/InventoryGridData.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/InventoryGridData.reds)
- [UI/InventoryGridItem.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/InventoryGridItem.reds)
