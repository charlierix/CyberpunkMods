---
type: "Import"
title: "Game-Systems Entries"
description: "Imported game-systems entries types (17 types)."
resource: "codeware/scripts/"
tags: "[imports, entries]"
timestamp: 2026-07-01T18:09:13Z
---

# Overview

Imported game-systems entries types (17 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameCommunitySpawnSetNameToIDEntry | struct | — | communityId |
| gameCommunityTrafficConnectionsEntry | struct | — | — |
| gameCrowdEntryType | enum | — | Pedestrian, Vehicle, AV |
| gameCrowdTemplateEntry | struct | — | entryName, phases |
| gameCrowdTemplateEntryPhase | struct | — | phaseName, density, legacy, legacyCharactersData |
| gameEffectExecutor_KatanaBulletBendingEffectEntry | struct | — | tag, attach |
| gameEntityToAppearancesAndColorVariantsMapEntry | class | ISerializable | entityPathHash, debugEntityPath, appearancesAndTheirColorVariants |
| gameFuncCallEntry | class | ISerializable | callTime, callId |
| gameJournalEntryUserState | enum | — | Undefined, Inactive, Active, Succeeded, Failed |
| gameJournalFolderEntry | class | JournalContainerEntry | — |
| gameJournalPrimaryFolderEntry | class | gameJournalFolderEntry | — |
| gameJournalRootFolderEntry | class | gameJournalFolderEntry | descriptor |
| gamePingEntry | struct | — | owner, time, hitObject |
| gameSmartObjectInstanceEntryType | enum | — | UseEntryAnimation, UseLocomotion |
| gameSmartObjectPropertyDictionaryPropertyEntry | struct | — | id, animationName, type, movementOrientation, isReachable |
| gameSmartObjectTransformDictionaryTransformEntry | struct | — | transform, id |
| gameSmartObjectTransformSequenceDictionaryEntry | struct | — | sequence |

# Citations

- `codeware/scripts/Base/Imports/gameCommunitySpawnSetNameToIDEntry.reds`
- `codeware/scripts/Base/Imports/gameCommunityTrafficConnectionsEntry.reds`
- `codeware/scripts/Base/Imports/gameCrowdEntryType.reds`
- `codeware/scripts/Base/Imports/gameCrowdTemplateEntry.reds`
- `codeware/scripts/Base/Imports/gameCrowdTemplateEntryPhase.reds`
- `codeware/scripts/Base/Imports/gameEffectExecutor_KatanaBulletBendingEffectEntry.reds`
- `codeware/scripts/Base/Imports/gameEntityToAppearancesAndColorVariantsMapEntry.reds`
- `codeware/scripts/Base/Imports/gameFuncCallEntry.reds`
- `codeware/scripts/Base/Imports/gameJournalEntryUserState.reds`
- `codeware/scripts/Base/Imports/gameJournalFolderEntry.reds`
- ... and 7 more source files
