---
type: "Import"
title: "Entity Components"
description: "Imported entity components types (48 types)."
resource: "codeware/scripts/"
tags: "[imports, components]"
timestamp: 2026-07-01T18:09:08Z
---

# Overview

Imported entity components types (48 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| EntitySpawnerComponent | unknown | — | — |
| entAmbientSoundEmitterComponent | class | IPlacedComponent | Settings, usePhysicsObstruction, occlusionEnabled, repositionEnabled, obstructionChangeTime |
| entAnimationSetupExtensionComponent | class | IComponent | animations, isOverrideContainer, controlBinding |
| entAppearanceProxyMeshComponent | class | PhysicalMeshComponent | — |
| entAttachEffectToComponentEvent | class | entAttachEffectEvent | — |
| entCharacterCustomizationSkinnedMeshComponent | class | entSkinnedMeshComponent | tags |
| entClothComponent | unknown | — | — |
| entComponentsStorage | class | ISerializable | components |
| entDebug_MeshComponent | class | MeshComponent | filterName |
| entDebug_ShapeComponent | class | IVisualComponent | radius, halfHeight, color, isEnabled |
| entDecalComponent | class | IVisualComponent | material, verticalFlip, horizontalFlip, aspectRatio, scale |
| entDynamicActorRepellingComponent | class | IPlacedComponent | type, shape, magnitude, bendIntensity, anchorPointVert |
| entEffectAttachmentComponent | class | IComponent | — |
| entEffectSpawnerComponent | unknown | — | — |
| entEntityUserComponentResolution | struct | — | id, mode |
| entEntityUserComponentResolutionMode | enum | — | Select, Suppress |
| entExternalComponent | class | IComponent | externalComponentName |
| entFacialCustomizationComponent | class | IComponent | debugIgnoreComponent, customizationSet, eyes, nose, mouth |
| entFogVolumeComponent | class | IVisualComponent | densityFalloff, blendFalloff, densityFactor, color, absorption |
| entGarmentParameterComponentData | struct | — | componentID, visibleTrangleIndexBufferHash, chunksCount, bendPowerMultiplier, smoothingStrength |
| entGarmentSkinnedMeshComponent | class | entSkinnedMeshComponent | — |
| entIMoverComponent | unknown | — | — |
| entISkinTargetComponent | class | IVisualComponent | skinning, useSkinningLOD |
| entInstancedAnimationComponent | class | ISkinableComponent | animations, animToSample, variantAnimToSample, variantTriggerTag |
| entLightBlockingComponent | class | IVisualComponent | radius, lightBlockerComponentVersion |
| entMarketingAnimationComponent | class | IPlacedComponent | freezeAnimations, animations, enableLookAt, lookAtSettings, lookAtCamera |
| entMeshComponentLODMode | enum | — | AlwaysVisible, Appearance, AppearanceProxy |
| entMorphTargetManagerComponent | class | entExternalComponent | — |
| entMorphTargetSkinnedMeshComponent | class | entISkinTargetComponent | morphResource, meshAppearance, castShadows, castLocalShadows, acceptDismemberment |
| entParticlesComponent | class | IVisualComponent | emissionRate, particleSystem, autoHideRange, renderLayerMask, isEnabled |
| entPhysicalFractureFieldComponent | unknown | — | — |
| entPhysicalImpulseAreaComponent | unknown | — | — |
| entPlacedComponentPositionProvider | class | IPositionProvider | — |
| entPlaceholderComponent | class | IPlacedComponent | — |
| entRenderToTextureCameraComponent | class | entCameraComponent | isEnabled, virtualCameraName, dynamicTextureRes, depthDynamicTextureRes, albedoDynamicTextureRes |
| entSkinnedClothComponent | unknown | — | — |
| entSkinnedMeshComponent | class | entISkinTargetComponent | mesh, meshAppearance, castShadows, castLocalShadows, acceptDismemberment |
| entSoundListenerComponent | class | IPlacedComponent | — |
| entStaticOccluderMeshComponent | class | IPlacedComponent | mesh, scale, color, occluderType, occluderAutohideDistanceScale |
| entTemplateComponentBackendDataOverrideInfo | struct | — | componentName |
| entTemplateComponentResolveMode | enum | — | AutoSelect, Select, Suppress |
| entTemplateComponentResolveSettings | struct | — | componentName, mode |
| entTransformComponent | class | IPlacedComponent | — |
| entTriggerActivatorComponent | class | IPlacedComponent | radius, height, channels, maxContinousDistance, enableCCD |
| entTriggerComponent | unknown | — | — |
| entVectorFieldComponent | class | IVisualComponent | direction, isEnabled |
| entVertexAnimationComponent | class | IComponent | vertexAnimationMapper, animatedComponent |
| entVisualOffsetTransformComponent | class | entTransformComponent | — |

# Citations

- `codeware/scripts/Base/Imports/EntitySpawnerComponent.reds`
- `codeware/scripts/Base/Imports/entAmbientSoundEmitterComponent.reds`
- `codeware/scripts/Base/Imports/entAnimationSetupExtensionComponent.reds`
- `codeware/scripts/Base/Imports/entAppearanceProxyMeshComponent.reds`
- `codeware/scripts/Base/Imports/entAttachEffectToComponentEvent.reds`
- `codeware/scripts/Base/Imports/entCharacterCustomizationSkinnedMeshComponent.reds`
- `codeware/scripts/Base/Imports/entClothComponent.reds`
- `codeware/scripts/Base/Imports/entComponentsStorage.reds`
- `codeware/scripts/Base/Imports/entDebug_MeshComponent.reds`
- `codeware/scripts/Base/Imports/entDebug_ShapeComponent.reds`
- ... and 38 more source files
