---
type: "Import"
title: "Game-Systems Types/Effect 1"
description: "Imported game-systems types/effect 1 types (80 types)."
resource: "codeware/scripts/"
tags: "[imports, effect-1]"
timestamp: 2026-07-01T18:09:09Z
---

# Overview

Imported game-systems types/effect 1 types (80 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameEffectAction_ChildEffectsMovingInCone | class | EffectPostAction | effectsCount, effectTagInThisFile, coneAngle, minEffectDuration, maxEffectDuration |
| gameEffectAction_KillFX | class | EffectAction | action, effectTag |
| gameEffectAction_KillFXAction | enum | — | Stop, BreakLoop |
| gameEffectAction_NewEffect_ReverseFromLastHit | class | EffectPostAction | tagInThisFile, forwardOffset, childEffect, childEffectTag |
| gameEffectAction_NewEffect_Ricochet | class | EffectPostAction | tagInThisFile, forwardOffset, childEffect, childEffectTag |
| gameEffectAction_NewEffect_SpreadingEffect | class | EffectPostAction | tagInThisFile, forwardOffset, childEffect, childEffectTag |
| gameEffectAction_TerminateChildEffect | class | EffectAction | effectTag |
| gameEffectAttachment | class | entIAttachment | — |
| gameEffectDuration_Duration_Blackboard | class | EffectDurationModifier | — |
| gameEffectDuration_Infinite | class | EffectDurationModifier | — |
| gameEffectDuration_Instant | class | EffectDurationModifier | — |
| gameEffectDuration_PredefinedTimeout | class | EffectDurationModifier | timeToLive |
| gameEffectExecutor_AnimFeature | class | EffectExecutor | key, animFeature, applyTo, ignoreWaterImpacts |
| gameEffectExecutor_AnimFeatureApplyTo | enum | — | Target, Instigator |
| gameEffectExecutor_DamageProjection | class | EffectExecutor | — |
| gameEffectExecutor_Finisher | class | EffectExecutor | InfluencedByPlayerCostBlock, finisherScenarios, alwaysUseEntryAnims, allowCameraMovement |
| gameEffectExecutor_GroundSlamEffects | class | EffectExecutor | groundEffect, waterEffect, earthquakeLevel1, earthquakeLevel2, earthquakeLevel1ChargeThreshold |
| gameEffectExecutor_HitReaction | class | EffectExecutor | npcMissEvents |
| gameEffectExecutor_LandingFX | class | EffectExecutor | — |
| gameEffectExecutor_NewEffect | class | EffectExecutor | tagInThisFile, forwardOffset, childEffect, childEffectTag |
| gameEffectExecutor_NewEffect_ReflectedVector | class | EffectExecutor | — |
| gameEffectExecutor_NewEffect_RicochetScan | class | gameEffectExecutor_NewEffect | box, isPreview, onlyForPlayer |
| gameEffectExecutor_OverrideMaterial | class | EffectExecutor | material |
| gameEffectExecutor_PhysicalFractureField | class | EffectExecutor | fromHitPosition, fieldParams, fieldShape, fieldDimensions |
| gameEffectExecutor_PhysicalImpulseFromInstigator | class | EffectExecutor | — |
| gameEffectExecutor_PhysicalImpulseFromInstigator_Value | class | EffectExecutor | magnitude, forceUseHitPosition |
| gameEffectExecutor_RevealObject | class | EffectExecutor | reason |
| gameEffectExecutor_SendStatusEffect | class | EffectExecutor | — |
| gameEffectExecutor_SendStimuli | class | EffectExecutor | — |
| gameEffectExecutor_TerminateGameEffect | class | EffectExecutor | onlyWithPlayerInstigator |
| gameEffectExecutor_TriggerDestruction | class | EffectExecutor | — |
| gameEffectExecutor_UpdateMeleeTireHit | class | EffectExecutor | — |
| gameEffectExecutor_VisualEffect | class | EffectExecutor | effect, attached, breakLoopOnDetach, effectTag, vectorEvaluator |
| gameEffectExecutor_VisualEffectAtInstigator | class | EffectExecutor | effect |
| gameEffectFilter_NotObstructed | class | EffectObjectSingleFilter | forwardOffset, filterData, queryPreset, playerUseCameraPositionForCheck |
| gameEffectFilter_ReachableByAcousticGraph | class | EffectObjectSingleFilter | maxPathLength |
| gameEffectFilter_ReachableByNavigation | class | EffectObjectSingleFilter | maxPathLength |
| gameEffectObjectFilter_AxisRange | class | EffectObjectSingleFilter | axis, position, constraints |
| gameEffectObjectFilter_AxisRangeAxis | enum | — | X, Y, Z |
| gameEffectObjectFilter_BlockingGeometry | class | gameEffectObjectGroupFilter | inclusive, sortQueryResultsByDistance |
| gameEffectObjectFilter_Cone | class | EffectObjectSingleFilter | — |
| gameEffectObjectFilter_DistanceFromRoot | class | gameEffectObjectGroupFilter | rootZOffset, bonusRange |
| gameEffectObjectFilter_EntityType | class | gameEffectObjectGroupFilter | typeFilter |
| gameEffectObjectFilter_EntityTypeEntityTypeFilter | enum | — | Puppet, Device |
| gameEffectObjectFilter_HitRepresentation | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_HitRepresentation_Capsule | class | gameEffectObjectFilter_HitRepresentation | flattenCapsuleToHeight |
| gameEffectObjectFilter_HitRepresentation_Quickhack | class | gameEffectObjectFilter_HitRepresentation | — |
| gameEffectObjectFilter_HitRepresentation_Raycast | class | gameEffectObjectFilter_HitRepresentation | isPreview, fillNearlyHitData |
| gameEffectObjectFilter_HitRepresentation_Sphere | class | gameEffectObjectFilter_HitRepresentation | — |
| gameEffectObjectFilter_HitRepresentation_SweepOverTime_Box | class | gameEffectObjectFilter_HitRepresentation | — |
| gameEffectObjectFilter_HitRepresentation_Sweep_Box | class | gameEffectObjectFilter_HitRepresentation | — |
| gameEffectObjectFilter_HitType | class | EffectObjectSingleFilter | action, hitType |
| gameEffectObjectFilter_HitTypeAction | enum | — | Accept, Reject |
| gameEffectObjectFilter_IgnoreMountedVehicle | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_NearestWeakspotIfAny | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_NoDuplicates | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_NoInstigator | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_NoInstigatorIfPlayerControlled | class | EffectObjectSingleFilter | — |
| gameEffectObjectFilter_NoPlayer | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_NoPuppet | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_NoSource | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_NoWeapon | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_NotAlive | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_NotObstructed | class | gameEffectObjectGroupFilter | filterData, queryPreset |
| gameEffectObjectFilter_OnlyNearestMelee | class | gameEffectObjectGroupFilter | count |
| gameEffectObjectFilter_OnlyNearest_BB | class | gameEffectObjectFilter_OnlyNearest | parameter |
| gameEffectObjectFilter_OnlyNearest_Pierce | class | gameEffectObjectFilter_OnlyNearest | alwaysApplyFullWeaponCharge, includePierced |
| gameEffectObjectFilter_PlayerIgnoreFriendlyAndAlive | class | gameEffectObjectGroupFilter | ignoreCharacterRecord |
| gameEffectObjectFilter_RejectOnPrereq | class | EffectObjectSingleFilter | prereq |
| gameEffectObjectFilter_TechPreview | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectFilter_Unique | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectGroupFilter_Cone | class | gameEffectObjectGroupFilter | — |
| gameEffectObjectProvider_Explosion | class | EffectObjectProvider | puppets, gameObjects, destructibleAndDynamic |
| gameEffectObjectProvider_Laser | class | gameEffectObjectProvider_PhysicalRay | inputTracesPerSecond, inputRayOffset |
| gameEffectObjectProvider_PhysicalRay | class | EffectObjectProvider | inputPosition, inputForward, inputRange, outputRaycastEnd, filterData |
| gameEffectObjectProvider_PhysicalRayFan | class | gameEffectObjectProvider_PhysicalRay | inputMinRayAngleDiff |
| gameEffectObjectProvider_QueryBox | class | EffectObjectProvider | filterData, queryPreset, inputPosition |
| gameEffectObjectProvider_QueryCapsule | class | EffectObjectProvider | gatherOnlyPuppets, queryPreset |
| gameEffectObjectProvider_QueryCapsule_GrowOverTime | class | gameEffectObjectProvider_QueryCapsule | — |
| gameEffectObjectProvider_QueryShockwave | class | gameEffectObjectProvider_QuerySphere | — |

# Citations

- `codeware/scripts/Base/Imports/gameEffectAction_ChildEffectsMovingInCone.reds`
- `codeware/scripts/Base/Imports/gameEffectAction_KillFX.reds`
- `codeware/scripts/Base/Imports/gameEffectAction_KillFXAction.reds`
- `codeware/scripts/Base/Imports/gameEffectAction_NewEffect_ReverseFromLastHit.reds`
- `codeware/scripts/Base/Imports/gameEffectAction_NewEffect_Ricochet.reds`
- `codeware/scripts/Base/Imports/gameEffectAction_NewEffect_SpreadingEffect.reds`
- `codeware/scripts/Base/Imports/gameEffectAction_TerminateChildEffect.reds`
- `codeware/scripts/Base/Imports/gameEffectAttachment.reds`
- `codeware/scripts/Base/Imports/gameEffectDuration_Duration_Blackboard.reds`
- `codeware/scripts/Base/Imports/gameEffectDuration_Infinite.reds`
- ... and 70 more source files
