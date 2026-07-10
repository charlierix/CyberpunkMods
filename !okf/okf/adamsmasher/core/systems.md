---
type: "Game System"
title: "Core Game Systems"
description: "Core game systems: audio, autodrive, blackboard, city lights, cooldown, crafting, debug cheats, delamain taxi, destructible spots, drop points, dynamic spawn, fast travel, focus clues, focus mode tagging, FX, game instance, session data, gamepad light, gameplay quests, god mode, GOG rewards, HUD, journal, navigation, network, player, police radio, prevention, psycho squad, quest, reaction, restrict movement, save locks, scene, scriptable system, spatial queries, stat pools, stats, status effects, take over control, targeting, telemetry, transaction, UI, varDB, vehicle, vision, wardrobe, weather, and workspot."
resource: "!core/systems/DeviceConnectionsHighlightSystem.swift"
tags: ['core', 'systems']
timestamp: 2026-07-01T13:00:55Z
---

# Core Game Systems

Core game systems: audio, autodrive, blackboard, city lights, cooldown, crafting, debug cheats, delamain taxi, destructible spots, drop points, dynamic spawn, fast travel, focus clues, focus mode tagging, FX, game instance, session data, gamepad light, gameplay quests, god mode, GOG rewards, HUD, journal, navigation, network, player, police radio, prevention, psycho squad, quest, reaction, restrict movement, save locks, scene, scriptable system, spatial queries, stat pools, stats, status effects, take over control, targeting, telemetry, transaction, UI, varDB, vehicle, vision, wardrobe, weather, and workspot.

## Source Files

- `core/systems/DeviceConnectionsHighlightSystem.swift`
- `core/systems/animationSystemForcedVisibilityManager.swift`
- `core/systems/audioSystem.swift`
- `core/systems/autoDriveSystem.swift`
- `core/systems/blackboardSystem.swift`
- `core/systems/cityLightSystem.swift`
- `core/systems/cooldownManager.swift`
- `core/systems/craftingSystem.swift`
- `core/systems/debugCheatSystem.swift`
- `core/systems/delamainTaxiSystem.swift`
- `core/systems/destructibleSpotsSystem.swift`
- `core/systems/dropPointSystem.swift`
- `core/systems/dynamicSpawnSystem.swift`
- `core/systems/fastTravelSystem.swift`
- `core/systems/focusCluesSystem.swift`
- `core/systems/focusModeTagging.swift`
- `core/systems/fxSystem.swift`
- `core/systems/gameInstance.swift`
- `core/systems/gameSessionDataSystem.swift`
- `core/systems/gamepadLightController.swift`
- `core/systems/gameplayQuestSystem.swift`
- `core/systems/godModeSystem.swift`
- `core/systems/gogRewardsSystem.swift`
- `core/systems/hud/hudManager.swift`
- `core/systems/hud/hudManagerMisc.swift`
- `core/systems/hud/modules/baseModule.swift`
- `core/systems/hud/modules/braindanceModule.swift`
- `core/systems/hud/modules/highlightModule.swift`
- `core/systems/hud/modules/iconsModule.swift`
- `core/systems/hud/modules/quickhackModule.swift`
- `core/systems/hud/modules/scannerModule.swift`
- `core/systems/journalManager.swift`
- `core/systems/navigationSystem.swift`
- `core/systems/networkSystem.swift`
- `core/systems/playerSystem.swift`
- `core/systems/policeRadioSystem.swift`
- `core/systems/prevention/districtManager.swift`
- `core/systems/prevention/policeAgentsRegistry.swift`
- `core/systems/prevention/preventionAgents.swift`
- `core/systems/preventionSpawnSystem.swift`
- `core/systems/preventionSystem.swift`
- `core/systems/preventionSystemAIHelperClasses.swift`
- `core/systems/preventionSystemHackerLoop.swift`
- `core/systems/psychoSquadAVSystem.swift`
- `core/systems/questSystem.swift`
- `core/systems/reactionSystem.swift`
- `core/systems/restrictMovementAreaManager.swift`
- `core/systems/saveLocksManager.swift`
- `core/systems/sceneSystem.swift`
- `core/systems/scriptableSystem.swift`
- `core/systems/spatialQueriesSystem.swift`
- `core/systems/statPoolsSystem.swift`
- `core/systems/statsSystem.swift`
- `core/systems/statusEffectSystem.swift`
- `core/systems/takeOverControlSystem.swift`
- `core/systems/targetingSystem.swift`
- `core/systems/telemetry.swift`
- `core/systems/transactionSystem.swift`
- `core/systems/uiSystem.swift`
- `core/systems/varDBSystem.swift`
- `core/systems/vehicleSystem.swift`
- `core/systems/vision/visionBlockerTypes.swift`
- `core/systems/vision/visionBlockersRegistrar.swift`
- `core/systems/wardrobeSystem.swift`
- `core/systems/weatherSystem.swift`
- `core/systems/workspotSystem.swift`

## Member Types

**Total declarations: 256**

### Classs (191)

| Name | Bases | Source File |
|------|-------|-------------|
| DeviceConnectionsHighlightSystem | ScriptableSystem | core/systems/DeviceConnectionsHighlightSystem.swift |
| AnimationSystemForcedVisibilityEntityData | IScriptable | core/systems/animationSystemForcedVisibilityManager.swift |
| AnimationSystemForcedVisibilityManager | ScriptableSystem | core/systems/animationSystemForcedVisibilityManager.swift |
| AudioSystem | gameIGameAudioSystem | core/systems/audioSystem.swift |
| worldScriptedAudioSignpostTrigger | IScriptable | core/systems/audioSystem.swift |
| AutodriveHealthChangeListener | CustomValueStatPoolsListener | core/systems/autoDriveSystem.swift |
| AutodriveQuestContentLockListener | ScriptQuestContentLockListener | core/systems/autoDriveSystem.swift |
| AutodriveForceBrakesCallbackListener | vehicleForceBrakesCallbackListener | core/systems/autoDriveSystem.swift |
| AutoDriveSystem | NativeAutodriveSystem | core/systems/autoDriveSystem.swift |
| BlackBoardRequestEvent | Event | core/systems/blackboardSystem.swift |
| TimetableCallbackData | IScriptable | core/systems/cityLightSystem.swift |
| ForceCLSStateRequest | ScriptableSystemRequest | core/systems/cityLightSystem.swift |
| CLSWeatherListener | WeatherScriptListener | core/systems/cityLightSystem.swift |
| CityLightSystem | ScriptableSystem | core/systems/cityLightSystem.swift |
| CSH | IScriptable | core/systems/cooldownManager.swift |
| CraftingSystem | ScriptableSystem | core/systems/craftingSystem.swift |
| CraftBook | IScriptable | core/systems/craftingSystem.swift |
| CraftingSystemInventoryCallback | InventoryScriptCallback | core/systems/craftingSystem.swift |
| DelamainTaxiSystem | ScriptableSystem | core/systems/delamainTaxiSystem.swift |
| gameDestructibleSpotsSystem | worldIDestructibleSpotsSystem | core/systems/destructibleSpotsSystem.swift |
| DropPointCallback | InventoryScriptCallback | core/systems/dropPointSystem.swift |
| DropPointRequest | ScriptableSystemRequest | core/systems/dropPointSystem.swift |
| DropPointMappinRegistrationData | IScriptable | core/systems/dropPointSystem.swift |
| ToggleDropPointSystemRequest | ScriptableSystemRequest | core/systems/dropPointSystem.swift |
| DropPointPackage | IScriptable | core/systems/dropPointSystem.swift |
| DropPointSystem | ScriptableSystem | core/systems/dropPointSystem.swift |
| DynamicSpawnSystem | IDynamicSpawnSystem | core/systems/dynamicSpawnSystem.swift |
| IsNPCInCourier | AIbehaviorconditionScript | core/systems/dynamicSpawnSystem.swift |
| FastTravelPointData | IScriptable | core/systems/fastTravelSystem.swift |
| EnableFastTravelRequest | ScriptableSystemRequest | core/systems/fastTravelSystem.swift |
| RegisterFastTravelPointsRequest | ScriptableSystemRequest | core/systems/fastTravelSystem.swift |
| OpenLastVisitedFastTravelSubwayGate | ScriptableSystemRequest | core/systems/fastTravelSystem.swift |
| OpenFastTravelMenuForLastVisitedSubwayGate | ScriptableSystemRequest | core/systems/fastTravelSystem.swift |
| CloseLastVisitedFastTravelSubwayGate | ScriptableSystemRequest | core/systems/fastTravelSystem.swift |
| FastTravelPrefetchRequest | ScriptableSystemRequest | core/systems/fastTravelSystem.swift |
| ProcessFastTravelPrefetchEvent | Event | core/systems/fastTravelSystem.swift |
| FastTravelSystem | ScriptableSystem | core/systems/fastTravelSystem.swift |
| FocusCluesSystem | ScriptableSystem | core/systems/focusCluesSystem.swift |
| TagObjectEvent | Event | core/systems/focusModeTagging.swift |
| FocusModeTaggingSystem | ScriptableSystem | core/systems/focusModeTagging.swift |
| Example_FxSpawning | ScriptableComponent | core/systems/fxSystem.swift |
| GameSessionDataSystem | ScriptableSystem | core/systems/gameSessionDataSystem.swift |
| GameSessionDataModule | IScriptable | core/systems/gameSessionDataSystem.swift |
| CameraDeadBodySessionDataModule | GameSessionDataModule | core/systems/gameSessionDataSystem.swift |
| CameraDeadBodyInternalData | IScriptable | core/systems/gameSessionDataSystem.swift |
| CameraTagEnemyLimitDataModule | GameSessionDataModule | core/systems/gameSessionDataSystem.swift |
| GamepadLightScriptableSystem | ScriptableSystem | core/systems/gamepadLightController.swift |
| GamplayQuestData | IScriptable | core/systems/gameplayQuestSystem.swift |
| GameplayQuestSystem | ScriptableSystem | core/systems/gameplayQuestSystem.swift |
| WrappedGOGRewardPack | IScriptable | core/systems/gogRewardsSystem.swift |
| HUDInstruction | Event | core/systems/hud/hudManager.swift |
| HUDManager | NativeHudManager | core/systems/hud/hudManager.swift |
| HUDManagerRequest | ScriptableSystemRequest | core/systems/hud/hudManagerMisc.swift |
| HUDManagerRegistrationRequest | HUDManagerRequest | core/systems/hud/hudManagerMisc.swift |
| RefreshActorRequest | HUDManagerRequest | core/systems/hud/hudManagerMisc.swift |
| HUDActor | IScriptable | core/systems/hud/hudManagerMisc.swift |
| HUDModule | IScriptable | core/systems/hud/modules/baseModule.swift |
| ModuleInstance | IScriptable | core/systems/hud/modules/baseModule.swift |
| BraindanceModule | HUDModule | core/systems/hud/modules/braindanceModule.swift |
| HighlightModule | HUDModule | core/systems/hud/modules/highlightModule.swift |
| HighlightInstance | ModuleInstance | core/systems/hud/modules/highlightModule.swift |
| IconsModule | HUDModule | core/systems/hud/modules/iconsModule.swift |
| IconsInstance | ModuleInstance | core/systems/hud/modules/iconsModule.swift |
| QuickhackModule | HUDModule | core/systems/hud/modules/quickhackModule.swift |
| QuickhackInstance | ModuleInstance | core/systems/hud/modules/quickhackModule.swift |
| ScannerModule | HUDModule | core/systems/hud/modules/scannerModule.swift |
| ScanInstance | ModuleInstance | core/systems/hud/modules/scannerModule.swift |
| JournalManager | IJournalManager | core/systems/journalManager.swift |
| NavigationSystem | IScriptable | core/systems/navigationSystem.swift |
| PingCachedData | IScriptable | core/systems/networkSystem.swift |
| NetworkSystem | ScriptableSystem | core/systems/networkSystem.swift |
| PlayerSystem | gamePlayerSystem | core/systems/playerSystem.swift |
| PlayRadioArgs | IScriptable | core/systems/policeRadioSystem.swift |
| PoliceRadioScriptSystem | ScriptableSystem | core/systems/policeRadioSystem.swift |
| District | IScriptable | core/systems/prevention/districtManager.swift |
| DistrictManager | IScriptable | core/systems/prevention/districtManager.swift |
| PoliceAgentRegistry | IScriptable | core/systems/prevention/policeAgentsRegistry.swift |
| NPCAgent | AgentBase | core/systems/prevention/policeAgentsRegistry.swift |
| VehicleAgent | AgentBase | core/systems/prevention/policeAgentsRegistry.swift |
| IsNPCMarkedForDespawn | AIbehaviorconditionScript | core/systems/prevention/policeAgentsRegistry.swift |
| MarkNPCAgentForDespawn | AIbehaviortaskScript | core/systems/prevention/policeAgentsRegistry.swift |
| PreventionAgents | IScriptable | core/systems/prevention/preventionAgents.swift |
| PreventionSpawnSystem | IPreventionSpawnSystem | core/systems/preventionSpawnSystem.swift |
| PreventionSystem | ScriptableSystem | core/systems/preventionSystem.swift |
| ShouldPoliceReactionBeAggressive | PreventionConditionAbstract | core/systems/preventionSystem.swift |
| PreventionDamage | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| TogglePreventionCrowdSpawns | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| SetWantedLevel | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| SetHeatCounterMultiplier | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| SetHeatLevelLimiter | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| SetPreventionPath | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| SetPreventionDifficulty | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| SetPoliceSearchArea | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| TogglePreventionFreeArea | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| ToggleQuestPreventionTrigger | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| TogglePreventionGlobalQuestObjective | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| ToggleBlockSceneInteractions | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| TryResetPreventionFreeArea | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| SetBlockShootingFromVehicle | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| SetPoliceForcesPool | ScriptableSystemRequest | core/systems/preventionSystem.swift |
| IsNPCInPrevention | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IsNPCInActivePoliceChase | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IsNPCMaxTac | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IsPreventionSystemActive | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IsLastPlayerPositionEmpty | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| MinimalDistanceToLastKnownPosition | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| HasLastKnownPositionChanged | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| ShouldWorkSpotPoliceJoinChaseCondition | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| HasDeescalatedFromCombatWithPlayer | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| SetLastKnownPosition | AIbehaviortaskScript | core/systems/preventionSystemAIHelperClasses.swift |
| SetLastPlayerPositionByDefault | AIbehaviortaskScript | core/systems/preventionSystemAIHelperClasses.swift |
| SetPoliceVehicleAsLastKnownPosition | AIbehaviortaskScript | core/systems/preventionSystemAIHelperClasses.swift |
| IsPlayerInVehicle | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IsPlayerFarFromLKP | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IsPoliceInCombatWithPlayer | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IsPoliceUnawareOfThePlayerExactLocationCondition | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| ManageSirensAndLightsInPoliceCar | AIbehaviortaskScript | core/systems/preventionSystemAIHelperClasses.swift |
| HasShootFromVehicleTicket | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IsPlayerInAPoliceCarChaseCondition | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IsNPCInVehicle | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| HasNPCVehicleAssigned | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| HasPlayerTakenMyVehicle | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| NullifyMountRequestBehaviourTask | AIVehicleTaskAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| TryQueueEventToMountPoliceToVehicle | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| ReleaseReservedSeat | AIbehaviortaskScript | core/systems/preventionSystemAIHelperClasses.swift |
| SetAnimsetOverrideForPassengerNPC | AIbehaviortaskScript | core/systems/preventionSystemAIHelperClasses.swift |
| CanNPCMountVehicle | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| HasNPCReactiveSignal | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| CanVehicleBeDriven | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| JoinTrafficInPoliceVehicle | AIVehicleTaskAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| JoinTrafficOnFoot | AIVehicleTaskAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| CheckSpawningStrategy | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| GetPoliceStrategyDestinationTask | AIbehaviortaskScript | core/systems/preventionSystemAIHelperClasses.swift |
| CheckHeatStage | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| SetNPCSensesMainPresetPrevention | SetNPCSensesMainPreset | core/systems/preventionSystemAIHelperClasses.swift |
| ShouldNPCRetreatFromMaxTacEncounter | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IsAVSpawned | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| ShouldRetreatBehaviorStop | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| HasVehicleAnyCommand | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| IntervalCaller | DelayCallback | core/systems/preventionSystemAIHelperClasses.swift |
| IsAssignedVehicleAV | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| CanShootToTargretFromMountedGuns | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| VehicleHasWindowsRollDown | PreventionConditionAbstract | core/systems/preventionSystemAIHelperClasses.swift |
| VehiclePreventionHackState | IScriptable | core/systems/preventionSystemHackerLoop.swift |
| PreventionSystemHackerLoop | ScriptableSystem | core/systems/preventionSystemHackerLoop.swift |
| PsychoSquadAvHelperClass | ScriptableSystem | core/systems/psychoSquadAVSystem.swift |
| IsPsychoSquadAvWithoutPassangers | PreventionConditionAbstract | core/systems/psychoSquadAVSystem.swift |
| TurnOnPsychoSquadAvCammo | AIbehaviortaskScript | core/systems/psychoSquadAVSystem.swift |
| TurnOnPsychoSquadAvCammoImmediatly | AIbehaviortaskScript | core/systems/psychoSquadAVSystem.swift |
| TurnOffPsychoSquadAvCammo | AIbehaviortaskScript | core/systems/psychoSquadAVSystem.swift |
| TurnOffPsychoSquadAvCammoImmediatly | AIbehaviortaskScript | core/systems/psychoSquadAVSystem.swift |
| RegisterPsychoSquadPassengers | AIbehaviortaskScript | core/systems/psychoSquadAVSystem.swift |
| GetOffThePsychoSquadAV | AIbehaviortaskScript | core/systems/psychoSquadAVSystem.swift |
| DetectPlayerFromAV | AIbehaviortaskScript | core/systems/psychoSquadAVSystem.swift |
| AvStartDescentSFXBehaviour | AIbehaviortaskScript | core/systems/psychoSquadAVSystem.swift |
| AvHoverIdleSFXBehaviour | AIbehaviortaskScript | core/systems/psychoSquadAVSystem.swift |
| AvStartAscentSFXBehaviour | AIbehaviortaskScript | core/systems/psychoSquadAVSystem.swift |
| IsPreventionMaxtacCondition | PreventionConditionAbstract | core/systems/psychoSquadAVSystem.swift |
| ScriptedReactionSystem | ScriptableSystem | core/systems/reactionSystem.swift |
| CombatRestrictMovementAreaScriptCondition | ICombatRestrictMovementAreaCondition | core/systems/restrictMovementAreaManager.swift |
| CombatRestrictMovementAreaPlayerEnterMainRMACondition | CombatRestrictMovementAreaScriptCondition | core/systems/restrictMovementAreaManager.swift |
| CombatRestrictMovementAreaAllDeadCondition | CombatRestrictMovementAreaScriptCondition | core/systems/restrictMovementAreaManager.swift |
| SaveLocksManager | ScriptableSystem | core/systems/saveLocksManager.swift |
| BraindanceSystem | ScriptableSystem | core/systems/sceneSystem.swift |
| ScriptableSystem | IScriptableSystem | core/systems/scriptableSystem.swift |
| SpatialQueriesHelper | IScriptable | core/systems/spatialQueriesSystem.swift |
| ScriptStatPoolsListener | IStatPoolsListener | core/systems/statPoolsSystem.swift |
| ScriptStatsListener | IStatsListener | core/systems/statsSystem.swift |
| StatsSystemHelper | IScriptable | core/systems/statsSystem.swift |
| StatusEffectHelper | IScriptable | core/systems/statusEffectSystem.swift |
| PlayerGameplayRestrictions | IScriptable | core/systems/statusEffectSystem.swift |
| TakeOverControlSystem | ScriptableSystem | core/systems/takeOverControlSystem.swift |
| LockTakeControlAction | ScriptableSystemRequest | core/systems/takeOverControlSystem.swift |
| LockDeviceChainCreation | ScriptableSystemRequest | core/systems/takeOverControlSystem.swift |
| TargetFilterResult | IScriptable | core/systems/targetingSystem.swift |
| TargetFilter_Script | TargetFilter | core/systems/targetingSystem.swift |
| AIActionTransactionSystem | IScriptable | core/systems/transactionSystem.swift |
| UISystem | IUISystem | core/systems/uiSystem.swift |
| GamePuppetPS | GameObjectPS | core/systems/varDBSystem.swift |
| VehicleSystem | IVehicleSystem | core/systems/vehicleSystem.swift |
| WardrobeSystem | IWardrobeSystem | core/systems/wardrobeSystem.swift |
| WeatherScriptListener | IScriptable | core/systems/weatherSystem.swift |
| WorkspotCondition | IScriptable | core/systems/workspotSystem.swift |
| TestConditon | WorkspotCondition | core/systems/workspotSystem.swift |
| TestFalseConditon | WorkspotCondition | core/systems/workspotSystem.swift |
| IsUnarmedCondition | WorkspotCondition | core/systems/workspotSystem.swift |
| HasMeleeWeaponEquippedCondition | WorkspotCondition | core/systems/workspotSystem.swift |
| HasRangedWeaponEquippedCondition | WorkspotCondition | core/systems/workspotSystem.swift |
| PrimaryWeaponTypeCondition | WorkspotCondition | core/systems/workspotSystem.swift |
| EquippedWeaponTypeCondition | WorkspotCondition | core/systems/workspotSystem.swift |
| LogicalCondition | WorkspotCondition | core/systems/workspotSystem.swift |

### Structs (2)

| Name | Bases | Source File |
|------|-------|-------------|
| ItemAttachments |  | core/systems/craftingSystem.swift |
| VirtualComponentBinder |  | core/systems/varDBSystem.swift |

### Static Funcs (26)

| Name | Bases | Source File |
|------|-------|-------------|
| OperatorAdd |  | core/systems/debugCheatSystem.swift |
| OperatorAdd |  | core/systems/debugCheatSystem.swift |
| OperatorEqual |  | core/systems/dropPointSystem.swift |
| OperatorEqual |  | core/systems/dropPointSystem.swift |
| CanLog |  | core/systems/gameInstance.swift |
| GetDamageSystemLogFlags |  | core/systems/gameInstance.swift |
| GetImmortality |  | core/systems/godModeSystem.swift |
| OperatorEqual |  | core/systems/dropPointSystem.swift |
| OperatorGreaterEqual |  | core/systems/hud/hudManagerMisc.swift |
| OperatorLessEqual |  | core/systems/hud/hudManagerMisc.swift |
| IntToEPreventionHeatStage |  | core/systems/preventionSystem.swift |
| GetGameObjectFromEntityReference |  | core/systems/questSystem.swift |
| ToInventoryItemData |  | core/systems/telemetry.swift |
| EmptyInventoryItemData |  | core/systems/telemetry.swift |
| ToTelemetryInventoryItem |  | core/systems/telemetry.swift |
| ToTelemetryEnemy |  | core/systems/telemetry.swift |
| ToTelemetryDamage |  | core/systems/telemetry.swift |
| ToTelemetryDamage |  | core/systems/telemetry.swift |
| ToTelemetryDamage |  | core/systems/telemetry.swift |
| ToTelemetryDamageDealt |  | core/systems/telemetry.swift |
| ToTelemetryDamageDealt |  | core/systems/telemetry.swift |
| GetPSGeneratorVersion |  | core/systems/varDBSystem.swift |
| SpawnVirtualPS |  | core/systems/varDBSystem.swift |
| GetNotSavableClasses |  | core/systems/varDBSystem.swift |
| GetIgnoredVisionBlockerTypes |  | core/systems/vision/visionBlockerTypes.swift |
| GetInvalidVisionBlockerID |  | core/systems/vision/visionBlockersRegistrar.swift |

### Funcs (37)

| Name | Bases | Source File |
|------|-------|-------------|
| OnStatPoolValueChanged |  | core/systems/autoDriveSystem.swift |
| OnRainIntensityChanged |  | core/systems/cityLightSystem.swift |
| OnRainIntensityTypeChanged |  | core/systems/cityLightSystem.swift |
| OnItemAdded |  | core/systems/craftingSystem.swift |
| OnItemRemoved |  | core/systems/dropPointSystem.swift |
| Initialize |  | core/systems/gameSessionDataSystem.swift |
| Uninitialize |  | core/systems/gameSessionDataSystem.swift |
| AddEntry |  | core/systems/gameSessionDataSystem.swift |
| RefreshDebug |  | core/systems/gameSessionDataSystem.swift |
| Initialize |  | core/systems/gameSessionDataSystem.swift |
| AddEntry |  | core/systems/gameSessionDataSystem.swift |
| RefreshDebug |  | core/systems/gameSessionDataSystem.swift |
| Initialize |  | core/systems/gameSessionDataSystem.swift |
| Uninitialize |  | core/systems/gameSessionDataSystem.swift |
| AddEntry |  | core/systems/gameSessionDataSystem.swift |
| RefreshDebug |  | core/systems/gameSessionDataSystem.swift |
| UnregisterActor |  | core/systems/hud/modules/baseModule.swift |
| Suppress |  | core/systems/hud/modules/baseModule.swift |
| SetState |  | core/systems/hud/modules/baseModule.swift |
| Suppress |  | core/systems/hud/modules/baseModule.swift |
| Suppress |  | core/systems/hud/modules/baseModule.swift |
| Suppress |  | core/systems/hud/modules/baseModule.swift |
| Suppress |  | core/systems/hud/modules/baseModule.swift |
| IsFulfilled |  | core/systems/restrictMovementAreaManager.swift |
| IsFulfilled |  | core/systems/restrictMovementAreaManager.swift |
| IsFulfilled |  | core/systems/restrictMovementAreaManager.swift |
| OnStatPoolValueChanged |  | core/systems/autoDriveSystem.swift |
| OnStatChanged |  | core/systems/statsSystem.swift |
| OnGodModeChanged |  | core/systems/statsSystem.swift |
| OnReset |  | core/systems/targetingSystem.swift |
| OnClone |  | core/systems/targetingSystem.swift |
| PreFilter |  | core/systems/targetingSystem.swift |
| Filter |  | core/systems/targetingSystem.swift |
| PostFilter |  | core/systems/targetingSystem.swift |
| CreateFilterResult |  | core/systems/targetingSystem.swift |
| OnRainIntensityChanged |  | core/systems/cityLightSystem.swift |
| OnRainIntensityTypeChanged |  | core/systems/cityLightSystem.swift |

## Citations

- `core/systems/DeviceConnectionsHighlightSystem.swift`
- `core/systems/animationSystemForcedVisibilityManager.swift`
- `core/systems/audioSystem.swift`
- `core/systems/autoDriveSystem.swift`
- `core/systems/blackboardSystem.swift`
- `core/systems/cityLightSystem.swift`
- `core/systems/cooldownManager.swift`
- `core/systems/craftingSystem.swift`
- `core/systems/debugCheatSystem.swift`
- `core/systems/delamainTaxiSystem.swift`
- `core/systems/destructibleSpotsSystem.swift`
- `core/systems/dropPointSystem.swift`
- `core/systems/dynamicSpawnSystem.swift`
- `core/systems/fastTravelSystem.swift`
- `core/systems/focusCluesSystem.swift`
- `core/systems/focusModeTagging.swift`
- `core/systems/fxSystem.swift`
- `core/systems/gameInstance.swift`
- `core/systems/gameSessionDataSystem.swift`
- `core/systems/gamepadLightController.swift`
- `core/systems/gameplayQuestSystem.swift`
- `core/systems/godModeSystem.swift`
- `core/systems/gogRewardsSystem.swift`
- `core/systems/hud/hudManager.swift`
- `core/systems/hud/hudManagerMisc.swift`
- `core/systems/hud/modules/baseModule.swift`
- `core/systems/hud/modules/braindanceModule.swift`
- `core/systems/hud/modules/highlightModule.swift`
- `core/systems/hud/modules/iconsModule.swift`
- `core/systems/hud/modules/quickhackModule.swift`
- `core/systems/hud/modules/scannerModule.swift`
- `core/systems/journalManager.swift`
- `core/systems/navigationSystem.swift`
- `core/systems/networkSystem.swift`
- `core/systems/playerSystem.swift`
- `core/systems/policeRadioSystem.swift`
- `core/systems/prevention/districtManager.swift`
- `core/systems/prevention/policeAgentsRegistry.swift`
- `core/systems/prevention/preventionAgents.swift`
- `core/systems/preventionSpawnSystem.swift`
- `core/systems/preventionSystem.swift`
- `core/systems/preventionSystemAIHelperClasses.swift`
- `core/systems/preventionSystemHackerLoop.swift`
- `core/systems/psychoSquadAVSystem.swift`
- `core/systems/questSystem.swift`
- `core/systems/reactionSystem.swift`
- `core/systems/restrictMovementAreaManager.swift`
- `core/systems/saveLocksManager.swift`
- `core/systems/sceneSystem.swift`
- `core/systems/scriptableSystem.swift`
- `core/systems/spatialQueriesSystem.swift`
- `core/systems/statPoolsSystem.swift`
- `core/systems/statsSystem.swift`
- `core/systems/statusEffectSystem.swift`
- `core/systems/takeOverControlSystem.swift`
- `core/systems/targetingSystem.swift`
- `core/systems/telemetry.swift`
- `core/systems/transactionSystem.swift`
- `core/systems/uiSystem.swift`
- `core/systems/varDBSystem.swift`
- `core/systems/vehicleSystem.swift`
- `core/systems/vision/visionBlockerTypes.swift`
- `core/systems/vision/visionBlockersRegistrar.swift`
- `core/systems/wardrobeSystem.swift`
- `core/systems/weatherSystem.swift`
- `core/systems/workspotSystem.swift`
