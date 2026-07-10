---
type: "Import"
title: "Scene Types/Interruption"
description: "Imported scene types/interruption types (3 types)."
resource: "codeware/scripts/"
tags: "[imports, interruption]"
timestamp: 2026-07-01T18:09:30Z
---

# Overview

Imported scene types/interruption types (3 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| scnInterruptionPhase | enum | — | WaitForInterruption, WaitForInterrupted, Interrupted, ClearTier, FadeOutLines |
| scnInterruptionScenario | struct | — | id, queueName, talkOnReturn, forcePlayReturnLine, playingLinesBehavior |
| scnInterruptionScenarioId | struct | — | id |

# Citations

- `codeware/scripts/Base/Imports/scnInterruptionPhase.reds`
- `codeware/scripts/Base/Imports/scnInterruptionScenario.reds`
- `codeware/scripts/Base/Imports/scnInterruptionScenarioId.reds`
