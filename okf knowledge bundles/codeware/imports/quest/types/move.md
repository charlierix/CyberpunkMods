---
type: "Import"
title: "Quest Types/Move"
description: "Imported quest types/move types (5 types)."
resource: "codeware/scripts/"
tags: "[imports, move]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/move types (5 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questMoveOnSplineAndKeepDistance_NodeType | class | questIVehicleManagerNodeType | vehicleRef, keepDistanceFromRef, splineRef, distance, blendTime |
| questMoveOnSplineControlRubberbanding_NodeType | class | questIVehicleManagerNodeType | enable, vehicleRef, keepDistanceFromRef, distance, minSpeed |
| questMoveOnSplineType | enum | — | Simple, Anim, WithCompanion |
| questMoveOnSpline_NodeType | class | questIVehicleManagerNodeType | vehicleRef, splineRef, startFrom, blendType, blendTime |
| questMoveType | enum | — | MoveOnSpline, MoveTo, RotateTo, Patrol, Follow |

# Citations

- `codeware/scripts/Base/Imports/questMoveOnSplineAndKeepDistance_NodeType.reds`
- `codeware/scripts/Base/Imports/questMoveOnSplineControlRubberbanding_NodeType.reds`
- `codeware/scripts/Base/Imports/questMoveOnSplineType.reds`
- `codeware/scripts/Base/Imports/questMoveOnSpline_NodeType.reds`
- `codeware/scripts/Base/Imports/questMoveType.reds`
