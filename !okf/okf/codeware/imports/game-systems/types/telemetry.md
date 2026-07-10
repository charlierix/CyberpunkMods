---
type: "Import"
title: "Game-Systems Types/Telemetry"
description: "Imported game-systems types/telemetry types (4 types)."
resource: "codeware/scripts/"
tags: "[imports, telemetry]"
timestamp: 2026-07-01T18:09:10Z
---

# Overview

Imported game-systems types/telemetry types (4 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameTelemetryMilestoneType | enum | — | StartFact, ImportantFact, Reward, EndFact, EndReward |
| gameTelemetryPostMortem | struct | — | crashVisitId, crashVersion, timeCrash, zoneType, location |
| gameTelemetryPostMortemContainer | class | ISerializable | postMortem |
| gameTelemetryTrackedQuest | struct | — | name, type, questName |

# Citations

- `codeware/scripts/Base/Imports/gameTelemetryMilestoneType.reds`
- `codeware/scripts/Base/Imports/gameTelemetryPostMortem.reds`
- `codeware/scripts/Base/Imports/gameTelemetryPostMortemContainer.reds`
- `codeware/scripts/Base/Imports/gameTelemetryTrackedQuest.reds`
