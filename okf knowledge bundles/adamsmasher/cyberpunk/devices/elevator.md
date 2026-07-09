---
type: "Device System"
title: "Elevator Devices"
description: "Elevator: floor terminal, floor terminal controller, lift, lift controller, and numeric display."
resource: "!cyberpunk/devices/elevator/elevatorFloorTerminal.swift"
tags: ['cyberpunk', 'devices', 'elevator']
timestamp: 2026-07-01T13:00:55Z
---

# Elevator Devices

Elevator: floor terminal, floor terminal controller, lift, lift controller, and numeric display.

## Source Files

- `cyberpunk/devices/elevator/elevatorFloorTerminal.swift`
- `cyberpunk/devices/elevator/elevatorFloorTerminalController.swift`
- `cyberpunk/devices/elevator/lift.swift`
- `cyberpunk/devices/elevator/liftController.swift`
- `cyberpunk/devices/elevator/numericDisplay/numericDisplay.swift`
- `cyberpunk/devices/elevator/numericDisplay/numericDisplayActions.swift`
- `cyberpunk/devices/elevator/numericDisplay/numericDisplayController.swift`

## Member Types

**Total declarations: 56**

### Classs (33)

| Name | Bases | Source File |
|------|-------|-------------|
| ElevatorFloorTerminal | Terminal | cyberpunk/devices/elevator/elevatorFloorTerminal.swift |
| QuickHackCallElevator | ActionBool | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| CallElevator | ActionBool | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| ElevatorFloorTerminalController | TerminalController | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| ElevatorFloorTerminalControllerPS | TerminalControllerPS | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| LiftDevice | InteractiveMasterDevice | cyberpunk/devices/elevator/lift.swift |
| LiftStatus | BaseDeviceStatus | cyberpunk/devices/elevator/liftController.swift |
| GoToFloor | ActionBool | cyberpunk/devices/elevator/liftController.swift |
| QuestGoToFloor | ActionInt | cyberpunk/devices/elevator/liftController.swift |
| QuestForceGoToFloor | ActionInt | cyberpunk/devices/elevator/liftController.swift |
| QuestForceTeleportToFloor | ActionInt | cyberpunk/devices/elevator/liftController.swift |
| QuestStopElevator | ActionBool | cyberpunk/devices/elevator/liftController.swift |
| QuestResumeElevator | ActionBool | cyberpunk/devices/elevator/liftController.swift |
| QuestShowFloor | ActionInt | cyberpunk/devices/elevator/liftController.swift |
| QuestHideFloor | ActionInt | cyberpunk/devices/elevator/liftController.swift |
| QuestSetFloorActive | ActionInt | cyberpunk/devices/elevator/liftController.swift |
| QuestSetFloorInactive | ActionInt | cyberpunk/devices/elevator/liftController.swift |
| QuestSetLiftSpeed | ActionFloat | cyberpunk/devices/elevator/liftController.swift |
| QuestSetLiftTravelTimeOverride | ActionFloat | cyberpunk/devices/elevator/liftController.swift |
| QuestEnableLiftTravelTimeOverride | ActionBool | cyberpunk/devices/elevator/liftController.swift |
| QuestDisableLiftTravelTimeOverride | ActionBool | cyberpunk/devices/elevator/liftController.swift |
| LiftController | MasterController | cyberpunk/devices/elevator/liftController.swift |
| LiftControllerPS | MasterControllerPS | cyberpunk/devices/elevator/liftController.swift |
| QuestSetRadioStation | ActionInt | cyberpunk/devices/elevator/liftController.swift |
| QuestDisableRadio | ActionBool | cyberpunk/devices/elevator/liftController.swift |
| QuestCloseAllDoors | ActionBool | cyberpunk/devices/elevator/liftController.swift |
| QuestToggleAds | ActionBool | cyberpunk/devices/elevator/liftController.swift |
| NumericDisplay | InteractiveDevice | cyberpunk/devices/elevator/numericDisplay/numericDisplay.swift |
| QuestIncreaseNumber | ActionBool | cyberpunk/devices/elevator/numericDisplay/numericDisplayActions.swift |
| QuestDecreaseNumber | ActionBool | cyberpunk/devices/elevator/numericDisplay/numericDisplayActions.swift |
| QuestIdle | ActionBool | cyberpunk/devices/elevator/numericDisplay/numericDisplayActions.swift |
| NumericDisplayController | ScriptableDeviceComponent | cyberpunk/devices/elevator/numericDisplay/numericDisplayController.swift |
| NumericDisplayControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/elevator/numericDisplay/numericDisplayController.swift |

### Structs (1)

| Name | Bases | Source File |
|------|-------|-------------|
| ElevatorFloorSetup |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |

### Funcs (22)

| Name | Bases | Source File |
|------|-------|-------------|
| OnMaraudersMapDeviceDebug |  | cyberpunk/devices/elevator/elevatorFloorTerminal.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| GetThumbnailWidgets |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| GetActions |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| OnQuickHackAuthorization |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| OnAuthorizeUser |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| GetDeviceWidgets |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| GetSlaveDeviceWidget |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| GetDeviceWidget |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| TurnAuthorizationModuleOFF |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| OnMaraudersMapDeviceDebug |  | cyberpunk/devices/elevator/elevatorFloorTerminal.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/elevator/liftController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| GetInkWidgetLibraryPath |  | cyberpunk/devices/elevator/liftController.swift |
| GetActions |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| GetQuestActionByName |  | cyberpunk/devices/elevator/liftController.swift |
| GetQuestActions |  | cyberpunk/devices/elevator/liftController.swift |
| OnQuickHackAuthorization |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| GetDeviceIconPath |  | cyberpunk/devices/elevator/liftController.swift |
| GetDeviceWidget |  | cyberpunk/devices/elevator/elevatorFloorTerminalController.swift |
| GetQuestActions |  | cyberpunk/devices/elevator/liftController.swift |

## Citations

- `cyberpunk/devices/elevator/elevatorFloorTerminal.swift`
- `cyberpunk/devices/elevator/elevatorFloorTerminalController.swift`
- `cyberpunk/devices/elevator/lift.swift`
- `cyberpunk/devices/elevator/liftController.swift`
- `cyberpunk/devices/elevator/numericDisplay/numericDisplay.swift`
- `cyberpunk/devices/elevator/numericDisplay/numericDisplayActions.swift`
- `cyberpunk/devices/elevator/numericDisplay/numericDisplayController.swift`
