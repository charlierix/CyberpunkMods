---
type: "AI System"
title: "AI Commands"
description: "AI commands: patrol prologue, aim with weapon, background combat, cerberus ranged kill, command handler base, drive, equip item, equip weapon, find teleport for takedown, find teleport behind target, find teleport for Kurt takedown, force shoot, idle, inject combat target, inject combat threat, inject lookat target, join targets squad, line trace, melee attack, move to, move to cover, root motion, scan target, set combat preset, shoot, teleport, throw grenade, use cover, use workspot, and vehicle behavior delegate."
resource: "!cyberpunk/ai/commands/PatrolCommandPrologue.swift"
tags: ['cyberpunk', 'ai', 'commands']
timestamp: 2026-07-01T13:00:55Z
---

# AI Commands

AI commands: patrol prologue, aim with weapon, background combat, cerberus ranged kill, command handler base, drive, equip item, equip weapon, find teleport for takedown, find teleport behind target, find teleport for Kurt takedown, force shoot, idle, inject combat target, inject combat threat, inject lookat target, join targets squad, line trace, melee attack, move to, move to cover, root motion, scan target, set combat preset, shoot, teleport, throw grenade, use cover, use workspot, and vehicle behavior delegate.

## Source Files

- `cyberpunk/ai/commands/PatrolCommandPrologue.swift`
- `cyberpunk/ai/commands/aiAimWithWeaponCommand.swift`
- `cyberpunk/ai/commands/aiBackgroundCombatCommand.swift`
- `cyberpunk/ai/commands/aiCerberusRangedKillCommand.swift`
- `cyberpunk/ai/commands/aiCommandHandlerBase.swift`
- `cyberpunk/ai/commands/aiDriveCommandHandler.swift`
- `cyberpunk/ai/commands/aiEquipItemCommand.swift`
- `cyberpunk/ai/commands/aiEquipWeaponCommand.swift`
- `cyberpunk/ai/commands/aiFindTeleportPositionForTakedown.swift`
- `cyberpunk/ai/commands/aiFindTeleportSpotBehindTargetCommand.swift`
- `cyberpunk/ai/commands/aiFindTeleportSpotKurtTakedown.swift`
- `cyberpunk/ai/commands/aiForceShootCommand.swift`
- `cyberpunk/ai/commands/aiIdleCommand.swift`
- `cyberpunk/ai/commands/aiInjectCombatTargetCommand.swift`
- `cyberpunk/ai/commands/aiInjectCombatThreatCommand.swift`
- `cyberpunk/ai/commands/aiInjectLookatTargetCommand.swift`
- `cyberpunk/ai/commands/aiJoinTargetsSquadCommand.swift`
- `cyberpunk/ai/commands/aiLineTrace.swift`
- `cyberpunk/ai/commands/aiMeleeAttackCommand.swift`
- `cyberpunk/ai/commands/aiMoveToCommandHandler.swift`
- `cyberpunk/ai/commands/aiMoveToCoverCommand.swift`
- `cyberpunk/ai/commands/aiRootMotionCommand.swift`
- `cyberpunk/ai/commands/aiScanTargetTask.swift`
- `cyberpunk/ai/commands/aiSetCombatPresetCommand.swift`
- `cyberpunk/ai/commands/aiShootCommand.swift`
- `cyberpunk/ai/commands/aiTeleportCommand.swift`
- `cyberpunk/ai/commands/aiThrowGrenadeCommand.swift`
- `cyberpunk/ai/commands/aiUseCoverCommand.swift`
- `cyberpunk/ai/commands/aiUseWorkspotCommandDelegate.swift`
- `cyberpunk/ai/commands/aiUseWorkspotCommandHandler.swift`
- `cyberpunk/ai/commands/aiVehicleBehaviorDelegate.swift`

## Member Types

**Total declarations: 64**

### Classs (62)

| Name | Bases | Source File |
|------|-------|-------------|
| AIPatrolCommandPrologue | AICommandHandlerBase | cyberpunk/ai/commands/PatrolCommandPrologue.swift |
| AimAtTargetCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiAimWithWeaponCommand.swift |
| AimAtTargetCommandCleanup | AIbehaviortaskScript | cyberpunk/ai/commands/aiAimWithWeaponCommand.swift |
| AimAtTargetCommandHandler | AIbehaviortaskScript | cyberpunk/ai/commands/aiAimWithWeaponCommand.swift |
| AIBackgroundCombatCommandParams | ScriptedAICommandParams | cyberpunk/ai/commands/aiBackgroundCombatCommand.swift |
| AIAnimationTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiBackgroundCombatCommand.swift |
| AIBackgroundCombatDelegate | ScriptBehaviorDelegate | cyberpunk/ai/commands/aiBackgroundCombatCommand.swift |
| CerberusRangedKillTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiCerberusRangedKillCommand.swift |
| AICommandHandlerBase | AIbehaviortaskScript | cyberpunk/ai/commands/aiCommandHandlerBase.swift |
| CommandCleanup | AIbehaviortaskScript | cyberpunk/ai/commands/aiCommandHandlerBase.swift |
| CompleteCommand | AIbehaviortaskScript | cyberpunk/ai/commands/aiCommandHandlerBase.swift |
| AIDriveCommandsDelegate | ScriptBehaviorDelegate | cyberpunk/ai/commands/aiDriveCommandHandler.swift |
| AIDriveOnSplineCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiDriveCommandHandler.swift |
| AIDriveFollowCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiDriveCommandHandler.swift |
| AIDriveToNodeCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiDriveCommandHandler.swift |
| AIDriveRacingCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiDriveCommandHandler.swift |
| AIDrivePanicCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiDriveCommandHandler.swift |
| AIDriveJoinTrafficCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiDriveCommandHandler.swift |
| EquipItemCommandDelegate | ScriptBehaviorDelegate | cyberpunk/ai/commands/aiEquipItemCommand.swift |
| EquipPrimaryWeaponCommandDelegate | ScriptBehaviorDelegate | cyberpunk/ai/commands/aiEquipWeaponCommand.swift |
| EquipSecondaryWeaponCommandDelegate | ScriptBehaviorDelegate | cyberpunk/ai/commands/aiEquipWeaponCommand.swift |
| FindTeleportPositionForTakedown | AIbehaviorconditionScript | cyberpunk/ai/commands/aiFindTeleportPositionForTakedown.swift |
| FollowerFindTeleportPositionRightBehindTarget | AIbehaviortaskScript | cyberpunk/ai/commands/aiFindTeleportSpotBehindTargetCommand.swift |
| FindTeleportPositionKurt | AIbehaviortaskScript | cyberpunk/ai/commands/aiFindTeleportSpotKurtTakedown.swift |
| ForceShootCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiForceShootCommand.swift |
| ForceShootCommandCleanup | AIbehaviortaskScript | cyberpunk/ai/commands/aiForceShootCommand.swift |
| ForceShootCommandHandler | AIbehaviortaskScript | cyberpunk/ai/commands/aiForceShootCommand.swift |
| HoldPositionCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiIdleCommand.swift |
| InjectCombatTargetCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiInjectCombatTargetCommand.swift |
| InjectCombatThreatCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiInjectCombatThreatCommand.swift |
| InjectLookatTargetCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiInjectLookatTargetCommand.swift |
| AIJoinTargetsSquadTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiJoinTargetsSquadCommand.swift |
| HorizontalLineTrace | AIbehaviorconditionScript | cyberpunk/ai/commands/aiLineTrace.swift |
| MeleeAttackCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiMeleeAttackCommand.swift |
| MeleeAttackCommandCleanup | AIbehaviortaskScript | cyberpunk/ai/commands/aiMeleeAttackCommand.swift |
| MeleeAttackCommandHandler | AIbehaviortaskScript | cyberpunk/ai/commands/aiMeleeAttackCommand.swift |
| AIMoveToCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiMoveToCommandHandler.swift |
| AIMoveOnSplineCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiMoveToCommandHandler.swift |
| AIMoveRotateToCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiMoveToCommandHandler.swift |
| MoveCommandCleanup | AIbehaviortaskScript | cyberpunk/ai/commands/aiMoveToCommandHandler.swift |
| AIMoveCommandsDelegate | ScriptBehaviorDelegate | cyberpunk/ai/commands/aiMoveToCommandHandler.swift |
| IgnoreMoveCommandInCombatCondition | AIbehaviorconditionScript | cyberpunk/ai/commands/aiMoveToCommandHandler.swift |
| MoveToCoverCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiMoveToCoverCommand.swift |
| MoveToCoverCommandDelegate | ScriptBehaviorDelegate | cyberpunk/ai/commands/aiMoveToCoverCommand.swift |
| RootMotionCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiRootMotionCommand.swift |
| AIScanTargetTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiScanTargetTask.swift |
| AISetCombatPresetTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiSetCombatPresetCommand.swift |
| ShootCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiShootCommand.swift |
| ShootCommandCleanup | AIbehaviortaskScript | cyberpunk/ai/commands/aiShootCommand.swift |
| ShootCommandHandler | AIbehaviortaskScript | cyberpunk/ai/commands/aiShootCommand.swift |
| TeleportCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiTeleportCommand.swift |
| ThrowGrenadeCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiThrowGrenadeCommand.swift |
| ThrowGrenadeCommandCleanup | AIbehaviortaskScript | cyberpunk/ai/commands/aiThrowGrenadeCommand.swift |
| ThrowGrenadeCommandHandler | AIbehaviortaskScript | cyberpunk/ai/commands/aiThrowGrenadeCommand.swift |
| UseCoverCommandTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiUseCoverCommand.swift |
| UseCoverCommandCleanup | AIbehaviortaskScript | cyberpunk/ai/commands/aiUseCoverCommand.swift |
| UseCoverCommandHandler | AIbehaviortaskScript | cyberpunk/ai/commands/aiUseCoverCommand.swift |
| UseWorkspotCommandDelegate | ScriptBehaviorDelegate | cyberpunk/ai/commands/aiUseWorkspotCommandDelegate.swift |
| UseWorkspotCommandHandler | AICommandHandlerBase | cyberpunk/ai/commands/aiUseWorkspotCommandHandler.swift |
| MountCommandHandlerTask | AIbehaviortaskScript | cyberpunk/ai/commands/aiVehicleBehaviorDelegate.swift |
| MountRequestCondition | AIbehaviorconditionScript | cyberpunk/ai/commands/aiVehicleBehaviorDelegate.swift |
| MountRequestPassiveCondition | AIbehaviorexpressionScript | cyberpunk/ai/commands/aiVehicleBehaviorDelegate.swift |

### Funcs (2)

| Name | Bases | Source File |
|------|-------|-------------|
| CreateCommand |  | cyberpunk/ai/commands/aiBackgroundCombatCommand.swift |
| GetDescription |  | cyberpunk/ai/commands/aiBackgroundCombatCommand.swift |

## Citations

- `cyberpunk/ai/commands/PatrolCommandPrologue.swift`
- `cyberpunk/ai/commands/aiAimWithWeaponCommand.swift`
- `cyberpunk/ai/commands/aiBackgroundCombatCommand.swift`
- `cyberpunk/ai/commands/aiCerberusRangedKillCommand.swift`
- `cyberpunk/ai/commands/aiCommandHandlerBase.swift`
- `cyberpunk/ai/commands/aiDriveCommandHandler.swift`
- `cyberpunk/ai/commands/aiEquipItemCommand.swift`
- `cyberpunk/ai/commands/aiEquipWeaponCommand.swift`
- `cyberpunk/ai/commands/aiFindTeleportPositionForTakedown.swift`
- `cyberpunk/ai/commands/aiFindTeleportSpotBehindTargetCommand.swift`
- `cyberpunk/ai/commands/aiFindTeleportSpotKurtTakedown.swift`
- `cyberpunk/ai/commands/aiForceShootCommand.swift`
- `cyberpunk/ai/commands/aiIdleCommand.swift`
- `cyberpunk/ai/commands/aiInjectCombatTargetCommand.swift`
- `cyberpunk/ai/commands/aiInjectCombatThreatCommand.swift`
- `cyberpunk/ai/commands/aiInjectLookatTargetCommand.swift`
- `cyberpunk/ai/commands/aiJoinTargetsSquadCommand.swift`
- `cyberpunk/ai/commands/aiLineTrace.swift`
- `cyberpunk/ai/commands/aiMeleeAttackCommand.swift`
- `cyberpunk/ai/commands/aiMoveToCommandHandler.swift`
- `cyberpunk/ai/commands/aiMoveToCoverCommand.swift`
- `cyberpunk/ai/commands/aiRootMotionCommand.swift`
- `cyberpunk/ai/commands/aiScanTargetTask.swift`
- `cyberpunk/ai/commands/aiSetCombatPresetCommand.swift`
- `cyberpunk/ai/commands/aiShootCommand.swift`
- `cyberpunk/ai/commands/aiTeleportCommand.swift`
- `cyberpunk/ai/commands/aiThrowGrenadeCommand.swift`
- `cyberpunk/ai/commands/aiUseCoverCommand.swift`
- `cyberpunk/ai/commands/aiUseWorkspotCommandDelegate.swift`
- `cyberpunk/ai/commands/aiUseWorkspotCommandHandler.swift`
- `cyberpunk/ai/commands/aiVehicleBehaviorDelegate.swift`
