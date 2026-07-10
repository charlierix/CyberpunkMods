---
type: "Import"
title: "Workspot Types"
description: "Imported game engine types in the workspot domain (54 types)."
resource: "codeware/scripts/"
tags: "[imports, workspot]"
timestamp: 2026-07-01T18:09:33Z
---

# Overview

Imported game engine types in the workspot domain (54 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| UsedSpotTokensList | class | ISerializable | tokens |
| WorkspotManager | unknown | — | — |
| workActorTagCondition | class | workIWorkspotCondition | tag |
| workAnimClip | class | workIEntry | animName, blendOutTime |
| workAnimClipWithItem | class | workAnimClip | itemActions |
| workBodytypeCondition | class | workIWorkspotCondition | rig |
| workConditionalSequence | class | workSequence | multipleConditionOperator, conditionList |
| workCoverTypeCondition | class | workIWorkspotCondition | isHighCover |
| workDebuggingTool | unknown | — | — |
| workEntryAnim | class | workIEntry | animName, idleAnim, movementType, orientationType, isSynchronized |
| workEquipInventoryWeaponAction | class | workIWorkspotItemAction | weaponType, keepEquippedAfterExit, fallbackItem, fallbackSlot |
| workEquipItemToSlotAction | class | workIWorkspotItemAction | item, itemSlot |
| workEquipPropToSlotAction | class | workIWorkspotItemAction | itemId, itemSlot, attachMethod, customOffsetPos, customOffsetRot |
| workExitAnim | class | workIEntry | animName, disableAutoTransition, idleAnim, movementType, isSynchronized |
| workFastExit | class | workIEntry | animName, forcedBlendIn, movementType |
| workIContainerEntry | class | workIEntry | list, disableAutoTransition, idleAnim |
| workIEntry | class | ISerializable | id, flags |
| workIWorkspotCommandData | unknown | — | — |
| workIWorkspotCondition | class | ISerializable | expectedResult, equals |
| workIWorkspotItemAction | class | ISerializable | — |
| workIWorkspotQuestAction | class | ISerializable | — |
| workInSyncCondition | class | workIWorkspotCondition | — |
| workIsPlayerCondition | class | workIWorkspotCondition | — |
| workIsSyncMasterCondition | class | workIWorkspotCondition | — |
| workIsSyncSlaveCondition | class | workIWorkspotCondition | — |
| workLogicalOperation | enum | — | AND, OR |
| workLookAtDrivenTurn | class | workIEntry | turnAngle, turnAnimName, blendTime |
| workMotionAnimClip | class | workAnimClip | — |
| workPauseClip | class | workIEntry | timeMin, timeMax, blendOutTime |
| workPropAttachMethod | enum | — | BonePosition, RelativePosition, Custom |
| workRandomList | class | workIContainerEntry | minClips, maxClips, pauseBetweenLength, pauseLengthDeviation, weights |
| workReactionSequence | class | workIContainerEntry | forcedBlendIn, reactionTypes, mainEmotionalState, emotionalExpression, facialKeyWeight |
| workScriptedCondition | class | workIWorkspotCondition | script |
| workSelector | class | workRandomList | — |
| workSequence | class | workIContainerEntry | previousLoopInfinitely, loopInfinitely, category |
| workStopWorkspotQuestAction | class | workIWorkspotQuestAction | allowCurrAnimToFinish, exitAnim |
| workSyncAnimClip | class | workAnimClip | slotName, syncOffset |
| workSyncMasterEntryAnim | class | workEntryAnim | — |
| workTagNode | class | workIEntry | tag |
| workTimeOfDayCondition | class | workIWorkspotCondition | activeAfter, activeUntil |
| workTransitionAnim | struct | — | idleA, transitionAtoB |
| workUnequipFromSlotAction | class | workIWorkspotItemAction | itemSlot |
| workUnequipItemAction | class | workIWorkspotItemAction | item |
| workUnequipPropAction | class | workIWorkspotItemAction | itemId |
| workWeaponType | enum | — | Any, Ranged, OneHandedRanged, AssaultRifle, Hammer |
| workWorkspotAnimsetEntry | struct | — | rig, animations |
| workWorkspotGlobalProp | struct | — | id, prop |
| workWorkspotItemOverride | struct | — | propOverrides |
| workWorkspotItemOverrideItemOverride | struct | — | prevItemId |
| workWorkspotItemOverridePropOverride | struct | — | prevItemId |
| workWorkspotLogic | enum | — | Allow, Deny |
| workWorkspotResource | class | animAnimGraph | workspotTree |
| workWorkspotSystem | class | worldIWorkspotSystem | — |
| workWorkspotTree | class | ISerializable | workspotRig, globalProps, propsPlaySyncAnim, rootEntry, idCounter |

# Citations

- `codeware/scripts/Base/Imports/UsedSpotTokensList.reds`
- `codeware/scripts/Base/Imports/WorkspotManager.reds`
- `codeware/scripts/Base/Imports/workActorTagCondition.reds`
- `codeware/scripts/Base/Imports/workAnimClip.reds`
- `codeware/scripts/Base/Imports/workAnimClipWithItem.reds`
- `codeware/scripts/Base/Imports/workBodytypeCondition.reds`
- `codeware/scripts/Base/Imports/workConditionalSequence.reds`
- `codeware/scripts/Base/Imports/workCoverTypeCondition.reds`
- `codeware/scripts/Base/Imports/workDebuggingTool.reds`
- `codeware/scripts/Base/Imports/workEntryAnim.reds`
- ... and 44 more source files
