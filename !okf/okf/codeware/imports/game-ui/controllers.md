---
type: "Import"
title: "Game-Ui Controllers"
description: "Imported game-ui controllers types (40 types)."
resource: "codeware/scripts/"
tags: "[imports, controllers]"
timestamp: 2026-07-01T18:09:13Z
---

# Overview

Imported game-ui controllers types (40 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameuiAdvertLightColorPickerController | class | inkLogicController | lightColor |
| gameuiAugmentedRealitySignGameController | class | inkGameController | — |
| gameuiBaseMenuGameControllerPuppetGenderInfo | enum | — | Male, Female, ShouldBeDetermined |
| gameuiBaseMenuGameControllerPuppetSceneInfo | struct | — | sceneName, prefabRef, puppetRecordId |
| gameuiBodyControllerCustomizationStateUpdater | class | gameuiICustomizationStateUpdater | — |
| gameuiBodyPartsControllerCustomizationStateUpdater | class | gameuiICustomizationStateUpdater | — |
| gameuiBriefingGameController | class | inkGameController | briefingPlayerType |
| gameuiCharacterCustomizationArmCyberwareController | class | gameuiCharacterCustomizationBodyPartsController | defaultGroupName, additionalCyberArmAppearances |
| gameuiCharacterCustomizationBeardController | class | gameuiCharacterCustomizationHeadPartsController | — |
| gameuiCharacterCustomizationBodyController | class | gameuiICharacterCustomizationBodyController | — |
| gameuiCharacterCustomizationBodyPartsController | class | gameuiICharacterCustomizationBodyPartsController | isHiddenInFpp |
| gameuiCharacterCustomizationBrokenNoseController | class | gameuiICharacterCustomizationComponent | stage1App, stage2App, finalSceneGroup |
| gameuiCharacterCustomizationBrokenNoseControllerBrokenNoseAppearance | struct | — | resource, definition |
| gameuiCharacterCustomizationFaceController | class | gameuiCharacterCustomizationHeadPartsController | — |
| gameuiCharacterCustomizationFeetController | class | gameuiCharacterCustomizationBodyPartsController | liftedFeetGroupName, flatFeetGroupName |
| gameuiCharacterCustomizationGenitalsController | class | gameuiCharacterCustomizationBodyPartsController | upperBodyGroupName, bottomBodyGroupName, forceHideGenitals |
| gameuiCharacterCustomizationHairstyleController | class | gameuiCharacterCustomizationHeadPartsController | — |
| gameuiCharacterCustomizationHeadPartsController | class | gameuiCharacterCustomizationBodyPartsController | groupName |
| gameuiCharacterCustomizationNailsController | class | gameuiCharacterCustomizationBodyPartsController | nailsGroupName |
| gameuiCharacterCustomizationPersonalLinkController | class | gameuiICharacterCustomizationComponent | simpleLinkGroup |
| gameuiCompassWidgetGameController | class | inkHUDGameController | compassWidget |
| gameuiCreditsPositionController | class | inkLogicController | titleText, namesText |
| gameuiCreditsSectionController | class | inkLogicController | sectionName |
| gameuiFPSCounterGameController | class | inkHUDGameController | counterWidget |
| gameuiGPSGameController | class | inkHUDGameController | gpsSettings |
| gameuiGameVersionTextController | class | inkLogicController | gameVersionText, expansionWrapper, fluffWrapper |
| gameuiGarmentSwitchEffectController | struct | — | sceneName, switchTime |
| gameuiGlobaltvWidgetGameController | class | inkGameController | overlayContainer |
| gameuiHUDVideoPlayerController | class | inkHUDGameController | playOnHud |
| gameuiHackingMinigameLogicController | class | inkLogicController | grid, buffer, programs, timer, timerProgressBar |
| gameuiICharacterCustomizationBodyController | class | gameuiICharacterCustomizationComponent | — |
| gameuiICharacterCustomizationBodyPartsController | class | gameuiICharacterCustomizationComponent | — |
| gameuiInGameMenuGameControllerItemSceneInfo | struct | — | sceneName, prefabRef |
| gameuiNewsFeedDisplayController | class | inkLogicController | newsTitleWidget, randomNewsLibraryWidget, randomNewsContainer |
| gameuiOnscreenVOPlayerController | class | inkGameController | subtitlesContainer, subtitlesLibraryResource, subtitlesRootName, audioVOList |
| gameuiPersonalLinkControllerCustomizationStateUpdater | class | gameuiICustomizationStateUpdater | — |
| gameuiPuppetPreviewCameraController | struct | — | cameraSetup, transitionDelay |
| gameuiRootHudGameController | class | inkGameController | resolutionSensitiveRoots |
| gameuiStaticIconLogicController | class | gameuiDynamicIconLogicController | iconReference |
| gameuiTrialPeriodTimerController | class | inkGenericSystemNotificationLogicController | timerText |

# Citations

- `codeware/scripts/Base/Imports/gameuiAdvertLightColorPickerController.reds`
- `codeware/scripts/Base/Imports/gameuiAugmentedRealitySignGameController.reds`
- `codeware/scripts/Base/Imports/gameuiBaseMenuGameControllerPuppetGenderInfo.reds`
- `codeware/scripts/Base/Imports/gameuiBaseMenuGameControllerPuppetSceneInfo.reds`
- `codeware/scripts/Base/Imports/gameuiBodyControllerCustomizationStateUpdater.reds`
- `codeware/scripts/Base/Imports/gameuiBodyPartsControllerCustomizationStateUpdater.reds`
- `codeware/scripts/Base/Imports/gameuiBriefingGameController.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationArmCyberwareController.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationBeardController.reds`
- `codeware/scripts/Base/Imports/gameuiCharacterCustomizationBodyController.reds`
- ... and 30 more source files
