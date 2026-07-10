---
type: "Import"
title: "Look-At Types"
description: "Imported game engine types in the look-at domain (3 types)."
resource: "codeware/scripts/"
tags: "[imports, look-at]"
timestamp: 2026-07-01T18:09:17Z
---

# Overview

Imported game engine types in the look-at domain (3 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| LookAtPartInfo | struct | — | partName |
| LookAtPartsDependency | struct | — | masterPart, angle, speedToTargetByAngleCurve, verticalPullSpeedByAngleCurve, horizontalPullSpeedByAngleCurve |
| LookAtStateMachineSettings | struct | — | partName, sphereAttachmentBone, followingSpeedFactor, enableFloatTrack, transitionSpeedMultiplier |

# Citations

- `codeware/scripts/Base/Imports/LookAtPartInfo.reds`
- `codeware/scripts/Base/Imports/LookAtPartsDependency.reds`
- `codeware/scripts/Base/Imports/LookAtStateMachineSettings.reds`
