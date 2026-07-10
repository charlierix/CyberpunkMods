---
type: "Import"
title: "Ink Entries"
description: "Imported ink entries types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, entries]"
timestamp: 2026-07-01T18:09:16Z
---

# Overview

Imported ink entries types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| inkCreditsSectionEntry | struct | — | sectionTitle, displayMode |
| inkDebugLayerEntry | struct | — | widgetResource, anchorPlace |
| inkHudEntryInfo | class | inkUserData | size, offset |
| inkMenuEntry | struct | — | name, depth, isAffectedByFadeout |
| inkNavigationOverrideEntry | struct | — | from, to |
| inkVideoSequenceEntry | struct | — | videoResource, audioEvent, retriggerAudioOnLoop |

# Citations

- `codeware/scripts/Base/Imports/inkCreditsSectionEntry.reds`
- `codeware/scripts/Base/Imports/inkDebugLayerEntry.reds`
- `codeware/scripts/Base/Imports/inkHudEntryInfo.reds`
- `codeware/scripts/Base/Imports/inkMenuEntry.reds`
- `codeware/scripts/Base/Imports/inkNavigationOverrideEntry.reds`
- `codeware/scripts/Base/Imports/inkVideoSequenceEntry.reds`
