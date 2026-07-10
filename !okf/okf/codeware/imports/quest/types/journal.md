---
type: "Import"
title: "Quest Types/Journal"
description: "Imported quest types/journal types (10 types)."
resource: "codeware/scripts/"
tags: "[imports, journal]"
timestamp: 2026-07-01T18:09:23Z
---

# Overview

Imported quest types/journal types (10 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| questJournalBulkUpdate_NodeType | class | questIJournal_NodeType | path, requiredEntryType, requiredEntryState, newEntryState, sendNotification |
| questJournalChangeMappinPhase_NodeType | class | questIJournal_NodeType | path, phase, notifyUI |
| questJournalCondition | class | questTypedCondition | type |
| questJournalContact_NodeType | class | questIJournal_NodeType | path |
| questJournalNotification_ConditionType | class | questIUIConditionType | journalPath |
| questJournalPushPopQuestObjective_NodeType | class | questIJournal_NodeType | path, restore |
| questJournalQuestObjectiveCounter_NodeType | class | questIJournal_NodeType | path |
| questJournalQuestSetObjectiveOptional_NodeType | class | questIJournal_NodeType | path, optional |
| questJournalSetLockQuestObjective_NodeType | class | questIJournal_NodeType | path, lock |
| questJournalTrackQuest_NodeType | class | questIJournal_NodeType | path |

# Citations

- `codeware/scripts/Base/Imports/questJournalBulkUpdate_NodeType.reds`
- `codeware/scripts/Base/Imports/questJournalChangeMappinPhase_NodeType.reds`
- `codeware/scripts/Base/Imports/questJournalCondition.reds`
- `codeware/scripts/Base/Imports/questJournalContact_NodeType.reds`
- `codeware/scripts/Base/Imports/questJournalNotification_ConditionType.reds`
- `codeware/scripts/Base/Imports/questJournalPushPopQuestObjective_NodeType.reds`
- `codeware/scripts/Base/Imports/questJournalQuestObjectiveCounter_NodeType.reds`
- `codeware/scripts/Base/Imports/questJournalQuestSetObjectiveOptional_NodeType.reds`
- `codeware/scripts/Base/Imports/questJournalSetLockQuestObjective_NodeType.reds`
- `codeware/scripts/Base/Imports/questJournalTrackQuest_NodeType.reds`
