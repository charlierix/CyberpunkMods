---
type: "Import"
title: "Entity Types"
description: "Imported entity types types (63 types)."
resource: "codeware/scripts/"
tags: "[imports, types]"
timestamp: 2026-07-01T18:09:08Z
---

# Overview

Imported entity types types (63 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| EntityIDArrayPrereq | class | IPrereq | — |
| entAnimationControlAttachment | class | entIAttachment | — |
| entAnimationControlBinding | class | entISourceBinding | — |
| entAnimationExtensionAttachment | class | entIAttachment | — |
| entAnimationFloatTrackAttachment | class | entIAttachment | — |
| entAppearanceStatus | enum | — | None, Proxy, Appearance |
| entCollisionPredictionPositionProvider | class | IPositionProvider | — |
| entDebugPositionProvider | class | IPositionProvider | — |
| entDebug_ShapeType | enum | — | Sphere, Box, Capsule, Cylinder |
| entDistanceLODsPresets | class | ISerializable | definitions |
| entEBindingDirection | enum | — | BindToSource, BindToDestination |
| entEffectDesc | class | ISerializable | id, effectName, effect, compiledEffectInfo, autoSpawnTag |
| entEntityOrientationProvider | class | IOrientationProvider | slotComponent, slotId, entity, orientationEntitySpace |
| entEntityPositionProvider | class | IPositionProvider | — |
| entEntityPreview | class | Entity | — |
| entEntitySpawnPriority | enum | — | Background, Normal, Immediate, Paramount, Critical |
| entEntitySpawnToken | class | IScriptable | — |
| entEntityTemplate | class | resStreamedResource | includes, appearances, defaultAppearance, visualTagsSchema, componentResolveSettings |
| entFactory | class | ISerializable | — |
| entFallbackSlot | struct | — | slotName |
| entForcedLodDistance | enum | — | Default, Background, Regular, Cinematic, Vehicle |
| entFuncOrientationProvider | class | IOrientationProvider | — |
| entFuncPositionProvider | class | IPositionProvider | — |
| entGenericListFactory | class | entFactory | — |
| entHardAttachment | class | entITransformAttachment | — |
| entHardTransformBinding | class | entITransformBinding | slotName |
| entHistoryPositionProvider | class | IPositionProvider | — |
| entIAttachment | class | ISerializable | source, destination |
| entIBinding | class | ISerializable | enabled, enableMask, bindName |
| entIDestinationBinding | class | entIBinding | — |
| entISkinningAttachment | class | entIAttachment | — |
| entISourceBinding | class | entIBinding | — |
| entITransformAttachment | class | entIAttachment | — |
| entITransformBinding | class | entISourceBinding | — |
| entLookAtLimits | struct | — | softLimitDegrees, hardLimitDistance |
| entRenderToTextureFeatures | struct | — | renderDecals, renderForwardNoTXAA, contactShadows, SSAO |
| entRenderToTextureFeaturesPlatform | enum | — | RTFP_All, RTFP_PC, RTFP_PC_PS5_XSX, RTFP_Consoles, RTFP_None |
| entRenderToTextureMode | enum | — | Shaded, GBufferOnly |
| entRepellingShape | enum | — | Sphere, Capsule |
| entRepellingType | enum | — | Debris, BigObjects, WindImpulse, WaterImpulse |
| entReplicatedInputSetterBase | struct | — | name |
| entReplicatedInputSetters | struct | — | serverReplicatedTime |
| entReplicatedItem | struct | — | entity |
| entReplicatedVariableValue | struct | — | name, applyServerTime |
| entSimpleSkinningAttachment | class | entISkinningAttachment | — |
| entSkinningBinding | class | entISourceBinding | — |
| entSlot | struct | — | slotName, relativeRotation |
| entSlotAttachment | class | entITransformAttachment | — |
| entSlotPositionProvider | class | IPositionProvider | — |
| entSpawnersContainer | class | ISerializable | — |
| entStaticOrientationProvider | class | IOrientationProvider | staticOrientation |
| entStaticPositionProvider | class | IPositionProvider | — |
| entTagMask | struct | — | hardTags, excludedTags |
| entTemplateAppearance | struct | — | name, appearanceName |
| entTemplateBindingOverride | struct | — | componentName, binding |
| entTemplateInclude | struct | — | name |
| entTriggerNotifier_Entity | class | worldITriggerAreaNotifer | entityRef |
| entVertexAnimationBinding | class | entISourceBinding | — |
| entVertexAnimationMapperSourceType | enum | — | FloatTrack, TranslationX, TranslationY, TranslationZ, RotationQuatX |
| entVisualTagsSchema | class | ISerializable | visualTags, schema |
| entVoicesetInputToBlock | struct | — | input, variationNumber |
| enteventsSetDissolveVisibility | class | Event | — |
| enteventsSetPlaneSetting | class | Event | — |

# Citations

- `codeware/scripts/Base/Imports/EntityIDArrayPrereq.reds`
- `codeware/scripts/Base/Imports/entAnimationControlAttachment.reds`
- `codeware/scripts/Base/Imports/entAnimationControlBinding.reds`
- `codeware/scripts/Base/Imports/entAnimationExtensionAttachment.reds`
- `codeware/scripts/Base/Imports/entAnimationFloatTrackAttachment.reds`
- `codeware/scripts/Base/Imports/entAppearanceStatus.reds`
- `codeware/scripts/Base/Imports/entCollisionPredictionPositionProvider.reds`
- `codeware/scripts/Base/Imports/entDebugPositionProvider.reds`
- `codeware/scripts/Base/Imports/entDebug_ShapeType.reds`
- `codeware/scripts/Base/Imports/entDistanceLODsPresets.reds`
- ... and 53 more source files
