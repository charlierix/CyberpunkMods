---
type: "Import"
title: "World Types/Node"
description: "Imported world types/node types (5 types)."
resource: "codeware/scripts/"
tags: "[imports, node]"
timestamp: 2026-07-01T18:09:34Z
---

# Overview

Imported world types/node types (5 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldNode | class | ISerializable | isVisibleInGame, isHostOnly |
| worldNodeGroupType | enum | — | RegularGroup, PrefabVariant, DecorationCell, ProxyGroup |
| worldNodeInstanceRegistry | class | worldINodeInstanceRegistry | — |
| worldNodeSocketType | enum | — | Bidirectional, Inward, Outward, Disabled |
| worldNodeTransform | struct | — | translation, scale |

# Citations

- `codeware/scripts/Base/Imports/worldNode.reds`
- `codeware/scripts/Base/Imports/worldNodeGroupType.reds`
- `codeware/scripts/Base/Imports/worldNodeInstanceRegistry.reds`
- `codeware/scripts/Base/Imports/worldNodeSocketType.reds`
- `codeware/scripts/Base/Imports/worldNodeTransform.reds`
