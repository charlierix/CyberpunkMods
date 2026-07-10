---
type: "Import"
title: "Animation Entries"
description: "Imported animation entries types (27 types)."
resource: "codeware/scripts/"
tags: "[imports, entries]"
timestamp: 2026-07-01T18:09:04Z
---

# Overview

Imported animation entries types (27 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animAdditionalFloatTrackEntry | class | ISerializable | name, trackInfo, values |
| animAdditionalTransformEntry | class | ISerializable | transformInfo, value |
| animAnimMultiBoolToFloatEntry | struct | — | group |
| animAnimNode_SetDrivenKey_InternalsEntry | struct | — | curve, outChannelName, outChanelType |
| animAnimNode_SetDrivenKey_InternalsISetDrivenKeyEntryProvider | class | ISerializable | — |
| animAnimNode_SetDrivenKey_InternalsSetDrivenKeyEntryProviderInline | class | animAnimNode_SetDrivenKey_InternalsISetDrivenKeyEntryProvider | entries |
| animAnimNode_StageFloatEntry | class | animAnimNode_FloatValue | — |
| animAnimNode_StagePoseEntry | class | animAnimNode_Base | inputName, parentInput |
| animAnimSetEntry | class | ISerializable | animation, events |
| animAnimSetupEntry | struct | — | priority, variableNames |
| animAnimStateMachineConditionalEntry | class | ISerializable | targetStateIndex, condition, isEnabled, priority, isForcedToTrue |
| animAnimTransformMappingEntry | struct | — | from |
| animCorrectivePoseEntry | struct | — | comparePose, jointsToCompare |
| animFacialCustomizationTargetEntryTemp | struct | — | setup, targetNames |
| animImportFacialInitialPoseEntryDesc | struct | — | poseName, weight, side, initAnimationPoseMid, initAnimationPoseMax |
| animLipsyncMappingSceneEntry | struct | — | actorVoiceTags |
| animMultipleParentConstraint_JsonEntry | struct | — | parentTransform, parentStaticWeight, useComplementWeight, offset |
| animPoseInfoLoggerEntry | class | ISerializable | — |
| animPoseInfoLoggerEntry_FloatTrack | class | animPoseInfoLoggerEntry | floatTrack, showOnlyWhenPositive |
| animPoseInfoLoggerEntry_Transform | class | animPoseInfoLoggerEntry | transform, logInModelSpace |
| animSetBoneTransformEntry | struct | — | transformToChange, snapToReference, offsetToReference, offset |
| animSetBoneTransformEntry_SetMethod | enum | — | NoSnapping, WholeTransform, TranslationOnly, RotationOnly |
| animSetBoneTransform_JsonEntry | struct | — | transformToChange, snapToReference, offsetToReference, offset |
| animSimpleBounceTransformOutput_ChannelEntry | struct | — | transformChannel |
| animStackTracksExtender_JsonEntry | struct | — | name |
| animStackTransformsExtender_Entry | struct | — | transformInfo, snapToReference, offsetToReference, offset |
| animStackTransformsExtender_JsonEntry | struct | — | name, referenceTransformLs, snapToReference, offsetToReference, offset |

# Citations

- `codeware/scripts/Base/Imports/animAdditionalFloatTrackEntry.reds`
- `codeware/scripts/Base/Imports/animAdditionalTransformEntry.reds`
- `codeware/scripts/Base/Imports/animAnimMultiBoolToFloatEntry.reds`
- `codeware/scripts/Base/Imports/animAnimNode_SetDrivenKey_InternalsEntry.reds`
- `codeware/scripts/Base/Imports/animAnimNode_SetDrivenKey_InternalsISetDrivenKeyEntryProvider.reds`
- `codeware/scripts/Base/Imports/animAnimNode_SetDrivenKey_InternalsSetDrivenKeyEntryProviderInline.reds`
- `codeware/scripts/Base/Imports/animAnimNode_StageFloatEntry.reds`
- `codeware/scripts/Base/Imports/animAnimNode_StagePoseEntry.reds`
- `codeware/scripts/Base/Imports/animAnimSetEntry.reds`
- `codeware/scripts/Base/Imports/animAnimSetupEntry.reds`
- ... and 17 more source files
