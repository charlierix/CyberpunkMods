---
type: "Import"
title: "Movement Types"
description: "Imported game engine types in the movement domain (14 types)."
resource: "codeware/scripts/"
tags: "[imports, movement]"
timestamp: 2026-07-01T18:09:21Z
---

# Overview

Imported game engine types in the movement domain (14 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| MoveEquip | unknown | — | — |
| MovePoliciesSystem | class | IMovePoliciesSystem | — |
| MoveSystem | class | IMoveSystem | — |
| MoveSystemStopEvent | class | ActionEvent | — |
| StrafingTarget | struct | — | position |
| moveComponent | class | entIMoverComponent | — |
| moveDroneMotionPlannerComponent | class | moveMotionPlannerComponent | — |
| moveIMotionPlannerComponent | class | IComponent | — |
| moveMotionPlannerComponent | class | moveIMotionPlannerComponent | snapToGround |
| moveMovementOrientationType | enum | — | NotSet, Forward, Backward, Left, Right |
| movePoliciesContract | class | ISerializable | — |
| movePoliciesContractMoveToSmartObject | class | movePoliciesContract | — |
| movePoliciesContractMoveToWorkspot | class | movePoliciesContract | — |
| moveReplicatedMovePoliciesState | struct | — | items |

# Citations

- `codeware/scripts/Base/Imports/MoveEquip.reds`
- `codeware/scripts/Base/Imports/MovePoliciesSystem.reds`
- `codeware/scripts/Base/Imports/MoveSystem.reds`
- `codeware/scripts/Base/Imports/MoveSystemStopEvent.reds`
- `codeware/scripts/Base/Imports/StrafingTarget.reds`
- `codeware/scripts/Base/Imports/moveComponent.reds`
- `codeware/scripts/Base/Imports/moveDroneMotionPlannerComponent.reds`
- `codeware/scripts/Base/Imports/moveIMotionPlannerComponent.reds`
- `codeware/scripts/Base/Imports/moveMotionPlannerComponent.reds`
- `codeware/scripts/Base/Imports/moveMovementOrientationType.reds`
- ... and 4 more source files
