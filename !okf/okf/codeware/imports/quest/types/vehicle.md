---
type: "Import"
title: "Quest Types/Vehicle"
description: "Imported quest types/vehicle types (20 types)."
resource: "codeware/scripts/"
tags: "[imports, vehicle]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/vehicle types (20 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questVehicleAVArrived_ConditionType | class | questIVehicleConditionType | vehicleRef |
| questVehicleAirtime_ConditionType | class | questIVehicleConditionType | seconds |
| questVehicleAvailable_ConditionType | class | questIVehicleConditionType | vehicleType, vehicleName |
| questVehicleCameraPerspective | enum | — | FPP, TPP |
| questVehicleCameraType | enum | — | Undefined, PuppetFPP, TPP, DriverFPP, FPP |
| questVehicleCollision_ConditionType | class | questIVehicleConditionType | magnitude |
| questVehicleCommandType | enum | — | Move_On_Spline, Follow, Move_To, Racing, Join_Traffic |
| questVehicleCondition | class | questTypedCondition | type |
| questVehicleCorrectlyPlaced_ConditionType | class | questIVehicleConditionType | vehicleRef, timeInterval, checkIsUpsideDown, checkIsOnTheSide, checkAreAllWheelsOnGround |
| questVehicleCrowdHit_ConditionType | class | questIVehicleConditionType | lethal |
| questVehicleDestruction_ConditionType | class | questIVehicleConditionType | vehicleRef, destruction, comparisonType |
| questVehicleDoor_ConditionType | class | questIVehicleConditionType | vehicleRef, door, state |
| questVehicleQuickHack_ConditionType | class | questIVehicleConditionType | vehicleRef, checkAccelerate, checkForceBrakes, checkRemoteControl |
| questVehicleSpawned_ConditionType | class | questIVehicleConditionType | vehicleType, vehicleRef, count, comparisonType, vehicleName |
| questVehicleSpeed_ConditionType | class | questIVehicleConditionType | vehicleRef, speed, comparisonType |
| questVehicleSummoned_ConditionType | class | questIVehicleConditionType | type |
| questVehicleTrunk_ConditionType | class | questIVehicleConditionType | anyVehicle, playerVehicle, vehicleRef, anyObject, objectRef |
| questVehicleWater_ConditionType | class | questIVehicleConditionType | anyVehicle, vehicleRef, submergedOnly, onEnter |
| questVehicleWeaponQuestID | enum | — | Primary, Secondary, Tertiary, Quaternary, Quinary |
| questVehicleWeaponUsed_ConditionType | class | questIVehicleConditionType | vehicleRef, weapon |

# Citations

- `codeware/scripts/Base/Imports/questVehicleAVArrived_ConditionType.reds`
- `codeware/scripts/Base/Imports/questVehicleAirtime_ConditionType.reds`
- `codeware/scripts/Base/Imports/questVehicleAvailable_ConditionType.reds`
- `codeware/scripts/Base/Imports/questVehicleCameraPerspective.reds`
- `codeware/scripts/Base/Imports/questVehicleCameraType.reds`
- `codeware/scripts/Base/Imports/questVehicleCollision_ConditionType.reds`
- `codeware/scripts/Base/Imports/questVehicleCommandType.reds`
- `codeware/scripts/Base/Imports/questVehicleCondition.reds`
- `codeware/scripts/Base/Imports/questVehicleCorrectlyPlaced_ConditionType.reds`
- `codeware/scripts/Base/Imports/questVehicleCrowdHit_ConditionType.reds`
- ... and 10 more source files
