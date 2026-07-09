---
type: "Import"
title: "Scene Types/Scene"
description: "Imported scene types/scene types (16 types)."
resource: "codeware/scripts/"
tags: "[imports, scene]"
timestamp: 2026-07-01T18:09:29Z
---

# Overview

Imported scene types/scene types (16 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| scnSceneCategoryTag | enum | — | voiceset, mainQuests, sideQuests, minorQuests, otherQuests |
| scnSceneEventId | struct | — | id |
| scnSceneEventSymbol | struct | — | editorEventId, sceneEventIds |
| scnSceneGraph | class | ISerializable | graph, startNodes, endNodes |
| scnSceneGraphNode | class | ISerializable | nodeId, ffStrategy, outputSockets |
| scnSceneId | struct | — | resPathHash |
| scnSceneInstanceId | struct | — | sceneId, internalId |
| scnSceneInstanceOwnerId | struct | — | hash |
| scnSceneMarker | class | worldIMarker | markers, workspotMarkers |
| scnSceneSolutionHash | struct | — | sceneSolutionHash |
| scnSceneSolutionHashHash | struct | — | sceneSolutionHashDate |
| scnSceneTime | struct | — | stu |
| scnSceneTimeProvider | class | IVisualizerTimeProvider | — |
| scnSceneVOInfo | struct | — | inVoTrigger, duration |
| scnSceneVersionCheck | enum | — | OlderOrEqual, Equal |
| scnSceneWorkspotInstanceId | struct | — | id |

# Citations

- `codeware/scripts/Base/Imports/scnSceneCategoryTag.reds`
- `codeware/scripts/Base/Imports/scnSceneEventId.reds`
- `codeware/scripts/Base/Imports/scnSceneEventSymbol.reds`
- `codeware/scripts/Base/Imports/scnSceneGraph.reds`
- `codeware/scripts/Base/Imports/scnSceneGraphNode.reds`
- `codeware/scripts/Base/Imports/scnSceneId.reds`
- `codeware/scripts/Base/Imports/scnSceneInstanceId.reds`
- `codeware/scripts/Base/Imports/scnSceneInstanceOwnerId.reds`
- `codeware/scripts/Base/Imports/scnSceneMarker.reds`
- `codeware/scripts/Base/Imports/scnSceneSolutionHash.reds`
- ... and 6 more source files
