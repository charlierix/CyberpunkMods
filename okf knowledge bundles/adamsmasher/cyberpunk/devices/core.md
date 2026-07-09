---
type: "Device System"
title: "Device Core Framework"
description: "Device core: action parameters holder, base device actions, device base, device component base, device operations (operations, container, triggers), device operations component, effectors, filters, interaction interpreters, interactive device, interactive master, master controller, peripherals (mappins, timetable, objective data, notifier), scriptable device PS, and sensor device/controller."
resource: "!cyberpunk/devices/core/actionParametersHolder.swift"
tags: ['cyberpunk', 'devices', 'core']
timestamp: 2026-07-01T13:00:55Z
---

# Device Core Framework

Device core: action parameters holder, base device actions, device base, device component base, device operations (operations, container, triggers), device operations component, effectors, filters, interaction interpreters, interactive device, interactive master, master controller, peripherals (mappins, timetable, objective data, notifier), scriptable device PS, and sensor device/controller.

## Source Files

- `cyberpunk/devices/core/actionParametersHolder.swift`
- `cyberpunk/devices/core/baseDeviceActions.swift`
- `cyberpunk/devices/core/deviceBase.swift`
- `cyberpunk/devices/core/deviceComponentBase.swift`
- `cyberpunk/devices/core/deviceOperations/deviceOperations.swift`
- `cyberpunk/devices/core/deviceOperations/deviceOperationsContainer.swift`
- `cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift`
- `cyberpunk/devices/core/deviceOperationsComponent.swift`
- `cyberpunk/devices/core/gameplayEffects/effectors.swift`
- `cyberpunk/devices/core/gameplayEffects/filters.swift`
- `cyberpunk/devices/core/interactionInterpreters.swift`
- `cyberpunk/devices/core/interactiveDevice.swift`
- `cyberpunk/devices/core/interactiveMaster.swift`
- `cyberpunk/devices/core/masterController.swift`
- `cyberpunk/devices/core/peripherals/deviceMappinsContainer.swift`
- `cyberpunk/devices/core/peripherals/deviceTimetable.swift`
- `cyberpunk/devices/core/peripherals/gameplayObjectiveData.swift`
- `cyberpunk/devices/core/peripherals/notifier.swift`
- `cyberpunk/devices/core/scriptableDeviceBasePS.swift`
- `cyberpunk/devices/core/sensorDevice.swift`
- `cyberpunk/devices/core/sensorDeviceController.swift`

## Member Types

**Total declarations: 524**

### Classs (208)

| Name | Bases | Source File |
|------|-------|-------------|
| DefaultActionsParametersHolder | IScriptable | cyberpunk/devices/core/actionParametersHolder.swift |
| BaseScriptableAction | DeviceAction | cyberpunk/devices/core/baseDeviceActions.swift |
| ScriptableDeviceAction | BaseScriptableAction | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionBool | ScriptableDeviceAction | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionInt | ScriptableDeviceAction | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionFloat | ScriptableDeviceAction | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionName | ScriptableDeviceAction | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionNodeRef | ScriptableDeviceAction | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionEntityReference | ScriptableDeviceAction | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionWorkSpot | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionSkillCheck | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| RemoteBreach | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| PingDevice | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionHacking | ActionSkillCheck | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionEngineering | ActionSkillCheck | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionDemolition | ActionSkillCheck | cyberpunk/devices/core/baseDeviceActions.swift |
| ActionScavenge | ActionInt | cyberpunk/devices/core/baseDeviceActions.swift |
| BaseDeviceStatus | ActionEnum | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceDestructible | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceIndestructible | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceInvulnerable | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceEnabled | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceDisabled | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForcePower | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceUnpower | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceON | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceOFF | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceAuthorizationEnabled | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceAuthorizationDisabled | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceDisconnectPersonalLink | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForcePersonalLinkUnderStrictQuestControl | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestEnableFixing | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestDisableFixing | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceJuryrigTrapArmed | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceJuryrigTrapDeactivated | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceSecuritySystemSafe | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceSecuritySystemAlarmed | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceSecuritySystemArmed | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestStartGlitch | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestStopGlitch | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestEnableInteraction | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestDisableInteraction | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SetDeviceON | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SetDeviceOFF | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SetDeviceUnpowered | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SetDevicePowered | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| DisassembleDevice | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| FixDevice | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ToggleJuryrigTrap | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ToggleActivation | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| TogglePower | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ToggleON | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuickHackToggleON | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ToggleBlockade | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuickHackToggleBlockade | ToggleBlockade | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceRoadBlockadeActivate | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceRoadBlockadeDeactivate | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceActivate | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceDeactivate | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestPickUpCall | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestHangUpCall | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ToggleActivate | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ActivateDevice | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| DeactivateDevice | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| AuthorizeUser | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| FactQuickHack | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuickHackAuthorization | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SetAuthorizationModuleON | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SetAuthorizationModuleOFF | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| InstallKeylogger | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SetExposeQuickHacks | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| TogglePersonalLink | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| OpenFullscreenUI | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SpiderbotDistraction | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SpiderbotBoolAction | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ToggleZoomInteraction | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SetDeviceAttitude | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ThumbnailUI | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestResetDeviceToInitialState | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceCameraZoom | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| PlayDeafeningMusic | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ChangeMusicAction | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| StartCall | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| Flush | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ToggleGlassTint | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceTintGlass | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestForceClearGlass | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| PresetAction | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ToggleAlarm | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SecurityAlarmBreachResponse | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| SecurityAlarmEscalate | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| MasterDeviceDestroyed | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| DelayEvent | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| Distraction | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| TogglePlay | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| OpenInteriorManager | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| EnterLadder | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ProgramSetDeviceOff | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ProgramSetDeviceAttitude | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| QuestResetPerformedActionsStorage | ActionBool | cyberpunk/devices/core/baseDeviceActions.swift |
| ForceUIRefreshEvent | Event | cyberpunk/devices/core/deviceBase.swift |
| ToggleUIInteractivity | Event | cyberpunk/devices/core/deviceBase.swift |
| DisableRPGRequirementsForDeviceActions | Event | cyberpunk/devices/core/deviceBase.swift |
| DeviceBase | GameObject | cyberpunk/devices/core/deviceBase.swift |
| Device | DeviceBase | cyberpunk/devices/core/deviceBase.swift |
| ScriptableDeviceComponent | DeviceComponent | cyberpunk/devices/core/deviceComponentBase.swift |
| SharedGameplayPS | DeviceComponentPS | cyberpunk/devices/core/deviceComponentBase.swift |
| DeviceComponentPS | GameComponentPS | cyberpunk/devices/core/deviceComponentBase.swift |
| DeviceOperationBase | IScriptable | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| GenericDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| SetMessageDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| RequestCLSStateChangeDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| ToggleComponentsDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| PlayTransformAnimationDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| FactsDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| PlayEffectDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| StimDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| PlaySoundDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| ApplyStatusEffectDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| ApplyDamageDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| ItemsDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| TeleportDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| MeshAppearanceDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| PlayerWokrspotDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| PlayBinkDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| ToggleCustomActionDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| ToggleOffMeshConnectionsDeviceOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| TeleportNodetoSlotOperation | DeviceOperationBase | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| DeviceOperationsContainer | IScriptable | cyberpunk/devices/core/deviceOperations/deviceOperationsContainer.swift |
| DeviceOperationsTrigger | IScriptable | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| FactOperationsTrigger | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| FocusModeOperationsTrigger | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| SensesOperationsTrigger | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| HitOperationsTrigger | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| InteractionAreaOperationsTrigger | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| TriggerVolumeOperationsTrigger | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| DeviceActionOperationsTrigger | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| CustomActionOperationsTriggers | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| DoorStateOperationsTrigger | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| BaseStateOperationsTrigger | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| ActivatorOperationsTrigger | DeviceOperationsTrigger | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| FocusModeOperations | DeviceOperations | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SensesOperations | DeviceOperations | cyberpunk/devices/core/deviceOperationsComponent.swift |
| HitOperations | DeviceOperations | cyberpunk/devices/core/deviceOperationsComponent.swift |
| InteractionAreaOperations | DeviceOperations | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TriggerVolumeOperations | DeviceOperations | cyberpunk/devices/core/deviceOperationsComponent.swift |
| BaseActionOperations | DeviceOperations | cyberpunk/devices/core/deviceOperationsComponent.swift |
| CustomActionOperations | DeviceOperations | cyberpunk/devices/core/deviceOperationsComponent.swift |
| DoorStateOperations | DeviceOperations | cyberpunk/devices/core/deviceOperationsComponent.swift |
| BaseStateOperations | DeviceOperations | cyberpunk/devices/core/deviceOperationsComponent.swift |
| DeviceOperations | IScriptable | cyberpunk/devices/core/deviceOperationsComponent.swift |
| RemotelyConnectToAccessPoint | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_PuppetForceVisionAppearance | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| ApplyJammer | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| ApplyJammerFromCw | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EMP | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EMPExplosion | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_PingNetwork | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_MuteBubble | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_Device | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_SetDeviceOFF | EffectExecutor_Device | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_SetDeviceON | EffectExecutor_Device | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_ToggleDevice | EffectExecutor_Device | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_GrenadeTargetTracker | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_TrackTargets | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_SendActionSignal | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| EffectExecutor_VisualEffectAtTarget | EffectExecutor_Scripted | cyberpunk/devices/core/gameplayEffects/effectors.swift |
| IsAccessPointFilter | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IsDeviceTargetValidFilter | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| OnlyNearest_AINavPath_Device | EffectObjectGroupFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IsSourceDeviceActveFilter | EffectObjectGroupFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| CanAIReactToStimTypeFilter | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IsDeviceFilter | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IsPlayerFilter | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IsCoverDevice | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IsNotWeakspotFilter | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IsNotInstigatorWeakspotFilter | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IsNotInstigatorProjectileFilter | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| EffectFilter_DamageOverTime | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| OnlySingleStatusEffectFromInstigator | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| NotInDefeated | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IgnoreFriendlyTargets | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IgnorePlayerMountedVehicle | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IgnorePlayerIfMountedToVehicle | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IgnoreAlreadyAffectedEntities | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| IsLootContainer | EffectObjectSingleFilter_Scripted | cyberpunk/devices/core/gameplayEffects/filters.swift |
| BasicInteractionInterpreter | IScriptable | cyberpunk/devices/core/interactionInterpreters.swift |
| InteractiveDevice | Device | cyberpunk/devices/core/interactiveDevice.swift |
| InteractiveMasterDevice | InteractiveDevice | cyberpunk/devices/core/interactiveMaster.swift |
| MasterController | ScriptableDeviceComponent | cyberpunk/devices/core/masterController.swift |
| MasterControllerPS | ScriptableDeviceComponentPS | cyberpunk/devices/core/masterController.swift |
| DeviceMappinsContainer | IScriptable | cyberpunk/devices/core/peripherals/deviceMappinsContainer.swift |
| DeviceTimeTableManager | IScriptable | cyberpunk/devices/core/peripherals/deviceTimetable.swift |
| DeviceTimetable | ScriptableComponent | cyberpunk/devices/core/peripherals/deviceTimetable.swift |
| GemplayObjectiveData | IScriptable | cyberpunk/devices/core/peripherals/gameplayObjectiveData.swift |
| ActionNotifier | IScriptable | cyberpunk/devices/core/peripherals/notifier.swift |
| SetCustomPersonalLinkReason | ScriptableDeviceAction | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ResolveAllSkillchecksEvent | Event | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| SetSkillcheckEvent | Event | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ChangeLoopCurveEvent | Event | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ScriptableDeviceComponentPS | SharedGameplayPS | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| QuestForceAttitude | ActionName | cyberpunk/devices/core/sensorDevice.swift |
| TargetedObjectDeathListener | CustomValueStatPoolsListener | cyberpunk/devices/core/sensorDevice.swift |
| SensorDevice | ExplosiveDevice | cyberpunk/devices/core/sensorDevice.swift |
| ForceIgnoreTargets | ActionBool | cyberpunk/devices/core/sensorDeviceController.swift |
| SetDeviceTagKillMode | ActionBool | cyberpunk/devices/core/sensorDeviceController.swift |
| SensorDeviceController | ExplosiveDeviceController | cyberpunk/devices/core/sensorDeviceController.swift |
| SensorDeviceControllerPS | ExplosiveDeviceControllerPS | cyberpunk/devices/core/sensorDeviceController.swift |

### Structs (2)

| Name | Bases | Source File |
|------|-------|-------------|
| AuthorizationData |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| SPerformedActions |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |

### Static Funcs (4)

| Name | Bases | Source File |
|------|-------|-------------|
| OperatorEqual |  | cyberpunk/devices/core/deviceBase.swift |
| OperatorEqual |  | cyberpunk/devices/core/deviceBase.swift |
| BasicAvailabilityTest |  | cyberpunk/devices/core/deviceComponentBase.swift |
| OperatorXor |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |

### Funcs (310)

| Name | Bases | Source File |
|------|-------|-------------|
| SetObjectActionID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| IsPossible |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CanInterrupt |  | cyberpunk/devices/core/baseDeviceActions.swift |
| IsVisible |  | cyberpunk/devices/core/baseDeviceActions.swift |
| IsVisible |  | cyberpunk/devices/core/baseDeviceActions.swift |
| ProcessRPGAction |  | cyberpunk/devices/core/baseDeviceActions.swift |
| StartAction |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CompleteAction |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetActivationTime |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetDurationTime |  | cyberpunk/devices/core/baseDeviceActions.swift |
| PayCost |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetCost |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetBaseCost |  | cyberpunk/devices/core/baseDeviceActions.swift |
| ResolveAction |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetLibraryPath |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetLibraryID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| SetInkWidgetTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| SetActiveStatusEffectTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetActiveStatusEffectTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| SetAttachedProgramTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetAttachedProgramTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| SetObjectActionID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CompleteAction |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetCost |  | cyberpunk/devices/core/baseDeviceActions.swift |
| SetInteractionIcon |  | cyberpunk/devices/core/baseDeviceActions.swift |
| HasUI |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CreateActionWidgetPackage |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CreateActionWidgetPackage |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CreateCustomInteraction |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetProperties |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CreateCustomInteraction |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CreateActionWidgetPackage |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetProperties |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetProperties |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetProperties |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetProperties |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetProperties |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetAttributeCheckType |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CompleteAction |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| SetProperties |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetBaseCost |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetActivationTime |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetBaseCost |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| ResolveAction |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetBaseCost |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CreateThumbnailWidgetPackage |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CreateThumbnailWidgetPackage |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetLibraryPath |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetLibraryID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| CreateActionWidgetPackage |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetInkWidgetTweakDBID |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| ApplyAnimFeatureToReplicate |  | cyberpunk/devices/core/deviceBase.swift |
| OnMaraudersMapDeviceDebug |  | cyberpunk/devices/core/deviceBase.swift |
| ResavePersistentData |  | cyberpunk/devices/core/deviceBase.swift |
| SetCurrentlyUploadingAction |  | cyberpunk/devices/core/deviceBase.swift |
| GetCurrentlyUploadingAction |  | cyberpunk/devices/core/deviceBase.swift |
| ControlledDeviceInputAction |  | cyberpunk/devices/core/deviceBase.swift |
| GetStimTarget |  | cyberpunk/devices/core/deviceBase.swift |
| GetDistractionControllerSource |  | cyberpunk/devices/core/deviceBase.swift |
| GetDistractionStimLifetime |  | cyberpunk/devices/core/deviceBase.swift |
| EvaluateDeviceState |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetActions |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetQuestActions |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetQuestActionByName |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetQuestActionByNameToNative |  | cyberpunk/devices/core/deviceComponentBase.swift |
| OnMaraudersMapDeviceDebug |  | cyberpunk/devices/core/deviceBase.swift |
| GetPersistentStateName |  | cyberpunk/devices/core/deviceComponentBase.swift |
| HackGetOwner |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetDeviceIconID |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetDeviceWidget |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetThumbnailWidget |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetThumbnailAction |  | cyberpunk/devices/core/deviceComponentBase.swift |
| DetermineInteractionState |  | cyberpunk/devices/core/deviceComponentBase.swift |
| ResloveUIOnAction |  | cyberpunk/devices/core/deviceComponentBase.swift |
| RefreshUI |  | cyberpunk/devices/core/deviceComponentBase.swift |
| RequestBreadCrumbUpdate |  | cyberpunk/devices/core/deviceComponentBase.swift |
| RequestActionWidgetsUpdate |  | cyberpunk/devices/core/deviceComponentBase.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Execute |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Restore |  | cyberpunk/devices/core/deviceOperations/deviceOperations.swift |
| Initialize |  | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| UnInitialize |  | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| SetDelayIdOnNamedOperation |  | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| ClearDelayIdOnNamedOperation |  | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| Initialize |  | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| UnInitialize |  | cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift |
| RequestComponents |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TakeControl |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ToggleOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SetDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ClearDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| RequestComponents |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TakeControl |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ToggleOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SetDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ClearDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| RequestComponents |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TakeControl |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ToggleOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SetDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ClearDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| RequestComponents |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TakeControl |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ToggleOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SetDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ClearDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| RequestComponents |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TakeControl |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ToggleOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SetDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ClearDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| RequestComponents |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TakeControl |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ToggleOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SetDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ClearDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| RequestComponents |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TakeControl |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ToggleOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SetDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ClearDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| RequestComponents |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TakeControl |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ToggleOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SetDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ClearDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| RequestComponents |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TakeControl |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ToggleOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SetDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ClearDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| RequestComponents |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| TakeControl |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ToggleOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| SetDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ClearDelayIdOnOperation |  | cyberpunk/devices/core/deviceOperationsComponent.swift |
| ShouldAlwaysUpdateDeviceWidgets |  | cyberpunk/devices/core/interactiveMaster.swift |
| GetWidgetTypeName |  | cyberpunk/devices/core/masterController.swift |
| OnRequestThumbnailWidgetsUpdate |  | cyberpunk/devices/core/masterController.swift |
| OnRequestDeviceWidgetUpdate |  | cyberpunk/devices/core/masterController.swift |
| GetThumbnailWidgets |  | cyberpunk/devices/core/masterController.swift |
| GetDeviceWidgets |  | cyberpunk/devices/core/masterController.swift |
| GetSlaveDeviceWidget |  | cyberpunk/devices/core/masterController.swift |
| RequestThumbnailWidgetsUpdate |  | cyberpunk/devices/core/masterController.swift |
| RequestDeviceWidgetsUpdate |  | cyberpunk/devices/core/masterController.swift |
| RequestDeviceWidgetsUpdate |  | cyberpunk/devices/core/masterController.swift |
| RevealDevicesGrid |  | cyberpunk/devices/core/masterController.swift |
| GetActions |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetQuickHackActionsExternal |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnAuthorizeUser |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnSetAuthorizationModuleON |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnSetAuthorizationModuleOFF |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnActionEngineering |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnActionDemolition |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuickHackDistraction |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuickHackAuthorization |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| RevealDevicesGrid |  | cyberpunk/devices/core/masterController.swift |
| GetWidgetTypeName |  | cyberpunk/devices/core/masterController.swift |
| GetDeviceIconPath |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| GetDeviceIconID |  | cyberpunk/devices/core/deviceComponentBase.swift |
| OnRequestActionWidgetsUpdate |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnRequestUIRefresh |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ResloveUIOnAction |  | cyberpunk/devices/core/deviceComponentBase.swift |
| OnThumbnailUI |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| RefreshUI |  | cyberpunk/devices/core/deviceComponentBase.swift |
| RequestBreadCrumbUpdate |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetDeviceWidget |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetThumbnailWidget |  | cyberpunk/devices/core/deviceComponentBase.swift |
| RequestActionWidgetsUpdate |  | cyberpunk/devices/core/deviceComponentBase.swift |
| RequestDeviceWidgetsUpdate |  | cyberpunk/devices/core/masterController.swift |
| DetermineInteractionState |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetQuestActionByName |  | cyberpunk/devices/core/deviceComponentBase.swift |
| GetQuestActions |  | cyberpunk/devices/core/deviceComponentBase.swift |
| OnToggleActivation |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnToggleActivate |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ActionActivateDevice |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ActionDeactivateDevice |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnTogglePower |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ActionToggleON |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnToggleON |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ActionSetDeviceON |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ActionSetDeviceOFF |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ActionSetDevicePowered |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ActionSetDeviceUnpowered |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| FinalizeNetrunnerDive |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnToggleZoomInteraction |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestForceCameraZoom |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnFixDevice |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnDisassembleDevice |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnSetExposeQuickHacks |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuickHackToggleOn |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestForceEnabled |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestEnableFixing |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestDisableFixing |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestRemoveQuickHacks |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestRestoreQuickHacks |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestResetPerfomedActionsStorage |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestBreachAccessPoint |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestResetDeviceToInitialState |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestForceSecuritySystemSafe |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestForceSecuritySystemAlarmed |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestForceSecuritySystemArmed |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestForceActivate |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnQuestForceDeactivate |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnSecuritySystemOutput |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnSecuritySystemForceAttitudeChange |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnSecurityAlarmBreachResponse |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnSecurityAreaCrossingPerimeter |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnTargetAssessmentRequest |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnActionForceResetDevice |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnFullSystemRestart |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ActionSetDeviceAttitude |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| UnpowerDevice |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| BreakDevice |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnAddUserEvent |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| TurnAuthorizationModuleOFF |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ExecuteCurrentSpiderbotActionPerformed |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnNotifyHighlightedDevice |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| SendDeviceNotOperationalEvent |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ActionProgramSetDeviceOff |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| ActionProgramSetDeviceAttitude |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnMaraudersMapDeviceDebug |  | cyberpunk/devices/core/deviceBase.swift |
| ApplyAnimFeatureToReplicate |  | cyberpunk/devices/core/deviceBase.swift |
| SetAsIntrestingTarget |  | cyberpunk/devices/core/sensorDevice.swift |
| OnValidTargetAppears |  | cyberpunk/devices/core/sensorDevice.swift |
| OnCurrentTargetAppears |  | cyberpunk/devices/core/sensorDevice.swift |
| OnValidTargetDisappears |  | cyberpunk/devices/core/sensorDevice.swift |
| OnAllValidTargetsDisappears |  | cyberpunk/devices/core/sensorDevice.swift |
| GetBaseCost |  | cyberpunk/devices/core/baseDeviceActions.swift |
| GetTweakDBChoiceRecord |  | cyberpunk/devices/core/baseDeviceActions.swift |
| OnSecuritySystemOutput |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnSecurityAreaCrossingPerimeter |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |
| OnTargetAssessmentRequest |  | cyberpunk/devices/core/scriptableDeviceBasePS.swift |

## Citations

- `cyberpunk/devices/core/actionParametersHolder.swift`
- `cyberpunk/devices/core/baseDeviceActions.swift`
- `cyberpunk/devices/core/deviceBase.swift`
- `cyberpunk/devices/core/deviceComponentBase.swift`
- `cyberpunk/devices/core/deviceOperations/deviceOperations.swift`
- `cyberpunk/devices/core/deviceOperations/deviceOperationsContainer.swift`
- `cyberpunk/devices/core/deviceOperations/deviceOperationsTriggers.swift`
- `cyberpunk/devices/core/deviceOperationsComponent.swift`
- `cyberpunk/devices/core/gameplayEffects/effectors.swift`
- `cyberpunk/devices/core/gameplayEffects/filters.swift`
- `cyberpunk/devices/core/interactionInterpreters.swift`
- `cyberpunk/devices/core/interactiveDevice.swift`
- `cyberpunk/devices/core/interactiveMaster.swift`
- `cyberpunk/devices/core/masterController.swift`
- `cyberpunk/devices/core/peripherals/deviceMappinsContainer.swift`
- `cyberpunk/devices/core/peripherals/deviceTimetable.swift`
- `cyberpunk/devices/core/peripherals/gameplayObjectiveData.swift`
- `cyberpunk/devices/core/peripherals/notifier.swift`
- `cyberpunk/devices/core/scriptableDeviceBasePS.swift`
- `cyberpunk/devices/core/sensorDevice.swift`
- `cyberpunk/devices/core/sensorDeviceController.swift`
