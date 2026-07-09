---
type: "Addon"
title: "Animation Addons"
description: "Field additions to animation types via @addField (16 types)."
resource: "codeware/scripts/"
tags: "[addons, animation]"
timestamp: 2026-07-01T18:09:40Z
---

# Overview

Field additions to animation types via @addField (16 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AnimFeature_Aim | addon | — | aimPoint |
| AnimFeature_AimPlayer | addon | — | zoomLevel, aimInTime, aimOutTime |
| AnimFeature_BasicAim | addon | — | aimState, zoomState |
| AnimFeature_Cover | addon | — | coverPosition, coverDirection, coverState, coverAngleToAction, stance |
| AnimFeature_FPPCamera | addon | — | fov, deltaYaw, deltaYawExternal, deltaYawInput, yawSpeed |
| AnimFeature_LoopableAction | addon | — | loopDuration, numLoops, isActive |
| AnimFeature_MoveTo | addon | — | initialFwdVector, targetPositionWs, targetDirectionWs, timeToMove |
| AnimFeature_Movement | addon | — | movementDirection, speed, desiredSpeed, stabilizedSpeed, acceleration |
| AnimFeature_PlayerMovement | addon | — | facingDirection, verticalSpeed, movementDirectionHorizontalAngle, inAir, standingTerrainAngle |
| AnimFeature_Stance | addon | — | stanceState |
| AnimFeature_VehiclePassenger | addon | — | overallForceMS, turnSpeed, bankSpeed, longitudinalForce, transversalForce |
| AnimFeature_WeaponData | addon | — | cycleTime, chargePercentage, timeInMaxCharge, ammoRemaining, triggerMode |
| AnimTargetAddEvent | addon | — | targetPositionProvider |
| AnimatedComponent | addon | — | controlBinding, rig, graph, animations, animTags |
| AnimationControllerComponent | addon | — | actionAnimDatabaseRef, animDatabaseCollection, controlBinding |
| animAnimFeatureEntry | addon | — | name, className, forceAllocate |

# Citations

- `codeware/scripts/Base/Addons/AnimFeature_Aim.reds`
- `codeware/scripts/Base/Addons/AnimFeature_AimPlayer.reds`
- `codeware/scripts/Base/Addons/AnimFeature_BasicAim.reds`
- `codeware/scripts/Base/Addons/AnimFeature_Cover.reds`
- `codeware/scripts/Base/Addons/AnimFeature_FPPCamera.reds`
- `codeware/scripts/Base/Addons/AnimFeature_LoopableAction.reds`
- `codeware/scripts/Base/Addons/AnimFeature_MoveTo.reds`
- `codeware/scripts/Base/Addons/AnimFeature_Movement.reds`
- `codeware/scripts/Base/Addons/AnimFeature_PlayerMovement.reds`
- `codeware/scripts/Base/Addons/AnimFeature_Stance.reds`
- ... and 6 more source files
