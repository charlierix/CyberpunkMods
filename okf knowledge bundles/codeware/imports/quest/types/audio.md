---
type: "Import"
title: "Quest Types/Audio"
description: "Imported quest types/audio types (10 types)."
resource: "codeware/scripts/"
tags: "[imports, audio]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/audio types (10 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questAudioEventNodeType | class | questIAudioNodeType | events, musicEvents, switches, params, dynamicParams |
| questAudioEventPrefetchMode | enum | — | AddEventPrefetch, RemoveEventPrefetch |
| questAudioEventPrefetchNode | class | questIAudioNodeType | prefetchEvents |
| questAudioEventPrefetchStruct | struct | — | eventName |
| questAudioFocusNodeType | class | questIAudioNodeType | — |
| questAudioMixNodeType | class | questIAudioNodeType | mixSignpost |
| questAudioMusicSyncNodeType | class | questIAudioNodeType | syncType, description, syncTrack, userCue |
| questAudioParameterNodeType | class | questIAudioNodeType | param, isMusic, objectRef, isPlayer |
| questAudioSwitchNodeType | class | questIAudioNodeType | switch, isMusic, objectRef, isPlayer |
| questAudioVehicleMultipliers_NodeType | class | questIVehicleManagerNodeType | vehicleRef, multipliers |

# Citations

- `codeware/scripts/Base/Imports/questAudioEventNodeType.reds`
- `codeware/scripts/Base/Imports/questAudioEventPrefetchMode.reds`
- `codeware/scripts/Base/Imports/questAudioEventPrefetchNode.reds`
- `codeware/scripts/Base/Imports/questAudioEventPrefetchStruct.reds`
- `codeware/scripts/Base/Imports/questAudioFocusNodeType.reds`
- `codeware/scripts/Base/Imports/questAudioMixNodeType.reds`
- `codeware/scripts/Base/Imports/questAudioMusicSyncNodeType.reds`
- `codeware/scripts/Base/Imports/questAudioParameterNodeType.reds`
- `codeware/scripts/Base/Imports/questAudioSwitchNodeType.reds`
- `codeware/scripts/Base/Imports/questAudioVehicleMultipliers_NodeType.reds`
