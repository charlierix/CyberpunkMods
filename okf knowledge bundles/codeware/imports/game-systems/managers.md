---
type: "Import"
title: "Game-Systems Managers"
description: "Imported game-systems managers types (7 types)."
resource: "codeware/scripts/"
tags: "[imports, managers]"
timestamp: 2026-07-01T18:09:13Z
---

# Overview

Imported game-systems managers types (7 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameAreaManager | class | gameIAreaManager | — |
| gameIAreaManager | class | IGameSystem | — |
| gameItemDropStorageManager | struct | — | — |
| gameJournalManagerSharedState | class | gameIGameSystemReplicatedState | entryData, trackedQuestPath |
| gamePlayerManager | class | gameIPlayerManager | — |
| gameRenderGameplayEffectsManagerSaveData | class | ISerializable | cyberspacePixelsortParams, cyberspacePixelsortEnabled, enforceScreenSpaceReflectionsUberQuality |
| gamemappinsQuestMappinManagerReplicatedState | struct | — | dynamicQuestMappinRepInfo |

# Citations

- `codeware/scripts/Base/Imports/gameAreaManager.reds`
- `codeware/scripts/Base/Imports/gameIAreaManager.reds`
- `codeware/scripts/Base/Imports/gameItemDropStorageManager.reds`
- `codeware/scripts/Base/Imports/gameJournalManagerSharedState.reds`
- `codeware/scripts/Base/Imports/gamePlayerManager.reds`
- `codeware/scripts/Base/Imports/gameRenderGameplayEffectsManagerSaveData.reds`
- `codeware/scripts/Base/Imports/gamemappinsQuestMappinManagerReplicatedState.reds`
