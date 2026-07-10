---
type: "Import"
title: "Animation Types/Anim 1"
description: "Imported animation types/anim 1 types (80 types)."
resource: "codeware/scripts/"
tags: "[imports, anim-1]"
timestamp: 2026-07-01T18:09:01Z
---

# Overview

Imported animation types/anim 1 types (80 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animAnimEventGenderAlt | enum | — | None, Female, Male |
| animAnimEvent_Effect | class | animAnimEvent | effectName |
| animAnimEvent_EffectDuration | class | animAnimEvent | effectName, sequenceShift, breakAllLoopsOnStop |
| animAnimEvent_FoleyAction | class | animAnimEvent | actionName |
| animAnimEvent_FootIK | class | animAnimEvent | leg |
| animAnimEvent_FootPhase | class | animAnimEvent | phase |
| animAnimEvent_FootPlant | class | animAnimEvent | side, customEvent |
| animAnimEvent_ForceRagdoll | class | animAnimEvent | — |
| animAnimEvent_GameplayVo | class | animAnimEvent | voContext, isQuest |
| animAnimEvent_ItemEffect | class | animAnimEvent | effectName |
| animAnimEvent_ItemEffectDuration | class | animAnimEvent | effectName, sequenceShift, breakAllLoopsOnStop |
| animAnimEvent_KeyPose | class | animAnimEvent | — |
| animAnimEvent_Phase | class | animAnimEvent | — |
| animAnimEvent_SafeCut | class | animAnimEvent | — |
| animAnimEvent_SceneItem | class | animAnimEvent | boneName |
| animAnimEvent_Simple | class | animAnimEvent | — |
| animAnimEvent_SimpleDuration | class | animAnimEvent | — |
| animAnimEvent_Slide | class | animAnimEvent | — |
| animAnimEvent_Sound | class | animAnimEvent | switches, params, dynamicParams, metadataContext, onlyPlayOn |
| animAnimEvent_SoundFromEmitter | class | animAnimEvent | emitterName |
| animAnimEvent_TrajectoryAdjustment | class | animAnimEvent | — |
| animAnimEvent_Valued | class | animAnimEvent | value |
| animAnimEvent_WorkspotFastExitCutoff | class | animAnimEvent | — |
| animAnimEvent_WorkspotItem | class | animAnimEvent | actions |
| animAnimEvent_WorkspotPlayFacialAnim | class | animAnimEvent | facialAnimName |
| animAnimFallbackFrameDesc | struct | — | mPositions, mFloatTracks |
| animAnimFeatureUpdateWorkspot | class | AnimFeature | animName, recordID, updateCounter, boolsAsFlags, animBlendTime |
| animAnimFeature_AIActionAnimation | class | AnimFeature_AIAction | animFeatureName |
| animAnimFeature_Crowd | class | AnimFeature | stopType, speedType, speedOverrideType, bumpDirection, threatSource |
| animAnimFeature_CrowdLocomotion | class | AnimFeature | speed, slopeAngle, isCrowd |
| animAnimFeature_DangleExternalInput | class | AnimFeature | fictitiousAccelerationWs |
| animAnimFeature_EditorOnlyPredictiveLookAt | class | AnimFeature | isEnabled, target, suppress, mode |
| animAnimFeature_Interaction | class | AnimFeature | interactionDuration, interactionStage |
| animAnimFeature_NPCExploration | class | AnimFeature | explorationType, state, movementType, isEvenLoop, playbackTime |
| animAnimFeature_SmartObject | class | AnimFeature | state, privateAnimationName |
| animAnimFeature_VehiclePassengerAnimSetup | class | AnimFeature | enableAdditiveAnim, additiveScale |
| animAnimFeature_WeaponUser | class | AnimFeature | ikLeftHandLocalPosition, ikRightHandLocalPosition |
| animAnimGraph | class | CResource | rootNode, variables, animFeatures, timeDeltaMultiplier, isPaused |
| animAnimMathExpressionFloatSocket | struct | — | link, inputFloatTrack |
| animAnimMathExpressionQuaternionSocket | struct | — | link |
| animAnimMathExpressionVectorSocket | struct | — | link |
| animAnimNodeSourceChannel_AnimFeatureQsTransform | class | animIAnimNodeSourceChannel_QsTransform | — |
| animAnimNodeSourceChannel_AnimFeatureQuat | class | animIAnimNodeSourceChannel_Quat | — |
| animAnimNodeSourceChannel_AnimFeatureVector | class | animIAnimNodeSourceChannel_Vector | — |
| animAnimNodeSourceChannel_FloatTrack | class | animIAnimNodeSourceChannel_Float | floatTrack, useComplementValue |
| animAnimNodeSourceChannel_OrientationVector | class | animIAnimNodeSourceChannel_Vector | transformIndex, inputTransformIndex, up |
| animAnimNodeSourceChannel_ReferenceTransformVector | class | animIAnimNodeSourceChannel_Vector | transformIndex |
| animAnimNodeSourceChannel_SocketQsTransform | class | animIAnimNodeSourceChannel_QsTransform | — |
| animAnimNodeSourceChannel_SocketQuat | class | animIAnimNodeSourceChannel_Quat | — |
| animAnimNodeSourceChannel_SocketVector | class | animIAnimNodeSourceChannel_Vector | — |
| animAnimNodeSourceChannel_StaticQsTransform | class | animIAnimNodeSourceChannel_QsTransform | data |
| animAnimNodeSourceChannel_StaticQuat | class | animIAnimNodeSourceChannel_Quat | data |
| animAnimNodeSourceChannel_StaticVector | class | animIAnimNodeSourceChannel_Vector | data |
| animAnimNodeSourceChannel_TransformQsTransform | class | animIAnimNodeSourceChannel_QsTransform | transformIndex |
| animAnimNodeSourceChannel_TransformQuat | class | animIAnimNodeSourceChannel_Quat | transformIndex |
| animAnimNodeSourceChannel_TransformVector | class | animIAnimNodeSourceChannel_Vector | transformIndex |
| animAnimNodeSourceChannel_WeightedQsTransform | class | ISerializable | channel, weight |
| animAnimNodeSourceChannel_WeightedQuat | class | ISerializable | channel, weight, weightLink, weightFloatTrack |
| animAnimNodeSourceChannel_WeightedVector | class | ISerializable | channel, weight, weightLink, weightFloatTrack |
| animAnimNode_AdditionalFloatTrack | class | animAnimNode_Base | poseInputNode, additionalTracks |
| animAnimNode_AdditionalTransform | class | animAnimNode_OnePoseInput | additionalTransforms |
| animAnimNode_AimConstraint | class | animAnimNode_OnePoseInput | areSourceChannelsResaved, targetTransforms, targetTransform, upTransform, transformIndex |
| animAnimNode_AimConstraint_ObjectRotationUp | class | animAnimNode_OnePoseInput | targetTransform, upTransform, upTransformVector, transformIndex, forwardAxisLS |
| animAnimNode_AimConstraint_ObjectUp | class | animAnimNode_OnePoseInput | targetTransform, upTransform, transformIndex, forwardAxisLS, upAxisLS |
| animAnimNode_AnimSetTagValue | class | animAnimNode_FloatValue | tags |
| animAnimNode_AnimSlot | class | animAnimNode_Base | inputLink |
| animAnimNode_ApplyCorrectivePoseRBF | class | animAnimNode_OnePoseInput | rbfCoefficient, rbfPowValue, correctiveFrame, correctives |
| animAnimNode_Base | class | ISerializable | id |
| animAnimNode_BaseSwitch | class | animAnimNode_Base | blendTime, timeWarpingEnabled, syncMethod, inputNodes, canRequestInertialization |
| animAnimNode_Blend2 | class | animAnimNode_Base | minInputValue, maxInputValue, timeWarpingEnabled, syncMethod, firstInputNode |
| animAnimNode_BlendAdditive | class | animAnimNode_Base | biasValue, scaleValue, additiveType, timeWarpingEnabled, blendTracks |
| animAnimNode_BlendByMaskDynamic | class | animAnimNode_Base | base, blend, mask, weight, masks |
| animAnimNode_BlendFromPose | class | animAnimNode_OnePoseInput | blendTime, blendType, customBlendCurve, mode, requestedByTag |
| animAnimNode_BlendMultiple | class | animAnimNode_Base | inputValues, sortedInputValues, minWeight, maxWeight, radialBlending |
| animAnimNode_BlendOverride | class | animAnimNode_Base | inputNode, overrideInputNode, weightNode, bones, blendAllTracks |
| animAnimNode_BlendSpace | class | animAnimNode_Base | inputLinks, blendSpace, progressLink, fireAnimEndEvent, animEndEventName |
| animAnimNode_BlendSpace_InternalsBlendSpace | struct | — | spaceDimension, spacePoints, fireAnimEndEvent, isLooped, wasRuntimeTriangulationResaveDone |
| animAnimNode_BlendSpace_InternalsBlendSpaceCoordinateDescription | struct | — | name, maxValue |
| animAnimNode_BlendSpace_InternalsBlendSpacePoint | struct | — | animationName, fixedCoordinates, staticPoseTime |
| animAnimNode_BoolConstant | class | animAnimNode_BoolValue | value |

# Citations

- `codeware/scripts/Base/Imports/animAnimEventGenderAlt.reds`
- `codeware/scripts/Base/Imports/animAnimEvent_Effect.reds`
- `codeware/scripts/Base/Imports/animAnimEvent_EffectDuration.reds`
- `codeware/scripts/Base/Imports/animAnimEvent_FoleyAction.reds`
- `codeware/scripts/Base/Imports/animAnimEvent_FootIK.reds`
- `codeware/scripts/Base/Imports/animAnimEvent_FootPhase.reds`
- `codeware/scripts/Base/Imports/animAnimEvent_FootPlant.reds`
- `codeware/scripts/Base/Imports/animAnimEvent_ForceRagdoll.reds`
- `codeware/scripts/Base/Imports/animAnimEvent_GameplayVo.reds`
- `codeware/scripts/Base/Imports/animAnimEvent_ItemEffect.reds`
- ... and 70 more source files
