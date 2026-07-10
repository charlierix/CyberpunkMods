---
type: "Import"
title: "Animation Events"
description: "Imported animation events types (9 types)."
resource: "codeware/scripts/"
tags: "[imports, events]"
timestamp: 2026-07-01T18:09:04Z
---

# Overview

Imported animation events types (9 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animAnimEvent | class | ISerializable | startFrame, durationInFrames, eventName |
| animAnimFeatureEvent | struct | — | — |
| animAnimGraphExternalEvent | class | ISerializable | eventName |
| animAnimNode_Event | class | animAnimNode_FloatValue | eventName, defaultValue, eventValue |
| animAnimNode_LocomotionAdjusterOnEvent | class | animAnimNode_LocomotionAdjuster | locomotionFeatureName, targetAnimationName, startAdjustmentAfterAnimEvent |
| animAnimStateTransitionCondition_AnimEvent | class | animIAnimStateTransitionCondition | eventName |
| animAnimStateTransitionCondition_ExternalEvent | class | animIAnimStateTransitionCondition | eventName |
| animAnimStateTransitionCondition_FootPhaseEvent | class | animIAnimStateTransitionCondition | footPhase |
| animSyncMethodByEvent | class | animISyncMethod | eventName |

# Citations

- `codeware/scripts/Base/Imports/animAnimEvent.reds`
- `codeware/scripts/Base/Imports/animAnimFeatureEvent.reds`
- `codeware/scripts/Base/Imports/animAnimGraphExternalEvent.reds`
- `codeware/scripts/Base/Imports/animAnimNode_Event.reds`
- `codeware/scripts/Base/Imports/animAnimNode_LocomotionAdjusterOnEvent.reds`
- `codeware/scripts/Base/Imports/animAnimStateTransitionCondition_AnimEvent.reds`
- `codeware/scripts/Base/Imports/animAnimStateTransitionCondition_ExternalEvent.reds`
- `codeware/scripts/Base/Imports/animAnimStateTransitionCondition_FootPhaseEvent.reds`
- `codeware/scripts/Base/Imports/animSyncMethodByEvent.reds`
