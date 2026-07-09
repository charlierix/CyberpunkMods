---
type: "UI System"
title: "Inventory UI System"
description: "Inventory UI: cyberware display, item, item display, items list, helper, items helper, cyberware item chooser, data manager V2, equipment slot, filters, game controller, generic item chooser, item data, item display controller, item display equipment area, grenade, label, item mode, item mods, item part display, item requirements, item stats, items manager, paperdoll glitch, ripperdoc display, stats display, transmog button, weapon display, weapon item chooser, weapon slot, wide item display, progress bar button, ripperdoc filter, visual slot, and wardrobe outfit slot."
resource: "!cyberpunk/UI/inventory/InventoryCyberwareDisplayController.swift"
tags: ['cyberpunk', 'ui', 'inventory']
timestamp: 2026-07-01T13:00:55Z
---

# Inventory UI System

Inventory UI: cyberware display, item, item display, items list, helper, items helper, cyberware item chooser, data manager V2, equipment slot, filters, game controller, generic item chooser, item data, item display controller, item display equipment area, grenade, label, item mode, item mods, item part display, item requirements, item stats, items manager, paperdoll glitch, ripperdoc display, stats display, transmog button, weapon display, weapon item chooser, weapon slot, wide item display, progress bar button, ripperdoc filter, visual slot, and wardrobe outfit slot.

## Source Files

- `cyberpunk/UI/inventory/InventoryCyberwareDisplayController.swift`
- `cyberpunk/UI/inventory/InventoryItem.swift`
- `cyberpunk/UI/inventory/InventoryItemDisplay.swift`
- `cyberpunk/UI/inventory/InventoryItemsList.swift`
- `cyberpunk/UI/inventory/UIInventoryHelper.swift`
- `cyberpunk/UI/inventory/UIItemsHelper.swift`
- `cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift`
- `cyberpunk/UI/inventory/inventoryDataManagerV2.swift`
- `cyberpunk/UI/inventory/inventoryEquipmentSlot.swift`
- `cyberpunk/UI/inventory/inventoryFilters.swift`
- `cyberpunk/UI/inventory/inventoryGameController.swift`
- `cyberpunk/UI/inventory/inventoryGenericItemChooser.swift`
- `cyberpunk/UI/inventory/inventoryItemData.swift`
- `cyberpunk/UI/inventory/inventoryItemDisplayController.swift`
- `cyberpunk/UI/inventory/inventoryItemDisplayEquipmentArea.swift`
- `cyberpunk/UI/inventory/inventoryItemGrenade.swift`
- `cyberpunk/UI/inventory/inventoryItemLabel.swift`
- `cyberpunk/UI/inventory/inventoryItemMode.swift`
- `cyberpunk/UI/inventory/inventoryItemMods.swift`
- `cyberpunk/UI/inventory/inventoryItemPartDisplay.swift`
- `cyberpunk/UI/inventory/inventoryItemRequirements.swift`
- `cyberpunk/UI/inventory/inventoryItemStats.swift`
- `cyberpunk/UI/inventory/inventoryItemsManager.swift`
- `cyberpunk/UI/inventory/inventoryPaperdollGlitchController.swift`
- `cyberpunk/UI/inventory/inventoryRipperdocDisplayController.swift`
- `cyberpunk/UI/inventory/inventoryStatsDisplay.swift`
- `cyberpunk/UI/inventory/inventoryTransmogButtonView.swift`
- `cyberpunk/UI/inventory/inventoryWeaponDisplayController.swift`
- `cyberpunk/UI/inventory/inventoryWeaponItemChooser.swift`
- `cyberpunk/UI/inventory/inventoryWeaponSlot.swift`
- `cyberpunk/UI/inventory/inventoryWideItemDisplay.swift`
- `cyberpunk/UI/inventory/progressBarButton.swift`
- `cyberpunk/UI/inventory/ripperdocFilter.swift`
- `cyberpunk/UI/inventory/visualSlotController.swift`
- `cyberpunk/UI/inventory/wardrobeOutfitSlot.swift`

## Member Types

**Total declarations: 148**

### Classs (69)

| Name | Bases | Source File |
|------|-------|-------------|
| InventoryCyberwareDisplayController | InventoryItemDisplayController | cyberpunk/UI/inventory/InventoryCyberwareDisplayController.swift |
| UIInventoryItemProgramData | IScriptable | cyberpunk/UI/inventory/InventoryItem.swift |
| UIInventoryItemComparisonManager | IScriptable | cyberpunk/UI/inventory/InventoryItem.swift |
| UIInventoryItem | IScriptable | cyberpunk/UI/inventory/InventoryItem.swift |
| InventoryItemDisplay | BaseButtonView | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| InventoryItemModSlotDisplay | inkLogicController | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| InventoryItemAttachmentDisplay | inkLogicController | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| InventoryItemsList | inkLogicController | cyberpunk/UI/inventory/InventoryItemsList.swift |
| UIInventoryHelper | IScriptable | cyberpunk/UI/inventory/UIInventoryHelper.swift |
| UIItemsHelper | IScriptable | cyberpunk/UI/inventory/UIItemsHelper.swift |
| InventoryCyberwareItemChooser | InventoryGenericItemChooser | cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift |
| InventoryDataManagerV2 | IScriptable | cyberpunk/UI/inventory/inventoryDataManagerV2.swift |
| StatProvider | IScriptable | cyberpunk/UI/inventory/inventoryDataManagerV2.swift |
| ItemPreferredComparisonResolver | IScriptable | cyberpunk/UI/inventory/inventoryDataManagerV2.swift |
| InventoryItemPreferredComparisonResolver | IScriptable | cyberpunk/UI/inventory/inventoryDataManagerV2.swift |
| InventoryEquipmentSlot | inkLogicController | cyberpunk/UI/inventory/inventoryEquipmentSlot.swift |
| InventoryFilterButton | BaseButtonView | cyberpunk/UI/inventory/inventoryFilters.swift |
| gameuiInventoryGameController | gameuiMenuGameController | cyberpunk/UI/inventory/inventoryGameController.swift |
| ItemDisplayInventoryMiniGrid | inkLogicController | cyberpunk/UI/inventory/inventoryGameController.swift |
| ItemInventoryMiniGrid | inkLogicController | cyberpunk/UI/inventory/inventoryGameController.swift |
| EquipmentAreaCategory | IScriptable | cyberpunk/UI/inventory/inventoryGameController.swift |
| InventoryStatsListener | ScriptStatsListener | cyberpunk/UI/inventory/inventoryGameController.swift |
| InventoryStatsController | inkLogicController | cyberpunk/UI/inventory/inventoryGameController.swift |
| InventoryStatsEntryController | inkLogicController | cyberpunk/UI/inventory/inventoryGameController.swift |
| CyberdeckInventoryStatsController | inkLogicController | cyberpunk/UI/inventory/inventoryGameController.swift |
| InventoryGenericItemChooser | inkLogicController | cyberpunk/UI/inventory/inventoryGenericItemChooser.swift |
| UILocalizationDataPackage | IScriptable | cyberpunk/UI/inventory/inventoryItemData.swift |
| UIGenderHelper | IScriptable | cyberpunk/UI/inventory/inventoryItemData.swift |
| InventoryGPRestrictionHelper | IScriptable | cyberpunk/UI/inventory/inventoryItemData.swift |
| InventoryItemDisplayController | BaseButtonView | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| ItemDisplayContextData | IScriptable | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| InventoryItemDisplayCategoryArea | inkLogicController | cyberpunk/UI/inventory/inventoryItemDisplayEquipmentArea.swift |
| InventoryItemDisplayEquipmentArea | inkLogicController | cyberpunk/UI/inventory/inventoryItemDisplayEquipmentArea.swift |
| UIInventoryItemGrenadeData | IScriptable | cyberpunk/UI/inventory/inventoryItemGrenade.swift |
| ItemLabelContainerController | inkLogicController | cyberpunk/UI/inventory/inventoryItemLabel.swift |
| ItemLabelController | inkLogicController | cyberpunk/UI/inventory/inventoryItemLabel.swift |
| InventoryItemModeLogicController | inkLogicController | cyberpunk/UI/inventory/inventoryItemMode.swift |
| ItemModeGridContainer | inkLogicController | cyberpunk/UI/inventory/inventoryItemMode.swift |
| ItemModeGridClassifier | inkVirtualItemTemplateClassifier | cyberpunk/UI/inventory/inventoryItemMode.swift |
| CommonItemsGridView | ScriptableDataView | cyberpunk/UI/inventory/inventoryItemMode.swift |
| ItemModeGridView | CommonItemsGridView | cyberpunk/UI/inventory/inventoryItemMode.swift |
| ItemModeInventoryListenerCallback | InventoryScriptCallback | cyberpunk/UI/inventory/inventoryItemMode.swift |
| InventoryOutfitCooldownResetCallback | DelayCallback | cyberpunk/UI/inventory/inventoryItemMode.swift |
| UIInventoryItemModsManager | IScriptable | cyberpunk/UI/inventory/inventoryItemMods.swift |
| UIInventoryItemModsStaticData | IScriptable | cyberpunk/UI/inventory/inventoryItemMods.swift |
| InventoryItemPartDisplay | inkLogicController | cyberpunk/UI/inventory/inventoryItemPartDisplay.swift |
| UIInventoryItemRequirementsManager | IScriptable | cyberpunk/UI/inventory/inventoryItemRequirements.swift |
| UIInventoryItemStatsManager | IScriptable | cyberpunk/UI/inventory/inventoryItemStats.swift |
| UIItemStatProperties | IScriptable | cyberpunk/UI/inventory/inventoryItemStats.swift |
| UIInventoryItemWeaponBar | IScriptable | cyberpunk/UI/inventory/inventoryItemStats.swift |
| UIInventoryItemWeaponBars | IScriptable | cyberpunk/UI/inventory/inventoryItemStats.swift |
| UIInventoryItemStat | IScriptable | cyberpunk/UI/inventory/inventoryItemStats.swift |
| IUIInventoryItemStatsProvider | IScriptable | cyberpunk/UI/inventory/inventoryItemStats.swift |
| DefaultUIInventoryItemStatsProvider | IUIInventoryItemStatsProvider | cyberpunk/UI/inventory/inventoryItemStats.swift |
| UIInventoryItemsManager | IScriptable | cyberpunk/UI/inventory/inventoryItemsManager.swift |
| PaperdollGlitchController | inkLogicController | cyberpunk/UI/inventory/inventoryPaperdollGlitchController.swift |
| InventoryRipperdocDisplayController | InventoryItemDisplayController | cyberpunk/UI/inventory/inventoryRipperdocDisplayController.swift |
| InventoryStatsDisplay | inkLogicController | cyberpunk/UI/inventory/inventoryStatsDisplay.swift |
| InventoryStatItemV2 | inkLogicController | cyberpunk/UI/inventory/inventoryStatsDisplay.swift |
| TransmogButtonView | BaseButtonView | cyberpunk/UI/inventory/inventoryTransmogButtonView.swift |
| InventoryWeaponDisplayController | InventoryItemDisplayController | cyberpunk/UI/inventory/inventoryWeaponDisplayController.swift |
| InventoryWeaponItemChooser | InventoryGenericItemChooser | cyberpunk/UI/inventory/inventoryWeaponItemChooser.swift |
| InventoryWeaponSlot | InventoryEquipmentSlot | cyberpunk/UI/inventory/inventoryWeaponSlot.swift |
| InventoryWideItemDisplay | InventoryItemDisplay | cyberpunk/UI/inventory/inventoryWideItemDisplay.swift |
| ProgressBarButton | inkLogicController | cyberpunk/UI/inventory/progressBarButton.swift |
| RipperdocFilterToggleController | ToggleController | cyberpunk/UI/inventory/ripperdocFilter.swift |
| VisualDisplayController | InventoryItemDisplayController | cyberpunk/UI/inventory/visualSlotController.swift |
| WardrobeOutfitSlotController | inkLogicController | cyberpunk/UI/inventory/wardrobeOutfitSlot.swift |
| WardrobeOutfitInfoTooltipController | AGenericTooltipController | cyberpunk/UI/inventory/wardrobeOutfitSlot.swift |

### Structs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| InventoryItemData |  | cyberpunk/UI/inventory/inventoryItemData.swift |

### Funcs (78)

| Name | Bases | Source File |
|------|-------|-------------|
| Unselect |  | cyberpunk/UI/inventory/InventoryCyberwareDisplayController.swift |
| Select |  | cyberpunk/UI/inventory/InventoryCyberwareDisplayController.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| RefreshSelectedItem |  | cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift |
| RequestClose |  | cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift |
| GetModifiedItemData |  | cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift |
| GetModifiedItemID |  | cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift |
| SetDisableSlot |  | cyberpunk/UI/inventory/inventoryEquipmentSlot.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Show |  | cyberpunk/UI/inventory/inventoryEquipmentSlot.swift |
| Clear |  | cyberpunk/UI/inventory/inventoryEquipmentSlot.swift |
| GetSlotWidget |  | cyberpunk/UI/inventory/inventoryEquipmentSlot.swift |
| GetCustomizeWidget |  | cyberpunk/UI/inventory/inventoryEquipmentSlot.swift |
| IsEmpty |  | cyberpunk/UI/inventory/inventoryEquipmentSlot.swift |
| OnStatChanged |  | cyberpunk/UI/inventory/inventoryGameController.swift |
| RequestClose |  | cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift |
| RefreshItems |  | cyberpunk/UI/inventory/inventoryGenericItemChooser.swift |
| RefreshSelectedItem |  | cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift |
| GetModifiedItem |  | cyberpunk/UI/inventory/inventoryGenericItemChooser.swift |
| GetModifiedItemData |  | cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift |
| GetModifiedItemID |  | cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift |
| GetSelectedSlotID |  | cyberpunk/UI/inventory/inventoryGenericItemChooser.swift |
| IsAttachmentItem |  | cyberpunk/UI/inventory/inventoryGenericItemChooser.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| Bind |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| Bind |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| BindVisualSlot |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| InvalidateVisualContent |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| SetParentItem |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| BindComparisonAndScriptableSystem |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| InvalidateContent |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| UpdateThisSlotItems |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| UpdateItemsCounter |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| SetDefaultShadowIcon |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| SetComparisonState |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| SetBuybackStack |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| SetDLCNewIndicator |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| SetIsNew |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| SetIsPlayerFavourite |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| Unselect |  | cyberpunk/UI/inventory/InventoryCyberwareDisplayController.swift |
| Select |  | cyberpunk/UI/inventory/InventoryCyberwareDisplayController.swift |
| SetHighlighted |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| SetHighlightedCyberwareSlot |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| ShowSelectionArrow |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| HideSelectionArrow |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| GetSlotID |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| SetInteractive |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| GetDisplayType |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| GetAttachmentsSize |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| GetParentItemData |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| GetNewItems |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| IsEmpty |  | cyberpunk/UI/inventory/inventoryEquipmentSlot.swift |
| ClassifyItem |  | cyberpunk/UI/inventory/inventoryItemMode.swift |
| SortItem |  | cyberpunk/UI/inventory/inventoryItemMode.swift |
| FilterItem |  | cyberpunk/UI/inventory/inventoryItemMode.swift |
| OnItemRemoved |  | cyberpunk/UI/inventory/inventoryItemMode.swift |
| OnItemQuantityChanged |  | cyberpunk/UI/inventory/inventoryItemMode.swift |
| Call |  | cyberpunk/UI/inventory/inventoryItemMode.swift |
| Get |  | cyberpunk/UI/inventory/inventoryItemStats.swift |
| Get |  | cyberpunk/UI/inventory/inventoryItemStats.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| SetAdditinalInfoType |  | cyberpunk/UI/inventory/inventoryWideItemDisplay.swift |
| Setup |  | cyberpunk/UI/inventory/InventoryItemDisplay.swift |
| GetLabelKey |  | cyberpunk/UI/inventory/ripperdocFilter.swift |
| GetIcon |  | cyberpunk/UI/inventory/ripperdocFilter.swift |
| BindVisualSlot |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| InvalidateVisualContent |  | cyberpunk/UI/inventory/inventoryItemDisplayController.swift |
| SetData |  | cyberpunk/UI/inventory/wardrobeOutfitSlot.swift |

## Citations

- `cyberpunk/UI/inventory/InventoryCyberwareDisplayController.swift`
- `cyberpunk/UI/inventory/InventoryItem.swift`
- `cyberpunk/UI/inventory/InventoryItemDisplay.swift`
- `cyberpunk/UI/inventory/InventoryItemsList.swift`
- `cyberpunk/UI/inventory/UIInventoryHelper.swift`
- `cyberpunk/UI/inventory/UIItemsHelper.swift`
- `cyberpunk/UI/inventory/inventoryCyberwareItemChooser.swift`
- `cyberpunk/UI/inventory/inventoryDataManagerV2.swift`
- `cyberpunk/UI/inventory/inventoryEquipmentSlot.swift`
- `cyberpunk/UI/inventory/inventoryFilters.swift`
- `cyberpunk/UI/inventory/inventoryGameController.swift`
- `cyberpunk/UI/inventory/inventoryGenericItemChooser.swift`
- `cyberpunk/UI/inventory/inventoryItemData.swift`
- `cyberpunk/UI/inventory/inventoryItemDisplayController.swift`
- `cyberpunk/UI/inventory/inventoryItemDisplayEquipmentArea.swift`
- `cyberpunk/UI/inventory/inventoryItemGrenade.swift`
- `cyberpunk/UI/inventory/inventoryItemLabel.swift`
- `cyberpunk/UI/inventory/inventoryItemMode.swift`
- `cyberpunk/UI/inventory/inventoryItemMods.swift`
- `cyberpunk/UI/inventory/inventoryItemPartDisplay.swift`
- `cyberpunk/UI/inventory/inventoryItemRequirements.swift`
- `cyberpunk/UI/inventory/inventoryItemStats.swift`
- `cyberpunk/UI/inventory/inventoryItemsManager.swift`
- `cyberpunk/UI/inventory/inventoryPaperdollGlitchController.swift`
- `cyberpunk/UI/inventory/inventoryRipperdocDisplayController.swift`
- `cyberpunk/UI/inventory/inventoryStatsDisplay.swift`
- `cyberpunk/UI/inventory/inventoryTransmogButtonView.swift`
- `cyberpunk/UI/inventory/inventoryWeaponDisplayController.swift`
- `cyberpunk/UI/inventory/inventoryWeaponItemChooser.swift`
- `cyberpunk/UI/inventory/inventoryWeaponSlot.swift`
- `cyberpunk/UI/inventory/inventoryWideItemDisplay.swift`
- `cyberpunk/UI/inventory/progressBarButton.swift`
- `cyberpunk/UI/inventory/ripperdocFilter.swift`
- `cyberpunk/UI/inventory/visualSlotController.swift`
- `cyberpunk/UI/inventory/wardrobeOutfitSlot.swift`
