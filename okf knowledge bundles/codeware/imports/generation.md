---
type: "Import"
title: "Generation Types"
description: "Imported game engine types in the generation domain (5 types)."
resource: "codeware/scripts/"
tags: "[imports, generation]"
timestamp: 2026-07-01T18:09:14Z
---

# Overview

Imported game engine types in the generation domain (5 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| genLevelRandomizer | class | GameObject | entries, seed, dataSource, supervisorType, debugSpawnAll |
| genLevelRandomizerDataSource | enum | — | Entries, Markers |
| genLevelRandomizerEntry | struct | — | id, spawnPos |
| genNullRandomizationSupervisor | class | IRandomizationSupervisor | — |
| genRandomizerMarker | class | worldIMarker | id, templateName, probability |

# Citations

- `codeware/scripts/Base/Imports/genLevelRandomizer.reds`
- `codeware/scripts/Base/Imports/genLevelRandomizerDataSource.reds`
- `codeware/scripts/Base/Imports/genLevelRandomizerEntry.reds`
- `codeware/scripts/Base/Imports/genNullRandomizationSupervisor.reds`
- `codeware/scripts/Base/Imports/genRandomizerMarker.reds`
