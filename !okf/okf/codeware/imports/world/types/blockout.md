---
type: "Import"
title: "World Types/Blockout"
description: "Imported world types/blockout types (4 types)."
resource: "codeware/scripts/"
tags: "[imports, blockout]"
timestamp: 2026-07-01T18:09:34Z
---

# Overview

Imported world types/blockout types (4 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldBlockoutArea | class | ISerializable | name, color, parent, children, outlines |
| worldBlockoutAreaOutline | class | ISerializable | points, edges |
| worldBlockoutEdge | struct | — | points, isFree |
| worldBlockoutPoint | class | ISerializable | position, edges, constraint, isFree |

# Citations

- `codeware/scripts/Base/Imports/worldBlockoutArea.reds`
- `codeware/scripts/Base/Imports/worldBlockoutAreaOutline.reds`
- `codeware/scripts/Base/Imports/worldBlockoutEdge.reds`
- `codeware/scripts/Base/Imports/worldBlockoutPoint.reds`
