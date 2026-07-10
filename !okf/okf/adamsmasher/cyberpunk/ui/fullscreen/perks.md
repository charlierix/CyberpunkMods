---
type: "UI System"
title: "Perks UI"
description: "Perks UI: display controller, screen controller, new perks (skills, tabs, attribute button, categories, cyberware details, gauge, perk container, perk item, screen logic), perks data, level bar, main, attribute display, attribute item, tooltips, points display, and skills levels container."
resource: "!cyberpunk/UI/fullscreen/perks/PerkDisplayController.swift"
tags: ['cyberpunk', 'ui', 'fullscreen', 'perks']
timestamp: 2026-07-01T13:00:55Z
---

# Perks UI

Perks UI: display controller, screen controller, new perks (skills, tabs, attribute button, categories, cyberware details, gauge, perk container, perk item, screen logic), perks data, level bar, main, attribute display, attribute item, tooltips, points display, and skills levels container.

## Source Files

- `cyberpunk/UI/fullscreen/perks/PerkDisplayController.swift`
- `cyberpunk/UI/fullscreen/perks/PerkScreenController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerkSkillsLogicController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerkTabsController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksAttributeButtonController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCategoriesGameController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCyberwareDetailsNotification.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksGaugeController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksPerkContainerLogicController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksPerkItemLogicController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksScreenLogicController.swift`
- `cyberpunk/UI/fullscreen/perks/perksData.swift`
- `cyberpunk/UI/fullscreen/perks/perksLevelBarController.swift`
- `cyberpunk/UI/fullscreen/perks/perksMain.swift`
- `cyberpunk/UI/fullscreen/perks/perksMenuAttributeDisplayController.swift`
- `cyberpunk/UI/fullscreen/perks/perksMenuAttributeItem.swift`
- `cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift`
- `cyberpunk/UI/fullscreen/perks/perksPointsDisplayController.swift`
- `cyberpunk/UI/fullscreen/perks/perksSkillsLevelsContainerController.swift`

## Member Types

**Total declarations: 80**

### Classs (51)

| Name | Bases | Source File |
|------|-------|-------------|
| PerkDisplayController | inkButtonController | cyberpunk/UI/fullscreen/perks/PerkDisplayController.swift |
| PerkDisplayContainerController | inkLogicController | cyberpunk/UI/fullscreen/perks/PerkDisplayController.swift |
| PerkScreenController | inkLogicController | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| PerksSkillLabelController | HubMenuLabelController | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| PerksSkillLabelContentContainer | HubMenuLabelContentContainer | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| PerksScreenStaticData | IScriptable | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| ProficiencyTabButtonController | TabButtonController | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| TabRadioGroup | inkRadioGroupController | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| TabButtonController | inkToggleController | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| NewPerkSkillsLogicController | inkLogicController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerkSkillsLogicController.swift |
| NewPerksSkillBarLogicController | inkVirtualCompoundItemController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerkSkillsLogicController.swift |
| NewPerksSkillLevelLogicController | inkLogicController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerkSkillsLogicController.swift |
| NewPerkTabsController | inkLogicController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerkTabsController.swift |
| NewPerkTabsArrowController | inkLogicController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerkTabsController.swift |
| NewPerksAttributeButtonController | inkLogicController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksAttributeButtonController.swift |
| NewPerksCategoriesGameController | gameuiMenuGameController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCategoriesGameController.swift |
| NewPerksCyberwareTooltipController | AGenericTooltipController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCyberwareDetailsNotification.swift |
| EspionageTooltipSettingsListener | ConfigVarListener | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCyberwareDetailsNotification.swift |
| NewPerksGaugeController | inkLogicController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksGaugeController.swift |
| NewPerksPerkContainerLogicController | inkLogicController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksPerkContainerLogicController.swift |
| NewPerksPerkItemLogicController | inkLogicController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksPerkItemLogicController.swift |
| NewPerksScreenLogicController | inkLogicController | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksScreenLogicController.swift |
| NewPerksRequirementsLinksManager | IScriptable | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksScreenLogicController.swift |
| IDisplayData | IScriptable | cyberpunk/UI/fullscreen/perks/perksData.swift |
| PerkDisplayData | BasePerkDisplayData | cyberpunk/UI/fullscreen/perks/perksData.swift |
| NewPerkDisplayData | BasePerkDisplayData | cyberpunk/UI/fullscreen/perks/perksData.swift |
| TraitDisplayData | BasePerkDisplayData | cyberpunk/UI/fullscreen/perks/perksData.swift |
| ProficiencyDisplayData | IDisplayData | cyberpunk/UI/fullscreen/perks/perksData.swift |
| AttributeDisplayData | IDisplayData | cyberpunk/UI/fullscreen/perks/perksData.swift |
| AttributeData | IDisplayData | cyberpunk/UI/fullscreen/perks/perksData.swift |
| PerkLevelData_Records | BasePerkLevelData_Records | cyberpunk/UI/fullscreen/perks/perksData.swift |
| NewPerkLevelData_Records | BasePerkLevelData_Records | cyberpunk/UI/fullscreen/perks/perksData.swift |
| BasePerkLevelData_Records | IScriptable | cyberpunk/UI/fullscreen/perks/perksData.swift |
| PlayerDevelopmentDataManager | IScriptable | cyberpunk/UI/fullscreen/perks/perksData.swift |
| PerksLevelBarController | inkLogicController | cyberpunk/UI/fullscreen/perks/perksLevelBarController.swift |
| PerksMainGameController | gameuiMenuGameController | cyberpunk/UI/fullscreen/perks/perksMain.swift |
| PerksMenuAttributeDisplayController | BaseButtonView | cyberpunk/UI/fullscreen/perks/perksMenuAttributeDisplayController.swift |
| PerksMenuAttributeItemController | inkLogicController | cyberpunk/UI/fullscreen/perks/perksMenuAttributeItem.swift |
| ProficiencyButtonController | inkButtonController | cyberpunk/UI/fullscreen/perks/perksMenuAttributeItem.swift |
| BasePerksMenuTooltipData | ATooltipData | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| AttributeTooltipData | BasePerksMenuTooltipData | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| SkillTooltipData | BasePerksMenuTooltipData | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| NewPerkTooltipData | BasePerksMenuTooltipData | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| PerkTooltipData | BasePerksMenuTooltipData | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| TraitTooltipData | BasePerksMenuTooltipData | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| PerkDisplayTooltipController | AGenericTooltipControllerWithDebug | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| PerkDisplayTooltipSettingsListener | ConfigVarListener | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| PerkMenuTooltipController | AGenericTooltipController | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| PerksPointsDisplayController | inkLogicController | cyberpunk/UI/fullscreen/perks/perksPointsDisplayController.swift |
| PerksSkillsLevelsContainerController | inkLogicController | cyberpunk/UI/fullscreen/perks/perksSkillsLevelsContainerController.swift |
| PerksSkillsLevelDisplayController | inkLogicController | cyberpunk/UI/fullscreen/perks/perksSkillsLevelsContainerController.swift |

### Structs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| PerkAttributeHelper |  | cyberpunk/UI/fullscreen/perks/perksMenuAttributeDisplayController.swift |

### Enums (1)

| Name | Bases | Source File |
|------|-------|-------------|
| name |  | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |

### Funcs (27)

| Name | Bases | Source File |
|------|-------|-------------|
| SetTargetData |  | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| SetActive |  | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| SetData |  | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| GetLabelKey |  | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| GetIcon |  | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| Show |  | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCyberwareDetailsNotification.swift |
| Refresh |  | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCyberwareDetailsNotification.swift |
| SetData |  | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| OnVarModified |  | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCyberwareDetailsNotification.swift |
| CreateTooltipData |  | cyberpunk/UI/fullscreen/perks/perksData.swift |
| CreateTooltipData |  | cyberpunk/UI/fullscreen/perks/perksData.swift |
| CreateTooltipData |  | cyberpunk/UI/fullscreen/perks/perksData.swift |
| CreateTooltipData |  | cyberpunk/UI/fullscreen/perks/perksData.swift |
| CreateTooltipData |  | cyberpunk/UI/fullscreen/perks/perksData.swift |
| CreateTooltipData |  | cyberpunk/UI/fullscreen/perks/perksData.swift |
| CreateTooltipData |  | cyberpunk/UI/fullscreen/perks/perksData.swift |
| RefreshRuntimeData |  | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| RefreshRuntimeData |  | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| RefreshRuntimeData |  | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| RefreshRuntimeData |  | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| RefreshRuntimeData |  | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| RefreshRuntimeData |  | cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift |
| Refresh |  | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCyberwareDetailsNotification.swift |
| SetData |  | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |
| OnVarModified |  | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCyberwareDetailsNotification.swift |
| Refresh |  | cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCyberwareDetailsNotification.swift |
| SetData |  | cyberpunk/UI/fullscreen/perks/PerkScreenController.swift |

## Citations

- `cyberpunk/UI/fullscreen/perks/PerkDisplayController.swift`
- `cyberpunk/UI/fullscreen/perks/PerkScreenController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerkSkillsLogicController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerkTabsController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksAttributeButtonController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCategoriesGameController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksCyberwareDetailsNotification.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksGaugeController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksPerkContainerLogicController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksPerkItemLogicController.swift`
- `cyberpunk/UI/fullscreen/perks/newPerks/NewPerksScreenLogicController.swift`
- `cyberpunk/UI/fullscreen/perks/perksData.swift`
- `cyberpunk/UI/fullscreen/perks/perksLevelBarController.swift`
- `cyberpunk/UI/fullscreen/perks/perksMain.swift`
- `cyberpunk/UI/fullscreen/perks/perksMenuAttributeDisplayController.swift`
- `cyberpunk/UI/fullscreen/perks/perksMenuAttributeItem.swift`
- `cyberpunk/UI/fullscreen/perks/perksMenuTooltips.swift`
- `cyberpunk/UI/fullscreen/perks/perksPointsDisplayController.swift`
- `cyberpunk/UI/fullscreen/perks/perksSkillsLevelsContainerController.swift`
