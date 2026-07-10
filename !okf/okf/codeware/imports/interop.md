---
type: "Import"
title: "Interop Types"
description: "Imported game engine types in the interop domain (25 types)."
resource: "codeware/scripts/"
tags: "[imports, interop]"
timestamp: 2026-07-01T18:09:17Z
---

# Overview

Imported game engine types in the interop domain (25 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| interopDispatchPrefabProxyJobsResult | struct | — | numProxyJobsDispatched, numProxyJobsFailed |
| interopEntityEffectSelectionSyncData | struct | — | effectName |
| interopEntityEffectSpawnerSyncData | struct | — | componentName, templatePath, included |
| interopGlobalNodeIDInfo | struct | — | globalName, globalNodeIDHash |
| interopGlobalNodeIDResult | struct | — | errorMessage, isValid |
| interopGraphConnectionCreationData | struct | — | data |
| interopMaterialListDescriptor | struct | — | chunksInfo, numLayers, isMultilayer, isTemplate, materialName |
| interopNodeTransformInfo | struct | — | id |
| interopOpaqueData | struct | — | description, version |
| interopRTTIClassDump | struct | — | classNames, resourceInfos |
| interopRTTIClassDumpEntry | struct | — | i, r |
| interopRTTIResourceDumpInfo | struct | — | extension, friendlyDescription |
| interopReExportOptions | struct | — | occlusionExportOptNames, typeExportOptions, runDispatcher, depotPath, exportMaterials |
| interopSelectByDefinitionOptions | struct | — | searchInSelection, maxBBoxDiagonalLength, includePrefabNodes, includeMeshNodes |
| interopSelectionChangeInfo | struct | — | selected |
| interopStringUint64Pair | struct | — | string |
| interopStringWithID | struct | — | text |
| interopTerrainEditToolCreationSlotInfo | struct | — | scale, heightMappingMin |
| interopTerrainEditToolInfo | struct | — | defaultHeightmapMode, defaultEmptyHeightmapHeight, defaultEmptyHeightmapMaskRoundness, defaultHeightmap1, defaultColormap1 |
| interopTerrainImportParams | struct | — | cellRes, scale, extraOffset, tileHeight, importHeightMaps |
| interopTerrainImportedTile | struct | — | heightMapAbsolutePath, colorMapAbsolutePath |
| interopTerrainNodeInfo | struct | — | width, externalDataSource, blendOrder, blendModeHeightIsNormal, blendModeHolesIsIgnore |
| interopTerrainSystemInstanceInfo | struct | — | cellSize, numUsedCells, numPatchesFromTerrainNodes, isEnabled, useDebugDraw |
| interopTransformInfo | struct | — | translation |
| interopUint64Pair | struct | — | first |

# Citations

- `codeware/scripts/Base/Imports/interopDispatchPrefabProxyJobsResult.reds`
- `codeware/scripts/Base/Imports/interopEntityEffectSelectionSyncData.reds`
- `codeware/scripts/Base/Imports/interopEntityEffectSpawnerSyncData.reds`
- `codeware/scripts/Base/Imports/interopGlobalNodeIDInfo.reds`
- `codeware/scripts/Base/Imports/interopGlobalNodeIDResult.reds`
- `codeware/scripts/Base/Imports/interopGraphConnectionCreationData.reds`
- `codeware/scripts/Base/Imports/interopMaterialListDescriptor.reds`
- `codeware/scripts/Base/Imports/interopNodeTransformInfo.reds`
- `codeware/scripts/Base/Imports/interopOpaqueData.reds`
- `codeware/scripts/Base/Imports/interopRTTIClassDump.reds`
- ... and 15 more source files
