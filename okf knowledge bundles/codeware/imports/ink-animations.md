---
type: "Import"
title: "Ink-Animations Types"
description: "Imported game engine types in the ink-animations domain (18 types)."
resource: "codeware/scripts/"
tags: "[imports, ink-animations]"
timestamp: 2026-07-01T18:09:17Z
---

# Overview

Imported game engine types in the ink-animations domain (18 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| inkanimAdvertPauseEvent | class | inkAnimEvent | — |
| inkanimAnimationController | class | inkLogicController | — |
| inkanimAnimationLibraryResource | class | CResource | sequences |
| inkanimChangeStateEvent | class | inkAnimEvent | state |
| inkanimChangeTexturePartEvent | class | inkAnimEvent | imageTexturePartName |
| inkanimExecuteCodeEventEvent | class | inkAnimEvent | eventToExecute |
| inkanimExecuteControllerFunctionEvent | class | inkAnimEvent | controllerType, eventName, params |
| inkanimMarkerEvent | class | inkAnimEvent | markerName |
| inkanimPlayAnimEvent | class | inkAnimEvent | animName, playbackOptions |
| inkanimPlaySoundEvent | class | inkAnimEvent | soundEventName |
| inkanimPlayVOEvent | class | inkAnimEvent | VOLine, speakerName |
| inkanimPlayVideoEvent | class | inkAnimEvent | videoResource |
| inkanimProcessor | class | ISerializable | — |
| inkanimSequenceTargetInfo | class | ISerializable | path |
| inkanimSetStyleEvent | class | inkAnimEvent | style |
| inkanimSetTextEvent | class | inkAnimEvent | localizationString |
| inkanimStopAnimEvent | class | inkAnimEvent | animName |
| inkanimStopVideoEvent | class | inkAnimEvent | — |

# Citations

- `codeware/scripts/Base/Imports/inkanimAdvertPauseEvent.reds`
- `codeware/scripts/Base/Imports/inkanimAnimationController.reds`
- `codeware/scripts/Base/Imports/inkanimAnimationLibraryResource.reds`
- `codeware/scripts/Base/Imports/inkanimChangeStateEvent.reds`
- `codeware/scripts/Base/Imports/inkanimChangeTexturePartEvent.reds`
- `codeware/scripts/Base/Imports/inkanimExecuteCodeEventEvent.reds`
- `codeware/scripts/Base/Imports/inkanimExecuteControllerFunctionEvent.reds`
- `codeware/scripts/Base/Imports/inkanimMarkerEvent.reds`
- `codeware/scripts/Base/Imports/inkanimPlayAnimEvent.reds`
- `codeware/scripts/Base/Imports/inkanimPlaySoundEvent.reds`
- ... and 8 more source files
