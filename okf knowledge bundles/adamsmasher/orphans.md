---
type: "Module"
title: "Orphaned Types"
description: "Large file with various orphaned type declarations including movement types and other miscellaneous enums/structs."
resource: "!orphans.swift"
tags: ['orphans']
timestamp: 2026-07-01T13:00:55Z
---

# Orphaned Types

Large file with various orphaned type declarations including movement types and other miscellaneous enums/structs.

## Source Files

- `orphans.swift`

## Member Types

**Total declarations: 5687**

### Classs (4071)

| Name | Bases | Source File |
|------|-------|-------------|
| IScriptable |  | orphans.swift |
| Event | IScriptable | orphans.swift |
| AdvertGlitchEvent | Event | orphans.swift |
| GameEntity | Entity | orphans.swift |
| PersistentState | IScriptable | orphans.swift |
| IGameSystem | IScriptable | orphans.swift |
| IGamePersistencySystem | IGameSystem | orphans.swift |
| ScriptTaskData | IScriptable | orphans.swift |
| HUDManagerRegistrationTaskData | ScriptTaskData | orphans.swift |
| IActivityLogSystem | IGameSystem | orphans.swift |
| gameIAttitudeManager | IGameSystem | orphans.swift |
| gameIGameAudioSystem | IGameSystem | orphans.swift |
| IBlackboardSystem | IGameSystem | orphans.swift |
| ICameraSystem | IGameSystem | orphans.swift |
| ICommunitySystem | IGameSystem | orphans.swift |
| ICompanionSystem | IGameSystem | orphans.swift |
| ICoverManager | IGameSystem | orphans.swift |
| gameIDebugVisualizerSystem | IGameSystem | orphans.swift |
| IDelaySystem | IGameSystem | orphans.swift |
| IDeviceSystem | IGameSystem | orphans.swift |
| IEntitySpawnerEventsBroadcaster | IGameSystem | orphans.swift |
| IEffectSystem | IGameSystem | orphans.swift |
| gameISpatialQueriesSystem | IGameSystem | orphans.swift |
| ILootManager | IGameSystem | orphans.swift |
| ILocationManager | IGameSystem | orphans.swift |
| IReplicatedGameSystem | IGameSystem | orphans.swift |
| IMappinSystem | IReplicatedGameSystem | orphans.swift |
| IObjectPoolSystem | IGameSystem | orphans.swift |
| gameIPlayerSystem | IGameSystem | orphans.swift |
| gamePlayerSystem | gameIPlayerSystem | orphans.swift |
| IPrereqManager | IGameSystem | orphans.swift |
| IPreventionSpawnSystem | IGameSystem | orphans.swift |
| IDynamicSpawnSystem | IGameSystem | orphans.swift |
| IGamepadLightController | IGameSystem | orphans.swift |
| IPoliceRadioSystem | IGameSystem | orphans.swift |
| questIQuestsSystem | IReplicatedGameSystem | orphans.swift |
| questIQuestsContentSystem | IGameSystem | orphans.swift |
| ISceneSystem | IGameSystem | orphans.swift |
| gameIScriptableSystemsContainer | IGameSystem | orphans.swift |
| IStatPoolsSystem | IGameSystem | orphans.swift |
| IStatsSystem | IGameSystem | orphans.swift |
| IStatsDataSystem | IGameSystem | orphans.swift |
| IStatusEffectSystem | IGameSystem | orphans.swift |
| IGodModeSystem | IReplicatedGameSystem | orphans.swift |
| IEffectorSystem | IGameSystem | orphans.swift |
| IDamageSystem | IReplicatedGameSystem | orphans.swift |
| ITargetingSystem | IGameSystem | orphans.swift |
| gameITimeSystem | IReplicatedGameSystem | orphans.swift |
| ITransactionSystem | IGameSystem | orphans.swift |
| IVisionModeSystem | IGameSystem | orphans.swift |
| IVehicleSystem | IGameSystem | orphans.swift |
| IWorkspotGameSystem | IGameSystem | orphans.swift |
| IInventoryManager | IGameSystem | orphans.swift |
| gameITeleportationFacility | IGameSystem | orphans.swift |
| IInfluenceMapSystem | IGameSystem | orphans.swift |
| IFxSystem | IGameSystem | orphans.swift |
| IRestrictMovementAreaManager | IGameSystem | orphans.swift |
| ISafeAreaManager | IGameSystem | orphans.swift |
| IGameplayLogicPackageSystem | IGameSystem | orphans.swift |
| IJournalManager | IReplicatedGameSystem | orphans.swift |
| IDebugCheatsSystem | IReplicatedGameSystem | orphans.swift |
| ITelemetrySystem | IGameSystem | orphans.swift |
| gameIPingSystem | IReplicatedGameSystem | orphans.swift |
| IProjectileSystem | IGameSystem | orphans.swift |
| gameIScriptsDebugOverlaySystem | IGameSystem | orphans.swift |
| IDebugPlayerBreadcrumbs | IGameSystem | orphans.swift |
| IInteractionManager | IGameSystem | orphans.swift |
| IGlobalTvSystem | IGameSystem | orphans.swift |
| ISubtitleHandlerSystem | IGameSystem | orphans.swift |
| AIINavigationSystem | IGameSystem | orphans.swift |
| ISenseManager | IGameSystem | orphans.swift |
| IUISystem | IGameSystem | orphans.swift |
| IAchievementSystem | IGameSystem | orphans.swift |
| ILevelAssignmentSystem | IGameSystem | orphans.swift |
| IPhotoModeSystem | IGameSystem | orphans.swift |
| IReactionSystem | IGameSystem | orphans.swift |
| IRacingSystem | IGameSystem | orphans.swift |
| gameIAutoSaveSystem | IGameSystem | orphans.swift |
| questITutorialManager | IGameSystem | orphans.swift |
| IStimuliSystem | IGameSystem | orphans.swift |
| questIPhoneManager | IGameSystem | orphans.swift |
| IWardrobeSystem | IGameSystem | orphans.swift |
| IRazerChromaEffectsSystem | IGameSystem | orphans.swift |
| IMinimapSystem | IGameSystem | orphans.swift |
| IContainerManager | IGameSystem | orphans.swift |
| DelaySystem | IDelaySystem | orphans.swift |
| ScriptableSystemRequest | IScriptable | orphans.swift |
| TimeDilatable | GameObject | orphans.swift |
| TweakDBInterface | IScriptable | orphans.swift |
| TweakDBRecord | IScriptable | orphans.swift |
| AIActionSubCondition_Record | TweakDBRecord | orphans.swift |
| AIRecord_Record | TweakDBRecord | orphans.swift |
| AINode_Record | AIRecord_Record | orphans.swift |
| AITicket_Record | TweakDBRecord | orphans.swift |
| AIItemCond_Record | AIActionSubCondition_Record | orphans.swift |
| BaseObject_Record | TweakDBRecord | orphans.swift |
| SpawnableObject_Record | BaseObject_Record | orphans.swift |
| AITicketCondition_Record | TweakDBRecord | orphans.swift |
| AITicketCheck_Record | AITicketCondition_Record | orphans.swift |
| AITicketFilter_Record | AITicketCondition_Record | orphans.swift |
| AISquadDistanceRelationToSectorCheck_Record | AITicketCheck_Record | orphans.swift |
| AISquadDistanceRelationToTargetCheck_Record | AITicketCheck_Record | orphans.swift |
| AISquadItemPriorityFilter_Record | AITicketFilter_Record | orphans.swift |
| AISubAction_Record | TweakDBRecord | orphans.swift |
| AISubActionShootWithWeapon_Record | AISubAction_Record | orphans.swift |
| AISubActionCharacterRecordEquip_Record | AISubAction_Record | orphans.swift |
| AISubActionSetTargetByTag_Record | AISubAction_Record | orphans.swift |
| AISubActionCharacterRecordUnequip_Record | AISubAction_Record | orphans.swift |
| CoverSelectionParameters_Record | TweakDBRecord | orphans.swift |
| ObjectAction_Record | TweakDBRecord | orphans.swift |
| ScannableData_Record | TweakDBRecord | orphans.swift |
| IPrereq_Record | TweakDBRecord | orphans.swift |
| WidgetDefinition_Record | TweakDBRecord | orphans.swift |
| Effector_Record | TweakDBRecord | orphans.swift |
| StatModifier_Record | TweakDBRecord | orphans.swift |
| ConstantStatModifier_Record | StatModifier_Record | orphans.swift |
| SenseShape_Record | TweakDBRecord | orphans.swift |
| ApplyStatusEffectEffector_Record | Effector_Record | orphans.swift |
| ArcadeObject_Record | TweakDBRecord | orphans.swift |
| Attack_Record | TweakDBRecord | orphans.swift |
| Attack_GameEffect_Record | Attack_Record | orphans.swift |
| Stat_Record | TweakDBRecord | orphans.swift |
| VehicleDriveModelData_Record | TweakDBRecord | orphans.swift |
| ProjectileCollision_Record | TweakDBRecord | orphans.swift |
| ContinuousEffector_Record | Effector_Record | orphans.swift |
| ChoiceCaptionPart_Record | TweakDBRecord | orphans.swift |
| Item_Record | BaseObject_Record | orphans.swift |
| StatusEffect_Record | TweakDBRecord | orphans.swift |
| DeviceScreenType_Record | TweakDBRecord | orphans.swift |
| StatPoolPrereq_Record | IPrereq_Record | orphans.swift |
| ItemAction_Record | ObjectAction_Record | orphans.swift |
| EquipmentArea_Record | TweakDBRecord | orphans.swift |
| ContentAssignment_Record | TweakDBRecord | orphans.swift |
| DriveHelper_Record | TweakDBRecord | orphans.swift |
| WeaponItem_Record | Item_Record | orphans.swift |
| BaseSign_Record | TweakDBRecord | orphans.swift |
| Gadget_Record | WeaponItem_Record | orphans.swift |
| GrenadeDeliveryMethod_Record | TweakDBRecord | orphans.swift |
| InteractionBase_Record | TweakDBRecord | orphans.swift |
| Query_Record | TweakDBRecord | orphans.swift |
| ItemQuery_Record | Query_Record | orphans.swift |
| ObjectActionCost_Record | TweakDBRecord | orphans.swift |
| StatPrereq_Record | IPrereq_Record | orphans.swift |
| LootTableElement_Record | TweakDBRecord | orphans.swift |
| UIIcon_Record | TweakDBRecord | orphans.swift |
| Accuracy_Record | TweakDBRecord | orphans.swift |
| Base_MappinDefinition_Record | TweakDBRecord | orphans.swift |
| MappinUIRuntimeProfile_Record | TweakDBRecord | orphans.swift |
| MiniGame_SymbolsWithRarity_Record | TweakDBRecord | orphans.swift |
| PoolValueModifier_Record | TweakDBRecord | orphans.swift |
| NPCEquipmentGroupEntry_Record | TweakDBRecord | orphans.swift |
| Proficiency_Record | TweakDBRecord | orphans.swift |
| LCDScreen_Record | BaseSign_Record | orphans.swift |
| LootTable_Record | TweakDBRecord | orphans.swift |
| PhotoModeItem_Record | TweakDBRecord | orphans.swift |
| ReactionPreset_Record | TweakDBRecord | orphans.swift |
| ProjectileLaunch_Record | TweakDBRecord | orphans.swift |
| RoachRaceObject_Record | ArcadeObject_Record | orphans.swift |
| SearchFilterMaskTypeCondition_Record | TweakDBRecord | orphans.swift |
| ShooterObject_Record | ArcadeObject_Record | orphans.swift |
| ShooterAI_Record | ShooterObject_Record | orphans.swift |
| ShooterBossAI_Record | ShooterAI_Record | orphans.swift |
| ShooterProjectileAI_Record | ShooterAI_Record | orphans.swift |
| ArcadeGameplay_Record | TweakDBRecord | orphans.swift |
| StatModifierGroup_Record | TweakDBRecord | orphans.swift |
| Character_Record | SpawnableObject_Record | orphans.swift |
| Device_Record | BaseObject_Record | orphans.swift |
| ArcadeCollidableObject_Record | ArcadeObject_Record | orphans.swift |
| TankDestroyableObject_Record | ArcadeCollidableObject_Record | orphans.swift |
| VehicleFxWheelsDecalsMaterial_Record | TweakDBRecord | orphans.swift |
| PurchaseOffer_Record | TweakDBRecord | orphans.swift |
| VehicleWheelDrivingSetup_Record | TweakDBRecord | orphans.swift |
| VendorWare_Record | TweakDBRecord | orphans.swift |
| gamePuppet | gamePuppetBase | orphans.swift |
| IComponent | IScriptable | orphans.swift |
| IPlacedComponent | IComponent | orphans.swift |
| GameComponent | IComponent | orphans.swift |
| GameObjectPS | PersistentState | orphans.swift |
| DeviceAction | Event | orphans.swift |
| GamePersistencySystem | IGamePersistencySystem | orphans.swift |
| GameComponentPS | PersistentState | orphans.swift |
| ExtractDevicesEvent | Event | orphans.swift |
| LazyDevice | IScriptable | orphans.swift |
| ProcessDevicesEvent | Event | orphans.swift |
| MaraudersMapDevicesSink | IScriptable | orphans.swift |
| DeviceSystem | IDeviceSystem | orphans.swift |
| GameAttachedEvent | Event | orphans.swift |
| gameStatModifierData | IScriptable | orphans.swift |
| gameConstantStatModifierData | gameStatModifierData | orphans.swift |
| LevelAssignmentSystem | ILevelAssignmentSystem | orphans.swift |
| StatsSystem | IStatsSystem | orphans.swift |
| gameItemData | IScriptable | orphans.swift |
| IPrereq | IScriptable | orphans.swift |
| PrereqState | IScriptable | orphans.swift |
| QuestsSystem | questIQuestsSystem | orphans.swift |
| StoreMiniGameProgramEvent | Event | orphans.swift |
| BlackboardSystem | IBlackboardSystem | orphans.swift |
| AllBlackboardDefinitions | IScriptable | orphans.swift |
| BlackboardDefinition | IScriptable | orphans.swift |
| AIBlackboardDef | BlackboardDefinition | orphans.swift |
| MasterDeviceBaseBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| CustomBlackboardDef | BlackboardDefinition | orphans.swift |
| IBlackboard | IScriptable | orphans.swift |
| VehicleCameraManagerComponent | GameComponent | orphans.swift |
| IScriptableSystem | IScriptable | orphans.swift |
| NativeHudManager | ScriptableSystem | orphans.swift |
| VisionModeSystem | IVisionModeSystem | orphans.swift |
| PushUIGameContextEvent | Event | orphans.swift |
| PopUIGameContextEvent | Event | orphans.swift |
| SwapUIGameContextEvent | Event | orphans.swift |
| ResetUIGameContextEvent | Event | orphans.swift |
| VisualStateChangeEvent | Event | orphans.swift |
| VisualStateRestorePreviousEvent | Event | orphans.swift |
| FastTravelSystem_Record | TweakDBRecord | orphans.swift |
| ScriptsDebugOverlaySystem | gameIScriptsDebugOverlaySystem | orphans.swift |
| FastTravelPoint_Record | TweakDBRecord | orphans.swift |
| District_Record | TweakDBRecord | orphans.swift |
| MappinSystem | IMappinSystem | orphans.swift |
| IVisualObject | IScriptable | orphans.swift |
| TriggerEvent | Event | orphans.swift |
| StatusEffectSystem | IStatusEffectSystem | orphans.swift |
| StatusEffectBase | IScriptable | orphans.swift |
| FastTravelPointsUpdated | Event | orphans.swift |
| PlayerScriptableSystemRequest | ScriptableSystemRequest | orphans.swift |
| Achievement_Record | TweakDBRecord | orphans.swift |
| ModifyTelemetryVariable | PlayerScriptableSystemRequest | orphans.swift |
| ResetMeleeAttackDelayedRequest | ScriptableSystemRequest | orphans.swift |
| ResetRangedAttackDelayedRequest | ScriptableSystemRequest | orphans.swift |
| AchievementSystem | IAchievementSystem | orphans.swift |
| ResetAttackDelayedRequest | ScriptableSystemRequest | orphans.swift |
| ResetNPCKilledDelayedRequest | ScriptableSystemRequest | orphans.swift |
| ModifyNPCTelemetryVariable | PlayerScriptableSystemRequest | orphans.swift |
| TransactionSystem | ITransactionSystem | orphans.swift |
| gameprojectileLaunchEvent | Event | orphans.swift |
| InventoryListener | IScriptable | orphans.swift |
| AttachmentSlotsListener | IScriptable | orphans.swift |
| ItemCraftedDataTrackingRequest | PlayerScriptableSystemRequest | orphans.swift |
| IAttack | IScriptable | orphans.swift |
| AttackType_Record | TweakDBRecord | orphans.swift |
| InteractionBaseEvent | Event | orphans.swift |
| AudioEvent | Event | orphans.swift |
| InteractionSetEnableEvent | Event | orphans.swift |
| IEffect | IScriptable | orphans.swift |
| EffectSystem | IEffectSystem | orphans.swift |
| EffectInstance | IEffect | orphans.swift |
| WorkspotGameSystem | IWorkspotGameSystem | orphans.swift |
| UnregisterAllMappinsEvent | Event | orphans.swift |
| PhotoModeSystem | IPhotoModeSystem | orphans.swift |
| Attack_Melee_Record | Attack_GameEffect_Record | orphans.swift |
| AttackSubtype_Record | TweakDBRecord | orphans.swift |
| TimeSystem | gameITimeSystem | orphans.swift |
| tickITimeDilationListener | IScriptable | orphans.swift |
| NPCKillDataTrackingRequest | PlayerScriptableSystemRequest | orphans.swift |
| gameHitEvent | Event | orphans.swift |
| IFxPackage | IScriptable | orphans.swift |
| IEquipmentSystem | ScriptableSystem | orphans.swift |
| ScriptableSystemsContainer | gameIScriptableSystemsContainer | orphans.swift |
| inkILogicController | IScriptable | orphans.swift |
| inkAsyncSpawnData | IScriptable | orphans.swift |
| WidgetStyle_Record | TweakDBRecord | orphans.swift |
| WidgetRatio_Record | TweakDBRecord | orphans.swift |
| worlduiIGameController | inkIGameController | orphans.swift |
| inkUserData | IScriptable | orphans.swift |
| inkGameController | worlduiIGameController | orphans.swift |
| inkMenuEventDispatcher | IScriptable | orphans.swift |
| BackActionCallback | Event | orphans.swift |
| inkMenuLayer_SetCursorType | Event | orphans.swift |
| inkEvent | Event | orphans.swift |
| inkInputEvent | inkEvent | orphans.swift |
| inkPointerEvent | inkInputEvent | orphans.swift |
| AnimFeature | IScriptable | orphans.swift |
| AnimInputSetter | Event | orphans.swift |
| AnimInputSetterVector | AnimInputSetter | orphans.swift |
| AnimInputSetterAnimFeature | AnimInputSetter | orphans.swift |
| AnimExternalEvent | Event | orphans.swift |
| AnimInputSetterFloat | AnimInputSetter | orphans.swift |
| AnimInputSetterBool | AnimInputSetter | orphans.swift |
| AnimInputSetterInt | AnimInputSetter | orphans.swift |
| AnimInputSetterUsesSleepMode | Event | orphans.swift |
| AnimWrapperWeightSetter | AnimInputSetter | orphans.swift |
| AnimFeature_Paperdoll | AnimFeature | orphans.swift |
| gameuiICharacterCustomizationState | IScriptable | orphans.swift |
| ItemCategory_Record | TweakDBRecord | orphans.swift |
| GameplayLogicPackageSystem | IGameplayLogicPackageSystem | orphans.swift |
| PartUninstallRequest | PlayerScriptableSystemRequest | orphans.swift |
| ItemType_Record | TweakDBRecord | orphans.swift |
| PartInstallRequest | PlayerScriptableSystemRequest | orphans.swift |
| ItemBlueprintElement_Record | TweakDBRecord | orphans.swift |
| inkHashMap | IScriptable | orphans.swift |
| ItemRecipe_Record | Item_Record | orphans.swift |
| CraftingResult_Record | TweakDBRecord | orphans.swift |
| gameObjectActionsCallbackController | IScriptable | orphans.swift |
| ObjectActionEffect_Record | TweakDBRecord | orphans.swift |
| ObjectActionReference_Record | TweakDBRecord | orphans.swift |
| EffectorSystem | IEffectorSystem | orphans.swift |
| TelemetrySystem | ITelemetrySystem | orphans.swift |
| Craftable_Record | TweakDBRecord | orphans.swift |
| AddRecipeRequest | PlayerScriptableSystemRequest | orphans.swift |
| UpgradingData_Record | TweakDBRecord | orphans.swift |
| RecipeElement_Record | TweakDBRecord | orphans.swift |
| CraftingPackage_Record | TweakDBRecord | orphans.swift |
| Quality_Record | TweakDBRecord | orphans.swift |
| StatsDataSystem | IStatsDataSystem | orphans.swift |
| ATooltipData | IScriptable | orphans.swift |
| UIScriptableSystemInventoryAddItem | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemInventoryRemoveItem | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemSetBackpackSorting | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemSetBackpackFilter | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemSetVendorPanelVendorSorting | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemSetVendorPanelPlayerSorting | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemSetComparisionTooltipDisabled | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemInventoryInspectItem | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemDLCAddedItemInspected | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemWardrobeSetAdded | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemWardrobeSetInspected | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemWardrobeAddItem | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemWardrobeInspectItem | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemAddAvailableCar | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemSetItemPlayerFavourite | ScriptableSystemRequest | orphans.swift |
| UIScriptableSystemSetPreviousAttributeLevel | ScriptableSystemRequest | orphans.swift |
| UI_DEV_ScriptableSystemUseNewTooltips | ScriptableSystemRequest | orphans.swift |
| ScanLongDescriptionCall | ScriptableSystemRequest | orphans.swift |
| DamageType_Record | TweakDBRecord | orphans.swift |
| InventoryItemAttachments | IScriptable | orphans.swift |
| RecipeData | IScriptable | orphans.swift |
| WeaponEvolution_Record | TweakDBRecord | orphans.swift |
| UIStatsMap_Record | TweakDBRecord | orphans.swift |
| IconsNameResolver | IScriptable | orphans.swift |
| inkIntHashMap | IScriptable | orphans.swift |
| inkWeakHashMap | IScriptable | orphans.swift |
| WeaponsTooltipData_Record | TweakDBRecord | orphans.swift |
| WeaponMaxStatValueData | IScriptable | orphans.swift |
| UIInventoryItemInternalData | IScriptable | orphans.swift |
| MinimalItemTooltipDataRequirements | IScriptable | orphans.swift |
| MinimalItemTooltipDataStatRequirement | IScriptable | orphans.swift |
| PerkPrereq_Record | IPrereq_Record | orphans.swift |
| Perk_Record | TweakDBRecord | orphans.swift |
| AttributeData_Record | TweakDBRecord | orphans.swift |
| NewPerk_Record | TweakDBRecord | orphans.swift |
| NewPerkTier_Record | TweakDBRecord | orphans.swift |
| PerkArea_Record | TweakDBRecord | orphans.swift |
| PassiveProficiencyBonus_Record | TweakDBRecord | orphans.swift |
| Trait_Record | TweakDBRecord | orphans.swift |
| TraitData_Record | TweakDBRecord | orphans.swift |
| PerkLevelData_Record | TweakDBRecord | orphans.swift |
| NewPerkLevelData_Record | TweakDBRecord | orphans.swift |
| SetAchievementProgressRequest | PlayerScriptableSystemRequest | orphans.swift |
| AddAchievementRequest | PlayerScriptableSystemRequest | orphans.swift |
| StatPoolsSystem | IStatPoolsSystem | orphans.swift |
| StatusEffect | StatusEffectBase | orphans.swift |
| ProficiencyProgressEvent | Event | orphans.swift |
| UIMenuNotificationEvent | Event | orphans.swift |
| NewPerkLockedEvent | Event | orphans.swift |
| IDamageSystemListener | IScriptable | orphans.swift |
| CacheData | IScriptable | orphans.swift |
| GodModeSystem | IGodModeSystem | orphans.swift |
| DeviceComponent | GameComponent | orphans.swift |
| InteractionComponent | IPlacedComponent | orphans.swift |
| VehicleCustomizationComponent | IComponent | orphans.swift |
| Vehicle_Record | SpawnableObject_Record | orphans.swift |
| IStatPoolsListener | IScriptable | orphans.swift |
| CustomValueStatPoolsListener | ScriptStatPoolsListener | orphans.swift |
| vehicleControllerPS | GameComponentPS | orphans.swift |
| VehicleColorTemplate_Record | TweakDBRecord | orphans.swift |
| VehicleCustomMultilayer_Record | TweakDBRecord | orphans.swift |
| VehicleDecalAttachment_Record | TweakDBRecord | orphans.swift |
| VehicleClearCoatOverrides_Record | TweakDBRecord | orphans.swift |
| VehiclePartsClearCoatOverrides_Record | TweakDBRecord | orphans.swift |
| DetermineInteractionStateTaskData | ScriptTaskData | orphans.swift |
| ScriptableComponent | GameComponent | orphans.swift |
| MappinScriptData | IScriptable | orphans.swift |
| ForceVisionApperanceEvent | Event | orphans.swift |
| HighlightEditableData | IScriptable | orphans.swift |
| RevealStatusNotification | HUDManagerRequest | orphans.swift |
| RevealStateChangedEvent | Event | orphans.swift |
| AIEvent | Event | orphans.swift |
| ScanningController | IScriptable | orphans.swift |
| ResponseEvent | Event | orphans.swift |
| RevealObjectEvent | Event | orphans.swift |
| gameVisionRevealExpiredEvent | Event | orphans.swift |
| BraindanceInstance | ModuleInstance | orphans.swift |
| WorkspotResourceComponent | IPlacedComponent | orphans.swift |
| LocalizationStringComponent | IComponent | orphans.swift |
| ActivityLogSystem | IActivityLogSystem | orphans.swift |
| ScavengeTargetConfirmEvent | Event | orphans.swift |
| DisassembleTargetRequest | Event | orphans.swift |
| TargetScavengedEvent | Event | orphans.swift |
| SlotComponent | IPlacedComponent | orphans.swift |
| AreaEffectTargetData | IScriptable | orphans.swift |
| AreaEffectVisualisationRequest | Event | orphans.swift |
| worldEffectBlackboard | IScriptable | orphans.swift |
| GameObjectEffectHelper | IScriptable | orphans.swift |
| PuppetForceVisionAppearanceData | IScriptable | orphans.swift |
| AddForceHighlightTargetEvent | Event | orphans.swift |
| QHackWheelItemChangedEvent | Event | orphans.swift |
| QuickhackData | IScriptable | orphans.swift |
| entCameraComponent | IPlacedComponent | orphans.swift |
| CameraComponent | entCameraComponent | orphans.swift |
| IVisualComponent | IPlacedComponent | orphans.swift |
| FlickerEvent | Event | orphans.swift |
| ToggleLightEvent | Event | orphans.swift |
| ToggleLightByNameEvent | ToggleLightEvent | orphans.swift |
| ChangeLightEvent | Event | orphans.swift |
| ChangeLightByNameEvent | ChangeLightEvent | orphans.swift |
| AdvanceChangeLightEvent | Event | orphans.swift |
| ChangeCurveEvent | Event | orphans.swift |
| ClearVisibilityInAnimSystemRequest | ScriptableSystemRequest | orphans.swift |
| ForcedVisibilityInAnimSystemData | IScriptable | orphans.swift |
| AnimationSystem | IScriptable | orphans.swift |
| DelayedVisibilityInAnimSystemRequest | ScriptableSystemRequest | orphans.swift |
| ToggleVisibilityInAnimSystemRequest | ScriptableSystemRequest | orphans.swift |
| DeviceActionProperty | IScriptable | orphans.swift |
| ActionEnum | ActionInt | orphans.swift |
| Clearance | IScriptable | orphans.swift |
| DeviceOperationTriggerData | IScriptable | orphans.swift |
| OperationExecutionData | IScriptable | orphans.swift |
| DelayedDeviceOperationTriggerEvent | Event | orphans.swift |
| ChatterHelper | IScriptable | orphans.swift |
| SoundPlayEvent | Event | orphans.swift |
| SoundSwitchEvent | Event | orphans.swift |
| SoundParameterEvent | Event | orphans.swift |
| SoundPlayVo | Event | orphans.swift |
| IMountingFacility | IGameSystem | orphans.swift |
| FactOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| FocusModeOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| TargetingSystem | ITargetingSystem | orphans.swift |
| SensesOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| AttitudeAgent | GameComponent | orphans.swift |
| HitOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| InteractionAreaOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| TriggerVolumeOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| DeviceActionOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| CustomActionOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| DoorStateOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| BaseStateOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| WidgetBaseComponent | IPlacedComponent | orphans.swift |
| RevealNetworkGridEvent | Event | orphans.swift |
| RevealDevicesGridEvent | Event | orphans.swift |
| SetCurrentGameplayRoleEvent | Event | orphans.swift |
| UnTagObjectRequest | ScriptableSystemRequest | orphans.swift |
| RuntimeInfo | IScriptable | orphans.swift |
| ActivateNetworkLinkTaskData | ScriptTaskData | orphans.swift |
| HUDActorUpdateData | IScriptable | orphans.swift |
| FxSystem | IFxSystem | orphans.swift |
| FxInstance | IScriptable | orphans.swift |
| RevealDeviceRequest | Event | orphans.swift |
| DeactivateNetworkLinkTaskData | ScriptTaskData | orphans.swift |
| NetworkPingingParameteres_Record | TweakDBRecord | orphans.swift |
| NetworkPresetBinderParameters_Record | TweakDBRecord | orphans.swift |
| RevealNetworkGridOnPulse | Event | orphans.swift |
| RevealNetworkRequestRequest | ScriptableSystemRequest | orphans.swift |
| UnregisterNetworkLinkRequest | ScriptableSystemRequest | orphans.swift |
| RegisterNetworkLinkRequest | ScriptableSystemRequest | orphans.swift |
| NewBackdoorDeviceRequest | ScriptableSystemRequest | orphans.swift |
| MarkBackdoorAsRevealedRequest | ScriptableSystemRequest | orphans.swift |
| UnregisterNetworkLinksByIDRequest | ScriptableSystemRequest | orphans.swift |
| UnregisterNetworkLinksByIdAndTypeRequest | ScriptableSystemRequest | orphans.swift |
| UnregisterNetworkLinkBetweenTwoEntitiesRequest | ScriptableSystemRequest | orphans.swift |
| DeactivateLinksRequest | ScriptableSystemRequest | orphans.swift |
| ActivateLinksRequest | ScriptableSystemRequest | orphans.swift |
| EvaluateVisionModeRequest | ScriptableSystemRequest | orphans.swift |
| UnregisterAllNetworkLinksRequest | ScriptableSystemRequest | orphans.swift |
| UpdateNetworkVisualisationRequest | ScriptableSystemRequest | orphans.swift |
| RegisterPingNetworkLinkRequest | ScriptableSystemRequest | orphans.swift |
| StartPingingNetworkRequest | ScriptableSystemRequest | orphans.swift |
| StopPingingNetworkRequest | ScriptableSystemRequest | orphans.swift |
| VirtualNetwork_Record | TweakDBRecord | orphans.swift |
| VirtualNetworkPath_Record | TweakDBRecord | orphans.swift |
| RevealNetworkGridNetworkRequest | Event | orphans.swift |
| AddPingedSquadRequest | ScriptableSystemRequest | orphans.swift |
| RemovePingedSquadRequest | ScriptableSystemRequest | orphans.swift |
| HackingSkillCheck | SkillCheckBase | orphans.swift |
| RevokeQuickHackAccess | Event | orphans.swift |
| SecuritySystemInputTaskData | ScriptTaskData | orphans.swift |
| TargetAssessmentRequest | ScriptableDeviceAction | orphans.swift |
| Transition | Event | orphans.swift |
| HackCategory_Record | TweakDBRecord | orphans.swift |
| ObjectActionType_Record | TweakDBRecord | orphans.swift |
| SetQuickHackEvent | Event | orphans.swift |
| RevealQuickhackMenu | HUDManagerRequest | orphans.swift |
| RevealInteractionWheel | Event | orphans.swift |
| RefreshSlavesEvent | ProcessDevicesEvent | orphans.swift |
| ProgramAction | ActionBool | orphans.swift |
| FirstPlusPlusLegendaryAwardedRequest | ScriptableSystemRequest | orphans.swift |
| UpdateShardFailedDropsRequest | ScriptableSystemRequest | orphans.swift |
| HackingRewardNotificationEvent | Event | orphans.swift |
| SetDetectionMultiplier | Event | orphans.swift |
| AnimFeature_DistractionState | AnimFeature | orphans.swift |
| ActionUploadListener | CustomValueStatPoolsListener | orphans.swift |
| UploadProgramProgressEvent | Event | orphans.swift |
| entAppearanceEvent | Event | orphans.swift |
| gameTransformAnimationEvent | Event | orphans.swift |
| gameTransformAnimationPlayEvent | gameTransformAnimationEvent | orphans.swift |
| RestoreRevealStateEvent | Event | orphans.swift |
| TagObjectRequest | ScriptableSystemRequest | orphans.swift |
| PSChangedEvent | Event | orphans.swift |
| SendSpiderbotToPerformActionEvent | Event | orphans.swift |
| StatPoolCost_Record | ObjectActionCost_Record | orphans.swift |
| StatPool_Record | TweakDBRecord | orphans.swift |
| DelayedDeviceActionEvent | Event | orphans.swift |
| MeshComponent | IVisualComponent | orphans.swift |
| SetLogicReadyEvent | Event | orphans.swift |
| DeactivateQuickHackIndicatorEvent | Event | orphans.swift |
| ItemCost_Record | ObjectActionCost_Record | orphans.swift |
| ChoiceCaptionIconPart_Record | ChoiceCaptionPart_Record | orphans.swift |
| StatusEffectType_Record | TweakDBRecord | orphans.swift |
| OffMeshConnectionComponent | IComponent | orphans.swift |
| InteractionChoiceCaptionPart | IScriptable | orphans.swift |
| SetQuickHackableMask | Event | orphans.swift |
| NotifyParentsEvent | Event | orphans.swift |
| PerformedAction | Event | orphans.swift |
| ToggleCustomActionEvent | Event | orphans.swift |
| SetIsSpiderbotInteractionOrderedEvent | Event | orphans.swift |
| SpiderbotOrderDeviceEvent | Event | orphans.swift |
| FactChangedEvent | Event | orphans.swift |
| RefreshInteractionTaskData | ScriptTaskData | orphans.swift |
| MarketSystemRequest | ScriptableSystemRequest | orphans.swift |
| AttachVendorRequest | MarketSystemRequest | orphans.swift |
| IMarketSystem | ScriptableSystem | orphans.swift |
| Vendor_Record | TweakDBRecord | orphans.swift |
| VendorType_Record | TweakDBRecord | orphans.swift |
| SoldItem | IScriptable | orphans.swift |
| UIVendorAttachedEvent | Event | orphans.swift |
| VendorItem_Record | VendorWare_Record | orphans.swift |
| VendorItemQuery_Record | VendorWare_Record | orphans.swift |
| VendorProgressionBasedStock_Record | TweakDBRecord | orphans.swift |
| gameCurveStatModifierData | gameStatModifierData | orphans.swift |
| InteractionActivationEvent | InteractionBaseEvent | orphans.swift |
| PSRefreshEvent | Event | orphans.swift |
| WidgetCustomData | IScriptable | orphans.swift |
| TerminalSystemCustomData | WidgetCustomData | orphans.swift |
| SecuritySystemUIPS | SurveillanceSystemUIPS | orphans.swift |
| RequestWidgetUpdateEvent | Event | orphans.swift |
| AddUserEvent | Event | orphans.swift |
| ResolveActionData | IScriptable | orphans.swift |
| TerminalSetState | Event | orphans.swift |
| RefreshFloorDataEvent | Event | orphans.swift |
| PreventionForceDeescalateRequest | ScriptableSystemRequest | orphans.swift |
| CrowdMemberComponent | IComponent | orphans.swift |
| AgentBase | IScriptable | orphans.swift |
| AIReactionData | IScriptable | orphans.swift |
| BaseStimuliEvent | AIEvent | orphans.swift |
| StimEventTaskData | ScriptTaskData | orphans.swift |
| Stim_Record | TweakDBRecord | orphans.swift |
| ReactionSystem | IReactionSystem | orphans.swift |
| BlockStimProcessingCooldownEvent | Event | orphans.swift |
| StimBroadcasterComponentHelper | IScriptable | orphans.swift |
| SetQuestTargetWasSeen | Event | orphans.swift |
| SetAnyTargetIsLocked | Event | orphans.swift |
| RequestQuestTakeControlInputLock | ScriptableSystemRequest | orphans.swift |
| DeviceEndPlayerCameraControlEvent | Event | orphans.swift |
| SenseVisibilityEvent | Event | orphans.swift |
| SensePresetChangeEvent | SenseVisibilityEvent | orphans.swift |
| TargetTrackerComponent | GameComponent | orphans.swift |
| AIITargetTrackingListener | IScriptable | orphans.swift |
| SquadScriptInterface | IScriptable | orphans.swift |
| SquadMemberComponent | GameComponent | orphans.swift |
| CombatSquadScriptInterface | SquadScriptInterface | orphans.swift |
| AISquadParams_Record | TweakDBRecord | orphans.swift |
| AITicketType_Record | TweakDBRecord | orphans.swift |
| BehaviorBlackboard | IScriptable | orphans.swift |
| SignalUserData | IScriptable | orphans.swift |
| TaggedSignalUserData | SignalUserData | orphans.swift |
| SquadActionSignal | TaggedSignalUserData | orphans.swift |
| SquadActionEvent | Event | orphans.swift |
| AIAction_Record | AINode_Record | orphans.swift |
| AIRingTicket_Record | AITicket_Record | orphans.swift |
| AIRole_Record | TweakDBRecord | orphans.swift |
| DriveCommandUpdate | IScriptable | orphans.swift |
| AICommand | IScriptable | orphans.swift |
| CActionScriptProxy | IScriptable | orphans.swift |
| WheeledObject | VehicleObject | orphans.swift |
| BikeObject | WheeledObject | orphans.swift |
| MountAIEvent | AIEvent | orphans.swift |
| NPCRoleChangeEvent | Event | orphans.swift |
| ActionAnimationScriptProxy | CActionScriptProxy | orphans.swift |
| IFriendlyFireSystem | IGameSystem | orphans.swift |
| FriendlyFireParams | IScriptable | orphans.swift |
| AITweakActionSystem | IGameSystem | orphans.swift |
| AIActionAnimData_Record | TweakDBRecord | orphans.swift |
| AIActionAnimSlot_Record | TweakDBRecord | orphans.swift |
| AIActionCondition_Record | TweakDBRecord | orphans.swift |
| AIActionTarget_Record | TweakDBRecord | orphans.swift |
| TrackingMode_Record | TweakDBRecord | orphans.swift |
| IPositionProvider | IScriptable | orphans.swift |
| CoverManager | ICoverManager | orphans.swift |
| VirtualCameraComponent | entCameraComponent | orphans.swift |
| VRoomFeed | Event | orphans.swift |
| FeedEvent | Event | orphans.swift |
| BinkVideoEvent | Event | orphans.swift |
| PSMBaseEvent | Event | orphans.swift |
| PSMPostponedParameterBase | PSMBaseEvent | orphans.swift |
| PSMPostponedParameterBool | PSMPostponedParameterBase | orphans.swift |
| PreventionRegisterRequest | ScriptableSystemRequest | orphans.swift |
| ResolveSensorDeviceBehaviour | Event | orphans.swift |
| VisibleObjectTypeEvent | Event | orphans.swift |
| DeviceFX_Record | TweakDBRecord | orphans.swift |
| CameraTagLimitData | IScriptable | orphans.swift |
| CameraDeadBodyData | IScriptable | orphans.swift |
| CameraTagLockEvent | Event | orphans.swift |
| DataEntryRequest | ScriptableSystemRequest | orphans.swift |
| RequestReleaseControl | ScriptableSystemRequest | orphans.swift |
| TCSTakeOverControlDeactivate | Event | orphans.swift |
| gameVehicleHitEvent | gameHitEvent | orphans.swift |
| HitInstigatorCooldownEvent | Event | orphans.swift |
| AINetStateComponent | ScriptableComponent | orphans.swift |
| NPCStateChangeSignal | TaggedSignalUserData | orphans.swift |
| gameBoolSignalTable | IScriptable | orphans.swift |
| gameHighLevelStateDataEvent | Event | orphans.swift |
| GameplayLogicPackage_Record | TweakDBRecord | orphans.swift |
| ContinuousAttackEffector_Record | ContinuousEffector_Record | orphans.swift |
| StatusEffectAIData_Record | TweakDBRecord | orphans.swift |
| StatusEffectPlayerData_Record | TweakDBRecord | orphans.swift |
| StatusEffectVariation_Record | TweakDBRecord | orphans.swift |
| AnimFeature_NPCState | AnimFeature | orphans.swift |
| InfluenceComponent | IPlacedComponent | orphans.swift |
| TransformHistoryComponent | IComponent | orphans.swift |
| TargetingComponent | IPlacedComponent | orphans.swift |
| AreaShapeComponent | IPlacedComponent | orphans.swift |
| TriggerComponent | AreaShapeComponent | orphans.swift |
| AnimFeature_SecurityTurretData | AnimFeature | orphans.swift |
| RemoveFromChainRequest | ScriptableSystemRequest | orphans.swift |
| PendingSecuritySystemDisable | Event | orphans.swift |
| MinigameAction_Record | ObjectAction_Record | orphans.swift |
| SecurityTurretOffline | Event | orphans.swift |
| DeviceReplicatedState | IScriptable | orphans.swift |
| SecurityTurretReplicatedState | DeviceReplicatedState | orphans.swift |
| GrabReferenceToWeaponEvent | Event | orphans.swift |
| AnimTargetAddEvent | Event | orphans.swift |
| IVelocityProvider | IScriptable | orphans.swift |
| MoveComponentVelocityProvider | IVelocityProvider | orphans.swift |
| LookAtAddEvent | AnimTargetAddEvent | orphans.swift |
| entSpawnEffectEvent | Event | orphans.swift |
| TriggerMode_Record | TweakDBRecord | orphans.swift |
| entKillEffectEvent | Event | orphans.swift |
| entBreakEffectLoopEvent | Event | orphans.swift |
| DebugVisualizerSystem | gameIDebugVisualizerSystem | orphans.swift |
| RangedAttackPackage_Record | TweakDBRecord | orphans.swift |
| RangedAttack_Record | TweakDBRecord | orphans.swift |
| ToggleVisibilityInAnimSystemEvent | Event | orphans.swift |
| CameraSystem | ICameraSystem | orphans.swift |
| AIAttackAttemptEvent | Event | orphans.swift |
| AmmoStateChangeEvent | Event | orphans.swift |
| AIPattern_Record | TweakDBRecord | orphans.swift |
| AIPatternDelay_Record | TweakDBRecord | orphans.swift |
| AIPatternsPackage_Record | TweakDBRecord | orphans.swift |
| ArchetypeData_Record | TweakDBRecord | orphans.swift |
| TurretShootingIntervalEvent | Event | orphans.swift |
| TankObject | VehicleObject | orphans.swift |
| TurretBurstShootingDelayEvent | Event | orphans.swift |
| UnregisterListenerOnTargetHPEvent | Event | orphans.swift |
| AttitudeGroup_Record | TweakDBRecord | orphans.swift |
| AttitudeSystem | gameIAttitudeManager | orphans.swift |
| SoundStopEvent | Event | orphans.swift |
| AnimFeature_SensorDevice | AnimFeature | orphans.swift |
| FPPCameraComponent | CameraComponent | orphans.swift |
| TCSTakeOverControlActivate | Event | orphans.swift |
| PreventionCombatStartedRequest | ScriptableSystemRequest | orphans.swift |
| AutoKillDelayEvent | Event | orphans.swift |
| EvaluateGameplayRoleEvent | Event | orphans.swift |
| gameDamageReceivedEvent | Event | orphans.swift |
| DamageInflictedEvent | Event | orphans.swift |
| SetScanningBlockedEvent | Event | orphans.swift |
| gameEvaluateLootQualityEvent | Event | orphans.swift |
| StimRequest | IScriptable | orphans.swift |
| RecurrentStimuliEvent | Event | orphans.swift |
| BroadcastEvent | Event | orphans.swift |
| LookAtPreset_Record | TweakDBRecord | orphans.swift |
| ProjectileComponent | IPlacedComponent | orphans.swift |
| gameprojectileTrajectoryParams | IScriptable | orphans.swift |
| gameprojectileCollisionEvaluator | IScriptable | orphans.swift |
| SimpleColliderComponent | IPlacedComponent | orphans.swift |
| Grenade_Record | Gadget_Record | orphans.swift |
| AnimFeature_Throwable | AnimFeature | orphans.swift |
| gameprojectileSetUpEvent | Event | orphans.swift |
| GrenadeDeliveryMethodType_Record | TweakDBRecord | orphans.swift |
| CollisionEvaluatorParams | IScriptable | orphans.swift |
| HomingGDM_Record | GrenadeDeliveryMethod_Record | orphans.swift |
| gameprojectileShootEvent | gameprojectileSetUpEvent | orphans.swift |
| GrenadeMappinData | MappinScriptData | orphans.swift |
| Attack_GameEffect | IAttack | orphans.swift |
| CuttingGrenadeSpawnBlinkEffectEvent | Event | orphans.swift |
| GrenadeDetonateRequestEvent | Event | orphans.swift |
| gameprojectileHitEvent | Event | orphans.swift |
| ICooldownSystem | IGameSystem | orphans.swift |
| RenderingSystem | IScriptable | orphans.swift |
| GrenadeStopDrillingRequestEvent | Event | orphans.swift |
| SpatialQueriesSystem | gameISpatialQueriesSystem | orphans.swift |
| GeometryDescriptionSystem | IScriptable | orphans.swift |
| GeometryDescriptionResult | IScriptable | orphans.swift |
| gameprojectileTickEvent | Event | orphans.swift |
| SenseManager | ISenseManager | orphans.swift |
| VisionBlockersRegistrar | IScriptable | orphans.swift |
| ParabolicTrajectoryParams | gameprojectileTrajectoryParams | orphans.swift |
| GrenadeDespawnRequestEvent | Event | orphans.swift |
| GrenadeSetTargetTrackerStateEvent | Event | orphans.swift |
| AccelerateTowardsTrajectoryParams | gameprojectileTrajectoryParams | orphans.swift |
| AccelerateTowardsParameters_Record | TweakDBRecord | orphans.swift |
| Affiliation_Record | TweakDBRecord | orphans.swift |
| GrenadeTriggerSmartTrajectoryEvent | Event | orphans.swift |
| CuttingGrenadeAddAxisRotationEvent | Event | orphans.swift |
| CuttingGrenadeStopAttackEvent | Event | orphans.swift |
| SpawnLaserAttackEvent | Event | orphans.swift |
| StimType_Record | TweakDBRecord | orphans.swift |
| AnimFeature_CombatGadget | AnimFeature | orphans.swift |
| IVisionBlockerShape | IScriptable | orphans.swift |
| VisionBlockerShape_BasicHemisphere | IVisionBlockerShape | orphans.swift |
| GrenadeAnimFeatureChangeEvent | Event | orphans.swift |
| GrenadeReleaseRequestEvent | Event | orphans.swift |
| StatusEffectAttackData_Record | TweakDBRecord | orphans.swift |
| GrenadeTrackerTargetAcquiredEvent | Event | orphans.swift |
| GrenadeTrackerTargetLostEvent | Event | orphans.swift |
| TurnONTurretAfterDuration | Event | orphans.swift |
| UpdateInputHintEvent | Event | orphans.swift |
| TurnOnVisibilitySenseComponent | Event | orphans.swift |
| SetThreatsPersistenceRequest | AIEvent | orphans.swift |
| AIThreatPersistenceSource_Record | TweakDBRecord | orphans.swift |
| AnimFeature_EquipUnequipItem | AnimFeature | orphans.swift |
| SubCharacter_Record | Character_Record | orphans.swift |
| CompanionSystem | ICompanionSystem | orphans.swift |
| EquipSlot_Record | TweakDBRecord | orphans.swift |
| EquipRequest | PlayerScriptableSystemRequest | orphans.swift |
| RandomVariant_Record | TweakDBRecord | orphans.swift |
| ClothingSet | IScriptable | orphans.swift |
| ResetItemAppearanceEvent | Event | orphans.swift |
| UnderwearEquipFailsafeEvent | Event | orphans.swift |
| EquipmentSystemWeaponManipulationRequest | PlayerScriptableSystemRequest | orphans.swift |
| ConfigVarListener | IScriptable | orphans.swift |
| ConfigVar | IScriptable | orphans.swift |
| UserSettings | IScriptable | orphans.swift |
| ConfigGroup | IScriptable | orphans.swift |
| InventoryManager | IInventoryManager | orphans.swift |
| inkMenuInstance_SpawnEvent | Event | orphans.swift |
| inkMenuInstance_SpawnAddressedEvent | inkMenuInstance_SpawnEvent | orphans.swift |
| StatusEffectEvent | Event | orphans.swift |
| DPadUIData_Record | TweakDBRecord | orphans.swift |
| EquipmentManipulationRequest | IScriptable | orphans.swift |
| PSMPostponedParameterScriptable | PSMPostponedParameterBase | orphans.swift |
| PSMAddOnDemandStateMachine | Event | orphans.swift |
| EquipmentInitData | IScriptable | orphans.swift |
| AudioNotifyItemUnequippedEvent | Event | orphans.swift |
| AutocraftEndCycleRequest | ScriptableSystemRequest | orphans.swift |
| AutocraftDeactivateRequest | ScriptableSystemRequest | orphans.swift |
| RegisterItemUsedRequest | ScriptableSystemRequest | orphans.swift |
| AutocraftActivateRequest | ScriptableSystemRequest | orphans.swift |
| AddSubCharacterRequest | ScriptableSystemRequest | orphans.swift |
| RemoveSubCharacterRequest | ScriptableSystemRequest | orphans.swift |
| SubCharEquipRequest | EquipRequest | orphans.swift |
| UnequipRequest | PlayerScriptableSystemRequest | orphans.swift |
| SubCharUnequipRequest | UnequipRequest | orphans.swift |
| SpawnUniqueSubCharacterRequest | ScriptableSystemRequest | orphans.swift |
| SpawnUniquePursuitSubCharacterRequest | ScriptableSystemRequest | orphans.swift |
| DespawnUniqueSubCharacterRequest | ScriptableSystemRequest | orphans.swift |
| SmartDespawnRequest | Event | orphans.swift |
| CancelSmartDespawnRequest | Event | orphans.swift |
| RestrictMovementAreaManager | IRestrictMovementAreaManager | orphans.swift |
| AIActionCooldown_Record | TweakDBRecord | orphans.swift |
| AIRingType_Record | TweakDBRecord | orphans.swift |
| AIOptimalDistanceCond_Record | AIActionSubCondition_Record | orphans.swift |
| MovementPolicy_Record | TweakDBRecord | orphans.swift |
| PullSquadSyncRequest | AIEvent | orphans.swift |
| NotifySecuritySystemCombatEvent | Event | orphans.swift |
| NotifyNearbyAboutCombatEvent | Event | orphans.swift |
| PreloadAnimationsEvent | Event | orphans.swift |
| GameplayAbility_Record | TweakDBRecord | orphans.swift |
| RegisterNPCRequest | ScriptableSystemRequest | orphans.swift |
| AIMoveCommand | AICommand | orphans.swift |
| DodgeToAvoidCombatEvent | Event | orphans.swift |
| AIHoldPositionCommand | AIMoveCommand | orphans.swift |
| StanceStateChangeEvent | Event | orphans.swift |
| VehicleExternalWindowRequestEvent | Event | orphans.swift |
| DisableAimAssist | Event | orphans.swift |
| ReprimandAgentDisconnectEvent | Event | orphans.swift |
| ForceReactivateHighlightsEvent | Event | orphans.swift |
| EnableAimAssist | Event | orphans.swift |
| SensorObjectComponent | IPlacedComponent | orphans.swift |
| AISlotCond_Record | AIItemCond_Record | orphans.swift |
| NPCEquipmentItemPool_Record | NPCEquipmentGroupEntry_Record | orphans.swift |
| NPCEquipmentItemsPoolEntry_Record | TweakDBRecord | orphans.swift |
| NPCEquipmentGroup_Record | TweakDBRecord | orphans.swift |
| NPCEquipmentItem_Record | NPCEquipmentGroupEntry_Record | orphans.swift |
| AIAbilityCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIStatusEffectCond_Record | AIActionSubCondition_Record | orphans.swift |
| AISignalCond_Record | AIActionSubCondition_Record | orphans.swift |
| AISpatialCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIMovementCond_Record | AIActionSubCondition_Record | orphans.swift |
| MovePoliciesComponent | IComponent | orphans.swift |
| MovePolicies | IScriptable | orphans.swift |
| AICommandCond_Record | AIActionSubCondition_Record | orphans.swift |
| AISquadCond_Record | AIActionSubCondition_Record | orphans.swift |
| AISquadAvoidLastFilter_Record | AITicketFilter_Record | orphans.swift |
| AISquadFilterByAICondition_Record | AITicketFilter_Record | orphans.swift |
| AISquadInSectorFilter_Record | AITicketFilter_Record | orphans.swift |
| AITacticTicket_Record | AITicket_Record | orphans.swift |
| AISectorType_Record | TweakDBRecord | orphans.swift |
| CombatAlley | IScriptable | orphans.swift |
| AISquadJustSelfFilter_Record | AITicketFilter_Record | orphans.swift |
| AISquadSpatialForOwnTarget_Record | AITicketFilter_Record | orphans.swift |
| AISquadFilterOwnTargetSpotted_Record | AITicketFilter_Record | orphans.swift |
| AISquadItemTypePriorityFilter_Record | AISquadItemPriorityFilter_Record | orphans.swift |
| AISquadItemCategoryPriorityFilter_Record | AISquadItemPriorityFilter_Record | orphans.swift |
| AISquadORCondition_Record | AITicketCheck_Record | orphans.swift |
| AISquadANDCondition_Record | AITicketCheck_Record | orphans.swift |
| AISquadMembersAmountCheck_Record | AITicketCheck_Record | orphans.swift |
| AISquadContainsSelfCheck_Record | AITicketCheck_Record | orphans.swift |
| AIStatPoolCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIAmmoCountCond_Record | AIActionSubCondition_Record | orphans.swift |
| WeakspotComponent | IComponent | orphans.swift |
| AIWeakSpotCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIVehicleCond_Record | AIActionSubCondition_Record | orphans.swift |
| VehicleDataPackage_Record | TweakDBRecord | orphans.swift |
| VehicleSeatSet_Record | TweakDBRecord | orphans.swift |
| VehicleSeat_Record | TweakDBRecord | orphans.swift |
| AITresspassingCond_Record | AIActionSubCondition_Record | orphans.swift |
| SafeAreaManager | ISafeAreaManager | orphans.swift |
| AIRestrictedMovementAreaCond_Record | AIActionSubCondition_Record | orphans.swift |
| AICalculatePathCond_Record | AIActionSubCondition_Record | orphans.swift |
| NavigationPath | IScriptable | orphans.swift |
| NavigationFindWallResult | IScriptable | orphans.swift |
| AICalculateLineOfSightVector_Record | AIActionSubCondition_Record | orphans.swift |
| AIReactionCond_Record | AIActionSubCondition_Record | orphans.swift |
| AILookAtCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIStateCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIIsOnNavmeshCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIExtendTargetCirclingCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIPreviousAttackCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIRelatedComponents | ScriptableComponent | orphans.swift |
| AIMandatoryComponents | AIRelatedComponents | orphans.swift |
| IStatsListener | IScriptable | orphans.swift |
| AnimFeature_HitReactionsData | AnimFeature | orphans.swift |
| HitShapeUserData | IScriptable | orphans.swift |
| ToggleHitShapeEvent | Event | orphans.swift |
| ResetFrameDamage | Event | orphans.swift |
| WoundedInstigated | Event | orphans.swift |
| DismembermentInstigated | Event | orphans.swift |
| ActionHitReactionScriptProxy | CActionScriptProxy | orphans.swift |
| ItemAddedToSlotBase | Event | orphans.swift |
| NPCType_Record | TweakDBRecord | orphans.swift |
| RagdollActivationRequestEvent | Event | orphans.swift |
| RagdollApplyImpulseEvent | Event | orphans.swift |
| HitReactionCumulativeDamageUpdate | Event | orphans.swift |
| HitReactionRequest | Event | orphans.swift |
| ForcedHitReactionEvent | Event | orphans.swift |
| NPCRevealedPrereqState | PrereqState | orphans.swift |
| NPCHitReactionTypePrereqState | PrereqState | orphans.swift |
| AddOrRemoveListenerEvent | Event | orphans.swift |
| ResetNPCHitReactionTypePrereqStateEvent | Event | orphans.swift |
| NPCHitSourcePrereqState | PrereqState | orphans.swift |
| NPCTrackingPlayerPrereqState | PrereqState | orphans.swift |
| ForcedDeathEvent | Event | orphans.swift |
| LastHitDataEvent | Event | orphans.swift |
| NewHitDataEvent | Event | orphans.swift |
| AttackDirection_Record | TweakDBRecord | orphans.swift |
| MeleeAttackDirection_Record | TweakDBRecord | orphans.swift |
| DismembermentDebrisEvent | Event | orphans.swift |
| DismembermentEvent | Event | orphans.swift |
| DismembermentAudioEvent | Event | orphans.swift |
| DismembermentExplosionEvent | Event | orphans.swift |
| RequestDismembermentEvent | AIEvent | orphans.swift |
| PlayOnePunchVFX | Event | orphans.swift |
| PlayGrandFinaleVFX | Event | orphans.swift |
| ClearHitStimEvent | Event | orphans.swift |
| AIBlockCountCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIDodgeCountCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIIsInActiveCameraCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIThrowCond_Record | AIActionSubCondition_Record | orphans.swift |
| FxPackage | IFxPackage | orphans.swift |
| StartGrenadeThrowQueryEvent | Event | orphans.swift |
| gameICombatQueriesSystem | IGameSystem | orphans.swift |
| AIWeaponLockedOnTargetCond_Record | AIActionSubCondition_Record | orphans.swift |
| AICoverCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIGoToCoverCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIValidCoversCond_Record | AIActionSubCondition_Record | orphans.swift |
| MultiSelectCovers | IScriptable | orphans.swift |
| AIHitCond_Record | AIActionSubCondition_Record | orphans.swift |
| AITargetCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIAdditionalTraceType_Record | TweakDBRecord | orphans.swift |
| AITargetInUnmountingRangeCond_Record | AIActionSubCondition_Record | orphans.swift |
| PreventionUnitSpawnedRequest | ScriptableSystemRequest | orphans.swift |
| PreventionUnitDespawnedRequest | ScriptableSystemRequest | orphans.swift |
| PreventionHeatTable_Record | TweakDBRecord | orphans.swift |
| PreventionDamageRequest | ScriptableSystemRequest | orphans.swift |
| AIVehicleCommand | AICommand | orphans.swift |
| AIVehicleDriveToPointAutonomousCommand | AIVehicleCommand | orphans.swift |
| AICommandEvent | AIEvent | orphans.swift |
| AIVehicleDrivePatrolCommand | AIVehicleCommand | orphans.swift |
| AIVehicleChaseCommand | AIVehicleCommand | orphans.swift |
| RefreshDeescalationTimers | ScriptableSystemRequest | orphans.swift |
| AICombatRelatedCommand | AICommand | orphans.swift |
| AIInjectCombatThreatCommand | AICombatRelatedCommand | orphans.swift |
| AITargetStandingOnTopOfMovingVehicleCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIMovingInCirclesCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIEverPerformedChase_Record | AIActionSubCondition_Record | orphans.swift |
| AIAssignedVehicleCanReachTargetCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIVehicleInsideInnerAreaOfAreaSpeedLimiter_Record | AIActionSubCondition_Record | orphans.swift |
| AIAssignedVehicleInPanicDriving_Record | AIActionSubCondition_Record | orphans.swift |
| AIAssignedVehicleInRace_Record | AIActionSubCondition_Record | orphans.swift |
| RacingSystem | IRacingSystem | orphans.swift |
| AIWorkspotCond_Record | AIActionSubCondition_Record | orphans.swift |
| WorkspotEntryData | IScriptable | orphans.swift |
| AISecurityCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIActionSecurityAreaType_Record | TweakDBRecord | orphans.swift |
| AIHasWeapon_Record | AIActionSubCondition_Record | orphans.swift |
| AINPCTypeCond_Record | AIActionSubCondition_Record | orphans.swift |
| AILoSPositionCond_Record | AIActionSubCondition_Record | orphans.swift |
| ILoSFinderSystem | IGameSystem | orphans.swift |
| AIVelocityCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIVelocityDotCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIVelocitiesDotCond_Record | AIActionSubCondition_Record | orphans.swift |
| AITargetInPreventionFreeArea_Record | AIActionSubCondition_Record | orphans.swift |
| AIGameDifficultyCond_Record | AIActionSubCondition_Record | orphans.swift |
| AINPCDifficultyCond_Record | AIActionSubCondition_Record | orphans.swift |
| AINPCRarityCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIPercentageChanceCond_Record | AIActionSubCondition_Record | orphans.swift |
| VisibleObjectComponent | IPlacedComponent | orphans.swift |
| LoSFinderParams | IScriptable | orphans.swift |
| CombatGadgetDataDef | BlackboardDefinition | orphans.swift |
| SetScriptExecutionContextEvent | Event | orphans.swift |
| BehaviorDelegate | BehaviorBlackboard | orphans.swift |
| ScriptBehaviorDelegate | BehaviorDelegate | orphans.swift |
| AIActionSelector_Record | AINode_Record | orphans.swift |
| AIActionSequence_Record | AINode_Record | orphans.swift |
| AIActionSmartComposite_Record | AIRecord_Record | orphans.swift |
| AISubActionRandomize_Record | AISubAction_Record | orphans.swift |
| AISmartCompositeType_Record | TweakDBRecord | orphans.swift |
| CommandSignal | TaggedSignalUserData | orphans.swift |
| AnimParamsEvent | Event | orphans.swift |
| CoverCommandParams | IScriptable | orphans.swift |
| AISubActionCover_Record | AISubAction_Record | orphans.swift |
| AIExposureMethodType_Record | TweakDBRecord | orphans.swift |
| inkAnimProxy | IScriptable | orphans.swift |
| inkAnimInterpolator | IScriptable | orphans.swift |
| inkAnimDef | IScriptable | orphans.swift |
| inkAnimTransparency | inkAnimInterpolator | orphans.swift |
| inkLeafWidget | inkWidget | orphans.swift |
| inkIconReference | IScriptable | orphans.swift |
| UIIconReference | inkIconReference | orphans.swift |
| inkImage | inkLeafWidget | orphans.swift |
| inkAnimSize | inkAnimInterpolator | orphans.swift |
| BossCombatNotifier | Event | orphans.swift |
| ThreatDefeated | AIEvent | orphans.swift |
| ThreatUnconscious | AIEvent | orphans.swift |
| ThreatDeath | AIEvent | orphans.swift |
| ThreatRemoved | AIEvent | orphans.swift |
| ThreatInvalid | AIEvent | orphans.swift |
| gameTargetHitEvent | gameHitEvent | orphans.swift |
| HostLeftSquad | AIEvent | orphans.swift |
| OnSquadmateDied | Event | orphans.swift |
| RemoveLinkedStatusEffectsEvent | Event | orphans.swift |
| HostileThreatDetected | AIEvent | orphans.swift |
| PlayerHostileThreatDetected | HostileThreatDetected | orphans.swift |
| NewThreat | AIEvent | orphans.swift |
| EnemyThreatDetected | AIEvent | orphans.swift |
| Rule_Record | TweakDBRecord | orphans.swift |
| Output_Record | TweakDBRecord | orphans.swift |
| DetectionRiseEvent | SenseVisibilityEvent | orphans.swift |
| OnBeingNoticed | Event | orphans.swift |
| SenseEnabledEvent | Event | orphans.swift |
| ReevaluateDetectionOverwriteEvent | Event | orphans.swift |
| AddToBlacklistEvent | Event | orphans.swift |
| RemoveFromBlacklistEvent | Event | orphans.swift |
| OnRemoveDetection | Event | orphans.swift |
| AttitudeChangedEvent | Event | orphans.swift |
| SuspiciousObjectEvent | Event | orphans.swift |
| SensorOwnerChangedEvent | Event | orphans.swift |
| HACK_UseSensePresetEvent | Event | orphans.swift |
| CancelDeviceUpdateEvent | Event | orphans.swift |
| TickableEvent | Event | orphans.swift |
| DeviceUpdateEvent | TickableEvent | orphans.swift |
| RequestTakeControl | ScriptableSystemRequest | orphans.swift |
| LockReleaseOnHit | ScriptableSystemRequest | orphans.swift |
| TeleportationFacility | gameITeleportationFacility | orphans.swift |
| DeviceStartPlayerCameraControlEvent | Event | orphans.swift |
| TCSUpdate | ScriptableSystemRequest | orphans.swift |
| FillTakeOverChainBBoardEvent | Event | orphans.swift |
| ActivateTPPRepresentationEvent | Event | orphans.swift |
| VehicleCameraManager | IScriptable | orphans.swift |
| DeactivateTPPRepresentationEvent | Event | orphans.swift |
| ReturnToDeviceScreenEvent | Event | orphans.swift |
| TCSInputXAxisEvent | Event | orphans.swift |
| TCSInputYAxisEvent | Event | orphans.swift |
| TCSInputDeviceAttack | Event | orphans.swift |
| RefreshQuickhackMenuEvent | Event | orphans.swift |
| RazerChromaEffectsSystem | IRazerChromaEffectsSystem | orphans.swift |
| DeleteInputHintBySourceEvent | Event | orphans.swift |
| TCSInputXYAxisEvent | Event | orphans.swift |
| ReactoToPreventionSystem | Event | orphans.swift |
| SetJammedEvent | Event | orphans.swift |
| DisableAreaIndicatorEvent | Event | orphans.swift |
| TargetLockedEvent | Event | orphans.swift |
| SensePreset_Record | TweakDBRecord | orphans.swift |
| OnDetectedEvent | SenseVisibilityEvent | orphans.swift |
| LostTargetDelayFalsePositivesDelay | Event | orphans.swift |
| ISenseShape | IScriptable | orphans.swift |
| SenseCone | ISenseShape | orphans.swift |
| SecuritySystemSupport | Event | orphans.swift |
| SecuritySystemForceAttitudeChange | ScriptableDeviceAction | orphans.swift |
| HostileUpdateTowardsPlayerHostiles | Event | orphans.swift |
| NetworkLinkQuickhackEvent | Event | orphans.swift |
| GameFeatureManager | IScriptable | orphans.swift |
| SceneSystem | ISceneSystem | orphans.swift |
| SceneSystemInterface | IScriptable | orphans.swift |
| DelayedCrowdReactionEvent | Event | orphans.swift |
| HandleReactionEvent | Event | orphans.swift |
| StimPriority_Record | TweakDBRecord | orphans.swift |
| ResetLookatReactionEvent | Event | orphans.swift |
| DelayStimEvent | Event | orphans.swift |
| ResetReactionEvent | Event | orphans.swift |
| CleanEnvironmentalHazardEvent | Event | orphans.swift |
| AnimFeature_Undead | AnimFeature | orphans.swift |
| EndLookatEvent | Event | orphans.swift |
| DisableUndeadAnimFeatureEvent | Event | orphans.swift |
| SecuritySystemOutputTaskData | ScriptTaskData | orphans.swift |
| PreventionVisibilityRequest | ScriptableSystemRequest | orphans.swift |
| LookedAtEvent | Event | orphans.swift |
| IgnoreListEvent | Event | orphans.swift |
| ReprimandEscalationEvent | Event | orphans.swift |
| ReactionBehaviorStatus | Event | orphans.swift |
| AnimFeature_FacialReaction | AnimFeature | orphans.swift |
| StimThresholdEvent | Event | orphans.swift |
| StealthStimThresholdEvent | Event | orphans.swift |
| BodyInvestigatedEvent | Event | orphans.swift |
| ResetFacialEvent | Event | orphans.swift |
| ExitWorkspotSequenceEvent | Event | orphans.swift |
| DeescalateFearInVehicle | Event | orphans.swift |
| AnimFeature_CrowdRunningAway | AnimFeature | orphans.swift |
| TriggerDelayedReactionEvent | DelayedCrowdReactionEvent | orphans.swift |
| CrowdSettingsEvent | Event | orphans.swift |
| RegisterFleeingNPC | ScriptableSystemRequest | orphans.swift |
| UnregisterFleeingNPC | ScriptableSystemRequest | orphans.swift |
| RegisterPoliceCaller | ScriptableSystemRequest | orphans.swift |
| UnregisterPoliceCaller | ScriptableSystemRequest | orphans.swift |
| StalkEvent | Event | orphans.swift |
| DisturbingComfortZone | Event | orphans.swift |
| CheckComfortZoneEvent | Event | orphans.swift |
| RepeatLookatEvent | Event | orphans.swift |
| AddInvestigatorEvent | Event | orphans.swift |
| SetBodyPositionEvent | Event | orphans.swift |
| PresetMapper_Record | TweakDBRecord | orphans.swift |
| VisibleObject | IScriptable | orphans.swift |
| VisibleObjectDetectionMultEvent | Event | orphans.swift |
| UnregisterAggressiveCrowd | Event | orphans.swift |
| SetAggressiveMask | Event | orphans.swift |
| ReactionChangeRequestEvent | Event | orphans.swift |
| CrosswalkEvent | Event | orphans.swift |
| BumpEvent | Event | orphans.swift |
| PlayerProximityStartEvent | Event | orphans.swift |
| ProximityLookatEvent | Event | orphans.swift |
| VehicleHijackEvent | Event | orphans.swift |
| SwapPresetEvent | Event | orphans.swift |
| DistrurbComfortZoneAggressiveEvent | Event | orphans.swift |
| PreventionSearchingStatusRequest | ScriptableSystemRequest | orphans.swift |
| RadioDelayedRequest | ScriptableSystemRequest | orphans.swift |
| DistrictEnteredEvent | ScriptableSystemRequest | orphans.swift |
| PlayerEnteredNewDistrictEvent | Event | orphans.swift |
| RefreshDistrictRequest | ScriptableSystemRequest | orphans.swift |
| PoliceRadioSystem | IPoliceRadioSystem | orphans.swift |
| PreventionSystemUpdateHackLoopStateEvent | ScriptableSystemRequest | orphans.swift |
| RemoveLinkEvent | Event | orphans.swift |
| SaveLockRequest | ScriptableSystemRequest | orphans.swift |
| DelayedStopVehicle | ScriptableSystemRequest | orphans.swift |
| PreventionSystemPlayerCarHackTimeOutEvent | ScriptableSystemRequest | orphans.swift |
| HackTargetEvent | Event | orphans.swift |
| PreventionSystemPlayerCarHackFinishedEvent | ScriptableSystemRequest | orphans.swift |
| DelayedForceAboutToExplodeStateRequest | ScriptableSystemRequest | orphans.swift |
| HackLoopReportPlayerLocationRequest | ScriptableSystemRequest | orphans.swift |
| PreventionTransitionToGreyStateTimerRequest | ScriptableSystemRequest | orphans.swift |
| DistrictPreventionData_Record | TweakDBRecord | orphans.swift |
| PreventionStarStateBufferTimerRequest | ScriptableSystemRequest | orphans.swift |
| PreventionHeatDataMatrix_Record | TweakDBRecord | orphans.swift |
| SPreventionAgentData | IScriptable | orphans.swift |
| MinimapSystem | IMinimapSystem | orphans.swift |
| ReserveAssignedSeat | Event | orphans.swift |
| SetControllerLightColorRequest | ScriptableSystemRequest | orphans.swift |
| GamepadLightController | IGamepadLightController | orphans.swift |
| LerpToColorControllerLightRequest | ScriptableSystemRequest | orphans.swift |
| ColorLerpTickRequest | ScriptableSystemRequest | orphans.swift |
| PoliceSirenTimerRequest | ScriptableSystemRequest | orphans.swift |
| VehicleAboutToExplodeTimerRequest | ScriptableSystemRequest | orphans.swift |
| RequestDeviceWidgetsUpdateEvent | RequestWidgetUpdateEvent | orphans.swift |
| HighlightConnectionsRequest | ScriptableSystemRequest | orphans.swift |
| HighlightConnectionComponentEvent | Event | orphans.swift |
| NotifyHighlightedDevice | Event | orphans.swift |
| SetAsQuestImportantEvent | Event | orphans.swift |
| ForwardAction | Event | orphans.swift |
| SequencerLock | Event | orphans.swift |
| SequenceCallback | Event | orphans.swift |
| SetGameplayObjectiveStateRequest | ScriptableSystemRequest | orphans.swift |
| JournalEntry | IScriptable | orphans.swift |
| JournalContainerEntry | JournalEntry | orphans.swift |
| JournalFileEntry | JournalContainerEntry | orphans.swift |
| JournalQuestObjectiveBase | JournalContainerEntry | orphans.swift |
| JournalQuest | JournalFileEntry | orphans.swift |
| JournalQuestObjective | JournalQuestObjectiveBase | orphans.swift |
| JournalPhoneConversation | JournalContainerEntry | orphans.swift |
| JournalContact | JournalFileEntry | orphans.swift |
| JournalQuestCodexLink | JournalEntry | orphans.swift |
| ContactData | IScriptable | orphans.swift |
| JournalPhoneMessage | JournalEntry | orphans.swift |
| JournalPhoneChoiceEntry | JournalEntry | orphans.swift |
| JournalQuestMapPinBase | JournalContainerEntry | orphans.swift |
| JournalCodexEntry | JournalContainerEntry | orphans.swift |
| JournalCodexGroup | JournalContainerEntry | orphans.swift |
| JournalCodexCategory | JournalFileEntry | orphans.swift |
| GenericCodexEntryData | IScriptable | orphans.swift |
| JournalOnscreensStructuredGroup | IScriptable | orphans.swift |
| ShardEntryData | GenericCodexEntryData | orphans.swift |
| JournalOnscreen | JournalEntry | orphans.swift |
| VirutalNestedListData | IScriptable | orphans.swift |
| CodexEntryData | GenericCodexEntryData | orphans.swift |
| JournalCodexDescription | JournalEntry | orphans.swift |
| JournalOnscreenGroup | JournalFileEntry | orphans.swift |
| ListItemData | IScriptable | orphans.swift |
| JournalRepresentationData | ListItemData | orphans.swift |
| JournalQuestDescription | JournalEntry | orphans.swift |
| RegisterGameplayObjectiveRequest | ScriptableSystemRequest | orphans.swift |
| MovingPlatform | IPlacedComponent | orphans.swift |
| LiftSetMovementStateEvent | Event | orphans.swift |
| AnimFastForwardEvent | Event | orphans.swift |
| LiftStartDelayEvent | Event | orphans.swift |
| LiftDepartedEvent | Event | orphans.swift |
| ElevatorDeviceBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| AnimFeatureMarkUnstable | AnimFeature | orphans.swift |
| AnimFeature_SimpleDevice | AnimFeatureMarkUnstable | orphans.swift |
| TeleportTo | Event | orphans.swift |
| IMovingPlatformMovement | IScriptable | orphans.swift |
| IMovingPlatformMovementPointToPoint | IMovingPlatformMovement | orphans.swift |
| MoveTo | Event | orphans.swift |
| MovingPlatformMovementDynamic | IMovingPlatformMovementPointToPoint | orphans.swift |
| FireFXEvent | Event | orphans.swift |
| LiftMovementLoadEvent | Event | orphans.swift |
| RefreshFloorAuthorizationDataEvent | Event | orphans.swift |
| DelayedUpdateDeviceStateEvent | Event | orphans.swift |
| PSDeviceChangedEvent | Event | orphans.swift |
| SetIsPlayerInsideLiftEvent | Event | orphans.swift |
| ScanPlayerDelayEvent | Event | orphans.swift |
| AdHocAnimationEvent | Event | orphans.swift |
| LiftArrivedEvent | Event | orphans.swift |
| ArrivedAt | Event | orphans.swift |
| RefreshPlayerAuthorizationEvent | Event | orphans.swift |
| SpawnRoadblockadeWithDelayRequest | ScriptableSystemRequest | orphans.swift |
| StrategyData_Record | TweakDBRecord | orphans.swift |
| PreventionTickRequest | ScriptableSystemRequest | orphans.swift |
| SpawnPoliceVehicleWithDelayRequest | ScriptableSystemRequest | orphans.swift |
| ResupplyVehicleTicketsRequest | ScriptableSystemRequest | orphans.swift |
| SecurityAreaResetRequest | ScriptableSystemRequest | orphans.swift |
| PreventionMinimapData_Record | TweakDBRecord | orphans.swift |
| PreventionHeatData_Record | TweakDBRecord | orphans.swift |
| PreventionVehiclePoolData_Record | TweakDBRecord | orphans.swift |
| PreventionUnitPoolData_Record | TweakDBRecord | orphans.swift |
| PointData | IScriptable | orphans.swift |
| AIVehiclePanicCommand | AIVehicleCommand | orphans.swift |
| PreventionBlinkingStatusRequest | ScriptableSystemRequest | orphans.swift |
| PreventionCrimeScoreZeroRequest | ScriptableSystemRequest | orphans.swift |
| UnlockPreventionInputRequest | ScriptableSystemRequest | orphans.swift |
| RemoveRecentAvSpawnLocationFromCacheRequest | ScriptableSystemRequest | orphans.swift |
| PreventionVehicleStolenRequest | ScriptableSystemRequest | orphans.swift |
| PreventionCrimeWitnessRequest | ScriptableSystemRequest | orphans.swift |
| PreventionSecurityAreaRequest | ScriptableSystemRequest | orphans.swift |
| PreventionPoliceSecuritySystemRequest | ScriptableSystemRequest | orphans.swift |
| TogglePreventionSystem | ScriptableSystemRequest | orphans.swift |
| InteractionManager | IInteractionManager | orphans.swift |
| PreventionConsoleInstructionRequest | ScriptableSystemRequest | orphans.swift |
| PreventionMinMaxHeatLevels | ScriptableSystemRequest | orphans.swift |
| LiftFloorSyncDataEvent | Event | orphans.swift |
| ActionRestrictionGroup_Record | TweakDBRecord | orphans.swift |
| AuthorisationNotificationEvent | Event | orphans.swift |
| ResolveSkillchecksEvent | Event | orphans.swift |
| ChangeHalfLights | Event | orphans.swift |
| ColliderComponent | IPlacedComponent | orphans.swift |
| AnimFeatureDoor | AnimFeature | orphans.swift |
| SetBusyEvent | Event | orphans.swift |
| gameTransformAnimationSkipEvent | gameTransformAnimationEvent | orphans.swift |
| gameTransformAnimationResetEvent | gameTransformAnimationPlayEvent | orphans.swift |
| OccluderEnableEvent | Event | orphans.swift |
| DoorReplicatedState | DeviceReplicatedState | orphans.swift |
| AIApproachingAreaEvent | AIEvent | orphans.swift |
| DoorTriggerDelayedEvent | Event | orphans.swift |
| AIApproachingAreaResponseEvent | Event | orphans.swift |
| PlayInDeviceCallbackEvent | Event | orphans.swift |
| StopShortGlitchEvent | Event | orphans.swift |
| ExecutePuppetActionEvent | Event | orphans.swift |
| RegisterDebuggerCanditateEvent | Event | orphans.swift |
| ResolveQuickHackRadialRequest | HUDManagerRequest | orphans.swift |
| ScaleAndLockLeftHandWeaponsCompensateInStashEvent | Event | orphans.swift |
| gameCombinedStatModifierData | gameStatModifierData | orphans.swift |
| UnifyIconicsUpgradeCountWithEffectiveTierInStashEvent | Event | orphans.swift |
| StorageUserData | IScriptable | orphans.swift |
| HotkeyRefreshRequest | PlayerScriptableSystemRequest | orphans.swift |
| ForceRadialWheelRebuild | Event | orphans.swift |
| UIVendorItemsSoldEvent | Event | orphans.swift |
| UIVendorItemsBoughtEvent | Event | orphans.swift |
| ConsumableItem_Record | Item_Record | orphans.swift |
| DeattachVendorRequest | MarketSystemRequest | orphans.swift |
| VendingMachineFinishedEvent | Event | orphans.swift |
| VendingMachineDeviceBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| DispenseRequest | MarketSystemRequest | orphans.swift |
| DispenseStackRequest | MarketSystemRequest | orphans.swift |
| TransactionRequest | MarketSystemRequest | orphans.swift |
| VendorBoughtItemEvent | Event | orphans.swift |
| BuyRequest | TransactionRequest | orphans.swift |
| DelayHackedEvent | Event | orphans.swift |
| LootManager | ILootManager | orphans.swift |
| UnregisterDropPointMappinRequest | ScriptableSystemRequest | orphans.swift |
| UpdateDropPointEvent | Event | orphans.swift |
| RegisterDropPointMappinRequest | ScriptableSystemRequest | orphans.swift |
| VendorPanelData | IScriptable | orphans.swift |
| gameAutoSaveSystem | gameIAutoSaveSystem | orphans.swift |
| PlayerCompanionCacheDataEvent | Event | orphans.swift |
| ReevaluatePresetEvent | Event | orphans.swift |
| AnimFeature_ProceduralLean | AnimFeature | orphans.swift |
| SetScanningTimeEvent | Event | orphans.swift |
| gamePotentialDeathEvent | Event | orphans.swift |
| SetBountyAwardedEvent | Event | orphans.swift |
| SetBountyObjectEvent | Event | orphans.swift |
| BountyDrawTable_Record | TweakDBRecord | orphans.swift |
| Bounty_Record | TweakDBRecord | orphans.swift |
| RewardBase_Record | TweakDBRecord | orphans.swift |
| XPPoints_Record | TweakDBRecord | orphans.swift |
| CurrencyReward_Record | TweakDBRecord | orphans.swift |
| Transgression_Record | TweakDBRecord | orphans.swift |
| ExperiencePointsEvent | Event | orphans.swift |
| BountyCompletionEvent | Event | orphans.swift |
| PlayerDetectionChangedEvent | Event | orphans.swift |
| gameEntityStubComponentPS | GameComponentPS | orphans.swift |
| ItemAddedToSlot | ItemAddedToSlotBase | orphans.swift |
| CacheItemEquippedToHandsEvent | Event | orphans.swift |
| UpdateMeleeTrailEffectEvent | Event | orphans.swift |
| ItemRemovedFromSlot | Event | orphans.swift |
| DelaySetCoverNPCCurrentlyExposed | Event | orphans.swift |
| OnBeingTarget | Event | orphans.swift |
| ForcedRagdollDeathSignal | TaggedSignalUserData | orphans.swift |
| ApplyStatusEffectEvent | StatusEffectEvent | orphans.swift |
| DefeatedEvent | Event | orphans.swift |
| AndroidTurnOff | Event | orphans.swift |
| AndroidTurnOn | Event | orphans.swift |
| NameplateVisibleEvent | Event | orphans.swift |
| AISignalHandlerComponent | IComponent | orphans.swift |
| SetSlowMoForOnePunchAttackEvent | Event | orphans.swift |
| DelayedStatusEffectApplicationEvent | Event | orphans.swift |
| UncontrolledMovementStartEvent | Event | orphans.swift |
| StatusEffectAIBehaviorFlag_Record | TweakDBRecord | orphans.swift |
| StatusEffectSignalEvent | Event | orphans.swift |
| CheckUncontrolledMovementStatusEffectEvent | Event | orphans.swift |
| RemoveStatusEffect | StatusEffectEvent | orphans.swift |
| ResurrectEvent | Event | orphans.swift |
| IncapacitatedEvent | Event | orphans.swift |
| UncontrolledMovementEndEvent | Event | orphans.swift |
| CacheStatusEffectAnimEvent | Event | orphans.swift |
| StatusEffectFX_Record | TweakDBRecord | orphans.swift |
| CacheStatusEffectFXEvent | Event | orphans.swift |
| RemoveAllStatusEffectOfTypeEvent | Event | orphans.swift |
| SpawnableObjectPriority_Record | TweakDBRecord | orphans.swift |
| CheckPuppetRagdollStateEvent | Event | orphans.swift |
| AnimVisibilityChangedEvent | Event | orphans.swift |
| AnimFeature_RagdollState | AnimFeature | orphans.swift |
| RagdollNotifyEnabledEvent | Event | orphans.swift |
| CheckDeadPuppetDisposedEvent | Event | orphans.swift |
| RagdollImpactEvent | Event | orphans.swift |
| StartRagdollDamageEvent | Event | orphans.swift |
| CleanUpThrownNPCNearbyCrowdNPCs | Event | orphans.swift |
| gameRagdollHitEvent | gameHitEvent | orphans.swift |
| AnimatedRagdollNotifyEnabledEvent | Event | orphans.swift |
| AISubActionForceHitReaction_Record | AISubAction_Record | orphans.swift |
| RagdollToggleDelayEvent | Event | orphans.swift |
| ApplyRelicMeleewareDamageOnNPCEvent | Event | orphans.swift |
| RagdollBodyPartWaterImpactEvent | Event | orphans.swift |
| ScanningLookAtEvent | Event | orphans.swift |
| StimuliData | IScriptable | orphans.swift |
| DamageInfoUserData | IScriptable | orphans.swift |
| gameTargetDamageEvent | gameTargetHitEvent | orphans.swift |
| BreachComponent | IPlacedComponent | orphans.swift |
| NPCAfterDeathOrDefeatEvent | Event | orphans.swift |
| ResetTimeDilation | Event | orphans.swift |
| DeathTaskData | ScriptTaskData | orphans.swift |
| gameDeathEvent | Event | orphans.swift |
| FinisherEffectorActionOn | Event | orphans.swift |
| TerminateReactionLookatEvent | Event | orphans.swift |
| LootPickupDelayEvent | Event | orphans.swift |
| DestroyLink | Event | orphans.swift |
| SetQuickHackAttemptEvent | Event | orphans.swift |
| HandleRagdollOnDeathEvent | Event | orphans.swift |
| ResetVehicleHijackEvent | Event | orphans.swift |
| ScannerModuleVisibilityPreset_Record | TweakDBRecord | orphans.swift |
| ArchetypeType_Record | TweakDBRecord | orphans.swift |
| AccessBreachListener | QuickHackUploadListener | orphans.swift |
| GameplayAbilityGroup_Record | TweakDBRecord | orphans.swift |
| HidePuppetDelayEvent | Event | orphans.swift |
| TestNPCOutsideNavmeshEvent | Event | orphans.swift |
| DelayedGameEffectEvent | Event | orphans.swift |
| gameDeathParamsEvent | Event | orphans.swift |
| gameDeathDirectionEvent | Event | orphans.swift |
| NPCThrowingGrenadeEvent | Event | orphans.swift |
| EnteredSplineEvent | Event | orphans.swift |
| AIThreatCalculationEvent | Event | orphans.swift |
| GameplayRoleMappinData | MappinScriptData | orphans.swift |
| QueueQuickHackEvent | Event | orphans.swift |
| linkedClueUpdateEvent | Event | orphans.swift |
| linkedClueTagEvent | Event | orphans.swift |
| TagLinkedCluekRequest | ScriptableSystemRequest | orphans.swift |
| RegisterLinkedCluekRequest | ScriptableSystemRequest | orphans.swift |
| UnregisterLinkedCluekRequest | ScriptableSystemRequest | orphans.swift |
| UpdateLinkedClueskRequest | ScriptableSystemRequest | orphans.swift |
| FocusClueStateChangeEvent | Event | orphans.swift |
| ContainerObjectSingleItem | gameContainerObjectBase | orphans.swift |
| ShardCaseAnimationEnded | Event | orphans.swift |
| inkBasePanel | inkCompoundWidget | orphans.swift |
| inkHorizontalPanel | inkBasePanel | orphans.swift |
| inkWidgetsSet | IScriptable | orphans.swift |
| DelayedDescriptionIntro | Event | orphans.swift |
| OverclockDamagePreview | Event | orphans.swift |
| inkDiscreteNavigationController | inkLogicController | orphans.swift |
| inkButtonController | inkDiscreteNavigationController | orphans.swift |
| inkAnimController | IScriptable | orphans.swift |
| inkAnimBuilder | IScriptable | orphans.swift |
| HubMenuInitData | IScriptable | orphans.swift |
| CyberwareDisplayWrapper | IScriptable | orphans.swift |
| QuickSlotCommandUsed | Event | orphans.swift |
| QhackExecuted | Event | orphans.swift |
| OnSpecialQuickhackTriggeredEvent | DelayEvent | orphans.swift |
| LockQHackInput | ScriptableSystemRequest | orphans.swift |
| ExplosiveDeviceDelayedEvent | Event | orphans.swift |
| NPCKillDelayEvent | Event | orphans.swift |
| ExplosiveDeviceHideDeviceEvent | Event | orphans.swift |
| SwapMeshDelayedEvent | Event | orphans.swift |
| NetworkMoneySiphoned | Event | orphans.swift |
| MinigameFailEvent | Event | orphans.swift |
| NPCBreachEvent | Event | orphans.swift |
| EntitySpawnerEventsBroadcaster | IEntitySpawnerEventsBroadcaster | orphans.swift |
| gameEntitySpawnerEvent | Event | orphans.swift |
| DrawNetworkSquadEvent | Event | orphans.swift |
| Validate | Event | orphans.swift |
| NetworkAreaActivationEvent | Event | orphans.swift |
| ControlledDeviceData | WidgetCustomData | orphans.swift |
| ManageAreaComponent | Event | orphans.swift |
| SecurityAreaTypeChangedNotification | Event | orphans.swift |
| RegisterTimeListeners | Event | orphans.swift |
| QuestModifyFilters | Event | orphans.swift |
| SuppressSecuritySystemReaction | Event | orphans.swift |
| SecurityGateResponse | Event | orphans.swift |
| SecurityGateForceUnlock | Event | orphans.swift |
| DeescalationEvent | Event | orphans.swift |
| InitiateScanner | Event | orphans.swift |
| RevokeAuthorization | Event | orphans.swift |
| BlacklistPeriodEnded | Event | orphans.swift |
| NotifiedSecSysAboutCombat | Event | orphans.swift |
| AutomaticDeescalationEvent | Event | orphans.swift |
| PSInitializeEvent | Event | orphans.swift |
| PSInstantiateEvent | Event | orphans.swift |
| MadnessDebuff | Event | orphans.swift |
| ModifyOverlappedSecurityAreas | Event | orphans.swift |
| PurgeAllTransitions | Event | orphans.swift |
| SecuritySystemDisabled | Event | orphans.swift |
| WakeUpFromRestartEvent | Event | orphans.swift |
| SecuritySystemEnabled | Event | orphans.swift |
| ActionForceResetDevice | ActionBool | orphans.swift |
| QuestSecuritySystemInput | Event | orphans.swift |
| RefreshPowerOnSlavesEvent | ProcessDevicesEvent | orphans.swift |
| ForceUpdateDefaultHighlightEvent | Event | orphans.swift |
| DeviceLinkEstablished | Event | orphans.swift |
| AcquireDeviceLink | Event | orphans.swift |
| UnTagAllObjectRequest | ScriptableSystemRequest | orphans.swift |
| TagStatusNotification | HUDManagerRequest | orphans.swift |
| RegisterInputListenerRequest | ScriptableSystemRequest | orphans.swift |
| UnRegisterInputListenerRequest | ScriptableSystemRequest | orphans.swift |
| InteractionChoiceEvent | InteractionBaseEvent | orphans.swift |
| AdvanceInteractionStateResolveEvent | Event | orphans.swift |
| DelayedUIRefreshEvent | Event | orphans.swift |
| InteractionResetChoicesEvent | Event | orphans.swift |
| EMPEnded | Event | orphans.swift |
| EMPHitEvent | Event | orphans.swift |
| SetUICameraZoomEvent | Event | orphans.swift |
| PhysicalMeshComponent | MeshComponent | orphans.swift |
| TimerEvent | Event | orphans.swift |
| UnmountingRequest | IScriptable | orphans.swift |
| Record1DamageInHistoryEvent | Event | orphans.swift |
| AnimFeature_AerialTakedown | AnimFeature | orphans.swift |
| ChangeRewardSettingsEvent | Event | orphans.swift |
| StopSoundDisposal | Event | orphans.swift |
| PhysicalBodyInterface | IScriptable | orphans.swift |
| GameplayRoleChangeNotification | Event | orphans.swift |
| DequeueQuickHackEvent | Event | orphans.swift |
| ShowSingleMappinEvent | Event | orphans.swift |
| HideSingleMappinEvent | Event | orphans.swift |
| gameDeviceVisibilityChangedEvent | Event | orphans.swift |
| inkCanvas | inkCompoundWidget | orphans.swift |
| UIUnstreamedEvent | Event | orphans.swift |
| DeviceUIDefinition_Record | TweakDBRecord | orphans.swift |
| PlaybackOptionsUpdateData | IScriptable | orphans.swift |
| UIRefreshedEvent | Event | orphans.swift |
| UIActionEvent | Event | orphans.swift |
| RequestActionWidgetsUpdateEvent | RequestWidgetUpdateEvent | orphans.swift |
| RequestDeviceWidgetUpdateEvent | RequestWidgetUpdateEvent | orphans.swift |
| RequestUIRefreshEvent | Event | orphans.swift |
| RequestBreadCrumbBarUpdateEvent | Event | orphans.swift |
| ChangeJuryrigTrapState | Event | orphans.swift |
| animAnimFeature_IK | AnimFeature | orphans.swift |
| AnimFeature_WorkspotIK | AnimFeature | orphans.swift |
| RepeatPersonalLinkAnimFeaturesHACK | Event | orphans.swift |
| UpdateInputHintMultipleEvent | Event | orphans.swift |
| UnregisterFromZoomBlackboardEvent | Event | orphans.swift |
| MissingWorkspotComponentFailsafeEvent | Event | orphans.swift |
| RequestDocumentWidgetUpdateEvent | RequestWidgetUpdateEvent | orphans.swift |
| RequestDocumentThumbnailWidgetsUpdateEvent | RequestWidgetUpdateEvent | orphans.swift |
| ComputerDeviceBlackboardDef | MasterDeviceBaseBlackboardDef | orphans.swift |
| gameJournalPath | IScriptable | orphans.swift |
| JournalFile | JournalEntry | orphans.swift |
| JournalEmail | JournalEntry | orphans.swift |
| ComputerStyleUIDefinition_Record | TweakDBRecord | orphans.swift |
| gameVisionModeUpdateVisuals | Event | orphans.swift |
| DelayedOperationEvent | Event | orphans.swift |
| ToggleOperationEvent | Event | orphans.swift |
| gameTransformAnimationPauseEvent | gameTransformAnimationEvent | orphans.swift |
| UpdateWillingInvestigators | Event | orphans.swift |
| AccessPointMiniGameStatus | Event | orphans.swift |
| PingNetworkGridEvent | Event | orphans.swift |
| RevealDevicesGridOnEntityEvent | Event | orphans.swift |
| ForwardPingToSquadEvent | Event | orphans.swift |
| DeviceTimetableEvent | Event | orphans.swift |
| ToggleComponentsEvent | Event | orphans.swift |
| BinkComponent | IVisualComponent | orphans.swift |
| PlayBinkEvent | Event | orphans.swift |
| CommunicationEvent | Event | orphans.swift |
| AddActiveContextEvent | Event | orphans.swift |
| RemoveActiveContextEvent | Event | orphans.swift |
| CurveStatModifier_Record | StatModifier_Record | orphans.swift |
| DemolitionSkillCheck | SkillCheckBase | orphans.swift |
| EngineeringSkillCheck | SkillCheckBase | orphans.swift |
| VehicleSeatReservationEvent | Event | orphans.swift |
| ForceExitDelamainEvent | Event | orphans.swift |
| VehicleBodyDisposalPerformedEvent | Event | orphans.swift |
| CarObject | WheeledObject | orphans.swift |
| VehicleType_Record | TweakDBRecord | orphans.swift |
| VehicleFinishedMountingEvent | Event | orphans.swift |
| VehicleStartedUnmountingEvent | Event | orphans.swift |
| TriggerVehicleRemoteControlEvent | Event | orphans.swift |
| CheckVehicleVelocityForStimsEvent | Event | orphans.swift |
| PreventionVehicleHackedEvent | Event | orphans.swift |
| VehicleHackedEvent | Event | orphans.swift |
| vehicleChangeWindowStateEvent | Event | orphans.swift |
| vehicleToggleDoorWrapperEvent | Event | orphans.swift |
| ForwardVehicleQuestEnableUIEvent | Event | orphans.swift |
| ForwardVehicleQuestUIEffectEvent | Event | orphans.swift |
| ForwardVehicleRaceUIEvent | Event | orphans.swift |
| VehicleDamageStageTurnOffEvent | Event | orphans.swift |
| VehicleExitDelayed | Event | orphans.swift |
| VehicleDefaultState_Record | TweakDBRecord | orphans.swift |
| SeatState_Record | TweakDBRecord | orphans.swift |
| VehicleSirenDelayEvent | Event | orphans.swift |
| InteractionMultipleSetEnableEvent | Event | orphans.swift |
| AnimFeature_PartData | AnimFeatureMarkUnstable | orphans.swift |
| VehicleParkedEvent | Event | orphans.swift |
| VehicleLightSetupEvent | Event | orphans.swift |
| AnimFeature_VehicleState | AnimFeatureMarkUnstable | orphans.swift |
| VehicleCrystalDomeOnDelayEvent | Event | orphans.swift |
| VehicleCrystalDomeMeshVisibilityDelayEvent | Event | orphans.swift |
| VehicleCrystalDomeOffDelayEvent | Event | orphans.swift |
| AnimFeature_CamberData | AnimFeatureMarkUnstable | orphans.swift |
| VehicleVisualDestruction_Record | TweakDBRecord | orphans.swift |
| AnimFeature_VehicleNPCData | AnimFeature | orphans.swift |
| DriverCombatType_Record | TweakDBRecord | orphans.swift |
| MountingEvent | Event | orphans.swift |
| MountingRequest | IScriptable | orphans.swift |
| ConfigVarListFloat | ConfigVar | orphans.swift |
| ConfigVarListString | ConfigVar | orphans.swift |
| MinutePassedEvent | Event | orphans.swift |
| ExecuteVehicleVisualCustomizationEvent | Event | orphans.swift |
| CheckVehicleVisialCustomizationDistanceTermination | Event | orphans.swift |
| MetroPitchAdjustmentEvent | Event | orphans.swift |
| MountEventOptions | IScriptable | orphans.swift |
| AnimFeature_VehicleSteeringLimit | AnimFeatureMarkUnstable | orphans.swift |
| RagdollDisableEvent | Event | orphans.swift |
| AnimFeature_NPCVehicleAdditionalFeatures | AnimFeatureMarkUnstable | orphans.swift |
| UnmountingEvent | Event | orphans.swift |
| vehicleController | GameComponent | orphans.swift |
| RepeatDirectEnvironmentalHazardStimEvent | Event | orphans.swift |
| VehicleQuestNodeSetVehicleRemoteControlled | Event | orphans.swift |
| PlayerVisionModeControllerInvalidateEvent | Event | orphans.swift |
| VehicleStartedMountingEvent | Event | orphans.swift |
| ActionEvent | AIEvent | orphans.swift |
| VehicleRemoteControlEvent | ActionEvent | orphans.swift |
| VehicleForceBrakesQuickhackEvent | ActionEvent | orphans.swift |
| DisableAlarmEvent | Event | orphans.swift |
| NativeAutodriveSystem | ScriptableSystem | orphans.swift |
| QuestsContentSystem | questIQuestsContentSystem | orphans.swift |
| ScriptQuestContentLockListener | IScriptable | orphans.swift |
| UpdateAutodriveStateAfterQuestLockChange | ScriptableSystemRequest | orphans.swift |
| vehicleRequestTPPCameraSoftResetEvent | Event | orphans.swift |
| SetTravelDestinationRequest | ScriptableSystemRequest | orphans.swift |
| RegisterDelamainTaxiRequest | ScriptableSystemRequest | orphans.swift |
| EnableAutoDriveRequest | ScriptableSystemRequest | orphans.swift |
| SetHUDHiddenRequest | ScriptableSystemRequest | orphans.swift |
| AIVehicleJoinTrafficCommand | AIVehicleCommand | orphans.swift |
| UnregisterCurrentTaxiRequest | ScriptableSystemRequest | orphans.swift |
| DelamainTaxiCancelledRequest | ScriptableSystemRequest | orphans.swift |
| PayTravelRequest | ScriptableSystemRequest | orphans.swift |
| StartDelamainTaxiRequest | ScriptableSystemRequest | orphans.swift |
| CancelDelamainRideRequest | ScriptableSystemRequest | orphans.swift |
| DelamainTaxiMenuToggledEvent | ScriptableSystemRequest | orphans.swift |
| CancelDriveIfNecessaryRequest | ScriptableSystemRequest | orphans.swift |
| SendAutoDriveNotificationRequest | ScriptableSystemRequest | orphans.swift |
| StopAutoDriveRequest | ScriptableSystemRequest | orphans.swift |
| UpdateAutodriveStateOnVehicleForceBrakeEnd | ScriptableSystemRequest | orphans.swift |
| DelamainTaxiArrivedRequest | ScriptableSystemRequest | orphans.swift |
| IMappin | IVisualObject | orphans.swift |
| StopAutoDriveOnDestinationReachedRequest | ScriptableSystemRequest | orphans.swift |
| UpdateAutodriveStateAfterVehicleHealthChange | ScriptableSystemRequest | orphans.swift |
| UpdateAutodriveStateOnVehicleQuickHackChange | ScriptableSystemRequest | orphans.swift |
| VehicleRammedEvent | Event | orphans.swift |
| VehicleNotifyPassengersOfCollision | Event | orphans.swift |
| TriggerPanicDrivingEvent | Event | orphans.swift |
| KnockOverBikeEvent | Event | orphans.swift |
| VehicleWaterEvent | Event | orphans.swift |
| VehicleDestruction_Record | TweakDBRecord | orphans.swift |
| VehicleGlassDestructionEvent | Event | orphans.swift |
| VehicleDestructibleGlass_Record | TweakDBRecord | orphans.swift |
| ReevaluateOxygenEvent | Event | orphans.swift |
| StealVehicleEvent | Event | orphans.swift |
| vehicleChangeStateEvent | Event | orphans.swift |
| VehicleExternalDoorRequestEvent | Event | orphans.swift |
| ToggleDoorInteractionEvent | Event | orphans.swift |
| DumpBodyWorkspotDelayEvent | Event | orphans.swift |
| VehicleDumpBodyCloseTrunkEvent | Event | orphans.swift |
| PickupBodyWorkspotDelayEvent | Event | orphans.swift |
| SummonStartedEvent | Event | orphans.swift |
| SummonFinishedEvent | Event | orphans.swift |
| VehicleGridDestructionEvent | Event | orphans.swift |
| DelayedBikeKnockOffEvent | Event | orphans.swift |
| AnimFeature_KnockOffData | AnimFeature | orphans.swift |
| VehicleOnPartDetachedEvent | Event | orphans.swift |
| UIVehicleRadioEvent | Event | orphans.swift |
| VehicleRadioSongChanged | Event | orphans.swift |
| VehicleChaseTargetEvent | Event | orphans.swift |
| UIVehicleRadioCycleEvent | Event | orphans.swift |
| RadioToggleEvent | Event | orphans.swift |
| VehicleHornOffDelayEvent | Event | orphans.swift |
| VehicleHornProbsEvent | Event | orphans.swift |
| VehicleFlippedOverEvent | Event | orphans.swift |
| NewVehicleVisualCustomizationTemplateEvent | Event | orphans.swift |
| VehicleCustomizationLightsEvent | Event | orphans.swift |
| VehicleAppearancesToColorTemplate_Record | TweakDBRecord | orphans.swift |
| VehicleForwardRaceCheckpointFactEvent | Event | orphans.swift |
| VehicleRaceClockUpdateEvent | TickableEvent | orphans.swift |
| VehicleForwardRaceClockUpdateEvent | Event | orphans.swift |
| SetIgnoreAutoDoorCloseEvent | Event | orphans.swift |
| CrowdMemberBaseComponent | CrowdMemberComponent | orphans.swift |
| DelayReactionToMissingPassengersEvent | Event | orphans.swift |
| StopAutoDriveOnTeleportRequest | ScriptableSystemRequest | orphans.swift |
| StoreVisualCustomizationDataForIDEvent | Event | orphans.swift |
| VehicleManufacturer_Record | TweakDBRecord | orphans.swift |
| VehicleUIData_Record | TweakDBRecord | orphans.swift |
| gameVehicleDestructionEvent | Event | orphans.swift |
| TrafficAudioEvent | Event | orphans.swift |
| VehicleBumpEvent | Event | orphans.swift |
| WaitForPassengersToSpawnEvent | Event | orphans.swift |
| VehicleUnableToStartPanicDriving | Event | orphans.swift |
| AutoDriveHitRequest | ScriptableSystemRequest | orphans.swift |
| SwitchVehicleVisualCustomizationStateEvent | Event | orphans.swift |
| NewVehicleVisualCustomizationEvent | Event | orphans.swift |
| QueueCombatExperience | PlayerScriptableSystemRequest | orphans.swift |
| ProcessVendettaAchievementEvent | Event | orphans.swift |
| ProjectileDelayEvent | Event | orphans.swift |
| gameprojectileSpawnerLaunchEvent | Event | orphans.swift |
| IOrientationProvider | IScriptable | orphans.swift |
| LinearTrajectoryParams | gameprojectileTrajectoryParams | orphans.swift |
| FollowCurveTrajectoryParams | gameprojectileTrajectoryParams | orphans.swift |
| ProjectileLauncherRoundDetonationDelayEvent | Event | orphans.swift |
| ObjectPoolSystem | IObjectPoolSystem | orphans.swift |
| ProjectileTickEvent | TickableEvent | orphans.swift |
| RemoveStatusEffectListenerEvent | Event | orphans.swift |
| AddStatusEffectListenerEvent | Event | orphans.swift |
| HitDebugData | IScriptable | orphans.swift |
| DamageDebugData | IScriptable | orphans.swift |
| ServerHitData | IScriptable | orphans.swift |
| ServerKillData | IScriptable | orphans.swift |
| StateScriptInterface | IScriptable | orphans.swift |
| HitPrereq_Record | IPrereq_Record | orphans.swift |
| HitPrereqCondition_Record | TweakDBRecord | orphans.swift |
| HitPrereqConditionType_Record | TweakDBRecord | orphans.swift |
| CheckType_Record | TweakDBRecord | orphans.swift |
| ReplaceEquipmentRequest | PlayerScriptableSystemRequest | orphans.swift |
| InventoryItemDataWrapper | IScriptable | orphans.swift |
| GameplayLogicPackageUIData_Record | TweakDBRecord | orphans.swift |
| AttachmentSlot_Record | TweakDBRecord | orphans.swift |
| NewPerkSoldEvent | Event | orphans.swift |
| Curve_Record | TweakDBRecord | orphans.swift |
| AddItemsEffector_Record | Effector_Record | orphans.swift |
| HideRecipeRequest | PlayerScriptableSystemRequest | orphans.swift |
| InventoryItem_Record | TweakDBRecord | orphans.swift |
| PerkResetEvent | Event | orphans.swift |
| ProgressionBuild_Record | TweakDBRecord | orphans.swift |
| ClearEquipmentRequest | PlayerScriptableSystemRequest | orphans.swift |
| BuildAttributeSet_Record | TweakDBRecord | orphans.swift |
| BuildProficiencySet_Record | TweakDBRecord | orphans.swift |
| BuildPerkSet_Record | TweakDBRecord | orphans.swift |
| InventoryItemSet_Record | TweakDBRecord | orphans.swift |
| BuildEquipmentSet_Record | TweakDBRecord | orphans.swift |
| BuildCyberwareSet_Record | TweakDBRecord | orphans.swift |
| BuildAttribute_Record | TweakDBRecord | orphans.swift |
| BuildProficiency_Record | TweakDBRecord | orphans.swift |
| BuildPerk_Record | TweakDBRecord | orphans.swift |
| BuildEquipment_Record | TweakDBRecord | orphans.swift |
| GameplayEquipRequest | PlayerScriptableSystemRequest | orphans.swift |
| DrawItemRequest | PlayerScriptableSystemRequest | orphans.swift |
| BuildCyberware_Record | TweakDBRecord | orphans.swift |
| BuildProgram_Record | TweakDBRecord | orphans.swift |
| GameplayEquipProgramsRequest | PlayerScriptableSystemRequest | orphans.swift |
| BuildNewPerk_Record | TweakDBRecord | orphans.swift |
| LifePath_Record | TweakDBRecord | orphans.swift |
| PlayerDetachRequest | PlayerScriptableSystemRequest | orphans.swift |
| ReinitializeProficiencies | PlayerScriptableSystemRequest | orphans.swift |
| NewPerkUnlockedEvent | Event | orphans.swift |
| NewPerkBoughtEvent | Event | orphans.swift |
| PerkBoughtEvent | Event | orphans.swift |
| TraitBoughtEvent | Event | orphans.swift |
| AttributeBoughtEvent | Event | orphans.swift |
| questSetProgressionBuildRequest | PlayerScriptableSystemRequest | orphans.swift |
| gameSetProgressionBuildRequest | PlayerScriptableSystemRequest | orphans.swift |
| questSetLifePathRequest | PlayerScriptableSystemRequest | orphans.swift |
| PlayerIsNewPerkBoughtPrereq_Record | IPrereq_Record | orphans.swift |
| MinimalItemTooltipRecipeData | IScriptable | orphans.swift |
| MinimalItemTooltipStatData | IScriptable | orphans.swift |
| MinimalItemTooltipModData | IScriptable | orphans.swift |
| MinimalItemTooltipModRecordData | MinimalItemTooltipModData | orphans.swift |
| MinimalItemTooltipModsAttunementData | IScriptable | orphans.swift |
| MinimalItemTooltipModAttachmentData | MinimalItemTooltipModData | orphans.swift |
| UIInventoryWeaponInternalData | IScriptable | orphans.swift |
| CraftItemRequest | PlayerScriptableSystemRequest | orphans.swift |
| DisassembleItemRequest | PlayerScriptableSystemRequest | orphans.swift |
| DisassemblingResult_Record | TweakDBRecord | orphans.swift |
| UpgradeItemRequest | PlayerScriptableSystemRequest | orphans.swift |
| ShowRecipeRequest | PlayerScriptableSystemRequest | orphans.swift |
| NCPDJobDoneEvent | Event | orphans.swift |
| ConsumableType_Record | TweakDBRecord | orphans.swift |
| RemoveConsumableDelayedEvent | Event | orphans.swift |
| ConsumableBaseName_Record | TweakDBRecord | orphans.swift |
| LearnAction | ConsumeAction | orphans.swift |
| NotifyShardRead | Event | orphans.swift |
| CrackAction_Record | ItemAction_Record | orphans.swift |
| DownloadFundsAction | BaseItemAction | orphans.swift |
| UIInventoryItemMod | IScriptable | orphans.swift |
| UIInventoryItemModDataPackage | UIInventoryItemMod | orphans.swift |
| UIInventoryItemModAttunementData | IScriptable | orphans.swift |
| UIInventoryItemModAttachment | UIInventoryItemMod | orphans.swift |
| WrappedInventoryItemData | IScriptable | orphans.swift |
| MultiPrereq_Record | IPrereq_Record | orphans.swift |
| TriggerAttackEffector_Record | Effector_Record | orphans.swift |
| DamageEffectUIEntry | IScriptable | orphans.swift |
| InventoryTooltiData_GrenadeDamageData | IScriptable | orphans.swift |
| CombinedStatModifier_Record | StatModifier_Record | orphans.swift |
| UIInventoryScriptableSystemInventoryAddItem | ScriptableSystemRequest | orphans.swift |
| UIInventoryScriptableSystemInventoryRemoveItem | ScriptableSystemRequest | orphans.swift |
| UIInventoryScriptableSystemInventoryQuantityChanged | ScriptableSystemRequest | orphans.swift |
| UIInventoryItemAdded | Event | orphans.swift |
| UIInventoryItemRemoved | Event | orphans.swift |
| SlotDataHolder | IScriptable | orphans.swift |
| SlotItemPartListElement_Record | TweakDBRecord | orphans.swift |
| ItemPartListElement_Record | TweakDBRecord | orphans.swift |
| InventoryTooltiData_GrenadeData | IScriptable | orphans.swift |
| InventoryTooltipData_CyberdeckData | IScriptable | orphans.swift |
| MessageTooltipData | ATooltipData | orphans.swift |
| TransmogMessageTooltipData | MessageTooltipData | orphans.swift |
| EquipVisualsRequest | PlayerScriptableSystemRequest | orphans.swift |
| UnequipVisualsRequest | PlayerScriptableSystemRequest | orphans.swift |
| UIInventoryItemStatComparison | IScriptable | orphans.swift |
| ClearItemAppearanceEvent | Event | orphans.swift |
| QuestDisableWardrobeSetRequest | PlayerScriptableSystemRequest | orphans.swift |
| EquipmentMovementSound_Record | TweakDBRecord | orphans.swift |
| AssignToCyberwareWheelRequest | PlayerScriptableSystemRequest | orphans.swift |
| UnequipItemsRequest | PlayerScriptableSystemRequest | orphans.swift |
| UnequipByTDBIDRequest | PlayerScriptableSystemRequest | orphans.swift |
| UIEquipmentReplacedEvent | Event | orphans.swift |
| SaveEquipmentSetRequest | PlayerScriptableSystemRequest | orphans.swift |
| LoadEquipmentSetRequest | PlayerScriptableSystemRequest | orphans.swift |
| DeleteEquipmentSetRequest | PlayerScriptableSystemRequest | orphans.swift |
| CheckRemovedItemWithSlotActiveItem | PlayerScriptableSystemRequest | orphans.swift |
| SynchronizeAttachmentSlotRequest | PlayerScriptableSystemRequest | orphans.swift |
| SetActiveItemInEquipmentArea | PlayerScriptableSystemRequest | orphans.swift |
| RefreshItemPlayerScalingEvent | Event | orphans.swift |
| BlockAndCompensateScalingEvent | Event | orphans.swift |
| IconicsReworkCompensateEvent | Event | orphans.swift |
| RetrofixQuickhacksEvent | Event | orphans.swift |
| RetrofixCyberwaresEvent | Event | orphans.swift |
| ConsumablesChargesReworkEvent | Event | orphans.swift |
| RescaleNonIconicWeaponsEvent | Event | orphans.swift |
| RestoreCybWeaponQualitiesEvent | Event | orphans.swift |
| RasetsuToPlayerScalingEvent | Event | orphans.swift |
| UnifyIconicsUpgradeCountWithEffectiveTierEvent | Event | orphans.swift |
| RetrofixOverallocatedCyberwareEvent | Event | orphans.swift |
| EquipWardrobeSetRequest | PlayerScriptableSystemRequest | orphans.swift |
| DeleteWardrobeSetRequest | PlayerScriptableSystemRequest | orphans.swift |
| QuestHideSlotRequest | PlayerScriptableSystemRequest | orphans.swift |
| QuestRestoreSlotRequest | PlayerScriptableSystemRequest | orphans.swift |
| PreviousMenuData | IScriptable | orphans.swift |
| VendorUserData | IScriptable | orphans.swift |
| inkVirtualCompoundController | inkDiscreteNavigationController | orphans.swift |
| inkVirtualListController | inkVirtualCompoundController | orphans.swift |
| AbstractDataSource | IScriptable | orphans.swift |
| BaseScriptableDataSource | AbstractDataSource | orphans.swift |
| inkVirtualItemTemplateClassifier | IScriptable | orphans.swift |
| inkScrollController | inkLogicController | orphans.swift |
| inkVirtualGridController | inkVirtualListController | orphans.swift |
| ScriptableDataSource | BaseScriptableDataSource | orphans.swift |
| RipperdocSelectorChangeEvent | Event | orphans.swift |
| VendorGameItemData | IScriptable | orphans.swift |
| BuybackRequest | TransactionRequest | orphans.swift |
| SellRequest | TransactionRequest | orphans.swift |
| CategoryHoverOverEvent | Event | orphans.swift |
| CategoryHoverOutEvent | Event | orphans.swift |
| ItemDisplayHoverOverEvent | Event | orphans.swift |
| DLCAddedItemDisplayHoverOverEvent | Event | orphans.swift |
| ItemDisplayHoverOutEvent | Event | orphans.swift |
| ItemDisplayPressEvent | Event | orphans.swift |
| ItemDisplayClickEvent | Event | orphans.swift |
| ItemDisplayHoldEvent | Event | orphans.swift |
| iconAtlasCallbackData | IScriptable | orphans.swift |
| DEBUG_IconErrorInfo | IScriptable | orphans.swift |
| SlotUserData | IScriptable | orphans.swift |
| inkAnimTranslation | inkAnimInterpolator | orphans.swift |
| inkAnimMargin | inkAnimInterpolator | orphans.swift |
| VendorRequirementsNotMetNotificationData | IScriptable | orphans.swift |
| EquipAnimationUpdateData | IScriptable | orphans.swift |
| NamedTooltipController | IScriptable | orphans.swift |
| TooltipSpawnedCallbackData | IScriptable | orphans.swift |
| GridUserData | IScriptable | orphans.swift |
| inkInputDisplayController | inkLogicController | orphans.swift |
| BasePerkDisplayData | IDisplayData | orphans.swift |
| Attribute_Record | Stat_Record | orphans.swift |
| LevelRewardDisplayData | IDisplayData | orphans.swift |
| PassiveProficiencyBonusUIData_Record | TweakDBRecord | orphans.swift |
| AreaDisplayData | IDisplayData | orphans.swift |
| PlayerDevUpdateDataEvent | Event | orphans.swift |
| AttributeUpdatedEvent | Event | orphans.swift |
| EdgrunnerPerkEvent | Event | orphans.swift |
| BackpackCraftingMaterialItemCallbackData | IScriptable | orphans.swift |
| inkGameNotificationData | inkUserData | orphans.swift |
| RipperdocTokenPopupData | inkGameNotificationData | orphans.swift |
| inkGameNotificationToken | IScriptable | orphans.swift |
| PerkUserData | IScriptable | orphans.swift |
| OpenMenuRequest | Event | orphans.swift |
| UIInGameNotificationRemoveEvent | Event | orphans.swift |
| AutoSaveEvent | Event | orphans.swift |
| RipperdocMeterArmorApplyEvent | Event | orphans.swift |
| RipperdocArmorData | IScriptable | orphans.swift |
| RipperdocMeterCapacityApplyEvent | Event | orphans.swift |
| RipperdocRefreshInventoryEvent | Event | orphans.swift |
| HandleItemEquippedNextFrameEvent | Event | orphans.swift |
| RipperdocInvalidateMinigridsNextFrame | Event | orphans.swift |
| RipperdocMeterArmorBarHoverEvent | Event | orphans.swift |
| RipperdocMeterCapacityBarHoverEvent | Event | orphans.swift |
| CyberwareTabModsRequest | Event | orphans.swift |
| inkActionName | IScriptable | orphans.swift |
| VendorConfirmationPopupData | inkGameNotificationData | orphans.swift |
| RipperdocCategoryTooltipData | ATooltipData | orphans.swift |
| RipperdocMeterCapacityHoverEvent | Event | orphans.swift |
| RipperdocMeterArmorHoverEvent | Event | orphans.swift |
| RipperdocPerkTooltipData | ATooltipData | orphans.swift |
| RipperdocBarTooltipTooltipData | ATooltipData | orphans.swift |
| BarHoverOverEvent | Event | orphans.swift |
| RipperdocInventoryItemData | IScriptable | orphans.swift |
| VendorConfirmationPopupCloseData | inkGameNotificationData | orphans.swift |
| RipperdocTokenPopupCloseData | inkGameNotificationData | orphans.swift |
| VendorHubMenuChanged | Event | orphans.swift |
| DrawItemByContextRequest | PlayerScriptableSystemRequest | orphans.swift |
| UnequipByContextRequest | PlayerScriptableSystemRequest | orphans.swift |
| UnequipWardrobeSetRequest | PlayerScriptableSystemRequest | orphans.swift |
| UpdateWeaponChargeEvent | Event | orphans.swift |
| UpdateDamageChangeEvent | Event | orphans.swift |
| WeaponFxPackage_Record | TweakDBRecord | orphans.swift |
| WeaponVFXSet_Record | TweakDBRecord | orphans.swift |
| AnimFeature_OwnerType | AnimFeature | orphans.swift |
| AnimFeature_WeaponOwnerVehicleData | AnimFeature | orphans.swift |
| AnimFeature_WeaponScopeData | AnimFeature | orphans.swift |
| AnimFeature_WeaponStats | AnimFeature | orphans.swift |
| WeaponSetMaxChargeEvent | Event | orphans.swift |
| WeaponChangeTriggerModeEvent | Event | orphans.swift |
| AnimFeature_MuzzleData | AnimFeature | orphans.swift |
| gameweaponeventsOwnerAimEvent | Event | orphans.swift |
| OutlineRequestEvent | Event | orphans.swift |
| ForceFadeOutlineEventForWeapon | Event | orphans.swift |
| WeaponVFXAction_Record | TweakDBRecord | orphans.swift |
| FxAction_Record | TweakDBRecord | orphans.swift |
| WeaponRegisterChargeStatListener | Event | orphans.swift |
| StartOverheatEffectEvent | Event | orphans.swift |
| UpdateOverheatEvent | Event | orphans.swift |
| PerfectChargeEvent | Event | orphans.swift |
| PerfectChargeUIEvent | Event | orphans.swift |
| MeleeHitEvent | Event | orphans.swift |
| ResetNPCFinishedDelayedRequest | ScriptableSystemRequest | orphans.swift |
| ResetNPCDefeatedDelayedRequest | ScriptableSystemRequest | orphans.swift |
| ResetNPCIncapacitatedDelayedRequest | ScriptableSystemRequest | orphans.swift |
| ResetNPCDownedDelayedRequest | ScriptableSystemRequest | orphans.swift |
| TakedownActionDataTrackingRequest | PlayerScriptableSystemRequest | orphans.swift |
| AutoSaveRequest | ScriptableSystemRequest | orphans.swift |
| PerformFastTravelRequest | ScriptableSystemRequest | orphans.swift |
| RegisterFastTravelPointRequest | ScriptableSystemRequest | orphans.swift |
| DataTermDeviceBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| UpdateFastTravelPointRecordRequest | ScriptableSystemRequest | orphans.swift |
| ChangeSubwayGateStateEvent | Event | orphans.swift |
| UnregisterFastTravelPointRequest | ScriptableSystemRequest | orphans.swift |
| FastTravelMenuToggledEvent | ScriptableSystemRequest | orphans.swift |
| RemoveAllFastTravelLocksRequest | ScriptableSystemRequest | orphans.swift |
| FastTravelConsoleInstructionRequest | ScriptableSystemRequest | orphans.swift |
| SDOClickedRequest | ScriptableSystemRequest | orphans.swift |
| CrosshairModule | HUDModule | orphans.swift |
| AimAssistModule | HUDModule | orphans.swift |
| SendInstructionRequest | ScriptableSystemRequest | orphans.swift |
| HUDManagerAssociationRequest | HUDManagerRequest | orphans.swift |
| ClueStatusNotification | HUDManagerRequest | orphans.swift |
| PlayerTargetChangedRequest | ScriptableSystemRequest | orphans.swift |
| QuickHackPanelStateEvent | Event | orphans.swift |
| PulseFinishedRequest | ScriptableSystemRequest | orphans.swift |
| ScannerTabChangeEvent | Event | orphans.swift |
| NemaplateChangedRequest | ScriptableSystemRequest | orphans.swift |
| ScannerTargetChangedRequest | ScriptableSystemRequest | orphans.swift |
| IterateModulesRequest | ScriptableSystemRequest | orphans.swift |
| enteventsSetVisibility | Event | orphans.swift |
| ScanningEvent | Event | orphans.swift |
| ClueLockNotification | HUDManagerRequest | orphans.swift |
| SetExclusiveFocusClueEntityEvent | Event | orphans.swift |
| OnWorkspotAvailabilityEvent | Event | orphans.swift |
| StatusEffectComponent | GameComponent | orphans.swift |
| ObjectSelectionComponent | IComponent | orphans.swift |
| RemoveTargetFromHighlightEvent | Event | orphans.swift |
| ToggleChargeHighlightEvent | Event | orphans.swift |
| HudEnhancer_Record | TweakDBRecord | orphans.swift |
| BreachControllerComponent | IComponent | orphans.swift |
| QuickSlotButtonTap | Event | orphans.swift |
| UsePhoneRequest | ScriptableSystemRequest | orphans.swift |
| DPADActionPerformed | Event | orphans.swift |
| CallAction | Event | orphans.swift |
| QuickSlotKeyboardTap | Event | orphans.swift |
| QuickSlotButtonHoldStartEvent | Event | orphans.swift |
| VehicleModel_Record | TweakDBRecord | orphans.swift |
| TimeDilationParameters | IScriptable | orphans.swift |
| questSetPhoneStatusRequest | ScriptableSystemRequest | orphans.swift |
| questTriggerCallRequest | ScriptableSystemRequest | orphans.swift |
| questPhoneManager | questIPhoneManager | orphans.swift |
| PickupPhoneRequest | ScriptableSystemRequest | orphans.swift |
| TalkingTriggerRequest | ScriptableSystemRequest | orphans.swift |
| questMinimizeCallRequest | ScriptableSystemRequest | orphans.swift |
| IStatusEffectListener | IScriptable | orphans.swift |
| ScriptStatusEffectListener | IStatusEffectListener | orphans.swift |
| AnimFeature_Inspection | AnimFeature | orphans.swift |
| InspectionEvent | Event | orphans.swift |
| ObjectInspectEvent | Event | orphans.swift |
| SetInspectStateEvent | Event | orphans.swift |
| TEMP_ScanningEvent | Event | orphans.swift |
| InspectionTriggerEvent | Event | orphans.swift |
| ScanEvent | Event | orphans.swift |
| ParticleDamage_Record | TweakDBRecord | orphans.swift |
| gameChaseSpawnComponent | IComponent | orphans.swift |
| AnimFeature_FocusMode | AnimFeature | orphans.swift |
| ToggleNewPlayerFlashlightEvent | Event | orphans.swift |
| PlayerCombatControllerInvalidateEvent | Event | orphans.swift |
| AnimFeature_CombatState | AnimFeature | orphans.swift |
| CrouchDelayEvent | Event | orphans.swift |
| EndGracePeriodAfterSpawn | Event | orphans.swift |
| LookAtObjectChangedEvent | Event | orphans.swift |
| WeaponEquipEvent | Event | orphans.swift |
| SetUpEquipmentOverlayEvent | Event | orphans.swift |
| ExitCombatOnOpticalCamoActivatedEvent | Event | orphans.swift |
| UpdateEquippedWeaponsHandlingEvent | Event | orphans.swift |
| PlayerAttachRequest | PlayerScriptableSystemRequest | orphans.swift |
| CPOMissionDataUpdateEvent | Event | orphans.swift |
| UpdateVisibilityModifierEvent | Event | orphans.swift |
| HealthUpdateEvent | Event | orphans.swift |
| UpdateAutoRevealStatEvent | Event | orphans.swift |
| ConfigVarListInt | ConfigVar | orphans.swift |
| AimAssistSettings_Record | TweakDBRecord | orphans.swift |
| PSMRemoveOnDemandStateMachine | Event | orphans.swift |
| AnimFeature_CameraGameplay | AnimFeature | orphans.swift |
| AnimFeature_CameraBodyOffset | AnimFeature | orphans.swift |
| VisibleObjectSecondaryPositionEvent | Event | orphans.swift |
| VisibleObjectDistanceEvent | Event | orphans.swift |
| VisibleObjectetSecondaryDistanceEvent | Event | orphans.swift |
| ConfigVarInt | ConfigVar | orphans.swift |
| PocketRadioUIEvent | Event | orphans.swift |
| VehicleRadioStationChanged | Event | orphans.swift |
| GameLoadedFactReset | Event | orphans.swift |
| CPOMissionDataTransferred | Event | orphans.swift |
| ClearBeingNoticedBB | Event | orphans.swift |
| StateFunctor | IScriptable | orphans.swift |
| StateContext | IScriptable | orphans.swift |
| StateGameScriptInterface | StateScriptInterface | orphans.swift |
| AdjustTransform | IScriptable | orphans.swift |
| AdjustTransformWithDurations | AdjustTransform | orphans.swift |
| ToggleAimDownSightsEvent | Event | orphans.swift |
| NotifySurfaceDirectionChangedEvent | Event | orphans.swift |
| MeleeAttackData | IScriptable | orphans.swift |
| SceneTier | StimuliData | orphans.swift |
| ChangeActiveContextRequest | PlayerScriptableSystemRequest | orphans.swift |
| ForceRadialWheelShutdown | Event | orphans.swift |
| AnimFeature_BasicAim | AnimFeature | orphans.swift |
| AnimFeature_AimPlayer | AnimFeature_BasicAim | orphans.swift |
| EnableFields | ScriptableSystemRequest | orphans.swift |
| DisableFields | ScriptableSystemRequest | orphans.swift |
| SetBraindanceState | ScriptableSystemRequest | orphans.swift |
| SetDebugSceneThrehsold | ScriptableSystemRequest | orphans.swift |
| SetIsInBraindance | ScriptableSystemRequest | orphans.swift |
| ItemIdWrapper | IScriptable | orphans.swift |
| GameplayCameraData | IScriptable | orphans.swift |
| vehicleRequestCameraPerspectiveEvent | Event | orphans.swift |
| vehicleCameraSceneEnableEvent | Event | orphans.swift |
| SetCameraParamsEvent | Event | orphans.swift |
| SceneTierData | IScriptable | orphans.swift |
| SceneTierDataMotionConstrained | SceneTierData | orphans.swift |
| SceneTier3Data | SceneTierDataMotionConstrained | orphans.swift |
| SetCameraParamsWithOverridesEvent | Event | orphans.swift |
| OverrideMissShotOffset | Event | orphans.swift |
| PingSystem | gameIPingSystem | orphans.swift |
| BeingTargetByLaserSightUpdateEvent | Event | orphans.swift |
| RequestBuyAttribute | Event | orphans.swift |
| PartAddedToSlotEvent | Event | orphans.swift |
| PartRemovedFromSlotEvent | Event | orphans.swift |
| ItemChangedEvent | Event | orphans.swift |
| PartRemovedEvent | Event | orphans.swift |
| AnimFeature_DOFControl | AnimFeature | orphans.swift |
| AnimFeature_PlayerCoverActionWeaponHolster | AnimFeature | orphans.swift |
| ItemAddedEvent | Event | orphans.swift |
| ItemBeingRemovedEvent | Event | orphans.swift |
| AIFollowerTakedownCommand | AIFollowerCommand | orphans.swift |
| OrderTakedownEvent | Event | orphans.swift |
| AIFollowerDeviceCommand | AIFollowerCommand | orphans.swift |
| KatanaMagFieldHitDelayEvent | Event | orphans.swift |
| AnimFeature_PlayerHitReactionData | AnimFeature | orphans.swift |
| gameCameraShakeEvent | Event | orphans.swift |
| TogglePlayerFlashlightEvent | Event | orphans.swift |
| CleanUpTimeDilationEvent | Event | orphans.swift |
| StopCritHealthRumble | Event | orphans.swift |
| RewardEvent | Event | orphans.swift |
| gameuiPersonalLinkSwitcherEvent | Event | orphans.swift |
| HeavyFootstepEvent | Event | orphans.swift |
| AimAssistConfigPreset_Record | TweakDBRecord | orphans.swift |
| AnimFeature_MeleeData | AnimFeature | orphans.swift |
| AnimFeature_SimpleIkSystem | AnimFeature | orphans.swift |
| PSMImpulse | PSMBaseEvent | orphans.swift |
| PlayerCoverStatusChangedEvent | Event | orphans.swift |
| GameplayRestrictionStatusEffect_Record | StatusEffect_Record | orphans.swift |
| VisionBlockerShape_BasicCapsule | IVisionBlockerShape | orphans.swift |
| AttachOpticalCamoVisionBlockerEffector | AttachCapsuleVisionBlockerEffector | orphans.swift |
| EnablePlayerVisibilityEvent | Event | orphans.swift |
| ProjectileSystem | IProjectileSystem | orphans.swift |
| FocusPerkTriggerd | Event | orphans.swift |
| AnimFeature_SceneGameplayOverrides | AnimFeature | orphans.swift |
| AnimFeature_Carry | AnimFeature | orphans.swift |
| SendPauseBraindanceRequest | ScriptableSystemRequest | orphans.swift |
| WorkspotStartedEvent | Event | orphans.swift |
| FinisherTransition | DefaultTransition | orphans.swift |
| FinisherInitData | IScriptable | orphans.swift |
| WorkspotFinishedEvent | Event | orphans.swift |
| VisionModeResetRequest | ScriptableSystemRequest | orphans.swift |
| RealTimeUpdateRequest | ScriptableSystemRequest | orphans.swift |
| SysDebuggerEvent | TickableEvent | orphans.swift |
| UpdateDebuggerRequest | ScriptableSystemRequest | orphans.swift |
| RequestEquipHeavyWeapon | Event | orphans.swift |
| FillAnimWrapperInfoBasedOnEquippedItem | Event | orphans.swift |
| FinishedVendettaTimeEvent | Event | orphans.swift |
| PlayerDamageFromDataEvent | TickableEvent | orphans.swift |
| CPOChoiceTokenDrawTextEvent | Event | orphans.swift |
| CPOMissionPlayerVotedEvent | Event | orphans.swift |
| TargetNeutraliziedEvent | Event | orphans.swift |
| scnRewindableSectionEvent | Event | orphans.swift |
| MeleeHitSlowMoEvent | Event | orphans.swift |
| OnCarHitPlayer | Event | orphans.swift |
| UpdateMiniGameProgramsEvent | Event | orphans.swift |
| QuestRestoreWardrobeSetRequest | PlayerScriptableSystemRequest | orphans.swift |
| QuestEnableWardrobeSetRequest | PlayerScriptableSystemRequest | orphans.swift |
| PlayerBuild_Record | TweakDBRecord | orphans.swift |
| WeatherSystem | IScriptable | orphans.swift |
| TimeTableCallbackRequest | ScriptableSystemRequest | orphans.swift |
| NotifyRecipientsRequest | ScriptableSystemRequest | orphans.swift |
| RegisterTimetableRequest | ScriptableSystemRequest | orphans.swift |
| ProcessRelevantDevicesForNetworkGridEvent | ProcessDevicesEvent | orphans.swift |
| FailedActionEvent | Event | orphans.swift |
| ActionCooldownEvent | Event | orphans.swift |
| SetRevealedInNetwork | Event | orphans.swift |
| Cooldown_Record | TweakDBRecord | orphans.swift |
| StartTakedownEvent | Event | orphans.swift |
| ClearPingedSquadRequest | ScriptableSystemRequest | orphans.swift |
| EvaluateMinigame | Event | orphans.swift |
| ShardForceSelectionEvent | Event | orphans.swift |
| CreateCustomBlackboardEvent | Event | orphans.swift |
| ResetSignal | Event | orphans.swift |
| KillRewardEvent | Event | orphans.swift |
| StartFinisherEvent | Event | orphans.swift |
| InputActivatedToUploadBlackwallEvent | Event | orphans.swift |
| RegisterPostionEvent | BlackBoardRequestEvent | orphans.swift |
| ClearOutlinesRequestEvent | Event | orphans.swift |
| ToggleTargetingComponentsEvent | Event | orphans.swift |
| SetBloodPuddleSettingsEvent | Event | orphans.swift |
| BloodPuddleEvent | Event | orphans.swift |
| InteractionChoiceCaptionStringPart | InteractionChoiceCaptionPart | orphans.swift |
| ObjectActionPrereq_Record | TweakDBRecord | orphans.swift |
| StartEndPhoneCallEvent | Event | orphans.swift |
| PauseResumePhoneCallEvent | Event | orphans.swift |
| EffectAndDamageEventData | ScriptTaskData | orphans.swift |
| AddOrRemoveListenerForGOEvent | Event | orphans.swift |
| PuppetBlackboardUpdater | IScriptable | orphans.swift |
| DebugOutlineEvent | Event | orphans.swift |
| EvaluateMappinsVisualStateEvent | Event | orphans.swift |
| DelayPrereqEvent | Event | orphans.swift |
| TriggerAttackEffectorWithDelay | Event | orphans.swift |
| ToggleOffMeshConnections | Event | orphans.swift |
| JournalInternetBase | IScriptable | orphans.swift |
| inkMenuLayer_SetCursorVisibility | Event | orphans.swift |
| ScreenMessageData | IScriptable | orphans.swift |
| LcdScreenBlackBoardDef | DeviceBaseBlackboardDef | orphans.swift |
| GlobalTvSystem | IGlobalTvSystem | orphans.swift |
| VirtualCameraViewComponent | IVisualComponent | orphans.swift |
| RequestBannerWidgetUpdateEvent | RequestWidgetUpdateEvent | orphans.swift |
| SetDocumentStateEvent | Event | orphans.swift |
| inkVerticalPanel | inkBasePanel | orphans.swift |
| inkVideo | inkLeafWidget | orphans.swift |
| RequestComputerMenuWidgetsUpdateEvent | RequestWidgetUpdateEvent | orphans.swift |
| RequestComputerMainMenuWidgetsUpdateEvent | RequestWidgetUpdateEvent | orphans.swift |
| LocationManager | ILocationManager | orphans.swift |
| JournalInternetPage | JournalEntry | orphans.swift |
| inkAsyncSpawnRequest | IScriptable | orphans.swift |
| JournalInternetText | JournalInternetBase | orphans.swift |
| JournalInternetImage | JournalInternetBase | orphans.swift |
| JournalInternetVideo | JournalInternetBase | orphans.swift |
| JournalInternetCanvas | JournalInternetBase | orphans.swift |
| JournalInternetSite | JournalFileEntry | orphans.swift |
| worldITriggerAreaNotifer | IScriptable | orphans.swift |
| TVBase_Record | Device_Record | orphans.swift |
| ChannelData_Record | TweakDBRecord | orphans.swift |
| TvDeviceWidgetCustomData | WidgetCustomData | orphans.swift |
| QuickHackToggleActivate | ToggleActivate | orphans.swift |
| RefreshCLSOnSlavesEvent | Event | orphans.swift |
| DelayedTimetableEvent | Event | orphans.swift |
| InitializeCLSEvent | Event | orphans.swift |
| BaseNetworkSystemControllerPS | MasterControllerPS | orphans.swift |
| IPlayerHandicapSystem | ScriptableSystem | orphans.swift |
| ClimbParametersBase | IScriptable | orphans.swift |
| IInspectListener | IScriptable | orphans.swift |
| MultiPrereqState | PrereqState | orphans.swift |
| ModifyAttackEffector | HitEventEffector | orphans.swift |
| StatusEffectPrereq_Record | IPrereq_Record | orphans.swift |
| HitTriggeredPrereq | GenericHitPrereq | orphans.swift |
| AIMoveToCommand | AIMoveCommand | orphans.swift |
| inkToggleController | inkButtonController | orphans.swift |
| gameinteractionsNodeDefinition | IScriptable | orphans.swift |
| inkAnimTextInterpolator | inkAnimInterpolator | orphans.swift |
| AnimFeatureCustom | AnimFeature | orphans.swift |
| inkBaseShapeWidget | inkLeafWidget | orphans.swift |
| AIBaseMountCommand | AICommand | orphans.swift |
| JournalBriefingBaseSection | JournalEntry | orphans.swift |
| ArrowClickedEvent | Event | orphans.swift |
| ProgressBarFinishedProccess | Event | orphans.swift |
| CraftingItemPreviewEvent | Event | orphans.swift |
| MaterialTooltipData | ATooltipData | orphans.swift |
| FilterRadioItemHoverOver | Event | orphans.swift |
| FilterRadioItemHoverOut | Event | orphans.swift |
| QuantityPickerPopupData | inkGameNotificationData | orphans.swift |
| QuantityPickerPopupCloseData | inkGameNotificationData | orphans.swift |
| PickerChoosenQuantityChangedEvent | inkGameNotificationData | orphans.swift |
| ItemCraftingData | IScriptable | orphans.swift |
| DropdownItemData | IScriptable | orphans.swift |
| DropdownItemClickedEvent | Event | orphans.swift |
| inkTextAnimationController | inkLogicController | orphans.swift |
| BaseGOGRegisterController | inkLogicController | orphans.swift |
| MakeNotificationQueueSilentEvent | Event | orphans.swift |
| PhoneMessagePopupEvent | Event | orphans.swift |
| inkGenericSystemNotificationLogicController | inkLogicController | orphans.swift |
| inkItemPositionProvider | IScriptable | orphans.swift |
| BaseInteractionMappinController | BaseMappinBaseController | orphans.swift |
| inkProjectedHUDGameController | inkHUDGameController | orphans.swift |
| PerksMenuAttributeItemClicked | Event | orphans.swift |
| RuntimeMappin | IMappin | orphans.swift |
| JournalEntryNotificationRemoveRequestData | IScriptable | orphans.swift |
| JournalEntryListItemData | IScriptable | orphans.swift |
| inkAnimTextOffset | inkAnimTextInterpolator | orphans.swift |
| gameuiCharacterCustomizationInfo | IScriptable | orphans.swift |
| inkLanguageOverrideProvider | inkUserData | orphans.swift |
| inkTextValueProgressController | inkTextAnimationController | orphans.swift |
| ConfigNotificationListener | IScriptable | orphans.swift |
| ConfigVarListName | ConfigVar | orphans.swift |
| MinigameState | IScriptable | orphans.swift |
| BaseQuestMappinController | BaseInteractionMappinController | orphans.swift |
| BluelinePart | IScriptable | orphans.swift |
| ConfigVarFloat | ConfigVar | orphans.swift |
| SubtitleHandlerSystem | ISubtitleHandlerSystem | orphans.swift |
| RefreshCrosshairEvent | Event | orphans.swift |
| inkGridController | inkVirtualCompoundController | orphans.swift |
| gameIPlayerManager | IGameSystem | orphans.swift |
| ProjectileBreachEvent | Event | orphans.swift |
| gameuiIronsightGameController | inkGameController | orphans.swift |
| ActionInternalEvent | IScriptable | orphans.swift |
| RequestThumbnailWidgetsUpdateEvent | RequestWidgetUpdateEvent | orphans.swift |
| TimeDilationListener | tickITimeDilationListener | orphans.swift |
| AttachmentSlotEvent | Event | orphans.swift |
| LocomotionParameters | IScriptable | orphans.swift |
| MorphData | IScriptable | orphans.swift |
| gameprojectileSpawnerPreviewEvent | Event | orphans.swift |
| gameprojectileLinearMovementEvent | Event | orphans.swift |
| inkAnimEvent | IScriptable | orphans.swift |
| RegenerateLootEvent | Event | orphans.swift |
| InteractionScriptedCondition | IScriptable | orphans.swift |
| inkISystemRequestsHandler | IScriptable | orphans.swift |
| GalleryScreenshotPreviewData | inkGameNotificationData | orphans.swift |
| GenericMessageNotificationData | inkGameNotificationData | orphans.swift |
| GenericMessageNotificationCloseData | inkGameNotificationData | orphans.swift |
| DelayedDeleteNotificationOKEvent | Event | orphans.swift |
| GalleryScreenshotPreviewPopupEvent | Event | orphans.swift |
| gameuiCreditsController | inkGameController | orphans.swift |
| inkMenuScenario | IScriptable | orphans.swift |
| inkRectangle | inkBaseShapeWidget | orphans.swift |
| PauseMenuListItemData | ListItemData | orphans.swift |
| gameuiGenericNotificationReceiverGameController | inkGameController | orphans.swift |
| BaseGOGProfileController | inkGameController | orphans.swift |
| inkTextReplaceController | inkTextAnimationController | orphans.swift |
| MappinControllerCustomData | IScriptable | orphans.swift |
| gameuiBaseMenuGameController | inkGameController | orphans.swift |
| gameuiNewPhoneRelatedGameController | inkGameController | orphans.swift |
| QuestMappin | IMappin | orphans.swift |
| PointOfInterestMappin | IMappin | orphans.swift |
| inkAnimPadding | inkAnimInterpolator | orphans.swift |
| MappinsGroup_Record | TweakDBRecord | orphans.swift |
| inkAnimScale | inkAnimInterpolator | orphans.swift |
| BarHoverOutEvent | Event | orphans.swift |
| MainMenuGameController | gameuiMenuItemListGameController | orphans.swift |
| SongbirdAudioCallGameController | inkHUDGameController | orphans.swift |
| ItemChooserItemChanged | Event | orphans.swift |
| ItemChooserUnequipItem | Event | orphans.swift |
| ItemChooserUnequipMod | Event | orphans.swift |
| ItemChooserItemHoverOver | Event | orphans.swift |
| ItemChooserItemHoverOut | Event | orphans.swift |
| GameFinishEvent | Event | orphans.swift |
| gameuiNewHudPhoneGameController | gameuiGenericNotificationGameController | orphans.swift |
| IronsightTargetHealthUpdateEvent | Event | orphans.swift |
| BaseDirectionalIndicatorPartLogicController | inkLogicController | orphans.swift |
| PassiveAutonomousCondition | AIbehaviorexpressionScript | orphans.swift |
| AILookatTask | AIbehaviortaskScript | orphans.swift |
| gameuiBaseBunkerComputerGameController | inkGameController | orphans.swift |
| TriggerNotifier_Script | worldITriggerAreaNotifer | orphans.swift |
| AnimFeature_RoadBlock | AnimFeature | orphans.swift |
| TVDeviceBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| TrafficLightChangeEvent | Event | orphans.swift |
| gameCpoPickableItem | GameObject | orphans.swift |
| AnimFeature_SuperheroLand | AnimFeature | orphans.swift |
| LadderDescription | IScriptable | orphans.swift |
| ActivateTriggerDestructionComponentEvent | Event | orphans.swift |
| DeactivateTriggerDestructionComponentEvent | Event | orphans.swift |
| MineDispenserTransition | DefaultTransition | orphans.swift |
| AnimFeature_PlayerLocomotionStateMachine | AnimFeature | orphans.swift |
| AnimFeature_Landing | AnimFeature | orphans.swift |
| AnimFeature_Zoom | AnimFeature | orphans.swift |
| AnimFeature_VehicleData | AnimFeature | orphans.swift |
| AnimFeature_VehiclePassenger | AnimFeature | orphans.swift |
| VehicleFPPCameraParams_Record | TweakDBRecord | orphans.swift |
| vehicleCinematicCameraToggleEvent | Event | orphans.swift |
| vehicleCameraResetEvent | Event | orphans.swift |
| PSMStopStateMachine | Event | orphans.swift |
| PSMStartStateMachine | Event | orphans.swift |
| QuickSlotsDecisions | QuickSlotsTransition | orphans.swift |
| QuickSlotsReadyDecisions | QuickSlotsDecisions | orphans.swift |
| AnimFeature_PlayerVitals | AnimFeature | orphans.swift |
| AnimFeature_PlayerDeathAnimation | AnimFeature | orphans.swift |
| QuickSlotsEvents | QuickSlotsTransition | orphans.swift |
| AnimFeature_LeftHandCyberware | AnimFeature | orphans.swift |
| AnimFeature_LeftHandAnimation | AnimFeature | orphans.swift |
| AnimFeature_LeftHandItem | AnimFeature | orphans.swift |
| gameprojectileProjectilePreviewEvent | gameprojectileSpawnerPreviewEvent | orphans.swift |
| LeftHandCyberwareDataDef | BlackboardDefinition | orphans.swift |
| LocomotionTakedownInitData | IScriptable | orphans.swift |
| AnimFeature_Grapple | AnimFeature | orphans.swift |
| parameterRequestReload | IScriptable | orphans.swift |
| AnimFeature_Mounting | AnimFeature | orphans.swift |
| AnimFeature_DriverCombatWeaponData | AnimFeature | orphans.swift |
| VehicleAudioEvent | Event | orphans.swift |
| AimAssistMelee_Record | TweakDBRecord | orphans.swift |
| AnimFeature_MeleeSlotData | AnimFeature | orphans.swift |
| AnimFeature_MeleeIKData | AnimFeature | orphans.swift |
| StimuliSystem | IStimuliSystem | orphans.swift |
| PlayerObstacleSystem | IScriptable | orphans.swift |
| gameChangeDestination | ActionInternalEvent | orphans.swift |
| ActionSlideToScriptProxy | CActionScriptProxy | orphans.swift |
| ActionDodgeScriptProxy | CActionScriptProxy | orphans.swift |
| ActionTeleportScriptProxy | CActionScriptProxy | orphans.swift |
| AIArgumentMapping | IScriptable | orphans.swift |
| ISkinableComponent | IPlacedComponent | orphans.swift |
| AnimatedComponent | ISkinableComponent | orphans.swift |
| AttitudeGroupChangedEvent | Event | orphans.swift |
| AIbehaviorPassiveExpressionDefinition | IScriptable | orphans.swift |
| AIbehaviorStackScriptPassiveExpressionDefinition | AIbehaviorPassiveExpressionDefinition | orphans.swift |
| EthnicityComponent | IComponent | orphans.swift |
| EntityStubComponent | GameComponent | orphans.swift |
| TestBehaviorDelegateTask | AIbehaviortaskScript | orphans.swift |
| InteractionMountBase_Record | InteractionBase_Record | orphans.swift |
| PhysicalDestructionComponent | IVisualComponent | orphans.swift |
| PhysicalDestructionEvent | Event | orphans.swift |
| ToggleImpulseDestruction | Event | orphans.swift |
| InfluenceObstacleComponent | IPlacedComponent | orphans.swift |
| AVComponent | VehicleComponent | orphans.swift |
| InteractionSetChoicesEvent | Event | orphans.swift |
| CarComponent | VehicleComponent | orphans.swift |
| InCrowd | Event | orphans.swift |
| OutOfCrowd | Event | orphans.swift |
| OnPavement | Event | orphans.swift |
| OffPavement | Event | orphans.swift |
| DurabilityLimitReach | Event | orphans.swift |
| DurabilityComponent | ScriptableComponent | orphans.swift |
| RagdollRequestCollectAnimPoseEvent | Event | orphans.swift |
| RagdollNotifyDisabledEvent | Event | orphans.swift |
| AnimatedRagdollNotifyDisabledEvent | Event | orphans.swift |
| RagdollNotifyVelocityTresholdEvent | Event | orphans.swift |
| RagdollPutToSleepEvent | Event | orphans.swift |
| DisableRagdollComponentEvent | Event | orphans.swift |
| FollowSlot | IScriptable | orphans.swift |
| RequestSlotEvent | Event | orphans.swift |
| ReleaseSlotEvent | Event | orphans.swift |
| EntityAttachementRequestEvent | Event | orphans.swift |
| FollowTrajectoryParams | gameprojectileTrajectoryParams | orphans.swift |
| SpiralControllerParams | IScriptable | orphans.swift |
| BlackboardChangedEvent | Event | orphans.swift |
| SlideTrajectoryParams | gameprojectileTrajectoryParams | orphans.swift |
| gamePlayerControlledComponent | IComponent | orphans.swift |
| TurretInitData | IScriptable | orphans.swift |
| VehicleTransitionInitData | IScriptable | orphans.swift |
| CarriedObjectData | IScriptable | orphans.swift |
| InspectItemInspectionEvent | Event | orphans.swift |
| AnimationsLoaded | TaggedSignalUserData | orphans.swift |
| LootItemInspectionEvent | Event | orphans.swift |
| ObjectInspectListener | IInspectListener | orphans.swift |
| HitRepresentation_SetSingleScaleMultiplier_AllShapes | Event | orphans.swift |
| InspectListenerEvent | Event | orphans.swift |
| ProjectileSpawnComponent | IPlacedComponent | orphans.swift |
| HitRepresentation_SetSingleScaleMultiplier_SingleShape | HitRepresentation_SetSingleScaleMultiplier_AllShapes | orphans.swift |
| ObjectMoverStatus | Event | orphans.swift |
| HitRepresentation_SetSingleScaleMultiplier_MultipleShapes | HitRepresentation_SetSingleScaleMultiplier_AllShapes | orphans.swift |
| HitRepresentation_SetMultipleScaleMultipliers_MultipleShapes | Event | orphans.swift |
| ObjectMoverComponentPS | GameComponentPS | orphans.swift |
| ObjectMoverComponent | ScriptableComponent | orphans.swift |
| HitRepresentation_ResetSingleScaleMultiplier | Event | orphans.swift |
| HitRepresentation_ResetMultipleScaleMultipliers | Event | orphans.swift |
| HitRepresentation_ResetAllScaleMultipliers | Event | orphans.swift |
| EffectNode | IScriptable | orphans.swift |
| EffectExecutor | EffectNode | orphans.swift |
| EffectExecutor_Scripted | EffectExecutor | orphans.swift |
| HitData_Humanoid | HitData_Base | orphans.swift |
| AnimFeature_DroneProcedural | AnimFeature | orphans.swift |
| ApplyDroneProceduralAnimFeatureEvent | Event | orphans.swift |
| ApplyDroneLocomotionWrapperEvent | Event | orphans.swift |
| AnimFeature_DroneStateAnimationData | AnimFeature | orphans.swift |
| ReenableColliderEvent | Event | orphans.swift |
| DelamainTaxiArrivedEvent | Event | orphans.swift |
| LightPreset_Record | TweakDBRecord | orphans.swift |
| ApplyDiodeLightPresetEvent | Event | orphans.swift |
| ChangeDiodeLightSettingsEvent | Event | orphans.swift |
| RemoveSecondaryDiodeLightPresetEvent | Event | orphans.swift |
| VehicleToggleBrokenTireEvent | Event | orphans.swift |
| PhysicalImpulseEvent | Event | orphans.swift |
| AnimFeature_AIAction | AnimFeature | orphans.swift |
| WeakspotDestroyPhysicalComponentsEvent | Event | orphans.swift |
| WeakspotOnDestroyEvent | Event | orphans.swift |
| Weakspot_Record | SpawnableObject_Record | orphans.swift |
| DestroyWeakspotDelayedEvent | Event | orphans.swift |
| WeakspotRequestAttributeChangeEvent | Event | orphans.swift |
| AICommandFactory | IScriptable | orphans.swift |
| AICommandParams | AICommandFactory | orphans.swift |
| MiscAICommandNodeParams | AICommandParams | orphans.swift |
| EnableColliderDelayEvent | DelayEvent | orphans.swift |
| AICommsCallMoveToCommand | AIMoveToCommand | orphans.swift |
| AIMoveOnSplineCommand | AIMoveCommand | orphans.swift |
| SoundComponentBase | IPlacedComponent | orphans.swift |
| soundComponent | SoundComponentBase | orphans.swift |
| AIAnimMoveOnSplineCommand | AIMoveCommand | orphans.swift |
| AIRotateToCommand | AIMoveCommand | orphans.swift |
| AIPatrolCommand | AIMoveCommand | orphans.swift |
| gameStatsComponent | GameComponent | orphans.swift |
| AIFollowTargetCommand | AIMoveCommand | orphans.swift |
| AIJoinCrowdCommand | AIMoveCommand | orphans.swift |
| AIRootMotionCommand | AIMoveCommand | orphans.swift |
| AIAssignRestrictMovementAreaCommand | AICommand | orphans.swift |
| vehiclePortalsList | IScriptable | orphans.swift |
| vehicleAudioCurvesParam | IScriptable | orphans.swift |
| AIVehicleOnSplineCommand | AIVehicleCommand | orphans.swift |
| AIVehicleFollowCommand | AIVehicleCommand | orphans.swift |
| InventoryScriptListener | InventoryListener | orphans.swift |
| OnLootEvent | Event | orphans.swift |
| OnLootAllEvent | Event | orphans.swift |
| AIVehicleToNodeCommand | AIVehicleCommand | orphans.swift |
| AIVehicleRacingCommand | AIVehicleCommand | orphans.swift |
| SceneAnimationMotionActionParams | IScriptable | orphans.swift |
| AITeleportCommand | AICommand | orphans.swift |
| AIBaseUseWorkspotCommand | AICommand | orphans.swift |
| AIUseWorkspotCommand | AIBaseUseWorkspotCommand | orphans.swift |
| AIEquipCommand | AICommand | orphans.swift |
| AIUnequipCommand | AICommand | orphans.swift |
| AIAssignRoleCommand | AICommand | orphans.swift |
| AINoRole | AIRole | orphans.swift |
| AIUseCoverCommand | AICombatRelatedCommand | orphans.swift |
| AISetCombatPresetCommand | AICombatRelatedCommand | orphans.swift |
| AIMeleeAttackCommand | AICombatRelatedCommand | orphans.swift |
| AIInjectCombatTargetCommand | AICombatRelatedCommand | orphans.swift |
| AIInjectLookatTargetCommand | AICombatRelatedCommand | orphans.swift |
| ExplorationEnteredEvent | Event | orphans.swift |
| AIThrowGrenadeCommand | AICombatRelatedCommand | orphans.swift |
| ExplorationLeftEvent | Event | orphans.swift |
| ExitedSplineEvent | Event | orphans.swift |
| OnReserveWorkspotEvent | OnWorkspotAvailabilityEvent | orphans.swift |
| AIThrowGrenadeForcedCommand | AIThrowGrenadeCommand | orphans.swift |
| AIShootCommand | AICombatRelatedCommand | orphans.swift |
| OnReleaseWorkspotEvent | OnWorkspotAvailabilityEvent | orphans.swift |
| AIForceShootCommand | AICombatRelatedCommand | orphans.swift |
| AIAimAtTargetCommand | AICombatRelatedCommand | orphans.swift |
| TestMappinScriptData | MappinScriptData | orphans.swift |
| AISwitchToPrimaryWeaponCommand | AICommand | orphans.swift |
| AISwitchToSecondaryWeaponCommand | AICommand | orphans.swift |
| AIMoveToCoverCommand | AIMoveCommand | orphans.swift |
| AIStopCoverCommand | AICommand | orphans.swift |
| ItemLootedEvent | Event | orphans.swift |
| ChangeToPhase2DelayedEvent | DelayEvent | orphans.swift |
| EnableGasCloudDelayedEvent | DelayEvent | orphans.swift |
| ChangeToPhase3DelayedEvent | DelayEvent | orphans.swift |
| AIJoinTargetsSquad | AICommand | orphans.swift |
| parameterRequestItem | IScriptable | orphans.swift |
| parameterRequestEquip | IScriptable | orphans.swift |
| NavigationCostModCircle | IScriptable | orphans.swift |
| MovementPolicyTagList_Record | TweakDBRecord | orphans.swift |
| AIFollowerCombatCommand | AIFollowerCommand | orphans.swift |
| WidgetHudComponentInterface | WidgetBaseComponent | orphans.swift |
| WidgetHudComponent | WidgetHudComponentInterface | orphans.swift |
| FrameInitialisation | Event | orphans.swift |
| FrameSwitcherEvent | Event | orphans.swift |
| FrameSwitch | Event | orphans.swift |
| AIFlatheadSetSoloModeCommand | AIFollowerCommand | orphans.swift |
| AIScanTargetCommand | AICommand | orphans.swift |
| AIRoadBlockadeMemberCommand | AICombatRelatedCommand | orphans.swift |
| InfoBox | IScriptable | orphans.swift |
| ChimeraWeakspotDelayedEvent | Event | orphans.swift |
| HighlightOpacityEvent | Event | orphans.swift |
| entAppearanceChangeFinishEvent | Event | orphans.swift |
| entPostInitializeEvent | Event | orphans.swift |
| entPreUninitializeEvent | Event | orphans.swift |
| UnequipStart | AttachmentSlotEvent | orphans.swift |
| UnequipEnd | AttachmentSlotEvent | orphans.swift |
| EquipStart | AttachmentSlotEvent | orphans.swift |
| gameQuickItemsEvent | Event | orphans.swift |
| EquipEnd | AttachmentSlotEvent | orphans.swift |
| OnInventoryEmptyEvent | Event | orphans.swift |
| FinalizeActivationTPPRepresentationEvent | Event | orphans.swift |
| FinalizeDeactivationTPPRepresentationEvent | Event | orphans.swift |
| ItemVisualsAddedToSlot | ItemAddedToSlotBase | orphans.swift |
| AnimFeature_WeaponData | AnimFeature | orphans.swift |
| InventoryChangedEvent | Event | orphans.swift |
| IKTargetAddEvent | AnimTargetAddEvent | orphans.swift |
| MakeInventoryShareableEvent | Event | orphans.swift |
| SetLootInteractionAccessibilityEvent | Event | orphans.swift |
| AnimFeature_NPCCoverStanceState | AnimFeature_NPCState | orphans.swift |
| ContainerFilledEvent | Event | orphans.swift |
| AnimFeature_CoverAction | AnimFeature_AIAction | orphans.swift |
| AnimFeature_ExitCover | AnimFeature_AIAction | orphans.swift |
| AttachmentSlotsScriptListener | AttachmentSlotsListener | orphans.swift |
| AnimFeature_EquipType | AnimFeature | orphans.swift |
| AnimFeature_LoopableAction | AnimFeature | orphans.swift |
| AnimFeature_Aim | AnimFeature_BasicAim | orphans.swift |
| AnimFeature_Stance | AnimFeature | orphans.swift |
| UILootedItemEvent | Event | orphans.swift |
| DisableWeakspotDelayedEvent | DelayEvent | orphans.swift |
| AnimFeature_MoveTo | AnimFeature | orphans.swift |
| AnimFeature_Movement | AnimFeature | orphans.swift |
| AnimFeature_PlayerMovement | AnimFeature_Movement | orphans.swift |
| ReactionEvent | Event | orphans.swift |
| ResolveQualityRangeInteractionLayerEvent | Event | orphans.swift |
| AnimFeature_LadderEnterStyleData | AnimFeature | orphans.swift |
| gameProjectedHitEvent | gameHitEvent | orphans.swift |
| ScanningActionFinishedEvent | Event | orphans.swift |
| ScanningEventForInstigator | ScanningEvent | orphans.swift |
| ScanningModeEvent | Event | orphans.swift |
| AnimFeature_Cover | AnimFeature | orphans.swift |
| TaggedEvent | Event | orphans.swift |
| gameCloseByEvent | Event | orphans.swift |
| ScanningPulseStartEvent | Event | orphans.swift |
| ScanningPulseEvent | Event | orphans.swift |
| MeshParam_Weakspot | AnimFeature | orphans.swift |
| gameMissEvent | Event | orphans.swift |
| PSMPostponedParameterInt | PSMPostponedParameterBase | orphans.swift |
| PSMPostponedParameterFloat | PSMPostponedParameterBase | orphans.swift |
| DamageBlockedByNanoTechPlatesEvent | Event | orphans.swift |
| AnimFeature_RotatingObject | AnimFeature | orphans.swift |
| PSMPostponedParameterVector | PSMPostponedParameterBase | orphans.swift |
| PSMPostponedParameterCName | PSMPostponedParameterBase | orphans.swift |
| AnimFeature_FPPCamera | AnimFeature | orphans.swift |
| AnimFeature_PlayerStateMachineState | AnimFeature | orphans.swift |
| gameUnconsciousEvent | Event | orphans.swift |
| gameDropItemEvent | Event | orphans.swift |
| AnimFeature_IconicItem | AnimFeature | orphans.swift |
| gameCoverHitEvent | gameHitEvent | orphans.swift |
| AreaEnteredEvent | TriggerEvent | orphans.swift |
| AreaExitedEvent | TriggerEvent | orphans.swift |
| SmartGunLockEvent | Event | orphans.swift |
| WillDieSoonEvent | Event | orphans.swift |
| AnimFeature_CoverState | AnimFeature | orphans.swift |
| AnimFeature_DelayEntry | AnimFeature | orphans.swift |
| AnimFeature_PlayerCoverActionState | AnimFeature | orphans.swift |
| AnimFeature_PlayerPeekScale | AnimFeature | orphans.swift |
| AnimFeature_AnimatedDevice | AnimFeature | orphans.swift |
| AnimFeature_IndustrialArm | AnimFeature | orphans.swift |
| AnimFeature_DoorDevice | AnimFeature | orphans.swift |
| AnimFeature_Container | AnimFeature | orphans.swift |
| AnimFeature_ForkliftDevice | AnimFeature | orphans.swift |
| AnimFeature_SceneSystem | AnimFeature | orphans.swift |
| AnimFeature_SceneSystemCarrying | AnimFeature | orphans.swift |
| gameVisionModuleEvent | Event | orphans.swift |
| AnimFeature_SelectRandomAnimSync | AnimFeature | orphans.swift |
| gameVisionModeEvent | Event | orphans.swift |
| AnimFeature_TriggerModeChange | AnimFeature | orphans.swift |
| gameVisionModeVisualEvent | Event | orphans.swift |
| gameVisionModeHideEvent | Event | orphans.swift |
| gameVisionModeMappinEvent | Event | orphans.swift |
| EndTakedownEvent | Event | orphans.swift |
| gameProperlySeenByPlayerEvent | Event | orphans.swift |
| AnimFeature_MeleeAttack | AnimFeature | orphans.swift |
| AnimFeature_QuickMelee | AnimFeature | orphans.swift |
| RemoveCachedStatusEffectFXEvent | Event | orphans.swift |
| AnimFeature_Whip | AnimFeature | orphans.swift |
| AnimFeature_AirHover | AnimFeature | orphans.swift |
| gameprojectileSetUpAndLaunchEvent | gameprojectileLaunchEvent | orphans.swift |
| gameprojectileShootTargetEvent | gameprojectileShootEvent | orphans.swift |
| InteractionChoiceCaptionIconPart | InteractionChoiceCaptionPart | orphans.swift |
| EffectDurationModifier | IScriptable | orphans.swift |
| EffectDurationModifier_Scripted | EffectDurationModifier | orphans.swift |
| InteractionChoiceCaptionBluelinePart | InteractionChoiceCaptionPart | orphans.swift |
| AnimFeature_HoverJumpData | AnimFeature | orphans.swift |
| gameprojectileBroadPhaseHitEvent | Event | orphans.swift |
| TaggedAIEvent | AIEvent | orphans.swift |
| SignalEvent | TaggedAIEvent | orphans.swift |
| AnimFeature_SwimmingData | AnimFeature | orphans.swift |
| gameprojectileFollowEvent | Event | orphans.swift |
| AnimFeature_AirThrusterData | AnimFeature | orphans.swift |
| gameprojectileAcceleratedMovementEvent | gameprojectileLinearMovementEvent | orphans.swift |
| AnimFeature_VehicleNPCDeathData | AnimFeature | orphans.swift |
| gameprojectileForceActivationEvent | Event | orphans.swift |
| ThrowingKnifePickupEvent | Event | orphans.swift |
| VehicleRepairEvent | Event | orphans.swift |
| VehicleDetachPartEvent | Event | orphans.swift |
| HasVehicleBeenFlippedOverForSomeTimeEvent | Event | orphans.swift |
| AnimFeature_LookAt | AnimFeature | orphans.swift |
| VehicleReadyToParkEvent | Event | orphans.swift |
| VehicleAccelerateQuickhackEvent | ActionEvent | orphans.swift |
| AICommandStateEvent | Event | orphans.swift |
| VehicleExplodeEvent | Event | orphans.swift |
| StimuliEffectEvent | Event | orphans.swift |
| VehicleMountedWeaponShootEvent | Event | orphans.swift |
| VehicleRemoteControlCameraToggleEvent | Event | orphans.swift |
| AnimFeature_ProceduralIronsightData | AnimFeature | orphans.swift |
| JoinTrafficVehicleEvent | Event | orphans.swift |
| VehicleStuckEvent | Event | orphans.swift |
| AnimFeature_ProceduralDriverCombatData | AnimFeature | orphans.swift |
| AnimFeature_DodgeData | AnimFeature | orphans.swift |
| VehicleTirePuncturedEvent | Event | orphans.swift |
| AIVehicleDisabledEvent | Event | orphans.swift |
| AnimFeature_PreClimbing | AnimFeature | orphans.swift |
| AnimFeature_SafeAction | AnimFeature | orphans.swift |
| AnimFeatureShieldState | AnimFeatureCustom | orphans.swift |
| AnimFeature_WeaponOverride | AnimFeature | orphans.swift |
| ModifyStatPoolModifierEffector_Record | Effector_Record | orphans.swift |
| AnimFeature_StimReactions | AnimFeature | orphans.swift |
| AnimFeature_ConsumableAnimation | AnimFeature | orphans.swift |
| ApplyEffectorEffector_Record | Effector_Record | orphans.swift |
| AnimFeature_BulletBend | AnimFeature | orphans.swift |
| AnimFeature_RoboticArm | AnimFeature | orphans.swift |
| AnimFeature_Stamina | AnimFeature | orphans.swift |
| AnimFeature_AdHocAnimation | AnimFeature | orphans.swift |
| AnimFeature_WeaponReload | AnimFeature | orphans.swift |
| ApplyLightPresetEffector_Record | Effector_Record | orphans.swift |
| ModifyStatPoolValueEffector_Record | Effector_Record | orphans.swift |
| StatPoolUpdate_Record | TweakDBRecord | orphans.swift |
| AnimFeature_CameraSceneMode | AnimFeature | orphans.swift |
| AnimFeature_CameraBreathing | AnimFeature | orphans.swift |
| AnimFeature_CameraRecoil | AnimFeature | orphans.swift |
| AnimFeature_DeviceWorkspot | AnimFeature | orphans.swift |
| AnimFeature_WeaponBlur | AnimFeature | orphans.swift |
| AnimFeature_DroneActionAltitudeOffset | AnimFeature | orphans.swift |
| AnimFeature_WeaponHandlingStats | AnimFeature | orphans.swift |
| AnimFeature_WeaponReloadSpeedData | AnimFeature | orphans.swift |
| AnimFeature_PhotomodeFacial | AnimFeature | orphans.swift |
| AnimFeature_Reprimand | AnimFeature | orphans.swift |
| LookAtFacingPositionProvider | IPositionProvider | orphans.swift |
| AnimFeature_BodySlam | AnimFeature | orphans.swift |
| AnimFeature_Felled | AnimFeature | orphans.swift |
| AnimFeature_WeaponSprintBlock | AnimFeature | orphans.swift |
| ApplyStatusEffectByChanceEffector_Record | ApplyStatusEffectEffector_Record | orphans.swift |
| EffectorTimeDilationDriver_Record | TweakDBRecord | orphans.swift |
| ApplyStatGroupEffector_Record | Effector_Record | orphans.swift |
| BroadcastStimEffector_Record | ContinuousEffector_Record | orphans.swift |
| AIActionLookAtData_Record | TweakDBRecord | orphans.swift |
| LookAtPart_Record | TweakDBRecord | orphans.swift |
| ConvertDamageToStatPoolEffector_Record | Effector_Record | orphans.swift |
| gameContainerObjectBasePS | gameLootContainerBasePS | orphans.swift |
| AIActionPhase_Record | TweakDBRecord | orphans.swift |
| AIActionChangeNPCState_Record | TweakDBRecord | orphans.swift |
| AIActionAnimDirection_Record | TweakDBRecord | orphans.swift |
| AIActionSlideData_Record | TweakDBRecord | orphans.swift |
| ResetContainerEvent | Event | orphans.swift |
| ApplyStatusEffectBasedOnDifficultyEffector_Record | ApplyStatusEffectEffector_Record | orphans.swift |
| ContainerObjectSingleItemPS | gameLootContainerBasePS | orphans.swift |
| LootContainerObjectAnimatedByTransformPS | gameLootContainerBasePS | orphans.swift |
| ModifyAttackCritChanceEffector_Record | Effector_Record | orphans.swift |
| AddStatusEffectToAttackEffector_Record | Effector_Record | orphans.swift |
| ForceDismembermentEffector_Record | Effector_Record | orphans.swift |
| SetAttackHitTypeEffector_Record | Effector_Record | orphans.swift |
| EvaluateEncumbranceEvent | Event | orphans.swift |
| ModifyStatPoolCustomLimitEffector_Record | Effector_Record | orphans.swift |
| SetAmmoCountEvent | Event | orphans.swift |
| LootContainerObjectAnimatedByTransformWithFlarePS | LootContainerObjectAnimatedByTransformPS | orphans.swift |
| ForceResetAmmoEvent | Event | orphans.swift |
| OverrideRangedAttackPackageEffector_Record | Effector_Record | orphans.swift |
| ClearAllRevealRequestsEvent | Event | orphans.swift |
| ToggleMappinsOnLookAtEvent | Event | orphans.swift |
| RemoveAllModifiersEffector_Record | Effector_Record | orphans.swift |
| RefreshClueScanningDataEvent | Event | orphans.swift |
| MonowireSpreadableNPC | IScriptable | orphans.swift |
| ClueScannedEvent | Event | orphans.swift |
| InitializeFocusCluesEvent | Event | orphans.swift |
| OnScannableBraindanceClueEnabledEvent | Event | orphans.swift |
| OnScannableBraindanceClueDisabledEvent | Event | orphans.swift |
| IComparisonPrereq | IPrereq | orphans.swift |
| WasScannedPrereq | IPrereq | orphans.swift |
| HotSpotLayerDefinition | gameinteractionsNodeDefinition | orphans.swift |
| UncontrolledMovementEffector_Record | Effector_Record | orphans.swift |
| TriggerHackingMinigameEffector_Record | Effector_Record | orphans.swift |
| gameObjectActionRefreshEvent | Event | orphans.swift |
| AlwaysTruePrereqState | PrereqState | orphans.swift |
| MovingPlatformMovementLinear | IMovingPlatformMovementPointToPoint | orphans.swift |
| BeforeArrivedAt | Event | orphans.swift |
| MovementStateChanged | Event | orphans.swift |
| HitIsBodyPartHeadPrereq | GenericHitPrereq | orphans.swift |
| HitIsBodyPartTorsoPrereq | GenericHitPrereq | orphans.swift |
| HitIsBodyPartLimbPrereq | GenericHitPrereq | orphans.swift |
| HitIsInstigatorPlayerPrereq | GenericHitPrereq | orphans.swift |
| HitReceivedPrereq | GenericHitPrereq | orphans.swift |
| HitIsRicochetPrereq | GenericHitPrereq | orphans.swift |
| HitIsSourceGrenadePrereq | GenericHitPrereq | orphans.swift |
| CoverActionDataDef | BlackboardDefinition | orphans.swift |
| HitOrMissTriggeredPrereq | GenericHitPrereq | orphans.swift |
| UI_HUDButtonHintDef | BlackboardDefinition | orphans.swift |
| AIPatrolDef | AIBlackboardDef | orphans.swift |
| BackDoorDeviceBlackboardDef | MasterDeviceBaseBlackboardDef | orphans.swift |
| NumericDisplayBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| ArcadeMachineBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| ConfessionalBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| JukeboxBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| NcartTimetableBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| IntercomBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| InteractiveDeviceBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| ElectricBoxBlackboardDef | DeviceBaseBlackboardDef | orphans.swift |
| DistrictPrereq_Record | IPrereq_Record | orphans.swift |
| CameraShotEffect_VectorDamper | vehicleTimedCinematicCameraShotEffect | orphans.swift |
| OnOffPrereqState | PrereqState | orphans.swift |
| ItemCreationPrereqDataWrapper | IScriptable | orphans.swift |
| PlayerDoesntHaveRecipePrereqState | PrereqState | orphans.swift |
| CameraShotEffect_EulerAnglesDamper | vehicleTimedCinematicCameraShotEffect | orphans.swift |
| RarityOfEquippedCyberdeckPrereqState | PrereqState | orphans.swift |
| RarityOfEquippedConsumableItemPrereqState | PrereqState | orphans.swift |
| PlayerDoesntHaveQuickhackPrereqState | PrereqState | orphans.swift |
| InvestedPerksPrereqState | PrereqState | orphans.swift |
| BodyCarryingPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| BodyDisposalPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| CombatPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| FallPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| HighLevelPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| IsInWorkspotPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| LocomotionPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| IsInFocusModePSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| MeleePSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| UI_FastForwardDef | BlackboardDefinition | orphans.swift |
| MeleeWeaponPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| RangedWeaponPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| PerkPrereqState | PrereqState | orphans.swift |
| SwimmingPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| SenseInitializeEvent | Event | orphans.swift |
| OnBeingDetectedEvent | Event | orphans.swift |
| WeaponStateMachinePrereqState | PrereqState | orphans.swift |
| WeaponStateMachinePrereq | IScriptablePrereq | orphans.swift |
| TakedownPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| IsNewPerkBoughtPrereqState | PrereqState | orphans.swift |
| EnterShapeEvent | SenseVisibilityEvent | orphans.swift |
| ExitShapeEvent | SenseVisibilityEvent | orphans.swift |
| ZonesPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| TimeDilationPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| UpperBodyPSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| VehiclePSMPrereqState | PlayerStateMachinePrereqState | orphans.swift |
| SenseBox | ISenseShape | orphans.swift |
| SenseSphere | ISenseShape | orphans.swift |
| SenseAngleRange | ISenseShape | orphans.swift |
| GameplayTagsPrereq_Record | IPrereq_Record | orphans.swift |
| ActionTargetInDistancePrereq_Record | IPrereq_Record | orphans.swift |
| HideUIDetectionEvent | Event | orphans.swift |
| gameScriptedPrereqAttitudeListenerWrapper | IScriptable | orphans.swift |
| NPCIsAggressiveState | PrereqState | orphans.swift |
| NPCRecordHasVisualTagState | PrereqState | orphans.swift |
| NPCReactionPresetPrereqState | PrereqState | orphans.swift |
| NPCRarityPrereqState | PrereqState | orphans.swift |
| EffectObjectProvider | EffectNode | orphans.swift |
| EffectObjectFilter | EffectNode | orphans.swift |
| EffectObjectSingleFilter | EffectObjectFilter | orphans.swift |
| EffectObjectGroupFilter | EffectObjectFilter | orphans.swift |
| EffectAction | IScriptable | orphans.swift |
| EntityHasVisualTagPrereqState | PrereqState | orphans.swift |
| EffectPreAction | EffectAction | orphans.swift |
| gameScriptedPrereqSceneInspectionListenerWrapper | IScriptable | orphans.swift |
| EffectPostAction | EffectAction | orphans.swift |
| gameEffectObjectFilter | EffectNode | orphans.swift |
| gameEffectObjectGroupFilter | gameEffectObjectFilter | orphans.swift |
| gameEffectObjectFilter_OnlyNearest | gameEffectObjectGroupFilter | orphans.swift |
| EffectObjectProvider_Scripted | EffectObjectProvider | orphans.swift |
| EffectObjectSingleFilter_Scripted | EffectObjectSingleFilter | orphans.swift |
| EffectObjectGroupFilter_Scripted | EffectObjectGroupFilter | orphans.swift |
| EffectPreAction_Scripted | EffectPreAction | orphans.swift |
| EffectPostAction_Scripted | EffectPostAction | orphans.swift |
| ActionTargetPrereq_Record | IPrereq_Record | orphans.swift |
| VisualTagsPrereq_Record | IPrereq_Record | orphans.swift |
| AIAlertedPatrolDef | AIBlackboardDef | orphans.swift |
| IsHumanPrereqState | PrereqState | orphans.swift |
| CharacterDataPrereqState | PrereqState | orphans.swift |
| NPCTypePrereq_Record | IPrereq_Record | orphans.swift |
| IsPlayerPrereqState | PrereqState | orphans.swift |
| EffectInfoEvent | Event | orphans.swift |
| RandomChancePrereqState | PrereqState | orphans.swift |
| HighLevelNPCStatePrereqState | NPCStatePrereqState | orphans.swift |
| gameScriptedPrereqPSChangeListenerWrapper | IScriptable | orphans.swift |
| UpperBodyNPCStatePrereqState | NPCStatePrereqState | orphans.swift |
| SetChancePrereqState | PrereqState | orphans.swift |
| gameScriptedPrereqMountingListenerWrapper | IScriptable | orphans.swift |
| StanceNPCStatePrereqState | NPCStatePrereqState | orphans.swift |
| DialogueChoiceHubPrereqState | PrereqState | orphans.swift |
| IsPlayerReachablePrereqState | PrereqState | orphans.swift |
| ReactionData | IScriptable | orphans.swift |
| VehicleRadioStationInitialized | Event | orphans.swift |
| SceneTier1Data | SceneTierData | orphans.swift |
| SceneTier2Data | SceneTierData | orphans.swift |
| SceneTier4Data | SceneTierDataMotionConstrained | orphans.swift |
| VehicleCameraManagerFT | VehicleCameraManager | orphans.swift |
| SceneTier5Data | SceneTierDataMotionConstrained | orphans.swift |
| CallbackHandle | IScriptable | orphans.swift |
| PhysicalCollisionEvent | Event | orphans.swift |
| ResourceMetricsReportGenerator | IScriptable | orphans.swift |
| HitCharacterControllerEvent | Event | orphans.swift |
| LifePathBluelinePart | BluelinePart | orphans.swift |
| BuildBluelinePart | BluelinePart | orphans.swift |
| PaymentBluelinePart | BluelinePart | orphans.swift |
| BluelineDescription | IScriptable | orphans.swift |
| VoiceOverQuickHackFeedbackEvent | Event | orphans.swift |
| ContainerManager | IContainerManager | orphans.swift |
| DebugPlayerBreadcrumbs | IDebugPlayerBreadcrumbs | orphans.swift |
| CommunitySystem | ICommunitySystem | orphans.swift |
| worldIDestructibleSpotsSystem | IGameSystem | orphans.swift |
| RemoveCooldownRequest | ScriptableSystemRequest | orphans.swift |
| StartedBeingTrackedAsHostile | AIEvent | orphans.swift |
| StoppedBeingTrackedAsHostile | AIEvent | orphans.swift |
| DebugCheatsSystem | IDebugCheatsSystem | orphans.swift |
| SquadIsTracked | AIEvent | orphans.swift |
| IDebugDrawHistorySystem | IGameSystem | orphans.swift |
| CombatQueriesRequest | SignalUserData | orphans.swift |
| CoverDemandHolder | IScriptable | orphans.swift |
| mpPlayerManager | gameIPlayerManager | orphans.swift |
| ThreatExpectationInvalid | AIEvent | orphans.swift |
| EnemyPushedToSquad | AIEvent | orphans.swift |
| HostJoinedSquad | AIEvent | orphans.swift |
| gameIGameRulesSystem | IGameSystem | orphans.swift |
| EntitySpotted | AIEvent | orphans.swift |
| EntityLost | AIEvent | orphans.swift |
| GameTagSystem | IGameSystem | orphans.swift |
| IOnlineSystem | IGameSystem | orphans.swift |
| InfluenceMapSystem | IInfluenceMapSystem | orphans.swift |
| RegisterActiveClueOwnerkRequest | ScriptableSystemRequest | orphans.swift |
| MinimapSettings | IScriptable | orphans.swift |
| PrereqStateChangedEvent | Event | orphans.swift |
| WeakspotDestroyedEvent | Event | orphans.swift |
| SpreadInitEffector_Record | Effector_Record | orphans.swift |
| ResetControllerLightColorRequest | ScriptableSystemRequest | orphans.swift |
| LerpToDefaultControllerLightColorRequest | ScriptableSystemRequest | orphans.swift |
| PhotoModeEnableEvent | Event | orphans.swift |
| PrereqManager | IPrereqManager | orphans.swift |
| StopWeaponFireSoundEvent | Event | orphans.swift |
| AudioNotifyItemEquippedEvent | Event | orphans.swift |
| WeaponPreFireEvent | Event | orphans.swift |
| PickUpBodyBreathingEvent | Event | orphans.swift |
| DropBodyBreathingEvent | Event | orphans.swift |
| SpreadEffector_Record | Effector_Record | orphans.swift |
| EnteredPathWithDoors | Event | orphans.swift |
| FinishedPathWithDoors | Event | orphans.swift |
| NavigationObstacle | IScriptable | orphans.swift |
| RevealAccessPointPrereqState | PrereqState | orphans.swift |
| GAMEOBJECT_Actor | HUDActor | orphans.swift |
| VEHICLE_Actor | HUDActor | orphans.swift |
| DEVICE_Actor | HUDActor | orphans.swift |
| PUPPET_ACtor | HUDActor | orphans.swift |
| DEBUG_actorsClassNamesCount | IScriptable | orphans.swift |
| DisableAutoDriveRequest | ScriptableSystemRequest | orphans.swift |
| ToggleFreeRoamRequest | ScriptableSystemRequest | orphans.swift |
| UpdateAutoDriveAvailabilityRequest | ScriptableSystemRequest | orphans.swift |
| UpdateAutodriveOnDestinationChangeRequest | ScriptableSystemRequest | orphans.swift |
| MappinVariantChangedEvent | Event | orphans.swift |
| ICombatRestrictMovementAreaCondition | IScriptable | orphans.swift |
| CloseQHmenu | Event | orphans.swift |
| TrafficSystem | IScriptable | orphans.swift |
| gameuiIUIObjectsLoaderSystem | IGameSystem | orphans.swift |
| questTutorialManager | questITutorialManager | orphans.swift |
| CityLightSystemUpdateEvent | Event | orphans.swift |
| UnregisterTimetableRequest | ScriptableSystemRequest | orphans.swift |
| StatsBundleHandler | IScriptable | orphans.swift |
| TurnOffPsychoSquadAvCammoEvent | ScriptableSystemRequest | orphans.swift |
| TurnOnPsychoSquadAvCammoEvent | ScriptableSystemRequest | orphans.swift |
| PushAnimEventDelayed | ScriptableSystemRequest | orphans.swift |
| MaxTacFearEvent | ScriptableSystemRequest | orphans.swift |
| VisionBlockerShape_BasicSphere | IVisionBlockerShape | orphans.swift |
| IWatchdogSystem | IGameSystem | orphans.swift |
| RainEvent | Event | orphans.swift |
| ObjectLookedAtEvent | Event | orphans.swift |
| inkAnimSequence | IScriptable | orphans.swift |
| inkAnimToggleVisibilityEvent | inkAnimEvent | orphans.swift |
| inkAnimSetVisibilityEvent | inkAnimEvent | orphans.swift |
| TargetFilter | IScriptable | orphans.swift |
| GetOffAVDelayedEvent | ScriptableSystemRequest | orphans.swift |
| PreventionConditionAbstract | AIbehaviorconditionScript | orphans.swift |
| inkMenuLogicController | inkLogicController | orphans.swift |
| FakeUpdateEvent | TickableEvent | orphans.swift |
| ResloveFocusClueDescriptionEvent | Event | orphans.swift |
| ItemEquipRequest | IScriptable | orphans.swift |
| ItemUnequipRequest | IScriptable | orphans.swift |
| OnAttachedEvent | Event | orphans.swift |
| ClimbParameters | ClimbParametersBase | orphans.swift |
| VaultParameters | ClimbParametersBase | orphans.swift |
| LocomotionSwimmingParameters | LocomotionParameters | orphans.swift |
| LocomotionBraindanceParameters | LocomotionParameters | orphans.swift |
| inkStepperController | inkLogicController | orphans.swift |
| ClearBraindanceStateRequest | ScriptableSystemRequest | orphans.swift |
| ClearBraindancePauseRequest | ScriptableSystemRequest | orphans.swift |
| inkBorder | inkLeafWidget | orphans.swift |
| gameuiScreenProjectionsData | IScriptable | orphans.swift |
| inkAnimRotation | inkAnimInterpolator | orphans.swift |
| inkCacheWidget | inkCompoundWidget | orphans.swift |
| inkAnimShear | inkAnimInterpolator | orphans.swift |
| inkFlex | inkCompoundWidget | orphans.swift |
| inkAnimPivot | inkAnimInterpolator | orphans.swift |
| inkAnimAnchor | inkAnimInterpolator | orphans.swift |
| inkAnimEffect | inkAnimInterpolator | orphans.swift |
| inkLinePattern | inkImage | orphans.swift |
| inkVirtualCompoundBackgroundController | inkLogicController | orphans.swift |
| inkAnimTextReplace | inkAnimTextInterpolator | orphans.swift |
| inkAnimTextValueProgress | inkAnimTextInterpolator | orphans.swift |
| inkRichTextBox | inkText | orphans.swift |
| inkMask | inkLeafWidget | orphans.swift |
| inkVirtualUniformListController | inkVirtualCompoundController | orphans.swift |
| inkVirtualUniformGridController | inkVirtualUniformListController | orphans.swift |
| inkTextInput | inkText | orphans.swift |
| inkScrollArea | inkCompoundWidget | orphans.swift |
| inkCircle | inkBaseShapeWidget | orphans.swift |
| inkShape | inkBaseShapeWidget | orphans.swift |
| inkUniformGrid | inkCompoundWidget | orphans.swift |
| inkVirtualCompoundWidget | inkCompoundWidget | orphans.swift |
| inkCallbackConnectorData | IScriptable | orphans.swift |
| inkComboBoxObjectController | inkLogicController | orphans.swift |
| JournalEntryOverrideData | IScriptable | orphans.swift |
| JournalQuestGuidanceMarker | JournalEntry | orphans.swift |
| JournalQuestMapPin | JournalQuestMapPinBase | orphans.swift |
| JournalQuestMapPinLink | JournalEntry | orphans.swift |
| JournalImageEntry | JournalEntry | orphans.swift |
| JournalQuestSubObjective | JournalQuestObjectiveBase | orphans.swift |
| JournalQuestPhase | JournalContainerEntry | orphans.swift |
| JournalPhoneChoiceGroup | JournalContainerEntry | orphans.swift |
| inkEntityPreviewGameController | gameuiMenuGameController | orphans.swift |
| gameuiPuppetPreview_ReadyToBeDisplayed | Event | orphans.swift |
| worldBenchmarkSummary | IScriptable | orphans.swift |
| gameuiPuppetPreview_SetCameraSetupEvent | Event | orphans.swift |
| BaseItemDataSource | AbstractDataSource | orphans.swift |
| JournalBriefingMapSection | JournalBriefingBaseSection | orphans.swift |
| inkLocalizationChangedEvent | inkEvent | orphans.swift |
| JournalBriefingVideoSection | JournalBriefingBaseSection | orphans.swift |
| ItemDataSource | BaseItemDataSource | orphans.swift |
| JournalBriefingPaperDollSection | JournalBriefingBaseSection | orphans.swift |
| ItemDataView | BaseItemDataSource | orphans.swift |
| JournalTarotGroup | JournalFileEntry | orphans.swift |
| JournalTarot | JournalEntry | orphans.swift |
| ExtendedWorkspotInfo | IScriptable | orphans.swift |
| inkMenuInstance_SwitchToScenario | Event | orphans.swift |
| inkCharacterEvent | inkInputEvent | orphans.swift |
| JournalInternetRectangle | JournalInternetBase | orphans.swift |
| inkMenuLayer_SetMenuModeEvent | Event | orphans.swift |
| inkMenuLayer_SetGender | Event | orphans.swift |
| inkMenuLayer_SetCursorVisibilityOnActivate | Event | orphans.swift |
| inkMenuLayer_AbortHackingMinigame | Event | orphans.swift |
| inkGameNotificationLayer_SetCursorVisibility | Event | orphans.swift |
| JournalEmailGroup | JournalFileEntry | orphans.swift |
| JournalFileGroup | JournalFileEntry | orphans.swift |
| JournalMetaQuestObjective | JournalEntry | orphans.swift |
| inkArray | IScriptable | orphans.swift |
| JournalMetaQuest | JournalFileEntry | orphans.swift |
| inkFIFOQueue | IScriptable | orphans.swift |
| ConnectedWorkspotNotificationEvent | Event | orphans.swift |
| ReactionFinishedEvent | Event | orphans.swift |
| SetupWorkspotActionEvent | StimuliData | orphans.swift |
| inkStringMap | IScriptable | orphans.swift |
| inkScreenProjection | IScriptable | orphans.swift |
| UIAudioHandler | IScriptable | orphans.swift |
| inkMenusState | IScriptable | orphans.swift |
| BaseWeakScriptableDataSource | AbstractDataSource | orphans.swift |
| WeakScriptableDataSource | BaseWeakScriptableDataSource | orphans.swift |
| inkClippedMenuScenarioData | IScriptable | orphans.swift |
| inkTextOffsetController | inkTextAnimationController | orphans.swift |
| inkVectorGraphicWidget | inkLeafWidget | orphans.swift |
| BaseVariantDataSource | AbstractDataSource | orphans.swift |
| inkTextKiroshiAnimController | inkTextAnimationController | orphans.swift |
| VariantDataSource | BaseVariantDataSource | orphans.swift |
| gameuiPhoneWaveformData | IScriptable | orphans.swift |
| inkTextMotherTongueController | inkLogicController | orphans.swift |
| LatestSaveMetadataInfo | IScriptable | orphans.swift |
| inkWorldAttachedEvt | Event | orphans.swift |
| inkCursorInfo | inkUserData | orphans.swift |
| LabeledCursorData | inkUserData | orphans.swift |
| inkHoldControllerActionData | inkUserData | orphans.swift |
| AICustomComponents | AIRelatedComponents | orphans.swift |
| GateSignal | TaggedSignalUserData | orphans.swift |
| ConsumeGateSignal | GateSignal | orphans.swift |
| MechanicalComponentImpactEvent | Event | orphans.swift |
| CentaurShieldStateChangeEvent | Event | orphans.swift |
| HitShieldEvent | Event | orphans.swift |
| AIMountCommand | AIBaseMountCommand | orphans.swift |
| NameplateChangedEvent | ScriptableSystemRequest | orphans.swift |
| Crosshair | ModuleInstance | orphans.swift |
| AimAssist | ModuleInstance | orphans.swift |
| SceneScreenUIAnimationsData | IScriptable | orphans.swift |
| OnProgressBarAnimFinish | Event | orphans.swift |
| ConfigVarName | ConfigVar | orphans.swift |
| StatusEffectUIData_Record | TweakDBRecord | orphans.swift |
| BuffListVisibilityChangedEvent | Event | orphans.swift |
| gameuiDynamicIconLogicController | inkLogicController | orphans.swift |
| ReflexesMasterPerk3Triggerd | Event | orphans.swift |
| OverclockHudEvent | Event | orphans.swift |
| StreetSignSelector | TweakDBIDSelector | orphans.swift |
| HolocallStartEvent | Event | orphans.swift |
| SettingsMenuUserData | gameuiMenuGameController | orphans.swift |
| OnBnechmarkHideSettings | Event | orphans.swift |
| HoverEvent | Event | orphans.swift |
| KeyBindingEvent | Event | orphans.swift |
| ExecuteVisualCustomizationWithDelay | Event | orphans.swift |
| CodexBaseGameController | gameuiMenuGameController | orphans.swift |
| BackpackEquipSlotChooserData | inkGameNotificationData | orphans.swift |
| InventoryItemPreferredAreaItems | IScriptable | orphans.swift |
| InventoryItemComparableTypesCache | IScriptable | orphans.swift |
| InventoryTypeComparableItemsCache | IScriptable | orphans.swift |
| BackpackEquipSlotChooserCloseData | inkGameNotificationData | orphans.swift |
| CodexListSyncData | IScriptable | orphans.swift |
| ShardEntrySelectedEvent | Event | orphans.swift |
| ShardSelectedEvent | Event | orphans.swift |
| CodexEntrySelectedEvent | Event | orphans.swift |
| CodexSelectedEvent | Event | orphans.swift |
| CodexFilterButtonClicked | Event | orphans.swift |
| CodexForceSelectionEvent | Event | orphans.swift |
| CodexSyncBackEvent | Event | orphans.swift |
| TCSInputCameraZoom | Event | orphans.swift |
| BenchmarkLineData | IScriptable | orphans.swift |
| OnUnstoppableStateSignal | TaggedSignalUserData | orphans.swift |
| BleedingEffectDamageUpdate | Event | orphans.swift |
| CraftingPopupData | inkGameNotificationData | orphans.swift |
| ShardAttachmentData | IScriptable | orphans.swift |
| ShardSyncBackEvent | Event | orphans.swift |
| OnOpenCodexAtEntryEvent | Event | orphans.swift |
| OnVisitedJournalEntryEvent | Event | orphans.swift |
| CreditsData | inkUserData | orphans.swift |
| MenuItemData | IScriptable | orphans.swift |
| SelectMenuRequest | Event | orphans.swift |
| RadialSelectMenuRequest | Event | orphans.swift |
| DlcDescriptionData | inkUserData | orphans.swift |
| MenuItemDelayedUpdate | Event | orphans.swift |
| MenuItemDimRequest | Event | orphans.swift |
| TimeSkipPopupData | inkGameNotificationData | orphans.swift |
| TimeSkipPopupCloseData | inkGameNotificationData | orphans.swift |
| PatchNotesPopupData | inkGameNotificationData | orphans.swift |
| MenuButtonHoverOverEvent | Event | orphans.swift |
| MenuButtonHoverOutEvent | Event | orphans.swift |
| RequestStats | Event | orphans.swift |
| gameuiTimeDisplayLogicController | inkLogicController | orphans.swift |
| PreventionAVObject | AVObject | orphans.swift |
| MetroPlayerAdjustmentEvent | Event | orphans.swift |
| HubMenuInstanceData | IScriptable | orphans.swift |
| TimeSkipHoverOverEvent | Event | orphans.swift |
| TimeSkipHoverOutEvent | Event | orphans.swift |
| TimeSkipOpenedEvent | Event | orphans.swift |
| TimeSkipClosedEvent | Event | orphans.swift |
| OpenPatchNotesPopupEvent | Event | orphans.swift |
| DeathMenuUserData | IScriptable | orphans.swift |
| gameuiFinalBoardsGoToMainMenu | Event | orphans.swift |
| hubStaticSelectorPostArrangeEvent | Event | orphans.swift |
| TimeSkipFinishEvent | Event | orphans.swift |
| WardrobeUserData | inkUserData | orphans.swift |
| ILoadingLogicController | inkLogicController | orphans.swift |
| DropQueueUpdatedEvent | Event | orphans.swift |
| inkSetNextLoadingScreenEvent | Event | orphans.swift |
| MinimapQuestAreaInitData | MappinControllerCustomData | orphans.swift |
| TrackedMappinControllerCustomData | MappinControllerCustomData | orphans.swift |
| WorldMapFloorPlanController | MinimapContainerController | orphans.swift |
| InventoryItemPreviewData | inkGameNotificationData | orphans.swift |
| AuthorisationNotificationViewData | GenericNotificationViewData | orphans.swift |
| SignInPopupEvent | Event | orphans.swift |
| SignInPopupData | inkGameNotificationData | orphans.swift |
| RefreshGOGState | Event | orphans.swift |
| CraftingNotificationEvent | Event | orphans.swift |
| OpenCodexPopupEvent | Event | orphans.swift |
| CodexPopupData | inkGameNotificationData | orphans.swift |
| ForceCloseHubMenuEvent | Event | orphans.swift |
| ItemPreferredAreaItems | IScriptable | orphans.swift |
| ItemComparableTypesCache | IScriptable | orphans.swift |
| TypeComparableItemsCache | IScriptable | orphans.swift |
| TarotCardAddedNotificationViewData | GenericNotificationViewData | orphans.swift |
| TarotCardAdded | Event | orphans.swift |
| LevelUpUserData | inkGameNotificationData | orphans.swift |
| NewAreaDiscoveredUserData | inkGameNotificationData | orphans.swift |
| ItemLogUserData | inkGameNotificationData | orphans.swift |
| JournalNotificationData | inkGameNotificationData | orphans.swift |
| QuestUpdateUserData | inkGameNotificationData | orphans.swift |
| NewCodexEntryUserData | inkGameNotificationData | orphans.swift |
| CustomQuestNotificationUserData | inkGameNotificationData | orphans.swift |
| CustomNotificationEvent | Event | orphans.swift |
| DeactivateAllNetworkLinksRequest | ScriptableSystemRequest | orphans.swift |
| inGameMenuAnimContainer | IScriptable | orphans.swift |
| MorphMenuUserData | inkUserData | orphans.swift |
| RegisterPreviewControllerEvent | Event | orphans.swift |
| ResetItemAppearanceInSlotDelayEvent | Event | orphans.swift |
| MarketingConsentPopupData | inkGameNotificationData | orphans.swift |
| ShardReadPopupData | inkGameNotificationData | orphans.swift |
| RefreshSmsMessagerEvent | Event | orphans.swift |
| KeepPhoneOpenWhenInHubMenuEvent | Event | orphans.swift |
| FocusSmsMessagerEvent | Event | orphans.swift |
| UnfocusSmsMessagerEvent | Event | orphans.swift |
| RequestSmsMessagerCloseEvent | Event | orphans.swift |
| ShowSmsMessagerEvent | Event | orphans.swift |
| HideSmsMessagerEvent | Event | orphans.swift |
| OpenSmsMessengerEvent | PhoneMessagePopupEvent | orphans.swift |
| CloseSmsMessengerEvent | Event | orphans.swift |
| SmsMessangerInitalizedEvent | Event | orphans.swift |
| UINotificationRemoveEvent | Event | orphans.swift |
| OpenSkillsMenuData | IScriptable | orphans.swift |
| OpenExpansionPopupEvent | Event | orphans.swift |
| ExpansionPopupData | inkGameNotificationData | orphans.swift |
| ZoneAlertNotificationRemoveRequestData | IScriptable | orphans.swift |
| ReloadingExpansionPopupCloseEvent | Event | orphans.swift |
| TransferSaveData | IScriptable | orphans.swift |
| NewPerksScreenInitData | IScriptable | orphans.swift |
| DamageDigitUserData | IScriptable | orphans.swift |
| NewPerksTabAttributeInvestHoldFinished | Event | orphans.swift |
| NewPerksTabArrowClickedEvent | Event | orphans.swift |
| SkillHoverOver | Event | orphans.swift |
| SkillHoverOut | Event | orphans.swift |
| SkillRewardHoverOver | Event | orphans.swift |
| SkillRewardHoverOut | Event | orphans.swift |
| MarketingConsentPopupEvent | Event | orphans.swift |
| DeathMenuDelayEvent | Event | orphans.swift |
| DelayedRegisterToGlobalInputCallbackEvent | Event | orphans.swift |
| DelayedHandleQuickLoadEvent | Event | orphans.swift |
| RefreshInputHintEvent | Event | orphans.swift |
| UnlimitedUnlocked | Event | orphans.swift |
| PerkHoverOverEvent | Event | orphans.swift |
| PerkHoverOutEvent | Event | orphans.swift |
| PerksItemHoldStart | Event | orphans.swift |
| MessageMenuAttachmentData | IScriptable | orphans.swift |
| MessageThreadReadEvent | Event | orphans.swift |
| DelayedJournalUpdate | Event | orphans.swift |
| TypingDelayEvent | Event | orphans.swift |
| NewPerksPerkItemInitData | IScriptable | orphans.swift |
| NewPerkClickEvent | Event | orphans.swift |
| PlayNewPerksSoundEvent | Event | orphans.swift |
| NewPerkHoverOverEvent | Event | orphans.swift |
| NewPerkHoverOutEvent | Event | orphans.swift |
| NewPerkSlot_Record | TweakDBRecord | orphans.swift |
| PerksMenuAttributeItemCreated | Event | orphans.swift |
| PerksMenuAttributeItemReleased | Event | orphans.swift |
| PerksMenuProficiencyItemClicked | PerksMenuAttributeItemClicked | orphans.swift |
| PerksMenuAttributeItemHoverOver | Event | orphans.swift |
| PerksMenuAttributeItemHoverOut | Event | orphans.swift |
| PerksMenuAttributeItemHoldStart | Event | orphans.swift |
| AttributeUpgradePurchased | Event | orphans.swift |
| ActiveSkillScreenChangedEvent | Event | orphans.swift |
| InventoryItemPreviewPopupEvent | Event | orphans.swift |
| PerkDisplayContainerCreatedEvent | Event | orphans.swift |
| BackpackFilterButtonSpawnedCallbackData | IScriptable | orphans.swift |
| BackpackUpdateNextFrameEvent | Event | orphans.swift |
| VendorSellJunkPopupData | inkGameNotificationData | orphans.swift |
| VendorSellJunkPopupCloseData | inkGameNotificationData | orphans.swift |
| MessengerContactSyncData | IScriptable | orphans.swift |
| MessengerThreadSelectedEvent | Event | orphans.swift |
| MessengerContactSelectedEvent | Event | orphans.swift |
| PhotomodeLightInitializedEvent | Event | orphans.swift |
| PhotomodeCameraSwitchedEvent | Event | orphans.swift |
| CleanupUiNotificationsEvent | Event | orphans.swift |
| PhotoModeMenuListItemData | ListItemData | orphans.swift |
| TutorialPopupData | inkGameNotificationData | orphans.swift |
| ExpansionErrorPopuppData | inkGameNotificationData | orphans.swift |
| OpenExpansionErrorPopupEvent | Event | orphans.swift |
| CodexPopupClosedEvent | Event | orphans.swift |
| FrameCancel | Event | orphans.swift |
| TwintoneOverrideData | inkGameNotificationData | orphans.swift |
| ShowTwintoneOverrideEvent | Event | orphans.swift |
| OnTwintoneOverrideClosedEvent | Event | orphans.swift |
| WorldMapFiltersList_Record | TweakDBRecord | orphans.swift |
| MappinUIFilterGroup_Record | TweakDBRecord | orphans.swift |
| WorldMapFilter_Record | TweakDBRecord | orphans.swift |
| MapMenuUserData | IScriptable | orphans.swift |
| inkWorldMapPreviewGameController | gameuiMenuGameController | orphans.swift |
| MapNavigationDelay | Event | orphans.swift |
| FilterButtonSpawnedData | IScriptable | orphans.swift |
| UpdateTrackedObjectiveEvent | Event | orphans.swift |
| RequestChangeTrackedObjective | Event | orphans.swift |
| QuestObjectiveHoverOverEvent | Event | orphans.swift |
| QuestObjectiveHoverOutEvent | Event | orphans.swift |
| ScrollToJournalEntryEvent | Event | orphans.swift |
| QuestListDistanceData | IScriptable | orphans.swift |
| QuestlListItemSelected | Event | orphans.swift |
| ActivateMapLink | Event | orphans.swift |
| ActivateLink | Event | orphans.swift |
| UpdateOpenedQuestEvent | Event | orphans.swift |
| FastTravelMappin | RuntimeMappin | orphans.swift |
| WorldMapSettings_Record | TweakDBRecord | orphans.swift |
| VehicleMappin | RuntimeMappin | orphans.swift |
| ValueAssignment_Record | ContentAssignment_Record | orphans.swift |
| VehicleOffer_Record | PurchaseOffer_Record | orphans.swift |
| RipperdocMappin_Record | UIIcon_Record | orphans.swift |
| RacingMappin_Record | TweakDBRecord | orphans.swift |
| MessengerContactSyncBackEvent | Event | orphans.swift |
| MessengerForceSelectionEvent | Event | orphans.swift |
| PlayerProximityStopEvent | Event | orphans.swift |
| AIPuppetSwappedEvent | Event | orphans.swift |
| AIPuppetTeleportedEvent | Event | orphans.swift |
| CrowdCallingPoliceEvent | Event | orphans.swift |
| CharacterCreationSummaryListItemData | IScriptable | orphans.swift |
| SpreadFearEvent | Event | orphans.swift |
| gameuiMorphInfo | gameuiCharacterCustomizationInfo | orphans.swift |
| gameuiAppearanceInfo | gameuiCharacterCustomizationInfo | orphans.swift |
| gameuiSwitcherInfo | gameuiCharacterCustomizationInfo | orphans.swift |
| CharacterCustomizationOption | IScriptable | orphans.swift |
| gameuiCharacterRandomizationParametersData | IScriptable | orphans.swift |
| gameuiCharacterCustomizationSystem_OnInitializeOptionsListEvent | Event | orphans.swift |
| gameuiCharacterCustomizationSystem_OnPresetAppliedEvent | Event | orphans.swift |
| gameuiCharacterCustomizationSystem_OnAppearanceAppliedEvent | Event | orphans.swift |
| gameuiCharacterCustomizationSystem_OnRandomizeCompleteEvent | Event | orphans.swift |
| gameuiCharacterCustomizationSystem_OnAppearanceSwitchedEvent | Event | orphans.swift |
| gameuiCharacterCustomizationSystem_OnOptionUpdatedEvent | Event | orphans.swift |
| gameuiCharacterCustomizationSystem_OnReFinalizeStateCompleteEvent | Event | orphans.swift |
| gameuiCharacterCustomizationSystem_OnCancelFinalizedStateUpdateEvent | Event | orphans.swift |
| UICharacterCreationAttribute_Record | TweakDBRecord | orphans.swift |
| NewPerksRequirementsLinks | IScriptable | orphans.swift |
| NewPerkCategory_Record | TweakDBRecord | orphans.swift |
| BuyNewPerk | NewPerkActionRequest | orphans.swift |
| SellNewPerk | NewPerkActionRequest | orphans.swift |
| RefreshPerkTooltipEvent | Event | orphans.swift |
| UpdatePlayerDevelopmentData | Event | orphans.swift |
| QuestMappinHighlightEvent | Event | orphans.swift |
| GogRewardEntryData | IScriptable | orphans.swift |
| GogRewardsEntryHoverOver | Event | orphans.swift |
| GogRewardsEntryHoverOut | Event | orphans.swift |
| DelayedUpdateLayoutEvent | Event | orphans.swift |
| DelayedUpdateLayoutCompletedEvent | Event | orphans.swift |
| ServerInfo | IScriptable | orphans.swift |
| UICharacterCreationAttributesPreset_Record | TweakDBRecord | orphans.swift |
| CharacterRandomizationCategoryUI_Record | TweakDBRecord | orphans.swift |
| StatsMenuUserData | inkUserData | orphans.swift |
| CharacterCreationTooltipData | MessageTooltipData | orphans.swift |
| PerkUtility_Record | TweakDBRecord | orphans.swift |
| PerkWeaponGroup_Record | TweakDBRecord | orphans.swift |
| GOGReward_Record | TweakDBRecord | orphans.swift |
| DisconnectClickedEvent | Event | orphans.swift |
| LinkClickedEvent | Event | orphans.swift |
| MainMenuTooltipData | IScriptable | orphans.swift |
| hubSelectorSingleSmallCarouselController | hubSelectorSingleCarouselController | orphans.swift |
| CharacterRandomizationCategoriesList_Record | TweakDBRecord | orphans.swift |
| CharacterRandomizationCategory_Record | TweakDBRecord | orphans.swift |
| QuestTrackingEvent | Event | orphans.swift |
| ShowEngagementScreen | IScriptable | orphans.swift |
| ShowInitializeUserScreen | IScriptable | orphans.swift |
| PatchNotesCheckData | IScriptable | orphans.swift |
| SingleplayerMenuData | inkUserData | orphans.swift |
| QuestFluffShardLinkController | BaseCodexLinkController | orphans.swift |
| RipperdocPerkHoverEvent | Event | orphans.swift |
| RipperdocPerkData | IScriptable | orphans.swift |
| NextFrameEvent | Event | orphans.swift |
| ArmorBarFinalizedEvent | Event | orphans.swift |
| HitReactionStopMotionExtraction | Event | orphans.swift |
| RipperdocShardData | IScriptable | orphans.swift |
| SettingsCategoryItemData | ListItemData | orphans.swift |
| PlayRelicIntroAnimationEvent | Event | orphans.swift |
| UpdateHDRCalibrationScreenEvt | Event | orphans.swift |
| TarotCardPreviewData | inkGameNotificationData | orphans.swift |
| TarotCardPreviewPopupEvent | Event | orphans.swift |
| CategoryClickedEvent | Event | orphans.swift |
| CyberwareSlotTooltipData | ATooltipData | orphans.swift |
| CapacityBarFinalizedEvent | Event | orphans.swift |
| ClothingSetIconsPopupData | inkGameNotificationData | orphans.swift |
| SetIconSelectEvent | Event | orphans.swift |
| DelayedHUDInitializeEvent | Event | orphans.swift |
| RetrySaveDataRequestDelay | Event | orphans.swift |
| TimeSkipFinishedEvent | Event | orphans.swift |
| TimeSkipCursorInitFinishedEvent | Event | orphans.swift |
| BreachUIParameters | IScriptable | orphans.swift |
| WardrobeWrappedInventoryItemData | WrappedInventoryItemData | orphans.swift |
| EquipmentAreaDisplays | IScriptable | orphans.swift |
| EquipmentAreaCategoryCreated | Event | orphans.swift |
| PhoneContactHiddenEvent | Event | orphans.swift |
| DelayedHighlightUpdateEvent | Event | orphans.swift |
| QuestEntryUserData | IScriptable | orphans.swift |
| ShowPointOfNoReturnPromptEvent | Event | orphans.swift |
| smartGunUIParameters | IScriptable | orphans.swift |
| PhoneTimeoutRequest | ScriptableSystemRequest | orphans.swift |
| DialogHubPostInitializeEvent | Event | orphans.swift |
| AISubActionPlayVoiceOver_Record | AISubAction_Record | orphans.swift |
| ContactSelectionChangedEvent | Event | orphans.swift |
| VehicleListItemData | IScriptable | orphans.swift |
| RadioListItemData | IScriptable | orphans.swift |
| AISubActionDisableCollider_Record | AISubAction_Record | orphans.swift |
| RefreshTooltipEvent | Event | orphans.swift |
| InvalidateTooltipHiddenStateEvent | Event | orphans.swift |
| AISubActionAddFact_Record | AISubAction_Record | orphans.swift |
| IVisualizerTimeProvider | IScriptable | orphans.swift |
| QuestListItemHoverOverEvent | Event | orphans.swift |
| QuestListItemHoverOutEvent | Event | orphans.swift |
| QuestListHeaderData | IScriptable | orphans.swift |
| AISubActionQueueAIEvent_Record | AISubAction_Record | orphans.swift |
| AISubActionQueueCommunicationEvent_Record | AISubAction_Record | orphans.swift |
| InventoryComboBoxItemsList | inkLogicController | orphans.swift |
| InventoryCyberwareDetails | inkLogicController | orphans.swift |
| InventoryComboBoxContentController | inkLogicController | orphans.swift |
| RadioStationChangedEvent | Event | orphans.swift |
| RadioStation_Record | TweakDBRecord | orphans.swift |
| MinimalLootingListItemData | IScriptable | orphans.swift |
| AISubActionSpawnFX_Record | AISubAction_Record | orphans.swift |
| MappinVariant_Record | TweakDBRecord | orphans.swift |
| QuestListHeaderClicked | Event | orphans.swift |
| QuestlListItemHover | Event | orphans.swift |
| QuestlListItemDelayedHover | Event | orphans.swift |
| AISubActionPlaySound_Record | AISubAction_Record | orphans.swift |
| AISubActionEquipOnSlot_Record | AISubActionCharacterRecordEquip_Record | orphans.swift |
| InventoryQuickSlotsDisplay | inkLogicController | orphans.swift |
| InteractionMappin | RuntimeMappin | orphans.swift |
| PingSystemMappin | RuntimeMappin | orphans.swift |
| Ping_Record | TweakDBRecord | orphans.swift |
| WardrobeOutfitSlotHoverOverEvent | Event | orphans.swift |
| WardrobeOutfitSlotHoverOutEvent | Event | orphans.swift |
| WardrobeOutfitSlotClickedEvent | Event | orphans.swift |
| RemotePlayerMappin | RuntimeMappin | orphans.swift |
| DummyTooltipData | ATooltipData | orphans.swift |
| MappinUIGlobalProfile_Record | TweakDBRecord | orphans.swift |
| IArea | IVisualObject | orphans.swift |
| GrenadeMappin | RuntimeMappin | orphans.swift |
| StealthMappin | RuntimeMappin | orphans.swift |
| MiniGameStateUpdateEventAdvanced | Event | orphans.swift |
| GameFinishEventAdvanced | Event | orphans.swift |
| MinigameStateAdvanced | IScriptable | orphans.swift |
| UIAnimation_Record | TweakDBRecord | orphans.swift |
| GridNoiseGenRule | MinigameGenerationRule | orphans.swift |
| MainProgramGenRule | MinigameGenerationRule | orphans.swift |
| ProgramFromDataGenRule | MinigameGenerationRule | orphans.swift |
| ProgramsGridGenRule | MinigameGenerationRule | orphans.swift |
| TrapsGenRule | MinigameGenerationRule | orphans.swift |
| PanzerMiniGameController | MinigameControllerAdvanced | orphans.swift |
| StubMappin | IMappin | orphans.swift |
| SendScoreRequestAdvanced | ScriptableSystemRequest | orphans.swift |
| QuadRacerGameState | MinigameState | orphans.swift |
| MinigameCollisionLogic | inkLogicController | orphans.swift |
| RoachRaceGameState | MinigameState | orphans.swift |
| HitPlayerEvent | Event | orphans.swift |
| MiniGameStateUpdateEvent | Event | orphans.swift |
| SendScoreRequest | ScriptableSystemRequest | orphans.swift |
| MinigameDynObject | inkLogicController | orphans.swift |
| MinigamePlayerController | inkLogicController | orphans.swift |
| TutorialArea | inkLogicController | orphans.swift |
| WidgetsPoolItemSpawnData | IScriptable | orphans.swift |
| ItemsPoolItemSpawnData | IScriptable | orphans.swift |
| ItemsPoolCachedData | IScriptable | orphans.swift |
| InvalidateTooltipOwnerEvent | Event | orphans.swift |
| TooltipLootingCachedData | IScriptable | orphans.swift |
| TutorialOverlayUserData | inkUserData | orphans.swift |
| ItemChooserUnequipVisuals | Event | orphans.swift |
| Codex_Record | TweakDBRecord | orphans.swift |
| CodexRecord_Record | TweakDBRecord | orphans.swift |
| CodexRecordPart_Record | TweakDBRecord | orphans.swift |
| CodexUnlockRecordRequest | ScriptableSystemRequest | orphans.swift |
| CodexLockRecordRequest | ScriptableSystemRequest | orphans.swift |
| CodexAddRecordRequest | ScriptableSystemRequest | orphans.swift |
| UnlockCodexPartRequest | ScriptableSystemRequest | orphans.swift |
| CodexPrintRecordsRequest | ScriptableSystemRequest | orphans.swift |
| AISubActionForceEquip_Record | AISubAction_Record | orphans.swift |
| VendorUIInventoryItemData | WrappedInventoryItemData | orphans.swift |
| VenodrRequestQueueEntry | IScriptable | orphans.swift |
| VendorJunkSellItem | IScriptable | orphans.swift |
| TrackedQuestPhaseUpdateRequest | Event | orphans.swift |
| NPCStartingDetectionEvent | Event | orphans.swift |
| NPCStoppingDetectionEvent | Event | orphans.swift |
| UINameplate_Record | TweakDBRecord | orphans.swift |
| UINameplateDisplayType_Record | TweakDBRecord | orphans.swift |
| ItemTooltipModuleSpawnedCallbackData | IScriptable | orphans.swift |
| ItemTooltipEquippedModule | ItemTooltipModuleController | orphans.swift |
| HideIconModuleEvent | Event | orphans.swift |
| RecipeItem_Record | Item_Record | orphans.swift |
| MinigameTooltipShowRequest | Event | orphans.swift |
| MinigameTooltipHideRequest | Event | orphans.swift |
| MiniGame_Trap_Record | TweakDBRecord | orphans.swift |
| AISubActionUnequipOnSlot_Record | AISubActionCharacterRecordUnequip_Record | orphans.swift |
| Minigame_Def_Record | TweakDBRecord | orphans.swift |
| RowSymbols_Record | TweakDBRecord | orphans.swift |
| RowTraps_Record | TweakDBRecord | orphans.swift |
| Program_Record | TweakDBRecord | orphans.swift |
| MinigameActionType_Record | TweakDBRecord | orphans.swift |
| MinigameCategory_Record | TweakDBRecord | orphans.swift |
| MinigameTrapType_Record | TweakDBRecord | orphans.swift |
| VehicleEngineData_Record | TweakDBRecord | orphans.swift |
| LootingScrollBlockController | IScriptable | orphans.swift |
| ShardTooltipWrapper | ATooltipData | orphans.swift |
| NewItemTooltipAttachmentEntrySpawnData | IScriptable | orphans.swift |
| VehicleUIactivateEvent | Event | orphans.swift |
| CrosshairGameController_Hercules | CrosshairGameController_Smart_Rifl | orphans.swift |
| AISubActionForceUnequip_Record | AISubAction_Record | orphans.swift |
| ForceBlackwallKillNPCSEvent | Event | orphans.swift |
| LateInit | Event | orphans.swift |
| EquipmentChangeTaskData | ScriptTaskData | orphans.swift |
| RadialWheelUserData | IScriptable | orphans.swift |
| NewItemTooltipModuleSpawnedCallbackData | IScriptable | orphans.swift |
| NewItemTooltipEquippedModule | NewItemTooltipModuleController | orphans.swift |
| CrosshairGameController_Jailbreak_Power | gameuiCrosshairBaseGameController | orphans.swift |
| CrosshairGameController_Jailbreak_Smart | gameuiCrosshairBaseGameController | orphans.swift |
| CrosshairGameController_Jailbreak_Tech | gameuiCrosshairBaseGameController | orphans.swift |
| AISubActionDisableAimAssist_Record | AISubAction_Record | orphans.swift |
| DeviceHackTier_Record | TweakDBRecord | orphans.swift |
| DeviceHackCategory_Record | TweakDBRecord | orphans.swift |
| AISubActionApplyTimeDilation_Record | AISubAction_Record | orphans.swift |
| EventEquipSlotSelectDelayedInventoryEvent | Event | orphans.swift |
| EventInventorySlotSelectDelayedInventoryEvent | Event | orphans.swift |
| DelayedRefreshItems | Event | orphans.swift |
| DelayedItemEquipped | Event | orphans.swift |
| OutfitWardrobeSlotSpawnData | IScriptable | orphans.swift |
| ItemModeItemChanged | Event | orphans.swift |
| InstallModConfirmationData | IScriptable | orphans.swift |
| OpenInventoryQuantityPickerRequest | Event | orphans.swift |
| CyberwareSlotSpawnData | IScriptable | orphans.swift |
| DelayedSetItemModeShown | Event | orphans.swift |
| DelayedRefreshUI | Event | orphans.swift |
| VulnerabilityUserData | IScriptable | orphans.swift |
| AISubActionModifyStatPool_Record | AISubAction_Record | orphans.swift |
| MinimapSecurityAreaInitData | MappinControllerCustomData | orphans.swift |
| AISubActionForceDeath_Record | AISubAction_Record | orphans.swift |
| AbilityUserData | IScriptable | orphans.swift |
| AISubActionStatusEffect_Record | AISubAction_Record | orphans.swift |
| gameuiTooltipAttachmentSlot | inkLogicController | orphans.swift |
| StealthZonesGameController | inkHUDGameController | orphans.swift |
| RadialMenuItem | inkHUDGameController | orphans.swift |
| AISubActionGameplayLogicPackage_Record | AISubAction_Record | orphans.swift |
| AISubActionSetInt_Record | AISubAction_Record | orphans.swift |
| QuickSlotButtonHoldEndEvent | Event | orphans.swift |
| AISubActionReloadWeapon_Record | AISubAction_Record | orphans.swift |
| AISubActionTriggerStim_Record | AISubAction_Record | orphans.swift |
| AISubActionChangeAttitude_Record | AISubAction_Record | orphans.swift |
| RequirementUserData | IScriptable | orphans.swift |
| ThrowingKnifeReloadFinishedCrosshairEvent | Event | orphans.swift |
| AISubActionThrowItem_Record | AISubAction_Record | orphans.swift |
| HUDButtonHints | inkGameController | orphans.swift |
| questUpdateEntityHealthListenersEvent | Event | orphans.swift |
| VendorInventoryItemData | WrappedInventoryItemData | orphans.swift |
| LogTutorialHintActionEvent | Event | orphans.swift |
| AddInputGroupEvent | Event | orphans.swift |
| DeleteInputGroupEvent | Event | orphans.swift |
| InputHintManagerGameController | inkGameController | orphans.swift |
| NormalizeAndSaveSwayEvent | Event | orphans.swift |
| RefreshSellQueueEvent | Event | orphans.swift |
| RefreshBuyQueueEvent | Event | orphans.swift |
| PhoneMessageHidePopupEvent | Event | orphans.swift |
| ClearFearOnHitEvent | Event | orphans.swift |
| AISubActionTriggerItemActivation_Record | AISubAction_Record | orphans.swift |
| AIDeathConditions | AIbehaviorconditionScript | orphans.swift |
| AISubActionAttackWithWeapon_Record | AISubAction_Record | orphans.swift |
| SetWeaponOwnerEvent | Event | orphans.swift |
| PlayerVehicleDisplayOverride_Record | TweakDBRecord | orphans.swift |
| HitConditions | AIbehaviorconditionScript | orphans.swift |
| CheckStimID | AIbehaviorconditionScript | orphans.swift |
| CompareArguments | AIbehaviorconditionScript | orphans.swift |
| AIDebugConditions | AIbehaviorconditionScript | orphans.swift |
| QuickhackDescriptionUpdate | Event | orphans.swift |
| AINPCStateCheck | AIbehaviorconditionScript | orphans.swift |
| AISubActionRegisterActionName_Record | AISubAction_Record | orphans.swift |
| AISubActionMeleeAttackManager_Record | AISubAction_Record | orphans.swift |
| AITimeCondition | AIbehaviorconditionScript | orphans.swift |
| AIItemHandlingCondition | AIbehaviorconditionScript | orphans.swift |
| AISubActionShootToPoint_Record | AISubActionShootWithWeapon_Record | orphans.swift |
| AISubActionMissileRainGrid_Record | AISubActionShootWithWeapon_Record | orphans.swift |
| AISubActionMissileRainCircular_Record | AISubActionShootWithWeapon_Record | orphans.swift |
| AISubActionChimeraMetalstorm_Record | AISubActionShootWithWeapon_Record | orphans.swift |
| AISubActionShootFromCar_Record | AISubAction_Record | orphans.swift |
| UndelectAllItemsDelayedEvent | Event | orphans.swift |
| ChangeNPCState | AIbehaviortaskScript | orphans.swift |
| RagdollTask | AIbehaviortaskScript | orphans.swift |
| FollowVehicleTask | AIbehaviortaskScript | orphans.swift |
| DelayPassiveConditionEvaluationEvent | Event | orphans.swift |
| SquadTask | AIbehaviortaskScript | orphans.swift |
| WorkSpotTask | AIbehaviortaskScript | orphans.swift |
| AIPatrolPathParameters | IScriptable | orphans.swift |
| PatrolSplineProgress | IScriptable | orphans.swift |
| AICoreTasks | AIbehaviortaskScript | orphans.swift |
| DisassembleEvent | Event | orphans.swift |
| AISubActionCreateGameEffect_Record | AISubAction_Record | orphans.swift |
| AIBackgroundCombatCommand | AICommand | orphans.swift |
| SpiderbotOrderCompletedEvent | Event | orphans.swift |
| AISubActionInAir_Record | AISubAction_Record | orphans.swift |
| ShardCaseContainerPS | gameLootContainerBasePS | orphans.swift |
| Damage | IScriptable | orphans.swift |
| AIUnmountCommand | AIBaseMountCommand | orphans.swift |
| StatusEffectActions | AIbehaviortaskScript | orphans.swift |
| WeaponJammedAction | StatusEffectActions | orphans.swift |
| StatusEffectTasks | AIbehaviortaskScript | orphans.swift |
| StatusEffectAIBehaviorType_Record | TweakDBRecord | orphans.swift |
| StrikeDuration_Debug | EffectDurationModifier_Scripted | orphans.swift |
| DEBUG_RebalanceItemEvent | Event | orphans.swift |
| NormalDeathTask | AIDeathReactionsTask | orphans.swift |
| EffectPreAction_PreAttack_WithFriendlyFire | EffectPreAction_PreAttack | orphans.swift |
| VehicleColorSelectionSliderHoldEvent | Event | orphans.swift |
| VehicleColorSelectionUpdateEvent | Event | orphans.swift |
| VehicleVisualCustomizationPreviewSetup_Record | TweakDBRecord | orphans.swift |
| VehicleVisualCustomizationPreviewGlowSetup_Record | TweakDBRecord | orphans.swift |
| ScreenMessageData_Record | TweakDBRecord | orphans.swift |
| ScreenMessagesList_Record | TweakDBRecord | orphans.swift |
| DayPassedEvent | Event | orphans.swift |
| WorkspotList | IScriptable | orphans.swift |
| ConfessionCompletedEvent | Event | orphans.swift |
| InteractiveSignControllerPS | ScriptableDeviceComponentPS | orphans.swift |
| InteractiveSignDeviceWidgetController | DeviceWidgetControllerBase | orphans.swift |
| VehicleUnlockType_Record | TweakDBRecord | orphans.swift |
| VehicleShopBackEvent | Event | orphans.swift |
| VehicleShopPurchaseEvent | Event | orphans.swift |
| TargetAcquiredEvent | Event | orphans.swift |
| TargetLostEvent | Event | orphans.swift |
| ToggleGlassTintHack | ToggleGlassTint | orphans.swift |
| RipperdocRefreshMinigridsEvent | Event | orphans.swift |
| NcartTimeTableCounterUpdateEvent | Event | orphans.swift |
| HackingMiniGame_Record | TweakDBRecord | orphans.swift |
| Trap_Record | TweakDBRecord | orphans.swift |
| IndustrialArmDamageEvent | Event | orphans.swift |
| SWidgetPackageWrapper | IScriptable | orphans.swift |
| DocumentCustomData | IScriptable | orphans.swift |
| BarbedWireControllerPS | ActivatedDeviceControllerPS | orphans.swift |
| AISubActionSetInfluenceMap_Record | AISubAction_Record | orphans.swift |
| ImageButtonCustomData | WidgetCustomData | orphans.swift |
| worldITriggerAreaNotiferInstance | IScriptable | orphans.swift |
| TriggerNotifier_ScriptInstance | worldITriggerAreaNotiferInstance | orphans.swift |
| AISubActionSetStimSource_Record | AISubAction_Record | orphans.swift |
| TrafficLightListenerComponent | IComponent | orphans.swift |
| AISubActionWorkspot_Record | AISubAction_Record | orphans.swift |
| TrapPhysicsActivationEvent | Event | orphans.swift |
| AISubActionChangeCoverSelectionPreset_Record | AISubAction_Record | orphans.swift |
| gameConveyorControlEvent | Event | orphans.swift |
| DeviceDynamicConnectionChange | Event | orphans.swift |
| AISubActionStartCooldown_Record | AISubAction_Record | orphans.swift |
| AISubActionSquadSync_Record | AISubAction_Record | orphans.swift |
| MasterDeviceComponent | GameComponent | orphans.swift |
| AISubActionSecuritySystemNotification_Record | AISubAction_Record | orphans.swift |
| AIActionSecurityNotificationType_Record | TweakDBRecord | orphans.swift |
| AlarmEvent | Event | orphans.swift |
| BackDoorObjectiveData | GemplayObjectiveData | orphans.swift |
| ControlPanelObjectiveData | GemplayObjectiveData | orphans.swift |
| AISubActionCallSquadSearchBackUp_Record | AISubAction_Record | orphans.swift |
| CleanPasswordEvent | Event | orphans.swift |
| panelApperanceSwitchEvent | Event | orphans.swift |
| EnvLight_Record | TweakDBRecord | orphans.swift |
| StimPropagation_Record | TweakDBRecord | orphans.swift |
| VehicleReadyInteractionDelayEvent | Event | orphans.swift |
| VehicleCycleLightsEvent | Event | orphans.swift |
| ActivatorOperationTriggerData | DeviceOperationTriggerData | orphans.swift |
| DoorColliderEnableEvent | Event | orphans.swift |
| DropPointModule | Device | orphans.swift |
| BunkerMapObject | GameObject | orphans.swift |
| DebugRemoteConnectionEvent | Event | orphans.swift |
| ForkliftCompleteActivateEvent | Event | orphans.swift |
| SensorJammed | Event | orphans.swift |
| ExplosiveTriggerDeviceProximityEvent | Event | orphans.swift |
| AISubActionQuickHack_Record | AISubAction_Record | orphans.swift |
| SmartBulletDeflectedEvent | Event | orphans.swift |
| ResetAttackBlockedBlackBoardValue | Event | orphans.swift |
| AISubActionActivateStrongArmsFX_Record | AISubAction_Record | orphans.swift |
| AISubActionMountVehicle_Record | AISubAction_Record | orphans.swift |
| SecretOpenAnimationEvent | Event | orphans.swift |
| AISubActionUseSensePreset_Record | AISubAction_Record | orphans.swift |
| AISubActionConditionalFailure_Record | AISubAction_Record | orphans.swift |
| WindowBlindersReplicatedState | DeviceReplicatedState | orphans.swift |
| AISubActionCompleteCommand_Record | AISubAction_Record | orphans.swift |
| AISubActionLeaveCover_Record | AISubAction_Record | orphans.swift |
| AISubActionCustomEffectors_Record | AISubAction_Record | orphans.swift |
| RefreshSlavesState | Event | orphans.swift |
| AIActionAND_Record | AIActionSubCondition_Record | orphans.swift |
| PresetTimetableEvent | Event | orphans.swift |
| AISubActionActivateLightPreset_Record | AISubAction_Record | orphans.swift |
| BlinkingEvent | Event | orphans.swift |
| AISubActionFailIfFriendlyFire_Record | AISubAction_Record | orphans.swift |
| AISubActionUpdateFriendlyFireParams_Record | AISubAction_Record | orphans.swift |
| AISubActionSendSignal_Record | AISubAction_Record | orphans.swift |
| AISubActionFastExitWorkspot_Record | AISubAction_Record | orphans.swift |
| PhysicalHackingEvent | Event | orphans.swift |
| PortalControllerPS | ScriptableDeviceComponentPS | orphans.swift |
| AIActionOR_Record | AIActionSubCondition_Record | orphans.swift |
| AISubActionMeleeAttackAttemptEvent_Record | AISubAction_Record | orphans.swift |
| AISubActionSetWorldPosition_Record | AISubAction_Record | orphans.swift |
| AIActionTicket_Record | AITicket_Record | orphans.swift |
| AIActionType_Record | TweakDBRecord | orphans.swift |
| AIAffiliationCond_Record | AIActionSubCondition_Record | orphans.swift |
| AICanShootInCarChaseCond_Record | AIActionSubCondition_Record | orphans.swift |
| AICommand_Record | TweakDBRecord | orphans.swift |
| AIComparison_Record | TweakDBRecord | orphans.swift |
| TeleportToLinkedPortalEvent | Event | orphans.swift |
| AICooldownCond_Record | AIActionSubCondition_Record | orphans.swift |
| ToggleStreamOnLinkedPortalEvent | Event | orphans.swift |
| AIDifficulty_Record | TweakDBRecord | orphans.swift |
| AIDirectorEntryStartType_Record | TweakDBRecord | orphans.swift |
| AIDirectorSchedule_Record | TweakDBRecord | orphans.swift |
| AIDirectorScheduleEntry_Record | TweakDBRecord | orphans.swift |
| AIDirectorSchedulePlan_Record | TweakDBRecord | orphans.swift |
| AIDirectorSchedulePlanEnemyEntry_Record | TweakDBRecord | orphans.swift |
| AIDirectorScheduleSpawningDesc_Record | TweakDBRecord | orphans.swift |
| ChangeCasinoTableStateEvent | Event | orphans.swift |
| AIDriverCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIFriendlyFireCond_Record | AIActionSubCondition_Record | orphans.swift |
| UpdateGatePosition | Event | orphans.swift |
| AIInArmedVehicleCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIInTacticPositionCond_Record | AIActionSubCondition_Record | orphans.swift |
| AIIsFromDynamicSpawnSystem_Record | AIActionSubCondition_Record | orphans.swift |
| AIIsFromPreventionSystem_Record | AIActionSubCondition_Record | orphans.swift |
| AIIsHeatStage5Active_Record | AIActionSubCondition_Record | orphans.swift |
| AIIsShootingBlockedFromPrevention_Record | AIActionSubCondition_Record | orphans.swift |
| AINodeMap_Record | TweakDBRecord | orphans.swift |
| Disarm | Event | orphans.swift |
| Arm | Event | orphans.swift |
| AINodeMapField_Record | TweakDBRecord | orphans.swift |
| AVSpawnedRequest | ScriptableSystemRequest | orphans.swift |
| PreventionConsoleLockRequest | ScriptableSystemRequest | orphans.swift |
| AnimFeature_ChestPress | AnimFeature | orphans.swift |
| AISquadClosestToSectorCheck_Record | AISquadDistanceRelationToSectorCheck_Record | orphans.swift |
| AISquadClosestToTargetCheck_Record | AISquadDistanceRelationToTargetCheck_Record | orphans.swift |
| SpawnMaxTacAVWithDelayRequest | ScriptableSystemRequest | orphans.swift |
| PreventionDelayedSpawnBaseRequest | ScriptableSystemRequest | orphans.swift |
| NoReactionPerformedRequest | ScriptableSystemRequest | orphans.swift |
| ClearPreventionSystemLocks | ScriptableSystemRequest | orphans.swift |
| AISquadFurthestToSectorCheck_Record | AISquadDistanceRelationToSectorCheck_Record | orphans.swift |
| AISquadFurthestToTargetCheck_Record | AISquadDistanceRelationToTargetCheck_Record | orphans.swift |
| LightSwitchRequest | Event | orphans.swift |
| WeaponTrainingControllerPS | ScriptableDeviceComponentPS | orphans.swift |
| AISquadType_Record | TweakDBRecord | orphans.swift |
| DepleteCharges | Event | orphans.swift |
| AnimFeatureServer | AnimFeature | orphans.swift |
| AISubActionBlockData_Record | AISubAction_Record | orphans.swift |
| AISubActionCallReinforcements_Record | AISubAction_Record | orphans.swift |
| KillTaggedTargetEvent | Event | orphans.swift |
| ReevaluateTargetsEvent | Event | orphans.swift |
| RegisterPerkDeviceMappinRequest | ScriptableSystemRequest | orphans.swift |
| SetPerkDeviceAsUsedRequest | ScriptableSystemRequest | orphans.swift |
| TriggerPlayerAreaCheck | Event | orphans.swift |
| PerkDeviceTickEvent | TickableEvent | orphans.swift |
| AISubActionDroneModifyAltitude_Record | AISubAction_Record | orphans.swift |
| AISubActionEquipOnBody_Record | AISubActionCharacterRecordEquip_Record | orphans.swift |
| AISubActionFail_Record | AISubAction_Record | orphans.swift |
| DelaySpawning | Event | orphans.swift |
| InteractiveAdFinishedEvent | Event | orphans.swift |
| AISubActionGeneratePointOfInterestTarget_Record | AISubAction_Record | orphans.swift |
| AISubActionHitData_Record | AISubAction_Record | orphans.swift |
| AISubActionInitialReaction_Record | AISubAction_Record | orphans.swift |
| VirtualMasterDevice | Device | orphans.swift |
| AISubActionScaleDurationWithDistance_Record | AISubAction_Record | orphans.swift |
| AISubActionSetEquipPrimaryWeapons_Record | AISubActionCharacterRecordEquip_Record | orphans.swift |
| AISubActionSetEquipSecondaryWeapons_Record | AISubActionCharacterRecordEquip_Record | orphans.swift |
| AISubActionSetItemAsTarget_Record | AISubActionSetTargetByTag_Record | orphans.swift |
| AISubActionSetTopThreatPersistance_Record | AISubAction_Record | orphans.swift |
| AISubActionSetUnequipPrimaryWeapons_Record | AISubActionCharacterRecordUnequip_Record | orphans.swift |
| AISubActionSetUnequipSecondaryWeapons_Record | AISubActionCharacterRecordUnequip_Record | orphans.swift |
| AISubActionSetWaypointByTag_Record | AISubActionSetTargetByTag_Record | orphans.swift |
| grenadeSpawner | WeaponObject | orphans.swift |
| MineDispenser | WeaponObject | orphans.swift |
| RewireEvent | Event | orphans.swift |
| DrillScanPostProcessEvent | Event | orphans.swift |
| DrillScanEvent | Event | orphans.swift |
| DrillerUIEvent | Event | orphans.swift |
| AITacticType_Record | TweakDBRecord | orphans.swift |
| RespawnHealthConsumable | Event | orphans.swift |
| DrillerScanEvent | Event | orphans.swift |
| drillMachineEvent | Event | orphans.swift |
| MineArmEvent | Event | orphans.swift |
| MineDespawnEvent | Event | orphans.swift |
| PlaceMineEvent | Event | orphans.swift |
| ToggleBulletBendingEvent | Event | orphans.swift |
| MagFieldHitEvent | Event | orphans.swift |
| AbsoluteZLimiterCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| ActionMap_Record | TweakDBRecord | orphans.swift |
| Attack_Projectile | IAttack | orphans.swift |
| ActionMapField_Record | TweakDBRecord | orphans.swift |
| ActionPayment_Record | ObjectAction_Record | orphans.swift |
| PlayerClimbInfo | IScriptable | orphans.swift |
| ActionWidgetDefinition_Record | WidgetDefinition_Record | orphans.swift |
| AddDevelopmentPointEffector_Record | Effector_Record | orphans.swift |
| AddHitFlagToAttackEffector_Record | Effector_Record | orphans.swift |
| AverageNormalResult | IScriptable | orphans.swift |
| AverageNormalQuery | IScriptable | orphans.swift |
| AddStatusEffectToAttackEffector_inline0_Record | ConstantStatModifier_Record | orphans.swift |
| Advertisement_Record | TweakDBRecord | orphans.swift |
| AdvertisementFormatDef_Record | TweakDBRecord | orphans.swift |
| AdvertisementFormatsEnum_Record | TweakDBRecord | orphans.swift |
| AdvertisementGroup_Record | TweakDBRecord | orphans.swift |
| ClearAllWeaponSlotsRequest | PlayerScriptableSystemRequest | orphans.swift |
| AimAssistAimSnap_Record | TweakDBRecord | orphans.swift |
| AimAssistBulletMagnetism_Record | TweakDBRecord | orphans.swift |
| AimAssistCommon_Record | TweakDBRecord | orphans.swift |
| DelayedComDeviceClose | Event | orphans.swift |
| ResetMagFieldHitsEvent | Event | orphans.swift |
| ResetTickEvent | TickableEvent | orphans.swift |
| ComDeviceTransition | DefaultTransition | orphans.swift |
| CommunityProxyPSPresentEvent | Event | orphans.swift |
| AimAssistFinishing_Record | TweakDBRecord | orphans.swift |
| AimAssistMagnetism_Record | TweakDBRecord | orphans.swift |
| RefreshPlayerItemSlotsEvent | Event | orphans.swift |
| AimAssistTargetData_Record | TweakDBRecord | orphans.swift |
| ClearAnimFeatureCarryEvent | Event | orphans.swift |
| HalloweenEvent | Event | orphans.swift |
| AimAssistType_Record | TweakDBRecord | orphans.swift |
| AngleDistanceCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| AngleRange_Record | SenseShape_Record | orphans.swift |
| Appearance_Record | TweakDBRecord | orphans.swift |
| ApperanceToEthnicities_Record | TweakDBRecord | orphans.swift |
| ApperanceToEthnicitiesMap_Record | TweakDBRecord | orphans.swift |
| NewCycleEvent | Event | orphans.swift |
| LocomotionSceneInitData | IScriptable | orphans.swift |
| ApplyStatusEffectByChanceEffector_inline0_Record | ConstantStatModifier_Record | orphans.swift |
| ArcadeBackgroundLayer_Record | TweakDBRecord | orphans.swift |
| ArcadeMenu_Record | TweakDBRecord | orphans.swift |
| ArcadeMinigameData_Record | TweakDBRecord | orphans.swift |
| PlayerStateMachineTestFiveInput | IScriptable | orphans.swift |
| SafeCrosshairStateEvents | BaseCrosshairStateEvents | orphans.swift |
| ArcadeMinigameDataList_Record | TweakDBRecord | orphans.swift |
| PlayerStateMachineTestFourInput | IScriptable | orphans.swift |
| PlayerStateMachineTestFourOutput | IScriptable | orphans.swift |
| DriverCombatMountedWeaponsReloadCrosshairStateEvents | BaseCrosshairStateEvents | orphans.swift |
| PlayerStateMachineTestThreeOutput | IScriptable | orphans.swift |
| ArcadeScoreboard_Record | TweakDBRecord | orphans.swift |
| QuickHackCrosshairStateEvents | BaseCrosshairStateEvents | orphans.swift |
| ArcadeScoreboardEntry_Record | TweakDBRecord | orphans.swift |
| ArcadeSpawnableID_Record | TweakDBRecord | orphans.swift |
| ArcadeSpawnableObject_Record | TweakDBRecord | orphans.swift |
| gameDevicePSChanged | Event | orphans.swift |
| AttachableObject_Record | SpawnableObject_Record | orphans.swift |
| BreachAccessPointEvent | Event | orphans.swift |
| SetInvestigationPositionsArrayEvent | Event | orphans.swift |
| Attack_Landing_Record | Attack_GameEffect_Record | orphans.swift |
| IdleTier4Decisions | LocomotionGroundDecisions | orphans.swift |
| Attack_Projectile_Record | Attack_Record | orphans.swift |
| IdleTier5Decisions | LocomotionGroundDecisions | orphans.swift |
| Attitude_Record | TweakDBRecord | orphans.swift |
| AvoidLineOfSightSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| BaseDrivingParameters_Record | TweakDBRecord | orphans.swift |
| BikeDriveModelData_Record | VehicleDriveModelData_Record | orphans.swift |
| ConsumableCleanupDecisions | ConsumableTransitions | orphans.swift |
| Bounce_Record | ProjectileCollision_Record | orphans.swift |
| lookAtPresetGunBaseDecisions | LookAtPresetBaseDecisions | orphans.swift |
| Box_Record | SenseShape_Record | orphans.swift |
| LookAtPresetMeleeBaseDecisions | LookAtPresetBaseDecisions | orphans.swift |
| LookAtPresetMeleeBaseEvents | LookAtPresetBaseEvents | orphans.swift |
| lookAtPresetItemBaseDecisions | LookAtPresetBaseDecisions | orphans.swift |
| lookAtPresetItemBaseEvents | LookAtPresetBaseEvents | orphans.swift |
| UnarmedLookAtEvents | LookAtPresetBaseEvents | orphans.swift |
| AssualtRifleLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| AssualtRifleLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| FistsLookAtDecisions | LookAtPresetMeleeBaseDecisions | orphans.swift |
| FistsLookAtEvents | LookAtPresetMeleeBaseEvents | orphans.swift |
| HammerLookAtDecisions | LookAtPresetMeleeBaseDecisions | orphans.swift |
| HammerLookAtEvents | LookAtPresetMeleeBaseEvents | orphans.swift |
| HandgunLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| HandgunLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| HmgLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| HmgLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| KatanaLookAtDecisions | LookAtPresetMeleeBaseDecisions | orphans.swift |
| KatanaLookAtEvents | LookAtPresetMeleeBaseEvents | orphans.swift |
| KnifeLookAtDecisions | LookAtPresetMeleeBaseDecisions | orphans.swift |
| KnifeLookAtEvents | LookAtPresetMeleeBaseEvents | orphans.swift |
| LmgLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| LmgLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| LongBladeLookAtDecisions | LookAtPresetMeleeBaseDecisions | orphans.swift |
| LongBladeLookAtEvents | LookAtPresetMeleeBaseEvents | orphans.swift |
| MeleeLookAtDecisions | LookAtPresetMeleeBaseDecisions | orphans.swift |
| MeleeLookAtEvents | LookAtPresetMeleeBaseEvents | orphans.swift |
| OneHandedClubLookAtDecisions | LookAtPresetMeleeBaseDecisions | orphans.swift |
| OneHandedClubLookAtEvents | LookAtPresetMeleeBaseEvents | orphans.swift |
| CPOItemCategoryBase_Record | TweakDBRecord | orphans.swift |
| PrecisionRifleLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| CPOLoadoutBase_Record | TweakDBRecord | orphans.swift |
| PrecisionRifleLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| RevolverLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| RevolverLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| RifleLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| RifleLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| ShortBladeLookAtDecisions | LookAtPresetMeleeBaseDecisions | orphans.swift |
| ShortBladeLookAtEvents | LookAtPresetMeleeBaseEvents | orphans.swift |
| ShotgunLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| ShotgunLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| ShotgunDualLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| CarriableObject_Record | SpawnableObject_Record | orphans.swift |
| ShotgunDualLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| SniperRifleLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| SniperRifleLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| SmgLookAtDecisions | lookAtPresetGunBaseDecisions | orphans.swift |
| SmgLookAtEvents | lookAtPresetGunBaseEvents | orphans.swift |
| TwoHandedClubLookAtDecisions | LookAtPresetMeleeBaseDecisions | orphans.swift |
| TwoHandedClubLookAtEvents | LookAtPresetMeleeBaseEvents | orphans.swift |
| GrenadeLookAtDecisions | lookAtPresetItemBaseDecisions | orphans.swift |
| GrenadeLookAtEvents | lookAtPresetItemBaseEvents | orphans.swift |
| FinisherAttackDecisions | FinisherTransition | orphans.swift |
| TurretRipOffDecisions | TurretTransition | orphans.swift |
| TurretEndDecisions | TurretTransition | orphans.swift |
| CharacterEntry_Record | TweakDBRecord | orphans.swift |
| CharacterList_Record | TweakDBRecord | orphans.swift |
| ChatterHelperRadius_Record | TweakDBRecord | orphans.swift |
| StaminaEventsTransition | StaminaTransition | orphans.swift |
| ChoiceCaptionPartType_Record | TweakDBRecord | orphans.swift |
| ChoiceCaptionTagPart_Record | ChoiceCaptionPart_Record | orphans.swift |
| ClearLineOfSightCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| ClosestToOwnerCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| Clothing_Record | Item_Record | orphans.swift |
| Clothing_inline0_Record | ConstantStatModifier_Record | orphans.swift |
| FinisherEndDecisions | FinisherTransition | orphans.swift |
| CompanionDistancePreset_Record | TweakDBRecord | orphans.swift |
| CompoundSelectionPreset_Record | TweakDBRecord | orphans.swift |
| ComputerScreenType_Record | DeviceScreenType_Record | orphans.swift |
| ComputerUIStyle_Record | TweakDBRecord | orphans.swift |
| Cone_Record | SenseShape_Record | orphans.swift |
| ConsumableChargesPrereq_Record | StatPoolPrereq_Record | orphans.swift |
| StandLowGravityDecisions | LocomotionGroundDecisions | orphans.swift |
| ContainerType_Record | TweakDBRecord | orphans.swift |
| ControlledLootSet_Record | TweakDBRecord | orphans.swift |
| ControlledLootTable_Record | TweakDBRecord | orphans.swift |
| CooldownType_Record | TweakDBRecord | orphans.swift |
| CoverHealthCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| CoverSelectionPreset_Record | TweakDBRecord | orphans.swift |
| CoverTypeCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| Crosshair_Record | TweakDBRecord | orphans.swift |
| CrowdSettingsPackageBase_Record | TweakDBRecord | orphans.swift |
| CrowdSlotMovementPatternBase_Record | TweakDBRecord | orphans.swift |
| CrowdSlotMovementSettingsBase_Record | TweakDBRecord | orphans.swift |
| CurrencyReward_inline0_Record | ConstantStatModifier_Record | orphans.swift |
| Curves_Record | TweakDBRecord | orphans.swift |
| CyberwareArea_Record | EquipmentArea_Record | orphans.swift |
| DefenseMode_Record | TweakDBRecord | orphans.swift |
| DestructibleObject_Record | BaseObject_Record | orphans.swift |
| DetectionCurve_Record | TweakDBRecord | orphans.swift |
| DevelopmentPoint_Record | TweakDBRecord | orphans.swift |
| DeviceAreaAttack_Record | Attack_GameEffect_Record | orphans.swift |
| DeviceContentAssignment_Record | ContentAssignment_Record | orphans.swift |
| DeviceWidgetDefinition_Record | WidgetDefinition_Record | orphans.swift |
| CombatGadgetStartEvents | DefaultTransition | orphans.swift |
| DistanceFromOthersCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| State | MorphData | orphans.swift |
| LocomotionAirLowGravityEvents | LocomotionAirEvents | orphans.swift |
| Blacklist | MorphData | orphans.swift |
| Reprimand | MorphData | orphans.swift |
| ProtectedEntities | MorphData | orphans.swift |
| EntitiesAtGate | MorphData | orphans.swift |
| DriveHelperType_Record | TweakDBRecord | orphans.swift |
| DriveWheelsAccelerateNoise_Record | DriveHelper_Record | orphans.swift |
| DroneAnimationSetup_Record | TweakDBRecord | orphans.swift |
| DynamicDownforceHelper_Record | DriveHelper_Record | orphans.swift |
| DynamicVehicleData_Record | TweakDBRecord | orphans.swift |
| NetrunnerPrototypeSpawnRequestEvent | Event | orphans.swift |
| NetrunnerPrototypeSpawnCompletedEvent | Event | orphans.swift |
| NetrunnerPrototypeDespawnEvent | Event | orphans.swift |
| NetrunnerPrototypeNetworkNode | GameObject | orphans.swift |
| EthnicNames_Record | TweakDBRecord | orphans.swift |
| Ethnicity_Record | TweakDBRecord | orphans.swift |
| FacialPreset_Record | TweakDBRecord | orphans.swift |
| FastTravelBinkData_Record | TweakDBRecord | orphans.swift |
| FastTravelBinksGroup_Record | TweakDBRecord | orphans.swift |
| AbstractLandDecisions | LocomotionGroundDecisions | orphans.swift |
| RegularLandLowGravityDecisions | AbstractLandDecisions | orphans.swift |
| FastTravelScreenData_Record | TweakDBRecord | orphans.swift |
| FastTravelScreenDataGroup_Record | TweakDBRecord | orphans.swift |
| FocusClue_Record | ScannableData_Record | orphans.swift |
| Footstep_Record | TweakDBRecord | orphans.swift |
| FriendlyTargetAngleDistanceCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| FriendlyTargetDistanceCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| FxActionType_Record | TweakDBRecord | orphans.swift |
| Gender_Record | TweakDBRecord | orphans.swift |
| GenderEntity_Record | TweakDBRecord | orphans.swift |
| GenericHighwaySign_Record | BaseSign_Record | orphans.swift |
| GenericMetroSign_Record | BaseSign_Record | orphans.swift |
| GenericStreetNameSign_Record | BaseSign_Record | orphans.swift |
| VoicesetComponent | GameComponent | orphans.swift |
| HUD_Preset_Entry_Record | TweakDBRecord | orphans.swift |
| IRandomizationSupervisor | IScriptable | orphans.swift |
| ScriptedRandomizationSupervisor | IRandomizationSupervisor | orphans.swift |
| HandbrakeFrictionModifier_Record | DriveHelper_Record | orphans.swift |
| HandicapLootList_Record | TweakDBRecord | orphans.swift |
| HandicapLootPreset_Record | TweakDBRecord | orphans.swift |
| HomingParameters_Record | TweakDBRecord | orphans.swift |
| IconsGeneratorContext_Record | TweakDBRecord | orphans.swift |
| ImprovementRelation_Record | TweakDBRecord | orphans.swift |
| InAirGravityModifier_Record | DriveHelper_Record | orphans.swift |
| InitLoadingScreen_Record | TweakDBRecord | orphans.swift |
| InventoryItemGroup_Record | TweakDBRecord | orphans.swift |
| IsHackable_Record | TweakDBRecord | orphans.swift |
| CompletionOfFirstEquipRequest | ScriptableSystemRequest | orphans.swift |
| PlayerWeaponSetupEvent | Event | orphans.swift |
| UpdateWeaponStatsEvent | Event | orphans.swift |
| StimTargets_Record | TweakDBRecord | orphans.swift |
| BluelineSelectedRequest | PlayerScriptableSystemRequest | orphans.swift |
| ItemArrayQuery_Record | ItemQuery_Record | orphans.swift |
| ItemBlueprint_Record | TweakDBRecord | orphans.swift |
| UnlockAllAchievementsRequest | ScriptableSystemRequest | orphans.swift |
| ResetLightHitsReceivedRequest | ScriptableSystemRequest | orphans.swift |
| ResetStrongHitsReceivedRequest | ScriptableSystemRequest | orphans.swift |
| ResetFinalComboHitsReceivedRequest | ScriptableSystemRequest | orphans.swift |
| ResetBlockAttackHitsReceivedRequest | ScriptableSystemRequest | orphans.swift |
| ResetBlockedHitsRequest | ScriptableSystemRequest | orphans.swift |
| ResetDeflectedHitsRequest | ScriptableSystemRequest | orphans.swift |
| ResetGuardBreakRequest | ScriptableSystemRequest | orphans.swift |
| ItemCreationPrereq_Record | StatPrereq_Record | orphans.swift |
| ItemDropSettings_Record | TweakDBRecord | orphans.swift |
| ItemList_Record | TweakDBRecord | orphans.swift |
| ItemPartConnection_Record | TweakDBRecord | orphans.swift |
| ItemQueryElement_Record | LootTableElement_Record | orphans.swift |
| ItemRequiredSlot_Record | TweakDBRecord | orphans.swift |
| ItemStructure_Record | TweakDBRecord | orphans.swift |
| ItemsFactoryAppearanceSuffixBase_Record | TweakDBRecord | orphans.swift |
| ItemsFactoryAppearanceSuffixOrder_Record | TweakDBRecord | orphans.swift |
| JournalIcon_Record | UIIcon_Record | orphans.swift |
| KeepCurrentCoverCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| KnifeThrowDelivery_Record | GrenadeDeliveryMethod_Record | orphans.swift |
| LandingFxMaterial_Record | TweakDBRecord | orphans.swift |
| LandingFxPackage_Record | TweakDBRecord | orphans.swift |
| Layout_Record | TweakDBRecord | orphans.swift |
| AirDeathEvents | DeathEvents | orphans.swift |
| LinearAccuracy_Record | Accuracy_Record | orphans.swift |
| LoadingTipsGroup_Record | TweakDBRecord | orphans.swift |
| LocomotionMode_Record | TweakDBRecord | orphans.swift |
| LootInjectionSettings_Record | TweakDBRecord | orphans.swift |
| LootItem_Record | LootTableElement_Record | orphans.swift |
| MappinClampingSettings_Record | TweakDBRecord | orphans.swift |
| MappinDefinition_Record | Base_MappinDefinition_Record | orphans.swift |
| MappinPhase_Record | TweakDBRecord | orphans.swift |
| MappinPhaseDefinition_Record | TweakDBRecord | orphans.swift |
| UnblockHealingConsumableDrop | ScriptableSystemRequest | orphans.swift |
| UnblockAmmoDrop | ScriptableSystemRequest | orphans.swift |
| MappinUICustomOpacityParams_Record | TweakDBRecord | orphans.swift |
| BlockHealingConsumableDrop | ScriptableSystemRequest | orphans.swift |
| BlockAmmoDrop | ScriptableSystemRequest | orphans.swift |
| MappinUIParamGroup_Record | TweakDBRecord | orphans.swift |
| MappinUIPreventionSettings_Record | TweakDBRecord | orphans.swift |
| SceneTierInitialEvents | SceneTierAbstract | orphans.swift |
| MappinUISettings_Record | MappinUIRuntimeProfile_Record | orphans.swift |
| MappinUISpawnProfile_Record | TweakDBRecord | orphans.swift |
| Material_Record | TweakDBRecord | orphans.swift |
| MaterialFx_Record | TweakDBRecord | orphans.swift |
| MetaQuest_Record | TweakDBRecord | orphans.swift |
| MiniGame_AllSymbols_Record | TweakDBRecord | orphans.swift |
| UnlockNewPerk | NewPerkActionRequest | orphans.swift |
| LockNewPerk | NewPerkActionRequest | orphans.swift |
| MiniGame_AllSymbols_inline0_Record | MiniGame_SymbolsWithRarity_Record | orphans.swift |
| AddNewPerkPoints | NewPerkPoinsActionRequest | orphans.swift |
| MiniGame_AllSymbols_inline1_Record | MiniGame_SymbolsWithRarity_Record | orphans.swift |
| AddSpyTreePerkPoints | NewPerkPoinsActionRequest | orphans.swift |
| MiniGame_AllSymbols_inline2_Record | MiniGame_SymbolsWithRarity_Record | orphans.swift |
| AddSpyTreePowerUpPerkPoints | NewPerkPoinsActionRequest | orphans.swift |
| MiniGame_AllSymbols_inline3_Record | MiniGame_SymbolsWithRarity_Record | orphans.swift |
| MiniGame_AllSymbols_inline4_Record | MiniGame_SymbolsWithRarity_Record | orphans.swift |
| SwimmingForceFreezeEvents | LocomotionSwimmingEvents | orphans.swift |
| LeftHandCyberwareEquippedEvent | Event | orphans.swift |
| ModifyStaminaHandlerEffector_Record | Effector_Record | orphans.swift |
| MovementParam_Record | TweakDBRecord | orphans.swift |
| MovementParams_Record | TweakDBRecord | orphans.swift |
| ChargeStartedEvent | Event | orphans.swift |
| ChargeEndedEvent | Event | orphans.swift |
| MutablePoolValueModifier_Record | PoolValueModifier_Record | orphans.swift |
| NPCBehaviorState_Record | TweakDBRecord | orphans.swift |
| DrawBetweenEntitiesEvent | Event | orphans.swift |
| NPCHighLevelState_Record | TweakDBRecord | orphans.swift |
| NPCQuestAffiliation_Record | TweakDBRecord | orphans.swift |
| NPCRarity_Record | TweakDBRecord | orphans.swift |
| SecurityBreachPuppetNotificationEvent | SecuritySystemInput | orphans.swift |
| NPCStanceState_Record | TweakDBRecord | orphans.swift |
| NPCUpperBodyState_Record | TweakDBRecord | orphans.swift |
| LoopStartedEvent | Event | orphans.swift |
| LoopEndedEvent | Event | orphans.swift |
| NewPerkLevelUIData_Record | TweakDBRecord | orphans.swift |
| WeaponCycleTriggerModeEvent | Event | orphans.swift |
| WeaponConsumeMagazineAmmoEvent | Event | orphans.swift |
| NewSkillsProficiency_Record | Proficiency_Record | orphans.swift |
| NewsFeedTitle_Record | TweakDBRecord | orphans.swift |
| ForwardEventToProjectileEvent | Event | orphans.swift |
| NonLinearAccuracy_Record | Accuracy_Record | orphans.swift |
| NumberPlate_Record | LCDScreen_Record | orphans.swift |
| SetActiveWeaponEvent | Event | orphans.swift |
| RemoveActiveWeaponEvent | Event | orphans.swift |
| EnableSmartGunHandlerEvent | Event | orphans.swift |
| customGameNotificationDataSet | inkGameNotificationData | orphans.swift |
| QuickActionEvent | Event | orphans.swift |
| ObjectActionGameplayCategory_Record | ScannableData_Record | orphans.swift |
| OffMeshLinkTag_Record | TweakDBRecord | orphans.swift |
| OwnerAngleCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| OwnerDistanceCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| OwnerThreatCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| ParentAttachmentType_Record | TweakDBRecord | orphans.swift |
| ClearSubCharacterRequest | ScriptableSystemRequest | orphans.swift |
| SpawnSubCharacterRequest | SpawnUniqueSubCharacterRequest | orphans.swift |
| DespawnSubCharacterRequest | DespawnUniqueSubCharacterRequest | orphans.swift |
| PathLengthCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| PathSecurityCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| PerkLevelUIData_Record | TweakDBRecord | orphans.swift |
| PersistentLootTable_Record | LootTable_Record | orphans.swift |
| PhotoModeBackground_Record | PhotoModeItem_Record | orphans.swift |
| PhotoModeEffect_Record | PhotoModeItem_Record | orphans.swift |
| PhotoModeFace_Record | PhotoModeItem_Record | orphans.swift |
| PhotoModeFrame_Record | PhotoModeItem_Record | orphans.swift |
| PhotoModePose_Record | PhotoModeItem_Record | orphans.swift |
| PhotoModePoseCategory_Record | TweakDBRecord | orphans.swift |
| PhotoModeSticker_Record | PhotoModeItem_Record | orphans.swift |
| Pierce_Record | ProjectileCollision_Record | orphans.swift |
| PlayerPossesion_Record | TweakDBRecord | orphans.swift |
| Prereq_Record | TweakDBRecord | orphans.swift |
| PrereqCheck_Record | TweakDBRecord | orphans.swift |
| PreventionAttackTypeData_Record | TweakDBRecord | orphans.swift |
| PreventionFallbackUnitData_Record | TweakDBRecord | orphans.swift |
| SampleBumpEvent | Event | orphans.swift |
| SampleDeviceClass | GameObject | orphans.swift |
| LeftHandCyberwareCatchActionDecisions | LeftHandCyberwareActionAbstractDecisions | orphans.swift |
| PSD_Master | DeviceComponent | orphans.swift |
| PSD_MasterPS | DeviceComponentPS | orphans.swift |
| EquipmentBaseDecisions | EquipmentBaseTransition | orphans.swift |
| EquipmentBaseEvents | EquipmentBaseTransition | orphans.swift |
| ProjectileLaunchMode_Record | TweakDBRecord | orphans.swift |
| ProjectileOnCollisionAction_Record | TweakDBRecord | orphans.swift |
| LeftHandCyberwareUnequippedEvent | Event | orphans.swift |
| Prop_Record | SpawnableObject_Record | orphans.swift |
| PropagateStatusEffectInAreaEffector_Record | Effector_Record | orphans.swift |
| FUNC_TEST_inkGameController | inkGameController | orphans.swift |
| QuestRestrictionMode_Record | TweakDBRecord | orphans.swift |
| QuestSystemSetup_Record | TweakDBRecord | orphans.swift |
| RPGAction_Record | TweakDBRecord | orphans.swift |
| RPGDataPackage_Record | TweakDBRecord | orphans.swift |
| at_uiUserData | inkUserData | orphans.swift |
| RaceCheckpoint_Record | LCDScreen_Record | orphans.swift |
| RandomNewsFeedBatch_Record | TweakDBRecord | orphans.swift |
| RandomPassengerEntry_Record | TweakDBRecord | orphans.swift |
| RandomRatioCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| RandomStatModifier_Record | StatModifier_Record | orphans.swift |
| ReactionLimit_Record | TweakDBRecord | orphans.swift |
| UnequippedWaitingForExternalFactorsEvents | EquipmentBaseEvents | orphans.swift |
| SelfRemovalDecisions | StateFunctor | orphans.swift |
| ReactionPresetCivilian_Record | ReactionPreset_Record | orphans.swift |
| ReactionPresetCorpo_Record | ReactionPreset_Record | orphans.swift |
| ReactionPresetGanger_Record | ReactionPreset_Record | orphans.swift |
| ReactionPresetMechanical_Record | ReactionPreset_Record | orphans.swift |
| ReactionPresetNoReaction_Record | ReactionPreset_Record | orphans.swift |
| ReactionPresetPolice_Record | ReactionPreset_Record | orphans.swift |
| RearWheelsFrictionModifier_Record | DriveHelper_Record | orphans.swift |
| Regular_Record | ProjectileLaunch_Record | orphans.swift |
| RegularGDM_Record | GrenadeDeliveryMethod_Record | orphans.swift |
| RewardBase_inline0_Record | ConstantStatModifier_Record | orphans.swift |
| RewardSet_Record | TweakDBRecord | orphans.swift |
| Rigs_Record | TweakDBRecord | orphans.swift |
| RoachRaceBackground_Record | TweakDBRecord | orphans.swift |
| TakedownExecuteTakedownDecisions | LocomotionTakedownDecisions | orphans.swift |
| RoachRaceBackgroundObject_Record | ArcadeObject_Record | orphans.swift |
| RoachRaceLevel_Record | TweakDBRecord | orphans.swift |
| RoachRaceLevelList_Record | TweakDBRecord | orphans.swift |
| RoachRaceMovement_Record | TweakDBRecord | orphans.swift |
| SmartGunMissParams_Record | TweakDBRecord | orphans.swift |
| RoachRaceObstacle_Record | RoachRaceObject_Record | orphans.swift |
| RoachRaceObstacleTexturePartPair_Record | TweakDBRecord | orphans.swift |
| RoachRacePowerUpList_Record | TweakDBRecord | orphans.swift |
| RotationLimiter_Record | DriveHelper_Record | orphans.swift |
| SceneCameraDoF_Record | TweakDBRecord | orphans.swift |
| SceneInterruptionScenarios_Record | TweakDBRecord | orphans.swift |
| SceneResources_Record | TweakDBRecord | orphans.swift |
| SearchFilterMaskType_Record | TweakDBRecord | orphans.swift |
| SearchFilterMaskTypeCond_Record | SearchFilterMaskTypeCondition_Record | orphans.swift |
| SearchFilterMaskTypeValue_Record | SearchFilterMaskTypeCondition_Record | orphans.swift |
| SectorSelector_Record | TweakDBRecord | orphans.swift |
| SenseObjectType_Record | TweakDBRecord | orphans.swift |
| ShooterBackground_Record | TweakDBRecord | orphans.swift |
| ShooterBasilisk_Record | ShooterBossAI_Record | orphans.swift |
| ShooterBullet_Record | ShooterObject_Record | orphans.swift |
| ShooterBulletList_Record | TweakDBRecord | orphans.swift |
| ShooterFlyingDrone_Record | ShooterProjectileAI_Record | orphans.swift |
| ShooterGameplay_Record | ArcadeGameplay_Record | orphans.swift |
| ShooterLayerInfo_Record | TweakDBRecord | orphans.swift |
| ShooterLevel_Record | TweakDBRecord | orphans.swift |
| ShooterLevelList_Record | TweakDBRecord | orphans.swift |
| ShooterMeathead_Record | ShooterBossAI_Record | orphans.swift |
| ShooterMelee_Record | ShooterAI_Record | orphans.swift |
| ShooterNPCDrone_Record | ShooterAI_Record | orphans.swift |
| ShooterNinja_Record | ShooterBossAI_Record | orphans.swift |
| ShooterPickUpTransporter_Record | ShooterAI_Record | orphans.swift |
| ShooterPlayerData_Record | TweakDBRecord | orphans.swift |
| ShooterPowerUpList_Record | TweakDBRecord | orphans.swift |
| ShooterPowerup_Record | ShooterObject_Record | orphans.swift |
| ShooterProp_Record | ShooterAI_Record | orphans.swift |
| ShooterRange_Record | ShooterProjectileAI_Record | orphans.swift |
| ShooterRangeGrenade_Record | ShooterProjectileAI_Record | orphans.swift |
| ShooterRescueTransporter_Record | ShooterAI_Record | orphans.swift |
| ShooterSpiderDrone_Record | ShooterAI_Record | orphans.swift |
| ShooterTransporter_Record | ShooterAI_Record | orphans.swift |
| ShooterVFX_Record | ShooterObject_Record | orphans.swift |
| ShooterVFXList_Record | TweakDBRecord | orphans.swift |
| ShooterVIP_Record | ShooterAI_Record | orphans.swift |
| ShooterWeaponData_Record | TweakDBRecord | orphans.swift |
| ShooterWeaponList_Record | TweakDBRecord | orphans.swift |
| SlotItemPartElement_Record | TweakDBRecord | orphans.swift |
| SlotItemPartPreset_Record | TweakDBRecord | orphans.swift |
| SmartGunHandlerParams_Record | TweakDBRecord | orphans.swift |
| SmartGunTargetSortConfigurations_Record | TweakDBRecord | orphans.swift |
| SmartGunTargetSortData_Record | TweakDBRecord | orphans.swift |
| SpreadAreaEffector_Record | Effector_Record | orphans.swift |
| SquadBackyardBase_Record | TweakDBRecord | orphans.swift |
| SquadBase_Record | TweakDBRecord | orphans.swift |
| SquadFenceBase_Record | TweakDBRecord | orphans.swift |
| SquadInstance_Record | TweakDBRecord | orphans.swift |
| StatChangedPrereq_Record | IPrereq_Record | orphans.swift |
| StatDistributionData_Record | TweakDBRecord | orphans.swift |
| StatPoolDistributionData_Record | TweakDBRecord | orphans.swift |
| StatsArray_Record | TweakDBRecord | orphans.swift |
| StatsFolder_Record | TweakDBRecord | orphans.swift |
| StatsList_Record | TweakDBRecord | orphans.swift |
| StatusEffect_inline0_Record | StatModifierGroup_Record | orphans.swift |
| StatusEffect_inline1_Record | ConstantStatModifier_Record | orphans.swift |
| StickyGDM_Record | GrenadeDeliveryMethod_Record | orphans.swift |
| Stop_Record | ProjectileCollision_Record | orphans.swift |
| StopAndStick_Record | ProjectileCollision_Record | orphans.swift |
| StopAndStickPerpendicular_Record | ProjectileCollision_Record | orphans.swift |
| StreetCredTier_Record | TweakDBRecord | orphans.swift |
| StreetSign_Record | BaseSign_Record | orphans.swift |
| SubStatModifier_Record | StatModifier_Record | orphans.swift |
| Substat_Record | Stat_Record | orphans.swift |
| TPPCameraSetup_Record | TweakDBRecord | orphans.swift |
| TPPLookAtPresets_Record | TweakDBRecord | orphans.swift |
| TacticLimiterCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| TankArrangement_Record | TweakDBRecord | orphans.swift |
| TankBackgroundData_Record | TweakDBRecord | orphans.swift |
| TankDecorationSpawnerData_Record | TweakDBRecord | orphans.swift |
| GrenadeProximitySensorTargetAcquiredEvent | Event | orphans.swift |
| TankDriveModelData_Record | VehicleDriveModelData_Record | orphans.swift |
| CuttingGrenadeDespawnEffectsEvent | Event | orphans.swift |
| TankEnemy_Record | TankDestroyableObject_Record | orphans.swift |
| GrenadeRechargeDelayedEvent | Event | orphans.swift |
| TankEnemySpawnerData_Record | TweakDBRecord | orphans.swift |
| TankGameplay_Record | ArcadeGameplay_Record | orphans.swift |
| TankGameplayData_Record | TweakDBRecord | orphans.swift |
| TankLevelGameplay_Record | TweakDBRecord | orphans.swift |
| TankLevelObject_Record | TweakDBRecord | orphans.swift |
| TankLevelObjectID_Record | TweakDBRecord | orphans.swift |
| TankLevelSpawnableArrangement_Record | TweakDBRecord | orphans.swift |
| TankObstacleSpawnerData_Record | TweakDBRecord | orphans.swift |
| TankPickup_Record | ArcadeCollidableObject_Record | orphans.swift |
| TankPickupSpawnerData_Record | TweakDBRecord | orphans.swift |
| TankPlayerData_Record | TweakDBRecord | orphans.swift |
| TankPlayerWeaponLevel_Record | TweakDBRecord | orphans.swift |
| TankProjectile_Record | ArcadeCollidableObject_Record | orphans.swift |
| TankProjectileSpawnerData_Record | TweakDBRecord | orphans.swift |
| TankScoreMultiplierBreakpoint_Record | TweakDBRecord | orphans.swift |
| TankSpawnableArrangement_Record | TweakDBRecord | orphans.swift |
| TankWeapon_Record | ArcadeObject_Record | orphans.swift |
| TemporalPrereq_Record | IPrereq_Record | orphans.swift |
| TerminalScreenType_Record | DeviceScreenType_Record | orphans.swift |
| ThreatDistanceCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| ThreatTrackingPresetBase_Record | TweakDBRecord | orphans.swift |
| ThumbnailWidgetDefinition_Record | WidgetDefinition_Record | orphans.swift |
| Time_Record | TweakDBRecord | orphans.swift |
| Tracking_Record | ProjectileLaunch_Record | orphans.swift |
| TrapType_Record | TweakDBRecord | orphans.swift |
| UICharacterCustomizationResourcePaths_Record | TweakDBRecord | orphans.swift |
| UICondition_Record | TweakDBRecord | orphans.swift |
| UIElement_Record | TweakDBRecord | orphans.swift |
| UIIconCensorFlag_Record | TweakDBRecord | orphans.swift |
| UIIconCensorship_Record | TweakDBRecord | orphans.swift |
| UIIconPool_Record | TweakDBRecord | orphans.swift |
| UphillDriveHelper_Record | DriveHelper_Record | orphans.swift |
| UseConsumableEffector_Record | Effector_Record | orphans.swift |
| UtilityLossCoverSelectionParameters_Record | CoverSelectionParameters_Record | orphans.swift |
| VehicleAIBoostSettings_Record | TweakDBRecord | orphans.swift |
| VehicleAIPanicDrivingSettings_Record | TweakDBRecord | orphans.swift |
| VehicleAITractionEstimation_Record | TweakDBRecord | orphans.swift |
| VehicleAIVisionSettings_Record | TweakDBRecord | orphans.swift |
| VehicleAirControl_Record | TweakDBRecord | orphans.swift |
| VehicleAirControlAxis_Record | TweakDBRecord | orphans.swift |
| VehicleBehaviorData_Record | TweakDBRecord | orphans.swift |
| VehicleBurnOut_Record | TweakDBRecord | orphans.swift |
| VehicleCameraManager_Record | TweakDBRecord | orphans.swift |
| VehicleDeformablePart_Record | TweakDBRecord | orphans.swift |
| VehicleDeformableZone_Record | TweakDBRecord | orphans.swift |
| VehicleDestructibleLight_Record | TweakDBRecord | orphans.swift |
| VehicleDestructibleWheel_Record | TweakDBRecord | orphans.swift |
| VehicleDestructionPointDamper_Record | TweakDBRecord | orphans.swift |
| VehicleDetachablePart_Record | TweakDBRecord | orphans.swift |
| VehicleDiscountSettings_Record | TweakDBRecord | orphans.swift |
| VehicleDoorDetachRule_Record | TweakDBRecord | orphans.swift |
| VehicleFlatTireSimParams_Record | TweakDBRecord | orphans.swift |
| VehicleFlatTireSimulation_Record | TweakDBRecord | orphans.swift |
| VehicleFxCollision_Record | TweakDBRecord | orphans.swift |
| FunctionalTestsTimeChangeEvent | Event | orphans.swift |
| VehicleFxCollisionMaterial_Record | TweakDBRecord | orphans.swift |
| VehicleFxWheelsDecals_Record | TweakDBRecord | orphans.swift |
| VehicleFxWheelsDecalsMaterialSmear_Record | VehicleFxWheelsDecalsMaterial_Record | orphans.swift |
| VehicleFxWheelsParticles_Record | TweakDBRecord | orphans.swift |
| VehicleFxWheelsParticlesMaterial_Record | TweakDBRecord | orphans.swift |
| VehicleGear_Record | TweakDBRecord | orphans.swift |
| VehicleImpactTraffic_Record | TweakDBRecord | orphans.swift |
| VehiclePIDSettings_Record | TweakDBRecord | orphans.swift |
| VehicleProceduralFPPCameraParams_Record | TweakDBRecord | orphans.swift |
| VehicleSteeringSettings_Record | TweakDBRecord | orphans.swift |
| VehicleStoppingSettings_Record | TweakDBRecord | orphans.swift |
| VehicleSurfaceBinding_Record | TweakDBRecord | orphans.swift |
| VehicleSurfaceType_Record | TweakDBRecord | orphans.swift |
| VehicleTPPCameraParams_Record | TweakDBRecord | orphans.swift |
| VehicleTPPCameraPresetParams_Record | TweakDBRecord | orphans.swift |
| VehicleTrafficSuspension_Record | TweakDBRecord | orphans.swift |
| VehicleWater_Record | TweakDBRecord | orphans.swift |
| VehicleWeapon_Record | TweakDBRecord | orphans.swift |
| VehicleWheelDimensionsPreset_Record | TweakDBRecord | orphans.swift |
| VehicleWheelDimensionsSetup_Record | TweakDBRecord | orphans.swift |
| VehicleWheelDrivingPreset_Record | TweakDBRecord | orphans.swift |
| VehicleWheelDrivingSetup_2_Record | VehicleWheelDrivingSetup_Record | orphans.swift |
| VehicleWheelDrivingSetup_4_Record | VehicleWheelDrivingSetup_Record | orphans.swift |
| VehicleWheelRole_Record | TweakDBRecord | orphans.swift |
| VehicleWheelsFrictionMap_Record | TweakDBRecord | orphans.swift |
| VehicleWheelsFrictionPreset_Record | TweakDBRecord | orphans.swift |
| LadderEnterContextEvents | InputContextTransitionEvents | orphans.swift |
| JamWeaponE3HackEvent | Event | orphans.swift |
| entRagdollPutToSleepEvent | Event | orphans.swift |
| FadeOutOutlinesUpdate | TickableEvent | orphans.swift |
| VendorCraftable_Record | VendorWare_Record | orphans.swift |
| VendorExperience_Record | VendorWare_Record | orphans.swift |
| QuickHackEvent | Event | orphans.swift |
| VisionGroup_Record | TweakDBRecord | orphans.swift |
| VisionModuleBase_Record | TweakDBRecord | orphans.swift |
| VehiclePassengerRemoteControlDriverContextEvents | VehiclePassengerContextEvents | orphans.swift |
| WeaponManufacturer_Record | TweakDBRecord | orphans.swift |
| WeaponSafeModeBound_Record | TweakDBRecord | orphans.swift |
| WeaponSafeModeBounds_Record | TweakDBRecord | orphans.swift |
| VehicleDriverMountedWeaponsContextEvents | VehicleDriverContextEvents | orphans.swift |
| Weather_Record | TweakDBRecord | orphans.swift |
| WeatherPreset_Record | SpawnableObject_Record | orphans.swift |
| Website_Record | TweakDBRecord | orphans.swift |
| WeightedCharacter_Record | TweakDBRecord | orphans.swift |
| WorkspotActionType_Record | TweakDBRecord | orphans.swift |
| WorkspotCategory_Record | TweakDBRecord | orphans.swift |
| WorkspotReactionType_Record | TweakDBRecord | orphans.swift |
| WorkspotStatusEffect_Record | StatusEffect_Record | orphans.swift |
| WorldMapFreeCameraSettings_Record | TweakDBRecord | orphans.swift |
| WorldMapZoomLevel_Record | TweakDBRecord | orphans.swift |
| XPPoints_inline0_Record | ConstantStatModifier_Record | orphans.swift |
| device_gameplay_role_Record | ScannableData_Record | orphans.swift |
| device_role_action_desctiption_Record | ScannableData_Record | orphans.swift |
| device_scanning_data_Record | ScannableData_Record | orphans.swift |
| npc_scanning_data_Record | ScannableData_Record | orphans.swift |
| VehicleDriverCombatMountedWeaponsContextEvents | VehicleDriverCombatContextEvents | orphans.swift |
| VehicleMountedWeaponsAutodriveContextEvents | VehicleAutodriveContextEvents | orphans.swift |
| DeathExitingEvents | ImmediateExitWithForceEvents | orphans.swift |
| WaitingForSceneEvents | VehicleTransition | orphans.swift |
| MeleeEquipAttackDecisions | MeleeAttackGenericDecisions | orphans.swift |
| BodySlamJumpDecisions | JumpDecisions | orphans.swift |
| RegularLandDecisions | AbstractLandDecisions | orphans.swift |
| HardLandDecisions | FailedLandingAbstractDecisions | orphans.swift |
| VeryHardLandDecisions | FailedLandingAbstractDecisions | orphans.swift |
| DeathLandDecisions | FailedLandingAbstractDecisions | orphans.swift |
| LevelUpdateEvent | Event | orphans.swift |
| ActivePerkChangedEvent | Event | orphans.swift |
| ThrowEquipmentRequest | PlayerScriptableSystemRequest | orphans.swift |
| InstallCyberwareRequest | EquipRequest | orphans.swift |
| UninstallCyberwareRequest | UnequipRequest | orphans.swift |
| EquipmentUIBBRequest | PlayerScriptableSystemRequest | orphans.swift |
| ProcessVisualTags | PlayerScriptableSystemRequest | orphans.swift |
| PrepareForForcedVehicleCombat | Event | orphans.swift |
| ResetItemAppearanceTaskData | ScriptTaskData | orphans.swift |
| ClearItemAppearanceTaskData | ScriptTaskData | orphans.swift |

### Structs (719)

| Name | Bases | Source File |
|------|-------|-------------|
| WorldPosition |  | orphans.swift |
| WorldTransform |  | orphans.swift |
| GameInstance |  | orphans.swift |
| EntityID |  | orphans.swift |
| TDBID |  | orphans.swift |
| PSOwnerData |  | orphans.swift |
| PersistentID |  | orphans.swift |
| MinigameProgramData |  | orphans.swift |
| BlackboardID |  | orphans.swift |
| EntityRequestComponentsInterface |  | orphans.swift |
| FocusClueDefinition |  | orphans.swift |
| SDOSink |  | orphans.swift |
| FastTravelSystemLock |  | orphans.swift |
| IMappinData |  | orphans.swift |
| MappinData |  | orphans.swift |
| SHitFlag |  | orphans.swift |
| InteractionLayerData |  | orphans.swift |
| EffectData |  | orphans.swift |
| VisionAppearance |  | orphans.swift |
| ItemID |  | orphans.swift |
| SHitStatusEffect |  | orphans.swift |
| DamageHistoryEntry |  | orphans.swift |
| inkMargin |  | orphans.swift |
| Vector2 |  | orphans.swift |
| HDRColor |  | orphans.swift |
| HSBColor |  | orphans.swift |
| SEquipArea |  | orphans.swift |
| SLoadout |  | orphans.swift |
| SEquipSlot |  | orphans.swift |
| InnerItemData |  | orphans.swift |
| SPartSlots |  | orphans.swift |
| ItemModParams |  | orphans.swift |
| ItemRecipe |  | orphans.swift |
| SimpleScreenMessage |  | orphans.swift |
| IngredientData |  | orphans.swift |
| InventoryItemSortData |  | orphans.swift |
| StatViewData |  | orphans.swift |
| UIScriptableSystemAttributeLevel |  | orphans.swift |
| ItemViewData |  | orphans.swift |
| InventoryTooltipData_StatData |  | orphans.swift |
| SSlotVisualInfo |  | orphans.swift |
| SItemStackRequirementData |  | orphans.swift |
| SProficiency |  | orphans.swift |
| SAttribute |  | orphans.swift |
| SAttributeData |  | orphans.swift |
| SNewPerk |  | orphans.swift |
| SPerkArea |  | orphans.swift |
| STrait |  | orphans.swift |
| SDevelopmentPoints |  | orphans.swift |
| SPerk |  | orphans.swift |
| LevelUpData |  | orphans.swift |
| TelemetryLevelGained |  | orphans.swift |
| SExperiencePoints |  | orphans.swift |
| GetActionsContext |  | orphans.swift |
| SDeviceMappinData |  | orphans.swift |
| gameVisionModeSystemRevealIdentifier |  | orphans.swift |
| EntityResolveComponentsInterface |  | orphans.swift |
| SAreaEffectData |  | orphans.swift |
| SAreaEffectTargetData |  | orphans.swift |
| FxResourceMapData |  | orphans.swift |
| gameLightSettings |  | orphans.swift |
| ScriptLightSettings |  | orphans.swift |
| EditableGameLightSettings |  | orphans.swift |
| InteractionChoiceMetaData |  | orphans.swift |
| InteractionChoice |  | orphans.swift |
| SWidgetPackage |  | orphans.swift |
| SActionWidgetPackage |  | orphans.swift |
| SToggleDeviceOperationData |  | orphans.swift |
| EngineTime |  | orphans.swift |
| MountingInfo |  | orphans.swift |
| FxResource |  | orphans.swift |
| SNetworkLinkData |  | orphans.swift |
| HUDClueData |  | orphans.swift |
| Quaternion |  | orphans.swift |
| EulerAngles |  | orphans.swift |
| DisassembleOptions |  | orphans.swift |
| DestructionData |  | orphans.swift |
| ChoiceTypeWrapper |  | orphans.swift |
| IllegalActionTypes |  | orphans.swift |
| SecurityAreaData |  | orphans.swift |
| RWLock |  | orphans.swift |
| AreaTypeTransition |  | orphans.swift |
| GameTime |  | orphans.swift |
| HUDJob |  | orphans.swift |
| StatPoolModifier |  | orphans.swift |
| UIInteractionSkillCheck |  | orphans.swift |
| ConditionGroupData |  | orphans.swift |
| ConditionData |  | orphans.swift |
| ExplosiveDeviceResourceDefinition |  | orphans.swift |
| PlayerQuickhackData |  | orphans.swift |
| InteractionChoiceCaption |  | orphans.swift |
| SGenericDeviceActionsData |  | orphans.swift |
| GenericDeviceActionsData |  | orphans.swift |
| SCustomDeviceActionsData |  | orphans.swift |
| GlobalNodeRef |  | orphans.swift |
| MountingSlotId |  | orphans.swift |
| SThumbnailWidgetPackage |  | orphans.swift |
| ResRef |  | orphans.swift |
| SItemStack |  | orphans.swift |
| StatsObjectID |  | orphans.swift |
| gameStatDetailedData |  | orphans.swift |
| DoorSetup |  | orphans.swift |
| TerminalSetup |  | orphans.swift |
| DeviceCounter |  | orphans.swift |
| SDeviceWidgetPackage |  | orphans.swift |
| SecuritySystemClearanceEntry |  | orphans.swift |
| LiftSetup |  | orphans.swift |
| StimIdentificationData |  | orphans.swift |
| TargetingBehaviour |  | orphans.swift |
| DetectionParameters |  | orphans.swift |
| ScriptExecutionContext |  | orphans.swift |
| AIScriptUtils |  | orphans.swift |
| EnumNameToIndexCache |  | orphans.swift |
| SquadTicketReceipt |  | orphans.swift |
| TrackedLocation |  | orphans.swift |
| LocationInformation |  | orphans.swift |
| TimeBetweenHitsParameters |  | orphans.swift |
| FragmentBuilder |  | orphans.swift |
| Matrix |  | orphans.swift |
| DebugDrawer |  | orphans.swift |
| CameraQuestProperties |  | orphans.swift |
| CameraSetup |  | orphans.swift |
| LedColors_SensorDevice |  | orphans.swift |
| AimRequest |  | orphans.swift |
| AIActiveCommandList |  | orphans.swift |
| BaseDeviceData |  | orphans.swift |
| DebuggerProperties |  | orphans.swift |
| gameprojectileWeaponParams |  | orphans.swift |
| LookAtRequest |  | orphans.swift |
| ReprimandData |  | orphans.swift |
| AreaEntry |  | orphans.swift |
| LinkedStatusEffect |  | orphans.swift |
| PlayerTotalDamageAgainstHealth |  | orphans.swift |
| PlayerControlDeviceData |  | orphans.swift |
| LootChoiceActionWrapper |  | orphans.swift |
| LookAtLimits |  | orphans.swift |
| NewMappinID |  | orphans.swift |
| AttackInitContext |  | orphans.swift |
| gameprojectileHitInstance |  | orphans.swift |
| RegisterNewCooldownRequest |  | orphans.swift |
| TraceResult |  | orphans.swift |
| QueryFilter |  | orphans.swift |
| stimInvestigateData |  | orphans.swift |
| GrenadePotentialHomingTarget |  | orphans.swift |
| InputHintData |  | orphans.swift |
| SSubCharacter |  | orphans.swift |
| SSlotInfo |  | orphans.swift |
| SVisualTagProcessing |  | orphans.swift |
| SPaperdollEquipData |  | orphans.swift |
| SSlotActiveItems |  | orphans.swift |
| SLastUsedWeapon |  | orphans.swift |
| gameSaveLock |  | orphans.swift |
| StateMachineInstanceData |  | orphans.swift |
| NPCItemToEquip |  | orphans.swift |
| TargetSearchQuery |  | orphans.swift |
| TS_TargetPartInfo |  | orphans.swift |
| CameraRotationData |  | orphans.swift |
| HitHistoryItem |  | orphans.swift |
| CombatSpaceHelper |  | orphans.swift |
| AIPositionSpec |  | orphans.swift |
| AINavigationSystemQuery |  | orphans.swift |
| NavigationFindPointResult |  | orphans.swift |
| AINavigationSystemResult |  | orphans.swift |
| AIActionNPCStates |  | orphans.swift |
| AIActionPlayerStates |  | orphans.swift |
| AIActionTargetStates |  | orphans.swift |
| HitShapeData |  | orphans.swift |
| RagdollActivationRequestData |  | orphans.swift |
| NPCHitTypeTimeoutStruct |  | orphans.swift |
| HitRepresentationQueryResult |  | orphans.swift |
| ScriptHitData |  | orphans.swift |
| HitShapeResult |  | orphans.swift |
| ProjectileHitAoEData |  | orphans.swift |
| gameGrenadeThrowQueryParams |  | orphans.swift |
| gameAvailableExposureMethodResult |  | orphans.swift |
| PreventionSystemDebugData |  | orphans.swift |
| DSSSpawnRequestResult |  | orphans.swift |
| GlobalNodeID |  | orphans.swift |
| VisionBlockerTypeFlags |  | orphans.swift |
| EntityGameInterface |  | orphans.swift |
| DroppedThreatData |  | orphans.swift |
| inkLeafRef |  | orphans.swift |
| inkImageRef |  | orphans.swift |
| ThreatPersistanceMemory |  | orphans.swift |
| ReactionOutput |  | orphans.swift |
| ListenerAction |  | orphans.swift |
| ListenerActionConsumer |  | orphans.swift |
| NPCstubData |  | orphans.swift |
| StimEventData |  | orphans.swift |
| StimParams |  | orphans.swift |
| LookAtPartRequest |  | orphans.swift |
| LookAtData |  | orphans.swift |
| TicketData |  | orphans.swift |
| UnregisterResult |  | orphans.swift |
| HUDProgressBarData |  | orphans.swift |
| HackTargetSettings |  | orphans.swift |
| SActionTypeForward |  | orphans.swift |
| ActionsSequence |  | orphans.swift |
| JournalRequestStateFilter |  | orphans.swift |
| JournalRequestContext |  | orphans.swift |
| ScreenDefinitionPackage |  | orphans.swift |
| SUIScreenDefinition |  | orphans.swift |
| EffectFiringData |  | orphans.swift |
| SquadOrder |  | orphans.swift |
| NearestRoadFromPlayerInfo |  | orphans.swift |
| HandleWithValue |  | orphans.swift |
| SpawnRequestResult |  | orphans.swift |
| AVSpawnPointsRequestResult |  | orphans.swift |
| InteractionAttemptedChoice |  | orphans.swift |
| LedColors |  | orphans.swift |
| GlitchData |  | orphans.swift |
| SItemTransaction |  | orphans.swift |
| VendingMachineSetup |  | orphans.swift |
| VendingMachineSFX |  | orphans.swift |
| TransactionRequestData |  | orphans.swift |
| JunkItemRecord |  | orphans.swift |
| DropPointSystemLock |  | orphans.swift |
| VendorData |  | orphans.swift |
| DropInstruction |  | orphans.swift |
| Bounty |  | orphans.swift |
| TelemetryDamageDealt |  | orphans.swift |
| TelemetryDamage |  | orphans.swift |
| CachedBoolValue |  | orphans.swift |
| AIGateSignal |  | orphans.swift |
| RagdollImpactPointData |  | orphans.swift |
| RagdollDamagePollData |  | orphans.swift |
| DamageInfo |  | orphans.swift |
| Vulnerability |  | orphans.swift |
| ScannerStatDetails |  | orphans.swift |
| scannerDataStructure |  | orphans.swift |
| GameObjectScanStats |  | orphans.swift |
| LootVisualiserControlWrapper |  | orphans.swift |
| LinkedFocusClueData |  | orphans.swift |
| ScanningTooltipElementDef |  | orphans.swift |
| ClueRecordData |  | orphans.swift |
| inkAnimOptions |  | orphans.swift |
| TutorialOverlayData |  | orphans.swift |
| BuffInfo |  | orphans.swift |
| InventoryItemDisplayData |  | orphans.swift |
| TelemetryQuickHack |  | orphans.swift |
| ConnectedClassTypes |  | orphans.swift |
| EventsFilters |  | orphans.swift |
| RevealPlayerSettings |  | orphans.swift |
| OnDisableAreaData |  | orphans.swift |
| SecuritySystemOutputData |  | orphans.swift |
| SecurityGateDetectionProperties |  | orphans.swift |
| TrespasserEntry |  | orphans.swift |
| SecurityGateResponseProperties |  | orphans.swift |
| AgentDistanceToTarget |  | orphans.swift |
| DelayID |  | orphans.swift |
| InterestingFacts |  | orphans.swift |
| InvestigationData |  | orphans.swift |
| DistractionSetup |  | orphans.swift |
| DisposalDeviceSetup |  | orphans.swift |
| BaseResaveData |  | orphans.swift |
| SWidgetAnimationData |  | orphans.swift |
| SSoundData |  | orphans.swift |
| SBreadcrumbElementData |  | orphans.swift |
| ComputerSetup |  | orphans.swift |
| ComputerQuickHackData |  | orphans.swift |
| SNewsFeedElementData |  | orphans.swift |
| SBannerWidgetPackage |  | orphans.swift |
| SsimpleBanerData |  | orphans.swift |
| GenericDataContent |  | orphans.swift |
| SDocumentAdress |  | orphans.swift |
| DataElement |  | orphans.swift |
| SDocumentWidgetPackage |  | orphans.swift |
| SDocumentThumbnailWidgetPackage |  | orphans.swift |
| SComputerMenuButtonWidgetPackage |  | orphans.swift |
| ComputerUIData |  | orphans.swift |
| DeviceConnectionScannerData |  | orphans.swift |
| SBaseDeviceOperationData |  | orphans.swift |
| SVFXOperationData |  | orphans.swift |
| SVfxInstanceData |  | orphans.swift |
| SSFXOperationData |  | orphans.swift |
| SFactOperationData |  | orphans.swift |
| SComponentOperationData |  | orphans.swift |
| STransformAnimationData |  | orphans.swift |
| STransformAnimationPlayEventData |  | orphans.swift |
| STransformAnimationSkipEventData |  | orphans.swift |
| SWorkspotData |  | orphans.swift |
| SStimOperationData |  | orphans.swift |
| SStatusEffectOperationData |  | orphans.swift |
| StatusEffectTDBPicker |  | orphans.swift |
| SDamageOperationData |  | orphans.swift |
| SInventoryOperationData |  | orphans.swift |
| STeleportOperationData |  | orphans.swift |
| SToggleOperationData |  | orphans.swift |
| SBinkperationData |  | orphans.swift |
| Condition |  | orphans.swift |
| VehicleActionsContext |  | orphans.swift |
| TemporaryDoorState |  | orphans.swift |
| gameinteractionsActiveLayerData |  | orphans.swift |
| LayerHighlightRequestData |  | orphans.swift |
| MinimapLayerHighlightRequest |  | orphans.swift |
| VehEntityPlayerStateData |  | orphans.swift |
| VehicleCustomTemplatePersistentData |  | orphans.swift |
| vehicleVisualCustomizationPersistentData |  | orphans.swift |
| gameprojectileLaunchParams |  | orphans.swift |
| SDamageDealt |  | orphans.swift |
| previewTargetStruct |  | orphans.swift |
| KillInfo |  | orphans.swift |
| DismembermentInstigatedInfo |  | orphans.swift |
| UILocRecord |  | orphans.swift |
| InventoryItemAbility |  | orphans.swift |
| CharacterCustomizationAttribute |  | orphans.swift |
| CanSellNewPerkResult |  | orphans.swift |
| AttributeBoughtData |  | orphans.swift |
| AttachmentSlotCacheData |  | orphans.swift |
| CyberwareUpgradeCostData |  | orphans.swift |
| ItemRemovedData |  | orphans.swift |
| ItemQuantityChangedData |  | orphans.swift |
| InventoryPartsData |  | orphans.swift |
| SlotWeaponData |  | orphans.swift |
| InventoryTooltipData_QuickhackData |  | orphans.swift |
| AbilityData |  | orphans.swift |
| SEquipmentSet |  | orphans.swift |
| SItemInfo |  | orphans.swift |
| PulseAnimationParams |  | orphans.swift |
| VendingTerminalSetup |  | orphans.swift |
| VendorShoppingCartItem |  | orphans.swift |
| inkUniformGridRef |  | orphans.swift |
| TooltipWidgetReference |  | orphans.swift |
| inkWidgetLibraryResource |  | orphans.swift |
| inkWidgetLibraryReference |  | orphans.swift |
| TooltipWidgetStyledReference |  | orphans.swift |
| WidgetUtils |  | orphans.swift |
| RipperdocCategory |  | orphans.swift |
| inkVideoRef |  | orphans.swift |
| TutorialBracketData |  | orphans.swift |
| MenuData |  | orphans.swift |
| OutlineData |  | orphans.swift |
| LootData |  | orphans.swift |
| CombatTarget |  | orphans.swift |
| PlayerVehicle |  | orphans.swift |
| QuickSlotUIStructure |  | orphans.swift |
| QuickWheelStartUIStructure |  | orphans.swift |
| PhoneCallInformation |  | orphans.swift |
| DEBUG_VisualRecord |  | orphans.swift |
| PlayerVisionModeControllerActiveFlags |  | orphans.swift |
| PlayerVisionModeControllerBBIds |  | orphans.swift |
| PlayerVisionModeControllerBBValuesIds |  | orphans.swift |
| PlayerVisionModeControllerBBListeners |  | orphans.swift |
| PlayerVisionModeControllerInputActionsNames |  | orphans.swift |
| PlayerVisionModeControllerRefreshPolicy |  | orphans.swift |
| PlayerVisionModeControllerBlackboardListenersFunctions |  | orphans.swift |
| PlayerVisionModeControllerInputActiveFlags |  | orphans.swift |
| PlayerVisionModeControllerOtherVars |  | orphans.swift |
| PlayerCombatControllerBBIds |  | orphans.swift |
| PlayerCombatControllerBBValuesIds |  | orphans.swift |
| PlayerCombatControllerBBListeners |  | orphans.swift |
| PlayerCombatControllerRefreshPolicy |  | orphans.swift |
| PlayerCombatControllerBlackboardListenersFunctions |  | orphans.swift |
| PlayerCombatControllerActiveFlags |  | orphans.swift |
| PlayerCombatControllerOtherVars |  | orphans.swift |
| PlayerCombatControllerDelayCallbacksIds |  | orphans.swift |
| InteractionChoiceHubData |  | orphans.swift |
| DialogChoiceHubs |  | orphans.swift |
| InterestingFactsListenersFunctions |  | orphans.swift |
| InterestingFactsListenersIds |  | orphans.swift |
| FactCallbackData |  | orphans.swift |
| StateMachineIdentifier |  | orphans.swift |
| bbUIInteractionData |  | orphans.swift |
| SBraindanceInputMask |  | orphans.swift |
| StateResultCName |  | orphans.swift |
| StateResultBool |  | orphans.swift |
| Tier3CameraSettings |  | orphans.swift |
| StateResultInt |  | orphans.swift |
| SPlayerCooldown |  | orphans.swift |
| gameStatTotalValue |  | orphans.swift |
| SpiderbotScavengeOptions |  | orphans.swift |
| SecurityAlarmSetup |  | orphans.swift |
| ForcedStateData |  | orphans.swift |
| FuseData |  | orphans.swift |
| SSimpleGameTime |  | orphans.swift |
| SDeviceTimetableEntry |  | orphans.swift |
| RecipientData |  | orphans.swift |
| CooldownPackageDelayIDs |  | orphans.swift |
| CooldownStorageID |  | orphans.swift |
| CachedItemLoadout |  | orphans.swift |
| TelemetryInventoryItem |  | orphans.swift |
| TelemetrySourceEntity |  | orphans.swift |
| TelemetryEnemy |  | orphans.swift |
| TelemetryEnemyDown |  | orphans.swift |
| DismemberedLimbCount |  | orphans.swift |
| RadialAnimData |  | orphans.swift |
| QuestInfo |  | orphans.swift |
| SInternetData |  | orphans.swift |
| SBreadCrumbUpdateData |  | orphans.swift |
| JournalFactNameValue |  | orphans.swift |
| ActivatedDeviceSetup |  | orphans.swift |
| ActivatedDeviceAnimSetup |  | orphans.swift |
| ReflectorSFX |  | orphans.swift |
| TVSetup |  | orphans.swift |
| STvChannel |  | orphans.swift |
| cameraShotEffect_TranslationAffectedAxis |  | orphans.swift |
| vehicleCinematicCameraShotUpdateContext |  | orphans.swift |
| SFactToChange |  | orphans.swift |
| inkBasePanelRef |  | orphans.swift |
| gameuiPhoneElementVisibility |  | orphans.swift |
| scnDialogLineData |  | orphans.swift |
| subtitleLineMapEntry |  | orphans.swift |
| scnDialogDisplayString |  | orphans.swift |
| gamePendingSubtitles |  | orphans.swift |
| NPCNextToTheCrosshair |  | orphans.swift |
| AnimationElement |  | orphans.swift |
| RemoteControlDrivingUIData |  | orphans.swift |
| ProgramData |  | orphans.swift |
| ElementData |  | orphans.swift |
| ProgramProgressData |  | orphans.swift |
| BunkerSystemsFactsSet |  | orphans.swift |
| GameScreenshotInfo |  | orphans.swift |
| FixerTooltipMapData |  | orphans.swift |
| SimulationFilter |  | orphans.swift |
| SecureFootingResult |  | orphans.swift |
| StateResultFloat |  | orphans.swift |
| vehicleUnmountPosition |  | orphans.swift |
| ControllerHit |  | orphans.swift |
| ActionAnimationSlideParams |  | orphans.swift |
| TestStackScriptData |  | orphans.swift |
| gameJoinTrafficNPCContext |  | orphans.swift |
| AIDelegateAttrRef |  | orphans.swift |
| AIDelegateTaskRef |  | orphans.swift |
| BinkVideoSummary |  | orphans.swift |
| AIActionLookatParams |  | orphans.swift |
| AIActionSlideParams |  | orphans.swift |
| EntityAttachementData |  | orphans.swift |
| MountingRelationship |  | orphans.swift |
| SMovementPattern |  | orphans.swift |
| EffectExecutionScriptContext |  | orphans.swift |
| DiodeLightPreset |  | orphans.swift |
| WeakspotOnDestroyProperties |  | orphans.swift |
| WeakspotRecordData |  | orphans.swift |
| worldTrafficLaneRef |  | orphans.swift |
| AIMovementTypeSpec |  | orphans.swift |
| CameraData |  | orphans.swift |
| PrereqCheckData |  | orphans.swift |
| PrereqData |  | orphans.swift |
| PrereqParams |  | orphans.swift |
| ScanningTooltipElementData |  | orphans.swift |
| TacticRatio |  | orphans.swift |
| RequestItemParam |  | orphans.swift |
| AmmoData |  | orphans.swift |
| RectF |  | orphans.swift |
| WrappedEntIDArray |  | orphans.swift |
| gameStatModifierDetailedData |  | orphans.swift |
| IKTargetRef |  | orphans.swift |
| IKTargetRequest |  | orphans.swift |
| gameRicochetData |  | orphans.swift |
| EffectDurationModifierScriptContext |  | orphans.swift |
| EffectScriptContext |  | orphans.swift |
| LookAtRef |  | orphans.swift |
| BlackboardID_Bool |  | orphans.swift |
| BlackboardID_Int |  | orphans.swift |
| BlackboardID_Uint |  | orphans.swift |
| BlackboardID_Float |  | orphans.swift |
| BlackboardID_Name |  | orphans.swift |
| BlackboardID_Vector2 |  | orphans.swift |
| BlackboardID_Vector4 |  | orphans.swift |
| BlackboardID_Quat |  | orphans.swift |
| BlackboardID_Entity |  | orphans.swift |
| BlackboardID_String |  | orphans.swift |
| BlackboardID_EulerAngles |  | orphans.swift |
| BlackboardID_EntityID |  | orphans.swift |
| BlackboardID_Variant |  | orphans.swift |
| SpreadMapItem |  | orphans.swift |
| MovementParameters |  | orphans.swift |
| EffectRef |  | orphans.swift |
| EffectProviderScriptContext |  | orphans.swift |
| EffectSingleFilterScriptContext |  | orphans.swift |
| EffectGroupFilterScriptContext |  | orphans.swift |
| EffectPreloadScriptContext |  | orphans.swift |
| EffectInputParameter_Bool |  | orphans.swift |
| EffectInputParameter_Int |  | orphans.swift |
| EffectInputParameter_Float |  | orphans.swift |
| EffectInputParameter_CName |  | orphans.swift |
| EffectInputParameter_String |  | orphans.swift |
| EffectInputParameter_Vector |  | orphans.swift |
| EffectInputParameter_Quat |  | orphans.swift |
| EffectInputParameter_Variant |  | orphans.swift |
| EffectOutputParameter_Bool |  | orphans.swift |
| EffectOutputParameter_Int |  | orphans.swift |
| EffectOutputParameter_Float |  | orphans.swift |
| EffectOutputParameter_CName |  | orphans.swift |
| EffectOutputParameter_String |  | orphans.swift |
| EffectOutputParameter_Vector |  | orphans.swift |
| EffectOutputParameter_Quat |  | orphans.swift |
| EffectOutputParameter_Variant |  | orphans.swift |
| EffectInfo |  | orphans.swift |
| ChangeInfoWithTimeStamp |  | orphans.swift |
| MotionConstrainedTierDataParams |  | orphans.swift |
| Frustum |  | orphans.swift |
| TargetSearchFilter |  | orphans.swift |
| Sphere |  | orphans.swift |
| RegisterNewAbilityCooldownRequest |  | orphans.swift |
| RegisterCooldownFromRecordRequest |  | orphans.swift |
| SCooldown |  | orphans.swift |
| TrialHelper |  | orphans.swift |
| GOGRewardPack |  | orphans.swift |
| InputTriggerState |  | orphans.swift |
| Range |  | orphans.swift |
| MappinEntry |  | orphans.swift |
| WeakspotPhysicalDestructionProperties |  | orphans.swift |
| WeakspotPhysicalDestructionComponent |  | orphans.swift |
| PreventionSystemConfig |  | orphans.swift |
| EntityReference |  | orphans.swift |
| StimuliMergeInfo |  | orphans.swift |
| RestrictMovementArea |  | orphans.swift |
| animAnimFeatureEntry |  | orphans.swift |
| gameSuggestedDefenseValues |  | orphans.swift |
| StateSnapshot |  | orphans.swift |
| SnapshotResult |  | orphans.swift |
| StateSnapshotsContainer |  | orphans.swift |
| gameuiPatchIntroPackage |  | orphans.swift |
| TargetFilterTicket |  | orphans.swift |
| TargetHitInfo |  | orphans.swift |
| StateResultDouble |  | orphans.swift |
| StateResultVector |  | orphans.swift |
| StateResultString |  | orphans.swift |
| gameuiGenericNotificationData |  | orphans.swift |
| inkStepperData |  | orphans.swift |
| GarageVehicleID |  | orphans.swift |
| inkInputKeyData |  | orphans.swift |
| SecureFootingParameters |  | orphans.swift |
| gameuiBraindanceClueDescriptor |  | orphans.swift |
| VideoWidgetSummary |  | orphans.swift |
| inkWidgetLayout |  | orphans.swift |
| inkEntityPreviewCameraSettings |  | orphans.swift |
| JournalMetaQuestScriptedData |  | orphans.swift |
| inkScreenProjectionData |  | orphans.swift |
| WorkEntryId |  | orphans.swift |
| PopupSettings |  | orphans.swift |
| PopupData |  | orphans.swift |
| ScrollingText |  | orphans.swift |
| HandIKDescriptionResult |  | orphans.swift |
| GateSignalInstance |  | orphans.swift |
| ImpactPointData |  | orphans.swift |
| FactTextStruct |  | orphans.swift |
| TutorialStep |  | orphans.swift |
| PinInfo |  | orphans.swift |
| ActionDisplayData |  | orphans.swift |
| ContextDisplayData |  | orphans.swift |
| WeaponRosterInfo |  | orphans.swift |
| UIBuffInfo |  | orphans.swift |
| PlayerBioMonitor |  | orphans.swift |
| ChatBoxText |  | orphans.swift |
| NarrationEvent |  | orphans.swift |
| NarrativePlateData |  | orphans.swift |
| inkCanvasRef |  | orphans.swift |
| inkHorizontalPanelRef |  | orphans.swift |
| inkVerticalPanelRef |  | orphans.swift |
| inkFlexRef |  | orphans.swift |
| inkGridRef |  | orphans.swift |
| inkVirtualCompoundRef |  | orphans.swift |
| inkScrollAreaRef |  | orphans.swift |
| inkCacheRef |  | orphans.swift |
| inkTextInputRef |  | orphans.swift |
| inkBorderRef |  | orphans.swift |
| inkRectangleRef |  | orphans.swift |
| inkCircleRef |  | orphans.swift |
| inkShapeRef |  | orphans.swift |
| inkMaskRef |  | orphans.swift |
| inkRichTextBoxRef |  | orphans.swift |
| BinkResource |  | orphans.swift |
| VideoCarouselData |  | orphans.swift |
| CyberwareAttributes_ContainersStruct |  | orphans.swift |
| CyberwareAttributes_ResistancesStruct |  | orphans.swift |
| MetaQuestStatus |  | orphans.swift |
| ItemAddedData |  | orphans.swift |
| CustomQuestNotificationData |  | orphans.swift |
| metroMapPlayerPositionReferences |  | orphans.swift |
| AccumulatedDamageDigitsNode |  | orphans.swift |
| DamageEntry |  | orphans.swift |
| NewPerksGaugePointDetails |  | orphans.swift |
| NewPerksWireConnection |  | orphans.swift |
| WorldMapTooltipData |  | orphans.swift |
| PhotoModeOptionGridButtonData |  | orphans.swift |
| PhotoModeOptionSelectorData |  | orphans.swift |
| gameuiIndexedMorphName |  | orphans.swift |
| gameuiIndexedAppearanceDefinition |  | orphans.swift |
| gameuiSwitcherOption |  | orphans.swift |
| gameuiSwitchPair |  | orphans.swift |
| PerkScreenTierInfo |  | orphans.swift |
| PerkTierHighlight |  | orphans.swift |
| UnlockAnimData |  | orphans.swift |
| PerkHoverEventTooltipData |  | orphans.swift |
| PerkTooltipDescriptionEntry |  | orphans.swift |
| TarotCardData |  | orphans.swift |
| SocialPanelContactInfo |  | orphans.swift |
| TargetIndicatorEntry |  | orphans.swift |
| smartGunUITargetParameters |  | orphans.swift |
| ListChoiceData |  | orphans.swift |
| ListChoiceHubData |  | orphans.swift |
| InteractionChoiceData |  | orphans.swift |
| VisualizersInfo |  | orphans.swift |
| scannerQuestEntry |  | orphans.swift |
| InventoryComboBoxData |  | orphans.swift |
| SettingsCategory |  | orphans.swift |
| NPCAbility |  | orphans.swift |
| GridCell |  | orphans.swift |
| ScoreboardPlayer |  | orphans.swift |
| gameJournalEntryStateChangeData |  | orphans.swift |
| DialogHubData |  | orphans.swift |
| gameJournalQuestTrackedData |  | orphans.swift |
| SCodexRecord |  | orphans.swift |
| SCodexRecordPart |  | orphans.swift |
| UIObjectiveEntryData |  | orphans.swift |
| gameuiLocalPhoneElement |  | orphans.swift |
| ChatterKeyValuePair |  | orphans.swift |
| MinigameData |  | orphans.swift |
| CharactersChain |  | orphans.swift |
| UnlockableProgram |  | orphans.swift |
| Overlap |  | orphans.swift |
| gamemappinsSenseCone |  | orphans.swift |
| smartGunUISightParameters |  | orphans.swift |
| gameuiWeaponShootParams |  | orphans.swift |
| gameuiMountedWeaponTarget |  | orphans.swift |
| gameuiDriverCombatCrosshairReticleData |  | orphans.swift |
| CyberdeckDeviceQuickhackData |  | orphans.swift |
| PlayerListEntryData |  | orphans.swift |
| gameuiDetectionParams |  | orphans.swift |
| InputHintGroupData |  | orphans.swift |
| BraindanceClueData |  | orphans.swift |
| AIStackSignalConditionData |  | orphans.swift |
| NpcNameplateVisualData |  | orphans.swift |
| EquipmentWidgets |  | orphans.swift |
| AIBackgroundCombatStep |  | orphans.swift |
| SStatPoolValue |  | orphans.swift |
| SDebugChoice |  | orphans.swift |
| SCachedStat |  | orphans.swift |
| EndScreenData |  | orphans.swift |
| vehicleColorSelectorPointerDef |  | orphans.swift |
| SFakeFeatureChoice |  | orphans.swift |
| CellData |  | orphans.swift |
| SpecialProperties |  | orphans.swift |
| NetworkMinigameData |  | orphans.swift |
| NewTurnMinigameData |  | orphans.swift |
| JukeboxSetup |  | orphans.swift |
| RadioSetup |  | orphans.swift |
| IceMachineSFX |  | orphans.swift |
| NcartTimetableSetup |  | orphans.swift |
| ActivatedDeviceNPCSetup |  | orphans.swift |
| WeaponVendingMachineSetup |  | orphans.swift |
| WeaponVendingMachineSFX |  | orphans.swift |
| AOEAreaSetup |  | orphans.swift |
| SequenceVideo |  | orphans.swift |
| SoundFxFactsSet |  | orphans.swift |
| DeviceRef |  | orphans.swift |
| SurveillanceCameraResaveData |  | orphans.swift |
| SHighlightTarget |  | orphans.swift |
| LightPreset |  | orphans.swift |
| DoorPersistentData |  | orphans.swift |
| DoorResaveData |  | orphans.swift |
| AuthorizationFactsSet |  | orphans.swift |
| AttemptedToStopFactsSet |  | orphans.swift |
| ForkliftSetup |  | orphans.swift |
| MediaResaveData |  | orphans.swift |
| MediaDeviceData |  | orphans.swift |
| WindowBlindersData |  | orphans.swift |
| VentilationAreaSetup |  | orphans.swift |
| SChannelEnumData |  | orphans.swift |
| TVResaveData |  | orphans.swift |
| SoundSystemSettings |  | orphans.swift |
| SpeakerSetup |  | orphans.swift |
| SBaseStateOperationData |  | orphans.swift |
| SPresetTimetableEntry |  | orphans.swift |
| SmartHouseConfiguration |  | orphans.swift |
| SDoorStateOperationData |  | orphans.swift |
| SBaseActionOperationData |  | orphans.swift |
| SCustomActionOperationData |  | orphans.swift |
| STriggerVolumeOperationData |  | orphans.swift |
| SInteractionAreaOperationData |  | orphans.swift |
| SHitOperationData |  | orphans.swift |
| SSensesOperationData |  | orphans.swift |
| SFocusModeOperationData |  | orphans.swift |
| SGenericDevicePersistentData |  | orphans.swift |
| ComputerPersistentData |  | orphans.swift |
| UIScreenDefinition |  | orphans.swift |
| SNewsFeedData |  | orphans.swift |
| WeakFenceSetup |  | orphans.swift |
| MovableDeviceSetup |  | orphans.swift |
| CasinoTableSlotData |  | orphans.swift |
| BetData |  | orphans.swift |
| BetOnMark |  | orphans.swift |
| SecurityLockerProperties |  | orphans.swift |
| SecurityLockerUserEntry |  | orphans.swift |
| CrossingLightSetup |  | orphans.swift |
| TrafficPersistentData |  | orphans.swift |
| TrafficLightResaveData |  | orphans.swift |
| FanSetup |  | orphans.swift |
| FanResaveData |  | orphans.swift |
| SWeakPoints |  | orphans.swift |
| SCyberware |  | orphans.swift |
| DPSPackage |  | orphans.swift |
| SInspectableClue |  | orphans.swift |
| AttackDebugData |  | orphans.swift |
| ActionPrereqs |  | orphans.swift |
| ActionInteractivityInfo |  | orphans.swift |
| Time |  | orphans.swift |
| PlayerVisionModeControllerInputListeners |  | orphans.swift |
| QuickWheelEndUIStructure |  | orphans.swift |
| SecuritySystemMorphData |  | orphans.swift |
| RandomizationDataEntry |  | orphans.swift |
| AICommandNodeFunction |  | orphans.swift |
| questPaymentConditionData |  | orphans.swift |
| InstanceDataMappedToReferenceName |  | orphans.swift |
| EFirstEquipData |  | orphans.swift |
| EffectExecutor_SlashEffect_Entry |  | orphans.swift |
| BeamData |  | orphans.swift |
| ncartDoorScreenLineDataDef |  | orphans.swift |
| ncartStationListDef |  | orphans.swift |
| ncartLineListDef |  | orphans.swift |
| FUNC_TEST_Container |  | orphans.swift |
| FUNC_TEST_Container_2 |  | orphans.swift |
| at_uiWidgetData |  | orphans.swift |
| CuttingGrenadePotentialTarget |  | orphans.swift |
| PuppetActionContext |  | orphans.swift |
| KeyBindings |  | orphans.swift |
| QuickMeleeAttackData |  | orphans.swift |

### Enums (897)

| Name | Bases | Source File |
|------|-------|-------------|
| moveMovementType |  | orphans.swift |
| gameEActionStatus |  | orphans.swift |
| AIEExecutionOutcome |  | orphans.swift |
| AIEInterruptionOutcome |  | orphans.swift |
| AIbehaviorCombatModes |  | orphans.swift |
| AICombatSpaceSize |  | orphans.swift |
| AIArgumentType |  | orphans.swift |
| AIParameterizationType |  | orphans.swift |
| EAIAttitude |  | orphans.swift |
| gameLoSMode |  | orphans.swift |
| gameinfluenceCollisionTestOutcome |  | orphans.swift |
| gameinfluenceTestLineResult |  | orphans.swift |
| ECallbackExpressionActions |  | orphans.swift |
| gameFearStage |  | orphans.swift |
| AIinfluenceEBumpPolicy |  | orphans.swift |
| gameDismBodyPart |  | orphans.swift |
| gameDismWoundType |  | orphans.swift |
| entAudioDismembermentPart |  | orphans.swift |
| MountType |  | orphans.swift |
| entragdollActivationRequestType |  | orphans.swift |
| gameScriptedBlackboardStorage |  | orphans.swift |
| gameprojectileOnCollisionAction |  | orphans.swift |
| questObjectInspectEventType |  | orphans.swift |
| EMovementDirection |  | orphans.swift |
| EAIHitIntensity |  | orphans.swift |
| EAIHitSource |  | orphans.swift |
| EAILastHitReactionPlayed |  | orphans.swift |
| EAIHitDirection |  | orphans.swift |
| EAIHitBodyPart |  | orphans.swift |
| EAIDismembermentBodyPart |  | orphans.swift |
| ReactionZones_Humanoid_Side |  | orphans.swift |
| HitShape_Type |  | orphans.swift |
| EHitReactionZone |  | orphans.swift |
| EHitShapeType |  | orphans.swift |
| DelamainTaxiState |  | orphans.swift |
| AICommandState |  | orphans.swift |
| ECompanionDistancePreset |  | orphans.swift |
| ECompanionPositionPreset |  | orphans.swift |
| AIbehaviorConditionOutcomes |  | orphans.swift |
| AIbehaviorUpdateOutcome |  | orphans.swift |
| AIbehaviorCompletionStatus |  | orphans.swift |
| gameSharedInventoryTag |  | orphans.swift |
| gameinteractionsELootChoiceType |  | orphans.swift |
| gameinteractionsELootVisualiserControlOperation |  | orphans.swift |
| gameSceneAnimationMotionActionParamsPlacementMode |  | orphans.swift |
| MechanicalScanType |  | orphans.swift |
| DronePose |  | orphans.swift |
| EJuryrigTrapState |  | orphans.swift |
| entVisibilityParamSource |  | orphans.swift |
| moveCirclingDirection |  | orphans.swift |
| moveLineOfSight |  | orphans.swift |
| moveLineOfSightPointPreference |  | orphans.swift |
| worldOffMeshConnectionType |  | orphans.swift |
| moveExplorationType |  | orphans.swift |
| moveLocomotionAction |  | orphans.swift |
| vehicleEState |  | orphans.swift |
| vehicleELightMode |  | orphans.swift |
| vehicleELightType |  | orphans.swift |
| gameEPrerequisiteType |  | orphans.swift |
| gameEItemIDFlag |  | orphans.swift |
| AICombatSectorType |  | orphans.swift |
| AISquadType |  | orphans.swift |
| ERenderingPlane |  | orphans.swift |
| EquipmentManipulationRequestType |  | orphans.swift |
| EquipmentManipulationRequestSlot |  | orphans.swift |
| gameVisionModeType |  | orphans.swift |
| VisionModePatternType |  | orphans.swift |
| gameEStatFlags |  | orphans.swift |
| gameStatModifierType |  | orphans.swift |
| gameStatObjectsRelation |  | orphans.swift |
| gameGodModeType |  | orphans.swift |
| gameCombinedStatOperation |  | orphans.swift |
| gameinteractionsEInteractionEventType |  | orphans.swift |
| animAimState |  | orphans.swift |
| animStanceState |  | orphans.swift |
| animHitReactionType |  | orphans.swift |
| ESpaceFillMode |  | orphans.swift |
| TweakWeaponPose |  | orphans.swift |
| gameinteractionsReactionState |  | orphans.swift |
| gameinteractionsBumpSide |  | orphans.swift |
| gameinteractionsBumpIntensity |  | orphans.swift |
| gameScanningState |  | orphans.swift |
| gameinteractionsBumpLocation |  | orphans.swift |
| animCoverState |  | orphans.swift |
| gameScanningMode |  | orphans.swift |
| animCoverAction |  | orphans.swift |
| gamestateMachineParameterAspect |  | orphans.swift |
| gameeventsDeathDirection |  | orphans.swift |
| gameprojectileELaunchMode |  | orphans.swift |
| gameinteractionsChoiceType |  | orphans.swift |
| gameTickableEventState |  | orphans.swift |
| animNPCVehicleDeathType |  | orphans.swift |
| gameScriptTaskExecutionStage |  | orphans.swift |
| ELogicOperator |  | orphans.swift |
| animWeaponOwnerType |  | orphans.swift |
| animLookAtStyle |  | orphans.swift |
| animLookAtLimitDegreesType |  | orphans.swift |
| animLookAtLimitDistanceType |  | orphans.swift |
| animLookAtChestMode |  | orphans.swift |
| animLookAtHeadMode |  | orphans.swift |
| animLookAtEyesMode |  | orphans.swift |
| animLookAtLeftHandedMode |  | orphans.swift |
| animLookAtRightHandedMode |  | orphans.swift |
| animLookAtTwoHandedMode |  | orphans.swift |
| animLookAtStatus |  | orphans.swift |
| gamedeviceActionPropertyFlags |  | orphans.swift |
| EDeviceChallengeSkill |  | orphans.swift |
| EDeviceChallengeAttribute |  | orphans.swift |
| AdditionalTraceType |  | orphans.swift |
| ESenseLogSource |  | orphans.swift |
| ZoneRelativeToVehicle |  | orphans.swift |
| ETweakAINodeType |  | orphans.swift |
| EToggleOperationType |  | orphans.swift |
| EPriority |  | orphans.swift |
| EFocusForcedHighlightType |  | orphans.swift |
| EFocusOutlineType |  | orphans.swift |
| ERevealState |  | orphans.swift |
| ERevealDurationType |  | orphans.swift |
| EProgressBarType |  | orphans.swift |
| EProgressBarContext |  | orphans.swift |
| EMappinDisplayMode |  | orphans.swift |
| EUploadProgramState |  | orphans.swift |
| EAIActionPhase |  | orphans.swift |
| EAxisType |  | orphans.swift |
| EMappinVisualState |  | orphans.swift |
| EGameplayRole |  | orphans.swift |
| EFocusClueInvestigationState |  | orphans.swift |
| EConclusionQuestState |  | orphans.swift |
| gamePlatformMovementState |  | orphans.swift |
| gameMovingPlatformMovementInitializationType |  | orphans.swift |
| gameMovingPlatformLoopType |  | orphans.swift |
| PocketRadioRestrictions |  | orphans.swift |
| senseEShapeType |  | orphans.swift |
| gamedataAttackType |  | orphans.swift |
| gamedataDamageType |  | orphans.swift |
| gamedataItemCategory |  | orphans.swift |
| gamedataItemType |  | orphans.swift |
| gamedataMappinVariant |  | orphans.swift |
| gamedataMappinPhase |  | orphans.swift |
| gamedataMovementType |  | orphans.swift |
| gamedataParentAttachmentType |  | orphans.swift |
| gamedataQuality |  | orphans.swift |
| gamedataStatType |  | orphans.swift |
| EChargesAmount |  | orphans.swift |
| EChargesItem |  | orphans.swift |
| EInputCustomKey |  | orphans.swift |
| GameplayTier |  | orphans.swift |
| Tier2WalkType |  | orphans.swift |
| InputDevice |  | orphans.swift |
| vehicleCameraType |  | orphans.swift |
| InputScheme |  | orphans.swift |
| vehicleCameraPerspective |  | orphans.swift |
| gameinputActionType |  | orphans.swift |
| TargetComponentFilterType |  | orphans.swift |
| TSFMV |  | orphans.swift |
| TargetingSet |  | orphans.swift |
| vehiclePoliceStrategy |  | orphans.swift |
| EInputKey |  | orphans.swift |
| PuppetVehicleState |  | orphans.swift |
| ObjectToCheck |  | orphans.swift |
| ELogType |  | orphans.swift |
| EComparisonType |  | orphans.swift |
| navNaviPositionType |  | orphans.swift |
| gameEntitySpawnerEventType |  | orphans.swift |
| AITrackedStatusType |  | orphans.swift |
| AIThreatPersistenceStatus |  | orphans.swift |
| gameDebugViewETextAlignment |  | orphans.swift |
| gameGrenadeThrowStartType |  | orphans.swift |
| AICoverExposureMethod |  | orphans.swift |
| gamecheatsystemFlag |  | orphans.swift |
| entAttachmentTarget |  | orphans.swift |
| gameCoverHeight |  | orphans.swift |
| AIUninterruptibleActionType |  | orphans.swift |
| grsHeistStatus |  | orphans.swift |
| gamedataStatPoolType |  | orphans.swift |
| gameGameVersion |  | orphans.swift |
| gameSaveLockReason |  | orphans.swift |
| gamedataTriggerMode |  | orphans.swift |
| gamedataWeaponEvolution |  | orphans.swift |
| gamedataWeaponManufacturer |  | orphans.swift |
| gamedataGender |  | orphans.swift |
| gamedataPerkType |  | orphans.swift |
| GOGRewardsSystemStatus |  | orphans.swift |
| GOGRewardsSystemErrors |  | orphans.swift |
| gamedataPerkWeaponGroupType |  | orphans.swift |
| gamedataNewPerkType |  | orphans.swift |
| gameEEquipmentManagerState |  | orphans.swift |
| gamedataNewPerkCategoryType |  | orphans.swift |
| gamedataNewPerkTierType |  | orphans.swift |
| gamedataNewPerkSlotType |  | orphans.swift |
| gamedataAttributeDataType |  | orphans.swift |
| gamedataProficiencyType |  | orphans.swift |
| gamedataDevelopmentPointType |  | orphans.swift |
| gamedataEthnicity |  | orphans.swift |
| gamedataStatusEffectType |  | orphans.swift |
| gamedataAffiliation |  | orphans.swift |
| gamedataReactionPresetType |  | orphans.swift |
| gamedataStimType |  | orphans.swift |
| HighlightContext |  | orphans.swift |
| gamedataStimPropagation |  | orphans.swift |
| gamedataStimPriority |  | orphans.swift |
| gamedataStimTargets |  | orphans.swift |
| gamedataBuildType |  | orphans.swift |
| gamedataEquipmentArea |  | orphans.swift |
| gamedataWorkspotActionType |  | orphans.swift |
| gamedataWorkspotReactionType |  | orphans.swift |
| gamedataDistrict |  | orphans.swift |
| gamemappinsMappinTargetType |  | orphans.swift |
| gamedataNPCUpperBodyState |  | orphans.swift |
| gamedataNPCHighLevelState |  | orphans.swift |
| gamedataNPCStanceState |  | orphans.swift |
| gamedataNPCBehaviorState |  | orphans.swift |
| gamedataDefenseMode |  | orphans.swift |
| gamedataLocomotionMode |  | orphans.swift |
| gamedataNPCType |  | orphans.swift |
| gamedataUINameplateDisplayType |  | orphans.swift |
| gamedataNPCRarity |  | orphans.swift |
| gamedataAIActionTarget |  | orphans.swift |
| gameMountingSlotRole |  | orphans.swift |
| gameMountingObjectType |  | orphans.swift |
| gameMountingObjectSubType |  | orphans.swift |
| gameMountingRelationshipType |  | orphans.swift |
| HUDActorType |  | orphans.swift |
| HUDActorStatus |  | orphans.swift |
| ActorVisibilityStatus |  | orphans.swift |
| gamedataAIActionType |  | orphans.swift |
| gamedataAITacticType |  | orphans.swift |
| gamedataAIRingType |  | orphans.swift |
| gamedataAITicketType |  | orphans.swift |
| EGameSessionDataType |  | orphans.swift |
| gamedataAISquadType |  | orphans.swift |
| ELightState |  | orphans.swift |
| gamedataAIActionSecurityNotificationType |  | orphans.swift |
| gamedataAIActionSecurityAreaType |  | orphans.swift |
| audioEventActionType |  | orphans.swift |
| gamedataAISmartCompositeType |  | orphans.swift |
| audioAudioEventFlags |  | orphans.swift |
| gamedataAIExposureMethodType |  | orphans.swift |
| gamedataAIAdditionalTraceType |  | orphans.swift |
| gamedataAIThreatPersistenceSource |  | orphans.swift |
| gamedataVehicleType |  | orphans.swift |
| DropPointPackageStatus |  | orphans.swift |
| gamedataVehicleModel |  | orphans.swift |
| gamedataVehicleManufacturer |  | orphans.swift |
| gameaudioeventsSurfaceDirection |  | orphans.swift |
| gamedataVehicleUnlockType |  | orphans.swift |
| gamedataIsHackable |  | orphans.swift |
| gamedataDriverCombatType |  | orphans.swift |
| gamedataAIRole |  | orphans.swift |
| gamedataChoiceCaptionPartType |  | orphans.swift |
| gamedataSubCharacter |  | orphans.swift |
| gamedataFxAction |  | orphans.swift |
| vehicleAudioEventAction |  | orphans.swift |
| audioTrafficVehicleAudioAction |  | orphans.swift |
| gamedataFxActionType |  | orphans.swift |
| gamedataLifePath |  | orphans.swift |
| gamedataPlayerBuild |  | orphans.swift |
| gamedataStatusEffectAIBehaviorType |  | orphans.swift |
| worldNavigationRequestStatus |  | orphans.swift |
| gamedataStatusEffectAIBehaviorFlag |  | orphans.swift |
| NavGenAgentSize |  | orphans.swift |
| gamedataObjectActionType |  | orphans.swift |
| gamedataObjectActionReference |  | orphans.swift |
| gamedataPingType |  | orphans.swift |
| gamedataPerkArea |  | orphans.swift |
| gamedataAIDirectorEntryStartType |  | orphans.swift |
| gamedataVendorType |  | orphans.swift |
| gamedataMeleeAttackDirection |  | orphans.swift |
| gamedataGrenadeDeliveryMethodType |  | orphans.swift |
| gamedataUICondition |  | orphans.swift |
| gamedataWorldMapFilter |  | orphans.swift |
| gamedataSpawnableObjectPriority |  | orphans.swift |
| gamedataStatusEffectVariation |  | orphans.swift |
| gamedataCompanionDistancePreset |  | orphans.swift |
| gamedataProjectileOnCollisionAction |  | orphans.swift |
| gamedataProjectileLaunchMode |  | orphans.swift |
| gamedataNPCQuestAffiliation |  | orphans.swift |
| gamedataAchievement |  | orphans.swift |
| gamedataOutput |  | orphans.swift |
| gamedataWorkspotCategory |  | orphans.swift |
| gamedataSenseObjectType |  | orphans.swift |
| gamedataImprovementRelation |  | orphans.swift |
| gamedataConsumableType |  | orphans.swift |
| gamedataPlayerPossesion |  | orphans.swift |
| gamedataTraitType |  | orphans.swift |
| gamedataAttackSubtype |  | orphans.swift |
| gamedataPerkUtility |  | orphans.swift |
| gamedataArchetypeType |  | orphans.swift |
| gamedataItemStructure |  | orphans.swift |
| gamedataHitPrereqConditionType |  | orphans.swift |
| gamedataTrackingMode |  | orphans.swift |
| gamedataConsumableBaseName |  | orphans.swift |
| gamedataMetaQuest |  | orphans.swift |
| gamedataAimAssistType |  | orphans.swift |
| gamedataSearchFilterMaskType |  | orphans.swift |
| gamedataUIIconCensorFlag |  | orphans.swift |
| gamedataCheckType |  | orphans.swift |
| gamedataEffectorTimeDilationDriver |  | orphans.swift |
| gamedataComputerUIStyle |  | orphans.swift |
| gamedataAIDifficulty |  | orphans.swift |
| gamedataAIComparison |  | orphans.swift |
| gamedataHackCategory |  | orphans.swift |
| gamedataDeviceHackCategory |  | orphans.swift |
| gamedataDeviceHackTier |  | orphans.swift |
| gamedataMinigameCategory |  | orphans.swift |
| gamedataMinigameActionType |  | orphans.swift |
| gamedataMinigameTrapType |  | orphans.swift |
| gamedataWidgetStyle |  | orphans.swift |
| gamedataContainerType |  | orphans.swift |
| gamedataCharacterRandomizationCategory |  | orphans.swift |
| DynamicVehicleType |  | orphans.swift |
| gameAutodriveDestinationType |  | orphans.swift |
| gameAutodriveLaneValidityResult |  | orphans.swift |
| AIReactionCountOutcome |  | orphans.swift |
| physicsStateValue |  | orphans.swift |
| gameDifficulty |  | orphans.swift |
| ECLSForcedState |  | orphans.swift |
| gameStatPoolModificationTypes |  | orphans.swift |
| EVisionBlockerType |  | orphans.swift |
| scnFastForwardMode |  | orphans.swift |
| scnPlayDirection |  | orphans.swift |
| scnPlaySpeed |  | orphans.swift |
| UIGameContext |  | orphans.swift |
| worldRainIntensity |  | orphans.swift |
| gameuiPatchIntro |  | orphans.swift |
| gameuiOneTimeMessage |  | orphans.swift |
| EAppliedTriangulationHackSpeed |  | orphans.swift |
| gametargetingSystemETargetFilterStatus |  | orphans.swift |
| gameWardrobeClothingSetIndex |  | orphans.swift |
| EntityNotificationType |  | orphans.swift |
| inkanimPropertyType |  | orphans.swift |
| inkanimInterpolationMode |  | orphans.swift |
| inkanimInterpolationType |  | orphans.swift |
| inkanimEventType |  | orphans.swift |
| inkanimLoopType |  | orphans.swift |
| inkanimInterpolationDirection |  | orphans.swift |
| EPreventionHackLoopState |  | orphans.swift |
| inkEButtonState |  | orphans.swift |
| inkDiscreteNavigationDirection |  | orphans.swift |
| EDodgeMovementInput |  | orphans.swift |
| EOutlineType |  | orphans.swift |
| inkEScrollDirection |  | orphans.swift |
| gameStoryTier |  | orphans.swift |
| inkEToggleState |  | orphans.swift |
| gameTelemetryDamageSituation |  | orphans.swift |
| telemetryHitDefenseType |  | orphans.swift |
| telemetryInitalChoiceStage |  | orphans.swift |
| gamePlayerStateMachine |  | orphans.swift |
| telemetryMovementType |  | orphans.swift |
| GenericNotificationType |  | orphans.swift |
| gamePSMLocomotionStates |  | orphans.swift |
| gamePSMUpperBodyStates |  | orphans.swift |
| gamePSMWeaponStates |  | orphans.swift |
| gamePSMTimeDilation |  | orphans.swift |
| gamePSMHighLevel |  | orphans.swift |
| vehicleGarageState |  | orphans.swift |
| vehicleSummonState |  | orphans.swift |
| vehicleDisabledReason |  | orphans.swift |
| gamePSMZones |  | orphans.swift |
| gamePSMBodyCarryingStyle |  | orphans.swift |
| gamePSMBodyCarrying |  | orphans.swift |
| gamePSMMelee |  | orphans.swift |
| gamePSMUIState |  | orphans.swift |
| gamePSMCrosshairStates |  | orphans.swift |
| gamePSMReaction |  | orphans.swift |
| gamePSMVisionDebug |  | orphans.swift |
| gamePSMVision |  | orphans.swift |
| gamePSMCombatGadget |  | orphans.swift |
| gamePSMVehicle |  | orphans.swift |
| gamePSMWhip |  | orphans.swift |
| coverLeanDirection |  | orphans.swift |
| gamePSMLeftHandCyberware |  | orphans.swift |
| gamePSMMeleeWeapon |  | orphans.swift |
| gamePSMDetailedLocomotionStates |  | orphans.swift |
| gamePSMCombat |  | orphans.swift |
| gamePSMStamina |  | orphans.swift |
| gamePSMVitals |  | orphans.swift |
| gamePSMTakedown |  | orphans.swift |
| gamePSMRangedWeaponStates |  | orphans.swift |
| gamePSMFallStates |  | orphans.swift |
| gamePSMLandingState |  | orphans.swift |
| inkTextureType |  | orphans.swift |
| braindanceVisionMode |  | orphans.swift |
| gamePSMWorkspotState |  | orphans.swift |
| gamePSMSwimming |  | orphans.swift |
| gamePSMBodyCarryingLocomotion |  | orphans.swift |
| inkInputHintHoldIndicationType |  | orphans.swift |
| gamePSMDetailedBodyDisposal |  | orphans.swift |
| gamePSMNanoWireLaunchMode |  | orphans.swift |
| moveSecureFootingFailureReason |  | orphans.swift |
| inkSelectorChangeDirection |  | orphans.swift |
| moveSecureFootingFailureType |  | orphans.swift |
| gameuiEBraindanceLayer |  | orphans.swift |
| gameuiEClueDescriptorMode |  | orphans.swift |
| gameMessageSender |  | orphans.swift |
| gameContactType |  | orphans.swift |
| inkEOrientation |  | orphans.swift |
| inkEChildOrder |  | orphans.swift |
| inkEHorizontalAlign |  | orphans.swift |
| inkEVerticalAlign |  | orphans.swift |
| inkEAnchor |  | orphans.swift |
| inkESliderDirection |  | orphans.swift |
| inkESizeRule |  | orphans.swift |
| inkIconResult |  | orphans.swift |
| gameJournalQuestType |  | orphans.swift |
| questJournalSizeEventType |  | orphans.swift |
| questJournalAlignmentEventType |  | orphans.swift |
| gameJournalBriefingContentType |  | orphans.swift |
| textLetterCase |  | orphans.swift |
| textVerticalAlignment |  | orphans.swift |
| textHorizontalAlignment |  | orphans.swift |
| WorkspotSlidingBehaviour |  | orphans.swift |
| inkMenuMode |  | orphans.swift |
| inkMenuState |  | orphans.swift |
| workWorkspotDebugMode |  | orphans.swift |
| EInkAnimationPlaybackOption |  | orphans.swift |
| inkEffectType |  | orphans.swift |
| RumbleStrength |  | orphans.swift |
| RumbleType |  | orphans.swift |
| RumblePosition |  | orphans.swift |
| inkBrushDrawType |  | orphans.swift |
| inkBrushTileType |  | orphans.swift |
| EMeasurementSystem |  | orphans.swift |
| inkBrushMirrorType |  | orphans.swift |
| EMeasurementUnit |  | orphans.swift |
| PopupPosition |  | orphans.swift |
| VideoType |  | orphans.swift |
| SimpleMessageType |  | orphans.swift |
| WorkspotWeaponConditionEnum |  | orphans.swift |
| WorkspotConditionOperators |  | orphans.swift |
| LifetimeStatus |  | orphans.swift |
| inkSelectionRule |  | orphans.swift |
| worldgeometryDescriptionQueryFlags |  | orphans.swift |
| worldgeometryDescriptionQueryStatus |  | orphans.swift |
| worldgeometryProbingStatus |  | orphans.swift |
| EFastTravelSystemInstruction |  | orphans.swift |
| AISignalFlags |  | orphans.swift |
| scnDialogLineType |  | orphans.swift |
| scnDialogLineLanguage |  | orphans.swift |
| ECentaurShieldState |  | orphans.swift |
| TakeOverControlSystemInputHintSortPriority |  | orphans.swift |
| EKnockdownStates |  | orphans.swift |
| EMenuType |  | orphans.swift |
| ActiveMode |  | orphans.swift |
| InstanceState |  | orphans.swift |
| ModuleState |  | orphans.swift |
| VisualState |  | orphans.swift |
| SignalType |  | orphans.swift |
| HUDState |  | orphans.swift |
| HUDContext |  | orphans.swift |
| EVehicleDoor |  | orphans.swift |
| VehicleDoorState |  | orphans.swift |
| EVehicleWindowState |  | orphans.swift |
| VehicleDoorInteractionState |  | orphans.swift |
| EQuestVehicleDoorState |  | orphans.swift |
| EQuestVehicleWindowState |  | orphans.swift |
| VehicleNetrunnerQuickhackType |  | orphans.swift |
| ConfigVarType |  | orphans.swift |
| VehicleQuestEngineLockState |  | orphans.swift |
| ConfigVarUpdatePolicy |  | orphans.swift |
| UserSettingsLoadStatus |  | orphans.swift |
| ConfigChangeReason |  | orphans.swift |
| ConfigNotificationType |  | orphans.swift |
| vehicleQuestUIEnable |  | orphans.swift |
| vehicleRaceUI |  | orphans.swift |
| VehicleVisualCustomizationType |  | orphans.swift |
| WeaponPartType |  | orphans.swift |
| gameuiHitType |  | orphans.swift |
| gameuiDamageDigitsMode |  | orphans.swift |
| gameuiDamageDigitsStickingMode |  | orphans.swift |
| gameuiDamageIndicatorMode |  | orphans.swift |
| gameKillType |  | orphans.swift |
| vehicleQuestWindowDestruction |  | orphans.swift |
| panzerBootupUI |  | orphans.swift |
| GenericMessageNotificationType |  | orphans.swift |
| GenericMessageNotificationResult |  | orphans.swift |
| CrafringMaterialItemHighlight |  | orphans.swift |
| ItemSortMode |  | orphans.swift |
| ItemFilterType |  | orphans.swift |
| DropdownItemDirection |  | orphans.swift |
| DropdownDisplayContext |  | orphans.swift |
| EEntryColumn |  | orphans.swift |
| ECooldownGameControllerMode |  | orphans.swift |
| ECooldownIndicatorState |  | orphans.swift |
| EFrameState |  | orphans.swift |
| CodexDataSource |  | orphans.swift |
| ItemFilterCategory |  | orphans.swift |
| ECraftingIconPositioning |  | orphans.swift |
| ECartOperationResult |  | orphans.swift |
| EVendorMode |  | orphans.swift |
| vehicleExitDirection |  | orphans.swift |
| vehicleCoolExitImpulseLevel |  | orphans.swift |
| inkGameScreenshotSortMode |  | orphans.swift |
| inkLoadingScreenType |  | orphans.swift |
| gameuiAuthorisationNotificationType |  | orphans.swift |
| Direction |  | orphans.swift |
| ELinkType |  | orphans.swift |
| ENetworkRelation |  | orphans.swift |
| EPingType |  | orphans.swift |
| RadialHubMenuElement |  | orphans.swift |
| CodexCategoryType |  | orphans.swift |
| CraftingNotificationType |  | orphans.swift |
| CodexImageType |  | orphans.swift |
| EGenericNotificationPriority |  | orphans.swift |
| PauseMenuAction |  | orphans.swift |
| CurrencyNotificationAnimState |  | orphans.swift |
| JournalNotificationMode |  | orphans.swift |
| CraftingMode |  | orphans.swift |
| UIInGameNotificationType |  | orphans.swift |
| ScreenDisplayContext |  | orphans.swift |
| HubMenuItems |  | orphans.swift |
| HubMenuCraftingItems |  | orphans.swift |
| HubMenuInventoryItems |  | orphans.swift |
| HubMenuCharacterItems |  | orphans.swift |
| HubMenuDatabaseItems |  | orphans.swift |
| HubVendorMenuItems |  | orphans.swift |
| UIMenuNotificationType |  | orphans.swift |
| ExpansionPopupType |  | orphans.swift |
| NewPerkTabsArrowDirection |  | orphans.swift |
| TransferSaveState |  | orphans.swift |
| TransferSaveAction |  | orphans.swift |
| NewPerksWireState |  | orphans.swift |
| WorldMapTooltipType |  | orphans.swift |
| PerkMenuAttribute |  | orphans.swift |
| MessageViewType |  | orphans.swift |
| NewPerksCyberwareDetailsMenu |  | orphans.swift |
| gameuiTutorialHiddenReason |  | orphans.swift |
| MessengerContactType |  | orphans.swift |
| CharacterScreenType |  | orphans.swift |
| NewPerkCellAnimationType |  | orphans.swift |
| operationsMode |  | orphans.swift |
| gameuiCharacterCustomizationPart |  | orphans.swift |
| gameuiCharacterCustomizationEditTag |  | orphans.swift |
| EReactLogSource |  | orphans.swift |
| AttributeButtonState |  | orphans.swift |
| EGOGMenuState |  | orphans.swift |
| gameuiEWorldMapCameraMode |  | orphans.swift |
| EWorldMapView |  | orphans.swift |
| gameuiEWorldMapDistrictView |  | orphans.swift |
| gameuiMappinGroupState |  | orphans.swift |
| ECustomFilterDPadNavigationOption |  | orphans.swift |
| inkLifePath |  | orphans.swift |
| inkSaveType |  | orphans.swift |
| inkSaveStatus |  | orphans.swift |
| inkSaveTransferStatus |  | orphans.swift |
| BusySwitchingReason |  | orphans.swift |
| GogPopupScreenType |  | orphans.swift |
| ItemDisplayNotificationMessage |  | orphans.swift |
| NewPeksActiveScreen |  | orphans.swift |
| BarType |  | orphans.swift |
| VendorConfirmationPopupType |  | orphans.swift |
| DerivedFilterResult |  | orphans.swift |
| VendorSellJunkActionType |  | orphans.swift |
| CloudSavesQueryStatus |  | orphans.swift |
| inkMarketingConsentPopupType |  | orphans.swift |
| ContactsSortMethod |  | orphans.swift |
| ExpansionStatus |  | orphans.swift |
| QuantityPickerActionType |  | orphans.swift |
| EVisualizerActivityState |  | orphans.swift |
| EHudAvatarMode |  | orphans.swift |
| PhoneDialerTabs |  | orphans.swift |
| EVisualizerType |  | orphans.swift |
| EVisualizerDefinitionFlags |  | orphans.swift |
| EInventoryComboBoxMode |  | orphans.swift |
| EHudPhoneVisibility |  | orphans.swift |
| EHudPhoneFunction |  | orphans.swift |
| SettingsType |  | orphans.swift |
| ScannerNetworkState |  | orphans.swift |
| ScannerObjectType |  | orphans.swift |
| ScannerDataType |  | orphans.swift |
| ScannerDetailTab |  | orphans.swift |
| ItemLabelType |  | orphans.swift |
| QuestListItemType |  | orphans.swift |
| QuestListSortType |  | orphans.swift |
| RipperdocFilter |  | orphans.swift |
| CraftingCommands |  | orphans.swift |
| ExpansionErrorType |  | orphans.swift |
| EProgressBarState |  | orphans.swift |
| ItemAdditionalInfoType |  | orphans.swift |
| gamemappinsVerticalPositioning |  | orphans.swift |
| gameStubMappinType |  | orphans.swift |
| HackingMinigameState |  | orphans.swift |
| gameTutorialBracketType |  | orphans.swift |
| gameJournalEntryState |  | orphans.swift |
| gameJournalListenerType |  | orphans.swift |
| JournalChangeType |  | orphans.swift |
| JournalNotifyOption |  | orphans.swift |
| CustomButtonType |  | orphans.swift |
| UIObjectiveEntryType |  | orphans.swift |
| gameuiActivePhoneElement |  | orphans.swift |
| worlduiEntryVisibility |  | orphans.swift |
| PhoneScreenType |  | orphans.swift |
| MessageHash |  | orphans.swift |
| gameEnemyStealthAwarenessState |  | orphans.swift |
| gameReprimandMappinAnimationState |  | orphans.swift |
| InventoryItemAttachmentType |  | orphans.swift |
| EInventoryItemShape |  | orphans.swift |
| ItemIconGender |  | orphans.swift |
| LootItemType |  | orphans.swift |
| MinigameActionType |  | orphans.swift |
| UIItemCategory |  | orphans.swift |
| WeaponType |  | orphans.swift |
| gamesmartGunTargetState |  | orphans.swift |
| gameBreachUITrackingChange |  | orphans.swift |
| gamedataChargeStep |  | orphans.swift |
| EInventoryDataStatDisplayType |  | orphans.swift |
| WeaponBarType |  | orphans.swift |
| WeaponBarTypeGroup |  | orphans.swift |
| SlotType |  | orphans.swift |
| ERadialMode |  | orphans.swift |
| InventoryTooltipDisplayContext |  | orphans.swift |
| GrenadeDamageType |  | orphans.swift |
| gameuiDriverCombatCrosshairReticleDataState |  | orphans.swift |
| RarityItemType |  | orphans.swift |
| ETooltipsStyle |  | orphans.swift |
| gameuiETooltipPlacement |  | orphans.swift |
| CustomWeaponWheelSlot |  | orphans.swift |
| UIInventoryItemWeaponBarsType |  | orphans.swift |
| VehicleVisualCustomizationWidgetCarPart |  | orphans.swift |
| EUIStealthIconType |  | orphans.swift |
| AutoDriveDriveType |  | orphans.swift |
| inkInputHintKeyCombinationType |  | orphans.swift |
| EUIActionState |  | orphans.swift |
| gameuiInputHintSortingPriority |  | orphans.swift |
| ProximityProgressBarOrientation |  | orphans.swift |
| ProximityProgressBarState |  | orphans.swift |
| minimapuiELayerType |  | orphans.swift |
| ClueState |  | orphans.swift |
| ItemDisplayType |  | orphans.swift |
| ItemDisplayContext |  | orphans.swift |
| AIPatrolContinuationPolicy |  | orphans.swift |
| InventoryModes |  | orphans.swift |
| ItemViewModes |  | orphans.swift |
| PaperdollPositionAnimation |  | orphans.swift |
| EAIBackgroundCombatStep |  | orphans.swift |
| ECoverSpecialAction |  | orphans.swift |
| InventoryPaperdollZoomArea |  | orphans.swift |
| hitFlag |  | orphans.swift |
| EVarDBMode |  | orphans.swift |
| damageSystemLogFlags |  | orphans.swift |
| OutcomeMessage |  | orphans.swift |
| vehicleColorSelectorActiveMode |  | orphans.swift |
| vehicleColorSelectorMenuCloseReason |  | orphans.swift |
| vehicleColorSelectorActiveTab |  | orphans.swift |
| vehicleColorSelectorActiveInputMode |  | orphans.swift |
| vehicleColorSelectorSBBar |  | orphans.swift |
| EComponentOperation |  | orphans.swift |
| EMathOperationType |  | orphans.swift |
| ProgramEffect |  | orphans.swift |
| ProgramType |  | orphans.swift |
| ETrap |  | orphans.swift |
| HighlightMode |  | orphans.swift |
| EAIRole |  | orphans.swift |
| ButtonStatus |  | orphans.swift |
| HoverStatus |  | orphans.swift |
| EVehicleBrandState |  | orphans.swift |
| ItemModeGridSize |  | orphans.swift |
| EVehicleOfferState |  | orphans.swift |
| MuramasaOption |  | orphans.swift |
| RipperdocModes |  | orphans.swift |
| CyberwareScreenType |  | orphans.swift |
| RipperdocHoverState |  | orphans.swift |
| EForcedElevatorArrowsState |  | orphans.swift |
| ExtraEffect |  | orphans.swift |
| EComputerMenuType |  | orphans.swift |
| EDocumentType |  | orphans.swift |
| InnerBunkerCoreStatus |  | orphans.swift |
| InnerBunkerCoreStage |  | orphans.swift |
| BunkerSystems |  | orphans.swift |
| OpeningGateScreenState |  | orphans.swift |
| EIndustrialArmAnimations |  | orphans.swift |
| EWidgetPlacementType |  | orphans.swift |
| EScreenRatio |  | orphans.swift |
| ELayoutType |  | orphans.swift |
| EActionInactivityReson |  | orphans.swift |
| ERentStatus |  | orphans.swift |
| EPaymentSchedule |  | orphans.swift |
| worldTrafficLightColor |  | orphans.swift |
| EWidgetState |  | orphans.swift |
| ArcadeMinigame |  | orphans.swift |
| ArcadeMachineType |  | orphans.swift |
| EPlaystyleType |  | orphans.swift |
| ESurveillanceCameraStatus |  | orphans.swift |
| ESurveillanceCameraState |  | orphans.swift |
| EDoorType |  | orphans.swift |
| EDoorStatus |  | orphans.swift |
| EDoorOpeningType |  | orphans.swift |
| EAnimationType |  | orphans.swift |
| EDoorTriggerSide |  | orphans.swift |
| EDoorSkillcheckSide |  | orphans.swift |
| EMalfunctioningType |  | orphans.swift |
| EDebuggerColor |  | orphans.swift |
| EFastTravelTriggerType |  | orphans.swift |
| EFastTravelDeviceType |  | orphans.swift |
| SignType |  | orphans.swift |
| SignShape |  | orphans.swift |
| ExplosiveTriggerDeviceLaserState |  | orphans.swift |
| ERadioStationList |  | orphans.swift |
| EExplosiveAdditionalGameEffectType |  | orphans.swift |
| EViabilityDecision |  | orphans.swift |
| IntercomStatus |  | orphans.swift |
| EWindowBlindersStates |  | orphans.swift |
| EOperationClassType |  | orphans.swift |
| ETVChannel |  | orphans.swift |
| ETriggerOperationType |  | orphans.swift |
| EWorkspotOperationType |  | orphans.swift |
| EEffectOperationType |  | orphans.swift |
| ETransformAnimationOperationType |  | orphans.swift |
| EItemOperationType |  | orphans.swift |
| EBinkOperationType |  | orphans.swift |
| ESmartHousePreset |  | orphans.swift |
| ESystems |  | orphans.swift |
| EActionsSequencerMode |  | orphans.swift |
| ESwitchAction |  | orphans.swift |
| ESoundStatusEffects |  | orphans.swift |
| ELightSwitchRandomizerType |  | orphans.swift |
| RoboticArmStateType |  | orphans.swift |
| CasinoTableSlot |  | orphans.swift |
| CasinoTableState |  | orphans.swift |
| CasinoTableBet |  | orphans.swift |
| ChargeIndicatorWidgetType |  | orphans.swift |
| DoorProximityDetectorAppearanceStateType |  | orphans.swift |
| gameDamageCallbackType |  | orphans.swift |
| gameDamagePipelineStage |  | orphans.swift |
| DMGPipelineType |  | orphans.swift |
| ELightSequenceStage |  | orphans.swift |
| EPreventionHeatStage |  | orphans.swift |
| EPreventionDebugProcessReason |  | orphans.swift |
| EPreventionSystemInstruction |  | orphans.swift |
| EVehicleSpawnBlockSide |  | orphans.swift |
| EStarState |  | orphans.swift |
| ESecurityGateStatus |  | orphans.swift |
| ESecurityGateScannerIssueType |  | orphans.swift |
| ESecurityGateEntranceType |  | orphans.swift |
| ESecurityGateResponseType |  | orphans.swift |
| EToggleActivationTypeComputer |  | orphans.swift |
| EComputerAnimationState |  | orphans.swift |
| ETargetManagerAnimGraphState |  | orphans.swift |
| ESensorDeviceWakeState |  | orphans.swift |
| ESensorDeviceStates |  | orphans.swift |
| ESecurityAreaType |  | orphans.swift |
| EFilterType |  | orphans.swift |
| ETransitionMode |  | orphans.swift |
| CoverState |  | orphans.swift |
| ServerState |  | orphans.swift |
| ETrapEffects |  | orphans.swift |
| PaymentStatus |  | orphans.swift |
| ESecurityTurretStatus |  | orphans.swift |
| ESecurityTurretType |  | orphans.swift |
| EBOOL |  | orphans.swift |
| ECompareOp |  | orphans.swift |
| EWeaponNamesList |  | orphans.swift |
| EAITargetType |  | orphans.swift |
| EAIThreatCalculationType |  | orphans.swift |
| EBarkList |  | orphans.swift |
| EAIBlockDirection |  | orphans.swift |
| EAIActionState |  | orphans.swift |
| AIactionParamsPackageTypes |  | orphans.swift |
| EAIActionTarget |  | orphans.swift |
| EAICombatPreset |  | orphans.swift |
| EHitReactionMode |  | orphans.swift |
| EMeleeAttacks |  | orphans.swift |
| DeviceStimType |  | orphans.swift |
| ETauntType |  | orphans.swift |
| EWoundedBodyPart |  | orphans.swift |
| EStatusEffects |  | orphans.swift |
| EstatusEffectsState |  | orphans.swift |
| EAISquadAction |  | orphans.swift |
| EAISquadTactic |  | orphans.swift |
| EAISquadChoiceAlgorithm |  | orphans.swift |
| EAISquadRing |  | orphans.swift |
| EAISquadVerb |  | orphans.swift |
| EAITicketStatus |  | orphans.swift |
| EAIPlayerSquadOrder |  | orphans.swift |
| EReactionValue |  | orphans.swift |
| EAICoverAction |  | orphans.swift |
| EAICoverActionDirection |  | orphans.swift |
| EAIGateSignalFlags |  | orphans.swift |
| ENPCPhaseState |  | orphans.swift |
| EAIGateEventFlags |  | orphans.swift |
| EAIShootingPatternRange |  | orphans.swift |
| EStatusEffectBehaviorType |  | orphans.swift |
| EComparisonOperator |  | orphans.swift |
| EArgumentType |  | orphans.swift |
| EInitReactionAnim |  | orphans.swift |
| ENeutralizeType |  | orphans.swift |
| EMathOperator |  | orphans.swift |
| EMagazineAmmoState |  | orphans.swift |
| EBroadcasteingType |  | orphans.swift |
| TransmogSlots |  | orphans.swift |
| EDrillMachineRewireState |  | orphans.swift |
| gamePlayerCoverDirection |  | orphans.swift |
| gamePlayerCoverMode |  | orphans.swift |
| worldgeometryaverageNormalDetectionHelperQueryStatus |  | orphans.swift |
| gamePlayerObstacleSystemQueryType |  | orphans.swift |
| PackageStatus |  | orphans.swift |
| RequestType |  | orphans.swift |
| EQuestFilterType |  | orphans.swift |
| AttitudeChange |  | orphans.swift |
| SecurityEventScopeSettings |  | orphans.swift |
| EPermissionSource |  | orphans.swift |
| ERevealPlayerType |  | orphans.swift |
| EAllowedTo |  | orphans.swift |
| ESecurityAccessLevel |  | orphans.swift |
| BlacklistReason |  | orphans.swift |
| ESecuritySystemState |  | orphans.swift |
| EReprimandInstructions |  | orphans.swift |
| EBreachOrigin |  | orphans.swift |
| ESecurityNotificationType |  | orphans.swift |
| PlayerCombatState |  | orphans.swift |
| EShouldChangeAttitude |  | orphans.swift |
| PlayerCombatControllerRefreshPolicyEnum |  | orphans.swift |
| gamedeviceRequestType |  | orphans.swift |
| EGlitchState |  | orphans.swift |
| EDeviceStatus |  | orphans.swift |
| EDeviceDurabilityType |  | orphans.swift |
| EDeviceDurabilityState |  | orphans.swift |
| EGameplayChallengeLevel |  | orphans.swift |
| EActivationState |  | orphans.swift |
| EPersonalLinkSlotSide |  | orphans.swift |
| PlayerVisionModeControllerRefreshPolicyEnum |  | orphans.swift |
| QuickSlotActionType |  | orphans.swift |
| QuickSlotItemType |  | orphans.swift |
| EDPadSlot |  | orphans.swift |
| EActionType |  | orphans.swift |
| ELaunchMode |  | orphans.swift |
| EDeathType |  | orphans.swift |
| ThrowType |  | orphans.swift |
| ECarryState |  | orphans.swift |
| EEquipmentState |  | orphans.swift |
| EEquipmentSide |  | orphans.swift |
| EMissileRainPhase |  | orphans.swift |
| inputContextType |  | orphans.swift |
| ELauncherActionType |  | orphans.swift |
| EBeamStyle |  | orphans.swift |
| EGrenadeType |  | orphans.swift |
| aimTypeEnum |  | orphans.swift |
| EStatProviderDataSource |  | orphans.swift |
| DamageEffectDisplayType |  | orphans.swift |
| ETakedownActionType |  | orphans.swift |
| ETakedownBossName |  | orphans.swift |
| EGravityType |  | orphans.swift |
| ESlotState |  | orphans.swift |
| questPhoneStatus |  | orphans.swift |
| questPhoneCallPhase |  | orphans.swift |
| questPhoneCallMode |  | orphans.swift |
| questPhoneCallVisuals |  | orphans.swift |
| questPhoneTalkingState |  | orphans.swift |
| ETelemetryData |  | orphans.swift |
| ENPCTelemetryData |  | orphans.swift |
| ItemComparisonState |  | orphans.swift |
| EDownedType |  | orphans.swift |
| gameEContinuousMode |  | orphans.swift |
| gameweaponReloadStatus |  | orphans.swift |
| ENcartDistricts |  | orphans.swift |
| ENcartStations |  | orphans.swift |
| EPlayerMovementDirection |  | orphans.swift |
| EAimAssistLevel |  | orphans.swift |
| ActiveBaseContext |  | orphans.swift |
| EPlaystyle |  | orphans.swift |
| EVirtualSystem |  | orphans.swift |
| EActionContext |  | orphans.swift |
| FunctionalTestsResultCode |  | orphans.swift |
| inkELayerType |  | orphans.swift |
| ECameraDirectionFunctionalTestsUtil |  | orphans.swift |
| FTNpcMountingState |  | orphans.swift |
| TestCasePhase |  | orphans.swift |
| AssertType |  | orphans.swift |
| ESmartBulletPhase |  | orphans.swift |
| Ft_TakedownType |  | orphans.swift |
| ATUIComputerTestStepMode |  | orphans.swift |
| Ft_TakedownStage |  | orphans.swift |
| FTEntityRequirementsFlag |  | orphans.swift |
| EPersonalLinkConnectionStatus |  | orphans.swift |
| PlayerChangeCameraAndLeaveVehiclePhase |  | orphans.swift |
| Ft_Result |  | orphans.swift |
| EMeleeAttackType |  | orphans.swift |
| EMoveAssistLevel |  | orphans.swift |
| EquipmentPriority |  | orphans.swift |
| EHotkey |  | orphans.swift |
| EHotkeyRequestType |  | orphans.swift |
| telemetryLevelGainReason |  | orphans.swift |
| AimAssistSettingConfig |  | orphans.swift |
| LaserTargettingState |  | orphans.swift |
| gameCityAreaType |  | orphans.swift |
| meleeMoveDirection |  | orphans.swift |
| meleeQueuedAttack |  | orphans.swift |
| EHandEquipSlot |  | orphans.swift |
| gameEPowerDifferential |  | orphans.swift |
| LadderCameraParams |  | orphans.swift |
| LandingType |  | orphans.swift |
| gameItemEquipContexts |  | orphans.swift |
| gameEquipAnimationType |  | orphans.swift |
| gameItemUnequipContexts |  | orphans.swift |
| ELastUsed |  | orphans.swift |
| EEquipmentSetType |  | orphans.swift |
| EquipmentManipulationAction |  | orphans.swift |

## Citations

- `orphans.swift`
