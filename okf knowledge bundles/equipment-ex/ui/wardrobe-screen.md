---
type: UI
title: Wardrobe Screen
description: Main wardrobe screen controller extending inkPuppetPreviewGameController. Handles full wardrobe UI rendering, interaction, outfit switching, and slot management. Large UI module with 55 declared types.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/WardrobeScreen.reds"
tags: ['equipment-ex', 'redscript', 'ui', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Main wardrobe screen controller extending inkPuppetPreviewGameController. Handles full wardrobe UI rendering, interaction, outfit switching, and slot management. Large UI module with 55 declared types.

This concept covers 55 member declarations from 1 source file(s): UI/WardrobeScreen.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Class | `WardrobeScreenController` extends inkPuppetPreviewGameController | 48 methods |
| Method |  `OnInitialize()` -> `Bool` | — |
| Method |  `OnUninitialize()` -> `Bool` | — |
| Method |  `InitializeSearchField()` | — |
| Method |  `InitializeGridButtons()` | — |
| Method |  `InitializeInventoryGrid()` | — |
| Method |  `PopulateInventoryGrid()` | — |
| Method |  `CompareItem(leftItemID: ItemID, rightItemID: ItemID)` -> `Bool` | — |
| Method |  `RefreshInventoryGrid()` | — |
| Method |  `RestoreScrollPosition()` | — |
| Method |  `QueueScrollPositionRestore()` | — |
| Method |  `UpdateScrollPosition(opt forceReset: Bool)` | — |
| Method |  `QueueInventoryGridUpdate(opt resetScroll: Bool)` | — |
| Method |  `OnOutfitUpdated(evt: ref<OutfitUpdated>)` | — |
| Method |  `OnItemListUpdated(evt: ref<OutfitMappingUpdated>)` | — |
| Method |  `OnItemSourceUpdated(evt: ref<ItemSourceUpdated>)` | — |
| Method |  `OnDropQueueUpdated(evt: ref<DropQueueUpdatedEvent>)` | — |
| Method |  `OnInventoryItemsChanged(value: Variant)` | — |
| Method |  `OnEquipmentProgress(inProgress: Bool)` | — |
| Method |  `OnFilterChange(controller: wref<inkRadioGroupController>, selectedIndex: Int32)` | — |
| Method |  `OnSearchFieldInput(widget: wref<inkWidget>)` | — |
| Method |  `ShowItemTooltip(widget: wref<inkWidget>, item: wref<UIInventoryItem>)` | — |
| Method |  `ShowItemButtonHints(item: wref<UIInventoryItem>)` | — |
| Method |  `OnInventoryItemClick(evt: ref<ItemDisplayClickEvent>)` | — |
| Method |  `OnInventoryItemHold(evt: ref<ItemDisplayHoldEvent>)` | — |
| Method |  `OnInventoryItemHoverOver(evt: ref<ItemDisplayHoverOverEvent>)` | — |
| Method |  `OnInventoryItemHoverOut(evt: ref<ItemDisplayHoverOutEvent>)` | — |
| Method |  `ShowSlotButtonHints(slot: wref<InventoryGridSlotData>)` | — |
| Method |  `ShowGridButtonHints()` | — |
| Method |  `OnInventoryGridSlotClick(evt: ref<InventoryGridSlotClick>)` | — |
| Method |  `OnInventoryGridSlotItemHoverOver(evt: ref<InventoryGridSlotHoverOver>)` | — |
| Method |  `OnInventoryGridSlotItemHoverOut(evt: ref<InventoryGridSlotHoverOut>)` | — |
| Method |  `OnInventoryGridCollapseClick(evt: ref<CollapseButtonClick>)` | — |
| Method |  `OnInventoryGridSettingsClick(evt: ref<SettingsButtonClick>)` | — |
| Method |  `OnManagerHoverOver(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnManagerHoverOut(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnPreviewHoverOver(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnPreviewHoverOut(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnPreviewPress(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnPreviewAxis(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnPreviewRelative(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnGlobalPress(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnGlobalRelease(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnGlobalHold(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnGlobalAxis(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `OnGlobalRelative(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Method |  `RotatePreview(offset: Float, speed: Float, opt clamp: Bool)` | — |
| Method |  `SetPreviewCamera(zoomIn: Bool)` | — |
| Method |  `AccessOutfitSystem()` -> `Bool` | — |
| Class | `UpdateInventoryGridCallback` extends DelayCallback | 2 methods |
| Method |  `Call()` | — |
| Method |  `Create(controller: ref<WardrobeScreenController>)` -> `ref<UpdateInventoryGridCallback>` | — |
| Class | `RestoreInventoryScrollCallback` extends DelayCallback | 2 methods |
| Method |  `Call()` | — |
| Method |  `Create(controller: ref<WardrobeScreenController>)` -> `ref<RestoreInventoryScrollCallback>` | — |

# Notable Methods

## WardrobeScreenController

| Method | Parameters | Returns |
|--------|------------|---------|
| `OnInitialize` | `` | `Bool` |
| `OnUninitialize` | `` | `Bool` |
| `InitializeSearchField` | `` | `` |
| `InitializeGridButtons` | `` | `` |
| `InitializeInventoryGrid` | `` | `` |
| `PopulateInventoryGrid` | `` | `` |
| `CompareItem` | `leftItemID: ItemID, rightItemID: ItemID` | `Bool` |
| `RefreshInventoryGrid` | `` | `` |
| `RestoreScrollPosition` | `` | `` |
| `QueueScrollPositionRestore` | `` | `` |
| `UpdateScrollPosition` | `opt forceReset: Bool` | `` |
| `QueueInventoryGridUpdate` | `opt resetScroll: Bool` | `` |
| `OnOutfitUpdated` | `evt: ref<OutfitUpdated>` | `` |
| `OnItemListUpdated` | `evt: ref<OutfitMappingUpdated>` | `` |
| `OnItemSourceUpdated` | `evt: ref<ItemSourceUpdated>` | `` |
| `OnDropQueueUpdated` | `evt: ref<DropQueueUpdatedEvent>` | `` |
| `OnInventoryItemsChanged` | `value: Variant` | `` |
| `OnEquipmentProgress` | `inProgress: Bool` | `` |
| `OnFilterChange` | `controller: wref<inkRadioGroupController>, selectedIndex: Int32` | `` |
| `OnSearchFieldInput` | `widget: wref<inkWidget>` | `` |
| `ShowItemTooltip` | `widget: wref<inkWidget>, item: wref<UIInventoryItem>` | `` |
| `ShowItemButtonHints` | `item: wref<UIInventoryItem>` | `` |
| `OnInventoryItemClick` | `evt: ref<ItemDisplayClickEvent>` | `` |
| `OnInventoryItemHold` | `evt: ref<ItemDisplayHoldEvent>` | `` |
| `OnInventoryItemHoverOver` | `evt: ref<ItemDisplayHoverOverEvent>` | `` |
| `OnInventoryItemHoverOut` | `evt: ref<ItemDisplayHoverOutEvent>` | `` |
| `ShowSlotButtonHints` | `slot: wref<InventoryGridSlotData>` | `` |
| `ShowGridButtonHints` | `` | `` |
| `OnInventoryGridSlotClick` | `evt: ref<InventoryGridSlotClick>` | `` |
| `OnInventoryGridSlotItemHoverOver` | `evt: ref<InventoryGridSlotHoverOver>` | `` |
| `OnInventoryGridSlotItemHoverOut` | `evt: ref<InventoryGridSlotHoverOut>` | `` |
| `OnInventoryGridCollapseClick` | `evt: ref<CollapseButtonClick>` | `` |
| `OnInventoryGridSettingsClick` | `evt: ref<SettingsButtonClick>` | `` |
| `OnManagerHoverOver` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnManagerHoverOut` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnPreviewHoverOver` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnPreviewHoverOut` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnPreviewPress` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnPreviewAxis` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnPreviewRelative` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnGlobalPress` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnGlobalRelease` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnGlobalHold` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnGlobalAxis` | `evt: ref<inkPointerEvent>` | `Bool` |
| `OnGlobalRelative` | `evt: ref<inkPointerEvent>` | `Bool` |
| `RotatePreview` | `offset: Float, speed: Float, opt clamp: Bool` | `` |
| `SetPreviewCamera` | `zoomIn: Bool` | `` |
| `AccessOutfitSystem` | `` | `Bool` |

# Related Concepts

- "Driven by [view manager](/systems/view-manager.md) state transitions"
- "Contains the [outfit manager](/ui/outfit-manager.md) panel"
- "Embeds the [inventory grid](/ui/inventory-grid.md) for slot browsing"
- "Shows [popup dialogs](/ui/popups.md) for settings and conflicts"

# Citations

- [UI/WardrobeScreen.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/UI/WardrobeScreen.reds)
