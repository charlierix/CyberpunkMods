---
type: "Import"
title: "Network Types"
description: "Imported game engine types in the network domain (18 types)."
resource: "codeware/scripts/"
tags: "[imports, network]"
timestamp: 2026-07-01T18:09:21Z
---

# Overview

Imported game engine types in the network domain (18 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| ServerBlackboardUpdateProxy | class | BlackboardUpdateProxy | — |
| grsDeathmatchPlayerGameInfo | struct | — | peerID, isDead, killCount, lastShooter |
| grsDeathmatchState | struct | — | time, sessionLength |
| grsDeathmatchStatus | enum | — | Waiting, AdditionalWaiting, Starting, InGame, Ending |
| grsGatherAreaManager | struct | — | activeGatherAreaRepInfo |
| grsGatherAreaReplicatedInfo | struct | — | enteredPlayerIDs, enabled |
| grsHeistPlayerGameInfo | struct | — | peerID, isReady, isDead, killCount, characterRecord |
| grsHeistState | struct | — | time, playersInfo |
| mpCMultiplayerDebugFunctions | struct | — | — |
| mpInteractionActivatorComponent | class | IPlacedComponent | — |
| mpPersistentTestBox | class | GameObject | — |
| netEntityAttachmentInterface | struct | — | time |
| netEntitySystem | class | worldIRuntimeSystem | — |
| netIComponentState | unknown | — | — |
| netIEntityState | unknown | — | — |
| netIIngameProfilerSystem | class | IGameSystem | — |
| netPeerID | struct | — | value |
| netTime | struct | — | milliSecs |

# Citations

- `codeware/scripts/Base/Imports/ServerBlackboardUpdateProxy.reds`
- `codeware/scripts/Base/Imports/grsDeathmatchPlayerGameInfo.reds`
- `codeware/scripts/Base/Imports/grsDeathmatchState.reds`
- `codeware/scripts/Base/Imports/grsDeathmatchStatus.reds`
- `codeware/scripts/Base/Imports/grsGatherAreaManager.reds`
- `codeware/scripts/Base/Imports/grsGatherAreaReplicatedInfo.reds`
- `codeware/scripts/Base/Imports/grsHeistPlayerGameInfo.reds`
- `codeware/scripts/Base/Imports/grsHeistState.reds`
- `codeware/scripts/Base/Imports/mpCMultiplayerDebugFunctions.reds`
- `codeware/scripts/Base/Imports/mpInteractionActivatorComponent.reds`
- ... and 8 more source files
