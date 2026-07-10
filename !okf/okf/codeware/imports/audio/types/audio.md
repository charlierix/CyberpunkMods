---
type: "Import"
title: "Audio Types/Audio"
description: "Imported audio types/audio types (15 types)."
resource: "codeware/scripts/"
tags: "[imports, audio]"
timestamp: 2026-07-01T18:09:04Z
---

# Overview

Imported audio types/audio types (15 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioAudioAttractAreaSounds | class | audioAudioMetadata | NPCgrunts, environmentSounds |
| audioAudioEventArray | class | ISerializable | isSortedByRedHash, events, switchGroup, switch, stateGroup |
| audioAudioEventMetadata | class | ISerializable | wwiseId, maxAttenuation, minDuration, maxDuration, isLooping |
| audioAudioEventPostedASTCD | class | audioAudioStateTransitionConditionData | audioEvent |
| audioAudioFoliageMaterial | struct | — | loopStart |
| audioAudioFoliageMaterialDictionary | class | audioInlinedAudioMetadata | entries, entryType |
| audioAudioFoliageMaterialDictionaryItem | class | audioInlinedAudioMetadata | key, value |
| audioAudioFoliageMetadata | class | audioAudioMetadata | loopStartEvent, loopStopEvent, locomotionTotalVelocityParam, locomotionTotalVelocityThreshold, locomotionAngularVelocityMultiplier |
| audioAudioMetadata | class | audioAudioMetadataBase | — |
| audioAudioMetadataBase | class | ISerializable | name |
| audioAudioSceneDefaults | class | audioAudioMetadata | parameters |
| audioAudioSceneDictionary | class | audioInlinedAudioMetadata | entries, entryType |
| audioAudioSceneDictionaryItem | class | audioInlinedAudioMetadata | key, value |
| audioAudioSceneSignalOverride | struct | — | templateSignal |
| audioAudioVehicleCurve | enum | — | ThrottleInput, RPM, Gear |

# Citations

- `codeware/scripts/Base/Imports/audioAudioAttractAreaSounds.reds`
- `codeware/scripts/Base/Imports/audioAudioEventArray.reds`
- `codeware/scripts/Base/Imports/audioAudioEventMetadata.reds`
- `codeware/scripts/Base/Imports/audioAudioEventPostedASTCD.reds`
- `codeware/scripts/Base/Imports/audioAudioFoliageMaterial.reds`
- `codeware/scripts/Base/Imports/audioAudioFoliageMaterialDictionary.reds`
- `codeware/scripts/Base/Imports/audioAudioFoliageMaterialDictionaryItem.reds`
- `codeware/scripts/Base/Imports/audioAudioFoliageMetadata.reds`
- `codeware/scripts/Base/Imports/audioAudioMetadata.reds`
- `codeware/scripts/Base/Imports/audioAudioMetadataBase.reds`
- ... and 5 more source files
