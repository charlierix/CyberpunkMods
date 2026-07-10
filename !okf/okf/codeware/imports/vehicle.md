---
type: "Import"
title: "Vehicle Types"
description: "Imported game engine types in the vehicle domain (78 types)."
resource: "codeware/scripts/"
tags: "[imports, vehicle]"
timestamp: 2026-07-01T18:09:33Z
---

# Overview

Imported game engine types in the vehicle domain (78 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| GarageComponent | unknown | — | — |
| GarageComponentPS | unknown | — | — |
| VehicleAIMountedE3Hack | unknown | — | — |
| VehicleApplyZOffsetFromGroundEvent | unknown | — | — |
| VehicleAssignConvoyEvent | unknown | — | — |
| VehicleCinematicCameraManager | class | IScriptable | — |
| VehicleContactEvent | unknown | — | — |
| VehicleDetachAllPartsEvent | unknown | — | — |
| VehicleHasExplodedEvent | unknown | — | — |
| VehicleSlotsState | class | ISerializable | vehicleDoorState, vehicleWindowState, vehicleInteractionState |
| VehicleStartConvoyEvent | unknown | — | — |
| VehicleTeleportEvent | unknown | — | — |
| VehicleToggleDoorOpenEvent | unknown | — | — |
| VehicleToggleQuestForceBrakingEvent | unknown | — | — |
| VehicleToggleQuestWeaponEnabledEvent | unknown | — | — |
| VehicleTryKnockPlayerCarSurfingDownEvent | unknown | — | — |
| VehicleWheelPressureEvent | unknown | — | — |
| questvehicleChaseParams | class | questVehicleSpecificCommandParams | targetEntRef, isPlayer, distanceMin, distanceMax, forceStartSpeed |
| questvehicleFollowParams | class | questVehicleSpecificCommandParams | targetEntRef, distanceMin, distanceMax, isPlayer, stopWhenTargetReached |
| questvehicleJoinTrafficParams | class | questVehicleSpecificCommandParams | — |
| questvehicleOnSplineParams | class | questVehicleSpecificCommandParams | splineRef, reverseSpline, backwards, closest, forcedStartSpeed |
| questvehiclePanicParams | class | questVehicleSpecificCommandParams | allowSimplifiedMovement, ignoreTickets, disableStuckDetection, useSpeedBasedLookupRange, tryDriveAwayFromPlayer |
| questvehicleRacingParams | class | questVehicleSpecificCommandParams | splineRef, preciseLevel, reverseSpline, backwards, closest |
| questvehicleToNodeParams | class | questVehicleSpecificCommandParams | stopAtEnd, nodeRef, isPlayer, useTraffic, speedInTraffic |
| vehicleAIPathTrafficDeletionMode | enum | — | INSTANT, OUT_OF_VIEW, DEFERRED |
| vehicleAnimFeature_VehicleProceduralCamera | class | AnimFeature | cameraTranslationVS, cameraOrientationVS, cameraTargetWeight |
| vehicleArmedCarBaseObject | class | CarObject | — |
| vehicleAudio | unknown | — | — |
| vehicleAudioComponent | class | SoundComponentBase | — |
| vehicleAudioPSData | struct | — | — |
| vehicleAudioVehicleCurveSet | class | CurveSet | — |
| vehicleAutonomousData | class | ISerializable | owner, useKinematic, needDriver, aggressiveRammingEnabled, ignoreChaseVehiclesLimit |
| vehicleAutopilot | struct | — | — |
| vehicleAutopilotTransformProvider | struct | — | — |
| vehicleBikeCurve | enum | — | SpeedToTilt, InputToTilt, SpeedToTiltSpeed |
| vehicleBikeCurveSet | class | CurveSet | — |
| vehicleCameraManagerComponentPS | class | GameComponentPS | perspective |
| vehicleChangeAlarmEvent | class | Event | — |
| vehicleChangeHeadLightModeEvent | class | Event | — |
| vehicleChangeMovableEvent | class | Event | — |
| vehicleChassisComponent | class | IPlacedComponent | collisionResource, optionalPlayerOnlyCollisionResource |
| vehicleDestructionPSData | struct | — | — |
| vehicleDriveFollowEvent | class | Event | targetObjToFollow, distanceMin, distanceMax, stopWhenTargetReached, useTraffic |
| vehicleDriveFollowSplineEvent | class | Event | splineRef, backwards, reverseSpline |
| vehicleDriveSplineReverseEvent | class | Event | splineRef, backwards, reverseSpline |
| vehicleDriveToGameObjectEvent | class | Event | targetObjToReach |
| vehicleDriveToNodeRefEvent | class | Event | targetRef, useTraffic, speedInTraffic |
| vehicleDriveToPointEvent | class | Event | targetPos, useTraffic, speedInTraffic |
| vehicleDriver | struct | — | — |
| vehicleESummonedVehicleType | enum | — | Any, Car, Motorcycle |
| vehicleEVehicleSpeedConditionType | enum | — | CT_EQUAL, CT_NOT_EQUAL, CT_GREATER, CT_GREATER_EQUAL, CT_LESS |
| vehicleFollowObject | struct | — | — |
| vehicleForbiddenAreaState | unknown | — | — |
| vehicleFormation | struct | — | — |
| vehicleFormationType | enum | — | FORMATION_TRIANGLE, FORMATION_TURTLE, FORMATION_QUINCUNX |
| vehicleGarageComponentVehicleData | struct | — | — |
| vehicleLightComponent | class | gameLightComponent | allowSeparateEmissiveColor, emissiveColor, lightType, highBeamPitchAngle, highBeamRadiusMultiplier |
| vehicleMultilayerLoadingHandle | struct | — | — |
| vehicleNetrunnerQuickhackVehicleEndedEvent | class | Event | vehicleNetrunnerQuickhackType, shouldTriggerPanicDriving, shouldRejoinTraffic |
| vehiclePersistentData | class | GameComponent | — |
| vehiclePersistentDataPS | class | GameComponentPS | flags, autopilotPos, autopilotCurrentSpeed, isHackable, wheelRuntimeData |
| vehiclePlayerToAIBlendInterpolator | struct | — | — |
| vehiclePlayerToAIInterpolationType | enum | — | PTAIT_INSTANT, PTAIT_LINEAR, PTAIT_EASE_IN_QUAD, PTAIT_EASE_IN_CUBIC, PTAIT_EASE_OUT_CUBIC |
| vehicleSplineSlot | struct | — | — |
| vehicleSplineSlot_NonAnimSpline | struct | — | — |
| vehicleStartDynamicMovementEvent | class | Event | targetPosition |
| vehicleStopDriveToPointEvent | class | Event | — |
| vehicleSummonFinishState | enum | — | Arrived |
| vehicleTPPCameraComponent | class | CameraComponent | — |
| vehicleTPPCameraDistance | enum | — | Close, Medium, Far, DriverCombatClose, DriverCombatMedium |
| vehicleTPPCameraHeight | enum | — | Low, High |
| vehicleUnlockedVehicle | struct | — | — |
| vehicleVehicleAppearanceToDecalsName | unknown | — | — |
| vehicleVehicleAudioMultipliersEvent | unknown | — | — |
| vehicleVehicleMountableComponent | class | MountableComponent | — |
| vehicleVehicleProxyBlendCamera | class | CameraComponent | — |
| vehicleVisualPerception | struct | — | — |
| vehicleWheelRuntimePSData | struct | — | — |

# Citations

- `codeware/scripts/Base/Imports/GarageComponent.reds`
- `codeware/scripts/Base/Imports/GarageComponentPS.reds`
- `codeware/scripts/Base/Imports/VehicleAIMountedE3Hack.reds`
- `codeware/scripts/Base/Imports/VehicleApplyZOffsetFromGroundEvent.reds`
- `codeware/scripts/Base/Imports/VehicleAssignConvoyEvent.reds`
- `codeware/scripts/Base/Imports/VehicleCinematicCameraManager.reds`
- `codeware/scripts/Base/Imports/VehicleContactEvent.reds`
- `codeware/scripts/Base/Imports/VehicleDetachAllPartsEvent.reds`
- `codeware/scripts/Base/Imports/VehicleHasExplodedEvent.reds`
- `codeware/scripts/Base/Imports/VehicleSlotsState.reds`
- ... and 68 more source files
