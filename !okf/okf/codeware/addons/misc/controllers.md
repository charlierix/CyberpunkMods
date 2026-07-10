---
type: "Addon"
title: "Misc Controllers Addons"
description: "Field additions to misc controllers types (22 types)."
resource: "codeware/scripts/"
tags: "[addons, controllers]"
timestamp: 2026-07-01T18:09:41Z
---

# Overview

Field additions to misc controllers types (22 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| BaseDirectionalIndicatorPartLogicController | addon | — | defaultForwardFovRange, adjustedForwardFovRange |
| BaseInteractionMappinController | addon | — | canvasWidgetName, arrowWidgetName |
| BaseMappinBaseController | addon | — | scaleWidget |
| BaseMinimapMappinController | addon | — | iconOrientation, fixedOrientationWidget |
| BaseWorldMapMappinController | addon | — | groupContainerWidget, groupCountTextWidget |
| ControllerSettingsGameController | addon | — | defaultWidgets, southpawWidgets, legacyWidgets |
| DamageIndicatorGameController | addon | — | maxVisibleParts |
| DamageIndicatorPartLogicController | addon | — | maxDistanceForSharedIndicators |
| DriverCombatHUDGameController | addon | — | crosshairBrackets, crosshairBracketsFlairLeft, crosshairBracketsFlairRight, bracketsTransitionDetailsWidgetList, crosshairBracketsMinSize |
| HDRSettingsGameController | addon | — | callibrationScreen, callibrationScreenTarget, callibrationScreenAtlas |
| HackingMinigameGameController | addon | — | symbolsRecordTDBID, deviceMode |
| HoldIndicatorGameController | addon | — | HoldProgress, HoldStart, HoldFinish, HoldStop |
| InitialLoadingScreenLogicController | addon | — | skipButtonPanel, loadingPartsContainer, afterSkipAnimation, loadingFinishedAudioStopEvent |
| ListController | addon | — | itemLibraryID, cycledNavigation, beginToggled, ItemSelected, ItemActivated |
| ListItemController | addon | — | ToggledOff, ToggledOn, Selected, Deselected, AddedToList |
| LoadingScreenLogicController | addon | — | mainBackgroundImage, supportBackgroundImage, introAnimationName, loopAnimationName, tooltipAnimName |
| MainMenuGameController | addon | — | backgroundContainer |
| MappinsContainerController | addon | — | tier, spawnContainerPath, gpsQuestPathWidget, gpsPlayerTrackedPathWidget, gpsDelamainPathWidget |
| PhoneWaveformGameController | addon | — | measurementsIntreval, measurementsCount |
| SelectorController | addon | — | index, values, cycledNavigation, SelectionChanged |
| SongbirdAudioCallGameController | addon | — | waveformEnabled, voLevelsUpdateTimer, intensityMultiplier, targets |
| TutorialOverlayLogicController | addon | — | hideInMenu |

# Citations

- `codeware/scripts/Base/Addons/BaseDirectionalIndicatorPartLogicController.reds`
- `codeware/scripts/Base/Addons/BaseInteractionMappinController.reds`
- `codeware/scripts/Base/Addons/BaseMappinBaseController.reds`
- `codeware/scripts/Base/Addons/BaseMinimapMappinController.reds`
- `codeware/scripts/Base/Addons/BaseWorldMapMappinController.reds`
- `codeware/scripts/Base/Addons/ControllerSettingsGameController.reds`
- `codeware/scripts/Base/Addons/DamageIndicatorGameController.reds`
- `codeware/scripts/Base/Addons/DamageIndicatorPartLogicController.reds`
- `codeware/scripts/Base/Addons/DriverCombatHUDGameController.reds`
- `codeware/scripts/Base/Addons/HDRSettingsGameController.reds`
- ... and 12 more source files
