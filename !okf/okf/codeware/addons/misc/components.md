---
type: "Addon"
title: "Misc Components Addons"
description: "Field additions to misc components types (25 types)."
resource: "codeware/scripts/"
tags: "[addons, components]"
timestamp: 2026-07-01T18:09:41Z
---

# Overview

Field additions to misc components types (25 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| BinkComponent | addon | — | meshTargetBinding, videoPlayerName, binkResource, audioEvent, loopVideo |
| BreachComponent | addon | — | radius, healthPercentageOverride |
| BreachControllerComponent | addon | — | canHaveBreaches, allowNormalBreachesAfterWeakspotsAreDestroyed, debugAllowBreachesAfterDestruction, breachesScale |
| ColliderComponent | addon | — | colliders, simulationType, startInactive, useCCD, massOverride |
| FPPCameraComponent | addon | — | pitchMin, pitchMax, yawMaxLeft, yawMaxRight, headingLocked |
| IComponent | addon | — | name, isReplicable, id |
| IPlacedComponent | addon | — | localTransform, parentTransform |
| IVisualComponent | addon | — | autoHideDistance, renderSceneLayerMask, forceLODLevel |
| IWorldWidgetComponent | addon | — | glitchValue, tintColor, screenAreaMultiplier, textureMinMipBias, textureMaxMipBias |
| InfluenceComponent | addon | — | isEnabled |
| InfluenceObstacleComponent | addon | — | boundingBoxType, customBoundingBox, obstacleAgent, isEnabled |
| InteractionComponent | addon | — | definitionResource, interactionRootOffset, layerOverrides, layerOverridesTemp, isEnabled |
| OffMeshConnectionComponent | addon | — | offMeshConnectionNodesRefs, agentSize |
| ProjectileComponent | addon | — | onCollisionAction, useSweepCollision, collisionsFilterClosest, sweepCollisionRadius, rotationOffset |
| ProjectileSpawnComponent | addon | — | spawnOffset, projectileTemplates, slotName |
| ScriptableComponent | addon | — | priority |
| SimpleColliderComponent | addon | — | isEnabled, colliders, filter |
| SlotComponent | addon | — | slots, fallbackSlots |
| SoundComponentBase | addon | — | audioName, applyObstruction, applyAcousticOcclusion, applyAcousticRepositioning, obstructionChangeTime |
| TransformHistoryComponent | addon | — | historyLength, samplesAmount |
| VirtualCameraComponent | addon | — | virtualCameraName, resolutionWidth, resolutionHeight, drawBackground, isEnabled |
| VirtualCameraViewComponent | addon | — | virtualCameraName, targetPlaneSize |
| WeakspotComponent | addon | — | defaultPhysicalDestructionProperties |
| frameWidgetComponent | addon | — | dimensions |
| soundComponent | addon | — | subSystems, voEventOverride, minVocalizationRepeatTime, streamingDistance |

# Citations

- `codeware/scripts/Base/Addons/BinkComponent.reds`
- `codeware/scripts/Base/Addons/BreachComponent.reds`
- `codeware/scripts/Base/Addons/BreachControllerComponent.reds`
- `codeware/scripts/Base/Addons/ColliderComponent.reds`
- `codeware/scripts/Base/Addons/FPPCameraComponent.reds`
- `codeware/scripts/Base/Addons/IComponent.reds`
- `codeware/scripts/Base/Addons/IPlacedComponent.reds`
- `codeware/scripts/Base/Addons/IVisualComponent.reds`
- `codeware/scripts/Base/Addons/IWorldWidgetComponent.reds`
- `codeware/scripts/Base/Addons/InfluenceComponent.reds`
- ... and 15 more source files
