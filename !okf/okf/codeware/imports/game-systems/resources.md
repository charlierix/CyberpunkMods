---
type: "Import"
title: "Game-Systems Resources"
description: "Imported game-systems resources types (16 types)."
resource: "codeware/scripts/"
tags: "[imports, resources]"
timestamp: 2026-07-01T18:09:13Z
---

# Overview

Imported game-systems resources types (16 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameAreaResource | class | CResource | cookedData |
| gameDeviceResource | class | CResource | data |
| gameDeviceResourceData | class | ISerializable | version |
| gameJournalBaseResource | class | CResource | — |
| gameJournalDescriptorResource | class | gameJournalBaseResource | entriesActivatedAtStart |
| gameJournalResource | class | gameJournalBaseResource | entry |
| gameLocationResource | class | CResource | — |
| gameLootResource | class | CResource | data |
| gameLootResourceData | class | ISerializable | version |
| gameMappinResource | class | CResource | cookedData, cookedMultiData, cookedGpsData |
| gamePersistentStateDataResource | class | CResource | — |
| gamePointOfInterestMappinResource | class | CResource | cookedData |
| gamePrereqsResource | class | CResource | prereqs |
| gameSmartObjectResource | class | CResource | entryPoints, exitPoints, bodyTypes, loopAnimations, type |
| gameSmartObjectsCompiledResource | class | resStreamedResource | animationDatabase, compiledNodesData, transformDictionary, propertyDictionary, transformSequenceDictionary |
| gamegraphCGraphResource | class | CResource | — |

# Citations

- `codeware/scripts/Base/Imports/gameAreaResource.reds`
- `codeware/scripts/Base/Imports/gameDeviceResource.reds`
- `codeware/scripts/Base/Imports/gameDeviceResourceData.reds`
- `codeware/scripts/Base/Imports/gameJournalBaseResource.reds`
- `codeware/scripts/Base/Imports/gameJournalDescriptorResource.reds`
- `codeware/scripts/Base/Imports/gameJournalResource.reds`
- `codeware/scripts/Base/Imports/gameLocationResource.reds`
- `codeware/scripts/Base/Imports/gameLootResource.reds`
- `codeware/scripts/Base/Imports/gameLootResourceData.reds`
- `codeware/scripts/Base/Imports/gameMappinResource.reds`
- ... and 6 more source files
