---
type: "Device System"
title: "Master Devices"
description: "Master devices: access point, access point controller, actions sequencer, actions sequencer controller, activator, activator controller, computer, computer controller, electric box, electric box controller, fuse, fuse box, fuse box controller, fuse controller, network area, network area controller, security alarm, security alarm controller, smart house, smart house controller, smart house presets, smart window, smart window controller, sound system, sound system controller, switch, switch controller, terminal, terminal controller, and security system."
resource: "!cyberpunk/devices/masters/accessPoint.swift"
tags: ['cyberpunk', 'devices', 'masters']
timestamp: 2026-07-01T13:00:55Z
---

# Master Devices

Master devices: access point, access point controller, actions sequencer, actions sequencer controller, activator, activator controller, computer, computer controller, electric box, electric box controller, fuse, fuse box, fuse box controller, fuse controller, network area, network area controller, security alarm, security alarm controller, smart house, smart house controller, smart house presets, smart window, smart window controller, sound system, sound system controller, switch, switch controller, terminal, terminal controller, and security system.

## Source Files

- `cyberpunk/devices/masters/accessPoint.swift`
- `cyberpunk/devices/masters/accessPointController.swift`
- `cyberpunk/devices/masters/actionsSequencer.swift`
- `cyberpunk/devices/masters/actionsSequencerController.swift`
- `cyberpunk/devices/masters/activator.swift`
- `cyberpunk/devices/masters/activatorController.swift`
- `cyberpunk/devices/masters/computer.swift`
- `cyberpunk/devices/masters/computerController.swift`
- `cyberpunk/devices/masters/electricBox.swift`
- `cyberpunk/devices/masters/electricBoxController.swift`
- `cyberpunk/devices/masters/fuse.swift`
- `cyberpunk/devices/masters/fuseBox.swift`
- `cyberpunk/devices/masters/fuseBoxController.swift`
- `cyberpunk/devices/masters/fuseController.swift`
- `cyberpunk/devices/masters/networkArea.swift`
- `cyberpunk/devices/masters/networkAreaController.swift`
- `cyberpunk/devices/masters/securityAlarm/securityAlarm.swift`
- `cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift`
- `cyberpunk/devices/masters/smartHouse/SmartHouse.swift`
- `cyberpunk/devices/masters/smartHouse/SmartHouseController.swift`
- `cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift`
- `cyberpunk/devices/masters/smartWindows/smartWindow.swift`
- `cyberpunk/devices/masters/smartWindows/smartWindowController.swift`
- `cyberpunk/devices/masters/soundSystem/soundSystem.swift`
- `cyberpunk/devices/masters/soundSystem/soundSystemController.swift`
- `cyberpunk/devices/masters/switch.swift`
- `cyberpunk/devices/masters/switchController.swift`
- `cyberpunk/devices/masters/systems/deviceSystemBase.swift`
- `cyberpunk/devices/masters/systems/deviceSystemBaseController.swift`
- `cyberpunk/devices/masters/systems/securitySystem/agentRegistry.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securityAgent.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securityArea.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securitySystem.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securitySystemController.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift`
- `cyberpunk/devices/masters/terminal.swift`
- `cyberpunk/devices/masters/terminalController.swift`

## Member Types

**Total declarations: 232**

### Classs (108)

| Name | Bases | Source File |
|------|-------|-------------|
| BreachViewTimeListener | TimeDilationListener | cyberpunk/devices/masters/accessPoint.swift |
| AccessPoint | InteractiveMasterDevice | cyberpunk/devices/masters/accessPoint.swift |
| QuestResetPerfomedActionsStorage | ActionBool | cyberpunk/devices/masters/accessPointController.swift |
| QuestRemoveQuickHacks | ActionBool | cyberpunk/devices/masters/accessPointController.swift |
| QuestRestoreQuickHacks | ActionBool | cyberpunk/devices/masters/accessPointController.swift |
| QuestBreachAccessPoint | ActionBool | cyberpunk/devices/masters/accessPointController.swift |
| SpiderbotEnableAccessPoint | ActionBool | cyberpunk/devices/masters/accessPointController.swift |
| RevealEnemiesProgram | ProgramAction | cyberpunk/devices/masters/accessPointController.swift |
| ResetNetworkBreachState | ActionBool | cyberpunk/devices/masters/accessPointController.swift |
| ToggleNetrunnerDive | ActionBool | cyberpunk/devices/masters/accessPointController.swift |
| AccessPointController | MasterController | cyberpunk/devices/masters/accessPointController.swift |
| AccessPointControllerPS | MasterControllerPS | cyberpunk/devices/masters/accessPointController.swift |
| ActionsSequencer | InteractiveMasterDevice | cyberpunk/devices/masters/actionsSequencer.swift |
| ActionsSequencerController | ScriptableDeviceComponent | cyberpunk/devices/masters/actionsSequencerController.swift |
| ActionsSequencerControllerPS | MasterControllerPS | cyberpunk/devices/masters/actionsSequencerController.swift |
| Activator | InteractiveMasterDevice | cyberpunk/devices/masters/activator.swift |
| SpiderbotActivateActivator | ActionBool | cyberpunk/devices/masters/activatorController.swift |
| ActivatorController | MasterController | cyberpunk/devices/masters/activatorController.swift |
| ActivatorControllerPS | MasterControllerPS | cyberpunk/devices/masters/activatorController.swift |
| EnableDocumentEvent | Event | cyberpunk/devices/masters/computer.swift |
| OpenDocumentEvent | Event | cyberpunk/devices/masters/computer.swift |
| GoToMenuEvent | Event | cyberpunk/devices/masters/computer.swift |
| Computer | Terminal | cyberpunk/devices/masters/computer.swift |
| ToggleOpenComputer | ActionBool | cyberpunk/devices/masters/computerController.swift |
| ComputerController | TerminalController | cyberpunk/devices/masters/computerController.swift |
| ComputerControllerPS | TerminalControllerPS | cyberpunk/devices/masters/computerController.swift |
| ElectricBox | InteractiveMasterDevice | cyberpunk/devices/masters/electricBox.swift |
| ActionOverride | ActionBool | cyberpunk/devices/masters/electricBoxController.swift |
| ElectricBoxController | MasterController | cyberpunk/devices/masters/electricBoxController.swift |
| ElectricBoxControllerPS | MasterControllerPS | cyberpunk/devices/masters/electricBoxController.swift |
| Fuse | InteractiveMasterDevice | cyberpunk/devices/masters/fuse.swift |
| FuseBox | InteractiveMasterDevice | cyberpunk/devices/masters/fuseBox.swift |
| OverloadDevice | ActionBool | cyberpunk/devices/masters/fuseBoxController.swift |
| SendSpiderbotToOverloadDevice | ActionBool | cyberpunk/devices/masters/fuseBoxController.swift |
| SendSpiderbotToTogglePower | ActionBool | cyberpunk/devices/masters/fuseBoxController.swift |
| FuseBoxController | MasterController | cyberpunk/devices/masters/fuseBoxController.swift |
| FuseBoxControllerPS | MasterControllerPS | cyberpunk/devices/masters/fuseBoxController.swift |
| FuseController | MasterController | cyberpunk/devices/masters/fuseController.swift |
| FuseControllerPS | MasterControllerPS | cyberpunk/devices/masters/fuseController.swift |
| NetworkArea | InteractiveMasterDevice | cyberpunk/devices/masters/networkArea.swift |
| NetworkAreaController | MasterController | cyberpunk/devices/masters/networkAreaController.swift |
| NetworkAreaControllerPS | MasterControllerPS | cyberpunk/devices/masters/networkAreaController.swift |
| SecurityAlarm | InteractiveMasterDevice | cyberpunk/devices/masters/securityAlarm/securityAlarm.swift |
| SecurityAlarmController | MasterController | cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift |
| SecurityAlarmControllerPS | MasterControllerPS | cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift |
| ChangePresetEvent | Event | cyberpunk/devices/masters/smartHouse/SmartHouse.swift |
| EnableTimeCallbacks | Event | cyberpunk/devices/masters/smartHouse/SmartHouse.swift |
| DisableTimeCallbacks | Event | cyberpunk/devices/masters/smartHouse/SmartHouse.swift |
| SmartHouse | InteractiveMasterDevice | cyberpunk/devices/masters/smartHouse/SmartHouse.swift |
| SmartHouseController | MasterController | cyberpunk/devices/masters/smartHouse/SmartHouseController.swift |
| SmartHouseControllerPS | MasterControllerPS | cyberpunk/devices/masters/smartHouse/SmartHouseController.swift |
| SmartHousePreset | IScriptable | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| MorningPreset | SmartHousePreset | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| EveningPreset | SmartHousePreset | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| NightPreset | SmartHousePreset | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| SmartWindow | Computer | cyberpunk/devices/masters/smartWindows/smartWindow.swift |
| SmartWindowController | ComputerController | cyberpunk/devices/masters/smartWindows/smartWindowController.swift |
| SmartWindowControllerPS | ComputerControllerPS | cyberpunk/devices/masters/smartWindows/smartWindowController.swift |
| SoundSystem | InteractiveMasterDevice | cyberpunk/devices/masters/soundSystem/soundSystem.swift |
| SoundSystemController | MasterController | cyberpunk/devices/masters/soundSystem/soundSystemController.swift |
| SoundSystemControllerPS | MasterControllerPS | cyberpunk/devices/masters/soundSystem/soundSystemController.swift |
| MusicSettings | IScriptable | cyberpunk/devices/masters/soundSystem/soundSystemController.swift |
| PlayRadio | MusicSettings | cyberpunk/devices/masters/soundSystem/soundSystemController.swift |
| PlaySoundEvent | MusicSettings | cyberpunk/devices/masters/soundSystem/soundSystemController.swift |
| SimpleSwitch | InteractiveMasterDevice | cyberpunk/devices/masters/switch.swift |
| SimpleSwitchController | MasterController | cyberpunk/devices/masters/switchController.swift |
| SimpleSwitchControllerPS | MasterControllerPS | cyberpunk/devices/masters/switchController.swift |
| DeviceSystemBase | InteractiveMasterDevice | cyberpunk/devices/masters/systems/deviceSystemBase.swift |
| GetAccess | ActionBool | cyberpunk/devices/masters/systems/deviceSystemBaseController.swift |
| DeviceSystemBaseController | MasterController | cyberpunk/devices/masters/systems/deviceSystemBaseController.swift |
| DeviceSystemBaseControllerPS | MasterControllerPS | cyberpunk/devices/masters/systems/deviceSystemBaseController.swift |
| SecurityAgentSpawnedEvent | Event | cyberpunk/devices/masters/systems/securitySystem/agentRegistry.swift |
| AgentRegistry | IScriptable | cyberpunk/devices/masters/systems/securitySystem/agentRegistry.swift |
| SecurityArea | InteractiveMasterDevice | cyberpunk/devices/masters/systems/securitySystem/securityArea.swift |
| SecurityAreaEvent | ActionBool | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| SecurityAreaCrossingPerimeter | SecurityAreaEvent | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| SecurityAreaController | MasterController | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| SecurityAreaControllerPS | MasterControllerPS | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| SecuritySystem | DeviceSystemBase | cyberpunk/devices/masters/systems/securitySystem/securitySystem.swift |
| SecuritySystemController | DeviceSystemBaseController | cyberpunk/devices/masters/systems/securitySystem/securitySystemController.swift |
| SecuritySystemControllerPS | DeviceSystemBaseControllerPS | cyberpunk/devices/masters/systems/securitySystem/securitySystemController.swift |
| SecSystemDebugger | ScriptableSystem | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| PlayerSpotted | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| SetSecuritySystemState | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| SuppressSecuritySystemStateChange | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| AuthorizePlayerInSecuritySystem | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| BlacklistPlayer | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| SuppressNPCInSecuritySystem | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| QuestChangeSecuritySystemAttitudeGroup | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| QuestIllegalActionNotification | QuestSecuritySystemInput | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| QuestCombatActionNotification | QuestSecuritySystemInput | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| QuestAddTransition | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| QuestRemoveTransition | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| QuestExecuteTransition | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| QuestCombatActionAreaNotification | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| QuestIllegalActionAreaNotification | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| ReprimandUpdate | Event | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| TakeOverSecuritySystem | ActionBool | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| FullSystemRestart | ActionBool | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| SecuritySystemStatus | BaseDeviceStatus | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| SecuritySystemInput | SecurityAreaEvent | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| SecuritySystemOutput | ActionBool | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| BlacklistEntry | IScriptable | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| Terminal | InteractiveMasterDevice | cyberpunk/devices/masters/terminal.swift |
| QuestForceFakeElevatorArrows | ActionBool | cyberpunk/devices/masters/terminalController.swift |
| QuestResetFakeElevatorArrows | ActionBool | cyberpunk/devices/masters/terminalController.swift |
| TerminalController | MasterController | cyberpunk/devices/masters/terminalController.swift |
| TerminalControllerPS | MasterControllerPS | cyberpunk/devices/masters/terminalController.swift |

### Structs (8)

| Name | Bases | Source File |
|------|-------|-------------|
| Agent |  | cyberpunk/devices/masters/systems/securitySystem/securityAgent.swift |
| OutputPersistentData |  | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| NPCReference |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| SpawnerData |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| SecurityAccessLevelEntry |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| SecurityAccessLevelEntryClient |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OutputValidationDataStruct |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| NPCDebugInfo |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |

### Static Funcs (13)

| Name | Bases | Source File |
|------|-------|-------------|
| OperatorGreater |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorLogicOr |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorGreater |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorLess |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorSubtract |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorGreater |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorLess |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorGreater |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorLess |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorGreaterEqual |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorLessEqual |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorGreater |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| OperatorLess |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |

### Funcs (103)

| Name | Bases | Source File |
|------|-------|-------------|
| GetTweakDBChoiceRecord |  | cyberpunk/devices/masters/accessPointController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/masters/accessPointController.swift |
| GetQuestActionByName |  | cyberpunk/devices/masters/accessPointController.swift |
| FinalizeNetrunnerDive |  | cyberpunk/devices/masters/accessPointController.swift |
| OnSetExposeQuickHacks |  | cyberpunk/devices/masters/accessPointController.swift |
| OnQuestRemoveQuickHacks |  | cyberpunk/devices/masters/accessPointController.swift |
| OnQuestBreachAccessPoint |  | cyberpunk/devices/masters/accessPointController.swift |
| RevealDevicesGrid |  | cyberpunk/devices/masters/accessPointController.swift |
| GetQuestActions |  | cyberpunk/devices/masters/actionsSequencerController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/masters/accessPointController.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| GetQuestActionByName |  | cyberpunk/devices/masters/accessPointController.swift |
| GetQuestActions |  | cyberpunk/devices/masters/actionsSequencerController.swift |
| OnActionDemolition |  | cyberpunk/devices/masters/activatorController.swift |
| OnActionEngineering |  | cyberpunk/devices/masters/activatorController.swift |
| OnDisassembleDevice |  | cyberpunk/devices/masters/activatorController.swift |
| OnToggleActivation |  | cyberpunk/devices/masters/activatorController.swift |
| OnQuestForceActivate |  | cyberpunk/devices/masters/activatorController.swift |
| ResavePersistentData |  | cyberpunk/devices/masters/computer.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/masters/accessPointController.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/masters/computerController.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| GetQuestActionByName |  | cyberpunk/devices/masters/accessPointController.swift |
| GetQuestActions |  | cyberpunk/devices/masters/actionsSequencerController.swift |
| ActionToggleOpen |  | cyberpunk/devices/masters/computerController.swift |
| OnRequestDocumentWidgetUpdate |  | cyberpunk/devices/masters/computerController.swift |
| OnRequestDocumentThumbnailWidgetsUpdate |  | cyberpunk/devices/masters/computerController.swift |
| OnRequestMenuWidgetsUpdate |  | cyberpunk/devices/masters/computerController.swift |
| RequestFileWidgetUpdate |  | cyberpunk/devices/masters/computerController.swift |
| RequestMailWidgetUpdate |  | cyberpunk/devices/masters/computerController.swift |
| RequestMailThumbnailWidgetsUpdate |  | cyberpunk/devices/masters/computerController.swift |
| RequestFileThumbnailWidgetsUpdate |  | cyberpunk/devices/masters/computerController.swift |
| RequestMenuButtonWidgetsUpdate |  | cyberpunk/devices/masters/computerController.swift |
| RequestMainMenuButtonWidgetsUpdate |  | cyberpunk/devices/masters/computerController.swift |
| OnAuthorizeUser |  | cyberpunk/devices/masters/computerController.swift |
| TurnAuthorizationModuleOFF |  | cyberpunk/devices/masters/computerController.swift |
| OnToggleZoomInteraction |  | cyberpunk/devices/masters/computerController.swift |
| OnQuestForceCameraZoom |  | cyberpunk/devices/masters/computerController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/masters/accessPointController.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/masters/accessPointController.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/masters/accessPointController.swift |
| GetWidgetTypeName |  | cyberpunk/devices/masters/fuseBoxController.swift |
| OnToggleON |  | cyberpunk/devices/masters/fuseBoxController.swift |
| ActionToggleON |  | cyberpunk/devices/masters/fuseBoxController.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| ActionToggleON |  | cyberpunk/devices/masters/fuseBoxController.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| OnToggleON |  | cyberpunk/devices/masters/fuseBoxController.swift |
| UnpowerDevice |  | cyberpunk/devices/masters/fuseController.swift |
| GetQuestActions |  | cyberpunk/devices/masters/actionsSequencerController.swift |
| OnTargetAssessmentRequest |  | cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift |
| OnSecuritySystemOutput |  | cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift |
| OnSecurityAlarmBreachResponse |  | cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift |
| OnQuestForceSecuritySystemSafe |  | cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift |
| OnQuestForceSecuritySystemArmed |  | cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| OnOpenInteriorManager |  | cyberpunk/devices/masters/smartHouse/SmartHouseController.swift |
| OnPresetAction |  | cyberpunk/devices/masters/smartHouse/SmartHouseController.swift |
| GetDeviceWidget |  | cyberpunk/devices/masters/smartHouse/SmartHouseController.swift |
| GetPresetName |  | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| GetIconName |  | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| ExecutePresetActions |  | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| GetPresetName |  | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| GetIconName |  | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| GetPresetName |  | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| GetPresetName |  | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| GetIconName |  | cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| GetQuickHackActionsExternal |  | cyberpunk/devices/masters/soundSystem/soundSystemController.swift |
| OnToggleON |  | cyberpunk/devices/masters/fuseBoxController.swift |
| GetSoundName |  | cyberpunk/devices/masters/soundSystem/soundSystemController.swift |
| GetSoundName |  | cyberpunk/devices/masters/soundSystem/soundSystemController.swift |
| GetSoundName |  | cyberpunk/devices/masters/soundSystem/soundSystemController.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| ActionToggleON |  | cyberpunk/devices/masters/fuseBoxController.swift |
| OnToggleON |  | cyberpunk/devices/masters/fuseBoxController.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| OnSecuritySystemOutput |  | cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift |
| OnSecuritySystemForceAttitudeChange |  | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| OnTargetAssessmentRequest |  | cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift |
| OnFullSystemRestart |  | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| OnMaraudersMapDeviceDebug |  | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| OnMaraudersMapDeviceDebug |  | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| OnSecurityAreaCrossingPerimeter |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemController.swift |
| OnAddUserEvent |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemController.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| OnFullSystemRestart |  | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| OnActionForceResetDevice |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemController.swift |
| OnMaraudersMapDeviceDebug |  | cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift |
| SetProperties |  | cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/masters/accessPointController.swift |
| GetSlaveDeviceWidget |  | cyberpunk/devices/masters/terminalController.swift |
| GetDeviceWidgets |  | cyberpunk/devices/masters/terminalController.swift |
| GetThumbnailWidgets |  | cyberpunk/devices/masters/terminalController.swift |
| OnRequestDeviceWidgetUpdate |  | cyberpunk/devices/masters/terminalController.swift |
| ActionToggleON |  | cyberpunk/devices/masters/fuseBoxController.swift |
| GetActions |  | cyberpunk/devices/masters/activatorController.swift |
| GetQuestActions |  | cyberpunk/devices/masters/actionsSequencerController.swift |
| OnActionEngineering |  | cyberpunk/devices/masters/activatorController.swift |
| OnAuthorizeUser |  | cyberpunk/devices/masters/computerController.swift |
| TurnAuthorizationModuleOFF |  | cyberpunk/devices/masters/computerController.swift |
| OnDisassembleDevice |  | cyberpunk/devices/masters/activatorController.swift |

## Citations

- `cyberpunk/devices/masters/accessPoint.swift`
- `cyberpunk/devices/masters/accessPointController.swift`
- `cyberpunk/devices/masters/actionsSequencer.swift`
- `cyberpunk/devices/masters/actionsSequencerController.swift`
- `cyberpunk/devices/masters/activator.swift`
- `cyberpunk/devices/masters/activatorController.swift`
- `cyberpunk/devices/masters/computer.swift`
- `cyberpunk/devices/masters/computerController.swift`
- `cyberpunk/devices/masters/electricBox.swift`
- `cyberpunk/devices/masters/electricBoxController.swift`
- `cyberpunk/devices/masters/fuse.swift`
- `cyberpunk/devices/masters/fuseBox.swift`
- `cyberpunk/devices/masters/fuseBoxController.swift`
- `cyberpunk/devices/masters/fuseController.swift`
- `cyberpunk/devices/masters/networkArea.swift`
- `cyberpunk/devices/masters/networkAreaController.swift`
- `cyberpunk/devices/masters/securityAlarm/securityAlarm.swift`
- `cyberpunk/devices/masters/securityAlarm/securityAlarmController.swift`
- `cyberpunk/devices/masters/smartHouse/SmartHouse.swift`
- `cyberpunk/devices/masters/smartHouse/SmartHouseController.swift`
- `cyberpunk/devices/masters/smartHouse/SmartHousePresets.swift`
- `cyberpunk/devices/masters/smartWindows/smartWindow.swift`
- `cyberpunk/devices/masters/smartWindows/smartWindowController.swift`
- `cyberpunk/devices/masters/soundSystem/soundSystem.swift`
- `cyberpunk/devices/masters/soundSystem/soundSystemController.swift`
- `cyberpunk/devices/masters/switch.swift`
- `cyberpunk/devices/masters/switchController.swift`
- `cyberpunk/devices/masters/systems/deviceSystemBase.swift`
- `cyberpunk/devices/masters/systems/deviceSystemBaseController.swift`
- `cyberpunk/devices/masters/systems/securitySystem/agentRegistry.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securityAgent.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securityArea.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securityAreaController.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securitySystem.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securitySystemController.swift`
- `cyberpunk/devices/masters/systems/securitySystem/securitySystemMisc.swift`
- `cyberpunk/devices/masters/terminal.swift`
- `cyberpunk/devices/masters/terminalController.swift`
