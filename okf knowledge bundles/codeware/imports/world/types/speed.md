---
type: "Import"
title: "World Types/Speed"
description: "Imported world types/speed types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, speed]"
timestamp: 2026-07-01T18:09:34Z
---

# Overview

Imported world types/speed types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldSpeedSplineNode | class | worldSplineNode | speedChangeSections, useDeprecated, deprecatedSpeedRestrictions, deprecatedDefaultSpeed, deprecatedDefaultAdjustTime |
| worldSpeedSplineNodeOrientationChangeSection | struct | — | pos, targetOrientation |
| worldSpeedSplineNodeRoadAdjustmentFactorChangeSection | struct | — | pos |
| worldSpeedSplineNodeSpeedChangeSection | struct | — | start, targetSpeed_M_P_S |
| worldSpeedSplineNodeSpeedRestriction | struct | — | speed, adjustTime |
| worldSpeedSplineOrientationMarkerType | enum | — | UseSplineOrientation, WorldSpace, LocalSpace, KeepYawRoll_WorldSpacePitch, KeepPitchYaw_WorldSpaceRoll |

# Citations

- `codeware/scripts/Base/Imports/worldSpeedSplineNode.reds`
- `codeware/scripts/Base/Imports/worldSpeedSplineNodeOrientationChangeSection.reds`
- `codeware/scripts/Base/Imports/worldSpeedSplineNodeRoadAdjustmentFactorChangeSection.reds`
- `codeware/scripts/Base/Imports/worldSpeedSplineNodeSpeedChangeSection.reds`
- `codeware/scripts/Base/Imports/worldSpeedSplineNodeSpeedRestriction.reds`
- `codeware/scripts/Base/Imports/worldSpeedSplineOrientationMarkerType.reds`
