---
type: "Import"
title: "Quest Managers/Entity"
description: "Imported quest managers/entity types (19 types)."
resource: "codeware/scripts/"
tags: "[imports, entity]"
timestamp: 2026-07-01T18:09:26Z
---

# Overview

Imported quest managers/entity types (19 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questEntityManagerAddDevelopmentPoint_NodeType | class | questIEntityManager_NodeType | value, type |
| questEntityManagerChangeAppearance_NodeType | class | questIEntityManager_NodeType | entityRef, prefetchOnly, appearanceName |
| questEntityManagerDestroyCarriedObject | class | questIEntityManagerSetAttachment_NodeSubType | attachmentRef, objectRef, isPlayer |
| questEntityManagerEnablePlayerTPPRepresentation_NodeType | class | questIEntityManager_NodeType | enable |
| questEntityManagerForceStat_NodeType | class | questIEntityManager_NodeType | objectRef, isPlayer, statType, value, unforce |
| questEntityManagerLevelUpProficiency_NodeType | class | questIEntityManager_NodeType | type |
| questEntityManagerMountPuppet_NodeType | class | questIEntityManager_NodeType | parentRef, childRef, isParentPlayer, slotName, assign |
| questEntityManagerRemoteControlVehicle_NodeType | class | questIEntityManager_NodeType | parentRef, enable, shouldUnseatPassengers, shouldModifyInteractionState |
| questEntityManagerSendAnimationEvent_NodeType | class | questIEntityManager_NodeType | objectRef, eventName |
| questEntityManagerSetAttachment_NodeType | class | questIEntityManager_NodeType | subtype |
| questEntityManagerSetAttachment_ToActor | class | questIEntityManagerSetAttachment_NodeSubType | attachmentRef, objectRef, isPlayer, slot, offsetMode |
| questEntityManagerSetAttachment_ToNode | class | questIEntityManagerSetAttachment_NodeSubType | attachmentRef, objectRef, slot, customOffsetPos, customOffsetRot |
| questEntityManagerSetAttachment_ToWorld | class | questIEntityManagerSetAttachment_NodeSubType | attachmentRef, offsetMode, customOffsetPos, customOffsetRot |
| questEntityManagerSetDestructionState_NodeType | class | questIEntityManager_NodeType | action, params |
| questEntityManagerSetDestructionState_NodeTypeParams | struct | — | objectRef |
| questEntityManagerSetMeshAppearance_NodeType | class | questIEntityManager_NodeType | params |
| questEntityManagerSetMeshAppearance_NodeTypeParams | struct | — | objectRef, componentName |
| questEntityManagerSetStat_NodeType | class | questIEntityManager_NodeType | objectRef, isPlayer, statType, value, setExactValue |
| questEntityManagerToggleMirrorsArea_NodeType | class | questIEntityManager_NodeType | objectRef, isInMirrorsArea |

# Citations

- `codeware/scripts/Base/Imports/questEntityManagerAddDevelopmentPoint_NodeType.reds`
- `codeware/scripts/Base/Imports/questEntityManagerChangeAppearance_NodeType.reds`
- `codeware/scripts/Base/Imports/questEntityManagerDestroyCarriedObject.reds`
- `codeware/scripts/Base/Imports/questEntityManagerEnablePlayerTPPRepresentation_NodeType.reds`
- `codeware/scripts/Base/Imports/questEntityManagerForceStat_NodeType.reds`
- `codeware/scripts/Base/Imports/questEntityManagerLevelUpProficiency_NodeType.reds`
- `codeware/scripts/Base/Imports/questEntityManagerMountPuppet_NodeType.reds`
- `codeware/scripts/Base/Imports/questEntityManagerRemoteControlVehicle_NodeType.reds`
- `codeware/scripts/Base/Imports/questEntityManagerSendAnimationEvent_NodeType.reds`
- `codeware/scripts/Base/Imports/questEntityManagerSetAttachment_NodeType.reds`
- ... and 9 more source files
