---
type: "API"
title: "World Systems"
description: "World systems including entities, mappins, weather, open world activities, and workspots."
resource: "codeware/scripts/"
tags: "[world]"
timestamp: 2026-07-01T18:08:59Z
---

# Overview

World systems including entities, mappins, weather, open world activities, and workspots.

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| CommunityEntryWrapper | class | — | IsActive, GetName, GetPhases, GetRestoredEntityIDs, GetSpawnedEntityIDs |
| DynamicEntityEvent | class | — | GetEventType, GetEntityID, GetEntityTag |
| DynamicEntitySpec | class | — | recordID, templatePath, appearanceName, position, orientation |
| DynamicEntitySystem | class | IGameSystem | IsReady, IsRestored, CreateEntity, DeleteEntity, EnableEntity |
| MappinSystem | unknown | — | — |
| OpenWorldActivityRequest | struct | — | kind, cooldown, force |
| OpenWorldActivityResult | enum | — | OK, Invalid, NotFound, Undiscovered, Unfinished |
| OpenWorldActivityState | struct | — | name, timestamp, discovered |
| OpenWorldSystem | class | IGameSystem | IsReady, GetActivity, GetActivities, StartActivity, StartActivities |
| PopulationSpawnerWrapper | class | — | IsActive, IsInitialized, GetRecordID, GetAppearanceName, GetTransform |
| StaticEntitySpec | class | — | templatePath, appearanceName, position, orientation, attached |
| StaticEntitySystem | class | IGameSystem | IsReady, SpawnEntity, DespawnEntity, AttachEntity, DetachEntity |
| WeatherSystem | unknown | — | — |
| WorkspotSystem | unknown | — | — |
| WorldNodeSetupWrapper | class | — | GetNodeIndex, GetNode, GetTransform, GetPosition, GetOrientation |
| WorldStateSystem | class | IGameSystem | IsReady, GetStreamingWorld, GetCommunity, ActivateCommunity, DeactivateCommunity |
| workWorkspotInstance | class | ISerializable | tree, resource, animName, idleAnim, entryId |
| worldINodeInstance | class | ISerializable | GetNode, GetTransform, GetScale, GetGlobalNodeID, GetProxyNodeID |
| worldInstancedMeshNode | class | worldNode | mesh, meshAppearance, castShadows, castLocalShadows, occluderType |
| worldStreamingSector | class | CResource | GetNodes, GetNodeCount, GetNode, GetNodeSetupCount, GetNodeSetup, localInplaceResource, externInplaceResource, level (+1 more) |

# Citations

- `codeware/scripts/World/CommunityWrapper.reds`
- `codeware/scripts/World/DynamicEntityEvent.reds`
- `codeware/scripts/World/DynamicEntitySpec.reds`
- `codeware/scripts/World/DynamicEntitySystem.reds`
- `codeware/scripts/World/MappinSystem.reds`
- `codeware/scripts/World/OpenWorldActivityRequest.reds`
- `codeware/scripts/World/OpenWorldActivityResult.reds`
- `codeware/scripts/World/OpenWorldActivityState.reds`
- `codeware/scripts/World/OpenWorldSystem.reds`
- `codeware/scripts/World/PopulationSpawnerWrapper.reds`
- ... and 10 more source files
