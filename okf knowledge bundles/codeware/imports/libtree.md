---
type: "Import"
title: "Libtree Types"
description: "Imported game engine types in the libtree domain (35 types)."
resource: "codeware/scripts/"
tags: "[imports, libtree]"
timestamp: 2026-07-01T18:09:17Z
---

# Overview

Imported game engine types in the libtree domain (35 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| LibTreeCMetanodeDefinition | class | LibTreeINodeDefinition | — |
| LibTreeCMetanodeIfDefinition | class | LibTreeCMetanodeDefinition | ifCondition, ifBranch, elseBranch |
| LibTreeCTreeReference | class | ISerializable | TreeDefinition, parameters |
| LibTreeCTreeResource | class | CResource | variables |
| LibTreeDefBool | struct | — | variableId, v |
| LibTreeDefCName | struct | — | variableId, v |
| LibTreeDefEnum | struct | — | variableId, v |
| LibTreeDefFloat | struct | — | variableId, v |
| LibTreeDefISerializable | struct | — | variableId, v |
| LibTreeDefInt32 | struct | — | variableId, v |
| LibTreeDefNodeRef | struct | — | variableId, v |
| LibTreeDefTree | struct | — | variableId, v |
| LibTreeDefTreeList | struct | — | variableId, v |
| LibTreeDefTreeVariable | class | ISerializable | id, readableName |
| LibTreeDefTreeVariableBool | class | LibTreeDefTreeVariableBoolBase | exportAsProperty, defaultValue |
| LibTreeDefTreeVariableBoolBase | class | LibTreeDefTreeVariable | — |
| LibTreeDefTreeVariableCName | class | LibTreeDefTreeVariable | exportAsProperty, defaultValue |
| LibTreeDefTreeVariableEnum | class | LibTreeDefTreeVariable | exportAsProperty, enumClass, defaultValue |
| LibTreeDefTreeVariableFloat | class | LibTreeDefTreeVariable | exportAsProperty, defaultValue |
| LibTreeDefTreeVariableISerializable | class | LibTreeDefTreeVariable | exportAsProperty |
| LibTreeDefTreeVariableInt32 | class | LibTreeDefTreeVariable | exportAsProperty, defaultValue |
| LibTreeDefTreeVariableNodeRef | class | LibTreeDefTreeVariable | exportAsProperty, defaultValue |
| LibTreeDefTreeVariableTreeRef | class | LibTreeDefTreeVariable | exportAsProperty, defaultValue |
| LibTreeDefTreeVariableTreeRefList | class | LibTreeDefTreeVariable | exportAsProperty, defaultValue |
| LibTreeDefTreeVariableVector | class | LibTreeDefTreeVariable | exportAsProperty, defaultValue |
| LibTreeDefTreeVariablesList | struct | — | list |
| LibTreeDefVector | struct | — | variableId, v |
| LibTreeEParameterType | enum | — | PARAM_Bool, PARAM_Int32, PARAM_Enum, PARAM_Float, PARAM_CName |
| LibTreeGenericData | struct | — | — |
| LibTreeINodeDefinition | class | ISerializable | — |
| LibTreeParameter | struct | — | parameterName, parameterType |
| LibTreeParameterList | struct | — | parameters |
| LibTreeParametersForwarder | struct | — | overrides |
| LibTreeSharedVarReferenceName | struct | — | name |
| LibTreeSharedVarRegistrationName | struct | — | name |

# Citations

- `codeware/scripts/Base/Imports/LibTreeCMetanodeDefinition.reds`
- `codeware/scripts/Base/Imports/LibTreeCMetanodeIfDefinition.reds`
- `codeware/scripts/Base/Imports/LibTreeCTreeReference.reds`
- `codeware/scripts/Base/Imports/LibTreeCTreeResource.reds`
- `codeware/scripts/Base/Imports/LibTreeDefBool.reds`
- `codeware/scripts/Base/Imports/LibTreeDefCName.reds`
- `codeware/scripts/Base/Imports/LibTreeDefEnum.reds`
- `codeware/scripts/Base/Imports/LibTreeDefFloat.reds`
- `codeware/scripts/Base/Imports/LibTreeDefISerializable.reds`
- `codeware/scripts/Base/Imports/LibTreeDefInt32.reds`
- ... and 25 more source files
