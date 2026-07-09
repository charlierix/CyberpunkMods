---
type: "Class System"
title: "Base Effectors"
description: "Base effector types: stat pool modifiers, status effects, shaders, quickhacks, FX, attacks, and more."
resource: "!core/gameplay/effectors/ModifyStatPoolModifierEffector.swift"
tags: ['core', 'gameplay', 'effectors']
timestamp: 2026-07-01T13:00:55Z
---

# Base Effectors

Base effector types: stat pool modifiers, status effects, shaders, quickhacks, FX, attacks, and more.

## Source Files

- `core/gameplay/effectors/ModifyStatPoolModifierEffector.swift`
- `core/gameplay/effectors/ModifyStatPoolValueEffector.swift`
- `core/gameplay/effectors/addItemsEffector.swift`
- `core/gameplay/effectors/applyEffectToDismemberedEffector.swift`
- `core/gameplay/effectors/applyEffectorEffector.swift`
- `core/gameplay/effectors/applyLightPresetEffector.swift`
- `core/gameplay/effectors/applyQuickhackEffector.swift`
- `core/gameplay/effectors/applyRandomStatusEffectEffector.swift`
- `core/gameplay/effectors/applyShaderEffector.swift`
- `core/gameplay/effectors/applyShaderOnEquipmentEffector.swift`
- `core/gameplay/effectors/applyShaderOnObjectEffector.swift`
- `core/gameplay/effectors/applyStatGroupEffector.swift`
- `core/gameplay/effectors/applyStatusEffectByChanceEffector.swift`
- `core/gameplay/effectors/applyStatusEffectEffector.swift`
- `core/gameplay/effectors/attachCapsuleVisionBlockerEffector.swift`
- `core/gameplay/effectors/broadcastStimEffector.swift`
- `core/gameplay/effectors/changeAppearanceEffector.swift`
- `core/gameplay/effectors/destroyWeakspotEffector.swift`
- `core/gameplay/effectors/disableTargetingEffector.swift`
- `core/gameplay/effectors/dismemberEffector.swift`
- `core/gameplay/effectors/encumbranceEvaluationEffector.swift`
- `core/gameplay/effectors/highlightObjectEffector.swift`
- `core/gameplay/effectors/modifyStaminaHandler.swift`
- `core/gameplay/effectors/modifyStatPoolCustomLimitEffector.swift`
- `core/gameplay/effectors/modifyStatusEffectDurationEffector.swift`
- `core/gameplay/effectors/notifyPoliceEffector.swift`
- `core/gameplay/effectors/overrideRangedAttackPackageEffector.swift`
- `core/gameplay/effectors/playBreathingAnimation.swift`
- `core/gameplay/effectors/playFXEffector.swift`
- `core/gameplay/effectors/propagateStatusEffectInAreaEffector.swift`
- `core/gameplay/effectors/quickhackEffectors.swift`
- `core/gameplay/effectors/reloadWeaponEffector.swift`
- `core/gameplay/effectors/removeAllModifiersEffector.swift`
- `core/gameplay/effectors/removeAllStatusEffectsEffector.swift`
- `core/gameplay/effectors/removeStatusEffectsEffector.swift`
- `core/gameplay/effectors/restoreStatPoolEffector.swift`
- `core/gameplay/effectors/rewardPlayerWithCrimeScoreEffector.swift`
- `core/gameplay/effectors/setTargetHealthEffector.swift`
- `core/gameplay/effectors/setTimeDilationEffector.swift`
- `core/gameplay/effectors/showUIWarningEffector.swift`
- `core/gameplay/effectors/stopAndPlayFXEffector.swift`
- `core/gameplay/effectors/stopFXEffector.swift`
- `core/gameplay/effectors/toggleMaterialOverlayEffector.swift`
- `core/gameplay/effectors/triggerAttackByRandomChanceEffector.swift`
- `core/gameplay/effectors/triggerAttackEffector.swift`
- `core/gameplay/effectors/triggerAttackOnAttackEffect.swift`
- `core/gameplay/effectors/triggerAttackOnNearbyEnemiesEffector.swift`
- `core/gameplay/effectors/triggerAttackOnOwnerEffector.swift`
- `core/gameplay/effectors/triggerAttackOnTargetEffector.swift`
- `core/gameplay/effectors/triggerContinuousAttackEffector.swift`
- `core/gameplay/effectors/uncontrolledMovementEffector.swift`
- `core/gameplay/effectors/useConsumableEffector.swift`

## Member Types

**Total declarations: 89**

### Classs (85)

| Name | Bases | Source File |
|------|-------|-------------|
| ModifyStatPoolModifierEffector | Effector | core/gameplay/effectors/ModifyStatPoolModifierEffector.swift |
| ModifyStatPoolValueEffector | HitEventEffector | core/gameplay/effectors/ModifyStatPoolValueEffector.swift |
| ModifyStatPoolValuePerHitEffector | ModifyStatPoolValueEffector | core/gameplay/effectors/ModifyStatPoolValueEffector.swift |
| AddItemsEffector | Effector | core/gameplay/effectors/addItemsEffector.swift |
| ApplyEffectToDismemberedEffector | Effector | core/gameplay/effectors/applyEffectToDismemberedEffector.swift |
| ApplyEffectorEffector | Effector | core/gameplay/effectors/applyEffectorEffector.swift |
| ApplyLightPresetEffector | Effector | core/gameplay/effectors/applyLightPresetEffector.swift |
| AbstractApplyQuickhackEffector | ModifyAttackEffector | core/gameplay/effectors/applyQuickhackEffector.swift |
| ApplyQuickhackEffector | AbstractApplyQuickhackEffector | core/gameplay/effectors/applyQuickhackEffector.swift |
| ApplyRandomStatusEffectEffector | Effector | core/gameplay/effectors/applyRandomStatusEffectEffector.swift |
| ApplyShaderEffector | Effector | core/gameplay/effectors/applyShaderEffector.swift |
| ApplyShaderOnEquipmentEffector | Effector | core/gameplay/effectors/applyShaderOnEquipmentEffector.swift |
| ApplyShaderOnObjectEffector | Effector | core/gameplay/effectors/applyShaderOnObjectEffector.swift |
| ApplyStatGroupEffectorCallback | AttachmentSlotsScriptCallback | core/gameplay/effectors/applyStatGroupEffector.swift |
| ApplyStatGroupEffector | Effector | core/gameplay/effectors/applyStatGroupEffector.swift |
| ApplyStatusEffectByChanceEffector | Effector | core/gameplay/effectors/applyStatusEffectByChanceEffector.swift |
| ApplyStatusEffectEffector | Effector | core/gameplay/effectors/applyStatusEffectEffector.swift |
| FinisherEffector | ApplyStatusEffectEffector | core/gameplay/effectors/applyStatusEffectEffector.swift |
| ApplyStatusEffectBasedOnDifficultyEffector | ApplyStatusEffectEffector | core/gameplay/effectors/applyStatusEffectEffector.swift |
| AttachCapsuleVisionBlockerEffector | Effector | core/gameplay/effectors/attachCapsuleVisionBlockerEffector.swift |
| BroadcastStimEffector | ContinuousEffector | core/gameplay/effectors/broadcastStimEffector.swift |
| ChangeAppearanceEffector | Effector | core/gameplay/effectors/changeAppearanceEffector.swift |
| DestroyWeakspotEffector | Effector | core/gameplay/effectors/destroyWeakspotEffector.swift |
| DestroyBreachEffector | Effector | core/gameplay/effectors/destroyWeakspotEffector.swift |
| DisableTargetingEffector | Effector | core/gameplay/effectors/disableTargetingEffector.swift |
| DismemberEffector | Effector | core/gameplay/effectors/dismemberEffector.swift |
| EncumbranceEvaluationEffector | Effector | core/gameplay/effectors/encumbranceEvaluationEffector.swift |
| HighlightObjectEffector | Effector | core/gameplay/effectors/highlightObjectEffector.swift |
| ModifyStaminaHandlerEffector | Effector | core/gameplay/effectors/modifyStaminaHandler.swift |
| ModifyStatPoolCustomLimitEffector | Effector | core/gameplay/effectors/modifyStatPoolCustomLimitEffector.swift |
| OnStatusEffectAppliedListener | ScriptStatusEffectListener | core/gameplay/effectors/modifyStatusEffectDurationEffector.swift |
| ModifyStatusEffectDurationEffector | Effector | core/gameplay/effectors/modifyStatusEffectDurationEffector.swift |
| ModifyStatusEffectDurationOnAttackEffector | ModifyAttackEffector | core/gameplay/effectors/modifyStatusEffectDurationEffector.swift |
| NotifyPoliceEffector | Effector | core/gameplay/effectors/notifyPoliceEffector.swift |
| OverrideRangedAttackPackageEffector | Effector | core/gameplay/effectors/overrideRangedAttackPackageEffector.swift |
| PlayBreathingAnimationEffector | Effector | core/gameplay/effectors/playBreathingAnimation.swift |
| PlayVFXEffector | Effector | core/gameplay/effectors/playFXEffector.swift |
| PlaySFXEffector | Effector | core/gameplay/effectors/playFXEffector.swift |
| PropagateStatusEffectInAreaEffector | ApplyEffectToDismemberedEffector | core/gameplay/effectors/propagateStatusEffectInAreaEffector.swift |
| ApplyObjectActionEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| WeaponMalfunctionHudEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| MadnessEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| PingSquadEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| RefreshPingEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| RefreshQhWithTagInAreaEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| SetFriendlyEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| AndroidTurnOnEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| AndroidTurnOffEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| SpreadInitEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| SpreadEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| SpreadAreaEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| EffectExecutor_Spread | EffectExecutor_Scripted | core/gameplay/effectors/quickhackEffectors.swift |
| SortOut_Contagion | EffectObjectGroupFilter_Scripted | core/gameplay/effectors/quickhackEffectors.swift |
| RevealPlayerPositionEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| ForceMoveInCombatEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| ForceMoveInCombatWhistleEffector | ForceMoveInCombatEffector | core/gameplay/effectors/quickhackEffectors.swift |
| ForceMoveInCombatCommsCallEffector | ForceMoveInCombatEffector | core/gameplay/effectors/quickhackEffectors.swift |
| ApplyLegendaryWhistleEffector | Effector | core/gameplay/effectors/quickhackEffectors.swift |
| ReloadWeaponEffector | Effector | core/gameplay/effectors/reloadWeaponEffector.swift |
| RemoveAllModifiersEffector | Effector | core/gameplay/effectors/removeAllModifiersEffector.swift |
| RemoveAllStatusEffectsEffector | Effector | core/gameplay/effectors/removeAllStatusEffectsEffector.swift |
| RemoveStatusEffectsEffector | Effector | core/gameplay/effectors/removeStatusEffectsEffector.swift |
| RemoveStatusEffectOnAttackEffector | ModifyAttackEffector | core/gameplay/effectors/removeStatusEffectsEffector.swift |
| RemoveDOTStatusEffectsEffector | Effector | core/gameplay/effectors/removeStatusEffectsEffector.swift |
| RestoreStatPoolEffector | Effector | core/gameplay/effectors/restoreStatPoolEffector.swift |
| RewardPlayerWithCrimeScoreEffector | Effector | core/gameplay/effectors/rewardPlayerWithCrimeScoreEffector.swift |
| SetTargetHealthEffector | Effector | core/gameplay/effectors/setTargetHealthEffector.swift |
| SetTimeDilationEffector | Effector | core/gameplay/effectors/setTimeDilationEffector.swift |
| ShowUIWarningEffector | Effector | core/gameplay/effectors/showUIWarningEffector.swift |
| StopAndPlayVFXEffector | Effector | core/gameplay/effectors/stopAndPlayFXEffector.swift |
| StopAndPlaySFXEffector | Effector | core/gameplay/effectors/stopAndPlayFXEffector.swift |
| StopVFXEffector | Effector | core/gameplay/effectors/stopFXEffector.swift |
| StopSFXEffector | Effector | core/gameplay/effectors/stopFXEffector.swift |
| ToggleMaterialOverlayEffector | Effector | core/gameplay/effectors/toggleMaterialOverlayEffector.swift |
| TriggerAttackByChanceStatListener | ScriptStatsListener | core/gameplay/effectors/triggerAttackByRandomChanceEffector.swift |
| TriggerAttackByChanceEffector | Effector | core/gameplay/effectors/triggerAttackByRandomChanceEffector.swift |
| SimpleTriggerAttackEffect | Effector | core/gameplay/effectors/triggerAttackEffector.swift |
| TriggerAttackOnAttackEffect | ModifyAttackEffector | core/gameplay/effectors/triggerAttackOnAttackEffect.swift |
| TriggerAttackOnNearbyEnemiesEffector | Effector | core/gameplay/effectors/triggerAttackOnNearbyEnemiesEffector.swift |
| TriggerAttackOnOwnerEffect | Effector | core/gameplay/effectors/triggerAttackOnOwnerEffector.swift |
| TriggerAttackOnTargetEffect | HitEventEffector | core/gameplay/effectors/triggerAttackOnTargetEffector.swift |
| TriggerContinuousAttackEffector | ContinuousEffector | core/gameplay/effectors/triggerContinuousAttackEffector.swift |
| UncontrolledMovementEffector | Effector | core/gameplay/effectors/uncontrolledMovementEffector.swift |
| SetRagdollComponentStateEffector | Effector | core/gameplay/effectors/uncontrolledMovementEffector.swift |
| UseConsumableEffector | Effector | core/gameplay/effectors/useConsumableEffector.swift |

### Funcs (4)

| Name | Bases | Source File |
|------|-------|-------------|
| OnItemEquipped |  | core/gameplay/effectors/applyStatGroupEffector.swift |
| OnItemUnequipped |  | core/gameplay/effectors/applyStatGroupEffector.swift |
| OnStatusEffectApplied |  | core/gameplay/effectors/modifyStatusEffectDurationEffector.swift |
| OnStatChanged |  | core/gameplay/effectors/triggerAttackByRandomChanceEffector.swift |

## Citations

- `core/gameplay/effectors/ModifyStatPoolModifierEffector.swift`
- `core/gameplay/effectors/ModifyStatPoolValueEffector.swift`
- `core/gameplay/effectors/addItemsEffector.swift`
- `core/gameplay/effectors/applyEffectToDismemberedEffector.swift`
- `core/gameplay/effectors/applyEffectorEffector.swift`
- `core/gameplay/effectors/applyLightPresetEffector.swift`
- `core/gameplay/effectors/applyQuickhackEffector.swift`
- `core/gameplay/effectors/applyRandomStatusEffectEffector.swift`
- `core/gameplay/effectors/applyShaderEffector.swift`
- `core/gameplay/effectors/applyShaderOnEquipmentEffector.swift`
- `core/gameplay/effectors/applyShaderOnObjectEffector.swift`
- `core/gameplay/effectors/applyStatGroupEffector.swift`
- `core/gameplay/effectors/applyStatusEffectByChanceEffector.swift`
- `core/gameplay/effectors/applyStatusEffectEffector.swift`
- `core/gameplay/effectors/attachCapsuleVisionBlockerEffector.swift`
- `core/gameplay/effectors/broadcastStimEffector.swift`
- `core/gameplay/effectors/changeAppearanceEffector.swift`
- `core/gameplay/effectors/destroyWeakspotEffector.swift`
- `core/gameplay/effectors/disableTargetingEffector.swift`
- `core/gameplay/effectors/dismemberEffector.swift`
- `core/gameplay/effectors/encumbranceEvaluationEffector.swift`
- `core/gameplay/effectors/highlightObjectEffector.swift`
- `core/gameplay/effectors/modifyStaminaHandler.swift`
- `core/gameplay/effectors/modifyStatPoolCustomLimitEffector.swift`
- `core/gameplay/effectors/modifyStatusEffectDurationEffector.swift`
- `core/gameplay/effectors/notifyPoliceEffector.swift`
- `core/gameplay/effectors/overrideRangedAttackPackageEffector.swift`
- `core/gameplay/effectors/playBreathingAnimation.swift`
- `core/gameplay/effectors/playFXEffector.swift`
- `core/gameplay/effectors/propagateStatusEffectInAreaEffector.swift`
- `core/gameplay/effectors/quickhackEffectors.swift`
- `core/gameplay/effectors/reloadWeaponEffector.swift`
- `core/gameplay/effectors/removeAllModifiersEffector.swift`
- `core/gameplay/effectors/removeAllStatusEffectsEffector.swift`
- `core/gameplay/effectors/removeStatusEffectsEffector.swift`
- `core/gameplay/effectors/restoreStatPoolEffector.swift`
- `core/gameplay/effectors/rewardPlayerWithCrimeScoreEffector.swift`
- `core/gameplay/effectors/setTargetHealthEffector.swift`
- `core/gameplay/effectors/setTimeDilationEffector.swift`
- `core/gameplay/effectors/showUIWarningEffector.swift`
- `core/gameplay/effectors/stopAndPlayFXEffector.swift`
- `core/gameplay/effectors/stopFXEffector.swift`
- `core/gameplay/effectors/toggleMaterialOverlayEffector.swift`
- `core/gameplay/effectors/triggerAttackByRandomChanceEffector.swift`
- `core/gameplay/effectors/triggerAttackEffector.swift`
- `core/gameplay/effectors/triggerAttackOnAttackEffect.swift`
- `core/gameplay/effectors/triggerAttackOnNearbyEnemiesEffector.swift`
- `core/gameplay/effectors/triggerAttackOnOwnerEffector.swift`
- `core/gameplay/effectors/triggerAttackOnTargetEffector.swift`
- `core/gameplay/effectors/triggerContinuousAttackEffector.swift`
- `core/gameplay/effectors/uncontrolledMovementEffector.swift`
- `core/gameplay/effectors/useConsumableEffector.swift`
