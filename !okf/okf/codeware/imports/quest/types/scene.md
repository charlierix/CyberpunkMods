---
type: "Import"
title: "Quest Types/Scene"
description: "Imported quest types/scene types (9 types)."
resource: "codeware/scripts/"
tags: "[imports, scene]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/scene types (9 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questSceneCondition | class | questTypedCondition | type |
| questSceneConditionType | enum | — | Undefined, IsInside, IsOutside, Entered, Exited |
| questSceneInterrupt_ConditionType | class | questISceneConditionType | sceneFile, onlyInSafeMoment, interruptConditions |
| questSceneLocation | struct | — | sceneWorldMarkerTag |
| questSceneNode_ConditionType | class | questISceneConditionType | sceneFile, SceneVersion, ActorName, type |
| questSceneReturn_ConditionType | class | questISceneConditionType | sceneFile, SceneVersion, returnConditions |
| questSceneTalking_ConditionType | class | questISceneConditionType | GlobalEntityRef, sceneFile, SceneVersion, SectionName, ActorName |
| questSceneTier_ConditionType | class | questISceneConditionType | tier, isInverted |
| questScene_NodeType | class | questSpawnManagerNodeType | entityReference |

# Citations

- `codeware/scripts/Base/Imports/questSceneCondition.reds`
- `codeware/scripts/Base/Imports/questSceneConditionType.reds`
- `codeware/scripts/Base/Imports/questSceneInterrupt_ConditionType.reds`
- `codeware/scripts/Base/Imports/questSceneLocation.reds`
- `codeware/scripts/Base/Imports/questSceneNode_ConditionType.reds`
- `codeware/scripts/Base/Imports/questSceneReturn_ConditionType.reds`
- `codeware/scripts/Base/Imports/questSceneTalking_ConditionType.reds`
- `codeware/scripts/Base/Imports/questSceneTier_ConditionType.reds`
- `codeware/scripts/Base/Imports/questScene_NodeType.reds`
