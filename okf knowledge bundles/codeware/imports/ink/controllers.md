---
type: "Import"
title: "Ink Controllers"
description: "Imported ink controllers types (18 types)."
resource: "codeware/scripts/"
tags: "[imports, controllers]"
timestamp: 2026-07-01T18:09:16Z
---

# Overview

Imported ink controllers types (18 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| inkAnimatedAdvertController | class | inkLogicController | animName, loopType |
| inkCensorshipController | class | inkLogicController | censorshipFlags |
| inkContainerNavigationController | class | inkDiscreteNavigationController | overrideEntries, useGlobalInput |
| inkControllerProcessor | class | ISerializable | — |
| inkFastTravelLoadingControllerSupervisor | class | inkGameController | glitchEffect |
| inkFinalConfigurationController | class | inkLogicController | visibilityFlag |
| inkHighwaySignLogicController | class | inkIStreetNameSignLogicController | districtName, subDistrictName, metroStationIconLeft, metroStationIconRight |
| inkIStreetNameSignLogicController | class | inkLogicController | — |
| inkIWidgetSlotController | class | inkLogicController | slotID, layout |
| inkInitialLoadingControllerSupervisor | class | gameuiOnscreenVOPlayerController | — |
| inkInputActionValidityController | class | inkLogicController | invertVisibility, inputActionName, inputValidityDependentWidgets |
| inkMetroSignLogicController | class | inkIStreetNameSignLogicController | stationName, subDistrictName, metroStationsContainer, metroStationLibraryName, metroStationTextWidgetName |
| inkRollingListController | class | ListController | itemsToDisplay, convexity, verticalCompression, scrollTime |
| inkStateTransitionAnimationController | class | inkLogicController | transition, stopActiveAnimation |
| inkStreetNameSignLogicController | class | inkIStreetNameSignLogicController | streetName, districtName, subdistrictName |
| inkTextReplaceAnimationControllerWidgetTextUsage | enum | — | BaseText, TargetText, NoUsage |
| inkVideoSequenceController | class | inkLogicController | videoWidget, videoSequence |
| inkWidgetSlotController | class | inkIWidgetSlotController | — |

# Citations

- `codeware/scripts/Base/Imports/inkAnimatedAdvertController.reds`
- `codeware/scripts/Base/Imports/inkCensorshipController.reds`
- `codeware/scripts/Base/Imports/inkContainerNavigationController.reds`
- `codeware/scripts/Base/Imports/inkControllerProcessor.reds`
- `codeware/scripts/Base/Imports/inkFastTravelLoadingControllerSupervisor.reds`
- `codeware/scripts/Base/Imports/inkFinalConfigurationController.reds`
- `codeware/scripts/Base/Imports/inkHighwaySignLogicController.reds`
- `codeware/scripts/Base/Imports/inkIStreetNameSignLogicController.reds`
- `codeware/scripts/Base/Imports/inkIWidgetSlotController.reds`
- `codeware/scripts/Base/Imports/inkInitialLoadingControllerSupervisor.reds`
- ... and 8 more source files
