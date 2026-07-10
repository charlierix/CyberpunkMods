---
type: "Import"
title: "World Data"
description: "Imported world data types (23 types)."
resource: "codeware/scripts/"
tags: "[imports, data]"
timestamp: 2026-07-01T18:09:36Z
---

# Overview

Imported world data types (23 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| WorldMapPlayerInitData | class | MappinControllerCustomData | — |
| worldAcousticDataCell | struct | — | sectorId |
| worldAdvertisementLightData | struct | — | transform, lightName, autoHideDistance, color, unit |
| worldBlockoutData | class | ISerializable | points, edges, areas, worldSize, freePoints |
| worldConversationData | class | ISerializable | sceneFilename, condition, interruptionOperations, ignoreLocalLimit, ignoreGlobalLimit |
| worldConversationGroupData | class | ISerializable | conversationGroup, interruptionOperations, ignoreLocalLimit, ignoreGlobalLimit |
| worldCookedPrefabData | class | CResource | precookedDependencies, dependencies |
| worldCrowdNullAreaCollisionData | struct | — | areaID |
| worldFoliageRawData | class | ISerializable | items |
| worldNavigationTileData | struct | — | tileX, tileIndex, agentSize, tileRef, allVariantIDs |
| worldNodeEditorData | class | ISerializable | id, name, globalName, alternativeGlobalName, isGlobalNameLocked |
| worldOffMeshConnectionsData | struct | — | verts, flags, directions, tagIntervals, globalNodeIDs |
| worldOffMeshSmartObjectUserData | class | worldOffMeshUserData | nodeTransform, localSpaceTrajectoryStartPoint, localSpaceTrajectoryEndPoint, smartObjectDefinition, type |
| worldOffMeshUserData | class | ISerializable | — |
| worldPersistentSnapData | struct | — | targetObjectPath, snapTangent, preserveLength |
| worldPrefabInstanceData | class | ISerializable | — |
| worldSharedDataBuffer | class | ISerializable | — |
| worldStreamingDataGroup | enum | — | Base, EP1 |
| worldStreamingQueryRoadData | struct | — | transform, roadGlobalNodeId, connectedRoadsStartIndex |
| worldTrafficNullAreaCollisionData | class | ISerializable | header, nullAreaCollisions |
| worldTrafficNullAreaDynamicBlockadeData | class | ISerializable | nullAreasBlockades |
| worldTrafficPersistentData | struct | — | lanes |
| worldTrafficStaticCollisionData | class | ISerializable | laneCollisions |

# Citations

- `codeware/scripts/Base/Imports/WorldMapPlayerInitData.reds`
- `codeware/scripts/Base/Imports/worldAcousticDataCell.reds`
- `codeware/scripts/Base/Imports/worldAdvertisementLightData.reds`
- `codeware/scripts/Base/Imports/worldBlockoutData.reds`
- `codeware/scripts/Base/Imports/worldConversationData.reds`
- `codeware/scripts/Base/Imports/worldConversationGroupData.reds`
- `codeware/scripts/Base/Imports/worldCookedPrefabData.reds`
- `codeware/scripts/Base/Imports/worldCrowdNullAreaCollisionData.reds`
- `codeware/scripts/Base/Imports/worldFoliageRawData.reds`
- `codeware/scripts/Base/Imports/worldNavigationTileData.reds`
- ... and 13 more source files
