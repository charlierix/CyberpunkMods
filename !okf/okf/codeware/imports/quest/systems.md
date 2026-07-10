---
type: "Import"
title: "Quest Systems"
description: "Imported quest systems types (13 types)."
resource: "codeware/scripts/"
tags: "[imports, systems]"
timestamp: 2026-07-01T18:09:28Z
---

# Overview

Imported quest systems types (13 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questAudioCharacterSystemsManager_NodeType | class | questIAudioCharacterManager_NodeType | subType |
| questCharacterTriggeredCombatInSecuritySystem_ConditionType | class | questICharacterConditionType | objectRef |
| questDynamicSpawnSystemCondition | class | questTypedCondition | type |
| questDynamicSpawnSystemEnemies_ConditionType | class | questIDistanceConditionType | distanceDefinition1, distanceDefinition2, comparisonType |
| questDynamicSpawnSystemEnemyDistance | class | questIDistance | waveTag, checkAllEnemies, distanceType |
| questIDynamicSpawnSystemConditionType | class | questIConditionType | — |
| questIDynamicSpawnSystemType | class | ISerializable | — |
| questISystemConditionType | class | questIConditionType | — |
| questIWorldStateSystem | class | IGameSystem | — |
| questQuestsSystemReplicatedState | class | gameIGameSystemReplicatedState | replicatedQuestPrefabs |
| questSystemCondition | class | questTypedCondition | type |
| questWorldStateSystem | class | questIWorldStateSystem | — |
| questWorldStateSystemReplicatedState | struct | — | nodeVisibilityMapArray, nodeCollisionMapArray |

# Citations

- `codeware/scripts/Base/Imports/questAudioCharacterSystemsManager_NodeType.reds`
- `codeware/scripts/Base/Imports/questCharacterTriggeredCombatInSecuritySystem_ConditionType.reds`
- `codeware/scripts/Base/Imports/questDynamicSpawnSystemCondition.reds`
- `codeware/scripts/Base/Imports/questDynamicSpawnSystemEnemies_ConditionType.reds`
- `codeware/scripts/Base/Imports/questDynamicSpawnSystemEnemyDistance.reds`
- `codeware/scripts/Base/Imports/questIDynamicSpawnSystemConditionType.reds`
- `codeware/scripts/Base/Imports/questIDynamicSpawnSystemType.reds`
- `codeware/scripts/Base/Imports/questISystemConditionType.reds`
- `codeware/scripts/Base/Imports/questIWorldStateSystem.reds`
- `codeware/scripts/Base/Imports/questQuestsSystemReplicatedState.reds`
- ... and 3 more source files
