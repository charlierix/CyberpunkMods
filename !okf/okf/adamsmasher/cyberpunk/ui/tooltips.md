---
type: "UI System"
title: "Tooltip UI"
description: "Tooltips: inventory slot wrapper, inventory slot, inventory data, inventory elements, cyberdeck, cyberware, cyberware data, generic tooltip, item tooltip, item tooltip controller, item tooltip mod, item tooltip stat, level bars, material, message, minimal item data, new item tooltip, new item tooltip mod, program, tooltip cycle dot, tooltip progress bar, tooltip provider, tooltip randomized stats, tooltips manager, visual, and new tooltip subfolder."
resource: "!cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift"
tags: ['cyberpunk', 'ui', 'tooltips']
timestamp: 2026-07-01T13:00:55Z
---

# Tooltip UI

Tooltips: inventory slot wrapper, inventory slot, inventory data, inventory elements, cyberdeck, cyberware, cyberware data, generic tooltip, item tooltip, item tooltip controller, item tooltip mod, item tooltip stat, level bars, material, message, minimal item data, new item tooltip, new item tooltip mod, program, tooltip cycle dot, tooltip progress bar, tooltip provider, tooltip randomized stats, tooltips manager, visual, and new tooltip subfolder.

## Source Files

- `cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift`
- `cyberpunk/UI/tooltips/InventoryTooltip.swift`
- `cyberpunk/UI/tooltips/InventoryTooltipData.swift`
- `cyberpunk/UI/tooltips/InventoryTooltipElements.swift`
- `cyberpunk/UI/tooltips/cyberdeckTooltip.swift`
- `cyberpunk/UI/tooltips/cyberwareTooltip.swift`
- `cyberpunk/UI/tooltips/cyberwareTooltipData.swift`
- `cyberpunk/UI/tooltips/genericTooltip.swift`
- `cyberpunk/UI/tooltips/itemTooltip.swift`
- `cyberpunk/UI/tooltips/itemTooltipController.swift`
- `cyberpunk/UI/tooltips/itemTooltipMod.swift`
- `cyberpunk/UI/tooltips/itemTooltipStat.swift`
- `cyberpunk/UI/tooltips/levelBarsController.swift`
- `cyberpunk/UI/tooltips/materialTooltip.swift`
- `cyberpunk/UI/tooltips/messageTooltip.swift`
- `cyberpunk/UI/tooltips/minimalItemTooltipData.swift`
- `cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift`
- `cyberpunk/UI/tooltips/newTooltip/newItemTooltipMod.swift`
- `cyberpunk/UI/tooltips/programTooltip.swift`
- `cyberpunk/UI/tooltips/tooltipCycleDotController.swift`
- `cyberpunk/UI/tooltips/tooltipProgressBar.swift`
- `cyberpunk/UI/tooltips/tooltipProvider.swift`
- `cyberpunk/UI/tooltips/tooltipRandomizedStats.swift`
- `cyberpunk/UI/tooltips/tooltipsManager.swift`
- `cyberpunk/UI/tooltips/visualTooltipController.swift`

## Member Types

**Total declarations: 145**

### Classs (79)

| Name | Bases | Source File |
|------|-------|-------------|
| InventorySlotWrapperTooltip | AGenericTooltipController | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| InventorySlotTooltip | AGenericTooltipController | cyberpunk/UI/tooltips/InventoryTooltip.swift |
| InventoryTooltipData | ATooltipData | cyberpunk/UI/tooltips/InventoryTooltipData.swift |
| InventoryTooltiData_CyberwareUpgradeData | IScriptable | cyberpunk/UI/tooltips/InventoryTooltipData.swift |
| TooltipSpecialAbilityList | inkLogicController | cyberpunk/UI/tooltips/InventoryTooltipElements.swift |
| TooltipSpecialAbilityDisplay | inkLogicController | cyberpunk/UI/tooltips/InventoryTooltipElements.swift |
| InventoryItemAttachmentsList | inkLogicController | cyberpunk/UI/tooltips/InventoryTooltipElements.swift |
| InventoryItemStatList | inkLogicController | cyberpunk/UI/tooltips/InventoryTooltipElements.swift |
| InventoryItemStatItem | inkLogicController | cyberpunk/UI/tooltips/InventoryTooltipElements.swift |
| StatisticDifferenceBarController | inkLogicController | cyberpunk/UI/tooltips/InventoryTooltipElements.swift |
| DamageTypeIndicator | inkLogicController | cyberpunk/UI/tooltips/InventoryTooltipElements.swift |
| CyberdeckTooltip | AGenericTooltipController | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| CyberdeckTooltipSettingsListener | ConfigVarListener | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| CyberdeckDeviceHackIcon | inkLogicController | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| CyberdeckStatController | inkLogicController | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| CyberwareTooltip | AGenericTooltipController | cyberpunk/UI/tooltips/cyberwareTooltip.swift |
| CyberwareTooltipSlotListItem | AGenericTooltipController | cyberpunk/UI/tooltips/cyberwareTooltip.swift |
| CyberwareTooltipData | ATooltipData | cyberpunk/UI/tooltips/cyberwareTooltipData.swift |
| AGenericTooltipController | inkLogicController | cyberpunk/UI/tooltips/genericTooltip.swift |
| AGenericTooltipControllerWithDebug | AGenericTooltipController | cyberpunk/UI/tooltips/genericTooltip.swift |
| IdentifiedWrappedTooltipData | ATooltipData | cyberpunk/UI/tooltips/genericTooltip.swift |
| UIInventoryItemTooltipWrapper | ATooltipData | cyberpunk/UI/tooltips/genericTooltip.swift |
| ItemTooltipController | AGenericTooltipControllerWithDebug | cyberpunk/UI/tooltips/itemTooltip.swift |
| ItemTooltipCommonController | AGenericTooltipControllerWithDebug | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipModuleController | inkLogicController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipRepiceModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipHeaderController | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipIconModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipWeaponInfoModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipClothingInfoModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipGrenadeInfoModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipCyberwareWeaponModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipRequirementsModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipDetailsModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipRecipeDataModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipEvolutionModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipCraftedModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipCyberwareUpgradeController | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipBottomModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipAttributeRequirement | inkLogicController | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipSettingsListener | ConfigVarListener | cyberpunk/UI/tooltips/itemTooltipController.swift |
| ItemTooltipModController | inkLogicController | cyberpunk/UI/tooltips/itemTooltipMod.swift |
| ItemTooltipModEntryController | inkLogicController | cyberpunk/UI/tooltips/itemTooltipMod.swift |
| ItemTooltipModSettingsListener | ConfigVarListener | cyberpunk/UI/tooltips/itemTooltipMod.swift |
| ItemTooltipStatController | inkLogicController | cyberpunk/UI/tooltips/itemTooltipStat.swift |
| ItemTooltipStatSettingsListener | ConfigVarListener | cyberpunk/UI/tooltips/itemTooltipStat.swift |
| LevelBarsController | inkLogicController | cyberpunk/UI/tooltips/levelBarsController.swift |
| MaterialTooltip | AGenericTooltipController | cyberpunk/UI/tooltips/materialTooltip.swift |
| MessageTooltip | AGenericTooltipController | cyberpunk/UI/tooltips/messageTooltip.swift |
| MessageDescTooltip | MessageTooltip | cyberpunk/UI/tooltips/messageTooltip.swift |
| TransmogMessageDescTooltip | MessageTooltip | cyberpunk/UI/tooltips/messageTooltip.swift |
| MinimalItemTooltipData | ATooltipData | cyberpunk/UI/tooltips/minimalItemTooltipData.swift |
| NewItemTooltipCommonController | AGenericTooltipControllerWithDebug | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipModuleController | inkLogicController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipRepiceModule | NewItemTooltipModuleController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipHeaderController | NewItemTooltipModuleController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipWeaponBarsModule | NewItemTooltipModuleController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipStatBarController | inkLogicController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipRequirementsModule | NewItemTooltipModuleController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipDetailsStatsModule | NewItemTooltipModuleController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipDetailsModule | NewItemTooltipModuleController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipBottomModule | NewItemTooltipModuleController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipDescriptionModule | NewItemTooltipModuleController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipBrokenModule | NewItemTooltipModuleController | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipSettingsListener | ConfigVarListener | cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift |
| NewItemTooltipAttachmentGroupController | inkLogicController | cyberpunk/UI/tooltips/newTooltip/newItemTooltipMod.swift |
| NewItemTooltipAttachmentEntryController | inkLogicController | cyberpunk/UI/tooltips/newTooltip/newItemTooltipMod.swift |
| NewItemTooltipAttachmentEntrySettingsListener | ConfigVarListener | cyberpunk/UI/tooltips/newTooltip/newItemTooltipMod.swift |
| NewItemTooltipAttachmentEntryData | IScriptable | cyberpunk/UI/tooltips/newTooltip/newItemTooltipMod.swift |
| ProgramTooltipController | AGenericTooltipControllerWithDebug | cyberpunk/UI/tooltips/programTooltip.swift |
| ProgramTooltipEffectController | ItemTooltipModController | cyberpunk/UI/tooltips/programTooltip.swift |
| ProgramTooltipStatController | inkLogicController | cyberpunk/UI/tooltips/programTooltip.swift |
| TooltipCycleDotController | inkLogicController | cyberpunk/UI/tooltips/tooltipCycleDotController.swift |
| TooltipProgessBarController | inkLogicController | cyberpunk/UI/tooltips/tooltipProgressBar.swift |
| TooltipProvider | inkLogicController | cyberpunk/UI/tooltips/tooltipProvider.swift |
| ItemRandomizedStatsController | inkLogicController | cyberpunk/UI/tooltips/tooltipRandomizedStats.swift |
| gameuiTooltipsManager | inkLogicController | cyberpunk/UI/tooltips/tooltipsManager.swift |
| VisualTooltipController | ItemTooltipCommonController | cyberpunk/UI/tooltips/visualTooltipController.swift |
| ItemTooltipTransmogModule | ItemTooltipModuleController | cyberpunk/UI/tooltips/visualTooltipController.swift |

### Funcs (66)

| Name | Bases | Source File |
|------|-------|-------------|
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| SetStyle |  | cyberpunk/UI/tooltips/InventoryTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| Show |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| OnVarModified |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| SetStyle |  | cyberpunk/UI/tooltips/InventoryTooltip.swift |
| Show |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| Hide |  | cyberpunk/UI/tooltips/genericTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| Refresh |  | cyberpunk/UI/tooltips/genericTooltip.swift |
| PrespawnLazyModules |  | cyberpunk/UI/tooltips/genericTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| Show |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| PrespawnLazyModules |  | cyberpunk/UI/tooltips/genericTooltip.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| OnVarModified |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| OnVarModified |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| OnVarModified |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| Show |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| Show |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| PrespawnLazyModules |  | cyberpunk/UI/tooltips/genericTooltip.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| OnVarModified |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| OnVarModified |  | cyberpunk/UI/tooltips/cyberdeckTooltip.swift |
| SetData |  | cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift |
| Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |
| NEW_Update |  | cyberpunk/UI/tooltips/itemTooltipController.swift |

## Citations

- `cyberpunk/UI/tooltips/InventorySlotWrapperTooltip.swift`
- `cyberpunk/UI/tooltips/InventoryTooltip.swift`
- `cyberpunk/UI/tooltips/InventoryTooltipData.swift`
- `cyberpunk/UI/tooltips/InventoryTooltipElements.swift`
- `cyberpunk/UI/tooltips/cyberdeckTooltip.swift`
- `cyberpunk/UI/tooltips/cyberwareTooltip.swift`
- `cyberpunk/UI/tooltips/cyberwareTooltipData.swift`
- `cyberpunk/UI/tooltips/genericTooltip.swift`
- `cyberpunk/UI/tooltips/itemTooltip.swift`
- `cyberpunk/UI/tooltips/itemTooltipController.swift`
- `cyberpunk/UI/tooltips/itemTooltipMod.swift`
- `cyberpunk/UI/tooltips/itemTooltipStat.swift`
- `cyberpunk/UI/tooltips/levelBarsController.swift`
- `cyberpunk/UI/tooltips/materialTooltip.swift`
- `cyberpunk/UI/tooltips/messageTooltip.swift`
- `cyberpunk/UI/tooltips/minimalItemTooltipData.swift`
- `cyberpunk/UI/tooltips/newTooltip/newItemTooltip.swift`
- `cyberpunk/UI/tooltips/newTooltip/newItemTooltipMod.swift`
- `cyberpunk/UI/tooltips/programTooltip.swift`
- `cyberpunk/UI/tooltips/tooltipCycleDotController.swift`
- `cyberpunk/UI/tooltips/tooltipProgressBar.swift`
- `cyberpunk/UI/tooltips/tooltipProvider.swift`
- `cyberpunk/UI/tooltips/tooltipRandomizedStats.swift`
- `cyberpunk/UI/tooltips/tooltipsManager.swift`
- `cyberpunk/UI/tooltips/visualTooltipController.swift`
