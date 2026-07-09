---
type: "Import"
title: "Navigation Types"
description: "Imported game engine types in the navigation domain (25 types)."
resource: "codeware/scripts/"
tags: "[imports, navigation]"
timestamp: 2026-07-01T18:09:21Z
---

# Overview

Imported game engine types in the navigation domain (25 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| NavGenNavigationSetting | struct | — | navmeshImpact |
| NavGenNavmeshImpact | enum | — | Ignored, Walkable, Blocking, Road, Stairs |
| NavGenSamplingDensity | enum | — | None, Sparse, Dense, Very_dense |
| navLocomotionPath | class | ISerializable | splineNodeRef, segments, backwardSegments, points, userData |
| navLocomotionPathPointInfo | struct | — | point |
| navLocomotionPathPointUserData | class | ISerializable | — |
| navLocomotionPathPointUserDataEntry | struct | — | userData |
| navLocomotionPathResource | class | CResource | paths |
| navLocomotionPathSegmentInfo | struct | — | type, offMeshLink |
| navLocomotionPathSegmentTypes | enum | — | Invalid, Spline, OffMeshLink |
| navNavAreaID | enum | — | Unwalkable, Terrain, Crouchable, Regular, Road |
| navPathQueryDebugStatus | enum | — | InvalidQuery, Active, WaitingForStreaming, Completed, NoPathPossible |
| navRuntimeSystemPathfinding | class | worldIRuntimeSystem | — |
| navSerializableSplineProgression | struct | — | sectionIdx |
| navgendebugCompactCell | struct | — | cellData |
| navgendebugCompactContour | struct | — | rawVertices, innerPoints, area |
| navgendebugCompactPolygon | class | ISerializable | index, indices, neighbors, area, region |
| navgendebugCompactSpan | struct | — | spanData |
| navgendebugContourSet | struct | — | contours, cellSize, width, borderSize |
| navgendebugHeightfield | class | ISerializable | bounds, cellSize, cellHeight, width, height |
| navgendebugInputGeometry | struct | — | triangles, extrudedBoundingBox |
| navgendebugInputGeometryTriangle | struct | — | vertices |
| navgendebugPolyMesh | class | ISerializable | vertices, polygons, bounds, cellSize, cellHeight |
| navgendebugSpansData | struct | — | spans, filteredAreas |
| navgendebugTileGenerationDebugData | class | ISerializable | tileIndex, contours |

# Citations

- `codeware/scripts/Base/Imports/NavGenNavigationSetting.reds`
- `codeware/scripts/Base/Imports/NavGenNavmeshImpact.reds`
- `codeware/scripts/Base/Imports/NavGenSamplingDensity.reds`
- `codeware/scripts/Base/Imports/navLocomotionPath.reds`
- `codeware/scripts/Base/Imports/navLocomotionPathPointInfo.reds`
- `codeware/scripts/Base/Imports/navLocomotionPathPointUserData.reds`
- `codeware/scripts/Base/Imports/navLocomotionPathPointUserDataEntry.reds`
- `codeware/scripts/Base/Imports/navLocomotionPathResource.reds`
- `codeware/scripts/Base/Imports/navLocomotionPathSegmentInfo.reds`
- `codeware/scripts/Base/Imports/navLocomotionPathSegmentTypes.reds`
- ... and 15 more source files
