---
type: "Import"
title: "World Types/Proxy"
description: "Imported world types/proxy types (10 types)."
resource: "codeware/scripts/"
tags: "[imports, proxy]"
timestamp: 2026-07-01T18:09:34Z
---

# Overview

Imported world types/proxy types (10 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldProxyBBoxSyncOptions | enum | — | Do_Nothing, Pull, Pull_And_Delete |
| worldProxyCoreAxis | enum | — | X, Y, Z |
| worldProxyGroupingNormals | enum | — | Around_Core_Axis, Around_All_Axes |
| worldProxyMeshBuildType | enum | — | ProxyFromScratch, ProxyFromProxy, OnlyFromChildProxies |
| worldProxyMeshDependencyMode | enum | — | Auto, Include, Discard |
| worldProxyMeshOutputType | enum | — | RayScan, SurfaceReconstruction, LegacyFromVoxels, FromCustomMesh, FromBoxes |
| worldProxyMeshTexRes | enum | — | RES_64, RES_128, RES_256, RES_512, RES_1024 |
| worldProxyMeshUVType | enum | — | UvUseExisting, UvGenerateNew |
| worldProxyNormalAngleStepSize | enum | — | STEP_90, STEP_45, STEP_15, STEP_5 |
| worldProxySyncNormalSource | enum | — | From_Groups, From_Face_Average |

# Citations

- `codeware/scripts/Base/Imports/worldProxyBBoxSyncOptions.reds`
- `codeware/scripts/Base/Imports/worldProxyCoreAxis.reds`
- `codeware/scripts/Base/Imports/worldProxyGroupingNormals.reds`
- `codeware/scripts/Base/Imports/worldProxyMeshBuildType.reds`
- `codeware/scripts/Base/Imports/worldProxyMeshDependencyMode.reds`
- `codeware/scripts/Base/Imports/worldProxyMeshOutputType.reds`
- `codeware/scripts/Base/Imports/worldProxyMeshTexRes.reds`
- `codeware/scripts/Base/Imports/worldProxyMeshUVType.reds`
- `codeware/scripts/Base/Imports/worldProxyNormalAngleStepSize.reds`
- `codeware/scripts/Base/Imports/worldProxySyncNormalSource.reds`
