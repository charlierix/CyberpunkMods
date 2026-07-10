---
type: "Import"
title: "Audio Types/Vehicle"
description: "Imported audio types/vehicle types (7 types)."
resource: "codeware/scripts/"
tags: "[imports, vehicle]"
timestamp: 2026-07-01T18:09:04Z
---

# Overview

Imported audio types/vehicle types (7 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| audioVehicleDestructionGridCell | struct | — | impactEvent |
| audioVehicleDestructionGridLayer | struct | — | backLeft, centerBackLeft, centerForwardLeft, frontLeft |
| audioVehicleGridDestruction | class | audioAudioMetadata | minGridCellRawChangeThreshold, specificGridCellImpactCooldown, minGridCellValueToPlayDetailedEvent, bottomLayer, upperLayer |
| audioVehicleMetadata | class | audioCustomEmitterMetadata | generalData, mechanicalData, wheelData, emitterPositionData, minRpm |
| audioVehicleMultipliers | struct | — | throttleInputMultiplier |
| audioVehicleNpcOcclusionMetadata | class | audioEmitterMetadata | void |
| gameaudioeventsVehicleCollision | class | Event | — |

# Citations

- `codeware/scripts/Base/Imports/audioVehicleDestructionGridCell.reds`
- `codeware/scripts/Base/Imports/audioVehicleDestructionGridLayer.reds`
- `codeware/scripts/Base/Imports/audioVehicleGridDestruction.reds`
- `codeware/scripts/Base/Imports/audioVehicleMetadata.reds`
- `codeware/scripts/Base/Imports/audioVehicleMultipliers.reds`
- `codeware/scripts/Base/Imports/audioVehicleNpcOcclusionMetadata.reds`
- `codeware/scripts/Base/Imports/gameaudioeventsVehicleCollision.reds`
