---
type: "Import"
title: "World Definitions"
description: "Imported world definitions types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, definitions]"
timestamp: 2026-07-01T18:09:37Z
---

# Overview

Imported world definitions types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldEnvironmentDefinition | class | CResource | worldRenderSettings, worldShadowConfig, worldLightingConfig, renderSettingFactors, weatherStates |
| worldPatrolSplinePointDefinition | class | ISerializable | pointType, node, target |
| worldTrafficLaneExitDefinition | struct | — | outLaneRef, exitProbability, thisLaneReversed |
| worldTrafficLightDefinition | struct | — | positionOnLane, extent |
| worldTrafficSpotDefinition | class | ISerializable | length, direction |
| worldTrafficSyncPointDefinition | struct | — | laneRefs, length |

# Citations

- `codeware/scripts/Base/Imports/worldEnvironmentDefinition.reds`
- `codeware/scripts/Base/Imports/worldPatrolSplinePointDefinition.reds`
- `codeware/scripts/Base/Imports/worldTrafficLaneExitDefinition.reds`
- `codeware/scripts/Base/Imports/worldTrafficLightDefinition.reds`
- `codeware/scripts/Base/Imports/worldTrafficSpotDefinition.reds`
- `codeware/scripts/Base/Imports/worldTrafficSyncPointDefinition.reds`
