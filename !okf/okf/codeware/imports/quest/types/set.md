---
type: "Import"
title: "Quest Types/Set"
description: "Imported quest types/set types (41 types)."
resource: "codeware/scripts/"
tags: "[imports, set]"
timestamp: 2026-07-01T18:09:22Z
---

# Overview

Imported quest types/set types (41 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questSetAsCrowdObstacle_NodeTypeParams | struct | — | puppetRef |
| questSetAutopilot_NodeType | class | questIVehicleManagerNodeType | vehicleRef, val |
| questSetBriefingAlignment_NodeType | class | questIUIManagerNodeType | briefingAlignment |
| questSetBriefingSize_NodeType | class | questIUIManagerNodeType | briefingSize |
| questSetCanVehicleBeRemoteControlled_NodeType | class | questIVehicleManagerNodeType | vehicleRef, val |
| questSetCustomStyle_NodeType | class | questIPhoneManagerNodeType | style, isActive |
| questSetCyberspacePostFX_NodeType | class | questIRenderFxManagerNodeType | enabled, fullScreen, vfx, initialDatamosh, targetDatamosh |
| questSetDebugView_NodeType | class | questIRenderFxManagerNodeType | mode |
| questSetFOV_NodeType | class | questISceneManagerNodeType | FOV |
| questSetFadeInOut_NodeType | class | questIRenderFxManagerNodeType | fadeColor, fadeIn, duration |
| questSetFastTravelBinksGroup_NodeType | class | questIUIManagerNodeType | selectedBinkDataGroup |
| questSetGender_NodeTypeParams | struct | — | puppetRef, gender |
| questSetIdleRazerAnimation_NodeTypeParams | struct | — | animationName |
| questSetImmovable_NodeType | class | questIVehicleManagerNodeType | vehicleRef, enable |
| questSetInspectMode_NodeType | class | questIInteractiveObjectManagerNodeType | objectID, startingOffset, zoomOffset, timeInterval |
| questSetInteractionVisualizerOverride | class | questIInteractiveObjectManagerNodeType | objectRef, applyOverride, removeAfterSingleUse |
| questSetItemTags_NodeType | class | questIItemManagerNodeType | params |
| questSetItemTags_NodeTypeParams | struct | — | objectRef, addTags |
| questSetLocationName_NodeType | class | questIUIManagerNodeType | locationName, action, districtID, isNewLocation |
| questSetLootIconsVisibility_NodeType | class | questIUIManagerNodeType | lootIconsVisible |
| questSetLootInteractionAccess_NodeType | class | questIItemManagerNodeType | objectRef, accessible |
| questSetMetaQuestProgress_NodeType | class | questIUIManagerNodeType | metaQuestId, percent, text |
| questSetMultiplayerHeistSpawnPointTag_NodeType | class | questIMultiplayerHeistNodeType | spawnPointTag |
| questSetPhoneRestriction_NodeType | class | questIPhoneManagerNodeType | applyPhoneRestriction, forcedApply, forcedApplySource |
| questSetPhoneStatus_NodeType | class | questIPhoneManagerNodeType | status, customStatus |
| questSetPlayerMinimapIconRotationAdjustment_NodeType | class | questIUIManagerNodeType | rotationAdjustment |
| questSetPossesion_NodeType | class | questISceneManagerNodeType | playerPossesion |
| questSetProgress_NodeType | class | questIAchievementManagerNodeType | achievement, factName, maxValue, currentValue |
| questSetRenderLayer_NodeType | class | questIRenderFxManagerNodeType | renderSceneLayer |
| questSetScanningAngleThreshold_NodeType | class | questIVisionModeNodeType | angleThreshold, debugSource |
| questSetScanningTime_NodeType | class | questIVisionModeNodeType | objectRef, time |
| questSetTargetingQueryRange_NodeType | class | questISceneManagerNodeType | targetingQueryRange, resetToDefault |
| questSetTier2Params_NodeType | class | questISceneManagerNodeType | playerWalkType, usePlayerWorkspot, useEnterAnim, useExitAnim |
| questSetTier3Params_NodeType | class | questISceneManagerNodeType | yawLeftLimit, yawRightLimit, pitchUpLimit, pitchDownLimit, yawSpeedMultiplier |
| questSetTier4Params_NodeType | class | questISceneManagerNodeType | objectRef, adjustTime, usePlayerWorkspot, useEnterAnim, useExitAnim |
| questSetTier_NodeType | class | questISceneManagerNodeType | tier, usePlayerWorkspot, useEnterAnim, useExitAnim, forceEmptyHands |
| questSetTime_NodeType | class | questITimeManagerNodeType | hours, minutes, seconds, source |
| questSetTimer_NodeType | class | questIGameManagerNodeType | enable, duration |
| questSetUIGameContext_NodeType | class | questIUIManagerNodeType | requestType, context |
| questSetVar_NodeType | class | questIFactsDBManagerNodeType | factName, value, setExactValue |
| questSetVehicleCamera_NodeType | class | questIVehicleManagerNodeType | cameraType, blockOtherCameras |

# Citations

- `codeware/scripts/Base/Imports/questSetAsCrowdObstacle_NodeTypeParams.reds`
- `codeware/scripts/Base/Imports/questSetAutopilot_NodeType.reds`
- `codeware/scripts/Base/Imports/questSetBriefingAlignment_NodeType.reds`
- `codeware/scripts/Base/Imports/questSetBriefingSize_NodeType.reds`
- `codeware/scripts/Base/Imports/questSetCanVehicleBeRemoteControlled_NodeType.reds`
- `codeware/scripts/Base/Imports/questSetCustomStyle_NodeType.reds`
- `codeware/scripts/Base/Imports/questSetCyberspacePostFX_NodeType.reds`
- `codeware/scripts/Base/Imports/questSetDebugView_NodeType.reds`
- `codeware/scripts/Base/Imports/questSetFOV_NodeType.reds`
- `codeware/scripts/Base/Imports/questSetFadeInOut_NodeType.reds`
- ... and 31 more source files
