---
type: "Import"
title: "Scene Types/Choice"
description: "Imported scene types/choice types (9 types)."
resource: "codeware/scripts/"
tags: "[imports, choice]"
timestamp: 2026-07-01T18:09:30Z
---

# Overview

Imported scene types/choice types (9 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| scnChoiceHubPartId | struct | — | id |
| scnChoiceNode | class | scnSceneGraphNode | displayNameOverride, localizedDisplayNameOverride, options, mode, persistentLineEvents |
| scnChoiceNodeNsAdaptiveLookAtReferencePoint | struct | — | referencePoint |
| scnChoiceNodeNsOperationMode | enum | — | attachToActor, attachToProp, attachToGameObject, attachToScreen, attachToWorld |
| scnChoiceNodeNsSizePreset | enum | — | small, normal, big, Dialogue, Interaction |
| scnChoiceNodeNsTimedAction | enum | — | appear, disappear, disappearFading |
| scnChoiceNodeNsVisualizerStyle | enum | — | onScreen, inWorld |
| scnChoiceNodeOption | struct | — | screenplayOptionId, blueline, isSingleChoice, timedParams, triggerCondition |
| scnscreenplayChoiceOption | struct | — | itemId, locstringId |

# Citations

- `codeware/scripts/Base/Imports/scnChoiceHubPartId.reds`
- `codeware/scripts/Base/Imports/scnChoiceNode.reds`
- `codeware/scripts/Base/Imports/scnChoiceNodeNsAdaptiveLookAtReferencePoint.reds`
- `codeware/scripts/Base/Imports/scnChoiceNodeNsOperationMode.reds`
- `codeware/scripts/Base/Imports/scnChoiceNodeNsSizePreset.reds`
- `codeware/scripts/Base/Imports/scnChoiceNodeNsTimedAction.reds`
- `codeware/scripts/Base/Imports/scnChoiceNodeNsVisualizerStyle.reds`
- `codeware/scripts/Base/Imports/scnChoiceNodeOption.reds`
- `codeware/scripts/Base/Imports/scnscreenplayChoiceOption.reds`
