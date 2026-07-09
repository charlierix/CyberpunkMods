---
type: "Import"
title: "Quest Types/Time"
description: "Imported quest types/time types (13 types)."
resource: "codeware/scripts/"
tags: "[imports, time]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/time types (13 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questTimeCondition | class | questTypedCondition | type |
| questTimeDilation_Entity | class | questTimeDilation_NodeTypeParam | operation, globalTimeDilationOverride, parentTimeDilationOverride, entities |
| questTimeDilation_NodeType | class | questIGameManagerNonSignalStoppingNodeType | params |
| questTimeDilation_NodeTypeParam | class | ISerializable | — |
| questTimeDilation_Operation | class | ISerializable | — |
| questTimeDilation_Player | class | questTimeDilation_NodeTypeParam | operation, globalTimeDilationOverride |
| questTimeDilation_Puppet | class | questTimeDilation_NodeTypeParam | operation, globalTimeDilationOverride, puppets |
| questTimeDilation_Start | class | questTimeDilation_Operation | dilation, duration, easeInCurve, easeOutCurve |
| questTimeDilation_Stop | class | questTimeDilation_Operation | easeOutCurve |
| questTimeDilation_World | class | questTimeDilation_NodeTypeParam | reason, operation |
| questTimePeriod_ConditionType | class | questITimeConditionType | begin, end |
| questTimeSkipMode | enum | — | PreSkip, PostSkip |
| questTimeSkipped_ConditionType | class | questIUIConditionType | mode |

# Citations

- `codeware/scripts/Base/Imports/questTimeCondition.reds`
- `codeware/scripts/Base/Imports/questTimeDilation_Entity.reds`
- `codeware/scripts/Base/Imports/questTimeDilation_NodeType.reds`
- `codeware/scripts/Base/Imports/questTimeDilation_NodeTypeParam.reds`
- `codeware/scripts/Base/Imports/questTimeDilation_Operation.reds`
- `codeware/scripts/Base/Imports/questTimeDilation_Player.reds`
- `codeware/scripts/Base/Imports/questTimeDilation_Puppet.reds`
- `codeware/scripts/Base/Imports/questTimeDilation_Start.reds`
- `codeware/scripts/Base/Imports/questTimeDilation_Stop.reds`
- `codeware/scripts/Base/Imports/questTimeDilation_World.reds`
- ... and 3 more source files
