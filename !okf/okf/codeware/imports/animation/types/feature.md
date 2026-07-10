---
type: "Import"
title: "Animation Types/Feature"
description: "Imported animation types/feature types (17 types)."
resource: "codeware/scripts/"
tags: "[imports, feature]"
timestamp: 2026-07-01T18:09:02Z
---

# Overview

Imported animation types/feature types (17 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AnimFeaturePlaySlotAnim | class | AnimFeature | slotName, animationName, blendInTime, blendOutTime, speedMultiplier |
| AnimFeatureWorkspotExitAnim | class | AnimFeature | — |
| AnimFeatureWorkspotInertializationAnim | class | AnimFeature | duration |
| AnimFeature_Bump | class | AnimFeature | direction, source, intensity, isBumping, bumpType |
| AnimFeature_Climb | class | AnimFeature | verticalPosition, horizontalPosition, toVerticalTime, verticalToHorizontalTime, frontEdgePosition |
| AnimFeature_DeviceCameraControlled | class | AnimFeature | currentRotation |
| AnimFeature_DroneLocomotion | class | AnimFeature | speed, angularSpeed, lookAtAngle, desiredSpeed, pathCurvative |
| AnimFeature_HitReactions | class | AnimFeature | hitDirection, hitIntensity, hitType, hitBodyPart |
| AnimFeature_Ladder | class | AnimFeature | state, transitionType, distanceFromTop, entryFromRight |
| AnimFeature_Locomotion | class | AnimFeature | action, style, pathCurvature, inclineAngle, groundAngle |
| AnimFeature_Loot | class | AnimFeature | opened, transitionDuration |
| AnimFeature_PhotomodeBodyPartRotate | class | AnimFeature | rotateDegree |
| AnimFeature_PhotomodePoseCategory | class | AnimFeature | poseCategoryIndex |
| AnimFeature_PlayerCover | class | AnimFeature | cameraPositionMS, coverState, leanAmount, cameraOffsetAmount, autoCoverActivationFrame |
| AnimFeature_PlayerSpatialAwareness | class | AnimFeature | leftClosestVector, rightClosestVector, upHitPosition, forwardDistance |
| AnimFeature_Vault | class | AnimFeature_Climb | landPosition, travellingTime, obstacleDepth |
| AnimFeature_WallRun | class | AnimFeature | wallOnRightSide, wallPosition, wallNormal |

# Citations

- `codeware/scripts/Base/Imports/AnimFeaturePlaySlotAnim.reds`
- `codeware/scripts/Base/Imports/AnimFeatureWorkspotExitAnim.reds`
- `codeware/scripts/Base/Imports/AnimFeatureWorkspotInertializationAnim.reds`
- `codeware/scripts/Base/Imports/AnimFeature_Bump.reds`
- `codeware/scripts/Base/Imports/AnimFeature_Climb.reds`
- `codeware/scripts/Base/Imports/AnimFeature_DeviceCameraControlled.reds`
- `codeware/scripts/Base/Imports/AnimFeature_DroneLocomotion.reds`
- `codeware/scripts/Base/Imports/AnimFeature_HitReactions.reds`
- `codeware/scripts/Base/Imports/AnimFeature_Ladder.reds`
- `codeware/scripts/Base/Imports/AnimFeature_Locomotion.reds`
- ... and 7 more source files
