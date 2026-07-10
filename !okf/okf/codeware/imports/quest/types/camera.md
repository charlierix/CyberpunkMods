---
type: "Import"
title: "Quest Types/Camera"
description: "Imported quest types/camera types (4 types)."
resource: "codeware/scripts/"
tags: "[imports, camera]"
timestamp: 2026-07-01T18:09:24Z
---

# Overview

Imported quest types/camera types (4 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questCameraClippingPlane_NodeType | class | questISceneManagerNodeType | preset |
| questCameraFocus_ConditionType | class | questISystemConditionType | objectRef, timeInterval, onScreenTest, useFrustrumCheck, angleTolerance |
| questCameraParallaxSpace | enum | — | Trajectory, Camera, Chest |
| questCameraPlanesPreset | enum | — | Undefined, VeryNear, Near, Normal, None |

# Citations

- `codeware/scripts/Base/Imports/questCameraClippingPlane_NodeType.reds`
- `codeware/scripts/Base/Imports/questCameraFocus_ConditionType.reds`
- `codeware/scripts/Base/Imports/questCameraParallaxSpace.reds`
- `codeware/scripts/Base/Imports/questCameraPlanesPreset.reds`
