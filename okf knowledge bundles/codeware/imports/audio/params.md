---
type: "Import"
title: "Audio Params"
description: "Imported audio params types (8 types)."
resource: "codeware/scripts/"
tags: "[imports, params]"
timestamp: 2026-07-01T18:09:06Z
---

# Overview

Imported audio params types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioAcousticZoneParameterMapItem | class | audioAudioMetadata | param, value, enterCurveTime, exitCurveTime |
| audioAudParameter | struct | — | name, enterCurveType, exitCurveType |
| audioAudSimpleParameter | struct | — | name |
| audioMixParamDescription | struct | — | parameter |
| audioMixParamsAction | enum | — | Mull, MullPercent, MullComplemtement, MullComplemtementPercent, Add |
| audioParamMixerDecoratorMetadata | class | audioEmitterMetadata | inParams, outputName, operation, globalOutput |
| audioReverbCrossoverParams | struct | — | dist |
| gameaudioeventsSetParameterOnEmitter | class | gameaudioeventsEmitterEvent | paramName, paramValue |

# Citations

- `codeware/scripts/Base/Imports/audioAcousticZoneParameterMapItem.reds`
- `codeware/scripts/Base/Imports/audioAudParameter.reds`
- `codeware/scripts/Base/Imports/audioAudSimpleParameter.reds`
- `codeware/scripts/Base/Imports/audioMixParamDescription.reds`
- `codeware/scripts/Base/Imports/audioMixParamsAction.reds`
- `codeware/scripts/Base/Imports/audioParamMixerDecoratorMetadata.reds`
- `codeware/scripts/Base/Imports/audioReverbCrossoverParams.reds`
- `codeware/scripts/Base/Imports/gameaudioeventsSetParameterOnEmitter.reds`
