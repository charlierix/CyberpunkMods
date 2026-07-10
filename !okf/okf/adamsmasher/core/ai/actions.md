---
type: "AI System"
title: "AI Actions"
description: "AI action system with helpers, tasks, conditions, and sub-actions for behavior tree actions."
resource: "!core/ai/actions/aiActionHelper.swift"
tags: ['core', 'ai', 'actions']
timestamp: 2026-07-01T13:00:55Z
---

# AI Actions

AI action system with helpers, tasks, conditions, and sub-actions for behavior tree actions.

## Source Files

- `core/ai/actions/aiActionHelper.swift`
- `core/ai/actions/aiActionHelperTask.swift`
- `core/ai/actions/aiActionParams.swift`
- `core/ai/actions/tweakAIAction.swift`
- `core/ai/actions/tweakAIActionCondition.swift`
- `core/ai/actions/tweakAIActionTasks.swift`
- `core/ai/actions/tweakAIConditionChecks.swift`
- `core/ai/actions/tweakAISubActions.swift`

## Member Types

**Total declarations: 120**

### Classs (108)

| Name | Bases | Source File |
|------|-------|-------------|
| AIActionHelper | IScriptable | core/ai/actions/aiActionHelper.swift |
| AIActionChecks | IScriptable | core/ai/actions/aiActionHelper.swift |
| AIActionHelperTask | AIbehaviortaskScript | core/ai/actions/aiActionHelperTask.swift |
| DestroyWeakspot | AIActionHelperTask | core/ai/actions/aiActionHelperTask.swift |
| SetAppearance | AIActionHelperTask | core/ai/actions/aiActionHelperTask.swift |
| MonitorMeleeCombo | AIActionHelperTask | core/ai/actions/aiActionHelperTask.swift |
| SetDestinationWaypoint | AIActionHelperTask | core/ai/actions/aiActionHelperTask.swift |
| KillEntity | AIActionHelperTask | core/ai/actions/aiActionHelperTask.swift |
| SetPhaseState | AIActionHelperTask | core/ai/actions/aiActionHelperTask.swift |
| CheckPhaseState | AIbehaviorconditionScript | core/ai/actions/aiActionHelperTask.swift |
| CheckPathToCombatTarget | AIbehaviorconditionScript | core/ai/actions/aiActionHelperTask.swift |
| CheckFloatIsValid | AIbehaviorconditionScript | core/ai/actions/aiActionHelperTask.swift |
| CheckBoolisValid | AIbehaviorconditionScript | core/ai/actions/aiActionHelperTask.swift |
| CheckVectorIsValid | AIbehaviorconditionScript | core/ai/actions/aiActionHelperTask.swift |
| CheckGameDifficulty | AIbehaviorconditionScript | core/ai/actions/aiActionHelperTask.swift |
| AIActionParams | IScriptable | core/ai/actions/aiActionParams.swift |
| TweakAIActionAbstract | AIbehaviortaskScript | core/ai/actions/tweakAIAction.swift |
| TweakAIActionConditionAbstract | AIbehaviorconditionScript | core/ai/actions/tweakAIActionCondition.swift |
| TweakAIActionRecord | IScriptable | core/ai/actions/tweakAIActionTasks.swift |
| TweakAIAction | TweakAIActionAbstract | core/ai/actions/tweakAIActionTasks.swift |
| TweakAIActionCondition | TweakAIActionConditionAbstract | core/ai/actions/tweakAIActionTasks.swift |
| TweakAIActionSelector | TweakAIActionAbstract | core/ai/actions/tweakAIActionTasks.swift |
| TweakAIActionSequence | TweakAIActionAbstract | core/ai/actions/tweakAIActionTasks.swift |
| TweakAIActionSmartComposite | TweakAIActionAbstract | core/ai/actions/tweakAIActionTasks.swift |
| IdleActionsCondition | AIbehaviorconditionScript | core/ai/actions/tweakAIActionTasks.swift |
| IdleActions | TweakAIActionSmartComposite | core/ai/actions/tweakAIActionTasks.swift |
| PatrolAction | TweakAIActionSmartComposite | core/ai/actions/tweakAIActionTasks.swift |
| PatrolSpotAction | TweakAIActionSmartComposite | core/ai/actions/tweakAIActionTasks.swift |
| AICondition | IScriptable | core/ai/actions/tweakAIConditionChecks.swift |
| TweakAISubAction | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionPlayVoiceOver_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionDisableCollider_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionAddFact_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionQueueAIEvent_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionQueueCommunicationEvent_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSpawnFX_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionPlaySound_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetEquipWeaponsUtils | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetEquipPrimaryWeapons_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetEquipSecondaryWeapons_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionEquipOnSlot_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionEquipOnBody_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionForceEquip_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetUnequipWeaponsUtils | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetUnequipPrimaryWeapons_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetUnequipSecondaryWeapons_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionUnequipOnSlot_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionForceUnequip_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionDisableAimAssist_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionApplyTimeDilation_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionModifyStatPool_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionForceDeath_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionStatusEffect_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionGameplayLogicPackage_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetInt_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionReloadWeapon_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionTriggerStim_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionChangeAttitude_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionThrowItem_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionTriggerItemActivation_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionAttackWithWeapon_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionRegisterActionName_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionMeleeAttackManager_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionShootToPoint_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionMissileRainGrid_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionMissileRainCircular_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionChimeraMetalstorm_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionShootFromCar_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionShootWithWeapon_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionCreateGameEffect_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionInAir_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetTargetByTag_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetWaypointByTag_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetInfluenceMap_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetStimSource_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionWorkspot_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionChangeCoverSelectionPreset_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionStartCooldown_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSquadSync_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSecuritySystemNotification_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionCallSquadSearchBackUp_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionQuickHack_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionForceHitReaction_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionActivateStrongArmsFX_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionMountVehicle_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionUseSensePreset_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionConditionalFailure_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionCompleteCommand_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionLeaveCover_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionCustomEffectors_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionActivateLightPreset_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionFailIfFriendlyFire_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionUpdateFriendlyFireParams_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSendSignal_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionFastExitWorkspot_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionMeleeAttackAttemptEvent_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetWorldPosition_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionCover_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionHitData_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionBlockData_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionFail_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionInitialReactionParams_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionRandomize_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionCallReinforcements_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionGeneratePointOfInterestTarget_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionDroneModifyAltitude_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionSetTopThreatPersistance_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |
| AISubActionScaleDurationWithDistance_Record_Implementation | IScriptable | core/ai/actions/tweakAISubActions.swift |

### Funcs (12)

| Name | Bases | Source File |
|------|-------|-------------|
| GetDescription |  | core/ai/actions/tweakAIAction.swift |
| GetDescription |  | core/ai/actions/tweakAIAction.swift |
| GetDescription |  | core/ai/actions/tweakAIAction.swift |
| GetDescription |  | core/ai/actions/tweakAIAction.swift |
| GetSmartCompositeRecord |  | core/ai/actions/tweakAIActionTasks.swift |
| GetFriendlyName |  | core/ai/actions/tweakAIActionTasks.swift |
| GetSmartCompositeRecord |  | core/ai/actions/tweakAIActionTasks.swift |
| GetFriendlyName |  | core/ai/actions/tweakAIActionTasks.swift |
| GetSmartCompositeRecord |  | core/ai/actions/tweakAIActionTasks.swift |
| GetFriendlyName |  | core/ai/actions/tweakAIActionTasks.swift |
| GetSmartCompositeRecord |  | core/ai/actions/tweakAIActionTasks.swift |
| GetFriendlyName |  | core/ai/actions/tweakAIActionTasks.swift |

## Citations

- `core/ai/actions/aiActionHelper.swift`
- `core/ai/actions/aiActionHelperTask.swift`
- `core/ai/actions/aiActionParams.swift`
- `core/ai/actions/tweakAIAction.swift`
- `core/ai/actions/tweakAIActionCondition.swift`
- `core/ai/actions/tweakAIActionTasks.swift`
- `core/ai/actions/tweakAIConditionChecks.swift`
- `core/ai/actions/tweakAISubActions.swift`
