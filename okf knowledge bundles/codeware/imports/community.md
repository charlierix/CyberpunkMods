---
type: "Import"
title: "Community Types"
description: "Imported game engine types in the community domain (22 types)."
resource: "codeware/scripts/"
tags: "[imports, community]"
timestamp: 2026-07-01T18:09:07Z
---

# Overview

Imported game engine types in the community domain (22 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| communityArea | class | ISerializable | entriesData |
| communityCommunityEntryPhaseSpotsData | struct | — | timePeriodsData |
| communityCommunityEntryPhaseTimePeriodData | struct | — | periodName, isSequence |
| communityCommunityEntrySpotsData | struct | — | phasesData |
| communityCommunitySpawnSetTemplate | class | communityCommunityTemplate | — |
| communityCommunityTemplate | class | CResource | communityTemplate |
| communityCommunityTemplateData | class | ISerializable | entries, crowdEntries, spawnSetReference |
| communityECommunitySpawnTime | enum | — | Morning, Day, Evening, Night, Midnight |
| communityESquadType | enum | — | Global, Community, Security, Unknown |
| communityPatrolInitializer | class | communitySpawnInitializer | patrolRole |
| communityRole | class | ISerializable | roleName |
| communitySpawnEntry | class | ISerializable | entryName, characterRecordId, phases, spawnInView, initializers |
| communitySpawnInitializer | class | ISerializable | — |
| communitySpawnPhase | class | ISerializable | phaseName, appearances, timePeriods, alwaysSpawned, prefetchAppearance |
| communitySquadInitializer | class | communitySpawnInitializer | entries |
| communitySquadInitializerEntry | struct | — | type |
| communityTimePeriod | struct | — | hour |
| communityVoiceTagInitializer | class | communitySpawnInitializer | voiceTagName |
| populationModifier | class | ISerializable | — |
| populationPopulationSpawnParameter | class | gameObjectSpawnParameter | — |
| populationSpawnModifier | class | populationModifier | spawnParameter |
| populationSpawnerObjectCtrlAction | enum | — | Undefined, Activate, Deactivate, Reactivate, ResetKillCount |

# Citations

- `codeware/scripts/Base/Imports/communityArea.reds`
- `codeware/scripts/Base/Imports/communityCommunityEntryPhaseSpotsData.reds`
- `codeware/scripts/Base/Imports/communityCommunityEntryPhaseTimePeriodData.reds`
- `codeware/scripts/Base/Imports/communityCommunityEntrySpotsData.reds`
- `codeware/scripts/Base/Imports/communityCommunitySpawnSetTemplate.reds`
- `codeware/scripts/Base/Imports/communityCommunityTemplate.reds`
- `codeware/scripts/Base/Imports/communityCommunityTemplateData.reds`
- `codeware/scripts/Base/Imports/communityECommunitySpawnTime.reds`
- `codeware/scripts/Base/Imports/communityESquadType.reds`
- `codeware/scripts/Base/Imports/communityPatrolInitializer.reds`
- ... and 12 more source files
