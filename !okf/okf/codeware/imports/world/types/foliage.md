---
type: "Import"
title: "World Types/Foliage"
description: "Imported world types/foliage types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, foliage]"
timestamp: 2026-07-01T18:09:34Z
---

# Overview

Imported world types/foliage types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldFoliageBrush | class | CResource | items |
| worldFoliageBrushItem | class | ISerializable | Mesh, MeshAppearance, Params, Selected |
| worldFoliageDestructionNode | class | worldCollisionNode | populationIndex, foliageResourceHash, dataVersion |
| worldFoliageNode | class | worldNode | mesh, meshAppearance, foliageResource, foliageLocalBounds, autoHideDistanceScale |
| worldFoliagePopulationSpanInfo | struct | — | stancesBegin, stancesCount |
| worldFoliageRawItem | class | ISerializable | Mesh, MeshAppearance, Position, Rotation, Scale |

# Citations

- `codeware/scripts/Base/Imports/worldFoliageBrush.reds`
- `codeware/scripts/Base/Imports/worldFoliageBrushItem.reds`
- `codeware/scripts/Base/Imports/worldFoliageDestructionNode.reds`
- `codeware/scripts/Base/Imports/worldFoliageNode.reds`
- `codeware/scripts/Base/Imports/worldFoliagePopulationSpanInfo.reds`
- `codeware/scripts/Base/Imports/worldFoliageRawItem.reds`
