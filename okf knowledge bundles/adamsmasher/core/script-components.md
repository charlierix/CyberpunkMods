---
type: "Component System"
title: "Script Components"
description: "Scriptable components for bosses, vehicles, weapons, drones, and various gameplay entities."
resource: "!core/components/scriptComponents/adamSmasherComponent.swift"
tags: ['core', 'components', 'script-components']
timestamp: 2026-07-01T13:00:55Z
---

# Script Components

Scriptable components for bosses, vehicles, weapons, drones, and various gameplay entities.

## Source Files

- `core/components/scriptComponents/adamSmasherComponent.swift`
- `core/components/scriptComponents/appearanceRandomizer.swift`
- `core/components/scriptComponents/bossStealthComponent.swift`
- `core/components/scriptComponents/bumpComponent.swift`
- `core/components/scriptComponents/cerberusComponent.swift`
- `core/components/scriptComponents/chimeraBossComponent.swift`
- `core/components/scriptComponents/combatHUDManager.swift`
- `core/components/scriptComponents/delamainTaxiComponent.swift`
- `core/components/scriptComponents/detectorModuleComponent.swift`
- `core/components/scriptComponents/diodeControlComponent.swift`
- `core/components/scriptComponents/droneComponent.swift`
- `core/components/scriptComponents/entityAttachementComponent.swift`
- `core/components/scriptComponents/entityDeviceLink.swift`
- `core/components/scriptComponents/fastTravelComponent.swift`
- `core/components/scriptComponents/followSlotsComponent.swift`
- `core/components/scriptComponents/gameplayRoleComponent.swift`
- `core/components/scriptComponents/inspectableObjectComponent.swift`
- `core/components/scriptComponents/inspectionComponent.swift`
- `core/components/scriptComponents/kurtzBossComponent.swift`
- `core/components/scriptComponents/kurtzComponent.swift`
- `core/components/scriptComponents/minotaurMechComponent.swift`
- `core/components/scriptComponents/motorcycleComponent.swift`
- `core/components/scriptComponents/ncartMetroComponent.swift`
- `core/components/scriptComponents/odaComponent.swift`
- `core/components/scriptComponents/reactionComponent.swift`
- `core/components/scriptComponents/resourceLibraryComponent.swift`
- `core/components/scriptComponents/resourceMapperComponent.swift`
- `core/components/scriptComponents/royceComponent.swift`
- `core/components/scriptComponents/sasquatchComponent.swift`
- `core/components/scriptComponents/scannerControlComponent.swift`
- `core/components/scriptComponents/scavengeComponent.swift`
- `core/components/scriptComponents/updateComponent.swift`
- `core/components/scriptComponents/vehicleComponent.swift`
- `core/components/scriptComponents/vehicleComponentPS.swift`
- `core/components/scriptComponents/vehicleVisualCustomizationComponent.swift`
- `core/components/scriptComponents/vendorComponent.swift`
- `core/components/scriptComponents/weaponPositionComponent.swift`
- `core/components/scriptComponents/workspotMapperComponent.swift`

## Member Types

**Total declarations: 106**

### Classs (85)

| Name | Bases | Source File |
|------|-------|-------------|
| AdamSmasherHealthChangeListener | CustomValueStatPoolsListener | core/components/scriptComponents/adamSmasherComponent.swift |
| AdamSmasherComponent | ScriptableComponent | core/components/scriptComponents/adamSmasherComponent.swift |
| AppearanceRandomizerComponent | ScriptableComponent | core/components/scriptComponents/appearanceRandomizer.swift |
| BossStealthComponent | ScriptableComponent | core/components/scriptComponents/bossStealthComponent.swift |
| BumpComponent | IPlacedComponent | core/components/scriptComponents/bumpComponent.swift |
| CerberusComponent | ScriptableComponent | core/components/scriptComponents/cerberusComponent.swift |
| CerberusDetectionCombat | AIbehaviorconditionScript | core/components/scriptComponents/cerberusComponent.swift |
| CerberusDetectionOpticalCamo | AIbehaviorconditionScript | core/components/scriptComponents/cerberusComponent.swift |
| CerberusSensePresetChange | AIbehaviortaskScript | core/components/scriptComponents/cerberusComponent.swift |
| CerberusAbsoluteSensePresetChange | AIbehaviortaskScript | core/components/scriptComponents/cerberusComponent.swift |
| CerberusOpticalCamoVisibilityChange | AIbehaviortaskScript | core/components/scriptComponents/cerberusComponent.swift |
| IsCerberus | AIbehaviorconditionScript | core/components/scriptComponents/cerberusComponent.swift |
| ChimeraHealthChangeListener | CustomValueStatPoolsListener | core/components/scriptComponents/chimeraBossComponent.swift |
| ChimeraComponent | ScriptableComponent | core/components/scriptComponents/chimeraBossComponent.swift |
| EffectExecutor_GameObjectOutline | EffectExecutor_Scripted | core/components/scriptComponents/combatHUDManager.swift |
| AddTargetToHighlightEvent | Event | core/components/scriptComponents/combatHUDManager.swift |
| CombatHUDManager | ScriptableComponent | core/components/scriptComponents/combatHUDManager.swift |
| DelamainTaxiComponent | ScriptableComponent | core/components/scriptComponents/delamainTaxiComponent.swift |
| DelamainTaxiComponentPS | GameComponentPS | core/components/scriptComponents/delamainTaxiComponent.swift |
| DetectorModuleComponent | ScriptableComponent | core/components/scriptComponents/detectorModuleComponent.swift |
| DiodeControlComponent | ScriptableComponent | core/components/scriptComponents/diodeControlComponent.swift |
| DroneComponent | ScriptableComponent | core/components/scriptComponents/droneComponent.swift |
| EntityAttachementComponentPS | GameComponentPS | core/components/scriptComponents/entityAttachementComponent.swift |
| EntityAttachementComponent | ScriptableComponent | core/components/scriptComponents/entityAttachementComponent.swift |
| DeviceLinkRequest | Event | core/components/scriptComponents/entityDeviceLink.swift |
| DeviceLinkComponentPS | SharedGameplayPS | core/components/scriptComponents/entityDeviceLink.swift |
| PuppetDeviceLinkPS | DeviceLinkComponentPS | core/components/scriptComponents/entityDeviceLink.swift |
| VehicleDeviceLinkPS | DeviceLinkComponentPS | core/components/scriptComponents/entityDeviceLink.swift |
| RegisterFastTravelPointsEvent | Event | core/components/scriptComponents/fastTravelComponent.swift |
| FastTravelComponent | ScriptableComponent | core/components/scriptComponents/fastTravelComponent.swift |
| FollowSlotsComponent | ScriptableComponent | core/components/scriptComponents/followSlotsComponent.swift |
| SetGameplayRoleEvent | Event | core/components/scriptComponents/gameplayRoleComponent.swift |
| ToggleGameplayMappinVisibilityEvent | Event | core/components/scriptComponents/gameplayRoleComponent.swift |
| GameplayRoleComponent | ScriptableComponent | core/components/scriptComponents/gameplayRoleComponent.swift |
| InspectableObjectComponentPS | GameComponentPS | core/components/scriptComponents/inspectableObjectComponent.swift |
| InspectableObjectComponent | ScriptableComponent | core/components/scriptComponents/inspectableObjectComponent.swift |
| InspectionComponent | ScriptableComponent | core/components/scriptComponents/inspectionComponent.swift |
| KurtzBossComponent | ScriptableComponent | core/components/scriptComponents/kurtzBossComponent.swift |
| KurtzComponent | ScriptableComponent | core/components/scriptComponents/kurtzComponent.swift |
| MinotaurOnStatusEffectAppliedListener | ScriptStatusEffectListener | core/components/scriptComponents/minotaurMechComponent.swift |
| MinotaurMechComponent | ScriptableComponent | core/components/scriptComponents/minotaurMechComponent.swift |
| MotorcycleComponent | VehicleComponent | core/components/scriptComponents/motorcycleComponent.swift |
| NcartMetroComponent | VehicleComponent | core/components/scriptComponents/ncartMetroComponent.swift |
| OdaEmergencyListener | CustomValueStatPoolsListener | core/components/scriptComponents/odaComponent.swift |
| OdaComponent | ScriptableComponent | core/components/scriptComponents/odaComponent.swift |
| PlayerMuntedToMyVehicle | Event | core/components/scriptComponents/reactionComponent.swift |
| StimFilters | IScriptable | core/components/scriptComponents/reactionComponent.swift |
| ReactionManagerComponent | ScriptableComponent | core/components/scriptComponents/reactionComponent.swift |
| ResourceLibraryComponent | ScriptableComponent | core/components/scriptComponents/resourceLibraryComponent.swift |
| OptionalAreaEffectData | IScriptable | core/components/scriptComponents/resourceMapperComponent.swift |
| AreaEffectData | IScriptable | core/components/scriptComponents/resourceMapperComponent.swift |
| FxResourceMapperComponent | ScriptableComponent | core/components/scriptComponents/resourceMapperComponent.swift |
| RoyceComponent | ScriptableComponent | core/components/scriptComponents/royceComponent.swift |
| RoyceHealthChangeListener | CustomValueStatPoolsListener | core/components/scriptComponents/royceComponent.swift |
| SasquatchComponent | ScriptableComponent | core/components/scriptComponents/sasquatchComponent.swift |
| ScannerControlComponent | ScriptableComponent | core/components/scriptComponents/scannerControlComponent.swift |
| ScavengeComponent | ScriptableComponent | core/components/scriptComponents/scavengeComponent.swift |
| UpdateComponent | ScriptableComponent | core/components/scriptComponents/updateComponent.swift |
| VehicleComponent | ScriptableDeviceComponent | core/components/scriptComponents/vehicleComponent.swift |
| VehicleHealthStatPoolListener | CustomValueStatPoolsListener | core/components/scriptComponents/vehicleComponent.swift |
| VehicleRadioTierEvent | Event | core/components/scriptComponents/vehicleComponent.swift |
| ShouldNPCReEquipWeaponOnDismount | AIbehaviorconditionScript | core/components/scriptComponents/vehicleComponent.swift |
| VehicleComponentPS | ScriptableDeviceComponentPS | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestChangeDoorStateEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestToggleEngineEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestCrystalDomeEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestSirenEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleLightQuestToggleEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleLightQuestChangeColorEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestHornEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestDelayedHornEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestVisualDestructionEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestAVThrusterEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleRadioEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestEnableUIEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestUIEffectEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleRaceQuestEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleQuestWindowDestructionEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| VehiclePanzerBootupUIQuestEvent | Event | core/components/scriptComponents/vehicleComponentPS.swift |
| vehicleVisualCustomizationComponent | GameComponent | core/components/scriptComponents/vehicleVisualCustomizationComponent.swift |
| vehicleVisualCustomizationComponentPS | GameComponentPS | core/components/scriptComponents/vehicleVisualCustomizationComponent.swift |
| VendorComponent | ScriptableComponent | core/components/scriptComponents/vendorComponent.swift |
| WeaponPositionComponent | ScriptableComponent | core/components/scriptComponents/weaponPositionComponent.swift |
| WorkspotMapData | IScriptable | core/components/scriptComponents/workspotMapperComponent.swift |
| WorkspotMapperComponent | ScriptableComponent | core/components/scriptComponents/workspotMapperComponent.swift |

### Structs (8)

| Name | Bases | Source File |
|------|-------|-------------|
| DeviceLink |  | core/components/scriptComponents/entityDeviceLink.swift |
| GenericTemplatePersistentData |  | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleCustomMultilayer |  | core/components/scriptComponents/vehicleComponentPS.swift |
| UniqueTemplateData |  | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleVisualCustomizationTemplate |  | core/components/scriptComponents/vehicleComponentPS.swift |
| SavedVehicleVisualCustomizationTemplate |  | core/components/scriptComponents/vehicleComponentPS.swift |
| vehicleVisualModdingDefinition |  | core/components/scriptComponents/vehicleComponentPS.swift |
| VehicleUniqueTemplatePersistentData |  | core/components/scriptComponents/vehicleVisualCustomizationComponent.swift |

### Static Funcs (3)

| Name | Bases | Source File |
|------|-------|-------------|
| OperatorEqual |  | core/components/scriptComponents/entityDeviceLink.swift |
| OperatorEqual |  | core/components/scriptComponents/entityDeviceLink.swift |
| OperatorEqual |  | core/components/scriptComponents/entityDeviceLink.swift |

### Funcs (10)

| Name | Bases | Source File |
|------|-------|-------------|
| OnStatPoolValueChanged |  | core/components/scriptComponents/adamSmasherComponent.swift |
| OnStatPoolValueChanged |  | core/components/scriptComponents/adamSmasherComponent.swift |
| OnStatusEffectApplied |  | core/components/scriptComponents/minotaurMechComponent.swift |
| OnStatPoolValueChanged |  | core/components/scriptComponents/adamSmasherComponent.swift |
| OnStatPoolValueChanged |  | core/components/scriptComponents/adamSmasherComponent.swift |
| OnStatPoolValueChanged |  | core/components/scriptComponents/adamSmasherComponent.swift |
| OnActionDemolition |  | core/components/scriptComponents/vehicleComponentPS.swift |
| OnActionEngineering |  | core/components/scriptComponents/vehicleComponentPS.swift |
| OnSetExposeQuickHacks |  | core/components/scriptComponents/vehicleComponentPS.swift |
| GetActions |  | core/components/scriptComponents/vehicleComponentPS.swift |

## Citations

- `core/components/scriptComponents/adamSmasherComponent.swift`
- `core/components/scriptComponents/appearanceRandomizer.swift`
- `core/components/scriptComponents/bossStealthComponent.swift`
- `core/components/scriptComponents/bumpComponent.swift`
- `core/components/scriptComponents/cerberusComponent.swift`
- `core/components/scriptComponents/chimeraBossComponent.swift`
- `core/components/scriptComponents/combatHUDManager.swift`
- `core/components/scriptComponents/delamainTaxiComponent.swift`
- `core/components/scriptComponents/detectorModuleComponent.swift`
- `core/components/scriptComponents/diodeControlComponent.swift`
- `core/components/scriptComponents/droneComponent.swift`
- `core/components/scriptComponents/entityAttachementComponent.swift`
- `core/components/scriptComponents/entityDeviceLink.swift`
- `core/components/scriptComponents/fastTravelComponent.swift`
- `core/components/scriptComponents/followSlotsComponent.swift`
- `core/components/scriptComponents/gameplayRoleComponent.swift`
- `core/components/scriptComponents/inspectableObjectComponent.swift`
- `core/components/scriptComponents/inspectionComponent.swift`
- `core/components/scriptComponents/kurtzBossComponent.swift`
- `core/components/scriptComponents/kurtzComponent.swift`
- `core/components/scriptComponents/minotaurMechComponent.swift`
- `core/components/scriptComponents/motorcycleComponent.swift`
- `core/components/scriptComponents/ncartMetroComponent.swift`
- `core/components/scriptComponents/odaComponent.swift`
- `core/components/scriptComponents/reactionComponent.swift`
- `core/components/scriptComponents/resourceLibraryComponent.swift`
- `core/components/scriptComponents/resourceMapperComponent.swift`
- `core/components/scriptComponents/royceComponent.swift`
- `core/components/scriptComponents/sasquatchComponent.swift`
- `core/components/scriptComponents/scannerControlComponent.swift`
- `core/components/scriptComponents/scavengeComponent.swift`
- `core/components/scriptComponents/updateComponent.swift`
- `core/components/scriptComponents/vehicleComponent.swift`
- `core/components/scriptComponents/vehicleComponentPS.swift`
- `core/components/scriptComponents/vehicleVisualCustomizationComponent.swift`
- `core/components/scriptComponents/vendorComponent.swift`
- `core/components/scriptComponents/weaponPositionComponent.swift`
- `core/components/scriptComponents/workspotMapperComponent.swift`
