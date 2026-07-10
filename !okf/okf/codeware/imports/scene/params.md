---
type: "Import"
title: "Scene Params"
description: "Imported scene params types (41 types)."
resource: "codeware/scripts/"
tags: "[imports, params]"
timestamp: 2026-07-01T18:09:31Z
---

# Overview

Imported scene params types (41 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| scnCheckDistractedReturnConditionParams | struct | — | distracted |
| scnCheckFactInterruptConditionParams | struct | — | factCondition |
| scnCheckFactReturnConditionParams | struct | — | factCondition |
| scnCheckPlayerCombatInterruptConditionParams | struct | — | isInCombat |
| scnCheckPlayerCombatReturnConditionParams | struct | — | isInCombat |
| scnCheckSpeakersDistanceInterruptConditionParams | struct | — | distance |
| scnCheckSpeakersDistanceReturnConditionParams | struct | — | distance |
| scnCheckTriggerInterruptConditionParams | struct | — | inside |
| scnCheckTriggerReturnConditionParams | struct | — | inside |
| scnChoiceNodeNsActorReminderParams | class | ISerializable | useCustomReminder, reminderActor, waitTimeForReminderA, waitTimeForReminderB, waitTimeForReminderC |
| scnChoiceNodeNsAdaptiveLookAtParams | class | scnChoiceNodeNsLookAtParams | nearbySlotName, distantSlotName, blendLimit, referencePointFullEffectAngle, referencePointNoEffectAngle |
| scnChoiceNodeNsAttachToActorParams | struct | — | actorId |
| scnChoiceNodeNsAttachToGameObjectParams | struct | — | nodeRef |
| scnChoiceNodeNsAttachToPropParams | struct | — | propId |
| scnChoiceNodeNsAttachToScreenParams | struct | — | — |
| scnChoiceNodeNsAttachToWorldParams | struct | — | entityPosition, customEntityRadius |
| scnChoiceNodeNsBasicLookAtParams | class | scnChoiceNodeNsLookAtParams | slotName, offset |
| scnChoiceNodeNsDeprecatedParams | struct | — | actorId |
| scnChoiceNodeNsLookAtParams | class | ISerializable | — |
| scnChoiceNodeNsMappinParams | class | ISerializable | locationType, mappinSettings |
| scnChoiceNodeNsReminderParams | struct | — | reminderEnabled, reminderActor, waitTimeForReminderB, waitTimeForLooping |
| scnChoiceNodeNsTimedParams | class | ISerializable | action, timeLimitedFinish, duration |
| scnCommunityParams | struct | — | reference, forceMaxVisibility |
| scnDialogLineDuplicationParams | struct | — | executionTag, isHolocallSpeaker |
| scnDialogLineVoParams | struct | — | voContext, customVoEvent, isHolocallSpeaker, alwaysUseBrainGender |
| scnEventBlendWorkspotSetupParameters | class | ISerializable | workspotId, sequenceEntryId, idleOnlyMode, workExcludedGestures, itemOverride |
| scnFindEntityInContextParams | struct | — | contextualName, contextActorName, forceMaxVisibility |
| scnFindEntityInEntityParams | struct | — | actorId, itemID, forceMaxVisibility |
| scnFindEntityInNodeParams | struct | — | nodeRef |
| scnFindEntityInWorldParams | struct | — | actorRef |
| scnFindNetworkPlayerParams | struct | — | networkId |
| scnInteractionShapeParams | class | ISerializable | preset, offset, rotation, customIndicationRange, customActivationRange |
| scnOverridePhantomParamsEventParams | struct | — | performer, overrideIdleEffect |
| scnSpawnDespawnEntityParams | struct | — | dynamicEntityUniqueName, spawnMarkerType, spawnOffset, specRecordId, spawnOnStart |
| scnSpawnSetParams | struct | — | reference, forceMaxVisibility |
| scnSpawnerParams | struct | — | reference |
| scnUseSceneWorkspotParamsV1 | class | questUseWorkspotParamsV1 | workspotInstanceId, playAtActorLocation, itemOverride |
| scneventsDespawnEntityEventParams | struct | — | performer |
| scneventsPlayerLookAtEventParams | struct | — | slotName, duration, adjustYaw, endOnCameraInputApplied, cameraInputMagToBreak |
| scneventsSpawnEntityEventParams | struct | — | performer, referencePerformerSlotId, fallbackData |
| scnfppGenderSpecificParams | struct | — | genderMask, transitionBlendInCameraSpace, idleCameraLs |

# Citations

- `codeware/scripts/Base/Imports/scnCheckDistractedReturnConditionParams.reds`
- `codeware/scripts/Base/Imports/scnCheckFactInterruptConditionParams.reds`
- `codeware/scripts/Base/Imports/scnCheckFactReturnConditionParams.reds`
- `codeware/scripts/Base/Imports/scnCheckPlayerCombatInterruptConditionParams.reds`
- `codeware/scripts/Base/Imports/scnCheckPlayerCombatReturnConditionParams.reds`
- `codeware/scripts/Base/Imports/scnCheckSpeakersDistanceInterruptConditionParams.reds`
- `codeware/scripts/Base/Imports/scnCheckSpeakersDistanceReturnConditionParams.reds`
- `codeware/scripts/Base/Imports/scnCheckTriggerInterruptConditionParams.reds`
- `codeware/scripts/Base/Imports/scnCheckTriggerReturnConditionParams.reds`
- `codeware/scripts/Base/Imports/scnChoiceNodeNsActorReminderParams.reds`
- ... and 31 more source files
