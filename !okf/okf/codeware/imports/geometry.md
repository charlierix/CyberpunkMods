---
type: "Import"
title: "Geometry Types"
description: "Imported game engine types in the geometry domain (18 types)."
resource: "codeware/scripts/"
tags: "[imports, geometry]"
timestamp: 2026-07-01T18:09:14Z
---

# Overview

Imported game engine types in the geometry domain (18 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AreaShapeOutline | class | ISerializable | points, height |
| ConvexHull | struct | — | planes |
| Coordinates | struct | — | latitude |
| Cylinder | struct | — | positionAndRadius |
| FixedCapsule | struct | — | PointRadius |
| FixedPoint | struct | — | Bits |
| GeometryShape | class | ISerializable | vertices, indices, faces |
| GeometryShapeFace | struct | — | indices |
| OrientedBox | struct | — | position |
| OutlineArea | class | IArea | — |
| Plane | struct | — | NormalDistance |
| Point | struct | — | x |
| Point3D | struct | — | x, z |
| Rect | struct | — | left, right |
| Segment | struct | — | origin |
| Spline | class | ISerializable | points, looped, reversed, hasDirection |
| SplinePoint | struct | — | position, tangents, automaticTangents |
| Tetrahedron | struct | — | point1, point3 |

# Citations

- `codeware/scripts/Base/Imports/AreaShapeOutline.reds`
- `codeware/scripts/Base/Imports/ConvexHull.reds`
- `codeware/scripts/Base/Imports/Coordinates.reds`
- `codeware/scripts/Base/Imports/Cylinder.reds`
- `codeware/scripts/Base/Imports/FixedCapsule.reds`
- `codeware/scripts/Base/Imports/FixedPoint.reds`
- `codeware/scripts/Base/Imports/GeometryShape.reds`
- `codeware/scripts/Base/Imports/GeometryShapeFace.reds`
- `codeware/scripts/Base/Imports/OrientedBox.reds`
- `codeware/scripts/Base/Imports/OutlineArea.reds`
- ... and 8 more source files
