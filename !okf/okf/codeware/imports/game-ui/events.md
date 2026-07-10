---
type: "Import"
title: "Game-Ui Events"
description: "Imported game-ui events types (14 types)."
resource: "codeware/scripts/"
tags: "[imports, events]"
timestamp: 2026-07-01T18:09:14Z
---

# Overview

Imported game-ui events types (14 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameuiCharacterReplicaInitializedEvent | class | Event | — |
| gameuiHUDVideoStartEvent | struct | — | videoPathHash, fullScreen, keepWidescreenAspectRatio, size, isLooped |
| gameuiHUDVideoStopEvent | struct | — | videoPathHash |
| gameuiScreenAreaMultiplierChangeEvent | class | Event | screenAreaMultiplier |
| gameuiSpawnNewFeedEvent | class | Event | — |
| gameuiTextureMaxMipBiasChangeEvent | class | Event | textureMaxMipBias |
| gameuiTextureMinMipBiasChangeEvent | class | Event | textureMinMipBias |
| gameuiTutorialAreaDespawnEvent | class | Event | bracketID, areaID |
| gameuiTutorialAreaSpawnEvent | class | Event | bracketID, areaID, widget |
| gameuiTutorialBracketHideEvent | class | Event | bracketID |
| gameuiTutorialBracketShowEvent | class | Event | data |
| gameuiTutorialOverlayHideEvent | class | Event | itemName |
| gameuiTutorialOverlayShowEvent | class | Event | itemName |
| gameuiWorldMapUpdateGroupsEvent | class | Event | — |

# Citations

- `codeware/scripts/Base/Imports/gameuiCharacterReplicaInitializedEvent.reds`
- `codeware/scripts/Base/Imports/gameuiHUDVideoStartEvent.reds`
- `codeware/scripts/Base/Imports/gameuiHUDVideoStopEvent.reds`
- `codeware/scripts/Base/Imports/gameuiScreenAreaMultiplierChangeEvent.reds`
- `codeware/scripts/Base/Imports/gameuiSpawnNewFeedEvent.reds`
- `codeware/scripts/Base/Imports/gameuiTextureMaxMipBiasChangeEvent.reds`
- `codeware/scripts/Base/Imports/gameuiTextureMinMipBiasChangeEvent.reds`
- `codeware/scripts/Base/Imports/gameuiTutorialAreaDespawnEvent.reds`
- `codeware/scripts/Base/Imports/gameuiTutorialAreaSpawnEvent.reds`
- `codeware/scripts/Base/Imports/gameuiTutorialBracketHideEvent.reds`
- ... and 4 more source files
