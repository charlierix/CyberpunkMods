---
type: "Import"
title: "Ink States"
description: "Imported ink states types (8 types)."
resource: "codeware/scripts/"
tags: "[imports, states]"
timestamp: 2026-07-01T18:09:16Z
---

# Overview

Imported ink states types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| inkIStateMachine | class | ISerializable | — |
| inkIStateMachineState | unknown | — | — |
| inkIgnoresCursorState | class | inkUserData | — |
| inkLastTickVideoState | enum | — | NotDrawn, Drawn, Paused |
| inkState | enum | — | InitEngine, PreGameMenu, InitialLoading, Game, InGameMenu |
| inkStateMachine | class | inkIStateMachine | — |
| inkVideoOptimizationState | enum | — | None, TooManyBinks, FullscreenBinkVisible |
| inkWidgetStateAnimatedTransition | struct | — | startState, animationName |

# Citations

- `codeware/scripts/Base/Imports/inkIStateMachine.reds`
- `codeware/scripts/Base/Imports/inkIStateMachineState.reds`
- `codeware/scripts/Base/Imports/inkIgnoresCursorState.reds`
- `codeware/scripts/Base/Imports/inkLastTickVideoState.reds`
- `codeware/scripts/Base/Imports/inkState.reds`
- `codeware/scripts/Base/Imports/inkStateMachine.reds`
- `codeware/scripts/Base/Imports/inkVideoOptimizationState.reds`
- `codeware/scripts/Base/Imports/inkWidgetStateAnimatedTransition.reds`
