---
type: "Device System"
title: "Media Devices"
description: "Media devices: holo feeder, holo table, jukebox, media device actions, media device controller, radio, radio station data, display glass, display glass controller, movable wall screen, scene screen, TV, TV controller, and wall screen."
resource: "!cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeeder.swift"
tags: ['cyberpunk', 'devices', 'home-appliances', 'media-devices']
timestamp: 2026-07-01T13:00:55Z
---

# Media Devices

Media devices: holo feeder, holo table, jukebox, media device actions, media device controller, radio, radio station data, display glass, display glass controller, movable wall screen, scene screen, TV, TV controller, and wall screen.

## Source Files

- `cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeeder.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeederController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTable.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTableController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/jukebox/jukebox.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/jukebox/jukeboxController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/radio/radio.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/radio/radioStationData.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/displayGlass.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/displayGlassController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/movableWallScreen.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/movableWallScreenController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/sceneScreen.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/tv.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/tvController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/wallScreen.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/wallScreenController.swift`

## Member Types

**Total declarations: 91**

### Classs (45)

| Name | Bases | Source File |
|------|-------|-------------|
| HoloFeeder | InteractiveDevice | cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeeder.swift |
| HoloFeederController | ScriptableDeviceComponent | cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeederController.swift |
| HoloFeederControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeederController.swift |
| HoloTable | InteractiveDevice | cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTable.swift |
| HoloTableController | MediaDeviceController | cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTableController.swift |
| HoloTableControllerPS | MediaDeviceControllerPS | cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTableController.swift |
| JukeboxController | ScriptableDeviceComponent | cyberpunk/devices/homeAppliances/mediaDevices/jukebox/jukebox.swift |
| Jukebox | InteractiveDevice | cyberpunk/devices/homeAppliances/mediaDevices/jukebox/jukebox.swift |
| JukeboxControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/homeAppliances/mediaDevices/jukebox/jukeboxController.swift |
| MediaDeviceStatus | BaseDeviceStatus | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| NextStation | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| QuestNextStation | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| PreviousStation | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| QuestPreviousStation | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| QuestDefaultStation | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| QuestToggleInteractivity | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| QuestMuteSounds | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| QuestSetChannel | ActionInt | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| QuickHackDistraction | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| QuickHackAoeDamage | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| QuickHackHighPitchNoise | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| GlitchScreen | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| MediaDeviceController | ScriptableDeviceComponent | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| MediaDeviceControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| Radio | InteractiveDevice | cyberpunk/devices/homeAppliances/mediaDevices/radio/radio.swift |
| RadioController | MediaDeviceController | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift |
| RadioControllerPS | MediaDeviceControllerPS | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift |
| RadioStationDataProvider | IScriptable | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioStationData.swift |
| DisplayGlass | InteractiveDevice | cyberpunk/devices/homeAppliances/mediaDevices/tvs/displayGlass.swift |
| DisplayGlassController | ScriptableDeviceComponent | cyberpunk/devices/homeAppliances/mediaDevices/tvs/displayGlassController.swift |
| DisplayGlassControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/homeAppliances/mediaDevices/tvs/displayGlassController.swift |
| MovableWallScreen | Door | cyberpunk/devices/homeAppliances/mediaDevices/tvs/movableWallScreen.swift |
| MovableWallScreenController | DoorController | cyberpunk/devices/homeAppliances/mediaDevices/tvs/movableWallScreenController.swift |
| MovableWallScreenControllerPS | DoorControllerPS | cyberpunk/devices/homeAppliances/mediaDevices/tvs/movableWallScreenController.swift |
| SceneScreen | GameObject | cyberpunk/devices/homeAppliances/mediaDevices/tvs/sceneScreen.swift |
| ChangeUIAnimEvent | Event | cyberpunk/devices/homeAppliances/mediaDevices/tvs/sceneScreen.swift |
| SetGlobalTvChannel | Event | cyberpunk/devices/homeAppliances/mediaDevices/tvs/tv.swift |
| SetGlobalTvOnly | Event | cyberpunk/devices/homeAppliances/mediaDevices/tvs/tv.swift |
| TV | InteractiveDevice | cyberpunk/devices/homeAppliances/mediaDevices/tvs/tv.swift |
| TVController | MediaDeviceController | cyberpunk/devices/homeAppliances/mediaDevices/tvs/tvController.swift |
| TVControllerPS | MediaDeviceControllerPS | cyberpunk/devices/homeAppliances/mediaDevices/tvs/tvController.swift |
| WallScreen | TV | cyberpunk/devices/homeAppliances/mediaDevices/tvs/wallScreen.swift |
| ToggleShow | ActionBool | cyberpunk/devices/homeAppliances/mediaDevices/tvs/wallScreenController.swift |
| WallScreenController | TVController | cyberpunk/devices/homeAppliances/mediaDevices/tvs/wallScreenController.swift |
| WallScreenControllerPS | TVControllerPS | cyberpunk/devices/homeAppliances/mediaDevices/tvs/wallScreenController.swift |

### Funcs (46)

| Name | Bases | Source File |
|------|-------|-------------|
| GetActions |  | cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeederController.swift |
| GetActions |  | cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeederController.swift |
| OnNextStation |  | cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTableController.swift |
| OnPreviousStation |  | cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTableController.swift |
| GetActions |  | cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeederController.swift |
| OnQuickHackDistraction |  | cyberpunk/devices/homeAppliances/mediaDevices/jukebox/jukeboxController.swift |
| SetProperties |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| GetAttachedProgramTweakDBID |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift |
| ActionNextStation |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| ActionPreviousStation |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| GetActions |  | cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeederController.swift |
| GetQuestActionByName |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| GetQuestActions |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| OnNextStation |  | cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTableController.swift |
| OnPreviousStation |  | cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTableController.swift |
| OnQuestEnableInteraction |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| OnQuestDisableInteraction |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| OnQuestNextStation |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| OnQuestPreviousStation |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| GetActiveStationIndex |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| OnNextStation |  | cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTableController.swift |
| OnPreviousStation |  | cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTableController.swift |
| OnQuestDefaultStation |  | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift |
| GetActiveStationIndex |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| OnQuickHackDistraction |  | cyberpunk/devices/homeAppliances/mediaDevices/jukebox/jukeboxController.swift |
| GetDeviceIconPath |  | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift |
| GetDeviceWidget |  | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift |
| GetActions |  | cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeederController.swift |
| GetQuestActionByName |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| GetQuestActions |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| GetDeviceIconPath |  | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift |
| ResavePersistentData |  | cyberpunk/devices/homeAppliances/mediaDevices/tvs/tv.swift |
| GetQuestActionByName |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| GetQuestActions |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| OnQuestDefaultStation |  | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift |
| GetActiveStationIndex |  | cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift |
| GetDeviceIconPath |  | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift |
| GetDeviceWidget |  | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift |
| OnQuestMuteSounds |  | cyberpunk/devices/homeAppliances/mediaDevices/tvs/tvController.swift |
| OnQuestToggleInteractivity |  | cyberpunk/devices/homeAppliances/mediaDevices/tvs/tvController.swift |
| GetActions |  | cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeederController.swift |
| GetDeviceIconPath |  | cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift |

## Citations

- `cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeeder.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/holoFeeder/holoFeederController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTable.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/holoTable/holoTableController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/jukebox/jukebox.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/jukebox/jukeboxController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceActions.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/mediaDeviceController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/radio/radio.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/radio/radioController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/radio/radioStationData.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/displayGlass.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/displayGlassController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/movableWallScreen.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/movableWallScreenController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/sceneScreen.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/tv.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/tvController.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/wallScreen.swift`
- `cyberpunk/devices/homeAppliances/mediaDevices/tvs/wallScreenController.swift`
