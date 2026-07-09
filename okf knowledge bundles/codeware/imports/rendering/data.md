---
type: "Import"
title: "Rendering Data"
description: "Imported rendering data types (8 types)."
resource: "codeware/scripts/"
tags: "[imports, data]"
timestamp: 2026-07-01T18:09:29Z
---

# Overview

Imported rendering data types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| DynamicTextureDataFormat | enum | — | R_Uint8, R_Float16, R_Float32, RG_Float16, RG_Float32 |
| rendGridGeneratorData | struct | — | startingPosition, xStep, numberOfXSteps, orbitDistance |
| rendOpacityMicromapDatabase | struct | — | ommChunks |
| rendRenderMorphTargetMeshBlobTextureData | struct | — | targetDiffScale, targetDiffsDataOffset, targetDiffsWidth |
| rendRenderParticleUpdaterData | struct | — | modifOffset, turbulenceNoiseInterval, collisionMask, collisionStaticFriction, collisionVelocityDamp |
| rendScreenshotBatchData | struct | — | batchPositionsPath, numberOfCoordinatesToDump, streamingObserverMode |
| rendSingleScreenShotData | class | ISerializable | mode, outputPath, resolution, resolutionMultiplier, emmModes |
| rendTopologyData | struct | — | data, dataStride |

# Citations

- `codeware/scripts/Base/Imports/DynamicTextureDataFormat.reds`
- `codeware/scripts/Base/Imports/rendGridGeneratorData.reds`
- `codeware/scripts/Base/Imports/rendOpacityMicromapDatabase.reds`
- `codeware/scripts/Base/Imports/rendRenderMorphTargetMeshBlobTextureData.reds`
- `codeware/scripts/Base/Imports/rendRenderParticleUpdaterData.reds`
- `codeware/scripts/Base/Imports/rendScreenshotBatchData.reds`
- `codeware/scripts/Base/Imports/rendSingleScreenShotData.reds`
- `codeware/scripts/Base/Imports/rendTopologyData.reds`
