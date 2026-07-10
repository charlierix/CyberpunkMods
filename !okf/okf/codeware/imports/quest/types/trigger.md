---
type: "Import"
title: "Quest Types/Trigger"
description: "Imported quest types/trigger types (5 types)."
resource: "codeware/scripts/"
tags: "[imports, trigger]"
timestamp: 2026-07-01T18:09:24Z
---

# Overview

Imported quest types/trigger types (5 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questTriggerCondition | class | questCondition | type, triggerAreaRef, activatorRef, isPlayerActivator |
| questTriggerConditionType | enum | — | Undefined, Entered, Exited, IsInside, IsOutside |
| questTriggerCondition_FulfillInfo | struct | — | — |
| questTriggerIconGeneration_NodeType | class | questIUIManagerNodeType | — |
| questTriggerNotifier_Quest | class | worldITriggerAreaNotifer | — |

# Citations

- `codeware/scripts/Base/Imports/questTriggerCondition.reds`
- `codeware/scripts/Base/Imports/questTriggerConditionType.reds`
- `codeware/scripts/Base/Imports/questTriggerCondition_FulfillInfo.reds`
- `codeware/scripts/Base/Imports/questTriggerIconGeneration_NodeType.reds`
- `codeware/scripts/Base/Imports/questTriggerNotifier_Quest.reds`
