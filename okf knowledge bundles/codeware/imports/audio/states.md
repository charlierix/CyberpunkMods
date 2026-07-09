---
type: "Import"
title: "Audio States"
description: "Imported audio states types (11 types)."
resource: "codeware/scripts/"
tags: "[imports, states]"
timestamp: 2026-07-01T18:09:06Z
---

# Overview

Imported audio states types (11 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioAudioSceneStateOverride | struct | — | templateStateName, exitEventOverride |
| audioBreathingStateMetadata | class | audioAudioMetadata | inhaleSound, exhaleSound, paramChangeSpeed, targetBpm, targetTimeDistortion |
| audioBreathingStateTransitionMetadata | class | audioAudioMetadata | fromNames, toName, transitionStateName, conditionType, conditionComparator |
| audioBreathingTemporaryStateMetadata | class | audioAudioMetadata | inhaleSound, exhaleSound, paramChangeSpeed, targetBpm, targetTimeDistortion |
| audioEnemyState | enum | — | InCombat, Alerted, Afraid, Alive, Dead |
| audioEnemyStateCountASTCD | class | audioAudioStateTransitionConditionData | enemiesState, countComparer, enemiesCount |
| audioLocomotionStateEventDictionary | class | audioInlinedAudioMetadata | entries, entryType |
| audioLocomotionStateEventDictionaryItem | class | audioInlinedAudioMetadata | key, value |
| audioLocomotionStateType | class | audioAudioMetadata | void |
| audioLocomotionStateVfxDictionary | class | audioInlinedAudioMetadata | entries, entryType |
| audioLocomotionStateVfxDictionaryItem | class | audioInlinedAudioMetadata | key, value |

# Citations

- `codeware/scripts/Base/Imports/audioAudioSceneStateOverride.reds`
- `codeware/scripts/Base/Imports/audioBreathingStateMetadata.reds`
- `codeware/scripts/Base/Imports/audioBreathingStateTransitionMetadata.reds`
- `codeware/scripts/Base/Imports/audioBreathingTemporaryStateMetadata.reds`
- `codeware/scripts/Base/Imports/audioEnemyState.reds`
- `codeware/scripts/Base/Imports/audioEnemyStateCountASTCD.reds`
- `codeware/scripts/Base/Imports/audioLocomotionStateEventDictionary.reds`
- `codeware/scripts/Base/Imports/audioLocomotionStateEventDictionaryItem.reds`
- `codeware/scripts/Base/Imports/audioLocomotionStateType.reds`
- `codeware/scripts/Base/Imports/audioLocomotionStateVfxDictionary.reds`
- ... and 1 more source files
