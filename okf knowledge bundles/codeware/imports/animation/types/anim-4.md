---
type: "Import"
title: "Animation Types/Anim 4"
description: "Imported animation types/anim 4 types (54 types)."
resource: "codeware/scripts/"
tags: "[imports, anim-4]"
timestamp: 2026-07-01T18:09:01Z
---

# Overview

Imported animation types/anim 4 types (54 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animAnimNode_SkSyncedMasterAnimByTime | class | animAnimNode_SkFrameAnim | syncTag |
| animAnimNode_SkSyncedSlaveAnim | class | animAnimNode_SkAnim | syncTag |
| animAnimNode_SkipConsoleBegin | class | animAnimNode_OnePoseInput | — |
| animAnimNode_SkipConsoleEnd | class | animAnimNode_Base | inputLink |
| animAnimNode_SkipPerformanceModeBegin | class | animAnimNode_OnePoseInput | — |
| animAnimNode_SkipPerformanceModeEnd | class | animAnimNode_Base | inputLink |
| animAnimNode_SpringDamp | class | animAnimNode_FloatValue | massFactor, springFactor, dampFactor, startFromDefaultValue, defaultInitialValue |
| animAnimNode_StackTracksExtender | class | animAnimNode_OnePoseInput | tag, newTracks |
| animAnimNode_StackTracksShrinker | class | animAnimNode_OnePoseInput | tag |
| animAnimNode_StackTransformsExtender | class | animAnimNode_OnePoseInput | tag, transformInfos, snapMethods, snapToReferenceValues, snapTargetBones |
| animAnimNode_StackTransformsShrinker | class | animAnimNode_OnePoseInput | tag |
| animAnimNode_Stage | class | animAnimNode_Container | inputPoses |
| animAnimNode_StaticSwitch | class | animAnimNode_MotionTableSwitch | condition, motionProvider, True, False |
| animAnimNode_SuspensionLimit | class | animAnimNode_OnePoseInput | constrainedTransform, radiusTrack, deviationTrack, axis |
| animAnimNode_Switch | class | animAnimNode_MotionTableSwitch | numInputs, blendTime, timeWarpingEnabled, syncMethod, motionProvider |
| animAnimNode_TagSwitch | class | animAnimNode_BaseSwitch | tags |
| animAnimNode_TagValue | class | animAnimNode_FloatValue | tag, defaultValue, oneMinus |
| animAnimNode_Timer | class | animAnimNode_FloatValue | — |
| animAnimNode_TrackSetter | class | animAnimNode_OnePoseInput | track, value |
| animAnimNode_TrajectoryFromMetaPose | class | animAnimNode_OnePoseInput | metaPoseTrajectoryLs |
| animAnimNode_TransformConstant | class | animAnimNode_TransformValue | pos, rotation, scale |
| animAnimNode_TransformInterpolation | class | animAnimNode_TransformValue | interpolationType, firstInput, secondInput, weight |
| animAnimNode_TransformJoin | class | animAnimNode_TransformValue | input |
| animAnimNode_TransformLatch | class | animAnimNode_TransformValue | input |
| animAnimNode_TransformRotator | class | animAnimNode_OnePoseInput | transform, axis, valueScale, clamp, angleMin |
| animAnimNode_TransformToTrack | class | animAnimNode_OnePoseInput | floatTrack, floatTrackIndex, outputTransform, transformIndex, channel |
| animAnimNode_TransformValue | class | animAnimNode_Base | — |
| animAnimNode_TransformVariable | class | animAnimNode_TransformValue | variableName |
| animAnimNode_TranslateBone | class | animAnimNode_Base | inputNode, inputTranslation, scale, biasValue, bone |
| animAnimNode_TranslationLimit | class | animAnimNode_OnePoseInput | constrainedTransform, parentTransform, limitOnXAxis, limitOnYAxis, limitOnZAxis |
| animAnimNode_TriggerBranch | class | animAnimNode_Base | base, overlay, blendIn, blendOut, startEvent |
| animAnimNode_TwistConstraint | class | animAnimNode_OnePoseInput | frontAxis, transformA, transformB, outputs, debug |
| animAnimNode_ValueBySpeed | class | animAnimNode_FloatValue | defaultValue, clampType, rangeMin, rangeMax, resetOnActivation |
| animAnimNode_VectorConstant | class | animAnimNode_VectorValue | value |
| animAnimNode_VectorInput | class | animAnimNode_VectorValue | group, name |
| animAnimNode_VectorInterpolation | class | animAnimNode_VectorValue | firstInput, secondInput, weight |
| animAnimNode_VectorJoin | class | animAnimNode_VectorValue | input |
| animAnimNode_VectorLatch | class | animAnimNode_VectorValue | input |
| animAnimNode_VectorValue | class | animAnimNode_Base | — |
| animAnimNode_VectorVariable | class | animAnimNode_VectorValue | variableName |
| animAnimNode_VectorWsToMs | class | animAnimNode_VectorValue | type, vectorWs |
| animAnimNode_WorkspotAnim | class | animAnimNode_Base | collectEvents, inputLink |
| animAnimNode_WorkspotHub | class | animAnimNode_Base | additionalLinkIds, additionalLinks, animLoopEventName, isCoverHubHack, eventFilterType |
| animAnimSet | class | CResource | animations, animationDataChunks, fallbackDataAddresses, fallbackDataAddressIndexes, fallbackAnimFrameDescs |
| animAnimSetCollection | struct | — | animSets, animWrapperVariables |
| animAnimSetup | struct | — | cinematics, hash |
| animAnimVariable | class | ISerializable | name |
| animAnimVariableBool | class | animAnimVariable | value, default |
| animAnimVariableContainer | class | ISerializable | boolVariables, intVariables, floatVariables, vectorVariables, quaternionVariables |
| animAnimVariableFloat | class | animAnimVariable | value, default, min, max |
| animAnimVariableInt | class | animAnimVariable | value, default, min, max |
| animAnimVariableQuaternion | class | animAnimVariable | roll, pitch, yaw, default |
| animAnimVariableTransform | class | animAnimVariable | value, default |
| animAnimVariableVector | class | animAnimVariable | x, y, z, w, default |

# Citations

- `codeware/scripts/Base/Imports/animAnimNode_SkSyncedMasterAnimByTime.reds`
- `codeware/scripts/Base/Imports/animAnimNode_SkSyncedSlaveAnim.reds`
- `codeware/scripts/Base/Imports/animAnimNode_SkipConsoleBegin.reds`
- `codeware/scripts/Base/Imports/animAnimNode_SkipConsoleEnd.reds`
- `codeware/scripts/Base/Imports/animAnimNode_SkipPerformanceModeBegin.reds`
- `codeware/scripts/Base/Imports/animAnimNode_SkipPerformanceModeEnd.reds`
- `codeware/scripts/Base/Imports/animAnimNode_SpringDamp.reds`
- `codeware/scripts/Base/Imports/animAnimNode_StackTracksExtender.reds`
- `codeware/scripts/Base/Imports/animAnimNode_StackTracksShrinker.reds`
- `codeware/scripts/Base/Imports/animAnimNode_StackTransformsExtender.reds`
- ... and 44 more source files
