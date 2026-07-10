---
type: "Import"
title: "World States"
description: "Imported world states types (2 types)."
resource: "codeware/scripts/"
tags: "[imports, states]"
timestamp: 2026-07-01T18:09:37Z
---

# Overview

Imported world states types (2 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| worldWeatherState | class | ISerializable | minDuration, maxDuration, environmentAreaParameters, effect, name |
| worldWeatherStateTransition | class | ISerializable | probability, transitionDuration, sourceWeatherState, targetWeatherState |

# Citations

- `codeware/scripts/Base/Imports/worldWeatherState.reds`
- `codeware/scripts/Base/Imports/worldWeatherStateTransition.reds`
