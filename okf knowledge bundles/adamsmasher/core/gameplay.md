---
type: "Game System"
title: "Gameplay Framework"
description: "Core gameplay framework: caption parts, conditions, delay system, device actions, effectors, prereqs, and vehicle gameplay."
resource: "!core/gameplay/captionParts.swift"
tags: ['core', 'gameplay']
timestamp: 2026-07-01T13:00:55Z
---

# Gameplay Framework

Core gameplay framework: caption parts, conditions, delay system, device actions, effectors, prereqs, and vehicle gameplay.

## Source Files

- `core/gameplay/captionParts.swift`
- `core/gameplay/delaySystem.swift`
- `core/gameplay/deviceActionProperty.swift`
- `core/gameplay/durationModifiers.swift`
- `core/gameplay/effector.swift`
- `core/gameplay/gameplayEffects.swift`
- `core/gameplay/pocketRadio.swift`
- `core/gameplay/prereqs.swift`
- `core/gameplay/psmImports.swift`
- `core/gameplay/puppet.swift`
- `core/gameplay/quickHackableHelper.swift`
- `core/gameplay/quickHackableQueueHelper.swift`
- `core/gameplay/scriptCaptionParts.swift`
- `core/gameplay/targetingSearchFilter.swift`
- `core/gameplay/vehiclePoliceStrategy.swift`
- `core/gameplay/vehicles.swift`
- `core/gameplay/weakspot.swift`

## Member Types

**Total declarations: 116**

### Classs (94)

| Name | Bases | Source File |
|------|-------|-------------|
| InteractionChoiceCaptionScriptPart | InteractionChoiceCaptionPart | core/gameplay/captionParts.swift |
| DelayCallback | IScriptable | core/gameplay/delaySystem.swift |
| DeviceActionPropertyFunctions | IScriptable | core/gameplay/deviceActionProperty.swift |
| MuteArmDurationModifier | EffectDurationModifier_Scripted | core/gameplay/durationModifiers.swift |
| Effector | IScriptable | core/gameplay/effector.swift |
| ContinuousEffector | Effector | core/gameplay/effector.swift |
| TestEffector | Effector | core/gameplay/effector.swift |
| StatPoolEffector | Effector | core/gameplay/effector.swift |
| SenseSwitchEffector | Effector | core/gameplay/effector.swift |
| SpawnSubCharacterEffector | Effector | core/gameplay/effector.swift |
| DOTContinuousEffector | ContinuousEffector | core/gameplay/effector.swift |
| ForceDismembermentEffector | Effector | core/gameplay/effector.swift |
| EffectDataHelper | IScriptable | core/gameplay/gameplayEffects.swift |
| PocketRadioQuestContentLockListener | ScriptQuestContentLockListener | core/gameplay/pocketRadio.swift |
| PocketRadio | IScriptable | core/gameplay/pocketRadio.swift |
| IScriptablePrereq | IPrereq | core/gameplay/prereqs.swift |
| DevelopmentCheckPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| SkillCheckPrereqState | PrereqState | core/gameplay/prereqs.swift |
| SkillCheckPrereq | DevelopmentCheckPrereq | core/gameplay/prereqs.swift |
| StatCheckPrereqState | PrereqState | core/gameplay/prereqs.swift |
| StatCheckPrereq | DevelopmentCheckPrereq | core/gameplay/prereqs.swift |
| NPCRevealedPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| RevealAccessPointPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| NPCDeadPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| NPCIncapacitatedPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| NPCGrappledByPlayerPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| SinglePlayerPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| NPCNotMountedToVehiclePrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| NPCIsHumanoidPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| PuppetNotBossPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| NotReplacerPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| NotJohnnyReplacerPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| NotVRReplacerPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| PlayerDeadPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| PuppetIncapacitatedPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| PlayerNotCarryingPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| PlayerNotGrapplingPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| DisableAllWorldInteractionsNotEnabledPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| DisableAllVehicleInteractionsNotEnabledPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| PlayerHasTakedownWeaponEquippedPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| PlayerHasMantisBladesEquippedPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| IsNpcMountedInSlotPrereqState | PrereqState | core/gameplay/prereqs.swift |
| IsNpcMountedInSlotPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| IsMountedByPreventionNPCPrereqState | PrereqState | core/gameplay/prereqs.swift |
| IsMountedByPreventionNPCPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| CanPlayerHijackMountedNpcPrereqState | PrereqState | core/gameplay/prereqs.swift |
| CanPlayerHijackMountedNpcPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| IsNpcPlayingMountingAnimationPrereqState | PrereqState | core/gameplay/prereqs.swift |
| IsNpcPlayingMountingAnimationPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| IsVehicleDoorLockedState | PrereqState | core/gameplay/prereqs.swift |
| IsVehicleDoorLocked | IScriptablePrereq | core/gameplay/prereqs.swift |
| IsVehicleDoorQuestLockedState | PrereqState | core/gameplay/prereqs.swift |
| IsVehicleDoorQuestLocked | IScriptablePrereq | core/gameplay/prereqs.swift |
| PlayerHasNanoWiresEquippedPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| IsMultiplayerGamePrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| PlayerHasCPOMissionDataPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| SelectedForMultiplayerChoiceDialog | IScriptablePrereq | core/gameplay/prereqs.swift |
| PlayerCanTakeCPOMissionDataPrereq | InteractionScriptedCondition | core/gameplay/prereqs.swift |
| PlayerCanGiveCPOMissionDataPrereq | InteractionScriptedCondition | core/gameplay/prereqs.swift |
| AccessPointHasCPOMissionDataPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| AccessPointIsBlocked | IScriptablePrereq | core/gameplay/prereqs.swift |
| IsScannerTarget | IScriptablePrereq | core/gameplay/prereqs.swift |
| AccessPointCompatibleWithUser | InteractionScriptedCondition | core/gameplay/prereqs.swift |
| PlayerControlsDevicePrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| PlayerNotInBraindancePrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| CPOMissionPlayerVoted | InteractionScriptedCondition | core/gameplay/prereqs.swift |
| CPOMissionPlayerNotVoted | CPOMissionPlayerVoted | core/gameplay/prereqs.swift |
| PuppetMortalityListener | ScriptStatsListener | core/gameplay/prereqs.swift |
| PuppetMortalPrereqState | PrereqState | core/gameplay/prereqs.swift |
| PuppetMortalPrereq | IScriptablePrereq | core/gameplay/prereqs.swift |
| MountEventData | IScriptable | core/gameplay/psmImports.swift |
| gamePuppetBase | TimeDilatable | core/gameplay/puppet.swift |
| QuickHackableHelper | IScriptable | core/gameplay/quickHackableHelper.swift |
| OnMonowireQuickhackContagiousTargetStatusAppliedCallback | DelayCallback | core/gameplay/quickHackableHelper.swift |
| OnMonowireWindowToSpreadQuickhackCallback | DelayCallback | core/gameplay/quickHackableHelper.swift |
| QuickHackableQueueHelper | IScriptable | core/gameplay/quickHackableQueueHelper.swift |
| DeviceActionQueue | IScriptable | core/gameplay/quickHackableQueueHelper.swift |
| InteractionChoiceCaptionQuickhackCostPart | InteractionChoiceCaptionScriptPart | core/gameplay/scriptCaptionParts.swift |
| BaseStrategyRequest | IScriptable | core/gameplay/vehiclePoliceStrategy.swift |
| DriveTowardsPlayerStrategyRequest | BaseStrategyRequest | core/gameplay/vehiclePoliceStrategy.swift |
| DriveAwayFromPlayerStrategyRequest | BaseStrategyRequest | core/gameplay/vehiclePoliceStrategy.swift |
| PatrolNearbyStrategyRequest | BaseStrategyRequest | core/gameplay/vehiclePoliceStrategy.swift |
| InterceptAtNextIntersectionStrategyRequest | BaseStrategyRequest | core/gameplay/vehiclePoliceStrategy.swift |
| GetToPlayerFromAnywhereStrategyRequest | BaseStrategyRequest | core/gameplay/vehiclePoliceStrategy.swift |
| InitialSearchStrategyRequest | BaseStrategyRequest | core/gameplay/vehiclePoliceStrategy.swift |
| SearchFromAnywhereStrategyRequest | BaseStrategyRequest | core/gameplay/vehiclePoliceStrategy.swift |
| VehicleObject | GameObject | core/gameplay/vehicles.swift |
| AVObject | VehicleObject | core/gameplay/vehicles.swift |
| ncartMetroObject | AVObject | core/gameplay/vehicles.swift |
| vehicleForceBrakesCallbackListener | IScriptable | core/gameplay/vehicles.swift |
| WeakspotOnDestroyEffector | Effector | core/gameplay/weakspot.swift |
| WeakspotObject | GameObject | core/gameplay/weakspot.swift |
| WeakspotHealthChangeListener | CustomValueStatPoolsListener | core/gameplay/weakspot.swift |
| ScriptedWeakspotObject | WeakspotObject | core/gameplay/weakspot.swift |

### Static Funcs (10)

| Name | Bases | Source File |
|------|-------|-------------|
| GetCaptionTagsFromArray |  | core/gameplay/captionParts.swift |
| GetInvalidDelayID |  | core/gameplay/delaySystem.swift |
| PocketRadioRestrictionCount |  | core/gameplay/pocketRadio.swift |
| TSF_NPC |  | core/gameplay/targetingSearchFilter.swift |
| TSF_EnemyNPC |  | core/gameplay/targetingSearchFilter.swift |
| TSF_Quickhackable |  | core/gameplay/targetingSearchFilter.swift |
| TSQ_ALL |  | core/gameplay/targetingSearchFilter.swift |
| TSQ_NPC |  | core/gameplay/targetingSearchFilter.swift |
| TSQ_EnemyNPC |  | core/gameplay/targetingSearchFilter.swift |
| GetMountedVehicle |  | core/gameplay/vehicles.swift |

### Funcs (12)

| Name | Bases | Source File |
|------|-------|-------------|
| Call |  | core/gameplay/delaySystem.swift |
| OnGodModeChanged |  | core/gameplay/prereqs.swift |
| Call |  | core/gameplay/delaySystem.swift |
| Call |  | core/gameplay/delaySystem.swift |
| ReactToHitProcess |  | core/gameplay/vehicles.swift |
| SetCurrentlyUploadingAction |  | core/gameplay/vehicles.swift |
| GetCurrentlyUploadingAction |  | core/gameplay/vehicles.swift |
| IsInternal |  | core/gameplay/weakspot.swift |
| IsInvulnerable |  | core/gameplay/weakspot.swift |
| OnStatPoolValueChanged |  | core/gameplay/weakspot.swift |
| IsInternal |  | core/gameplay/weakspot.swift |
| IsInvulnerable |  | core/gameplay/weakspot.swift |

## Citations

- `core/gameplay/captionParts.swift`
- `core/gameplay/delaySystem.swift`
- `core/gameplay/deviceActionProperty.swift`
- `core/gameplay/durationModifiers.swift`
- `core/gameplay/effector.swift`
- `core/gameplay/gameplayEffects.swift`
- `core/gameplay/pocketRadio.swift`
- `core/gameplay/prereqs.swift`
- `core/gameplay/psmImports.swift`
- `core/gameplay/puppet.swift`
- `core/gameplay/quickHackableHelper.swift`
- `core/gameplay/quickHackableQueueHelper.swift`
- `core/gameplay/scriptCaptionParts.swift`
- `core/gameplay/targetingSearchFilter.swift`
- `core/gameplay/vehiclePoliceStrategy.swift`
- `core/gameplay/vehicles.swift`
- `core/gameplay/weakspot.swift`
