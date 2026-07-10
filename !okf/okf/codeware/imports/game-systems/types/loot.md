---
type: "Import"
title: "Game-Systems Types/Loot"
description: "Imported game-systems types/loot types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, loot]"
timestamp: 2026-07-01T18:09:10Z
---

# Overview

Imported game-systems types/loot types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameLootPrefabMetadata | class | worldPrefabMetadata | lootTableTDBIDs, ignoreParentPrefabs, contentAssignment |
| gameLootSlot | class | gameLootContainerBase | immovableAfterDrop, dropChance, lootState |
| gameLootSlotSingleAppearance | class | gameLootSlotSingleItem | lootAppearance |
| gameLootSlotSingleItem | class | gameLootSlot | itemTDBID |
| gameLootSlotSingleItemLongStreaming | class | gameLootSlotSingleItem | — |
| gameLootSlotSingleQuery | class | gameLootSlot | queryTDBID |

# Citations

- `codeware/scripts/Base/Imports/gameLootPrefabMetadata.reds`
- `codeware/scripts/Base/Imports/gameLootSlot.reds`
- `codeware/scripts/Base/Imports/gameLootSlotSingleAppearance.reds`
- `codeware/scripts/Base/Imports/gameLootSlotSingleItem.reds`
- `codeware/scripts/Base/Imports/gameLootSlotSingleItemLongStreaming.reds`
- `codeware/scripts/Base/Imports/gameLootSlotSingleQuery.reds`
