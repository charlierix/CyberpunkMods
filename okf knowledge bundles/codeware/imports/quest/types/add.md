---
type: "Import"
title: "Quest Types/Add"
description: "Imported quest types/add types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, add]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/add types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questAddBraindanceClue_NodeType | class | questIUIManagerNodeType | clueName, startTime, endTime, layer |
| questAddCombatLogMessage_NodeType | class | questIUIManagerNodeType | message, localizedMessage |
| questAddRemoveContact_NodeType | class | questIPhoneManagerNodeType | params |
| questAddRemoveContact_NodeTypeParams | struct | — | contact |
| questAddRemoveItem_NodeType | class | questIItemManagerNodeType | params |
| questAddRemoveItem_NodeTypeParams | class | ISerializable | sendNotification, isPlayer, objectRef, entityRef, nodeType |

# Citations

- `codeware/scripts/Base/Imports/questAddBraindanceClue_NodeType.reds`
- `codeware/scripts/Base/Imports/questAddCombatLogMessage_NodeType.reds`
- `codeware/scripts/Base/Imports/questAddRemoveContact_NodeType.reds`
- `codeware/scripts/Base/Imports/questAddRemoveContact_NodeTypeParams.reds`
- `codeware/scripts/Base/Imports/questAddRemoveItem_NodeType.reds`
- `codeware/scripts/Base/Imports/questAddRemoveItem_NodeTypeParams.reds`
