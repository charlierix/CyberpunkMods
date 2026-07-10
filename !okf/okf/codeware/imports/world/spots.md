---
type: "Import"
title: "World Spots"
description: "Imported world spots types (5 types)."
resource: "codeware/scripts/"
tags: "[imports, spots]"
timestamp: 2026-07-01T18:09:37Z
---

# Overview

Imported world spots types (5 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldAISpotNode | class | worldSocketNode | spot, isWorkspotInfinite, isWorkspotStatic, markings, spotDef |
| worldTrafficPersistentLaneSpots | struct | — | spots |
| worldTrafficSpotCompiled | class | ISerializable | — |
| worldTrafficSpotDirection | enum | — | Forward, Backward, Both |
| worldTrafficSpotNode | class | worldAISpotNode | — |

# Citations

- `codeware/scripts/Base/Imports/worldAISpotNode.reds`
- `codeware/scripts/Base/Imports/worldTrafficPersistentLaneSpots.reds`
- `codeware/scripts/Base/Imports/worldTrafficSpotCompiled.reds`
- `codeware/scripts/Base/Imports/worldTrafficSpotDirection.reds`
- `codeware/scripts/Base/Imports/worldTrafficSpotNode.reds`
