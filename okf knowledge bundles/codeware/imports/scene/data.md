---
type: "Import"
title: "Scene Data"
description: "Imported scene data types (23 types)."
resource: "codeware/scripts/"
tags: "[imports, data]"
timestamp: 2026-07-01T18:09:31Z
---

# Overview

Imported scene data types (23 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| scnAnimTargetBasicData | struct | — | performerId, targetPerformerId, targetOffsetEntitySpace, targetActorId, targetType |
| scnAnimationRidAudioData | class | ISerializable | events |
| scnGameplayActionSetVehicleSuspensionData | class | scnIGameplayActionData | active, cooldownTime |
| scnIGameplayActionData | class | ISerializable | — |
| scnIKEventData | struct | — | orientation, chainName |
| scnIScalingData | class | ISerializable | — |
| scnInterestingConversationData | class | ISerializable | sceneFilename, interruptionOperations |
| scnLookAtAdvancedEventData | struct | — | basic |
| scnLookAtBasicEventData | struct | — | basic, requests |
| scnLookAtEventData | struct | — | id, singleBodyPartName, bodyTargetSlot, eyesTargetSlot, bodyWeight |
| scnPlayAnimEventData | struct | — | blendIn, clipFront, weight |
| scnPlaySkAnimEventData | struct | — | animName, blendOut, stretch, bodyPartMask |
| scnPlaySkAnimRootMotionData | struct | — | enabled, originMarker, customBlendInTime, removePitchRollRotation, snapToGroundStart |
| scnPlayerAnimData | struct | — | tierData, unmountBodyCarry |
| scnScalingData_KeepRelationWithOtherEvents | class | scnIScalingData | groupRfrncNdspaceStarttime, groupRfrncNdspaceEndtime |
| scnSceneWorkspotDataId | struct | — | id |
| scnWorkspotData | class | ISerializable | dataId |
| scnWorkspotData_EmbeddedWorkspotTree | class | scnWorkspotData | workspotTree |
| scneventsAttachPropToPerformerFallbackData | struct | — | owner, fallbackAnimset, fallbackAnimationName |
| scneventsAttachPropToWorldFallbackData | struct | — | owner, fallbackAnimset, fallbackAnimationName |
| scneventsPlayAnimEventData | struct | — | blendIn, clipFront, stretch, blendOutCurve |
| scneventsPlayAnimEventExData | struct | — | basic, bodyPartMask |
| scneventsSpawnEntityEventFallbackData | struct | — | owner, fallbackAnimset, fallbackAnimationName |

# Citations

- `codeware/scripts/Base/Imports/scnAnimTargetBasicData.reds`
- `codeware/scripts/Base/Imports/scnAnimationRidAudioData.reds`
- `codeware/scripts/Base/Imports/scnGameplayActionSetVehicleSuspensionData.reds`
- `codeware/scripts/Base/Imports/scnIGameplayActionData.reds`
- `codeware/scripts/Base/Imports/scnIKEventData.reds`
- `codeware/scripts/Base/Imports/scnIScalingData.reds`
- `codeware/scripts/Base/Imports/scnInterestingConversationData.reds`
- `codeware/scripts/Base/Imports/scnLookAtAdvancedEventData.reds`
- `codeware/scripts/Base/Imports/scnLookAtBasicEventData.reds`
- `codeware/scripts/Base/Imports/scnLookAtEventData.reds`
- ... and 13 more source files
