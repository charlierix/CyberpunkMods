---
type: "Import"
title: "Game-Systems Types/Effect 2"
description: "Imported game-systems types/effect 2 types (34 types)."
resource: "codeware/scripts/"
tags: "[imports, effect-2]"
timestamp: 2026-07-01T18:09:09Z
---

# Overview

Imported game-systems types/effect 2 types (34 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameEffectObjectProvider_QuerySphere | class | EffectObjectProvider | gatherOnlyPuppets, filterData, queryPreset |
| gameEffectObjectProvider_QuerySphere_GrowOverTime | class | gameEffectObjectProvider_QuerySphere | — |
| gameEffectObjectProvider_QuerySphere_Value | class | EffectObjectProvider | radius, filterData, queryPreset |
| gameEffectObjectProvider_SingleEntity | class | EffectObjectProvider | — |
| gameEffectObjectProvider_Stimuli_EntitiesInRange | class | EffectObjectProvider | — |
| gameEffectObjectProvider_SweepMelee_Box | class | gameEffectObjectProvider_SweepOverTime | playerStaticDetectionConeDistance, playerStaticDetectionConeStartAngle, playerStaticDetectionConeEndAngle, playerUseCameraForObstructionChecks, checkMeleeInvulnerability |
| gameEffectObjectProvider_SweepMelee_MantisBlades | class | gameEffectObjectProvider_SweepMelee_Box | — |
| gameEffectObjectProvider_SweepOverTime | class | EffectObjectProvider | filterData, queryPreset |
| gameEffectObjectProvider_SweepOverTime_Box | class | gameEffectObjectProvider_SweepOverTime | — |
| gameEffectObjectProvider_SweepOverTime_Capsule | class | gameEffectObjectProvider_SweepOverTime | radius, height |
| gameEffectObjectProvider_SweepOverTime_Sphere | class | gameEffectObjectProvider_SweepOverTime | radius |
| gameEffectObjectProvider_Sweep_Box | class | EffectObjectProvider | filterData, queryPreset |
| gameEffectObjectSingleFilter_BlackboardBoolCondition | class | EffectObjectSingleFilter | parameter, filter |
| gameEffectPostAction_BeamVFX | class | EffectPostAction | — |
| gameEffectPostAction_BeamVFX_Custom | class | gameEffectPostAction_BeamVFX | effect, attached, breakLoopOnDetach, invert, maxRange |
| gameEffectPostAction_Beam_RicochetPreview | class | EffectPostAction | ricocheted, fromMuzzle |
| gameEffectPostAction_Beam_RicochetPreviewPreviewEffect | struct | — | effect, effectTag, effectSnapTag |
| gameEffectPostAction_BulletExplode | class | EffectPostAction | endRangeTolerance, explosionDuration |
| gameEffectPostAction_BulletTrace | class | gameEffectPostAction_BeamVFX | — |
| gameEffectPostAction_MeleeTireHit | class | EffectPostAction | — |
| gameEffectPostAction_MeleeWaterEffects | class | EffectPostAction | — |
| gameEffectPostAction_NewEffect_ChimeraMissileExplosion | class | EffectPostAction | tagInThisFile, overrideRadius, executeOnNthHit |
| gameEffectPostAction_ProcessNearlyHitAgents | class | EffectPostAction | — |
| gameEffectPostAction_WaterImpulse | class | EffectPostAction | — |
| gameEffectPreAction_SpreadingEffect | class | EffectPreAction | — |
| gameEffectPreAction_VisualEffectAtPosition | class | EffectPreAction | effect, attached, breakLoopOnDetach, vertical, effectTag |
| gameEffectSet | class | CResource | effects |
| gameEffectTriggerEffectDesc | class | ISerializable | effect, positionType, rotationType, offset, playFromHour |
| gameEffectTriggerNode | class | worldAreaShapeNode | effectDescs |
| gameEffectTriggerPositioningType | enum | — | PlayerRoot, CameraRoot, AtSpawn, XYCameraZPlayer, XYPlayerZCamera |
| gameEffectTriggerRotationType | enum | — | None, AtSpawn, Continuous |
| gameEffectVectorEvaluator | class | ISerializable | modifier |
| gameEffectVectorEvaluator_HitDirection | class | gameEffectVectorEvaluator | — |
| gameEffectVectorEvaluator_HitNormal | class | gameEffectVectorEvaluator | — |

# Citations

- `codeware/scripts/Base/Imports/gameEffectObjectProvider_QuerySphere.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectProvider_QuerySphere_GrowOverTime.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectProvider_QuerySphere_Value.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectProvider_SingleEntity.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectProvider_Stimuli_EntitiesInRange.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectProvider_SweepMelee_Box.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectProvider_SweepMelee_MantisBlades.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectProvider_SweepOverTime.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectProvider_SweepOverTime_Box.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectProvider_SweepOverTime_Capsule.reds`
- ... and 24 more source files
