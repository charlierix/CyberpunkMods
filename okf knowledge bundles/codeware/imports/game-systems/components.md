---
type: "Import"
title: "Game-Systems Components"
description: "Imported game-systems components types (33 types)."
resource: "codeware/scripts/"
tags: "[imports, components]"
timestamp: 2026-07-01T18:09:12Z
---

# Overview

Imported game-systems components types (33 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameAIDirectorTensionAnalyzeComponent | class | IComponent | — |
| gameBodyTriggerDestructionComponent | class | gameITriggerDestructionComponent | colliderComponentName, filterData, impulseForce, impulseRadius |
| gameComponentsStateSaveComponent | class | IComponent | — |
| gameComponentsStateSystem | class | gameIComponentsStateSystem | — |
| gameEffectComponentBinding | class | entISourceBinding | — |
| gameEntityStubComponent | class | GameComponent | — |
| gameEntityStubComponentPlacedProxy | class | IPlacedComponent | — |
| gameIComponentsStateSystem | class | IGameSystem | — |
| gameITriggerDestructionComponent | class | IComponent | startActive |
| gameImpostorComponent | class | IComponent | isCharacterReplica, addHead, ignorePlayerHeadSlot, slotIDsToOmit |
| gameImpostorComponentAttachEvent | class | Event | — |
| gameImpostorComponentSlotListener | class | AttachmentSlotsListener | — |
| gameLadderComponent | class | IComponent | heightOfBottomPart, exitStepTop, verticalStepTop, exitStepBottom, verticalStepBottom |
| gameMovingPlatformMountableComponent | class | MountableComponent | — |
| gameObjectMountableComponent | class | MountableComponent | — |
| gameOccupantSlotComponent | class | SlotComponent | slotData |
| gamePhantomEntityComponent | class | IComponent | params, effectBinding |
| gamePhotoModeBackgroundCameraComponent | class | entCameraComponent | isEnabled, virtualCameraName, dynamicTextureRes, env, params |
| gamePhysicalDestructionListenerComponent | class | IComponent | physicalDestructionComponentName, thresholdLevels |
| gamePlayerCommandConsumerComponent | class | IComponent | — |
| gamePlayerTierComponent | class | IComponent | — |
| gamePuppetTriggerDestructionComponent | class | gameITriggerDestructionComponent | projectionDist |
| gameRootTransformAnimatorComponent | class | entIMoverComponent | animations |
| gameScreenshot360CameraComponent | class | CameraComponent | — |
| gameSquadMemberComponentPS | class | GameComponentPS | entries |
| gameStatsComponentPS | class | GameComponentPS | — |
| gameTPPRepresentationComponent | class | IComponent | detachedObjectInfo, attachedObjectInfo, affectedAppearanceSlots |
| gameTargetingActivatorComponent | class | IComponent | — |
| gameTargetingComponentData | struct | — | — |
| gameTargetingLocalizedEffectComponent | class | IComponent | streamingDistance, visibleTargetRange |
| gameTransformAnimatorComponent | class | IPlacedComponent | animations |
| gameVisionActivatorComponent | class | IComponent | — |
| gameWeaponAudioComponent | class | SoundComponentBase | — |

# Citations

- `codeware/scripts/Base/Imports/gameAIDirectorTensionAnalyzeComponent.reds`
- `codeware/scripts/Base/Imports/gameBodyTriggerDestructionComponent.reds`
- `codeware/scripts/Base/Imports/gameComponentsStateSaveComponent.reds`
- `codeware/scripts/Base/Imports/gameComponentsStateSystem.reds`
- `codeware/scripts/Base/Imports/gameEffectComponentBinding.reds`
- `codeware/scripts/Base/Imports/gameEntityStubComponent.reds`
- `codeware/scripts/Base/Imports/gameEntityStubComponentPlacedProxy.reds`
- `codeware/scripts/Base/Imports/gameIComponentsStateSystem.reds`
- `codeware/scripts/Base/Imports/gameITriggerDestructionComponent.reds`
- `codeware/scripts/Base/Imports/gameImpostorComponent.reds`
- ... and 23 more source files
