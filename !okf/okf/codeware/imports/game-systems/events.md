---
type: "Import"
title: "Game-Systems Events"
description: "Imported game-systems events types (32 types)."
resource: "codeware/scripts/"
tags: "[imports, events]"
timestamp: 2026-07-01T18:09:13Z
---

# Overview

Imported game-systems events types (32 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gameBinkVideoEvent | class | Event | videoPath, action |
| gameCooldownFinishedEvent | class | gameCooldownSystemEvent | — |
| gameCooldownRemovedEvent | class | gameCooldownSystemEvent | — |
| gameCooldownSystemEvent | class | Event | — |
| gameCrowdEntityReuseEvent | class | Event | — |
| gameDeprecated_GameplayEvent | class | Event | — |
| gameEffectAction_MissEvent | class | EffectAction | npcMissEvents |
| gameEffectObjectFilter_NoInstigator_MissEvent | class | gameEffectObjectGroupFilter | npcMissEvents |
| gameEffectObjectProvider_ProjectileHitEvent | class | EffectObjectProvider | — |
| gameEnableScanningStatePropagationToParentEvent | class | Event | isEnabled |
| gameFootstepEvent | class | Event | — |
| gameForceVisionModuleQuestEvent | unknown | — | — |
| gamePrepareTPPRepresentationEvent | class | Event | — |
| gameRemoveCooldownEvent | class | gameCooldownSystemEvent | — |
| gameScanningInternalEvent | class | Event | — |
| gameSetDestinationActionEvent | class | ActionEvent | position |
| gameSetupControlledByStoryEvent | class | AIEvent | — |
| gameSpawnOccupantsEvent | class | Event | — |
| gameTPPCustomizableAppearanceChangeFinishedEvent | class | Event | — |
| gameTimeDilationEvent | class | Event | — |
| gameVehicleMeleeCleaveEvent | class | Event | attackData, hitPosition, hitDirection, hitComponent |
| gameVisionAppearanceForcedEvent | class | Event | state |
| gameVisionModeActivationEvent | unknown | — | — |
| gameeventsDeviceRegisterCameraControlOnPuppetEvent | class | Event | component, register |
| gameeventsMuppetUseLoadoutEvent | class | Event | adout |
| gameeventsReloadLootEvent | class | Event | — |
| gameeventsSquadStartedCombatEvent | class | Event | started |
| gameeventsStealthMappinCheckLootEvent | class | Event | — |
| gameeventsToggleMinimapVisibilityEvent | class | Event | show |
| gameeventsToggleStealthMappinVisibilityEvent | class | Event | show |
| gameeventsUserEnteredCoverEvent | class | Event | actionsPoints |
| gameeventsUserLeftCoverEvent | class | Event | — |

# Citations

- `codeware/scripts/Base/Imports/gameBinkVideoEvent.reds`
- `codeware/scripts/Base/Imports/gameCooldownFinishedEvent.reds`
- `codeware/scripts/Base/Imports/gameCooldownRemovedEvent.reds`
- `codeware/scripts/Base/Imports/gameCooldownSystemEvent.reds`
- `codeware/scripts/Base/Imports/gameCrowdEntityReuseEvent.reds`
- `codeware/scripts/Base/Imports/gameDeprecated_GameplayEvent.reds`
- `codeware/scripts/Base/Imports/gameEffectAction_MissEvent.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectFilter_NoInstigator_MissEvent.reds`
- `codeware/scripts/Base/Imports/gameEffectObjectProvider_ProjectileHitEvent.reds`
- `codeware/scripts/Base/Imports/gameEnableScanningStatePropagationToParentEvent.reds`
- ... and 22 more source files
