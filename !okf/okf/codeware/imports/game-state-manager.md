---
type: "Import"
title: "Game-State-Manager Types"
description: "Imported game engine types in the game-state-manager domain (34 types)."
resource: "codeware/scripts/"
tags: "[imports, game-state-manager]"
timestamp: 2026-07-01T18:09:09Z
---

# Overview

Imported game engine types in the game-state-manager domain (34 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| gsmBaseRequestsHandler | unknown | — | — |
| gsmGameDefinition | class | CResource | mainQuests, world, streamingWorld, worldName, spawnPointTags |
| gsmIStateObserver | unknown | — | — |
| gsmMainQuest | class | ISerializable | questFile, additionalContent, additionalContentName |
| gsmMenuState | class | gsmState | — |
| gsmMenuState_CreateSingleplayerSession | class | gsmMenuState | — |
| gsmMenuState_ErrorPopup | class | gsmPopupState | — |
| gsmMenuState_FindSessions | class | gsmMenuState | — |
| gsmMenuState_GatheringSaves | class | gsmPopupState | — |
| gsmMenuState_InGamePause | class | gsmMenuState | — |
| gsmMenuState_LoadGameDefinition | class | gsmMenuState | — |
| gsmMenuState_LoadSession | class | gsmMenuState | — |
| gsmMenuState_MainMenu | class | gsmMenuState | — |
| gsmMenuState_ModalPopup | class | gsmPopupState | — |
| gsmMenuState_Multiplayer | class | gsmMenuState | — |
| gsmMenuState_MultiplayerSelectCharacter | class | gsmMenuState | — |
| gsmMenuState_PlayRecordedSession | class | gsmMenuState | — |
| gsmMenuState_Singleplayer | class | gsmMenuState | — |
| gsmPopupState | class | gsmState | — |
| gsmState | class | IScriptable | — |
| gsmStateError | enum | — | StateError_OK, StateError_SettingsCorrupted, StateError_SettingsCorrupted_Save, StateError_ProfileCorrupted, StateError_ProfileCorrupted_Save |
| gsmState_AutoJoinServer | class | gsmMenuState | — |
| gsmState_BoothModeMainMenu | class | gsmMenuState | — |
| gsmState_Initialization | class | gsmState | — |
| gsmState_PreGameSession | class | gsmState_Session | — |
| gsmState_ReconnectController | class | gsmState | — |
| gsmState_Session | class | gsmState | — |
| gsmState_SessionActive | class | gsmState_SessionStreamingAware | — |
| gsmState_SessionLoading | class | gsmState | — |
| gsmState_SessionNewGame | class | gsmState | — |
| gsmState_SessionPaused | class | gsmState_SessionStreamingAware | — |
| gsmState_SessionRestoreFromSave | class | gsmState | — |
| gsmState_SessionStreamingAware | class | gsmState | — |
| gsmState_TrialVersionUpgrade | class | gsmState | — |

# Citations

- `codeware/scripts/Base/Imports/gsmBaseRequestsHandler.reds`
- `codeware/scripts/Base/Imports/gsmGameDefinition.reds`
- `codeware/scripts/Base/Imports/gsmIStateObserver.reds`
- `codeware/scripts/Base/Imports/gsmMainQuest.reds`
- `codeware/scripts/Base/Imports/gsmMenuState.reds`
- `codeware/scripts/Base/Imports/gsmMenuState_CreateSingleplayerSession.reds`
- `codeware/scripts/Base/Imports/gsmMenuState_ErrorPopup.reds`
- `codeware/scripts/Base/Imports/gsmMenuState_FindSessions.reds`
- `codeware/scripts/Base/Imports/gsmMenuState_GatheringSaves.reds`
- `codeware/scripts/Base/Imports/gsmMenuState_InGamePause.reds`
- ... and 24 more source files
