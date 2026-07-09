---
type: "Import"
title: "Quest Data"
description: "Imported quest data types (8 types)."
resource: "codeware/scripts/"
tags: "[imports, data]"
timestamp: 2026-07-01T18:09:28Z
---

# Overview

Imported quest data types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questHUDEntryVisibilityData | struct | — | hudEntryName |
| questInjectLoot_NodeTypeParams_OperationData | class | ISerializable | operationType, itemTDBID, quantity |
| questSetSaveDataLoadingScreen_NodeType | class | questIUIManagerNodeType | selectedLoading |
| questTransferItems_NodeTypeParams_OperationData | struct | — | itemTDBID |
| questTransferItems_NodeTypeParams_TagOperationData | struct | — | tagToTransfer, tagsToIgnore |
| questTransferItems_NodeTypeParams_TransferAllOperationData | class | ISerializable | itemIDsToIgnore, tagsToIgnore |
| questdbgCallstackData | struct | — | resourceHash, blocks, executedHistory, callstackRevision |
| questdbgRuntimeData | struct | — | version, selectedBlockId |

# Citations

- `codeware/scripts/Base/Imports/questHUDEntryVisibilityData.reds`
- `codeware/scripts/Base/Imports/questInjectLoot_NodeTypeParams_OperationData.reds`
- `codeware/scripts/Base/Imports/questSetSaveDataLoadingScreen_NodeType.reds`
- `codeware/scripts/Base/Imports/questTransferItems_NodeTypeParams_OperationData.reds`
- `codeware/scripts/Base/Imports/questTransferItems_NodeTypeParams_TagOperationData.reds`
- `codeware/scripts/Base/Imports/questTransferItems_NodeTypeParams_TransferAllOperationData.reds`
- `codeware/scripts/Base/Imports/questdbgCallstackData.reds`
- `codeware/scripts/Base/Imports/questdbgRuntimeData.reds`
