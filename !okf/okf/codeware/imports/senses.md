---
type: "Import"
title: "Senses Types"
description: "Imported game engine types in the senses domain (4 types)."
resource: "codeware/scripts/"
tags: "[imports, senses]"
timestamp: 2026-07-01T18:09:32Z
---

# Overview

Imported game engine types in the senses domain (4 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| SenseVisibilityPartsEvent | class | Event | target, isPrimaryVisible, isSecondaryVisible, description |
| SensorObject | class | ISerializable | presetID, detectionFactor, detectionDropFactor, detectionCoolDownTime, detectionPartCoolDownTime |
| senseShapes | struct | — | shapes |
| senseTracingFreq | enum | — | Never, Lowest, Low, Medium, High |

# Citations

- `codeware/scripts/Base/Imports/SenseVisibilityPartsEvent.reds`
- `codeware/scripts/Base/Imports/SensorObject.reds`
- `codeware/scripts/Base/Imports/senseShapes.reds`
- `codeware/scripts/Base/Imports/senseTracingFreq.reds`
