---
type: "Import"
title: "World Maps"
description: "Imported world maps types (7 types)."
resource: "codeware/scripts/"
tags: "[imports, maps]"
timestamp: 2026-07-01T18:09:37Z
---

# Overview

Imported world maps types (7 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldAutoFoliageMapping | class | CResource | Items |
| worldAutoFoliageMappingItem | struct | — | Material, FoliageBrush |
| worldFoliageBakedDestructionMapping | class | worldFoliageDestructionMapping | numFrames, frameRate, audioMetadata, destructionEffect, filterDataSource |
| worldFoliageDestructionMapping | class | ISerializable | baseMesh, destructibleMesh |
| worldFoliagePhysicalDestructionMapping | class | worldFoliageDestructionMapping | audioMetadata, destructionParams, destructionLevelData |
| worldInteriorMapNode | class | worldNode | version, coords |
| worldPrefabInteriorMapContribution | enum | — | Auto, Include, Discard |

# Citations

- `codeware/scripts/Base/Imports/worldAutoFoliageMapping.reds`
- `codeware/scripts/Base/Imports/worldAutoFoliageMappingItem.reds`
- `codeware/scripts/Base/Imports/worldFoliageBakedDestructionMapping.reds`
- `codeware/scripts/Base/Imports/worldFoliageDestructionMapping.reds`
- `codeware/scripts/Base/Imports/worldFoliagePhysicalDestructionMapping.reds`
- `codeware/scripts/Base/Imports/worldInteriorMapNode.reds`
- `codeware/scripts/Base/Imports/worldPrefabInteriorMapContribution.reds`
