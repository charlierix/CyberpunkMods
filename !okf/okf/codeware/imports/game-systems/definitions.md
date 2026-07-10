---
type: "Import"
title: "Game-Systems Definitions"
description: "Imported game-systems definitions types (12 types)."
resource: "codeware/scripts/"
tags: "[imports, definitions]"
timestamp: 2026-07-01T18:09:13Z
---

# Overview

Imported game-systems definitions types (12 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameAnimationOverrideDefinition | struct | — | animset, variables |
| gameBlackboardPropertyBindingDefinition | struct | — | serializableID, propertyType |
| gameBodyTypeAnimationDefinition | struct | — | rig, animsets |
| gameCoverDefinition | class | gameSmartObjectWorkspotDefinition | overridenCoveringFOVDegrees, overridenCoveringVerticalFOVDegrees, fovExposureDegrees, overridenHeight, overrideGeneratedCoverAngles |
| gameEffectDefinition | struct | — | tag, objectFilters, durationModifiers, postActions, settings |
| gameHardcodedSignalPriorityDefinition | class | gameSignalPriorityDefinition | signals |
| gamePrereqDefinition | struct | — | prereqName |
| gameShootingSpotDefinition | class | gameCoverDefinition | — |
| gameSignalPriorityDefinition | class | ISerializable | defaultPriority |
| gameSmartObjectDefinition | class | ISerializable | resource, actions, motionActionDatabase, enabled, overrideGeneratedParameters |
| gameSmartObjectWorkspotDefinition | class | gameSmartObjectDefinition | workspotTemplate |
| gameTransformAnimationDefinition | struct | — | name, autoStartDelay, looping, reverse |

# Citations

- `codeware/scripts/Base/Imports/gameAnimationOverrideDefinition.reds`
- `codeware/scripts/Base/Imports/gameBlackboardPropertyBindingDefinition.reds`
- `codeware/scripts/Base/Imports/gameBodyTypeAnimationDefinition.reds`
- `codeware/scripts/Base/Imports/gameCoverDefinition.reds`
- `codeware/scripts/Base/Imports/gameEffectDefinition.reds`
- `codeware/scripts/Base/Imports/gameHardcodedSignalPriorityDefinition.reds`
- `codeware/scripts/Base/Imports/gamePrereqDefinition.reds`
- `codeware/scripts/Base/Imports/gameShootingSpotDefinition.reds`
- `codeware/scripts/Base/Imports/gameSignalPriorityDefinition.reds`
- `codeware/scripts/Base/Imports/gameSmartObjectDefinition.reds`
- ... and 2 more source files
