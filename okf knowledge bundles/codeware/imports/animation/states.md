---
type: "Import"
title: "Animation States"
description: "Imported animation states types (30 types)."
resource: "codeware/scripts/"
tags: "[imports, states]"
timestamp: 2026-07-01T18:09:03Z
---

# Overview

Imported animation states types (30 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animAnimGraphDebugState | class | ISerializable | nodes |
| animAnimNodeDebugState | class | ISerializable | nodeId, active |
| animAnimNode_LocoState | class | animAnimNode_State | type, locoTag |
| animAnimNode_State | class | animAnimNode_Container | name, outTransitionIndices, preventTransitionsInActivationFrame, tags, requiredQualityDistanceCategory |
| animAnimNode_StateFrozen | class | animAnimNode_State | — |
| animAnimNode_StateMachine | class | animAnimNode_Base | states, frozenState, transitions, conditionalEntries, globalTransitions |
| animAnimStateInterpolationType | enum | — | Linear, EaseIn, EaseOut, EaseInOut |
| animAnimStateTransitionCondition_AnimEnd | class | animIAnimStateTransitionCondition | eventName |
| animAnimStateTransitionCondition_AnyAnimEnd | class | animIAnimStateTransitionCondition | — |
| animAnimStateTransitionCondition_BoolEdgeFeature | class | animIAnimStateTransitionCondition | featureName, featurePropertyName |
| animAnimStateTransitionCondition_BoolFeature | class | animIAnimStateTransitionCondition | compareValue, featureName, featurePropertyName |
| animAnimStateTransitionCondition_BoolVariable | class | animIAnimStateTransitionCondition | variableName, compareValue |
| animAnimStateTransitionCondition_CompositeSimultaneous | class | animIAnimStateTransitionCondition | conditions |
| animAnimStateTransitionCondition_FloatFeature | class | animIAnimStateTransitionCondition | compareValue, featureName, featurePropertyName, compareFunc |
| animAnimStateTransitionCondition_FloatVariable | class | animIAnimStateTransitionCondition | variableName, compareValue, compareFunc |
| animAnimStateTransitionCondition_HasAnimation | class | animIAnimStateTransitionCondition | animationName |
| animAnimStateTransitionCondition_IntEdgeFeature | class | animIAnimStateTransitionCondition | featureName, featurePropertyName |
| animAnimStateTransitionCondition_IntEdgeFromToFeature | class | animAnimStateTransitionCondition_IntEdgeFeature | fromValue, toValue |
| animAnimStateTransitionCondition_IntEdgeGreaterFromZeroFeature | class | animAnimStateTransitionCondition_IntEdgeFeature | greaterThenValue |
| animAnimStateTransitionCondition_IntEdgeToFeature | class | animAnimStateTransitionCondition_IntEdgeFeature | toValue |
| animAnimStateTransitionCondition_IntFeature | class | animIAnimStateTransitionCondition | compareValue, featureName, featurePropertyName, compareFunc |
| animAnimStateTransitionCondition_IntVariable | class | animIAnimStateTransitionCondition | variableName, compareValue, compareFunc |
| animAnimStateTransitionCondition_ModifiedFloatVariable | class | animIAnimStateTransitionCondition | variableName, compareValue, compareFunc |
| animAnimStateTransitionCondition_Timed | class | animIAnimStateTransitionCondition | timeToFireTransition |
| animAnimStateTransitionDescription | class | ISerializable | targetStateIndex, condition, isEnabled, interpolator, duration |
| animAnimStateTransitionInterpolator_Blend | class | animIAnimStateTransitionInterpolator | interpolationType |
| animIAnimStateTransitionCondition | class | ISerializable | — |
| animIAnimStateTransitionInterpolator | class | ISerializable | — |
| animLocoStateType | enum | — | LS_Pre, LS_Loop |
| animStateTag | enum | — | ST_Invalid, Idle, Cover |

# Citations

- `codeware/scripts/Base/Imports/animAnimGraphDebugState.reds`
- `codeware/scripts/Base/Imports/animAnimNodeDebugState.reds`
- `codeware/scripts/Base/Imports/animAnimNode_LocoState.reds`
- `codeware/scripts/Base/Imports/animAnimNode_State.reds`
- `codeware/scripts/Base/Imports/animAnimNode_StateFrozen.reds`
- `codeware/scripts/Base/Imports/animAnimNode_StateMachine.reds`
- `codeware/scripts/Base/Imports/animAnimStateInterpolationType.reds`
- `codeware/scripts/Base/Imports/animAnimStateTransitionCondition_AnimEnd.reds`
- `codeware/scripts/Base/Imports/animAnimStateTransitionCondition_AnyAnimEnd.reds`
- `codeware/scripts/Base/Imports/animAnimStateTransitionCondition_BoolEdgeFeature.reds`
- ... and 20 more source files
