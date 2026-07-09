---
type: "Import"
title: "Quest Types/Toggle"
description: "Imported quest types/toggle types (14 types)."
resource: "codeware/scripts/"
tags: "[imports, toggle]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/toggle types (14 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questToggleBrokenTire_NodeType | class | questIVehicleManagerNodeType | vehicleRef, val, tire |
| questToggleCombatForPlayer_NodeType | class | questIVehicleManagerNodeType | startCombat |
| questToggleDoor_NodeType | class | questIVehicleManagerNodeType | vehicleRef, doorAction, door, forceScene, toOpen |
| questToggleEventExecutionTag_NodeType | class | questISceneManagerNodeType | sceneFile, eventExecutionTag, mute |
| questToggleForceBrake_NodeType | class | questIVehicleManagerNodeType | vehicleRef, playerVehicle, val |
| questToggleMinimapVisibility_NodeSubType | class | questIUIManagerNodeType | entityReference, show |
| questTogglePrefabVariant_NodeType | class | questIWorldDataManagerNodeType | params |
| questTogglePrefabVariant_NodeTypeParams | struct | — | — |
| questToggleStealthMappinVisibility_NodeSubType | class | questIUIManagerNodeType | entityReference, show |
| questToggleSwitchSeatsForPlayer_NodeType | class | questIVehicleManagerNodeType | — |
| questToggleTankCustomFPPLockOff_NodeType | class | questIVehicleManagerNodeType | vehicleRef, playerVehicle, val |
| questToggleVisionMode_NodeType | class | questIVisionModeNodeType | objectRef, enable |
| questToggleWeaponEnabled_NodeType | class | questIVehicleManagerNodeType | vehicleRef, playerVehicle, val, weapon |
| questToggleWindow_NodeType | class | questIVehicleManagerNodeType | vehicleRef, windowState, door |

# Citations

- `codeware/scripts/Base/Imports/questToggleBrokenTire_NodeType.reds`
- `codeware/scripts/Base/Imports/questToggleCombatForPlayer_NodeType.reds`
- `codeware/scripts/Base/Imports/questToggleDoor_NodeType.reds`
- `codeware/scripts/Base/Imports/questToggleEventExecutionTag_NodeType.reds`
- `codeware/scripts/Base/Imports/questToggleForceBrake_NodeType.reds`
- `codeware/scripts/Base/Imports/questToggleMinimapVisibility_NodeSubType.reds`
- `codeware/scripts/Base/Imports/questTogglePrefabVariant_NodeType.reds`
- `codeware/scripts/Base/Imports/questTogglePrefabVariant_NodeTypeParams.reds`
- `codeware/scripts/Base/Imports/questToggleStealthMappinVisibility_NodeSubType.reds`
- `codeware/scripts/Base/Imports/questToggleSwitchSeatsForPlayer_NodeType.reds`
- ... and 4 more source files
