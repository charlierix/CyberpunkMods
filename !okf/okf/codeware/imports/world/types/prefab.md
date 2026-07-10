---
type: "Import"
title: "World Types/Prefab"
description: "Imported world types/prefab types (11 types)."
resource: "codeware/scripts/"
tags: "[imports, prefab]"
timestamp: 2026-07-01T18:09:34Z
---

# Overview

Imported world types/prefab types (11 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldPrefab | class | resStreamedResource | mainGroup, type, teamOwnership, streamingOcclusion, streamingImportance |
| worldPrefabMetadata | class | IScriptable | — |
| worldPrefabMinimapContribution | enum | — | Auto, Include, Discard |
| worldPrefabNode | class | worldNode | prefab, instanceData, enabledVariants, canBeToggledInGame, noCollisions |
| worldPrefabOwnership | enum | — | None, Quest, Audio, Environment, FX |
| worldPrefabProxyMeshNode | class | worldMeshNode | nearAutoHideDistance, nbNodesUnderProxy |
| worldPrefabProxyMeshOnly | enum | — | SettingFromResource, Enabled, Disabled |
| worldPrefabStreamingImportance | enum | — | Auto, P1, P2, P3, P4 |
| worldPrefabStreamingOcclusion | enum | — | Default, Exterior, Interior, OpenInterior |
| worldPrefabType | enum | — | Regular, Area, Generated, Decoration, Quest |
| worldPrefabVariantsList | class | ISerializable | activeVariants |

# Citations

- `codeware/scripts/Base/Imports/worldPrefab.reds`
- `codeware/scripts/Base/Imports/worldPrefabMetadata.reds`
- `codeware/scripts/Base/Imports/worldPrefabMinimapContribution.reds`
- `codeware/scripts/Base/Imports/worldPrefabNode.reds`
- `codeware/scripts/Base/Imports/worldPrefabOwnership.reds`
- `codeware/scripts/Base/Imports/worldPrefabProxyMeshNode.reds`
- `codeware/scripts/Base/Imports/worldPrefabProxyMeshOnly.reds`
- `codeware/scripts/Base/Imports/worldPrefabStreamingImportance.reds`
- `codeware/scripts/Base/Imports/worldPrefabStreamingOcclusion.reds`
- `codeware/scripts/Base/Imports/worldPrefabType.reds`
- ... and 1 more source files
