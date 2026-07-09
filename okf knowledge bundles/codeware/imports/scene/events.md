---
type: "Import"
title: "Scene Events"
description: "Imported scene events types (42 types)."
resource: "codeware/scripts/"
tags: "[imports, events]"
timestamp: 2026-07-01T18:09:31Z
---

# Overview

Imported scene events types (42 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| scnAddIdleAnimEvent | class | scnSceneEvent | performerId, actorComponent, weight |
| scnAddIdleWithBlendAnimEvent | class | scnSceneEvent | performerId, actorComponent, targetWeight |
| scnAudioDurationEvent | class | scnSceneEvent | performer, audioEventName, playbackDirectionSupport |
| scnAudioEvent | class | scnSceneEvent | performer, audioEventName, ambientUniqueName, emitterName, fastForwardSupport |
| scnChangeIdleAnimEvent | class | scnPlayAnimEvent | idleAnimName, addIdleAnimName, isEnabled, animName, bakedFacialTransition |
| scnDialogLineEvent | class | scnSceneEvent | screenplayLineId, voParams, visualStyle, additionalSpeakers |
| scnGameplayActionEvent | class | scnSceneEvent | performer, gameplayActionData |
| scnGameplayTransitionEvent | class | scnSceneEvent | performer, vehState |
| scnIKEvent | class | scnSceneEvent | ikData |
| scnLookAtAdvancedEvent | class | scnSceneEvent | advancedData |
| scnLookAtEvent | class | scnSceneEvent | basicData |
| scnOverridePhantomParamsEvent | class | scnSceneEvent | params |
| scnPlacementEvent | class | scnSceneEvent | actorId, targetWaypoint |
| scnPlayAnimEvent | class | scnSceneEvent | animData, performer, actorComponent, convertToAdditive, muteAnimEvents |
| scnPlayDefaultMountedSlotWorkspotEvent | class | scnSceneEvent | performer, parentRef, slotName, puppetVehicleState |
| scnPlayFPPControlAnimEvent | class | scnPlayAnimEvent | gameplayAnimName, FPPControlActive, blendOverride, cameraUseTrajectorySpace, cameraBlendInDuration |
| scnPlayRidAnimEvent | class | scnPlayFPPControlAnimEvent | ridVersinon, animResRefId, animOriginMarker, actorPlacement, actorHasCollision |
| scnPlaySkAnimEvent | class | scnPlayFPPControlAnimEvent | animName, poseBlendOutWorkspot, rootMotionData, playerData |
| scnPlayVideoEvent | class | scnSceneEvent | videoPath, isPhoneCall, forceFrameRate |
| scnPoseCorrectionEvent | class | scnSceneEvent | performerId, poseCorrectionGroup |
| scnSceneEvent | class | ISerializable | id, type, startTime, duration, executionTagFlags |
| scnSetupSyncWorkspotRelationshipsEvent | class | scnSceneEvent | syncedWorkspotIds |
| scnUnmountEvent | class | scnSceneEvent | performer |
| scnWalkToEvent | class | scnSceneEvent | actorId, targetWaypointTag, usePathfinding |
| scndevEvent | struct | — | nodeId, message |
| scneventsBraindanceVisibilityEvent | class | scnSceneEvent | performerId, customMaterialParam, parameterIndex, override, priority |
| scneventsCameraEvent | class | scnSceneEvent | cameraRef, isBlendIn, blendTime |
| scneventsCameraParamsEvent | class | scnSceneEvent | cameraRef, fovValue, fovWeigh, dofIntensity, dofNearBlur |
| scneventsCameraPlacementEvent | class | scnSceneEvent | cameraRef, cameraTransformLS |
| scneventsClueEvent | class | scnSceneEvent | clueEntity, markedOnTimeline, clueName, layer, overrideFact |
| scneventsDespawnEntityEvent | class | scnSceneEvent | params |
| scneventsMountEvent | class | scnSceneEvent | parent, child, slotName, carryStyle, isInstant |
| scneventsPlayRidCameraAnimEvent | class | scnSceneEvent | cameraRef, cameraPlacement, animData, animSRRefId, animOriginMarker |
| scneventsPlayerLookAtEvent | class | scnSceneEvent | performer, nodeRef, lookAtParams |
| scneventsRagdollEvent | class | scnSceneEvent | performer, enableRagdoll |
| scneventsSetAnimFeatureEvent | class | scnSceneEvent | actorId, animFeatureName, animFeature |
| scneventsSpawnEntityEvent | class | scnSceneEvent | params |
| scneventsUIAnimationBraindanceEvent | class | scnSceneEvent | animationName, performerId, nodeRef |
| scneventsUIAnimationEvent | class | scnSceneEvent | animationName, performerId, nodeRef |
| scneventsVFXBraindanceEvent | class | scnSceneEvent | performerId, nodeRef, effectEntry, sequenceShift, glitchEffectEntry |
| scneventsVFXDurationEvent | class | scnSceneEvent | effectEntry, startAction, endAction, sequenceShift, performerId |
| scneventsVFXEvent | class | scnSceneEvent | effectEntry, action, sequenceShift, performerId, nodeRef |

# Citations

- `codeware/scripts/Base/Imports/scnAddIdleAnimEvent.reds`
- `codeware/scripts/Base/Imports/scnAddIdleWithBlendAnimEvent.reds`
- `codeware/scripts/Base/Imports/scnAudioDurationEvent.reds`
- `codeware/scripts/Base/Imports/scnAudioEvent.reds`
- `codeware/scripts/Base/Imports/scnChangeIdleAnimEvent.reds`
- `codeware/scripts/Base/Imports/scnDialogLineEvent.reds`
- `codeware/scripts/Base/Imports/scnGameplayActionEvent.reds`
- `codeware/scripts/Base/Imports/scnGameplayTransitionEvent.reds`
- `codeware/scripts/Base/Imports/scnIKEvent.reds`
- `codeware/scripts/Base/Imports/scnLookAtAdvancedEvent.reds`
- ... and 32 more source files
