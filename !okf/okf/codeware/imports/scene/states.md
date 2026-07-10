---
type: "Import"
title: "Scene States"
description: "Imported scene states types (3 types)."
resource: "codeware/scripts/"
tags: "[imports, states]"
timestamp: 2026-07-01T18:09:32Z
---

# Overview

Imported scene states types (3 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| scnChatterModuleSharedState | class | ISerializable | chatterHistory |
| scnPuppetVehicleState | enum | — | IdleMounted, IdleStand, CombatWindowed, CombatSeated, Turret |
| scnSceneSharedState | class | ISerializable | entrypoint, syncNodesVisited, instanceHash, finishedOnServer, finishedOnClient |

# Citations

- `codeware/scripts/Base/Imports/scnChatterModuleSharedState.reds`
- `codeware/scripts/Base/Imports/scnPuppetVehicleState.reds`
- `codeware/scripts/Base/Imports/scnSceneSharedState.reds`
