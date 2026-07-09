---
type: Override
title: Inventory UI Overrides
description: Overrides for inventory game controllers, item display, mode logic, UI inventory item creation, items manager, and scroll controller to integrate EquipmentEx features.
resource: "https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/gameuiInventoryGameController.reds"
tags: ['equipment-ex', 'redscript', 'overrides', 'core']
timestamp: 2026-07-08T12:15:00Z
---

# Overview

Overrides for inventory game controllers, item display, mode logic, UI inventory item creation, items manager, and scroll controller to integrate EquipmentEx features.

This concept covers 32 member declarations from 6 source file(s): Overrides/gameuiInventoryGameController.reds, Overrides/InventoryItemDisplayController.reds, Overrides/InventoryItemModeLogicController.reds, Overrides/UIInventoryItem.reds, Overrides/UIInventoryItemsManager.reds, Overrides/inkScrollController.reds.

# Member Types

| Kind | Name | Details |
|------|------|--------|
| Function | `OnInitialize()` -> `Bool` | — |
| Function | `OnUninitialize()` -> `Bool` | — |
| Function | `SetupSetButton()` -> `Void` | — |
| Function | `OnWardrobeBtnClick(evt: ref<inkPointerEvent>)` -> `Bool` | — |
| Function | `OnWardrobePopupClose(data: ref<inkGameNotificationData>)` | — |
| Function | `OnBack(userData: ref<IScriptable>)` -> `Bool` | — |
| Function | `ShowWardrobeScreen()` -> `Bool` | — |
| Function | `OnWardrobeScreenShown(anim: ref<inkAnimProxy>)` | — |
| Function | `HideWardrobeScreen()` -> `Bool` | — |
| Function | `OnWardrobeScreenHidden(anim: ref<inkAnimProxy>)` | — |
| Function | `PlaySlidePaperdollAnimationToOutfit()` | — |
| Function | `OnPaperDollSlideComplete(anim: ref<inkAnimProxy>)` | — |
| Function | `OnEquipmentClick(evt: ref<ItemDisplayClickEvent>)` -> `Bool` | — |
| Function | `RefreshEquippedWardrobeItems()` | — |
| Function | `Bind(inventoryDataManager: ref<InventoryDataManagerV2>, equipmentArea: gamedataEquipmentArea, opt slotIndex: Int32, opt displayContext: ItemDisplayContext, opt setWardrobeOutfit: Bool, opt wardrobeOutfitIndex: Int32)` | — |
| Function | `RefreshUI()` | — |
| Function | `NewUpdateRequirements(itemData: ref<UIInventoryItem>)` | — |
| Function | `SetupData(buttonHints: wref<ButtonHints>, tooltipsManager: wref<gameuiTooltipsManager>, inventoryManager: ref<InventoryDataManagerV2>, player: wref<PlayerPuppet>)` | — |
| Function | `UpdateOutfitWardrobe(active: Bool, activeSetOverride: Int32)` | — |
| Function | `OnWardrobeOutfitSlotClicked(e: ref<WardrobeOutfitSlotClickedEvent>)` -> `Bool` | — |
| Function | `OnWardrobeOutfitSlotHoverOver(e: ref<WardrobeOutfitSlotHoverOverEvent>)` -> `Bool` | — |
| Function | `OnItemDisplayClick(evt: ref<ItemDisplayClickEvent>)` -> `Bool` | — |
| Function | `OnItemDisplayHoverOver(evt: ref<ItemDisplayHoverOverEvent>)` -> `Bool` | — |
| Function | `SetInventoryItemButtonHintsHoverOver(const displayingData: script_ref<InventoryItemData>,
                                                        opt display: ref<InventoryItemDisplayController>)` | — |
| Function | `HandleItemClick(const itemData: script_ref<InventoryItemData>, actionName: ref<inkActionName>, opt displayContext: ItemDisplayContext, opt isPlayerLocked: Bool)` | — |
| Function | `Make(owner: wref<GameObject>, slotID: TweakDBID, itemData: script_ref<InventoryItemData>, opt manager: wref<UIInventoryItemsManager>)` -> `ref<UIInventoryItem>` | — |
| Function | `IsForWardrobe()` -> `Bool` | — |
| Function | `IsEquipped(opt force: Bool)` -> `Bool` | — |
| Function | `IsTransmogItem()` -> `Bool` | — |
| Function | `IsItemEquippedInSlot(itemID: ItemID, slotID: TweakDBID)` -> `Bool` | — |
| Function | `IsItemTransmog(itemID: ItemID)` -> `Bool` | — |
| Function | `SetScrollEnabled(enabled: Bool)` | — |

# Related Concepts

- "Calls [EquipmentEx facade](/systems/facade.md) for equipment operations"
- "Renders [inventory grid UI](/ui/inventory-grid.md) with extended slots"

# Citations

- [Overrides/gameuiInventoryGameController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/gameuiInventoryGameController.reds)
- [Overrides/InventoryItemDisplayController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/InventoryItemDisplayController.reds)
- [Overrides/InventoryItemModeLogicController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/InventoryItemModeLogicController.reds)
- [Overrides/UIInventoryItem.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/UIInventoryItem.reds)
- [Overrides/UIInventoryItemsManager.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/UIInventoryItemsManager.reds)
- [Overrides/inkScrollController.reds](https://github.com/rayshader/nvzi-equipment-ex/tree/main/scripts/Overrides/inkScrollController.reds)
