---
type: "Import"
title: "Effects Types"
description: "Imported effects types types (51 types)."
resource: "codeware/scripts/"
tags: "[imports, types]"
timestamp: 2026-07-01T18:09:07Z
---

# Overview

Imported effects types types (51 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| ParticleBurst | struct | — | burstTime, spawnTimeRange |
| ParticleDamage | class | ISerializable | boundingBoxes |
| VelocityEvaluator | class | PhysicsParticleInitializer | — |
| VelocityInheritEvaluator | class | PhysicsParticleInitializer | — |
| VelocitySpreadEvaluator | class | PhysicsParticleInitializer | — |
| cpAnimFeature_Stairs | class | AnimFeature | onOff |
| cpConveyor | class | GameObject | lines, movementCurve, entityDistance, entitySpawnOffset, audioParameterLineActive |
| cpConveyorLine | struct | — | spline, reverseDirection |
| cpConveyorObject | class | GameObject | rotationLerpFactor, ignoreZAxis |
| cpExplosiveBarrel | class | gameDestructibleObject | colliderComponentName, destructionComponentName |
| cpMeatBag | class | GameObject | rotationLerpFactor, kinematicBodyBoneName, bagBodyBoneName, physicalComponentName, bagHitComponentName |
| cpPlayerDetector | class | GameObject | range |
| cpPlayerDetector_PseudoDevice | class | GameObject | playerDetector |
| cpSplinePlacementProvider | class | ISerializable | — |
| cpSplinePlacementProvider_Count | class | cpSplinePlacementProvider_Distance | count |
| cpSplinePlacementProvider_Distance | class | cpSplinePlacementProvider | distance |
| cpStairsTrigger | class | GameObject | — |
| cpTestPhysXDynamicMovement | class | GameObject | — |
| cpTimerTest | class | GameObject | counter |
| effectBaseItem | class | ISerializable | — |
| effectBoneEntries | class | effectIPlacementEntries | inheritRotation, bones |
| effectIPlacementEntries | class | ISerializable | — |
| effectPlacedSpawner | class | effectSpawner | placement |
| effectRootEntries | class | effectIPlacementEntries | inheritRotation, roots |
| effectSlotEntries | class | effectIPlacementEntries | inheritRotation, slots |
| effectSpawner | class | ISerializable | — |
| effectTrack | class | effectTrackBase | items |
| effectTrackBase | class | effectBaseItem | — |
| effectTrackGroup | class | effectTrackBase | tracks, componentName |
| effectTrackItem | class | effectBaseItem | timeBegin, timeDuration, ruid |
| effectTrackItemBloom | class | effectTrackItem | override, sceneColorScale, bloomColorScale |
| effectTrackItemChromaticAberration | class | effectTrackItem | override, chromaticAberrationOffset, chromaticAberrationExp |
| effectTrackItemColorGrade | class | effectTrackItem | contrast, saturate, brightness, lutWeight, lutParams |
| effectTrackItemColorGradeV2 | class | effectTrackItem | contrast, contrastPivot, saturation, hue, brightness |
| effectTrackItemDecal | class | effectTrackItem | material, scale, emissiveScale, normalThreshold, horizontalFlip |
| effectTrackItemDynamicDecal | class | effectTrackItem | material, width, height, fadeInTime, fadeOutTime |
| effectTrackItemEmissive | class | effectTrackItem | override, brigtness |
| effectTrackItemExposureScale | class | effectTrackItem | scale, useInitialCameraPosDirForFadeout, fullEffectRadius, fadeOutRadius, fullyVisibleAngle |
| effectTrackItemFOV | class | effectTrackItem | FOV |
| effectTrackItemFilmGrain | class | effectTrackItem | override, luminanceBias, strength, mask |
| effectTrackItemFogVolume | class | effectTrackItem | priority, densityFalloff, blendFalloff, density, size |
| effectTrackItemForwardDecal | class | effectTrackItem | mesh, appearance, scale, additionalRotation, sizeThreshold |
| effectTrackItemLoopMarker | class | effectTrackItemMetadata | — |
| effectTrackItemMetadata | class | effectTrackItem | — |
| effectTrackItemMotionBlurScale | class | effectTrackItem | scale |
| effectTrackItemParticles | class | effectTrackItem | particleSystem, emissionScale, alpha, size, velocity |
| effectTrackItemPointLight | class | effectTrackItem | tint, intensity, EV, radius, offset |
| effectTrackItemSound | class | effectTrackItem | eventName, switches, params, positionName, emitterMetadataName |
| effectTrackItemTonemapping | class | effectTrackItem | override, maxStopsSDR, midGrayScaleSDR, maxStopsHDR, midGrayScaleHDR |
| effectTrackItemVignette | class | effectTrackItem | overrideRadiusAndExp, overrideColor, vignetteRadius, vignetteExp, color |
| effectTrackItemWeaponPlaneBlur | class | effectTrackItem | farPlaneMultiplier, override |

# Citations

- `codeware/scripts/Base/Imports/ParticleBurst.reds`
- `codeware/scripts/Base/Imports/ParticleDamage.reds`
- `codeware/scripts/Base/Imports/VelocityEvaluator.reds`
- `codeware/scripts/Base/Imports/VelocityInheritEvaluator.reds`
- `codeware/scripts/Base/Imports/VelocitySpreadEvaluator.reds`
- `codeware/scripts/Base/Imports/cpAnimFeature_Stairs.reds`
- `codeware/scripts/Base/Imports/cpConveyor.reds`
- `codeware/scripts/Base/Imports/cpConveyorLine.reds`
- `codeware/scripts/Base/Imports/cpConveyorObject.reds`
- `codeware/scripts/Base/Imports/cpExplosiveBarrel.reds`
- ... and 41 more source files
