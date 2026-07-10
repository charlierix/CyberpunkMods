---
type: "UI System"
title: "Common UI Utilities"
description: "Common UI utilities: button hints, comparison, animations, fact text, generic buttons, messages, hold indicators, image utils, inventory utils, item display, progress bars, slot machines, sounds, state utils, tooltips, tutorials, and localization."
resource: "!cyberpunk/UI/common/ButtonHints.swift"
tags: ['cyberpunk', 'ui', 'common']
timestamp: 2026-07-01T13:00:55Z
---

# Common UI Utilities

Common UI utilities: button hints, comparison, animations, fact text, generic buttons, messages, hold indicators, image utils, inventory utils, item display, progress bars, slot machines, sounds, state utils, tooltips, tutorials, and localization.

## Source Files

- `cyberpunk/UI/common/ButtonHints.swift`
- `cyberpunk/UI/common/ComparisionUtils.swift`
- `cyberpunk/UI/common/animationHelper.swift`
- `cyberpunk/UI/common/customAnimationsGameController.swift`
- `cyberpunk/UI/common/customAnimationsHudGameController.swift`
- `cyberpunk/UI/common/factTextGameController.swift`
- `cyberpunk/UI/common/genericButton.swift`
- `cyberpunk/UI/common/genericMessageNotification.swift`
- `cyberpunk/UI/common/holdIndicator.swift`
- `cyberpunk/UI/common/inkImageUtils.swift`
- `cyberpunk/UI/common/inventoryUtils.swift`
- `cyberpunk/UI/common/itemDisplayUtils.swift`
- `cyberpunk/UI/common/journalListController.swift`
- `cyberpunk/UI/common/localizationMap.swift`
- `cyberpunk/UI/common/progressBarAnimationController.swift`
- `cyberpunk/UI/common/progressBarSimple.swift`
- `cyberpunk/UI/common/slotMachineController.swift`
- `cyberpunk/UI/common/soundController.swift`
- `cyberpunk/UI/common/stateUtils.swift`
- `cyberpunk/UI/common/statsProgress.swift`
- `cyberpunk/UI/common/tooltipAnimationController.swift`
- `cyberpunk/UI/common/tutorialMain.swift`
- `cyberpunk/UI/common/tweakDBIDSelector.swift`
- `cyberpunk/UI/common/uiInventoryScriptableSystem.swift`
- `cyberpunk/UI/common/uiLocalizationHelper.swift`
- `cyberpunk/UI/common/uiScriptableSystem.swift`
- `cyberpunk/UI/common/virtualNestedListController.swift`
- `cyberpunk/UI/common/weaponsUtils.swift`
- `cyberpunk/UI/common/widgetStateMapper.swift`

## Member Types

**Total declarations: 83**

### Classs (55)

| Name | Bases | Source File |
|------|-------|-------------|
| ButtonHints | inkLogicController | cyberpunk/UI/common/ButtonHints.swift |
| ButtonHintListItem | inkLogicController | cyberpunk/UI/common/ButtonHints.swift |
| CompareBuilder | IScriptable | cyberpunk/UI/common/ComparisionUtils.swift |
| NewItemCompareBuilder | IScriptable | cyberpunk/UI/common/ComparisionUtils.swift |
| ItemCompareBuilder | IScriptable | cyberpunk/UI/common/ComparisionUtils.swift |
| InkAnimHelper | IScriptable | cyberpunk/UI/common/animationHelper.swift |
| CustomUIAnimationEvent | Event | cyberpunk/UI/common/customAnimationsGameController.swift |
| CustomAnimationsGameController | inkGameController | cyberpunk/UI/common/customAnimationsGameController.swift |
| CustomAnimationsHudGameController | inkHUDGameController | cyberpunk/UI/common/customAnimationsHudGameController.swift |
| FactTextGameController | inkGameController | cyberpunk/UI/common/factTextGameController.swift |
| GenericButtonController | inkLogicController | cyberpunk/UI/common/genericButton.swift |
| GenericMessageNotification | inkGameController | cyberpunk/UI/common/genericMessageNotification.swift |
| HoldIndicatorGameController | inkGameController | cyberpunk/UI/common/holdIndicator.swift |
| GamepadHoldIndicatorGameController | HoldIndicatorGameController | cyberpunk/UI/common/holdIndicator.swift |
| KeyboardHoldIndicatorGameController | HoldIndicatorGameController | cyberpunk/UI/common/holdIndicator.swift |
| InkImageUtils | IScriptable | cyberpunk/UI/common/inkImageUtils.swift |
| InventoryUtils | IScriptable | cyberpunk/UI/common/inventoryUtils.swift |
| ItemDisplayUtils | IScriptable | cyberpunk/UI/common/itemDisplayUtils.swift |
| JournalEntryListItemController | ListItemController | cyberpunk/UI/common/journalListController.swift |
| JournalEntriesListController | ListController | cyberpunk/UI/common/journalListController.swift |
| UILocalizationMap | IScriptable | cyberpunk/UI/common/localizationMap.swift |
| ProgressBarAnimationChunkController | inkLogicController | cyberpunk/UI/common/progressBarAnimationController.swift |
| ProgressBarSimpleWidgetLogicController | inkLogicController | cyberpunk/UI/common/progressBarSimple.swift |
| NameplateBarLogicController | ProgressBarSimpleWidgetLogicController | cyberpunk/UI/common/progressBarSimple.swift |
| SlotMachineController | inkLogicController | cyberpunk/UI/common/slotMachineController.swift |
| SlotMachineSlot | inkLogicController | cyberpunk/UI/common/slotMachineController.swift |
| InitializationSoundController | inkLogicController | cyberpunk/UI/common/soundController.swift |
| PopupStateUtils | IScriptable | cyberpunk/UI/common/stateUtils.swift |
| StatsProgressController | inkLogicController | cyberpunk/UI/common/statsProgress.swift |
| TooltipAnimationController | inkLogicController | cyberpunk/UI/common/tooltipAnimationController.swift |
| TutorialMainController | inkGameController | cyberpunk/UI/common/tutorialMain.swift |
| TweakDBIDSelector | IScriptable | cyberpunk/UI/common/tweakDBIDSelector.swift |
| LCDScreenSelector | TweakDBIDSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| CityFluffScreenSelector | LCDScreenSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| NumberPlateSelector | LCDScreenSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| GenericStreetSignSelector | StreetSignSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| StreetNameSelector | StreetSignSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| MetroSignSelector | StreetSignSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| HighwaySignSelector | StreetSignSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| RaceCheckpointSelector | StreetSignSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| ScreenMessageSelector | TweakDBIDSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| CityFluffMessageSelector | ScreenMessageSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| QuestMessageSelector | ScreenMessageSelector | cyberpunk/UI/common/tweakDBIDSelector.swift |
| UIInventoryScriptableSystem | ScriptableSystem | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| UIInventoryScriptableInventoryListenerCallback | InventoryScriptCallback | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| UIInventoryScriptableEquipmentListener | IScriptable | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| UIInventoryScriptableStatsListener | ScriptStatsListener | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| UILocalizationHelper | IScriptable | cyberpunk/UI/common/uiLocalizationHelper.swift |
| UIScriptableSystem | ScriptableSystem | cyberpunk/UI/common/uiScriptableSystem.swift |
| UIScriptableInventoryListenerCallback | InventoryScriptCallback | cyberpunk/UI/common/uiScriptableSystem.swift |
| VirutalNestedListClassifier | inkVirtualItemTemplateClassifier | cyberpunk/UI/common/virtualNestedListController.swift |
| VirtualNestedListDataView | ScriptableDataView | cyberpunk/UI/common/virtualNestedListController.swift |
| VirtualNestedListController | inkVirtualListController | cyberpunk/UI/common/virtualNestedListController.swift |
| WeaponsUtils | IScriptable | cyberpunk/UI/common/weaponsUtils.swift |
| ListItemStateMapper | inkLogicController | cyberpunk/UI/common/widgetStateMapper.swift |

### Funcs (28)

| Name | Bases | Source File |
|------|-------|-------------|
| SetRecordID |  | cyberpunk/UI/common/tweakDBIDSelector.swift |
| SetRecordID |  | cyberpunk/UI/common/tweakDBIDSelector.swift |
| SetRecordID |  | cyberpunk/UI/common/tweakDBIDSelector.swift |
| SetRecordID |  | cyberpunk/UI/common/tweakDBIDSelector.swift |
| SetRecordID |  | cyberpunk/UI/common/tweakDBIDSelector.swift |
| SetRecordID |  | cyberpunk/UI/common/tweakDBIDSelector.swift |
| SetRecordID |  | cyberpunk/UI/common/tweakDBIDSelector.swift |
| SetRecordID |  | cyberpunk/UI/common/tweakDBIDSelector.swift |
| SetRecordID |  | cyberpunk/UI/common/tweakDBIDSelector.swift |
| SetRecordID |  | cyberpunk/UI/common/tweakDBIDSelector.swift |
| OnItemAdded |  | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| OnPartRemoved |  | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| OnItemRemoved |  | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| OnItemQuantityChanged |  | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| OnItemExtracted |  | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| OnStatChanged |  | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| OnItemAdded |  | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| OnItemRemoved |  | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| OnItemExtracted |  | cyberpunk/UI/common/uiInventoryScriptableSystem.swift |
| ClassifyItem |  | cyberpunk/UI/common/virtualNestedListController.swift |
| SetData |  | cyberpunk/UI/common/virtualNestedListController.swift |
| ToggleLevel |  | cyberpunk/UI/common/virtualNestedListController.swift |
| IsLevelToggled |  | cyberpunk/UI/common/virtualNestedListController.swift |
| GetItem |  | cyberpunk/UI/common/virtualNestedListController.swift |
| GetDataSize |  | cyberpunk/UI/common/virtualNestedListController.swift |
| EnableSorting |  | cyberpunk/UI/common/virtualNestedListController.swift |
| DisableSorting |  | cyberpunk/UI/common/virtualNestedListController.swift |
| IsSortingEnabled |  | cyberpunk/UI/common/virtualNestedListController.swift |

## Citations

- `cyberpunk/UI/common/ButtonHints.swift`
- `cyberpunk/UI/common/ComparisionUtils.swift`
- `cyberpunk/UI/common/animationHelper.swift`
- `cyberpunk/UI/common/customAnimationsGameController.swift`
- `cyberpunk/UI/common/customAnimationsHudGameController.swift`
- `cyberpunk/UI/common/factTextGameController.swift`
- `cyberpunk/UI/common/genericButton.swift`
- `cyberpunk/UI/common/genericMessageNotification.swift`
- `cyberpunk/UI/common/holdIndicator.swift`
- `cyberpunk/UI/common/inkImageUtils.swift`
- `cyberpunk/UI/common/inventoryUtils.swift`
- `cyberpunk/UI/common/itemDisplayUtils.swift`
- `cyberpunk/UI/common/journalListController.swift`
- `cyberpunk/UI/common/localizationMap.swift`
- `cyberpunk/UI/common/progressBarAnimationController.swift`
- `cyberpunk/UI/common/progressBarSimple.swift`
- `cyberpunk/UI/common/slotMachineController.swift`
- `cyberpunk/UI/common/soundController.swift`
- `cyberpunk/UI/common/stateUtils.swift`
- `cyberpunk/UI/common/statsProgress.swift`
- `cyberpunk/UI/common/tooltipAnimationController.swift`
- `cyberpunk/UI/common/tutorialMain.swift`
- `cyberpunk/UI/common/tweakDBIDSelector.swift`
- `cyberpunk/UI/common/uiInventoryScriptableSystem.swift`
- `cyberpunk/UI/common/uiLocalizationHelper.swift`
- `cyberpunk/UI/common/uiScriptableSystem.swift`
- `cyberpunk/UI/common/virtualNestedListController.swift`
- `cyberpunk/UI/common/weaponsUtils.swift`
- `cyberpunk/UI/common/widgetStateMapper.swift`
