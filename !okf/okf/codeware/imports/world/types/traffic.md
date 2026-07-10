---
type: "Import"
title: "World Types/Traffic"
description: "Imported world types/traffic types (23 types)."
resource: "codeware/scripts/"
tags: "[imports, traffic]"
timestamp: 2026-07-01T18:09:34Z
---

# Overview

Imported world types/traffic types (23 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldTrafficCollisionDebug | class | ISerializable | overlapBoxes |
| worldTrafficCollisionGroupNode | class | worldNode | collisionEntries |
| worldTrafficCollisionSphere | struct | — | worldPos, radius, flags |
| worldTrafficCompiledNode | class | worldNode | aabb |
| worldTrafficConnectivityInLane | struct | — | — |
| worldTrafficConnectivityOutLane | struct | — | — |
| worldTrafficGlobalPathPosition | class | ISerializable | worldPosition, pathIdx |
| worldTrafficLaneCrowdCreationInfo | struct | — | connectedFragments |
| worldTrafficLaneCrowdFragment | struct | — | desiredSlotCountsPerTimePeriod, laneX1 |
| worldTrafficLanePersistent | struct | — | outLanes, outline, crowdCreationInfo, deadEndStart, width |
| worldTrafficLanePlayerGPSInfo | struct | — | subGraphId |
| worldTrafficLanePolygonRepresentation | struct | — | outline |
| worldTrafficLaneStreamed | struct | — | — |
| worldTrafficLaneUID | struct | — | nodeRefHash, seqNumber |
| worldTrafficLightStage | struct | — | color |
| worldTrafficMovementBehavior | enum | — | Pedestrian, Car |
| worldTrafficNullAreaDynamicBlockade | struct | — | areaID, affectedTrafficLanes |
| worldTrafficPersistentLaneConnections | struct | — | outlanes |
| worldTrafficPersistentNode | class | worldNode | resource |
| worldTrafficSourceNode | class | worldSplineNode | — |
| worldTrafficSplineNode | class | worldTrafficSourceNode | usage, maxSlotMaxSpeed, width, pathSamplingDistance, bidirectional |
| worldTrafficSplineNodeUsage | enum | — | Pavement, Road |
| worldTrafficStaticCollisionSphere | struct | — | worldPos |

# Citations

- `codeware/scripts/Base/Imports/worldTrafficCollisionDebug.reds`
- `codeware/scripts/Base/Imports/worldTrafficCollisionGroupNode.reds`
- `codeware/scripts/Base/Imports/worldTrafficCollisionSphere.reds`
- `codeware/scripts/Base/Imports/worldTrafficCompiledNode.reds`
- `codeware/scripts/Base/Imports/worldTrafficConnectivityInLane.reds`
- `codeware/scripts/Base/Imports/worldTrafficConnectivityOutLane.reds`
- `codeware/scripts/Base/Imports/worldTrafficGlobalPathPosition.reds`
- `codeware/scripts/Base/Imports/worldTrafficLaneCrowdCreationInfo.reds`
- `codeware/scripts/Base/Imports/worldTrafficLaneCrowdFragment.reds`
- `codeware/scripts/Base/Imports/worldTrafficLanePersistent.reds`
- ... and 13 more source files
