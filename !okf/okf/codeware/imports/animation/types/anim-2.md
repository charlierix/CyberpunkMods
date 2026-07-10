---
type: "Import"
title: "Animation Types/Anim 2"
description: "Imported animation types/anim 2 types (80 types)."
resource: "codeware/scripts/"
tags: "[imports, anim-2]"
timestamp: 2026-07-01T18:09:01Z
---

# Overview

Imported animation types/anim 2 types (80 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animAnimNode_BoolInput | class | animAnimNode_BoolValue | group, name |
| animAnimNode_BoolJoin | class | animAnimNode_BoolValue | input |
| animAnimNode_BoolLatch | class | animAnimNode_BoolValue | input |
| animAnimNode_BoolToFloatConverter | class | animAnimNode_FloatValue | inputNode |
| animAnimNode_BoolValue | class | animAnimNode_Base | — |
| animAnimNode_BoolVariable | class | animAnimNode_BoolValue | variableName |
| animAnimNode_ConditionalSegmentBegin | class | animAnimNode_OnePoseInput | condition |
| animAnimNode_ConditionalSegmentEnd | class | animAnimNode_OnePoseInput | — |
| animAnimNode_ConeLimit | class | animAnimNode_OnePoseInput | coneTransform, constrainedTransform, coneAxisLs, coneAxisNormalizedLs, coneOffsetMs |
| animAnimNode_Container | class | animAnimNode_Base | nodes |
| animAnimNode_CoordinateFromVector | class | animAnimNode_FloatValue | vectorCoodrinateType, input |
| animAnimNode_CriticalSpringDamp | class | animAnimNode_FloatValue | smoothTime, useRange, rangeMin, rangeMax, useRawTime |
| animAnimNode_CurveFloatValue | class | animAnimNode_FloatValue | curveData, argument |
| animAnimNode_CurvePathSlot | class | animAnimNode_Base | input |
| animAnimNode_CurveVectorValue | class | animAnimNode_VectorValue | curveData, argument |
| animAnimNode_DampFloat | class | animAnimNode_FloatValue | defaultIncreaseSpeed, defaultDecreaseSpeed, startFromDefaultValue, defaultInitialValue, wrapAroundRange |
| animAnimNode_DampQuaternion | class | animAnimNode_QuaternionValue | defaultRotationSpeed, defaultInitialValue, inputNode, initialValueNode, rotationSpeedNode |
| animAnimNode_DampVector | class | animAnimNode_VectorValue | defaultIncreaseSpeed, defaultDecreaseSpeed, startFromDefaultValue, defaultInitialValue, inputNode |
| animAnimNode_Dangle | class | animAnimNode_OnePoseInput | dangleConstraint |
| animAnimNode_DirectConnConstraint | class | animAnimNode_OnePoseInput | sourceTransform, isSourceTransformResaved, sourceTransformIndex, transformIndex, posX |
| animAnimNode_DirectionToEuler | class | animAnimNode_FloatValue | inputNode, initialForwardVector, conversionType |
| animAnimNode_DisableLunaticMode | class | animAnimNode_OnePoseInput | — |
| animAnimNode_DisableSleepMode | class | animAnimNode_OnePoseInput | forceUpdate |
| animAnimNode_Drag | class | animAnimNode_OnePoseInput | sourceBone, outTargetBone, simulationFps, sourceSpeedMultiplier, hasOvershoot |
| animAnimNode_EnumSwitch | class | animAnimNode_InputSwitch | enumName |
| animAnimNode_EventValue | class | animAnimNode_FloatValue | eventName, defaultValue |
| animAnimNode_ExplorationAdjuster | class | animAnimNode_MotionAdjuster | targetPosition2, targetDirection2, totalTimeToAdjust2, targetPosition3, targetDirection3 |
| animAnimNode_EyesLookAt | class | animAnimNode_OnePoseInput | targetALink, weightALink, targetBLink, weightBLink, transitionWeightLink |
| animAnimNode_EyesReset | class | animAnimNode_OnePoseInput | — |
| animAnimNode_EyesTracksLookAt | class | animAnimNode_OnePoseInput | eyeTransform, leftTrack, rightTrack, upTrack, downTrack |
| animAnimNode_FPPCamera | class | animAnimNode_OnePoseInput | — |
| animAnimNode_FPPCameraSharedVar | class | animAnimNode_FloatValue | — |
| animAnimNode_FacialMixerSlot | class | animAnimNode_OnePoseInput | lookAtDefinitions |
| animAnimNode_FacialSharedMetaPose | class | animAnimNode_OnePoseInput | — |
| animAnimNode_FloatClamp | class | animAnimNode_FloatValue | min, max, inputNode |
| animAnimNode_FloatComparator | class | animAnimNode_FloatValue | firstValue, secondValue, trueValue, falseValue, operation |
| animAnimNode_FloatConstant | class | animAnimNode_FloatValue | value |
| animAnimNode_FloatCumulative | class | animAnimNode_FloatValue | clamp, resetOnActivation, normalize180, defaultValue, resetExternalEventName |
| animAnimNode_FloatInput | class | animAnimNode_FloatValue | group, name |
| animAnimNode_FloatInterpolation | class | animAnimNode_FloatValue | x1, x2, y1, y2, interpolationType |
| animAnimNode_FloatJoin | class | animAnimNode_FloatValue | input |
| animAnimNode_FloatLatch | class | animAnimNode_FloatValue | input |
| animAnimNode_FloatMathOp | class | animAnimNode_FloatValue | operationType, firstInputNode, secondInputNode |
| animAnimNode_FloatRandom | class | animAnimNode_FloatValue | rand, cooldown, min, max |
| animAnimNode_FloatTimeDependentSinus | class | animAnimNode_FloatValue | min, max, frequencyFactor, phaseFactor |
| animAnimNode_FloatToBoolConverter | class | animAnimNode_BoolValue | inputNode |
| animAnimNode_FloatToIntConverter | class | animAnimNode_IntValue | inputNode |
| animAnimNode_FloatTrackDirectConnConstraint | class | animAnimNode_OnePoseInput | floatTrackIndex, transformIndex, channel, mulFactor, weight |
| animAnimNode_FloatTrackModifier | class | animAnimNode_Base | floatTrack, operationType, inputFloatTrack, poseInputNode, floatInputNode |
| animAnimNode_FloatTrackModifierMarkUnstable | class | animAnimNode_FloatTrackModifier | requiredQualityDistanceCategory |
| animAnimNode_FloatValue | class | animAnimNode_Base | — |
| animAnimNode_FloatValueDebugProvider | struct | — | isEnabled, max, auto, wrap |
| animAnimNode_FloatVariable | class | animAnimNode_FloatValue | variableName |
| animAnimNode_FloorIk | class | animAnimNode_FloorIkBase | pelvis, legs, leftLegIK, rightLegIK |
| animAnimNode_FloorIkBase | class | animAnimNode_OnePoseInput | requiredAnimEvent, blockAnimEvent, canBeDisabledDueToFrameRate, useFixedVersion, slopeAngleDamp |
| animAnimNode_FootStepAdjuster | class | animAnimNode_OnePoseInput | leftToeName, rightToeName, leftFootName, rightFootName, leftCalfName |
| animAnimNode_FootStepScaling | class | animAnimNode_OnePoseInput | hipsIndex, leftFootIKIndex, rightFootIKIndex, inputSpeed, weight |
| animAnimNode_ForegroundSegmentBegin | class | animAnimNode_OnePoseInput | — |
| animAnimNode_ForegroundSegmentEnd | class | animAnimNode_OnePoseInput | isAlwaysEnabledForHighEndHardware |
| animAnimNode_FrozenFrame | class | animAnimNode_OnePoseInput | maxFramesFrozen, triggerEventName, clearEventName |
| animAnimNode_GraphSlot | class | animAnimNode_Base | name, dontDeactivateInput, inputLink |
| animAnimNode_GraphSlotConditions | class | animAnimNode_GraphSlot | conditions |
| animAnimNode_GraphSlotInput | class | animAnimNode_Base | — |
| animAnimNode_GraphSlot_Test | class | animAnimNode_GraphSlot | graph_TEST, copyAnimInputsAtAttachTime |
| animAnimNode_HumanIk | class | animAnimNode_OnePoseInput | ikTargetsControllers |
| animAnimNode_IdentityPoseTerminator | class | animAnimNode_Base | — |
| animAnimNode_Ik2 | class | animAnimNode_Base | firstBone, secondBone, endBone, hingeAxis, minHingeAngleDegrees |
| animAnimNode_Ik2Constraint | class | animAnimNode_OnePoseInput | inputTarget, inputPoleVector, inputTargetOrientation, firstBoneIndex, secondBoneIndex |
| animAnimNode_Inertialization | class | animAnimNode_OnePoseInput | safeMode, transformsCountUpperBound, tracksCountUpperBound, rotationLimits |
| animAnimNode_InputSwitch | class | animAnimNode_BaseSwitch | selectIntNode, selectFloatNode |
| animAnimNode_IntConstant | class | animAnimNode_IntValue | value |
| animAnimNode_IntInput | class | animAnimNode_IntValue | group, name |
| animAnimNode_IntJoin | class | animAnimNode_IntValue | input |
| animAnimNode_IntLatch | class | animAnimNode_IntValue | input |
| animAnimNode_IntToFloatConverter | class | animAnimNode_FloatValue | inputNode |
| animAnimNode_IntValue | class | animAnimNode_Base | — |
| animAnimNode_IntVariable | class | animAnimNode_IntValue | variableName |
| animAnimNode_Join | class | animAnimNode_Base | input |
| animAnimNode_LODBegin | class | animAnimNode_OnePoseInput | levelOfDetail |
| animAnimNode_LODEnd | class | animAnimNode_Base | inputLink |

# Citations

- `codeware/scripts/Base/Imports/animAnimNode_BoolInput.reds`
- `codeware/scripts/Base/Imports/animAnimNode_BoolJoin.reds`
- `codeware/scripts/Base/Imports/animAnimNode_BoolLatch.reds`
- `codeware/scripts/Base/Imports/animAnimNode_BoolToFloatConverter.reds`
- `codeware/scripts/Base/Imports/animAnimNode_BoolValue.reds`
- `codeware/scripts/Base/Imports/animAnimNode_BoolVariable.reds`
- `codeware/scripts/Base/Imports/animAnimNode_ConditionalSegmentBegin.reds`
- `codeware/scripts/Base/Imports/animAnimNode_ConditionalSegmentEnd.reds`
- `codeware/scripts/Base/Imports/animAnimNode_ConeLimit.reds`
- `codeware/scripts/Base/Imports/animAnimNode_Container.reds`
- ... and 70 more source files
