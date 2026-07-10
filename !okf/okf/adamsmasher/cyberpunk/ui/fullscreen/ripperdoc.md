---
type: "UI System"
title: "Ripperdoc UI"
description: "Ripperdoc UI: cyberware minigrid, money label, pulse animation, main controller, animation controller, armor meters, bar tooltip, category tooltip, CW preview, fill bar, fill label, inventory controller, meter capacity, meters, meters bars, perk controller, perk tooltip, selector, shard, token popup, shopping cart item."
resource: "!cyberpunk/UI/fullscreen/ripperdoc/cyberwareMinigrid.swift"
tags: ['cyberpunk', 'ui', 'fullscreen', 'ripperdoc']
timestamp: 2026-07-01T13:00:55Z
---

# Ripperdoc UI

Ripperdoc UI: cyberware minigrid, money label, pulse animation, main controller, animation controller, armor meters, bar tooltip, category tooltip, CW preview, fill bar, fill label, inventory controller, meter capacity, meters, meters bars, perk controller, perk tooltip, selector, shard, token popup, shopping cart item.

## Source Files

- `cyberpunk/UI/fullscreen/ripperdoc/cyberwareMinigrid.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/moneyLabelController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/pulseAnimation.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocAnimationController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocArmorMeters.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocBarTooltip.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocCategoryTooltip.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocCwPreviewItemController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocFillBar.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocFillLabel.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocInventoryController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocMeterCapacity.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocMeters.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocMetersBars.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocPerkController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocPerkTooltip.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocSelectorController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocShardController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocTokenPopup.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/shoppingCartListItem.swift`

## Member Types

**Total declarations: 38**

### Classs (30)

| Name | Bases | Source File |
|------|-------|-------------|
| CyberwareInventoryMiniGrid | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/cyberwareMinigrid.swift |
| MoneyLabelController | inkTextValueProgressController | cyberpunk/UI/fullscreen/ripperdoc/moneyLabelController.swift |
| PulseAnimation | IScriptable | cyberpunk/UI/fullscreen/ripperdoc/pulseAnimation.swift |
| PulseScaleAnimation | PulseAnimation | cyberpunk/UI/fullscreen/ripperdoc/pulseAnimation.swift |
| RipperDocItemBoughtCallback | InventoryScriptCallback | cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift |
| RipperDocGameController | gameuiMenuGameController | cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift |
| CyberwareTemplateClassifier | inkVirtualItemTemplateClassifier | cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift |
| RipperdocCyberwareEquipAnimationCategory | IScriptable | cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift |
| WrappedUIInventoryItem | IScriptable | cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift |
| VendorItemAdditionalData | IScriptable | cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift |
| RipperdocScreenAnimationController | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocAnimationController.swift |
| RipperdocMetersArmor | RipperdocMetersBase | cyberpunk/UI/fullscreen/ripperdoc/ripperdocArmorMeters.swift |
| RipperdocBarTooltip | AGenericTooltipController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocBarTooltip.swift |
| RipperdocCategoryTooltip | AGenericTooltipController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocCategoryTooltip.swift |
| RipperdocCwPreviewItemController | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocCwPreviewItemController.swift |
| RipperdocFillBar | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocFillBar.swift |
| RipperdocFillLabel | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocFillLabel.swift |
| RipperdocInventoryController | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocInventoryController.swift |
| RipperdocWrappedUIInventoryItem | IScriptable | cyberpunk/UI/fullscreen/ripperdoc/ripperdocInventoryController.swift |
| RipperdocInventoryItem | inkVirtualCompoundItemController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocInventoryController.swift |
| RipperdocInventoryTemplateClassifier | inkVirtualItemTemplateClassifier | cyberpunk/UI/fullscreen/ripperdoc/ripperdocInventoryController.swift |
| RipperdocMetersCapacity | RipperdocMetersBase | cyberpunk/UI/fullscreen/ripperdoc/ripperdocMeterCapacity.swift |
| RipperdocMetersBase | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocMeters.swift |
| RipperdocNewMeterBar | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocMetersBars.swift |
| RipperdocPerkController | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocPerkController.swift |
| RipperdocPerkTooltip | AGenericTooltipController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocPerkTooltip.swift |
| RipperdocSelectorController | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocSelectorController.swift |
| RipperdocShardController | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocShardController.swift |
| RipperdocTokenPopup | inkGameController | cyberpunk/UI/fullscreen/ripperdoc/ripperdocTokenPopup.swift |
| ShoppingCartListItem | inkLogicController | cyberpunk/UI/fullscreen/ripperdoc/shoppingCartListItem.swift |

### Funcs (8)

| Name | Bases | Source File |
|------|-------|-------------|
| Start |  | cyberpunk/UI/fullscreen/ripperdoc/pulseAnimation.swift |
| Start |  | cyberpunk/UI/fullscreen/ripperdoc/pulseAnimation.swift |
| OnItemAdded |  | cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift |
| ClassifyItem |  | cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift |
| SetData |  | cyberpunk/UI/fullscreen/ripperdoc/ripperdocBarTooltip.swift |
| SetData |  | cyberpunk/UI/fullscreen/ripperdoc/ripperdocBarTooltip.swift |
| ClassifyItem |  | cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift |
| SetData |  | cyberpunk/UI/fullscreen/ripperdoc/ripperdocBarTooltip.swift |

## Citations

- `cyberpunk/UI/fullscreen/ripperdoc/cyberwareMinigrid.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/moneyLabelController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/pulseAnimation.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdoc.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocAnimationController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocArmorMeters.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocBarTooltip.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocCategoryTooltip.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocCwPreviewItemController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocFillBar.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocFillLabel.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocInventoryController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocMeterCapacity.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocMeters.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocMetersBars.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocPerkController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocPerkTooltip.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocSelectorController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocShardController.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/ripperdocTokenPopup.swift`
- `cyberpunk/UI/fullscreen/ripperdoc/shoppingCartListItem.swift`
