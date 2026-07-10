---
type: "Import"
title: "Threats Types"
description: "Imported game engine types in the threats domain (6 types)."
resource: "codeware/scripts/"
tags: "[imports, threats]"
timestamp: 2026-07-01T18:09:32Z
---

# Overview

Imported game engine types in the threats domain (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AddedAsHostileThreat | class | AIEvent | threateningEntity, threateningEntityCanTriggersCombat |
| AttitudePrereq | class | IPrereq | attitude |
| AttitudePrereqState | class | PrereqState | — |
| RemovedAsHostileThreat | class | AIEvent | threateningEntity, threateningEntityCanTriggersCombat |
| ThreatPositionProvider | class | IPositionProvider | — |
| ThreatValid | class | AIEvent | owner, threat, isEnemy, isHostile |

# Citations

- `codeware/scripts/Base/Imports/AddedAsHostileThreat.reds`
- `codeware/scripts/Base/Imports/AttitudePrereq.reds`
- `codeware/scripts/Base/Imports/AttitudePrereqState.reds`
- `codeware/scripts/Base/Imports/RemovedAsHostileThreat.reds`
- `codeware/scripts/Base/Imports/ThreatPositionProvider.reds`
- `codeware/scripts/Base/Imports/ThreatValid.reds`
