---
type: "Component System"
title: "Core Components"
description: "Native game components for AI, animation, shooting, scanning, sensing, vehicles, and more."
resource: "!core/components/aiComponent.swift"
tags: ['core', 'components']
timestamp: 2026-07-01T13:00:55Z
---

# Core Components

Native game components for AI, animation, shooting, scanning, sensing, vehicles, and more.

## Source Files

- `core/components/aiComponent.swift`
- `core/components/animationControllerComponent.swift`
- `core/components/cwBreachComponents.swift`
- `core/components/dismembermentComponent.swift`
- `core/components/gameLightComponent.swift`
- `core/components/gameMountableComponent.swift`
- `core/components/gameNavmeshDetector.swift`
- `core/components/gamePuppetMountableComponent.swift`
- `core/components/gameVehicleMountableComponent.swift`
- `core/components/hitRepresentationComponent.swift`
- `core/components/inventoryComponent.swift`
- `core/components/lightComponent.swift`
- `core/components/lootContainers.swift`
- `core/components/movePoliciesComponent.swift`
- `core/components/playerStateMachineComponent.swift`
- `core/components/projectileComponent.swift`
- `core/components/scanningComponent.swift`
- `core/components/scriptableComponent.swift`
- `core/components/senseComponent.swift`
- `core/components/sourceShootComponent.swift`
- `core/components/stimBroadcasterComponent.swift`
- `core/components/targetShootComponent.swift`
- `core/components/targetTrackingComponent.swift`
- `core/components/trapComponent.swift`
- `core/components/uiComponents.swift`
- `core/components/vehicleCinematicCameraComponent.swift`
- `core/components/vehicleCustomizationComponent.swift`
- `core/components/virtualCameraComponent.swift`
- `core/components/visionModeComponent.swift`

## Member Types

**Total declarations: 154**

### Classs (94)

| Name | Bases | Source File |
|------|-------|-------------|
| AIComponent | GameComponent | core/components/aiComponent.swift |
| DriveToPointAutonomousUpdate | DriveCommandUpdate | core/components/aiComponent.swift |
| DrivePatrolUpdate | DriveCommandUpdate | core/components/aiComponent.swift |
| AIVehicleAgent | AIComponent | core/components/aiComponent.swift |
| AIHumanComponent | AIComponent | core/components/aiComponent.swift |
| AnimationControllerComponent | IComponent | core/components/animationControllerComponent.swift |
| BreachFinderComponent | IComponent | core/components/cwBreachComponents.swift |
| DismembermentComponent | IComponent | core/components/dismembermentComponent.swift |
| gameLightComponent | LightComponent | core/components/gameLightComponent.swift |
| MountableComponent | IComponent | core/components/gameMountableComponent.swift |
| gameNavmeshDetector | IPlacedComponent | core/components/gameNavmeshDetector.swift |
| gamePuppetMountableComponent | MountableComponent | core/components/gamePuppetMountableComponent.swift |
| gamevehicleVehicleMountableComponent | MountableComponent | core/components/gameVehicleMountableComponent.swift |
| HitData_Base | HitShapeUserData | core/components/hitRepresentationComponent.swift |
| HitShapeUserDataBase | HitShapeUserData | core/components/hitRepresentationComponent.swift |
| InventoryScriptCallback | IScriptable | core/components/inventoryComponent.swift |
| Inventory | GameComponent | core/components/inventoryComponent.swift |
| gameLootObject | GameObject | core/components/inventoryComponent.swift |
| gameItemDropObject | gameLootObject | core/components/inventoryComponent.swift |
| LightComponent | IVisualComponent | core/components/lightComponent.swift |
| SetContainerStateEvent | Event | core/components/lootContainers.swift |
| ToggleContainerLockEvent | Event | core/components/lootContainers.swift |
| gameLootContainerBasePS | GameObjectPS | core/components/lootContainers.swift |
| gameLootBag | GameObject | core/components/lootContainers.swift |
| gameLootContainerBase | GameObject | core/components/lootContainers.swift |
| gameContainerObjectBase | gameLootContainerBase | core/components/lootContainers.swift |
| LootContainerObjectAnimatedByTransform | gameContainerObjectBase | core/components/lootContainers.swift |
| LootContainerObjectAnimatedByTransformWithFlare | LootContainerObjectAnimatedByTransform | core/components/lootContainers.swift |
| AIActionMovePolicy | IScriptable | core/components/movePoliciesComponent.swift |
| gamestateMachineComponent | gamePlayerControlledComponent | core/components/playerStateMachineComponent.swift |
| gameprojectileScriptCollisionEvaluator | gameprojectileCollisionEvaluator | core/components/projectileComponent.swift |
| ObjectScanningDescription | IScriptable | core/components/scanningComponent.swift |
| DeviceScanningDescription | ObjectScanningDescription | core/components/scanningComponent.swift |
| NPCScanningDescription | ObjectScanningDescription | core/components/scanningComponent.swift |
| ToggleClueConclusionEvent | Event | core/components/scanningComponent.swift |
| DisableScannerEvent | Event | core/components/scanningComponent.swift |
| DisableObjectDescriptionEvent | Event | core/components/scanningComponent.swift |
| SetCustomObjectDescriptionEvent | Event | core/components/scanningComponent.swift |
| ClearCustomObjectDescriptionEvent | Event | core/components/scanningComponent.swift |
| ToggleFocusClueEvent | Event | core/components/scanningComponent.swift |
| CluePSData | IScriptable | core/components/scanningComponent.swift |
| gameScanningComponentPS | GameComponentPS | core/components/scanningComponent.swift |
| ScanningComponent | GameComponent | core/components/scanningComponent.swift |
| TestScriptableComponent | ScriptableComponent | core/components/scriptableComponent.swift |
| SenseComponent | IPlacedComponent | core/components/senseComponent.swift |
| SetNPCSensesMainPreset | AIbehaviortaskScript | core/components/senseComponent.swift |
| ResetNPCSensesMainPreset | AIbehaviortaskScript | core/components/senseComponent.swift |
| SourceShootComponent | IComponent | core/components/sourceShootComponent.swift |
| StimTargetsEvent | Event | core/components/stimBroadcasterComponent.swift |
| StimBroadcasterComponent | ScriptableComponent | core/components/stimBroadcasterComponent.swift |
| TargetShootComponent | IComponent | core/components/targetShootComponent.swift |
| AIScriptsTargetTrackingListener | AIITargetTrackingListener | core/components/targetTrackingComponent.swift |
| SecuritySupportListener | AIScriptsTargetTrackingListener | core/components/targetTrackingComponent.swift |
| TargetTrackingExtension | TargetTrackerComponent | core/components/targetTrackingComponent.swift |
| AIActionTarget | IScriptable | core/components/targetTrackingComponent.swift |
| TrapComponent | ScriptableComponent | core/components/trapComponent.swift |
| IWorldWidgetComponent | WidgetBaseComponent | core/components/uiComponents.swift |
| worlduiWidgetComponent | IWorldWidgetComponent | core/components/uiComponents.swift |
| frameWidgetComponent | worlduiWidgetComponent | core/components/uiComponents.swift |
| vehicleCinematicCameraShotEffect | IScriptable | core/components/vehicleCinematicCameraComponent.swift |
| vehicleTimedCinematicCameraShotEffect | vehicleCinematicCameraShotEffect | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShot | IScriptable | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShotGroup | IScriptable | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShotStartCondition | IScriptable | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShotStartCondition_VehicleType | vehicleCinematicCameraShotStartCondition | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShotStartCondition_MinSpeed | vehicleCinematicCameraShotStartCondition | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShotStartCondition_MaxSpeed | vehicleCinematicCameraShotStartCondition | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShotStopCondition | IScriptable | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShotStopCondition_VehicleNotVisible | vehicleCinematicCameraShotStopCondition | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShotStopCondition_VehicleDistanceFromCamera | vehicleCinematicCameraShotStopCondition | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShotStopCondition_CollisionWithEnvironment | vehicleCinematicCameraShotStopCondition | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraShotRoot | IScriptable | core/components/vehicleCinematicCameraComponent.swift |
| cameraShotRoot_FixedOnVehicle | vehicleCinematicCameraShotRoot | core/components/vehicleCinematicCameraComponent.swift |
| cameraShotRoot_FixedOnVehicleNonSuspensionTracking | cameraShotRoot_FixedOnVehicle | core/components/vehicleCinematicCameraComponent.swift |
| cameraShotRoot_FixedOnVehicleSuspensionTracking | cameraShotRoot_FixedOnVehicle | core/components/vehicleCinematicCameraComponent.swift |
| cameraShotRoot_FixedShot | vehicleCinematicCameraShotRoot | core/components/vehicleCinematicCameraComponent.swift |
| cameraShotEffect_Translation | vehicleTimedCinematicCameraShotEffect | core/components/vehicleCinematicCameraComponent.swift |
| cameraShotEffect_FOV | vehicleTimedCinematicCameraShotEffect | core/components/vehicleCinematicCameraComponent.swift |
| cameraShotEffect_LookAtVehicle | vehicleTimedCinematicCameraShotEffect | core/components/vehicleCinematicCameraComponent.swift |
| cameraShotEffect_Shake | CameraShotEffect_EulerAnglesDamper | core/components/vehicleCinematicCameraComponent.swift |
| cameraShotEffect_PositionShake | CameraShotEffect_VectorDamper | core/components/vehicleCinematicCameraComponent.swift |
| CameraShotEffect_PositionDamper | CameraShotEffect_VectorDamper | core/components/vehicleCinematicCameraComponent.swift |
| CameraShotEffect_RotationDamper | CameraShotEffect_EulerAnglesDamper | core/components/vehicleCinematicCameraComponent.swift |
| vehicleCinematicCameraComponent | CameraComponent | core/components/vehicleCinematicCameraComponent.swift |
| ScriptableVirtualCameraViewComponent | VirtualCameraViewComponent | core/components/virtualCameraComponent.swift |
| RevealQuestTargetEvent | Event | core/components/visionModeComponent.swift |
| ToggleForcedHighlightEvent | Event | core/components/visionModeComponent.swift |
| ToggleWeakspotHighlightEvent | Event | core/components/visionModeComponent.swift |
| SetPersistentForcedHighlightEvent | Event | core/components/visionModeComponent.swift |
| SetDefaultHighlightEvent | Event | core/components/visionModeComponent.swift |
| FocusForcedHighlightPersistentData | IScriptable | core/components/visionModeComponent.swift |
| FocusForcedHighlightData | IScriptable | core/components/visionModeComponent.swift |
| gameVisionModeComponentPS | GameComponentPS | core/components/visionModeComponent.swift |
| VisionModeComponent | GameComponent | core/components/visionModeComponent.swift |

### Structs (6)

| Name | Bases | Source File |
|------|-------|-------------|
| StimRequestID |  | core/components/stimBroadcasterComponent.swift |
| StimTargetData |  | core/components/stimBroadcasterComponent.swift |
| CinematicCameraData |  | core/components/vehicleCinematicCameraComponent.swift |
| VehicleDecalAttachmentData |  | core/components/vehicleCustomizationComponent.swift |
| VehicleClearCoatOverrides |  | core/components/vehicleCustomizationComponent.swift |
| VehiclePartsClearCoatOverrides |  | core/components/vehicleCustomizationComponent.swift |

### Funcs (54)

| Name | Bases | Source File |
|------|-------|-------------|
| OnItemNotification |  | core/components/inventoryComponent.swift |
| OnItemAdded |  | core/components/inventoryComponent.swift |
| OnItemRemoved |  | core/components/inventoryComponent.swift |
| OnItemQuantityChanged |  | core/components/inventoryComponent.swift |
| OnItemExtracted |  | core/components/inventoryComponent.swift |
| OnPartAdded |  | core/components/inventoryComponent.swift |
| OnPartRemoved |  | core/components/inventoryComponent.swift |
| OnAccuracyBoundReached |  | core/components/targetTrackingComponent.swift |
| OnSharedAccuracyBoundReached |  | core/components/targetTrackingComponent.swift |
| OnAccuracyBoundReached |  | core/components/targetTrackingComponent.swift |
| GetExecutionTime |  | core/components/vehicleCinematicCameraComponent.swift |
| Reset |  | core/components/vehicleCinematicCameraComponent.swift |
| Start |  | core/components/vehicleCinematicCameraComponent.swift |
| Update |  | core/components/vehicleCinematicCameraComponent.swift |
| GetExecutionTime |  | core/components/vehicleCinematicCameraComponent.swift |
| Reset |  | core/components/vehicleCinematicCameraComponent.swift |
| Start |  | core/components/vehicleCinematicCameraComponent.swift |
| StartDelayed |  | core/components/vehicleCinematicCameraComponent.swift |
| Evaluate |  | core/components/vehicleCinematicCameraComponent.swift |
| Evaluate |  | core/components/vehicleCinematicCameraComponent.swift |
| Evaluate |  | core/components/vehicleCinematicCameraComponent.swift |
| Evaluate |  | core/components/vehicleCinematicCameraComponent.swift |
| Reset |  | core/components/vehicleCinematicCameraComponent.swift |
| Evaluate |  | core/components/vehicleCinematicCameraComponent.swift |
| Reset |  | core/components/vehicleCinematicCameraComponent.swift |
| Evaluate |  | core/components/vehicleCinematicCameraComponent.swift |
| Evaluate |  | core/components/vehicleCinematicCameraComponent.swift |
| Evaluate |  | core/components/vehicleCinematicCameraComponent.swift |
| Reset |  | core/components/vehicleCinematicCameraComponent.swift |
| GetRootTransform |  | core/components/vehicleCinematicCameraComponent.swift |
| GetShotSpaceTransform |  | core/components/vehicleCinematicCameraComponent.swift |
| Reset |  | core/components/vehicleCinematicCameraComponent.swift |
| GetShotSpaceTransform |  | core/components/vehicleCinematicCameraComponent.swift |
| GetShotSpaceTransform |  | core/components/vehicleCinematicCameraComponent.swift |
| GetRootTransform |  | core/components/vehicleCinematicCameraComponent.swift |
| GetShotSpaceTransform |  | core/components/vehicleCinematicCameraComponent.swift |
| Reset |  | core/components/vehicleCinematicCameraComponent.swift |
| Start |  | core/components/vehicleCinematicCameraComponent.swift |
| StartDelayed |  | core/components/vehicleCinematicCameraComponent.swift |
| Update |  | core/components/vehicleCinematicCameraComponent.swift |
| Update |  | core/components/vehicleCinematicCameraComponent.swift |
| Update |  | core/components/vehicleCinematicCameraComponent.swift |
| Start |  | core/components/vehicleCinematicCameraComponent.swift |
| StartDelayed |  | core/components/vehicleCinematicCameraComponent.swift |
| Update |  | core/components/vehicleCinematicCameraComponent.swift |
| Start |  | core/components/vehicleCinematicCameraComponent.swift |
| StartDelayed |  | core/components/vehicleCinematicCameraComponent.swift |
| Update |  | core/components/vehicleCinematicCameraComponent.swift |
| Start |  | core/components/vehicleCinematicCameraComponent.swift |
| StartDelayed |  | core/components/vehicleCinematicCameraComponent.swift |
| Update |  | core/components/vehicleCinematicCameraComponent.swift |
| Start |  | core/components/vehicleCinematicCameraComponent.swift |
| StartDelayed |  | core/components/vehicleCinematicCameraComponent.swift |
| Update |  | core/components/vehicleCinematicCameraComponent.swift |

## Citations

- `core/components/aiComponent.swift`
- `core/components/animationControllerComponent.swift`
- `core/components/cwBreachComponents.swift`
- `core/components/dismembermentComponent.swift`
- `core/components/gameLightComponent.swift`
- `core/components/gameMountableComponent.swift`
- `core/components/gameNavmeshDetector.swift`
- `core/components/gamePuppetMountableComponent.swift`
- `core/components/gameVehicleMountableComponent.swift`
- `core/components/hitRepresentationComponent.swift`
- `core/components/inventoryComponent.swift`
- `core/components/lightComponent.swift`
- `core/components/lootContainers.swift`
- `core/components/movePoliciesComponent.swift`
- `core/components/playerStateMachineComponent.swift`
- `core/components/projectileComponent.swift`
- `core/components/scanningComponent.swift`
- `core/components/scriptableComponent.swift`
- `core/components/senseComponent.swift`
- `core/components/sourceShootComponent.swift`
- `core/components/stimBroadcasterComponent.swift`
- `core/components/targetShootComponent.swift`
- `core/components/targetTrackingComponent.swift`
- `core/components/trapComponent.swift`
- `core/components/uiComponents.swift`
- `core/components/vehicleCinematicCameraComponent.swift`
- `core/components/vehicleCustomizationComponent.swift`
- `core/components/virtualCameraComponent.swift`
- `core/components/visionModeComponent.swift`
