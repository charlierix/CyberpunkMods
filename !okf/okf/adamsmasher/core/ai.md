---
type: "AI System"
title: "AI Framework"
description: "Core AI framework with behavior delegates, code interfaces, commands, scripting, and tweak params."
resource: "!core/ai/actions.swift"
tags: ['core', 'ai']
timestamp: 2026-07-01T13:00:55Z
---

# AI Framework

Core AI framework with behavior delegates, code interfaces, commands, scripting, and tweak params.

## Source Files

- `core/ai/actions.swift`
- `core/ai/aiBehaviorDelegate.swift`
- `core/ai/aiCodeInterface.swift`
- `core/ai/aiCommand.swift`
- `core/ai/aiScripting.swift`
- `core/ai/aiStackScriptTask.swift`
- `core/ai/aiTweakParams.swift`
- `core/ai/attitudeAgent.swift`
- `core/ai/attitudeSystem.swift`

## Member Types

**Total declarations: 55**

### Classs (30)

| Name | Bases | Source File |
|------|-------|-------------|
| TestBehaviorDelegate | ScriptBehaviorDelegate | core/ai/aiBehaviorDelegate.swift |
| ActionWeightCondition | AIbehaviorconditionScript | core/ai/aiBehaviorDelegate.swift |
| ActionWeightManagerDelegate | ScriptBehaviorDelegate | core/ai/aiBehaviorDelegate.swift |
| AICodeInterface | IScriptable | core/ai/aiCodeInterface.swift |
| ScriptedAICommandParams | MiscAICommandNodeParams | core/ai/aiCommand.swift |
| AIAssignRoleCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIClearRoleCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AISetCombatPresetCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIInjectCombatThreatCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIMeleeAttackCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIForceShootCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIAimAtTargetCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIHoldPositionCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIMoveToCoverCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIStopCoverCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIJoinTargetsSquadCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIFollowerCommand | AICommand | core/ai/aiCommand.swift |
| AIFollowerTakedownCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIFlatheadSetSoloModeCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIScanTargetCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIRoadBlockadeMemberCommandParams | ScriptedAICommandParams | core/ai/aiCommand.swift |
| AIBehaviorScript | IScriptable | core/ai/aiScripting.swift |
| AIBehaviorScriptBase | IScriptable | core/ai/aiScripting.swift |
| AIbehaviorconditionScript | AIBehaviorScriptBase | core/ai/aiScripting.swift |
| AIbehaviortaskScript | AIBehaviorScriptBase | core/ai/aiScripting.swift |
| AIbehaviorexpressionScript | AIBehaviorScriptBase | core/ai/aiScripting.swift |
| AIbehaviortaskStackScript | AIBehaviorScriptBase | core/ai/aiStackScriptTask.swift |
| TestStackScript | AIbehaviortaskStackScript | core/ai/aiStackScriptTask.swift |
| TestStackPassiveExpression | AIbehaviorStackScriptPassiveExpressionDefinition | core/ai/aiStackScriptTask.swift |
| AITweakParams | IScriptable | core/ai/aiTweakParams.swift |

### Static Funcs (6)

| Name | Bases | Source File |
|------|-------|-------------|
| GetActionAnimationSlideParams |  | core/ai/actions.swift |
| Cast |  | core/ai/aiScripting.swift |
| Cast |  | core/ai/aiScripting.swift |
| OperatorAdd |  | core/ai/attitudeAgent.swift |
| OperatorAdd |  | core/ai/attitudeAgent.swift |
| CanChangeAttitudeRelationFor |  | core/ai/attitudeSystem.swift |

### Funcs (19)

| Name | Bases | Source File |
|------|-------|-------------|
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| CreateCommand |  | core/ai/aiCommand.swift |
| GetDescription |  | core/ai/aiScripting.swift |
| GetInstanceTypeName |  | core/ai/aiStackScriptTask.swift |
| GetInstanceTypeName |  | core/ai/aiStackScriptTask.swift |

## Citations

- `core/ai/actions.swift`
- `core/ai/aiBehaviorDelegate.swift`
- `core/ai/aiCodeInterface.swift`
- `core/ai/aiCommand.swift`
- `core/ai/aiScripting.swift`
- `core/ai/aiStackScriptTask.swift`
- `core/ai/aiTweakParams.swift`
- `core/ai/attitudeAgent.swift`
- `core/ai/attitudeSystem.swift`
