---
type: "Import"
title: "Game-Systems Types/Transform"
description: "Imported game-systems types/transform types (27 types)."
resource: "codeware/scripts/"
tags: "[imports, transform]"
timestamp: 2026-07-01T18:09:09Z
---

# Overview

Imported game-systems types/transform types (27 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameTransformAnimationTimeline | struct | — | items |
| gameTransformAnimationTrackItem | class | ISerializable | impl, startTime, duration |
| gameTransformAnimationTrackItemImpl | class | ISerializable | — |
| gameTransformAnimation_BreakEffectLoop | class | gameTransformAnimation_Effects | effectTag |
| gameTransformAnimation_Effects | class | gameTransformAnimationTrackItemImpl | — |
| gameTransformAnimation_KillEffect | class | gameTransformAnimation_Effects | effectTag |
| gameTransformAnimation_Move | class | gameTransformAnimationTrackItemImpl | startPositionEvaluator, targetPositionEvaluator, movement |
| gameTransformAnimation_MoveOnSpline | class | gameTransformAnimationTrackItemImpl | splineNode, from, to, rotationMode, movement |
| gameTransformAnimation_MoveOnSplineRotationMode | enum | — | Disabled, Yaw, PitchAndYaw |
| gameTransformAnimation_Movement | class | ISerializable | — |
| gameTransformAnimation_Movement_CurveSet | class | gameTransformAnimation_Movement | — |
| gameTransformAnimation_Movement_CustomCurve | class | gameTransformAnimation_Movement | curve |
| gameTransformAnimation_Movement_PredefinedFunction | class | gameTransformAnimation_Movement | function |
| gameTransformAnimation_PlaySound | class | gameTransformAnimationTrackItemImpl | soundName, unique |
| gameTransformAnimation_Position | class | ISerializable | — |
| gameTransformAnimation_Position_InitialPosition | class | gameTransformAnimation_Position | offset, offsetInWorldSpace |
| gameTransformAnimation_Position_LocalPosition | class | gameTransformAnimation_Position | position |
| gameTransformAnimation_Position_MarkerPosition | class | gameTransformAnimation_Position | markerNode, offset |
| gameTransformAnimation_RotateFromTo | class | gameTransformAnimationTrackItemImpl | startRotationEvaluator, targetRotationEvaluator, movement |
| gameTransformAnimation_RotateOnAxis | class | gameTransformAnimationTrackItemImpl | axis, numberOfFullRotations, startAngle, reverseDirection, movement |
| gameTransformAnimation_RotateOnAxisAxis | enum | — | X, Y, Z |
| gameTransformAnimation_Rotation | class | ISerializable | — |
| gameTransformAnimation_Rotation_CurrentRotation | class | gameTransformAnimation_Rotation | offset |
| gameTransformAnimation_Rotation_InitialRotation | class | gameTransformAnimation_Rotation | — |
| gameTransformAnimation_Rotation_LocalRotation | class | gameTransformAnimation_Rotation | rotation |
| gameTransformAnimation_Rotation_MarkerRotation | class | gameTransformAnimation_Rotation | markerNode, offset |
| gameTransformAnimation_SpawnEffect | class | gameTransformAnimation_Effects | effectName, effectTag, persistOnDetach |

# Citations

- `codeware/scripts/Base/Imports/gameTransformAnimationTimeline.reds`
- `codeware/scripts/Base/Imports/gameTransformAnimationTrackItem.reds`
- `codeware/scripts/Base/Imports/gameTransformAnimationTrackItemImpl.reds`
- `codeware/scripts/Base/Imports/gameTransformAnimation_BreakEffectLoop.reds`
- `codeware/scripts/Base/Imports/gameTransformAnimation_Effects.reds`
- `codeware/scripts/Base/Imports/gameTransformAnimation_KillEffect.reds`
- `codeware/scripts/Base/Imports/gameTransformAnimation_Move.reds`
- `codeware/scripts/Base/Imports/gameTransformAnimation_MoveOnSpline.reds`
- `codeware/scripts/Base/Imports/gameTransformAnimation_MoveOnSplineRotationMode.reds`
- `codeware/scripts/Base/Imports/gameTransformAnimation_Movement.reds`
- ... and 17 more source files
