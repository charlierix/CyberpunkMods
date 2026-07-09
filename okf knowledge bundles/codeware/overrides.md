---
type: "Override"
title: "Type Overrides"
description: "Type override definitions for existing game engine types (8 types)."
resource: "codeware/scripts/"
tags: "[overrides]"
timestamp: 2026-07-01T18:09:41Z
---

# Overview

Type override definitions for existing game engine types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioAudioEventMetadataArrayElement | struct | — | redId, maxAttenuation, maxDuration, stopActionEvents |
| entLODDefinition | struct | — | backgroundDistanceLODs, cinematicVehicleDistanceLODs, regularDistanceLODs, vehicleDistanceLODs |
| gameStatPoolPrereq | class | IComparisonPrereq | statPoolType, valueToCheck |
| gameStatPrereq | class | IRPGPrereq | statType, valueToCheck |
| gameStatusEffectComponentPS | class | GameComponentPS | statusEffectArray, delayedFunctions, delayedFunctionsNoTd, isPlayerControlled, tickComponent |
| gameuiBaseUIData | class | ISerializable | id |
| inkHudWidgetSpawnEntry | struct | — | hudEntryName, spawnMode, anchorPlace, margins, slotParams |
| scnChatter | class | ISerializable | id, voicesetComponent |

# Citations

- `codeware/scripts/Base/Overrides/audioAudioEventMetadataArrayElement.reds`
- `codeware/scripts/Base/Overrides/entLODDefinition.reds`
- `codeware/scripts/Base/Overrides/gameStatPoolPrereq.reds`
- `codeware/scripts/Base/Overrides/gameStatPrereq.reds`
- `codeware/scripts/Base/Overrides/gameStatusEffectComponentPS.reds`
- `codeware/scripts/Base/Overrides/gameuiBaseUIData.reds`
- `codeware/scripts/Base/Overrides/inkHudWidgetSpawnEntry.reds`
- `codeware/scripts/Base/Overrides/scnChatter.reds`
