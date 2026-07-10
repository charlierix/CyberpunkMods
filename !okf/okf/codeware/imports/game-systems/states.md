---
type: "Import"
title: "Game-Systems States"
description: "Imported game-systems states types (37 types)."
resource: "codeware/scripts/"
tags: "[imports, states]"
timestamp: 2026-07-01T18:09:12Z
---

# Overview

Imported game-systems states types (37 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameActionReplicatedState | struct | — | replicationId, startTimeStamp, updateBucket |
| gameAlwaysSpawnedState | enum | — | default__false_, true, false |
| gameAttachmentSlotReplicatedState | struct | — | slotID, hasItemObject |
| gameChildEffectsMovingInCone_State | struct | — | — |
| gameDebugCheatsSharedState | class | gameIGameSystemReplicatedState | activeCheats, debugTimeDilationIndex, debugTimeDilationPlayerIndex |
| gameDebugTimeState | class | gameITimeState | — |
| gameFinalTimeState | class | gameITimeState | — |
| gameGodModeSharedState | class | gameIGameSystemReplicatedState | datas |
| gameITimeState | class | ISerializable | — |
| gameMovingPlatformsSavedState | class | ISerializable | mapping, data |
| gameMuppetCompressedInputStates | struct | — | usesCompression, firstFrameId |
| gameMuppetDebugState | class | ISerializable | comparisonReports, comparisonReportIndex, subStepsData |
| gameMuppetHealthState | struct | — | health |
| gameMuppetHighLevelState | struct | — | isDead |
| gameMuppetInputState | struct | — | frameId |
| gameMuppetInventoryState | struct | — | slots |
| gameMuppetLookState | struct | — | lookDir |
| gameMuppetMoveState | struct | — | desiredSpeed, isFalling, moveStyle, landFrameId |
| gameMuppetPhysicalState | struct | — | position, velocity, groundNormal |
| gameMuppetScanningState | struct | — | isScanning |
| gameMuppetState | struct | — | frameId, healthState, lookState, upperBodyState, inventoryState |
| gameMuppetStateComparisonReport | struct | — | frameID |
| gameMuppetStateMachineSnapshot | struct | — | stateMachineId |
| gameMuppetStateMachinesSnapshot | struct | — | stateMachines |
| gameMuppetStates | struct | — | — |
| gameMuppetUpperBodyState | struct | — | currentWeapon, inProgressWeapon, equippingTransitionTime, timeTillNextShootSeconds, currentWeaponAmmo |
| gameNetAIState | struct | — | value, time |
| gamePhantomEntityState | enum | — | RootMotion, Workspot, MoveOnSpline |
| gameReplicatedEntityEventsState | struct | — | items |
| gameSavedPatrolProgressState | class | ISerializable | entrySplineParam, entrySectionIndex, controlPointIndex, splineEntryPosition, splineEntryTangent |
| gameSpawnInViewState | enum | — | default__true_, true, false |
| gameStatsStateMapStructure | unknown | — | — |
| gameTPPRepresentationCustomizationStateUpdater | class | gameuiICustomizationStateUpdater | — |
| gameTierPrereqState | class | PrereqState | — |
| gameVisionModePrereqState | class | PrereqState | — |
| gameWeaponsReplicatedState | struct | — | — |
| gamedataGroupNodeInheritanceState | enum | — | Unresolved, Resolving, Resolved |

# Citations

- `codeware/scripts/Base/Imports/gameActionReplicatedState.reds`
- `codeware/scripts/Base/Imports/gameAlwaysSpawnedState.reds`
- `codeware/scripts/Base/Imports/gameAttachmentSlotReplicatedState.reds`
- `codeware/scripts/Base/Imports/gameChildEffectsMovingInCone_State.reds`
- `codeware/scripts/Base/Imports/gameDebugCheatsSharedState.reds`
- `codeware/scripts/Base/Imports/gameDebugTimeState.reds`
- `codeware/scripts/Base/Imports/gameFinalTimeState.reds`
- `codeware/scripts/Base/Imports/gameGodModeSharedState.reds`
- `codeware/scripts/Base/Imports/gameITimeState.reds`
- `codeware/scripts/Base/Imports/gameMovingPlatformsSavedState.reds`
- ... and 27 more source files
