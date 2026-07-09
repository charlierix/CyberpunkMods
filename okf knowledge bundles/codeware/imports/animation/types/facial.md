---
type: "Import"
title: "Animation Types/Facial"
description: "Imported animation types/facial types (8 types)."
resource: "codeware/scripts/"
tags: "[imports, facial]"
timestamp: 2026-07-01T18:09:02Z
---

# Overview

Imported animation types/facial types (8 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animFacialCustomizationSet | class | CResource | baseSetup, targetSetups, targetSetupsTemp, numTargets, posesInfo |
| animFacialEmotionTransitionBaked | struct | — | toIdleMale, toIdleFemale, transitionType, timeScale, toIdleNeckWeight |
| animFacialEmotionTransitionType | enum | — | Natural, Fast, Blend, Instant, Custom |
| animFacialSetup | class | CResource | rig, inputRig, info, posesInfo, usedTransformIndices |
| animFacialSetup_BufferInfo | struct | — | tracksMapping, numJointRegions, eyes |
| animFacialSetup_OneSermoBufferInfo | struct | — | numGlobalLimits, numInfluenceIndices, numLipsyncPosesSides, numGlobalCorrectiveEntries, numCorrectiveInfluencedPoses |
| animFacialSetup_OneSermoPoseBufferInfo | struct | — | numMainPoses, numMainTransforms, numCorrectiveTransforms |
| animFacialSetup_PosesBufferInfo | struct | — | face, eyes |

# Citations

- `codeware/scripts/Base/Imports/animFacialCustomizationSet.reds`
- `codeware/scripts/Base/Imports/animFacialEmotionTransitionBaked.reds`
- `codeware/scripts/Base/Imports/animFacialEmotionTransitionType.reds`
- `codeware/scripts/Base/Imports/animFacialSetup.reds`
- `codeware/scripts/Base/Imports/animFacialSetup_BufferInfo.reds`
- `codeware/scripts/Base/Imports/animFacialSetup_OneSermoBufferInfo.reds`
- `codeware/scripts/Base/Imports/animFacialSetup_OneSermoPoseBufferInfo.reds`
- `codeware/scripts/Base/Imports/animFacialSetup_PosesBufferInfo.reds`
