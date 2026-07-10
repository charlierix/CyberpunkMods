---
type: "Import"
title: "World Resources"
description: "Imported world resources types (24 types)."
resource: "codeware/scripts/"
tags: "[imports, resources]"
timestamp: 2026-07-01T18:09:36Z
---

# Overview

Imported world resources types (24 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldAcousticDataResource | class | resStreamedResource | cells |
| worldBlockoutResource | class | CResource | blockoutData |
| worldDebugColoring_CookedResource | class | worldEditorDebugColoringSettings | alpha |
| worldDebugColoring_ResourceName | class | worldEditorDebugColoringSettings | names, defaultColor |
| worldDebugColoring_ResourceReadiness | class | worldEditorDebugColoringSettings | — |
| worldDebugColoring_SameResourceName | class | worldEditorDebugColoringSettings | alpha |
| worldDebugFilterSetting_MeshResource | class | worldEditorDebugFilterSettings | resourcePaths |
| worldFoliageCompiledResource | class | CResource | version, populationCount, bucketCount |
| worldFoliageDestructionResource | class | CResource | mappings |
| worldHeatmapResource | class | CResource | setup, name, layerNames, layers |
| worldNavigationTileResource | class | resStreamedResource | localBoundingBox, tilesData, agentSize |
| worldSceneRecordingNodeMeshResourceFilter | struct | — | forceFilterIgnore |
| worldStreamingQueryDataResource | class | CResource | roadDatas, connectedRoadDataIndices |
| worldTrafficCollisionDebugResource | class | CResource | data |
| worldTrafficCollisionResource | class | CResource | data |
| worldTrafficLanesSpotsResource | class | resStreamedResource | — |
| worldTrafficNullAreaCollisionResource | class | CResource | nullAreasCollisionData, nullAreaBlockadeData |
| worldTrafficPersistentDebugResource | class | resStreamedResource | brokenUIDs, brokenUIDsDeadEnds |
| worldTrafficPersistentLaneConnectionsResource | class | resStreamedResource | — |
| worldTrafficPersistentLanePolygonResource | class | resStreamedResource | — |
| worldTrafficPersistentResource | class | resStreamedResource | data |
| worldTrafficPersistentSpatialResource | class | resStreamedResource | neighborGroups |
| worldWorldListResource | class | CResource | worlds |
| worldWorldListResourceEntry | struct | — | world, streamingWorld, worldName |

# Citations

- `codeware/scripts/Base/Imports/worldAcousticDataResource.reds`
- `codeware/scripts/Base/Imports/worldBlockoutResource.reds`
- `codeware/scripts/Base/Imports/worldDebugColoring_CookedResource.reds`
- `codeware/scripts/Base/Imports/worldDebugColoring_ResourceName.reds`
- `codeware/scripts/Base/Imports/worldDebugColoring_ResourceReadiness.reds`
- `codeware/scripts/Base/Imports/worldDebugColoring_SameResourceName.reds`
- `codeware/scripts/Base/Imports/worldDebugFilterSetting_MeshResource.reds`
- `codeware/scripts/Base/Imports/worldFoliageCompiledResource.reds`
- `codeware/scripts/Base/Imports/worldFoliageDestructionResource.reds`
- `codeware/scripts/Base/Imports/worldHeatmapResource.reds`
- ... and 14 more source files
