---
type: "Import"
title: "Graph Types"
description: "Imported game engine types in the graph domain (18 types)."
resource: "codeware/scripts/"
tags: "[imports, graph]"
timestamp: 2026-07-01T18:09:15Z
---

# Overview

Imported game engine types in the graph domain (18 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| ExpressionTreeCAINodeDefinition | class | ExpressionTreeCNodeDefinition | — |
| ExpressionTreeCConstBoolNodeDefinition | class | ExpressionTreeCGeneralNodeDefinition | value |
| ExpressionTreeCConstFloatNodeDefinition | class | ExpressionTreeCGeneralNodeDefinition | value |
| ExpressionTreeCGeneralAndNodeDefinition | class | ExpressionTreeCGeneralCompositeNodeDefinition | — |
| ExpressionTreeCGeneralCompositeNodeDefinition | class | ExpressionTreeCGeneralNodeDefinition | children |
| ExpressionTreeCGeneralIfNodeDefinition | class | ExpressionTreeCGeneralNodeDefinition | expressions, trueBranch, falseBranch |
| ExpressionTreeCGeneralNodeDefinition | class | ExpressionTreeCNodeDefinition | — |
| ExpressionTreeCGeneralOrNodeDefinition | class | ExpressionTreeCGeneralCompositeNodeDefinition | — |
| ExpressionTreeCNodeDefinition | class | LibTreeINodeDefinition | — |
| ExpressionTreeCParametrizationNodeDefinition | class | ExpressionTreeCNodeDefinition | — |
| ExpressionTreeCParametrizationNodeReadIntDefinition | class | ExpressionTreeCParametrizationNodeDefinition | — |
| ExpressionTreeExecutionListenerRef | struct | — | — |
| graphGraphConnectionDefinition | class | graphIGraphObjectDefinition | source, destination |
| graphGraphDefinition | class | graphIGraphObjectDefinition | nodes |
| graphGraphNodeDefinition | class | graphIGraphObjectDefinition | sockets |
| graphGraphResource | class | CResource | graph |
| graphIGraphNodeCondition | class | ISerializable | — |
| graphIGraphObjectDefinition | class | ISerializable | — |

# Citations

- `codeware/scripts/Base/Imports/ExpressionTreeCAINodeDefinition.reds`
- `codeware/scripts/Base/Imports/ExpressionTreeCConstBoolNodeDefinition.reds`
- `codeware/scripts/Base/Imports/ExpressionTreeCConstFloatNodeDefinition.reds`
- `codeware/scripts/Base/Imports/ExpressionTreeCGeneralAndNodeDefinition.reds`
- `codeware/scripts/Base/Imports/ExpressionTreeCGeneralCompositeNodeDefinition.reds`
- `codeware/scripts/Base/Imports/ExpressionTreeCGeneralIfNodeDefinition.reds`
- `codeware/scripts/Base/Imports/ExpressionTreeCGeneralNodeDefinition.reds`
- `codeware/scripts/Base/Imports/ExpressionTreeCGeneralOrNodeDefinition.reds`
- `codeware/scripts/Base/Imports/ExpressionTreeCNodeDefinition.reds`
- `codeware/scripts/Base/Imports/ExpressionTreeCParametrizationNodeDefinition.reds`
- ... and 8 more source files
