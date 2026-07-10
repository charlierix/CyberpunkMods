---
type: "Import"
title: "World Params"
description: "Imported world params types (15 types)."
resource: "codeware/scripts/"
tags: "[imports, params]"
timestamp: 2026-07-01T18:09:37Z
---

# Overview

Imported world params types (15 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldEnvironmentAreaParameters | class | CResource | renderAreaSettings, resourceVersion |
| worldFoliageBrushParams | struct | — | Proximity, ScaleVariation |
| worldProxyBoundingBoxSyncParams | struct | — | positiveAxis, pullRange, stackOffset |
| worldProxyCustomGeometryParams | struct | — | useLimiterHelper |
| worldProxyMeshAdvancedBuildParams | struct | — | boundingBoxSyncParams, misc, rayMaxDistance |
| worldProxyMeshBuildParams | struct | — | buildProxy, usedMesh, polycount, coreAxis, forceSurfaceFlattening |
| worldProxyMeshGroupBuildParams | struct | — | overridePrefabBuildParams |
| worldProxyMiscAdvancedParams | struct | — | useLod1, blurCutout, capTop, fillHolesBeforeReduceRatio, rsSweepOrder |
| worldProxySurfaceFlattenParams | struct | — | flatten, syncNormalSource, postFlattenReduce |
| worldProxyTextureParams | struct | — | exportVertexColor, generateAlbedo, generateNormal, generateRoughness, generateMetalness |
| worldProxyWindowsParams | struct | — | windowsType, distanceAboveProxy, removeSmallerThan, distantWindowsSize, distantWindowsTurnedOf |
| worldWorldEnvironmentAreaParameters | struct | — | enable |
| worldWorldEnvironmentParameters | struct | — | globalLightingTrajectory |
| worldWorldGlobalLightOverrideWithColorParameters | struct | — | lightDirOverride |
| worldWorldGlobalLightParameters | struct | — | unit, moonColor, moonSize |

# Citations

- `codeware/scripts/Base/Imports/worldEnvironmentAreaParameters.reds`
- `codeware/scripts/Base/Imports/worldFoliageBrushParams.reds`
- `codeware/scripts/Base/Imports/worldProxyBoundingBoxSyncParams.reds`
- `codeware/scripts/Base/Imports/worldProxyCustomGeometryParams.reds`
- `codeware/scripts/Base/Imports/worldProxyMeshAdvancedBuildParams.reds`
- `codeware/scripts/Base/Imports/worldProxyMeshBuildParams.reds`
- `codeware/scripts/Base/Imports/worldProxyMeshGroupBuildParams.reds`
- `codeware/scripts/Base/Imports/worldProxyMiscAdvancedParams.reds`
- `codeware/scripts/Base/Imports/worldProxySurfaceFlattenParams.reds`
- `codeware/scripts/Base/Imports/worldProxyTextureParams.reds`
- ... and 5 more source files
