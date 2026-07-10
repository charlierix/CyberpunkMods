---
type: "Import"
title: "Prereqs Types"
description: "Imported game engine types in the prereqs domain (15 types)."
resource: "codeware/scripts/"
tags: "[imports, prereqs]"
timestamp: 2026-07-01T18:09:22Z
---

# Overview

Imported game engine types in the prereqs domain (15 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| CurrentTargetPrereq | class | IPrereq | — |
| CurrentTargetPrereqState | class | PrereqState | — |
| EntitiesWithStatusEffectPrereq | class | IPrereq | — |
| EntitiesWithStatusEffectPrereqState | class | PrereqState | — |
| EquippedPrereq | class | IPrereq | itemID, slot |
| EquippedPrereqState | class | PrereqState | — |
| HasDialogVisualizerVisiblePrereq | class | IPrereq | — |
| HasDialogVisualizerVisiblePrereqState | class | PrereqState | — |
| MultiEcsManagerComponent | class | IComponent | — |
| MultiPrereq | unknown | — | — |
| NotImplementedAICommandParams | class | AICommandParams | — |
| NotPrereq | class | IPrereq | negatedPrereq |
| NotPrereqState | class | PrereqState | — |
| ProximityProgressBarAction | enum | — | Activated, Inactivated, Completed, WentOutOfRange |
| WasScannedPrereqState | class | PrereqState | — |

# Citations

- `codeware/scripts/Base/Imports/CurrentTargetPrereq.reds`
- `codeware/scripts/Base/Imports/CurrentTargetPrereqState.reds`
- `codeware/scripts/Base/Imports/EntitiesWithStatusEffectPrereq.reds`
- `codeware/scripts/Base/Imports/EntitiesWithStatusEffectPrereqState.reds`
- `codeware/scripts/Base/Imports/EquippedPrereq.reds`
- `codeware/scripts/Base/Imports/EquippedPrereqState.reds`
- `codeware/scripts/Base/Imports/HasDialogVisualizerVisiblePrereq.reds`
- `codeware/scripts/Base/Imports/HasDialogVisualizerVisiblePrereqState.reds`
- `codeware/scripts/Base/Imports/MultiEcsManagerComponent.reds`
- `codeware/scripts/Base/Imports/MultiPrereq.reds`
- ... and 5 more source files
