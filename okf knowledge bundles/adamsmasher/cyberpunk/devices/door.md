---
type: "Device System"
title: "Door Devices"
description: "Door devices: bunker door, bunker door controller, door, door actions, door controller, fake door, and Judy door."
resource: "!cyberpunk/devices/door/bunkerDoor.swift"
tags: ['cyberpunk', 'devices', 'door']
timestamp: 2026-07-01T13:00:55Z
---

# Door Devices

Door devices: bunker door, bunker door controller, door, door actions, door controller, fake door, and Judy door.

## Source Files

- `cyberpunk/devices/door/bunkerDoor.swift`
- `cyberpunk/devices/door/bunkerDoorController.swift`
- `cyberpunk/devices/door/door.swift`
- `cyberpunk/devices/door/doorActions.swift`
- `cyberpunk/devices/door/doorController.swift`
- `cyberpunk/devices/door/fakeDoor.swift`
- `cyberpunk/devices/door/judysDoor.swift`

## Member Types

**Total declarations: 67**

### Classs (35)

| Name | Bases | Source File |
|------|-------|-------------|
| BunkerDoor | Door | cyberpunk/devices/door/bunkerDoor.swift |
| BunkerDoorController | DoorController | cyberpunk/devices/door/bunkerDoorController.swift |
| BunkerDoorControllerPS | DoorControllerPS | cyberpunk/devices/door/bunkerDoorController.swift |
| MalfunctionHalfOpen | ToggleOpen | cyberpunk/devices/door/bunkerDoorController.swift |
| SetDoorMalfunctioningType | Event | cyberpunk/devices/door/bunkerDoorController.swift |
| Door | InteractiveDevice | cyberpunk/devices/door/door.swift |
| Pay | ActionBool | cyberpunk/devices/door/doorActions.swift |
| QuickHackToggleOpen | ActionBool | cyberpunk/devices/door/doorActions.swift |
| DoorStatus | BaseDeviceStatus | cyberpunk/devices/door/doorActions.swift |
| DoorOpeningToken | ActionBool | cyberpunk/devices/door/doorActions.swift |
| ToggleOpen | ActionBool | cyberpunk/devices/door/doorActions.swift |
| SetOpened | ActionBool | cyberpunk/devices/door/doorActions.swift |
| SetClosed | ActionBool | cyberpunk/devices/door/doorActions.swift |
| ToggleLock | ActionBool | cyberpunk/devices/door/doorActions.swift |
| ToggleSeal | ActionBool | cyberpunk/devices/door/doorActions.swift |
| ForceOpen | ActionBool | cyberpunk/devices/door/doorActions.swift |
| ForceLockElevator | ToggleLock | cyberpunk/devices/door/doorActions.swift |
| ForceUnlockAndOpenElevator | ToggleLock | cyberpunk/devices/door/doorActions.swift |
| PlayerUnauthorized | ActionBool | cyberpunk/devices/door/doorActions.swift |
| QuestForceOpen | ActionBool | cyberpunk/devices/door/doorActions.swift |
| QuestForceClose | ActionFloat | cyberpunk/devices/door/doorActions.swift |
| QuestForceCloseImmediate | ActionBool | cyberpunk/devices/door/doorActions.swift |
| QuestForceOpenScene | ActionBool | cyberpunk/devices/door/doorActions.swift |
| QuestForceCloseScene | ActionBool | cyberpunk/devices/door/doorActions.swift |
| QuestForceLock | ActionBool | cyberpunk/devices/door/doorActions.swift |
| QuestForceUnlock | ActionBool | cyberpunk/devices/door/doorActions.swift |
| QuestForceSeal | ActionBool | cyberpunk/devices/door/doorActions.swift |
| QuestForceUnseal | ActionBool | cyberpunk/devices/door/doorActions.swift |
| DoorController | ScriptableDeviceComponent | cyberpunk/devices/door/doorController.swift |
| SetDoorType | Event | cyberpunk/devices/door/doorController.swift |
| SetCloseItself | Event | cyberpunk/devices/door/doorController.swift |
| ResetDoorState | Event | cyberpunk/devices/door/doorController.swift |
| DoorControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/door/doorController.swift |
| FakeDoor | GameObject | cyberpunk/devices/door/fakeDoor.swift |
| JudysDoor | InteractiveDevice | cyberpunk/devices/door/judysDoor.swift |

### Funcs (32)

| Name | Bases | Source File |
|------|-------|-------------|
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/door/bunkerDoorController.swift |
| OnMaraudersMapDeviceDebug |  | cyberpunk/devices/door/door.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| SetProperties |  | cyberpunk/devices/door/doorActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| SetProperties |  | cyberpunk/devices/door/doorActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/door/bunkerDoorController.swift |
| GetProperties |  | cyberpunk/devices/door/doorActions.swift |
| GetWidgetTypeName |  | cyberpunk/devices/door/doorController.swift |
| GetDeviceIconPath |  | cyberpunk/devices/door/doorController.swift |
| GetActions |  | cyberpunk/devices/door/doorController.swift |
| GetQuestActionByName |  | cyberpunk/devices/door/doorController.swift |
| GetQuestActions |  | cyberpunk/devices/door/doorController.swift |
| ActionToggleOpen |  | cyberpunk/devices/door/doorController.swift |
| OnSecuritySystemOutput |  | cyberpunk/devices/door/doorController.swift |
| OnActionEngineering |  | cyberpunk/devices/door/doorController.swift |
| OnActionForceResetDevice |  | cyberpunk/devices/door/doorController.swift |
| OnSetAuthorizationModuleOFF |  | cyberpunk/devices/door/doorController.swift |
| OnAuthorizeUser |  | cyberpunk/devices/door/doorController.swift |
| OnMaraudersMapDeviceDebug |  | cyberpunk/devices/door/door.swift |

## Citations

- `cyberpunk/devices/door/bunkerDoor.swift`
- `cyberpunk/devices/door/bunkerDoorController.swift`
- `cyberpunk/devices/door/door.swift`
- `cyberpunk/devices/door/doorActions.swift`
- `cyberpunk/devices/door/doorController.swift`
- `cyberpunk/devices/door/fakeDoor.swift`
- `cyberpunk/devices/door/judysDoor.swift`
