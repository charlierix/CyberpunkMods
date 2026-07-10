---
type: "Import"
title: "Quest Types/Input"
description: "Imported quest types/input types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, input]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/input types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questInputAction_ConditionType | class | questISystemConditionType | anyInputAction, inputAction, checkIfButtonAlreadyPressed, axisAction, valueLessThan |
| questInputDevice | enum | — | Undefined, KeyboardMouse, XBoxGamepad, PS4Gamepad, StadiaGamepad |
| questInputHintGroup_NodeType | class | questIUIManagerNodeType | show, iconID, groupId, localizedTitle, localizedDescription |
| questInputHint_NodeType | class | questIUIManagerNodeType | show, action, groupId, source, localizedLabel |
| questInputScheme | enum | — | Legacy, Agile, Alternative |
| questInputScheme_ConditionType | class | questISystemConditionType | scheme |

# Citations

- `codeware/scripts/Base/Imports/questInputAction_ConditionType.reds`
- `codeware/scripts/Base/Imports/questInputDevice.reds`
- `codeware/scripts/Base/Imports/questInputHintGroup_NodeType.reds`
- `codeware/scripts/Base/Imports/questInputHint_NodeType.reds`
- `codeware/scripts/Base/Imports/questInputScheme.reds`
- `codeware/scripts/Base/Imports/questInputScheme_ConditionType.reds`
