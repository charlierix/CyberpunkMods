---
type: "Import"
title: "Quest Entries"
description: "Imported quest entries types (15 types)."
resource: "codeware/scripts/"
tags: "[imports, entries]"
timestamp: 2026-07-01T18:09:28Z
---

# Overview

Imported quest entries types (15 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| JournalContactModifierEntry | class | JournalEntry | — |
| questActorOverrideEntry | struct | — | MetadataForOverride |
| questEntryScanned_ConditionType | class | questIObjectConditionType | objectRef, entryID |
| questHUDEntryAnimationFinished | struct | — | hudEntry, finished |
| questJournalEntryState_ConditionType | class | questIJournalConditionType | path, state, inverted |
| questJournalEntryVisited_ConditionType | class | questIJournalConditionType | path, visited |
| questJournalEntry_ConditionType | class | questIJournalConditionType | path, state |
| questJournalEntry_NodeType | class | questIJournal_NodeType | path, sendNotification |
| questJournalQuestEntry_NodeType | class | questIJournal_NodeType | path, sendNotification, trackQuest, optional, version |
| questJournalQuestEntry_NodeTypeNodeVersion | enum | — | Initial, OptionalProperty |
| questPlayHUDEntryAnimation_NodeType | class | questIUIManagerNodeType | hudEntryName, animationName, dependsOnTimeDilation |
| questQuestPrefabEntry | struct | — | prefabNodeRef |
| questQuestPrefabsEntry | struct | — | nodeRef |
| questSetHUDEntryForcedVisibility_NodeType | class | questIUIManagerNodeType | hudEntryName, usePreset, hudVisibilityPreset, visibility, skipAnimation |
| questSetHUDEntryVisibility_NodeType | class | questIUIManagerNodeType | hudEntryName, usePreset, hudVisibilityPreset, visibility |

# Citations

- `codeware/scripts/Base/Imports/JournalContactModifierEntry.reds`
- `codeware/scripts/Base/Imports/questActorOverrideEntry.reds`
- `codeware/scripts/Base/Imports/questEntryScanned_ConditionType.reds`
- `codeware/scripts/Base/Imports/questHUDEntryAnimationFinished.reds`
- `codeware/scripts/Base/Imports/questJournalEntryState_ConditionType.reds`
- `codeware/scripts/Base/Imports/questJournalEntryVisited_ConditionType.reds`
- `codeware/scripts/Base/Imports/questJournalEntry_ConditionType.reds`
- `codeware/scripts/Base/Imports/questJournalEntry_NodeType.reds`
- `codeware/scripts/Base/Imports/questJournalQuestEntry_NodeType.reds`
- `codeware/scripts/Base/Imports/questJournalQuestEntry_NodeTypeNodeVersion.reds`
- ... and 5 more source files
