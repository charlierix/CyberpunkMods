---
type: "Import"
title: "Quest Params"
description: "Imported quest params types (38 types)."
resource: "codeware/scripts/"
tags: "[imports, params]"
timestamp: 2026-07-01T18:09:27Z
---

# Overview

Imported quest params types (38 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questAnimMoveOnSplineParams | struct | — | controllersSetupName, globalInBlendTime, turnCharacterToMatchVelocity, customMainAnimationName, startSnapToTerrain |
| questCombatNodeParams | class | AICommandParams | — |
| questCombatNodeParams_PrimaryWeapon | class | questCombatNodeParams | unEquip |
| questCombatNodeParams_RestrictMovementToArea | class | questCombatNodeParams | area |
| questCombatNodeParams_SecondaryWeapon | class | questCombatNodeParams | unEquip |
| questCombatNodeParams_ShootAt | class | questCombatNodeParams | targetOverrideNode, targetOverridePuppet, duration, once, immediately |
| questCombatNodeParams_SwitchWeapon | class | questCombatNodeParams | mode |
| questCombatNodeParams_ThrowGrenade | class | questCombatNodeParams | targetOverrideNode, targetOverridePuppet, duration, once, force |
| questCombatNodeParams_UseCover | class | questCombatNodeParams | cover, oneTimeSelection, forceStance, forcedEntryAnimation, immediately |
| questComparisonParam | class | ISerializable | entireCommunity, count, comparisonType |
| questConstAICommandParams | class | AICommandParams | command |
| questDevice_ConditionFunctionParameter | struct | — | name |
| questEquipItemParams | class | AICommandParams | slotId, type, itemId, equipDurationOverride, unequipDurationOverride |
| questFollowParams | class | AICommandParams | companionRef, companionDistance, destinationPointTolerance, stopWhenDestinationReached, movementType |
| questJoinCrowdParams | class | AICommandParams | repeatCommandOnInterrupt |
| questMoveOnSplineAdditionalParams | class | ISerializable | type, simpleParams, animParams, withCompanionParams |
| questMoveOnSplineParams | class | AICommandParams | splineNodeRef, useStart, useStop, reverse, startFromClosestPoint |
| questMovePuppetNodeParams | class | AICommandParams | moveType, moveOnSplineParams, moveToParams, otherParams, repeatCommandOnInterrupt |
| questMoveToParams | class | AICommandParams | movementTargetRef, facingTargetRef, rotateEntityTowardsFacingTarget, movementType, ignoreNavigation |
| questMultiplayerAIDirectorParams | class | ISerializable | function, status, pathRef, scheduleEntryName, scheduleName |
| questMultiplayerChoiceTokenParams | struct | — | timeout |
| questMultiplayerTeleportPuppetParams | struct | — | teleportAllPlayers, destinationRef, areaNodeTriggerRef |
| questParamKeepDistance | class | ISerializable | companionTargetRef, distance |
| questParamRubberbanding | class | ISerializable | targetRef, targetForwardOffset, minDistance, maxDistance, stopAndWait |
| questPatrolParams | class | AICommandParams | pathParams, repeatCommandOnInterrupt |
| questPlayerLookAtParams | class | ISerializable | useOffsetToPlayer, lookAtTarget, slotName, offset, duration |
| questRotateToParams | class | AICommandParams | facingTargetRef, angleOffset, speed |
| questSimpleMoveOnSplineParams | struct | — | movementType, rotateEntityTowardsFacingTarget, useOffMeshLinkReservation |
| questTeleportPuppetParams | struct | — | destinationRef |
| questTeleportPuppetParamsV1 | class | AICommandParams | destinationRef, destinationOffset, doNavTest, useFastTravelMechanism, healAtTeleport |
| questUnequipItemParams | struct | — | slotId |
| questUseWorkspotCommandParams | class | AICommandParams | workspotNode, moveToWorkspot, forceEntryAnimName |
| questUseWorkspotParams | struct | — | — |
| questUseWorkspotParamsV1 | class | AICommandParams | function, workspotNode, teleport, finishAnimation, forceEntryAnimName |
| questUseWorkspotPlayerParams | struct | — | — |
| questVehicleCommandParams | class | AICommandParams | type, additionalParamsOnSpline, additionalParamsFollow, additionalParamsToNode, additionalParamsRacing |
| questVehicleSpecificCommandParams | class | ISerializable | pushOtherVehiclesAside, needDriver, secureTimeOut |
| questWithCompanionMoveOnSplineParams | struct | — | movementType, rotateEntityTowardsFacingTarget, shootingTargetRef, companionDistancePreset, catchUpWithCompanion |

# Citations

- `codeware/scripts/Base/Imports/questAnimMoveOnSplineParams.reds`
- `codeware/scripts/Base/Imports/questCombatNodeParams.reds`
- `codeware/scripts/Base/Imports/questCombatNodeParams_PrimaryWeapon.reds`
- `codeware/scripts/Base/Imports/questCombatNodeParams_RestrictMovementToArea.reds`
- `codeware/scripts/Base/Imports/questCombatNodeParams_SecondaryWeapon.reds`
- `codeware/scripts/Base/Imports/questCombatNodeParams_ShootAt.reds`
- `codeware/scripts/Base/Imports/questCombatNodeParams_SwitchWeapon.reds`
- `codeware/scripts/Base/Imports/questCombatNodeParams_ThrowGrenade.reds`
- `codeware/scripts/Base/Imports/questCombatNodeParams_UseCover.reds`
- `codeware/scripts/Base/Imports/questComparisonParam.reds`
- ... and 28 more source files
