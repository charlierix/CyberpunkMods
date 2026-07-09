---
type: "Import"
title: "Animation Data"
description: "Imported animation data types (32 types)."
resource: "codeware/scripts/"
tags: "[imports, data]"
timestamp: 2026-07-01T18:09:03Z
---

# Overview

Imported animation data types (32 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| AnimDataChanged | class | Event | — |
| animActionAnimDatabase | class | CResource | rows |
| animActionAnimDatabase_AnimationData | struct | — | animationName, inTransitionDuration, outTransitionDuration, streamingContext |
| animActionAnimDatabase_DatabaseRow | struct | — | animFeatureName, animVariation |
| animAnimDataAddress | struct | — | unkIndex, zeInBytes |
| animAnimDataChunk | struct | — | — |
| animAnimDatabaseCollection | struct | — | animDatabases |
| animAnimDatabaseCollectionEntry | struct | — | name, overrideAnimDatabase |
| animAnimNode_AnimDatabase | class | animAnimNode_SkPhaseWithDurationAnim | animDataBase, inputLinks |
| animAnimNode_GenerateIkAnimFeatureData | class | animAnimNode_OnePoseInput | ikChainSettings |
| animAnimProfileData_RootItem | class | ISerializable | timeMS, children |
| animAnimProfilerData_SectionTimings | struct | — | sectionName, sampleTimeMS |
| animAnimProfilerData_Timings | struct | — | className, avarageInclusiveTimeMS |
| animAnimProfilerData_TimingsDetailed | struct | — | className, avarageInclusiveUpdateTimeMS, avarageInclusiveSampleTimeMS, totalInclusiveUpdateTimeMS, totalInclusiveSampleTimeMS |
| animAnimProfilerData_TimingsDetailedRoot | class | ISerializable | sections, timings |
| animAnimProfilerData_TimingsRoot | class | ISerializable | timings |
| animAnimProfilerData_TreeItem | class | ISerializable | className, exclusiveTimeMS, inclusiveTimeMS, children |
| animAnimSetEntryAudioData | class | ISerializable | events |
| animFacialEmotionTransitionEditData | struct | — | toIdleMale, toIdleFemale, transitionType, toIdleNeckWeight, customTransitionAnim |
| animGenericAnimDatabase | class | CResource | rows |
| animGenericAnimDatabase_AnimationData | struct | — | animationName, streamingContext |
| animGenericAnimDatabase_DatabaseRow | struct | — | inputValues |
| animImportFacialCorrectivePoseDataDesc | struct | — | transforms, transformIds, parentsWeights |
| animMathExpressionNodeData | struct | — | expression, vectorSockets |
| animRigSharedData | class | CResource | parts, ikSetups |
| animSAnimationBufferBitwiseCompressedData | struct | — | dt, numFrames, dataAddrFallback |
| animSApplyRotationIKSolverData | struct | — | bone |
| animSBehaviorConstraintNodeFloorIKCommonData | struct | — | gravityCentreBone, verticalVelocityOffsetUpBlendTime, slidingOnSlopeBlendTime |
| animSBehaviorConstraintNodeFloorIKLegsData | struct | — | verticalOffsetBlendUpTime |
| animSBehaviorConstraintNodeFloorIKMaintainLookBoneData | struct | — | bone |
| animSBehaviorConstraintNodeFloorIKVerticalBoneData | struct | — | bone, verticalOffsetBlendTime |
| animSTwoBonesIKSolverData | struct | — | upperBone, subLowerBone, ikBone, reverseBend, autoSetupDirs |

# Citations

- `codeware/scripts/Base/Imports/AnimDataChanged.reds`
- `codeware/scripts/Base/Imports/animActionAnimDatabase.reds`
- `codeware/scripts/Base/Imports/animActionAnimDatabase_AnimationData.reds`
- `codeware/scripts/Base/Imports/animActionAnimDatabase_DatabaseRow.reds`
- `codeware/scripts/Base/Imports/animAnimDataAddress.reds`
- `codeware/scripts/Base/Imports/animAnimDataChunk.reds`
- `codeware/scripts/Base/Imports/animAnimDatabaseCollection.reds`
- `codeware/scripts/Base/Imports/animAnimDatabaseCollectionEntry.reds`
- `codeware/scripts/Base/Imports/animAnimNode_AnimDatabase.reds`
- `codeware/scripts/Base/Imports/animAnimNode_GenerateIkAnimFeatureData.reds`
- ... and 22 more source files
