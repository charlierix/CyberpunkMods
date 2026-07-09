---
type: "Import"
title: "Audio Systems"
description: "Imported audio systems types (10 types)."
resource: "codeware/scripts/"
tags: "[imports, systems]"
timestamp: 2026-07-01T18:09:06Z
---

# Overview

Imported audio systems types (10 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioDirectorSystemSettings | class | audioAudioMetadata | combatVoManagerSettingsName, singleConversationMinRepeatTime, allConversationsMinRepeatTime, maxVelocityMagnitudeToConsiderPlayerVehicleInactive, maxVelocityMagnitudeToConsiderTrafficVehicleIdle |
| gameaudioBreathingSubSystem | class | gameaudioISoundComponentSubSystem | metadataName |
| gameaudioFlybySubSystem | class | gameaudioISoundComponentSubSystem | — |
| gameaudioIAudioSubSystem | class | IScriptable | — |
| gameaudioIScanningSystem | class | IGameSystem | — |
| gameaudioMeleeAudioSubSystem | class | gameaudioIWeaponAudioComponentSubSystem | — |
| gameaudioRagdollSubSystem | class | gameaudioISoundComponentSubSystem | defaultMaterialMetadata, customDismembermentSettings, lookupMatrixName |
| gameaudioScanningSystem | class | gameaudioIScanningSystem | — |
| gameaudioeventsNotifyBreathingSubSystemStateChangeRequested | class | Event | — |
| gameaudioeventsNotifyFootstepSubSystemStateChangeRequested | class | Event | — |

# Citations

- `codeware/scripts/Base/Imports/audioDirectorSystemSettings.reds`
- `codeware/scripts/Base/Imports/gameaudioBreathingSubSystem.reds`
- `codeware/scripts/Base/Imports/gameaudioFlybySubSystem.reds`
- `codeware/scripts/Base/Imports/gameaudioIAudioSubSystem.reds`
- `codeware/scripts/Base/Imports/gameaudioIScanningSystem.reds`
- `codeware/scripts/Base/Imports/gameaudioMeleeAudioSubSystem.reds`
- `codeware/scripts/Base/Imports/gameaudioRagdollSubSystem.reds`
- `codeware/scripts/Base/Imports/gameaudioScanningSystem.reds`
- `codeware/scripts/Base/Imports/gameaudioeventsNotifyBreathingSubSystemStateChangeRequested.reds`
- `codeware/scripts/Base/Imports/gameaudioeventsNotifyFootstepSubSystemStateChangeRequested.reds`
