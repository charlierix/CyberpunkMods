---
type: "Import"
title: "Misc Types/A"
description: "Imported misc types/a types (28 types)."
resource: "codeware/scripts/"
tags: "[imports, a]"
timestamp: 2026-07-01T18:09:19Z
---

# Overview

Imported misc types/a types (28 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AIbehaviorActivationStatus | enum | — | NOT_ACTIVATED, ACTIVATING, ACTIVATED, DEACTIVATING |
| AIbehaviorAgentInfoDebuggerCommand | class | AIbehaviorIDebuggerCommand | entityId, agentName, isSelected, entries |
| AIbehaviorAssignTaskItem | struct | — | leftHandSide |
| AIbehaviorAsyncCallbackToken | struct | — | — |
| AIbehaviorBehaviorDebugInfo | class | AIbehaviorDebugInfoBase | — |
| AIbehaviorBehaviorIncludedDebuggerCommand | class | AIbehaviorIDebuggerCommand | entries |
| AIbehaviorBehaviorInstanceCallStack | struct | — | resourceHashes |
| AIbehaviorClearActiveNodesDebuggerCommand | class | AIbehaviorIDebuggerCommand | — |
| AIbehaviorDebugInfoBase | class | ISerializable | caption |
| AIbehaviorDebugNodeStatus | enum | — | Undefined, NotRunning, ForceStopped, Running, Success |
| AIbehaviorDebugger | class | AIbehaviorIDebugger | — |
| AIbehaviorEdgeConditionAction | enum | — | None, Toggle, TurnOn, TurnOff |
| AIbehaviorEntityLODConditions | enum | — | Crowd, Cinematic, WorkspotStatic |
| AIbehaviorExpressionSocket | class | ISerializable | typeHint, expression |
| AIbehaviorGetSelectedAgentDebuggerCommand | class | AIbehaviorIDebuggerCommand | — |
| AIbehaviorIDebugger | class | ISerializable | — |
| AIbehaviorIDebuggerCommand | class | ISerializable | — |
| AIbehaviorMaybeNodeAction | enum | — | Succeed, Fail, RepeatChild |
| AIbehaviorMovementPolicyTaskFunctions | enum | — | SetMovementType, SetTargetObject, UseFollowSlots, SetLocalTargetOffset, SetIgnoreNavigation |
| AIbehaviorNaryExpressionOperators | enum | — | LogicalAnd, LogicalOr |
| AIbehaviorNodeStatusDebuggerCommand | class | AIbehaviorIDebuggerCommand | behaviorResourceHash, generation, entries |
| AIbehaviorParallelNodeWaitFor | enum | — | LeftChild, RightChild, AllChildren, BothChildren, AnyChild |
| AIbehaviorSignalConditionModes | enum | — | CurrentValue, StartOfFrameValue, RisingEdge, FallingEdge, AnyEdge |
| AIbehaviorStoryActionType | enum | — | Setup, Stop |
| AIbehaviorTypeRef | struct | — | isSet, enumeratedType |
| AIbehaviortweakInstanceRef | struct | — | — |
| AIbehaviortweakNPCCallbacks | struct | — | — |
| AIbehaviortweakPlayerCallbacks | struct | — | — |

# Citations

- `codeware/scripts/Base/Imports/AIbehaviorActivationStatus.reds`
- `codeware/scripts/Base/Imports/AIbehaviorAgentInfoDebuggerCommand.reds`
- `codeware/scripts/Base/Imports/AIbehaviorAssignTaskItem.reds`
- `codeware/scripts/Base/Imports/AIbehaviorAsyncCallbackToken.reds`
- `codeware/scripts/Base/Imports/AIbehaviorBehaviorDebugInfo.reds`
- `codeware/scripts/Base/Imports/AIbehaviorBehaviorIncludedDebuggerCommand.reds`
- `codeware/scripts/Base/Imports/AIbehaviorBehaviorInstanceCallStack.reds`
- `codeware/scripts/Base/Imports/AIbehaviorClearActiveNodesDebuggerCommand.reds`
- `codeware/scripts/Base/Imports/AIbehaviorDebugInfoBase.reds`
- `codeware/scripts/Base/Imports/AIbehaviorDebugNodeStatus.reds`
- ... and 18 more source files
