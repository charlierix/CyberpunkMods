---
type: "Import"
title: "Game-Systems Data"
description: "Imported game-systems data types (75 types)."
resource: "codeware/scripts/"
tags: "[imports, data]"
timestamp: 2026-07-01T18:09:12Z
---

# Overview

Imported game-systems data types (75 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameAnimationExtractedData | struct | — | animationName, smartObjectPointType |
| gameAnimsetOverrideData | struct | — | animsetHash |
| gameAreaData | struct | — | position, type, name, lootID |
| gameBinkVideoData | class | ISerializable | data |
| gameBlueprintStackableItemData | class | gameItemData | — |
| gameBodyTypeData | struct | — | rigHash, overrides |
| gameCompiledCoverData | class | gameCompiledSmartObjectData | — |
| gameCompiledShootingSpotData | class | gameCompiledCoverData | — |
| gameCompiledSmartObjectData | class | ISerializable | — |
| gameCookedAreaData | struct | — | entityID, radius |
| gameCookedDeviceData | struct | — | className, children |
| gameCookedGpsMappinData | struct | — | journalPathHash |
| gameCookedLootData | class | ISerializable | lootTables, contentAssignment |
| gameCookedMappinData | struct | — | journalPathHash, volume |
| gameCookedMultiMappinData | struct | — | journalPathHash |
| gameCookedPointOfInterestMappinData | struct | — | journalPathHash, position |
| gameCrowdCreationData | struct | — | timePeriods |
| gameCrowdCreationDataMergeMode | enum | — | Average, Override |
| gameCrowdCreationDataRegistry | class | ISerializable | creationData |
| gameCrowdTemplateCharacterData | struct | — | characterRecordId |
| gameDebugContextUserData | struct | — | — |
| gameDependentWorkspotData | class | ISerializable | — |
| gameEffectData_MeleeTireHit | struct | — | — |
| gameEffectData_MeleeWaterFx | struct | — | — |
| gameEffectData_Pierce | struct | — | — |
| gameEffectData_PiercePreview | struct | — | — |
| gameEffectData_Splatter | struct | — | — |
| gameEffectData_SplatterList | struct | — | — |
| gameEffectExecutor_NewEffect_CopyData | class | gameEffectExecutor_NewEffect | — |
| gameEffectHitDataType | enum | — | Entity, Node, Static |
| gameEffectNearlyHitAgentData | struct | — | hitPosition, entity, wasHit |
| gameEffectPostAction_UpdateActiveVehicleUIData | class | EffectPostAction | — |
| gameFinisherSyncData | struct | — | syncAnimSlotName |
| gameFlattenedLootData | struct | — | lootID |
| gameGlobalTierSaveData | struct | — | subtype |
| gameGodModeSaveData | class | ISerializable | gods |
| gameGodModeSaveEntityData | struct | — | entityId |
| gameGodModeSharedStateData | struct | — | entity |
| gameHitDetectionDebugFrameData | struct | — | t, tTime |
| gameHitDetectionDebugFrameDataShapeEntry | struct | — | ansformWS |
| gameIMovingPlatformMovementInitData | struct | — | initType |
| gameJournalChoiceEntryData | struct | — | entryPath |
| gameJournalEntryStateChangeDelayData | struct | — | entryPath, oldState, notifyOption, delay |
| gameJournalEntryVisitedStatusData | struct | — | entryPath, isVisited |
| gameJournalQuestObjectiveCounterData | struct | — | entryPath, newValue |
| gameJournalSharedStateData | struct | — | pathHash |
| gameLastHitData | struct | — | targetEntityId, hitShapes |
| gameMovingPlatformSavedData | struct | — | currentLocalPosition, destinationName, time, mountedPlayerEntityID |
| gameMuppetSubStepData | struct | — | frameId, parentFramePrimaryColor, state |
| gameOccupantSlotData | unknown | — | — |
| gamePreviewItemData | class | gameUniqueItemData | — |
| gameRandomStatModifierData | class | gameStatModifierData | value |
| gameRazerChromaAnimationDatabase | class | CResource | setsSerialized |
| gameReplicatedShotData | struct | — | timeStamp, target |
| gameSavedStatsData | unknown | — | — |
| gameSmartObjectAnimationDatabase | class | ISerializable | animationData, bodyTypesData |
| gameSmartObjectVisualData | struct | — | — |
| gameSourceData | class | ISerializable | name, savable |
| gameSquadMemberDataEntry | struct | — | — |
| gameStackedItemData | class | gameItemData | — |
| gameStatData | struct | — | modifiers |
| gameStatPoolData | struct | — | ownerID, type, alternativeModifierRecords, maxValue, changeMode |
| gameStatPoolDataBonusType | enum | — | None, Persistent, NonPersistent |
| gameStatPoolDataStatPoolModificationStatus | enum | — | Regeneration, Decay, NoModification |
| gameStatPoolDataValueChangeMode | enum | — | Normal, IncreasingOnly, DecreasingOnly, NonZero |
| gameStatPoolModifierRuntimeData | struct | — | modifier, inRange |
| gameSubStatModifierData | class | gameStatModifierData | refStatType |
| gameTierSaveData | class | ISerializable | globalTiers |
| gameTrafficWorkspotTransitionData | class | ISerializable | workspotData, returnPosition, workspotExitTangent, trafficLaneReturnTangent |
| gameUniqueItemData | class | gameItemData | — |
| gamedataDataNode | class | ISerializable | nodeType, fileName, parent |
| gamedataDataNodeType | enum | — | File, Group, Variable, Value, SimpleValue |
| gamedataValueDataNode | class | gamedataDataNode | — |
| gamemappinsIMappinUpdateData | unknown | — | — |
| gamemappinsIRuntimeMappinData | unknown | — | — |

# Citations

- `codeware/scripts/Base/Imports/gameAnimationExtractedData.reds`
- `codeware/scripts/Base/Imports/gameAnimsetOverrideData.reds`
- `codeware/scripts/Base/Imports/gameAreaData.reds`
- `codeware/scripts/Base/Imports/gameBinkVideoData.reds`
- `codeware/scripts/Base/Imports/gameBlueprintStackableItemData.reds`
- `codeware/scripts/Base/Imports/gameBodyTypeData.reds`
- `codeware/scripts/Base/Imports/gameCompiledCoverData.reds`
- `codeware/scripts/Base/Imports/gameCompiledShootingSpotData.reds`
- `codeware/scripts/Base/Imports/gameCompiledSmartObjectData.reds`
- `codeware/scripts/Base/Imports/gameCookedAreaData.reds`
- ... and 65 more source files
