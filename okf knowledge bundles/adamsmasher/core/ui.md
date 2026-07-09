---
type: "UI System"
title: "Core UI Framework"
description: "Core UI framework: animation interpolators, base controllers, base widgets, combo boxes, list controllers, menu definitions, settings, text params, views, and widget utilities."
resource: "!core/ui/animationInterpolators.swift"
tags: ['core', 'ui']
timestamp: 2026-07-01T13:00:55Z
---

# Core UI Framework

Core UI framework: animation interpolators, base controllers, base widgets, combo boxes, list controllers, menu definitions, settings, text params, views, and widget utilities.

## Source Files

- `core/ui/animationInterpolators.swift`
- `core/ui/animationPlaybackOptions.swift`
- `core/ui/autoplayVideoController.swift`
- `core/ui/baseControllers/entityPreviewGameController.swift`
- `core/ui/baseControllers/filterToggleController.swift`
- `core/ui/baseControllers/genericNotificationGameController.swift`
- `core/ui/baseControllers/hudGameController.swift`
- `core/ui/baseControllers/radioGroupController.swift`
- `core/ui/baseControllers/selectorController.swift`
- `core/ui/baseControllers/sliderController.swift`
- `core/ui/baseControllers/spawnLibraryItemController.swift`
- `core/ui/baseControllers/virtualCompoundItemController.swift`
- `core/ui/baseControllers/widgetController.swift`
- `core/ui/baseWidgets/abstractWidgets.swift`
- `core/ui/baseWidgets/inputDisplayController.swift`
- `core/ui/baseWidgets/textWidget.swift`
- `core/ui/buttonAnimatedController.swift`
- `core/ui/buttonDpadSupportedController.swift`
- `core/ui/comboBoxControllers/comboBoxController.swift`
- `core/ui/fullscreenDpadSupported.swift`
- `core/ui/hoverResize.swift`
- `core/ui/listControllers/animatedListItem.swift`
- `core/ui/listControllers/listController.swift`
- `core/ui/listControllers/listItemController.swift`
- `core/ui/listControllers/listItemsGroupController.swift`
- `core/ui/listControllers/phoneWaveformGameController.swift`
- `core/ui/measurementUtils.swift`
- `core/ui/menuDefinitions.swift`
- `core/ui/scriptableDataSource.swift`
- `core/ui/settingsSelectorController.swift`
- `core/ui/textParams.swift`
- `core/ui/textScrollingAnimController.swift`
- `core/ui/uiStructs.swift`
- `core/ui/userSettingsData.swift`
- `core/ui/variantDataSource.swift`
- `core/ui/views/AnimateAnchorOnHoverView.swift`
- `core/ui/views/baseButtonView.swift`
- `core/ui/views/baseToggleView.swift`
- `core/ui/views/buttonCursorStateView.swift`
- `core/ui/views/buttonPlaySoundView.swift`
- `core/ui/views/genericAnimationPlayer.swift`
- `core/ui/views/inputProgressView.swift`
- `core/ui/views/playLibraryAnimationButtonView.swift`
- `core/ui/views/transparencyAnimationToggleView.swift`
- `core/ui/views/transparnecyAnimationButtonView.swift`
- `core/ui/widgetPath.swift`
- `core/ui/widgetReference.swift`
- `core/ui/widgetsSet.swift`

## Member Types

**Total declarations: 114**

### Classs (64)

| Name | Bases | Source File |
|------|-------|-------------|
| inkAnimColor | inkAnimInterpolator | core/ui/animationInterpolators.swift |
| WidgetAnimationManager | IScriptable | core/ui/animationPlaybackOptions.swift |
| AutoplayVideoController | inkLogicController | core/ui/autoplayVideoController.swift |
| inkPreviewGameController | gameuiMenuGameController | core/ui/baseControllers/entityPreviewGameController.swift |
| inkPuppetPreviewGameController | inkPreviewGameController | core/ui/baseControllers/entityPreviewGameController.swift |
| inkGenderSelectionPuppetPreviewGameController | inkPuppetPreviewGameController | core/ui/baseControllers/entityPreviewGameController.swift |
| inkCharacterCreationPuppetPreviewGameController | inkPuppetPreviewGameController | core/ui/baseControllers/entityPreviewGameController.swift |
| inkInventoryPuppetPreviewGameController | inkPuppetPreviewGameController | core/ui/baseControllers/entityPreviewGameController.swift |
| FilterRadioGroup | inkRadioGroupController | core/ui/baseControllers/filterToggleController.swift |
| ToggleController | inkToggleController | core/ui/baseControllers/filterToggleController.swift |
| gameuiGenericNotificationGameController | inkGameController | core/ui/baseControllers/genericNotificationGameController.swift |
| inkHUDGameController | inkGameController | core/ui/baseControllers/hudGameController.swift |
| inkRadioGroupController | inkLogicController | core/ui/baseControllers/radioGroupController.swift |
| SelectorController | inkLogicController | core/ui/baseControllers/selectorController.swift |
| inkSliderController | inkLogicController | core/ui/baseControllers/sliderController.swift |
| SpawnLibraryItemController | inkLogicController | core/ui/baseControllers/spawnLibraryItemController.swift |
| inkVirtualCompoundItemController | inkButtonController | core/ui/baseControllers/virtualCompoundItemController.swift |
| inkIGameController | IScriptable | core/ui/baseControllers/widgetController.swift |
| inkLogicController | inkILogicController | core/ui/baseControllers/widgetController.swift |
| inkWidget | IScriptable | core/ui/baseWidgets/abstractWidgets.swift |
| inkCompoundWidget | inkWidget | core/ui/baseWidgets/abstractWidgets.swift |
| LabelInputDisplayController | inkInputDisplayController | core/ui/baseWidgets/inputDisplayController.swift |
| inkText | inkLeafWidget | core/ui/baseWidgets/textWidget.swift |
| inkButtonAnimatedController | inkButtonController | core/ui/buttonAnimatedController.swift |
| inkButtonDpadSupportedController | inkButtonAnimatedController | core/ui/buttonDpadSupportedController.swift |
| inkComboBoxController | inkLogicController | core/ui/comboBoxControllers/comboBoxController.swift |
| fullscreenDpadSupported | inkLogicController | core/ui/fullscreenDpadSupported.swift |
| inkHoverResizeController | inkLogicController | core/ui/hoverResize.swift |
| AnimatedListItemController | ListItemController | core/ui/listControllers/animatedListItem.swift |
| ListController | inkLogicController | core/ui/listControllers/listController.swift |
| ListItemController | inkButtonController | core/ui/listControllers/listItemController.swift |
| ListItemsGroupController | CodexListItemController | core/ui/listControllers/listItemsGroupController.swift |
| PhoneWaveformGameController | inkGameController | core/ui/listControllers/phoneWaveformGameController.swift |
| MenuScenario_ClippedMenu | inkMenuScenario | core/ui/menuDefinitions.swift |
| ScriptableDataView | BaseScriptableDataSource | core/ui/scriptableDataSource.swift |
| WeakScriptableDataView | BaseWeakScriptableDataSource | core/ui/scriptableDataSource.swift |
| SettingsSelectorController | inkLogicController | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerBool | SettingsSelectorController | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerKeyBinding | SettingsSelectorController | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerRange | SettingsSelectorController | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerInt | SettingsSelectorControllerRange | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerFloat | SettingsSelectorControllerRange | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerList | SettingsSelectorControllerRange | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerListInt | SettingsSelectorControllerList | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerListFloat | SettingsSelectorControllerList | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerListString | SettingsSelectorControllerList | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerListName | SettingsSelectorControllerList | core/ui/settingsSelectorController.swift |
| SettingsSelectorControllerLanguagesList | SettingsSelectorControllerListName | core/ui/settingsSelectorController.swift |
| inkTextParams | IScriptable | core/ui/textParams.swift |
| textScrollingAnimController | inkLogicController | core/ui/textScrollingAnimController.swift |
| ConfigVarBool | ConfigVar | core/ui/userSettingsData.swift |
| GameplaySettingsSystem | ScriptableSystem | core/ui/userSettingsData.swift |
| GameplaySettingsListener | ConfigVarListener | core/ui/userSettingsData.swift |
| VariantDataView | BaseVariantDataSource | core/ui/variantDataSource.swift |
| AnimateAnchorOnHoverView | inkLogicController | core/ui/views/AnimateAnchorOnHoverView.swift |
| BaseButtonView | inkDiscreteNavigationController | core/ui/views/baseButtonView.swift |
| BaseToggleView | inkLogicController | core/ui/views/baseToggleView.swift |
| ButtonCursorStateView | BaseButtonView | core/ui/views/buttonCursorStateView.swift |
| ButtonPlaySoundView | BaseButtonView | core/ui/views/buttonPlaySoundView.swift |
| animationPlayer | inkLogicController | core/ui/views/genericAnimationPlayer.swift |
| InputProgressView | inkLogicController | core/ui/views/inputProgressView.swift |
| PlayLibraryAnimationButtonView | BaseButtonView | core/ui/views/playLibraryAnimationButtonView.swift |
| TransparencyAnimationToggleView | BaseToggleView | core/ui/views/transparencyAnimationToggleView.swift |
| TransparencyAnimationButtonView | BaseButtonView | core/ui/views/transparnecyAnimationButtonView.swift |

### Structs (5)

| Name | Bases | Source File |
|------|-------|-------------|
| MeasurementUtils |  | core/ui/measurementUtils.swift |
| inkWidgetPath |  | core/ui/widgetPath.swift |
| inkWidgetRef |  | core/ui/widgetReference.swift |
| inkCompoundRef |  | core/ui/widgetReference.swift |
| inkTextRef |  | core/ui/widgetReference.swift |

### Static Funcs (4)

| Name | Bases | Source File |
|------|-------|-------------|
| GetAnimOptionsInfiniteLoop |  | core/ui/animationPlaybackOptions.swift |
| NoScreenMessage |  | core/ui/uiStructs.swift |
| OperatorEqual |  | core/ui/widgetReference.swift |
| SelectWidgets |  | core/ui/widgetsSet.swift |

### Funcs (41)

| Name | Bases | Source File |
|------|-------|-------------|
| GetLabelKey |  | core/ui/baseControllers/filterToggleController.swift |
| GetIcon |  | core/ui/baseControllers/filterToggleController.swift |
| GetShouldSaveState |  | core/ui/baseControllers/genericNotificationGameController.swift |
| GetID |  | core/ui/baseControllers/genericNotificationGameController.swift |
| UpdateRequired |  | core/ui/baseControllers/hudGameController.swift |
| GetIntroAnimation |  | core/ui/baseControllers/hudGameController.swift |
| GetOutroAnimation |  | core/ui/baseControllers/hudGameController.swift |
| SetData |  | core/ui/listControllers/listItemsGroupController.swift |
| OpenGroup |  | core/ui/listControllers/listItemsGroupController.swift |
| CloseGroup |  | core/ui/listControllers/listItemsGroupController.swift |
| Select |  | core/ui/listControllers/listItemsGroupController.swift |
| SelectDefault |  | core/ui/listControllers/listItemsGroupController.swift |
| FilterItem |  | core/ui/scriptableDataSource.swift |
| SortItem |  | core/ui/scriptableDataSource.swift |
| FilterItem |  | core/ui/scriptableDataSource.swift |
| SortItem |  | core/ui/scriptableDataSource.swift |
| SetInteractive |  | core/ui/settingsSelectorController.swift |
| Setup |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| Setup |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| SetInteractive |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| Setup |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| Setup |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| Setup |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| Setup |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| Setup |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| Setup |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| Setup |  | core/ui/settingsSelectorController.swift |
| Refresh |  | core/ui/settingsSelectorController.swift |
| OnVarModified |  | core/ui/userSettingsData.swift |
| FilterItem |  | core/ui/scriptableDataSource.swift |
| SortItem |  | core/ui/scriptableDataSource.swift |

## Citations

- `core/ui/animationInterpolators.swift`
- `core/ui/animationPlaybackOptions.swift`
- `core/ui/autoplayVideoController.swift`
- `core/ui/baseControllers/entityPreviewGameController.swift`
- `core/ui/baseControllers/filterToggleController.swift`
- `core/ui/baseControllers/genericNotificationGameController.swift`
- `core/ui/baseControllers/hudGameController.swift`
- `core/ui/baseControllers/radioGroupController.swift`
- `core/ui/baseControllers/selectorController.swift`
- `core/ui/baseControllers/sliderController.swift`
- `core/ui/baseControllers/spawnLibraryItemController.swift`
- `core/ui/baseControllers/virtualCompoundItemController.swift`
- `core/ui/baseControllers/widgetController.swift`
- `core/ui/baseWidgets/abstractWidgets.swift`
- `core/ui/baseWidgets/inputDisplayController.swift`
- `core/ui/baseWidgets/textWidget.swift`
- `core/ui/buttonAnimatedController.swift`
- `core/ui/buttonDpadSupportedController.swift`
- `core/ui/comboBoxControllers/comboBoxController.swift`
- `core/ui/fullscreenDpadSupported.swift`
- `core/ui/hoverResize.swift`
- `core/ui/listControllers/animatedListItem.swift`
- `core/ui/listControllers/listController.swift`
- `core/ui/listControllers/listItemController.swift`
- `core/ui/listControllers/listItemsGroupController.swift`
- `core/ui/listControllers/phoneWaveformGameController.swift`
- `core/ui/measurementUtils.swift`
- `core/ui/menuDefinitions.swift`
- `core/ui/scriptableDataSource.swift`
- `core/ui/settingsSelectorController.swift`
- `core/ui/textParams.swift`
- `core/ui/textScrollingAnimController.swift`
- `core/ui/uiStructs.swift`
- `core/ui/userSettingsData.swift`
- `core/ui/variantDataSource.swift`
- `core/ui/views/AnimateAnchorOnHoverView.swift`
- `core/ui/views/baseButtonView.swift`
- `core/ui/views/baseToggleView.swift`
- `core/ui/views/buttonCursorStateView.swift`
- `core/ui/views/buttonPlaySoundView.swift`
- `core/ui/views/genericAnimationPlayer.swift`
- `core/ui/views/inputProgressView.swift`
- `core/ui/views/playLibraryAnimationButtonView.swift`
- `core/ui/views/transparencyAnimationToggleView.swift`
- `core/ui/views/transparnecyAnimationButtonView.swift`
- `core/ui/widgetPath.swift`
- `core/ui/widgetReference.swift`
- `core/ui/widgetsSet.swift`
