---
type: "AI System"
title: "AI Tasks"
description: "AI behavior tasks: follower, patrol controller, reaction tasks (death, hit), smasher tasks, spiderbot tasks, alerted, apply anim wrappers, assign restrict movement, change NPC state, core, custom aiming, event sender, follow vehicle, leave cover, lookats, low FPS cover, NPC init, ragdoll, random, return to restrict area, send command, set avoid LOS, set arguments, search influence, squad, status effect, stim reaction, target data, teleport failsafe, vehicle, wait cover, and workspot."
resource: "!cyberpunk/ai/Tasks/FollowerTasks.swift"
tags: ['cyberpunk', 'ai', 'tasks']
timestamp: 2026-07-01T13:00:55Z
---

# AI Tasks

AI behavior tasks: follower, patrol controller, reaction tasks (death, hit), smasher tasks, spiderbot tasks, alerted, apply anim wrappers, assign restrict movement, change NPC state, core, custom aiming, event sender, follow vehicle, leave cover, lookats, low FPS cover, NPC init, ragdoll, random, return to restrict area, send command, set avoid LOS, set arguments, search influence, squad, status effect, stim reaction, target data, teleport failsafe, vehicle, wait cover, and workspot.

## Source Files

- `cyberpunk/ai/Tasks/FollowerTasks.swift`
- `cyberpunk/ai/Tasks/PatrolControllerTask.swift`
- `cyberpunk/ai/Tasks/ReactionTasks/aiDeathReactionTask.swift`
- `cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift`
- `cyberpunk/ai/Tasks/SmasherTasks.swift`
- `cyberpunk/ai/Tasks/SpiderbotTasks.swift`
- `cyberpunk/ai/Tasks/aiAlertedTasks.swift`
- `cyberpunk/ai/Tasks/aiApplyAnimWrappersOnWeaponTask.swift`
- `cyberpunk/ai/Tasks/aiAssignRestrictMovementAreaTask.swift`
- `cyberpunk/ai/Tasks/aiChangeNPCState.swift`
- `cyberpunk/ai/Tasks/aiCoreTasks.swift`
- `cyberpunk/ai/Tasks/aiCustomAimingTasks.swift`
- `cyberpunk/ai/Tasks/aiEventSender.swift`
- `cyberpunk/ai/Tasks/aiFollowVehicleTasks.swift`
- `cyberpunk/ai/Tasks/aiLeaveCoverImmediately.swift`
- `cyberpunk/ai/Tasks/aiLookats.swift`
- `cyberpunk/ai/Tasks/aiLowFPSSelectCoverMode.swift`
- `cyberpunk/ai/Tasks/aiNPCInitTask.swift`
- `cyberpunk/ai/Tasks/aiRagdollTasks.swift`
- `cyberpunk/ai/Tasks/aiRandomTasks.swift`
- `cyberpunk/ai/Tasks/aiReturnToRestrictMovementArea.swift`
- `cyberpunk/ai/Tasks/aiSendCommandTasks.swift`
- `cyberpunk/ai/Tasks/aiSetAvoidLOSTimeStamp.swift`
- `cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift`
- `cyberpunk/ai/Tasks/aiSetSearchInfluenceTask.swift`
- `cyberpunk/ai/Tasks/aiSquadTasks.swift`
- `cyberpunk/ai/Tasks/aiStatusEffectTask.swift`
- `cyberpunk/ai/Tasks/aiStimReactionTask.swift`
- `cyberpunk/ai/Tasks/aiTargetDataTasks.swift`
- `cyberpunk/ai/Tasks/aiTeleportFailsafeHelperTask.swift`
- `cyberpunk/ai/Tasks/aiVehicle.swift`
- `cyberpunk/ai/Tasks/aiWaitIfEnteringOrLeavingCover.swift`
- `cyberpunk/ai/Tasks/aiWorkSpotTask.swift`

## Member Types

**Total declarations: 264**

### Classs (247)

| Name | Bases | Source File |
|------|-------|-------------|
| PassiveIsPlayerCompanionCondition | PassiveAutonomousCondition | cyberpunk/ai/Tasks/FollowerTasks.swift |
| IsFollowTargetInCombat | AIAutonomousConditions | cyberpunk/ai/Tasks/FollowerTasks.swift |
| IsPlayerCompanion | AIAutonomousConditions | cyberpunk/ai/Tasks/FollowerTasks.swift |
| IsFriendlyToPlayer | AIAutonomousConditions | cyberpunk/ai/Tasks/FollowerTasks.swift |
| FollowerFindTeleportPositionAroundTarget | AIbehaviortaskScript | cyberpunk/ai/Tasks/FollowerTasks.swift |
| AIFollowerTakedownCommandHandler | AIbehaviortaskScript | cyberpunk/ai/Tasks/FollowerTasks.swift |
| AIFollowerTakedownCommandDelegate | ScriptBehaviorDelegate | cyberpunk/ai/Tasks/FollowerTasks.swift |
| AIFollowerInterpolateFollowingSpeed | AIbehaviortaskScript | cyberpunk/ai/Tasks/FollowerTasks.swift |
| AIFollowerBeforeTakedown | AIbehaviortaskScript | cyberpunk/ai/Tasks/FollowerTasks.swift |
| PatrolControllerTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| PatrolCommandHandler | AIbehaviortaskScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| PatrolRoleHandler | AIbehaviortaskScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| PatrolAlertedControllerTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| PatrolAlertedCommandHandler | AIbehaviortaskScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| AlertedRoleHandler | AIbehaviortaskScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| CheckCurrentWorkspotTag | AIbehaviorconditionScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| GetCurrentPatrolSpotActionPath | AIbehaviortaskScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| HasPatrolAction | AIbehaviorconditionScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| SendPatrolEndSignal | AIbehaviortaskScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| ShouldContinuePatrolFromNextControlPoint | AIbehaviorconditionScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| ShouldContinuePatrolFromClosestPoint | AIbehaviorconditionScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| ShouldContinuePatrolFromBeginning | AIbehaviorconditionScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| IsPatrolProgressValid | AIbehaviorconditionScript | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| AIDeathReactionsTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/ReactionTasks/aiDeathReactionTask.swift |
| DeadOnInitTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/ReactionTasks/aiDeathReactionTask.swift |
| DeathIsRagdollCondition | AIbehaviorconditionScript | cyberpunk/ai/Tasks/ReactionTasks/aiDeathReactionTask.swift |
| WithoutHitDataDeathTask | AIDeathReactionsTask | cyberpunk/ai/Tasks/ReactionTasks/aiDeathReactionTask.swift |
| SyncAnimDeathTask | WithoutHitDataDeathTask | cyberpunk/ai/Tasks/ReactionTasks/aiDeathReactionTask.swift |
| ForcedRagdollDeathTask | AIDeathReactionsTask | cyberpunk/ai/Tasks/ReactionTasks/aiDeathReactionTask.swift |
| VehicleDeathTask | AIDeathReactionsTask | cyberpunk/ai/Tasks/ReactionTasks/aiDeathReactionTask.swift |
| SetSkipDeathAnimationTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/ReactionTasks/aiDeathReactionTask.swift |
| AIHitReactionTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| ImpactReactionTask | AIHitReactionTask | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| StaggerReactionTask | AIHitReactionTask | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| KnockdownReactionTask | AIHitReactionTask | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| PainReactionTask | AIHitReactionTask | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| GuardbreakReactionTask | AIHitReactionTask | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| BlockReactionTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| ParryReactionTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| DodgeReactionTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| BlockReactionFlag | AIbehaviortaskScript | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| BroadcastCombatHitStim | AIbehaviortaskScript | cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift |
| SmasherFindTeleportPositionAroundTarget | AIbehaviortaskScript | cyberpunk/ai/Tasks/SmasherTasks.swift |
| SmasherPlayVFX | AIbehaviortaskScript | cyberpunk/ai/Tasks/SmasherTasks.swift |
| FindClosestScavengeTarget | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| MoveToScavengeTarget | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| ScavengeTarget | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| HaveScavengeTargets | AIbehaviorconditionScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AITakedownHandler | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AICommandDeviceHandler | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AISetSoloModeHandler | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| IsCombatModuleEquipped | AIAutonomousConditions | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AIPrepareTakedownData | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AIDeviceFeedbackData | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AIFindForwardPositionAround | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AIFindPositionAroundSelf | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AISpiderbotFindBoredMovePosition | AIFindPositionAroundSelf | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AISpiderbotCheckIfFriendlyMoved | AIAutonomousConditions | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AIFindPositionAroundTarget | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AISetHealthRegenerationState | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AISetAutocraftingState | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| SelectClosestPlayerThreat | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| SetManouverPosition | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| IsAnyThreatClose | AIAutonomousConditions | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| RemoveCommand | AIbehaviortaskScript | cyberpunk/ai/Tasks/SpiderbotTasks.swift |
| AIAlertedStateDelegate | ScriptBehaviorDelegate | cyberpunk/ai/Tasks/aiAlertedTasks.swift |
| AlertedAnimWrapper | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiAlertedTasks.swift |
| ApplyAnimWrappersOnWeapon | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiApplyAnimWrappersOnWeaponTask.swift |
| AssignRestrictMovementAreaTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiAssignRestrictMovementAreaTask.swift |
| AssignRestrictMovementAreaHandler | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiAssignRestrictMovementAreaTask.swift |
| ChangeHighLevelStateAbstract | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| RelaxedState | ChangeHighLevelStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| AlertedState | ChangeHighLevelStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| CombatState | ChangeHighLevelStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| StealthState | ChangeHighLevelStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| UnconsciousState | ChangeHighLevelStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| DeadState | ChangeHighLevelStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| HighLevelStateMapping | ChangeHighLevelStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| StackChangeHighLevelStateAbstract | AIbehaviortaskStackScript | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| StackRelaxedState | StackChangeHighLevelStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| StackAlertedState | StackChangeHighLevelStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| ChangeUpperBodyStateAbstract | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| ChangeUpperBodyState | ChangeUpperBodyStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| ChangeStanceStateAbstract | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| ChangeStanceState | ChangeStanceStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| StandState | ChangeStanceStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| VehicleState | ChangeStanceStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| VehicleWindowState | ChangeStanceStateAbstract | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| InitialiseNPC | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| SelectorRevalutionBreak | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| SetTopThreatToCombatTarget | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| ClearCombatTarget | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| StackClearCombatTarget | AIbehaviortaskStackScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| TempClearForcedCombatTarget | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| AICombatTargetHelper | IScriptable | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| SetDroppedThreatLastKnowPosition | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| StopCallReinforcements | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| UpdateDyingStimSource | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| AddWeapon | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| IncrementArgumentInt | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCoreTasks.swift |
| SetCustomShootPosition | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiCustomAimingTasks.swift |
| AISignalSenderTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiEventSender.swift |
| CustomEventSender | AISignalSenderTask | cyberpunk/ai/Tasks/aiEventSender.swift |
| ReactiveEventSender | AISignalSenderTask | cyberpunk/ai/Tasks/aiEventSender.swift |
| CerberusCustomEventSender | AISignalSenderTask | cyberpunk/ai/Tasks/aiEventSender.swift |
| GetFollowTarget | FollowVehicleTask | cyberpunk/ai/Tasks/aiFollowVehicleTasks.swift |
| CheckFollowTarget | AIbehaviorconditionScript | cyberpunk/ai/Tasks/aiFollowVehicleTasks.swift |
| CheckTargetInVehicle | AIbehaviorconditionScript | cyberpunk/ai/Tasks/aiFollowVehicleTasks.swift |
| LeaveCoverImmediately | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiLeaveCoverImmediately.swift |
| AIGenericLookatTask | AILookatTask | cyberpunk/ai/Tasks/aiLookats.swift |
| AIGenericEntityLookatTask | AIGenericLookatTask | cyberpunk/ai/Tasks/aiLookats.swift |
| AIGenericAdvancedLookatTask | AIGenericLookatTask | cyberpunk/ai/Tasks/aiLookats.swift |
| AIGenericStaticLookatTask | AIGenericLookatTask | cyberpunk/ai/Tasks/aiLookats.swift |
| AISearchingLookat | AIGenericStaticLookatTask | cyberpunk/ai/Tasks/aiLookats.swift |
| LookatCompanion | AIGenericAdvancedLookatTask | cyberpunk/ai/Tasks/aiLookats.swift |
| LookatCombatTarget | AIGenericEntityLookatTask | cyberpunk/ai/Tasks/aiLookats.swift |
| HeadLookatCombatTarget | LookatCombatTarget | cyberpunk/ai/Tasks/aiLookats.swift |
| LookatCombatTarget_WithoutArms | AIGenericEntityLookatTask | cyberpunk/ai/Tasks/aiLookats.swift |
| WoundedLookatController | AIGenericEntityLookatTask | cyberpunk/ai/Tasks/aiLookats.swift |
| SearchPatternMappingLookat | AISearchingLookat | cyberpunk/ai/Tasks/aiLookats.swift |
| SearchInFrontPatternLookat | AISearchingLookat | cyberpunk/ai/Tasks/aiLookats.swift |
| CentaurShieldLookatController | AILookatTask | cyberpunk/ai/Tasks/aiLookats.swift |
| LowFPSSelectCoverMode | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiLowFPSSelectCoverMode.swift |
| NPCInitTask | AIbehaviortaskStackScript | cyberpunk/ai/Tasks/aiNPCInitTask.swift |
| CacheAnimationForPotentialRagdoll | RagdollTask | cyberpunk/ai/Tasks/aiRagdollTasks.swift |
| ForceRagdoll | RagdollTask | cyberpunk/ai/Tasks/aiRagdollTasks.swift |
| DisableRagdoll | RagdollTask | cyberpunk/ai/Tasks/aiRagdollTasks.swift |
| AIRandomTasks | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiRandomTasks.swift |
| SetRandomIntArgument | AIRandomTasks | cyberpunk/ai/Tasks/aiRandomTasks.swift |
| GetRandomThreat | AIRandomTasks | cyberpunk/ai/Tasks/aiRandomTasks.swift |
| GetRandomPositionAroundPoint | AIRandomTasks | cyberpunk/ai/Tasks/aiRandomTasks.swift |
| RestrictedMovementAreaCondition | AIbehaviorconditionScript | cyberpunk/ai/Tasks/aiReturnToRestrictMovementArea.swift |
| AIReturnToRestrictMovementAreaCondition | RestrictedMovementAreaCondition | cyberpunk/ai/Tasks/aiReturnToRestrictMovementArea.swift |
| IsStimSourceInRestrictMovementArea | RestrictedMovementAreaCondition | cyberpunk/ai/Tasks/aiReturnToRestrictMovementArea.swift |
| AIReturnToRestrictMovementArea | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiReturnToRestrictMovementArea.swift |
| SendEquipWeaponCommand | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiSendCommandTasks.swift |
| SetAvoidLOSTimeStamp | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiSetAvoidLOSTimeStamp.swift |
| ResetAvoidLOSTimeStamp | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiSetAvoidLOSTimeStamp.swift |
| SetArguments | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| SetArgumentBoolean | SetArguments | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| SetArgumentInt | SetArguments | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| SetTimeStampToArgumentFloat | SetArguments | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| SetArgumentFloat | SetArguments | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| SetArgumentName | SetArguments | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| SetArgumentVector | SetArguments | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| ClearArgumentObject | SetArguments | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| SetSearchInfluenceTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiSetSearchInfluenceTask.swift |
| CallOffReactionAction | SquadTask | cyberpunk/ai/Tasks/aiSquadTasks.swift |
| SquadAlertedSync | SquadTask | cyberpunk/ai/Tasks/aiSquadTasks.swift |
| ApplyStatusEffectOnOwner | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| RemoveStatusEffectOnOwner | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| MonitorStatusEffectBehavior | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| UnconsciousManagerTask | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| SystemCollapseManagerTask | UnconsciousManagerTask | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| HeartAttackManagerTask | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| DropWeaponTask | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| SetHitStimSourceTask | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| ToggleVisibleObjectComponent | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| SetPlayerAsKiller | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| SetPendingReactionBB | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| BlindManagerTask | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| CacheFXOnDefeated | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| CacheStatusEffectAnimationTask | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| CheckFriendlyNPCAboutToBeHit | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| CheckRagdollOutOfNavmeshTask | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| AIRagdollDelegate | ScriptBehaviorDelegate | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| RemoveStatusEffectsOnStoryTier | StatusEffectTasks | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| ForceAnimationOffScreen | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStatusEffectTask.swift |
| ReactionManagerTask | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| UpdateStimSource | ReactionManagerTask | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetDesiredReaction | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetControllerStimSource | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetDeviceInvestigationData | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetDeviceControllerInvestigationData | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| TriggerCombatAgainstStimTarget | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| TriggerCombatReaction | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| GenerateHeatAroundLastTriggeredStimuli | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetTrafficLaneMovementParams | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetAvoidThreatDestination | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| AddActiveStimuli | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| MarkDespawnCandidate | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| RegisterFearReaction | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetExplosionInstigatorPositionAsStimSource | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| UpdateWhistlePosition | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| UpdateWhistleStimSource | UpdateWhistlePosition | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| UpdateWhistleCustomWorldPosition | UpdateWhistlePosition | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| InjectAttackInstigatorAsThreat | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| AdjustAnimWrappersForEscalatingFearPhase | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| AdjustAnimWrappersForDeescalatingFearPhase | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| AdjustAnimWrappersForEscalatingPanicPhase | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetStressOnTrafficLane | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetPanicOnTrafficLane | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| TriggerFearRunningVO | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| ResetAllFearWrappers | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| ReprimandEscalation | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| ReprimandDeescalation | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| ResetReprimandEscalation | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| ReprimandStartAnimFeature | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| ReprimandResetAnimFeature | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| ReprimandEscalateAnimFeature | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| ReprimandDeescalateAnimFeature | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| ReprimandToAlertedAnimFeature | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| ReprimandToCombatAnimFeature | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| CallPolice | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| IncrimentStimThreshold | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| IncrimentStealthStimThreshold | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetTimestampToBehaviorAgrument | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| UnregisterReactionAction | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetBackOffAnimFeature | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| SetBooleanArgumentWhenActive | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| BodyInvestigated | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| TryStopMovingOnTrafficLane | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| CrowdWalkAwayAfterCombat | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiStimReactionTask.swift |
| GetTargetLastKnownPosition | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiTargetDataTasks.swift |
| GetOwnPosition | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiTargetDataTasks.swift |
| TeleportFailsafeHelper | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiTeleportFailsafeHelperTask.swift |
| AIVehicleTaskAbstract | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiVehicle.swift |
| SetAnimWrappersFromMountData | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| EnterVehicle | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| ExitFromVehicle | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| ApproachVehicleDecorator | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| SlotReservationDecorator | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| GetOnWindowCombatDecorator | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| InVehicleDecorator | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| InVehicleCombatDecorator | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| InVehicleDriveToPointAutonomousDecorator | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| InVehicleAlertedDecorator | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| SetKeepStrategyOnSearch | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| KeepStrategyOnSearch | AIVehicleConditionAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| InVehicleDrivePatrolDecorator | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| MountAssigendVehicle | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| WaitBeforeExiting | AIVehicleTaskAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| AIVehicleConditionAbstract | AIbehaviorconditionScript | cyberpunk/ai/Tasks/aiVehicle.swift |
| HasVehicleAssigned | AIVehicleConditionAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| CanMountVehicle | AIVehicleConditionAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| DoesVehicleSupportCombat | AIVehicleConditionAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| IsNPCDriver | AIVehicleConditionAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| IsNPCAloneInVehicle | AIVehicleConditionAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| IsDriverActive | AIVehicleConditionAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| HasNewMountRequest | AIVehicleConditionAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| ShouldExitVehicle | AIVehicleConditionAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| StepOutOfVehicle | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiVehicle.swift |
| IsInVehicle | AIVehicleConditionAbstract | cyberpunk/ai/Tasks/aiVehicle.swift |
| InArmedVehicle | AIbehaviorconditionScript | cyberpunk/ai/Tasks/aiVehicle.swift |
| WaitIfEnteringOrLeavingCover | AIbehaviortaskScript | cyberpunk/ai/Tasks/aiWaitIfEnteringOrLeavingCover.swift |
| ReserveWorkSpotTask | WorkSpotTask | cyberpunk/ai/Tasks/aiWorkSpotTask.swift |
| ReleaseWorkSpotTask | WorkSpotTask | cyberpunk/ai/Tasks/aiWorkSpotTask.swift |

### Static Funcs (2)

| Name | Bases | Source File |
|------|-------|-------------|
| Cast |  | cyberpunk/ai/Tasks/PatrolControllerTask.swift |
| GetItemTypeFromContext |  | cyberpunk/ai/Tasks/aiStimReactionTask.swift |

### Funcs (15)

| Name | Bases | Source File |
|------|-------|-------------|
| GetDesiredHighLevelState |  | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| GetDesiredHighLevelState |  | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| GetDesiredHighLevelState |  | cyberpunk/ai/Tasks/aiChangeNPCState.swift |
| GetSignalLifeTime |  | cyberpunk/ai/Tasks/aiEventSender.swift |
| GetSignalLifeTime |  | cyberpunk/ai/Tasks/aiEventSender.swift |
| GetSignalLifeTime |  | cyberpunk/ai/Tasks/aiEventSender.swift |
| GetSignalLifeTime |  | cyberpunk/ai/Tasks/aiEventSender.swift |
| GetDescription |  | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| GetEditorSubCaption |  | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| GetEditorSubCaption |  | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| GetEditorSubCaption |  | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| GetEditorSubCaption |  | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| GetEditorSubCaption |  | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| GetEditorSubCaption |  | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |
| GetEditorSubCaption |  | cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift |

## Citations

- `cyberpunk/ai/Tasks/FollowerTasks.swift`
- `cyberpunk/ai/Tasks/PatrolControllerTask.swift`
- `cyberpunk/ai/Tasks/ReactionTasks/aiDeathReactionTask.swift`
- `cyberpunk/ai/Tasks/ReactionTasks/aiHitReactionTasks.swift`
- `cyberpunk/ai/Tasks/SmasherTasks.swift`
- `cyberpunk/ai/Tasks/SpiderbotTasks.swift`
- `cyberpunk/ai/Tasks/aiAlertedTasks.swift`
- `cyberpunk/ai/Tasks/aiApplyAnimWrappersOnWeaponTask.swift`
- `cyberpunk/ai/Tasks/aiAssignRestrictMovementAreaTask.swift`
- `cyberpunk/ai/Tasks/aiChangeNPCState.swift`
- `cyberpunk/ai/Tasks/aiCoreTasks.swift`
- `cyberpunk/ai/Tasks/aiCustomAimingTasks.swift`
- `cyberpunk/ai/Tasks/aiEventSender.swift`
- `cyberpunk/ai/Tasks/aiFollowVehicleTasks.swift`
- `cyberpunk/ai/Tasks/aiLeaveCoverImmediately.swift`
- `cyberpunk/ai/Tasks/aiLookats.swift`
- `cyberpunk/ai/Tasks/aiLowFPSSelectCoverMode.swift`
- `cyberpunk/ai/Tasks/aiNPCInitTask.swift`
- `cyberpunk/ai/Tasks/aiRagdollTasks.swift`
- `cyberpunk/ai/Tasks/aiRandomTasks.swift`
- `cyberpunk/ai/Tasks/aiReturnToRestrictMovementArea.swift`
- `cyberpunk/ai/Tasks/aiSendCommandTasks.swift`
- `cyberpunk/ai/Tasks/aiSetAvoidLOSTimeStamp.swift`
- `cyberpunk/ai/Tasks/aiSetBehaviorArguments.swift`
- `cyberpunk/ai/Tasks/aiSetSearchInfluenceTask.swift`
- `cyberpunk/ai/Tasks/aiSquadTasks.swift`
- `cyberpunk/ai/Tasks/aiStatusEffectTask.swift`
- `cyberpunk/ai/Tasks/aiStimReactionTask.swift`
- `cyberpunk/ai/Tasks/aiTargetDataTasks.swift`
- `cyberpunk/ai/Tasks/aiTeleportFailsafeHelperTask.swift`
- `cyberpunk/ai/Tasks/aiVehicle.swift`
- `cyberpunk/ai/Tasks/aiWaitIfEnteringOrLeavingCover.swift`
- `cyberpunk/ai/Tasks/aiWorkSpotTask.swift`
