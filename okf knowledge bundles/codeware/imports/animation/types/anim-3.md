---
type: "Import"
title: "Animation Types/Anim 3"
description: "Imported animation types/anim 3 types (80 types)."
resource: "codeware/scripts/"
tags: "[imports, anim-3]"
timestamp: 2026-07-01T18:09:01Z
---

# Overview

Imported animation types/anim 3 types (80 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animAnimNode_LocomotionAdjuster | class | animAnimNode_OnePoseInput | targetPosition, targetDirection, initialForwardVector, blendSpeedPos, blendSpeedPosMin |
| animAnimNode_LocomotionMachine | class | animAnimNode_StateMachine | usePlanner, group, logic, requestId, distance |
| animAnimNode_LocomotionSwitch | class | animAnimNode_Switch | audioTagsPerInput |
| animAnimNode_LookAt | class | animAnimNode_OnePoseInput | transform, forwardAxis, useLimits, limitAxis, limitAngle |
| animAnimNode_LookAtApplyVehicleRestrictions | class | animAnimNode_OnePoseInput | group, name, referenceBone |
| animAnimNode_LookAtPose360 | class | animAnimNode_Base | speedInDegreesPerSecond, angleOffsetNode, targetAngleOffsetNode, weightNode, animEndEventName |
| animAnimNode_LookAtPose360Direction | class | animAnimNode_FloatValue | angleOffset, defaultValue, negateOutput |
| animAnimNode_MaskReset | class | animAnimNode_OnePoseInput | weightNode, transforms |
| animAnimNode_MathExpressionFloat | class | animAnimNode_FloatValue | expressionData |
| animAnimNode_MathExpressionPose | class | animAnimNode_OnePoseInput | expressionData, outputFloatTrack |
| animAnimNode_MathExpressionQuaternion | class | animAnimNode_QuaternionValue | expressionData |
| animAnimNode_MathExpressionVector | class | animAnimNode_VectorValue | expressionData |
| animAnimNode_MixerSlot | class | animAnimNode_OnePoseInput | maxNormalAnimEntriesCount, maxAdditiveAnimEntriesCount, maxOverrideAnimEntriesCount |
| animAnimNode_MotionAdjuster | class | animAnimNode_Base | inputNode, targetPosition, targetDirection, totalTimeToAdjust, forwardVector |
| animAnimNode_MotionTableSwitch | class | animAnimNode_Base | — |
| animAnimNode_MultiBoolToFloatValue | class | animAnimNode_FloatValue | allMustBeTrue, onTrue, onFalse, inputsData |
| animAnimNode_MultipleParentConstraint | class | animAnimNode_OnePoseInput | parentsTransform, parentsWeight, areSourceChannelsResaved, parentsTransforms, transformIndex |
| animAnimNode_MultipleParentConstraint_ParentInfo | struct | — | parentTransform, parentStaticWeight, useComplementWeight, offset |
| animAnimNode_NPCExploration | class | animAnimNode_Base | — |
| animAnimNode_NameHashConstant | class | animAnimNode_IntValue | value |
| animAnimNode_OnePoseInput | class | animAnimNode_Base | inputLink |
| animAnimNode_OrientConstraint | class | animAnimNode_OnePoseInput | areSourceChannelsResaved, inputTransforms, preprocessedWeights, inputWeightedTransforms, transformIndex |
| animAnimNode_OrientConstraint_WeightedTransform | struct | — | transform |
| animAnimNode_Output | class | animAnimNode_Base | node |
| animAnimNode_ParentConstraint | class | animAnimNode_OnePoseInput | parentTransform, isParentTransformResaved, parentTransformIndex, transformIndex, interpolationType |
| animAnimNode_ParentTransform | class | animAnimNode_OnePoseInput | mapping |
| animAnimNode_PointConstraint | class | animAnimNode_OnePoseInput | areSourceChannelsResaved, inputTransforms, preprocessedWeights, inputWeightedTransforms, transformIndex |
| animAnimNode_PointConstraint_WeightedTransform | struct | — | transform |
| animAnimNode_Pose360 | class | animAnimNode_Base | angle, animation |
| animAnimNode_PoseCorrection | class | animAnimNode_OnePoseInput | — |
| animAnimNode_PoseLsToMs | class | animAnimNode_OnePoseInput | — |
| animAnimNode_PoseMsToLs | class | animAnimNode_OnePoseInput | — |
| animAnimNode_PostProcess_Footlock | class | animIAnimNode_PostProcess | — |
| animAnimNode_QuaternionConstant | class | animAnimNode_QuaternionValue | value |
| animAnimNode_QuaternionInput | class | animAnimNode_QuaternionValue | group, name |
| animAnimNode_QuaternionInterpolation | class | animAnimNode_QuaternionValue | interpolationType, firstInput, secondInput, weight |
| animAnimNode_QuaternionJoin | class | animAnimNode_QuaternionValue | input |
| animAnimNode_QuaternionLatch | class | animAnimNode_QuaternionValue | input |
| animAnimNode_QuaternionValue | class | animAnimNode_Base | — |
| animAnimNode_QuaternionVariable | class | animAnimNode_QuaternionValue | variableName |
| animAnimNode_QuaternionWsToMs | class | animAnimNode_QuaternionValue | quaternionWs |
| animAnimNode_RagdollControl | class | animAnimNode_Base | blendInDuration, blendOutDuration, inputPoseNode |
| animAnimNode_RagdollPose | class | animAnimNode_Base | — |
| animAnimNode_ReferencePoseTerminator | class | animAnimNode_Base | — |
| animAnimNode_Retarget | class | animAnimNode_OnePoseInput | refRig, postProcess |
| animAnimNode_Root | class | animAnimNode_Container | outputNode |
| animAnimNode_RotateBone | class | animAnimNode_Base | inputNode, angleNode, minValueNode, maxValueNode, bone |
| animAnimNode_RotateBoneByQuaternion | class | animAnimNode_Base | inputNode, quaternionNode, bone, useIncrementalMode, resetOnActivation |
| animAnimNode_RotationLimit | class | animAnimNode_OnePoseInput | constrainedTransform, limitOnX, limitOnY, limitOnZ, useEyesLookAtBlendWeight |
| animAnimNode_RuntimeSwitch | class | animAnimNode_Base | condition, True, False |
| animAnimNode_SelectiveJoin | class | animAnimNode_OnePoseInput | — |
| animAnimNode_Sermo | class | animAnimNode_OnePoseInput | — |
| animAnimNode_SetBoneOrientation | class | animAnimNode_OnePoseInput | bone, orientationMs |
| animAnimNode_SetBonePosition | class | animAnimNode_OnePoseInput | bone, positionMs |
| animAnimNode_SetBoneTransform | class | animAnimNode_OnePoseInput | entries |
| animAnimNode_SetDrivenKey | class | animAnimNode_Base | inputLink, provider |
| animAnimNode_SetDrivenKey_InternalsEChannelType | enum | — | FloatTrack, TransX, TransY, TransZ, RotEulZ_Pitch |
| animAnimNode_SetRequiredDistanceCategory | class | animAnimNode_OnePoseInput | requiredQualityDistanceCategory |
| animAnimNode_SetRequiredDistanceCategoryByBone | class | animAnimNode_OnePoseInput | bone |
| animAnimNode_SetTrackRange | class | animAnimNode_OnePoseInput | min, max, oldMin, oldMax, minLink |
| animAnimNode_SharedMetaPose | class | animAnimNode_OnePoseInput | weightLink |
| animAnimNode_SharedMetaPoseAdditive | class | animAnimNode_OnePoseInput | weightLink, additiveType, blendTracks, convertParentPoseToAdditive |
| animAnimNode_Signal | class | animAnimNode_FloatValue | blendIn, blendOut, startEvent, endEvent, defaultState |
| animAnimNode_SimpleBounce | class | animAnimNode_OnePoseInput | areChannelsResaved, outputDriverTrack, debug, startTransform, endTransform |
| animAnimNode_SimpleSpline | class | animAnimNode_OnePoseInput | areSourceChannelsResaved, startTransform, middleTransform, endTransform, constrainedTransform |
| animAnimNode_SkAnim | class | animAnimNode_Base | animation, applyMotion, isLooped, resume, collectEvents |
| animAnimNode_SkAnimAdjuster | class | animAnimNode_SkAnim | targetPositionWs, targetDirectionWs, initialForwardVector, startAdjustmentEventName, endAdjustmentEventName |
| animAnimNode_SkAnimContinue | class | animAnimNode_SkAnim | Input, popSafeCutTag |
| animAnimNode_SkAnimDecorator | class | animAnimNode_SkAnim | Fallback |
| animAnimNode_SkAnimSlot | class | animAnimNode_SkAnim | forFacialIdle |
| animAnimNode_SkDurationAnim | class | animAnimNode_SkAnim | Duration |
| animAnimNode_SkFrameAnim | class | animAnimNode_SkAnim | progressLink, timeLink, frameLink, fireAnimEndOnceOnAnimEnd |
| animAnimNode_SkFrameAnimByTrack | class | animAnimNode_SkFrameAnim | progressFloatTrack, timeFloatTrack, frameFloatTrack, inputWithTracks |
| animAnimNode_SkOneShotAnim | class | animAnimNode_SkAnim | Input, blendIn, blendOut |
| animAnimNode_SkPhaseAnim | class | animAnimNode_SkAnim | phase |
| animAnimNode_SkPhaseSlotWithDurationAnim | class | animAnimNode_SkPhaseWithDurationAnim | animFeatureName, actionAnimDatabaseRef |
| animAnimNode_SkPhaseWithDurationAnim | class | animAnimNode_SkPhaseAnim | durationLink |
| animAnimNode_SkPhaseWithSpeedAnim | class | animAnimNode_SkPhaseAnim | speedLink |
| animAnimNode_SkSpeedAnim | class | animAnimNode_SkAnim | Speed |
| animAnimNode_SkSyncedMasterAnim | class | animAnimNode_SkSpeedAnim | syncTag |

# Citations

- `codeware/scripts/Base/Imports/animAnimNode_LocomotionAdjuster.reds`
- `codeware/scripts/Base/Imports/animAnimNode_LocomotionMachine.reds`
- `codeware/scripts/Base/Imports/animAnimNode_LocomotionSwitch.reds`
- `codeware/scripts/Base/Imports/animAnimNode_LookAt.reds`
- `codeware/scripts/Base/Imports/animAnimNode_LookAtApplyVehicleRestrictions.reds`
- `codeware/scripts/Base/Imports/animAnimNode_LookAtPose360.reds`
- `codeware/scripts/Base/Imports/animAnimNode_LookAtPose360Direction.reds`
- `codeware/scripts/Base/Imports/animAnimNode_MaskReset.reds`
- `codeware/scripts/Base/Imports/animAnimNode_MathExpressionFloat.reds`
- `codeware/scripts/Base/Imports/animAnimNode_MathExpressionPose.reds`
- ... and 70 more source files
