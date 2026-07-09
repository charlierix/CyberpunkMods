---
type: "Import"
title: "Audio Data"
description: "Imported audio data types (16 types)."
resource: "codeware/scripts/"
tags: "[imports, data]"
timestamp: 2026-07-01T18:09:06Z
---

# Overview

Imported audio data types (16 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioAudioSceneData | class | audioAudioMetadata | anyStateArray, states, anyStateTransitionsTable, voLineSignals, signalLeadingToShutdown |
| audioAudioSceneVariableReadActionData | struct | — | name, value |
| audioAudioSceneVariableWriteActionData | struct | — | name, value |
| audioAudioStateData | struct | — | stateName, exitEvent, mixingActions, writeVariableActions |
| audioAudioStateTransitionConditionData | class | audioAudioMetadata | — |
| audioAudioStateTransitionData | struct | — | targetStateId, transitionTime, exitSignal, conditions |
| audioDialogLineEventData | struct | — | stringId, expression, isRewind, customVoEvent, playbackSpeedParameter |
| audioEditorSelectedData | class | audioAudioMetadata | selectedWeaponConfigurationName, selectedFootstepsEventName |
| audioMixingActionData | struct | — | actionType, tagValue, distanceRolloffFactor, customParametersSetKey |
| audioVehicleEmitterPositionData | struct | — | engineEmitterPosition, centralEmitterPosition, trunkEmitterPosition, wheel2Position, wheel4Position |
| audioVehicleEngageMovingFasterInterpolationData | struct | — | enterCurveType, exitCurveType |
| audioVehicleGeneralData | struct | — | revSoundbankName, reverbSoundbankName, exitVehicleEvent, ignitionEndEvent, UIEndEvent |
| audioVehicleInteriorParameterData | struct | — | enterCurveType, enterDelayTime, exitCurveTime |
| audioVehicleMechanicalData | struct | — | engineStartEvent, gearUpBeginEvent, gearDownBeginEvent, throttleOnEvent, suspensionSqueekEvent |
| audioVehicleWheelData | struct | — | wheelStartEvents, wheelRegularSuspensionImpacts, suspensionPressureMultiplier, suspensionPressureLimit, suspensionImpactCooldown |
| audioVoiceTriggerData | struct | — | name, variationNumber |

# Citations

- `codeware/scripts/Base/Imports/audioAudioSceneData.reds`
- `codeware/scripts/Base/Imports/audioAudioSceneVariableReadActionData.reds`
- `codeware/scripts/Base/Imports/audioAudioSceneVariableWriteActionData.reds`
- `codeware/scripts/Base/Imports/audioAudioStateData.reds`
- `codeware/scripts/Base/Imports/audioAudioStateTransitionConditionData.reds`
- `codeware/scripts/Base/Imports/audioAudioStateTransitionData.reds`
- `codeware/scripts/Base/Imports/audioDialogLineEventData.reds`
- `codeware/scripts/Base/Imports/audioEditorSelectedData.reds`
- `codeware/scripts/Base/Imports/audioMixingActionData.reds`
- `codeware/scripts/Base/Imports/audioVehicleEmitterPositionData.reds`
- ... and 6 more source files
