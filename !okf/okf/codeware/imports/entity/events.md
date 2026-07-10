---
type: "Import"
title: "Entity Events"
description: "Imported entity events types (38 types)."
resource: "codeware/scripts/"
tags: "[imports, events]"
timestamp: 2026-07-01T18:09:08Z
---

# Overview

Imported entity events types (38 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| EntityResizeEvent | class | Event | extents |
| EntityTargetedEvent | class | Event | targetingEntity |
| EntityUntargetedEvent | class | Event | targetingEntity |
| entAllowVehicleCollisionRagdollInSceneEvent | class | Event | allow |
| entAnimEntityToEntityAttachmentEvent | class | Event | — |
| entAnimGraphCustomDataEvent | class | Event | — |
| entAnimOnStateChangedEvent | class | Event | — |
| entAnimSoundEvent | class | entSoundEvent | metadataContext |
| entAppearanceDissolveFinishEvent | class | Event | — |
| entAppearanceLODsDistanceOverrideEvent | class | Event | — |
| entAppearanceMeshLoadedEvent | class | Event | — |
| entAppearanceStatusEvent | class | Event | status |
| entAttachEffectEvent | class | Event | — |
| entAttachEffectToSlotEvent | class | entAttachEffectEvent | — |
| entAttachGraphToSlotEvent | class | Event | — |
| entChangeVoicesetStateEvent | class | Event | enableVoicesetLines, enableVoicesetGrunts, inputsToBlock |
| entDestructionAudioEvent | class | Event | — |
| entDetachGraphFromSlotEvent | class | Event | — |
| entFoleyActionEvent | class | Event | actionName |
| entFootPhaseChangedEvent | class | Event | footPhase |
| entFootPlantedEvent | class | Event | customAction, footSide |
| entInjectVoiceTagEvent | class | Event | voiceTagName, forceInjection |
| entLocomotionSlideEvent | class | Event | — |
| entPreloadAllEffectsEvent | unknown | — | — |
| entPreloadEffectEvent | unknown | — | — |
| entReleasePreloadedEffectEvent | unknown | — | — |
| entReleasePreloadedEffectsEvent | unknown | — | — |
| entRenderHighlightEvent | unknown | — | — |
| entRenderOverlayEvent | class | Event | — |
| entRenderScanEvent | unknown | — | — |
| entSceneAnimSetEvent | class | Event | — |
| entShadowMeshChangeEvent | class | Event | requestedState |
| entSoundEvent | class | Event | eventName, switches, params, dynamicParams |
| entTriggerDestructionEvent | class | Event | — |
| entTriggerVOEvent | class | Event | triggerBaseName, triggerVariationIndex, triggerVariationNumber, debugInitialContext, answeringEntityIDHash |
| entUpdateEffectPositionEvent | class | Event | — |
| entUpdateRenderProxyStateEvent | class | Event | — |
| entWorkspotItemEvent | class | Event | — |

# Citations

- `codeware/scripts/Base/Imports/EntityResizeEvent.reds`
- `codeware/scripts/Base/Imports/EntityTargetedEvent.reds`
- `codeware/scripts/Base/Imports/EntityUntargetedEvent.reds`
- `codeware/scripts/Base/Imports/entAllowVehicleCollisionRagdollInSceneEvent.reds`
- `codeware/scripts/Base/Imports/entAnimEntityToEntityAttachmentEvent.reds`
- `codeware/scripts/Base/Imports/entAnimGraphCustomDataEvent.reds`
- `codeware/scripts/Base/Imports/entAnimOnStateChangedEvent.reds`
- `codeware/scripts/Base/Imports/entAnimSoundEvent.reds`
- `codeware/scripts/Base/Imports/entAppearanceDissolveFinishEvent.reds`
- `codeware/scripts/Base/Imports/entAppearanceLODsDistanceOverrideEvent.reds`
- ... and 28 more source files
