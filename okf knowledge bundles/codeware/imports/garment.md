---
type: "Import"
title: "Garment Types"
description: "Imported game engine types in the garment domain (7 types)."
resource: "codeware/scripts/"
tags: "[imports, garment]"
timestamp: 2026-07-01T18:09:14Z
---

# Overview

Imported game engine types in the garment domain (7 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| garmentBendingParams | struct | — | bendPowerOffsetInCM |
| garmentCollarAreaParams | struct | — | enable, radiusForTriangleRemovalInCM, offset |
| garmentGarmentLayerParams | class | CResource | bending, smoothing, collarArea, hiddenTrianglesRemoval |
| garmentHiddenTrianglesRemovalParams | struct | — | garmentBorderThreshold, removeHiddenTrianglesRasterization, rayLengthMorphOffsetFactor |
| garmentMeshParamGarment | class | meshMeshParameter | chunks |
| garmentMeshParamGarmentChunkData | struct | — | numVertices, isTwoSided |
| garmentSmoothingParams | struct | — | smoothingStrength, smoothingExponent, smoothNormalsEnabled |

# Citations

- `codeware/scripts/Base/Imports/garmentBendingParams.reds`
- `codeware/scripts/Base/Imports/garmentCollarAreaParams.reds`
- `codeware/scripts/Base/Imports/garmentGarmentLayerParams.reds`
- `codeware/scripts/Base/Imports/garmentHiddenTrianglesRemovalParams.reds`
- `codeware/scripts/Base/Imports/garmentMeshParamGarment.reds`
- `codeware/scripts/Base/Imports/garmentMeshParamGarmentChunkData.reds`
- `codeware/scripts/Base/Imports/garmentSmoothingParams.reds`
