---
type: "AI System"
title: "AI Conditions"
description: "AI behavior conditions: reaction conditions (aggressive, death), animations loaded, autonomous, check arguments, free workspot, last hit, NPC state, quest fact, threat, compare arguments, debug, event/signal, item handling, simple combat, simple, slot animation, stack signal, status effect, stim reaction, and time."
resource: "!cyberpunk/ai/Conditions/ReactionConditions/aiAggressiveReactionPresetCondition.swift"
tags: ['cyberpunk', 'ai', 'conditions']
timestamp: 2026-07-01T13:00:55Z
---

# AI Conditions

AI behavior conditions: reaction conditions (aggressive, death), animations loaded, autonomous, check arguments, free workspot, last hit, NPC state, quest fact, threat, compare arguments, debug, event/signal, item handling, simple combat, simple, slot animation, stack signal, status effect, stim reaction, and time.

## Source Files

- `cyberpunk/ai/Conditions/ReactionConditions/aiAggressiveReactionPresetCondition.swift`
- `cyberpunk/ai/Conditions/ReactionConditions/aiDeathCondition.swift`
- `cyberpunk/ai/Conditions/aiAnimationsLoadedCondition.swift`
- `cyberpunk/ai/Conditions/aiAutonomousConditions.swift`
- `cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift`
- `cyberpunk/ai/Conditions/aiCheckFreeWorkspot.swift`
- `cyberpunk/ai/Conditions/aiCheckLastHitCondition.swift`
- `cyberpunk/ai/Conditions/aiCheckNPCState.swift`
- `cyberpunk/ai/Conditions/aiCheckQuestFact.swift`
- `cyberpunk/ai/Conditions/aiCheckThreat.swift`
- `cyberpunk/ai/Conditions/aiCompareBehaviorArguments.swift`
- `cyberpunk/ai/Conditions/aiDebugConditions.swift`
- `cyberpunk/ai/Conditions/aiEventConditions.swift`
- `cyberpunk/ai/Conditions/aiItemHandlingConditions.swift`
- `cyberpunk/ai/Conditions/aiSimpleCombatConditions.swift`
- `cyberpunk/ai/Conditions/aiSimpleConditions.swift`
- `cyberpunk/ai/Conditions/aiSlotAnimationInProgress.swift`
- `cyberpunk/ai/Conditions/aiStackSignalConditions.swift`
- `cyberpunk/ai/Conditions/aiStatusEffectCondition.swift`
- `cyberpunk/ai/Conditions/aiStimReactionCondition.swift`
- `cyberpunk/ai/Conditions/aiTimeConditions.swift`

## Member Types

**Total declarations: 154**

### Classs (148)

| Name | Bases | Source File |
|------|-------|-------------|
| AIAggressiveReactionPresetCondition | AIbehaviorconditionScript | cyberpunk/ai/Conditions/ReactionConditions/aiAggressiveReactionPresetCondition.swift |
| GlobalDeathCondition | AIDeathConditions | cyberpunk/ai/Conditions/ReactionConditions/aiDeathCondition.swift |
| PassiveGlobalDeathCondition | AIbehaviorexpressionScript | cyberpunk/ai/Conditions/ReactionConditions/aiDeathCondition.swift |
| DeathWithoutRagdollCondition | AIDeathConditions | cyberpunk/ai/Conditions/ReactionConditions/aiDeathCondition.swift |
| DeathWithoutAnimationCondition | AIDeathConditions | cyberpunk/ai/Conditions/ReactionConditions/aiDeathCondition.swift |
| AnimationsLoadedCondition | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiAnimationsLoadedCondition.swift |
| AnimationsLoadedTask | AIbehaviortaskScript | cyberpunk/ai/Conditions/aiAnimationsLoadedCondition.swift |
| AIAutonomousConditions | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| NoWeaponCombatConditions | AIAutonomousConditions | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| CombatConditions | AIAutonomousConditions | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| AlertedConditions | AIAutonomousConditions | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| CrowdCombatConditions | AIAutonomousConditions | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| PassiveNoWeaponCombatConditions | PassiveAutonomousCondition | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| PassiveCrowdCombatConditions | PassiveAutonomousCondition | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| PassiveCombatConditions | PassiveAutonomousCondition | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| PassiveAlertedConditions | PassiveAutonomousCondition | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| PassiveRoleCondition | AIbehaviorexpressionScript | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| PassiveCommandCondition | AIbehaviorexpressionScript | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| PassivePatrolConditions | PassiveAutonomousCondition | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| PassiveCoverSelectionConditions | PassiveAutonomousCondition | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| AIStatListener | ScriptStatsListener | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| IsConnectedToSecuritySystem | AIAutonomousConditions | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| IsReprimandOngoing | AIAutonomousConditions | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| IsTargetObjectPlayer | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| IsBoss | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| IsAggressive | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| PassiveCannotMoveConditions | PassiveAutonomousCondition | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| CheckArguments | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift |
| CheckArgumentBoolean | CheckArguments | cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift |
| CheckArgumentInt | CheckArguments | cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift |
| CheckElapsedTimeFromArgumentFloat | CheckArguments | cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift |
| CheckArgumentFloat | CheckArguments | cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift |
| CheckArgumentName | CheckArguments | cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift |
| CheckArgumentObjectSet | CheckArguments | cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift |
| CheckFreeWorkspot | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiCheckFreeWorkspot.swift |
| CheckLastHitReaction | HitConditions | cyberpunk/ai/Conditions/aiCheckLastHitCondition.swift |
| CheckCurrentHitReaction | HitConditions | cyberpunk/ai/Conditions/aiCheckLastHitCondition.swift |
| CheckHitReactionStimID | CheckStimID | cyberpunk/ai/Conditions/aiCheckLastHitCondition.swift |
| AINPCHighLevelStateCheck | AINPCStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| AINPCPreviousHighLevelStateCheck | AINPCStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| IsDead | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| IsRagdolling | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| CheckHighLevelState | AINPCHighLevelStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InRelaxedHighLevelState | AINPCHighLevelStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InAlertedHighLevelState | AINPCHighLevelStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InCombatHighLevelState | AINPCHighLevelStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InStealthHighLevelState | AINPCHighLevelStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InUnconsciousHighLevelState | AINPCHighLevelStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InDeadHighLevelState | AINPCHighLevelStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| CheckPreviousHighLevelState | AINPCPreviousHighLevelStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| AINPCUpperBodyStateCheck | AINPCStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| CheckUpperBodyState | AINPCUpperBodyStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InNormalUpperBodyState | AINPCUpperBodyStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InShootUpperBodyState | AINPCUpperBodyStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InReloadUpperBodyState | AINPCUpperBodyStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InDefendUpperBodyState | AINPCUpperBodyStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InAttackUpperBodyState | AINPCUpperBodyStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InParryUpperBodyState | AINPCUpperBodyStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InTauntUpperBodyState | AINPCUpperBodyStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| AINPCStanceStateCheck | AINPCStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| CheckStanceState | AINPCStanceStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InStandStanceState | AINPCStanceStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InCrouchStanceState | AINPCStanceStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InCoverStanceState | AINPCStanceStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| InSwimStanceState | AINPCStanceStateCheck | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| IsCrowdNPC | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| IsAggressiveCrowd | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| WasNPCForcedToJoinCrowd | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiCheckNPCState.swift |
| CheckQuestFact | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiCheckQuestFact.swift |
| CheckThreat | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiCheckThreat.swift |
| CheckDroppedThreat | CheckThreat | cyberpunk/ai/Conditions/aiCheckThreat.swift |
| CompareArgumentsBooleans | CompareArguments | cyberpunk/ai/Conditions/aiCompareBehaviorArguments.swift |
| CompareArgumentsInts | CompareArguments | cyberpunk/ai/Conditions/aiCompareBehaviorArguments.swift |
| CompareArgumentsFloats | CompareArguments | cyberpunk/ai/Conditions/aiCompareBehaviorArguments.swift |
| CompareArgumentsNames | CompareArguments | cyberpunk/ai/Conditions/aiCompareBehaviorArguments.swift |
| CompareArgumentsVectors | CompareArguments | cyberpunk/ai/Conditions/aiCompareBehaviorArguments.swift |
| CompareArgumentsObjects | CompareArguments | cyberpunk/ai/Conditions/aiCompareBehaviorArguments.swift |
| CompareArgumentsNodeRefs | CompareArguments | cyberpunk/ai/Conditions/aiCompareBehaviorArguments.swift |
| CheckIfCombatAllowed | AIDebugConditions | cyberpunk/ai/Conditions/aiDebugConditions.swift |
| CheckIfSearchAllowed | AIDebugConditions | cyberpunk/ai/Conditions/aiDebugConditions.swift |
| CheckIfPatrolAllowed | AIDebugConditions | cyberpunk/ai/Conditions/aiDebugConditions.swift |
| Debug_CheckIfShouldReturnToSpawn | AIDebugConditions | cyberpunk/ai/Conditions/aiDebugConditions.swift |
| Debug_LookatTestEnabled | AIDebugConditions | cyberpunk/ai/Conditions/aiDebugConditions.swift |
| Debug_AimingLookatTestEnabled | AIDebugConditions | cyberpunk/ai/Conditions/aiDebugConditions.swift |
| Debug_RotationTestEnabled | AIDebugConditions | cyberpunk/ai/Conditions/aiDebugConditions.swift |
| AISignalCondition | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiEventConditions.swift |
| CustomEventCondition | AISignalCondition | cyberpunk/ai/Conditions/aiEventConditions.swift |
| PriorityCheckEventCondition | AISignalCondition | cyberpunk/ai/Conditions/aiEventConditions.swift |
| HighestPrioritySignalCondition | AIbehaviorexpressionScript | cyberpunk/ai/Conditions/aiEventConditions.swift |
| CheckAbilityCanRetreat | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiEventConditions.swift |
| CheckUnregisteredWeapon | AIItemHandlingCondition | cyberpunk/ai/Conditions/aiItemHandlingConditions.swift |
| CheckEquippedWeapon | AIItemHandlingCondition | cyberpunk/ai/Conditions/aiItemHandlingConditions.swift |
| CheckEquippedWeaponType | AIItemHandlingCondition | cyberpunk/ai/Conditions/aiItemHandlingConditions.swift |
| SimpleCombatConditon | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiSimpleCombatConditions.swift |
| SimpleCoverBehaviorCondition | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiSimpleConditions.swift |
| SimpleCanUseAvoidLOSMovement | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiSimpleConditions.swift |
| SimpleCanUseCover | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiSimpleConditions.swift |
| SimpleCanSwapWeapons | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiSimpleConditions.swift |
| SimpleSandevistanHarassCondition | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiSimpleConditions.swift |
| SimpleSandevistanDashShootCondition | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiSimpleConditions.swift |
| SimpleSprintHarassCondition | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiSimpleConditions.swift |
| SimpleSetUnequipWeapons | AIbehaviortaskScript | cyberpunk/ai/Conditions/aiSimpleConditions.swift |
| SimpleSetEquipWeapons | AIbehaviortaskScript | cyberpunk/ai/Conditions/aiSimpleConditions.swift |
| SimpleShouldEvadeCondition | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiSimpleConditions.swift |
| SlotAnimationInProgress | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiSlotAnimationInProgress.swift |
| AIStackSignalCondition | AIbehaviorStackScriptPassiveExpressionDefinition | cyberpunk/ai/Conditions/aiStackSignalConditions.swift |
| AIGateSignalSender | AIbehaviortaskStackScript | cyberpunk/ai/Conditions/aiStackSignalConditions.swift |
| AIStatusEffectCondition | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStatusEffectCondition.swift |
| CheckCurrentStatusEffect | AIStatusEffectCondition | cyberpunk/ai/Conditions/aiStatusEffectCondition.swift |
| CheckStatusEffect | AIStatusEffectCondition | cyberpunk/ai/Conditions/aiStatusEffectCondition.swift |
| CheckAllStatusEffect | AIStatusEffectCondition | cyberpunk/ai/Conditions/aiStatusEffectCondition.swift |
| CheckStatusEffectState | AIStatusEffectCondition | cyberpunk/ai/Conditions/aiStatusEffectCondition.swift |
| CheckWoundedStatusEffectState | AIStatusEffectCondition | cyberpunk/ai/Conditions/aiStatusEffectCondition.swift |
| CheckCurrentWoundedState | AIStatusEffectCondition | cyberpunk/ai/Conditions/aiStatusEffectCondition.swift |
| CheckReaction | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| CheckReactionValueThreshold | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| InvestigateController | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| CheckReactionStimType | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| CheckStimTag | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| PlayInitFearAnimation | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| PlayStartupLocoFearAnimation | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| IsWorkspotReaction | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| IsValidCombatTarget | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| IsPlayerAKiller | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| CheckStimRevealsInstigatorPosition | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| CheckLastTriggeredStimuli | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| CheckAnimSetTags | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| HasPositionFarFromThreat | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| CanNPCRun | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| ShouldNPCContinueInAlerted | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| IsInTrafficLane | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| IsBlockedInTraffic | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| PreviousFearPhaseCheck | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| HearStimThreshold | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| StealthStimThreshold | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| CanDoReactionAction | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| CheckTimestamp | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| EscalateProvoke | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| ReactAfterDodge | AIbehaviorconditionScript | cyberpunk/ai/Conditions/aiStimReactionCondition.swift |
| AITimeoutCondition | AITimeCondition | cyberpunk/ai/Conditions/aiTimeConditions.swift |
| SelectorTimeout | AITimeoutCondition | cyberpunk/ai/Conditions/aiTimeConditions.swift |
| MappingTimeout | AITimeoutCondition | cyberpunk/ai/Conditions/aiTimeConditions.swift |
| CustomValueTimeout | AITimeoutCondition | cyberpunk/ai/Conditions/aiTimeConditions.swift |
| CustomValueFromMappingTimeout | AITimeoutCondition | cyberpunk/ai/Conditions/aiTimeConditions.swift |
| CharParamTimeout | AITimeoutCondition | cyberpunk/ai/Conditions/aiTimeConditions.swift |
| AICooldown | AITimeCondition | cyberpunk/ai/Conditions/aiTimeConditions.swift |
| CooldownOnActivation | AICooldown | cyberpunk/ai/Conditions/aiTimeConditions.swift |
| CooldownOnDeactivation | AICooldown | cyberpunk/ai/Conditions/aiTimeConditions.swift |

### Funcs (6)

| Name | Bases | Source File |
|------|-------|-------------|
| OnStatChanged |  | cyberpunk/ai/Conditions/aiAutonomousConditions.swift |
| GetDescription |  | cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift |
| GetEditorSubCaption |  | cyberpunk/ai/Conditions/aiEventConditions.swift |
| GetDescription |  | cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift |
| GetInstanceTypeName |  | cyberpunk/ai/Conditions/aiStackSignalConditions.swift |
| GetSignalLifeTime |  | cyberpunk/ai/Conditions/aiStackSignalConditions.swift |

## Citations

- `cyberpunk/ai/Conditions/ReactionConditions/aiAggressiveReactionPresetCondition.swift`
- `cyberpunk/ai/Conditions/ReactionConditions/aiDeathCondition.swift`
- `cyberpunk/ai/Conditions/aiAnimationsLoadedCondition.swift`
- `cyberpunk/ai/Conditions/aiAutonomousConditions.swift`
- `cyberpunk/ai/Conditions/aiCheckBehaviorArguments.swift`
- `cyberpunk/ai/Conditions/aiCheckFreeWorkspot.swift`
- `cyberpunk/ai/Conditions/aiCheckLastHitCondition.swift`
- `cyberpunk/ai/Conditions/aiCheckNPCState.swift`
- `cyberpunk/ai/Conditions/aiCheckQuestFact.swift`
- `cyberpunk/ai/Conditions/aiCheckThreat.swift`
- `cyberpunk/ai/Conditions/aiCompareBehaviorArguments.swift`
- `cyberpunk/ai/Conditions/aiDebugConditions.swift`
- `cyberpunk/ai/Conditions/aiEventConditions.swift`
- `cyberpunk/ai/Conditions/aiItemHandlingConditions.swift`
- `cyberpunk/ai/Conditions/aiSimpleCombatConditions.swift`
- `cyberpunk/ai/Conditions/aiSimpleConditions.swift`
- `cyberpunk/ai/Conditions/aiSlotAnimationInProgress.swift`
- `cyberpunk/ai/Conditions/aiStackSignalConditions.swift`
- `cyberpunk/ai/Conditions/aiStatusEffectCondition.swift`
- `cyberpunk/ai/Conditions/aiStimReactionCondition.swift`
- `cyberpunk/ai/Conditions/aiTimeConditions.swift`
