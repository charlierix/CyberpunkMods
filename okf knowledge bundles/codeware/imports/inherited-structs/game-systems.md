---
type: "Struct"
title: "Game-Systems Inherited Structs"
description: "Inherited struct definitions in the game-systems domain (76 types)."
resource: "codeware/scripts/"
tags: "[imports, game-systems]"
timestamp: 2026-07-01T18:09:38Z
---

# Overview

Inherited struct definitions in the game-systems domain (76 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameAINetStateComponentReplicatedState | struct | — | componentName, replHighLevelState, replStanceState, replBehaviorState, replDefenseMode |
| gameActionAnimationState | struct | — | replicationId, startTimeStamp, updateBucket, animFeature, usePoseMatching |
| gameActionDieState | struct | — | replicationId, startTimeStamp, updateBucket, movingAgent, slotComponent |
| gameActionEquipItemState | struct | — | replicationId, startTimeStamp, updateBucket, itemId, animFeatureNameLeft |
| gameActionHitReactionState | struct | — | replicationId, startTimeStamp, updateBucket |
| gameActionMoveToDynamicNodeState | struct | — | targetPos, rotateEntity, replicationId, startTimeStamp, updateBucket |
| gameActionMoveToPositionState | struct | — | replicationId, startTimeStamp, updateBucket, useSpotReservation, useStart |
| gameActionMoveToSmartObjectState | struct | — | targetPos, rotateEntity, replicationId, startTimeStamp, updateBucket |
| gameActionMoveToState | struct | — | replicationId, startTimeStamp, updateBucket, toleranceRadius, moveStyle |
| gameActionRotateBaseState | struct | — | replicationId, startTimeStamp, updateBucket, angleTolerance, useRotationTime |
| gameActionRotateToObjectState | struct | — | angleOffset, keepUpdatingTarget, rotationSpeed, replicationId, startTimeStamp |
| gameActionRotateToState | struct | — | angleOffset, keepUpdatingTarget, rotationSpeed, replicationId, startTimeStamp |
| gameActionUnequipItemState | struct | — | replicationId, startTimeStamp, updateBucket, animFeatureNameRight, duration |
| gameAttachmentSlotsReplicatedState | struct | — | componentName, stateVersion |
| gameCombinedStatModifier | struct | — | — |
| gameConstantStatModifier | struct | — | — |
| gameCoverInstance | struct | — | — |
| gameCoverVisualData | struct | — | — |
| gameCrowdPhaseTimePeriod | struct | — | hour, density, workspotsUsage, reducedCharactersData, useDensityPreset |
| gameCurveStatModifier | struct | — | — |
| gameDeviceBaseReplicationProxy | struct | — | recordID, scriptState, versionTimestamp, initialLocation |
| gameDynamicCookedDeviceData | struct | — | className, children, componentName |
| gameFPPCameraComponentReplicatedState | struct | — | componentName |
| gameGameSession | struct | — | — |
| gameInventoryListenerData_InventoryEmpty | struct | — | — |
| gameInventoryListenerData_ItemAdded | struct | — | — |
| gameInventoryListenerData_ItemExtracted | struct | — | — |
| gameInventoryListenerData_ItemNotification | struct | — | — |
| gameInventoryListenerData_ItemQuantityChanged | struct | — | — |
| gameInventoryListenerData_ItemRemoved | struct | — | — |
| gameInventoryListenerData_PartAdded | struct | — | — |
| gameInventoryListenerData_PartRemoved | struct | — | — |
| gameMuppetInputActionActivateScanning | struct | — | — |
| gameMuppetInputActionAimDownSight | struct | — | — |
| gameMuppetInputActionCrouch | struct | — | — |
| gameMuppetInputActionDebugCommand | struct | — | debugCommand |
| gameMuppetInputActionJump | struct | — | — |
| gameMuppetInputActionLook | struct | — | rotation |
| gameMuppetInputActionMeleeAttack | struct | — | — |
| gameMuppetInputActionMoveForward | struct | — | direction |
| gameMuppetInputActionQuickMelee | struct | — | — |
| gameMuppetInputActionRangedAttack | struct | — | actionType |
| gameMuppetInputActionReloadWeapon | struct | — | — |
| gameMuppetInputActionSelectSlot | struct | — | targetSlot |
| gameMuppetInputActionSelectWeapon | struct | — | wantedWeapon |
| gameMuppetInputActionUseConsumable | struct | — | — |
| gameMuppetReplicatedState | struct | — | recordID, state, initialLocation, armor |
| gameNpcPuppetReplicatedState | struct | — | initialOrientation, initialAppearance, health, hasCPOMissionData, animEventsState |
| gamePlayerPuppetReplicatedState | struct | — | initialOrientation, initialAppearance, health, hasCPOMissionData, animEventsState |
| gamePuppetReplicatedState | unknown | — | — |
| gameRandomStatModifier | struct | — | — |
| gameReplAnimTransformOperationRequest | struct | — | applyServerTime, operationType |
| gameReplAnimTransformPlayRequest | struct | — | applyServerTime, timeScale |
| gameReplAnimTransformSkipRequest | struct | — | applyServerTime, skipTime |
| gameReplAnimTransformSyncAnimRequest | struct | — | applyServerTime |
| gameReplAnimTransformSyncMatrixRequest | struct | — | applyServerTime |
| gameReplicatedAnimEvent | struct | — | entity, name |
| gameReplicatedEntityEvent | struct | — | entity, value |
| gameScanningComponentReplicatedState | struct | — | componentName, scanningState, controllingPeerIDs |
| gameShootingSpotInstance | struct | — | — |
| gameStatusEffectComponentReplicatedState | struct | — | componentName, replicatedInfo |
| gameStreamingSmartObjectsDataExtractor | struct | — | — |
| gameTransformAnimatorComponentReplicatedState | struct | — | componentName |
| gameWeakspotComponentReplicatedState | struct | — | componentName, WeakspotRepInfos |
| gamecarryReplicatedEntitySetAttachmentToEntity | struct | — | time, slot |
| gamecarryReplicatedEntitySetAttachmentToNode | struct | — | time |
| gamecarryReplicatedEntitySetAttachmentToWorld | struct | — | time |
| gamemappinsInteractionMappinInitialData | struct | — | mappinType, active, localizedCaption, scriptData |
| gamemappinsInteractionMappinUpdateData | struct | — | — |
| gamemappinsRuntimeGenericMappinData | struct | — | — |
| gamemappinsRuntimeInteractionMappinData | struct | — | — |
| gamemappinsRuntimePointOfInterestMappinData | struct | — | — |
| gamemappinsRuntimeQuestMappinData | struct | — | — |
| gamemappinsRuntimeStubMappinData | struct | — | — |
| gamemappinsStubMappinData | struct | — | mappinType, active, localizedCaption, scriptData |
| gameweaponGrenadeReplicatedState | struct | — | recordID, instigator, currentTransform, launched |

# Citations

- `codeware/scripts/Base/Imports/InheritedStructs/gameAINetStateComponentReplicatedState.reds`
- `codeware/scripts/Base/Imports/InheritedStructs/gameActionAnimationState.reds`
- `codeware/scripts/Base/Imports/InheritedStructs/gameActionDieState.reds`
- `codeware/scripts/Base/Imports/InheritedStructs/gameActionEquipItemState.reds`
- `codeware/scripts/Base/Imports/InheritedStructs/gameActionHitReactionState.reds`
- `codeware/scripts/Base/Imports/InheritedStructs/gameActionMoveToDynamicNodeState.reds`
- `codeware/scripts/Base/Imports/InheritedStructs/gameActionMoveToPositionState.reds`
- `codeware/scripts/Base/Imports/InheritedStructs/gameActionMoveToSmartObjectState.reds`
- `codeware/scripts/Base/Imports/InheritedStructs/gameActionMoveToState.reds`
- `codeware/scripts/Base/Imports/InheritedStructs/gameActionRotateBaseState.reds`
- ... and 66 more source files
