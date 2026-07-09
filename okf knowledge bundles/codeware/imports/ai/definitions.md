---
type: "Import"
title: "Ai Definitions"
description: "Imported ai definitions types (53 types)."
resource: "codeware/scripts/"
tags: "[imports, definitions]"
timestamp: 2026-07-01T18:09:00Z
---

# Overview

Imported ai definitions types (53 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AIArgumentDefinition | class | ISerializable | name, isPersistent, behaviorCallbackName |
| AICTreeNodeActionAnimationCurvePathDefinition | class | AICTreeNodeActionDefinition | nodeReference, controllersSetupName, useStart, useStop, blendTime |
| AICTreeNodeActionAnimationCurvePathDynamicDefinition | class | AICTreeNodeActionDefinition | targetSplineVarName, controlerVarName, startAnimVarName, stopAnimVarName, blendTime |
| AICTreeNodeActionDefinition | class | AICTreeExtendableNodeDefinition | — |
| AICTreeNodeActionDieDefinition | class | AICTreeNodeActionDefinition | — |
| AICTreeNodeActionDynamicMoveToDefinition | class | AICTreeNodeActionDefinition | moveType, tolerance, target, keepDistance |
| AICTreeNodeActionReloadWeaponDefinition | class | AICTreeNodeActionDefinition | — |
| AICTreeNodeActionTeleportToPositionDefinition | class | AICTreeNodeActionDefinition | positionName, doNavTest |
| AICTreeNodeAtomicDefinition | class | AICTreeNodeDefinition | — |
| AICTreeNodeBoolSharedVarDecoratorDefinition | class | AICTreeNodeSingleSharedVarDecoratorDefinition | — |
| AICTreeNodeBrainDefinition | class | AICTreeNodeCompositeDefinition | children, useScoring |
| AICTreeNodeChildrenListDefinition | class | AICTreeNodeCompositeDefinition | children |
| AICTreeNodeCompleteImmediatelyDefinition | class | AICTreeNodeAtomicDefinition | completeWithSuccess |
| AICTreeNodeCompositeDefinition | class | AICTreeNodeDefinition | — |
| AICTreeNodeConditionDefinition | class | AICTreeNodeCompositeDefinition | expressions, trueBranch, falseBranch, reevaluateOnExecution |
| AICTreeNodeDebugLogDefinition | class | AICTreeExtendableNodeDefinition | text, timeOnScreen, useVisualDebug |
| AICTreeNodeDecisionDefinition | class | AICTreeNodeCompositeDefinition | child, expressions, interruption |
| AICTreeNodeDecoratorDefinition | class | AICTreeNodeDefinition | child |
| AICTreeNodeDoNothingDefinition | class | AICTreeNodeAtomicDefinition | — |
| AICTreeNodeDynamicBindDefinition | class | AICTreeNodeDynamicDefinition | — |
| AICTreeNodeDynamicDefinition | class | AICTreeNodeDefinition | — |
| AICTreeNodeFSMDefinition | class | AICTreeNodeCompositeDefinition | defaultState, transitions, onEventTransitions, states, sharedVars |
| AICTreeNodeFloatSharedVarDecoratorDefinition | class | AICTreeNodeSingleSharedVarDecoratorDefinition | — |
| AICTreeNodeForcedBehaviourDefinition | class | AICTreeNodeDynamicDefinition | — |
| AICTreeNodeIncludedTreeDefinition | class | AICTreeNodeDefinition | tree |
| AICTreeNodeInt32SharedVarDecoratorDefinition | class | AICTreeNodeSingleSharedVarDecoratorDefinition | — |
| AICTreeNodeNameSharedVarDecoratorDefinition | class | AICTreeNodeSingleSharedVarDecoratorDefinition | — |
| AICTreeNodeParallelDefinition | class | AICTreeNodeChildrenListDefinition | forwardChildrenCompleteness |
| AICTreeNodePlayerControlledDefinition | class | AICTreeNodeAtomicDefinition | — |
| AICTreeNodePositionSharedVarDecoratorDefinition | class | AICTreeNodeSingleSharedVarDecoratorDefinition | — |
| AICTreeNodeReadWorkspotParamsDefinition | class | AICTreeNodeDecoratorDefinition | workspotNodeVarName, prevWorkspotNodeVarName, splineNodeVarName, workspotEntryAnimVar, animControllerVarName |
| AICTreeNodeScriptDecoratorDefinition | class | AICTreeExtendableNodeDefinition | script, scriptName |
| AICTreeNodeSequenceDefinition | class | AICTreeNodeChildrenListDefinition | — |
| AICTreeNodeSetSplineMovementTargetDefinition | class | AICTreeNodeDecoratorDefinition | splineNode, movementTarget |
| AICTreeNodeSharedVarsBaseDecoratorDefinition | class | AICTreeNodeDecoratorDefinition | — |
| AICTreeNodeSharedVarsDecoratorDefinition | class | AICTreeNodeSharedVarsBaseDecoratorDefinition | sharedVars |
| AICTreeNodeSimpleSelectorDefinition | class | AICTreeNodeChildrenListDefinition | — |
| AICTreeNodeSingleSharedVarDecoratorDefinition | class | AICTreeNodeSharedVarsBaseDecoratorDefinition | sharedVarName |
| AICTreeNodeTargetNodeSharedVarDecoratorDefinition | class | AICTreeNodeSingleSharedVarDecoratorDefinition | — |
| AICTreeNodeTargetSharedVarDecoratorDefinition | class | AICTreeNodeSingleSharedVarDecoratorDefinition | — |
| AICTreeNodeTimeoutDefinition | class | AICTreeExtendableNodeDefinition | timeout |
| AIInterruptionHandlerAllowDefinition | class | AIInterruptionHandlerDefinition | — |
| AIInterruptionHandlerBehaviorDefinition | class | AIInterruptionHandlerDefinition | ai, parallelActivation, parallelExecution, blockInterruption |
| AIInterruptionHandlerDefinition | class | LibTreeINodeDefinition | signal, supportLessImportantSignals |
| AIInterruptionHandlerDenyDefinition | class | AIInterruptionHandlerDefinition | — |
| AISharedVarDefinition | struct | — | type |
| AISharedVarTableDefinition | struct | — | table |
| AITrafficExternalWorkspotDefinition | class | worldTrafficSpotDefinition | nearestPointEntry, globalWorkspotNodeRef |
| AITrafficWorkspotDefinition | class | worldTrafficSpotDefinition | workspotResource |
| AITreeArgumentsDefinition | struct | — | args |
| AITreeNodeDeathDefinition | class | AICTreeNodeActionDefinition | — |
| AITreeNodeInterruptionDecoratorDefinition | class | AICTreeNodeDecoratorDefinition | interruptions |
| AITreeNodeRepeatDefinition | class | AICTreeNodeDecoratorDefinition | limit |

# Citations

- `codeware/scripts/Base/Imports/AIArgumentDefinition.reds`
- `codeware/scripts/Base/Imports/AICTreeNodeActionAnimationCurvePathDefinition.reds`
- `codeware/scripts/Base/Imports/AICTreeNodeActionAnimationCurvePathDynamicDefinition.reds`
- `codeware/scripts/Base/Imports/AICTreeNodeActionDefinition.reds`
- `codeware/scripts/Base/Imports/AICTreeNodeActionDieDefinition.reds`
- `codeware/scripts/Base/Imports/AICTreeNodeActionDynamicMoveToDefinition.reds`
- `codeware/scripts/Base/Imports/AICTreeNodeActionReloadWeaponDefinition.reds`
- `codeware/scripts/Base/Imports/AICTreeNodeActionTeleportToPositionDefinition.reds`
- `codeware/scripts/Base/Imports/AICTreeNodeAtomicDefinition.reds`
- `codeware/scripts/Base/Imports/AICTreeNodeBoolSharedVarDecoratorDefinition.reds`
- ... and 43 more source files
