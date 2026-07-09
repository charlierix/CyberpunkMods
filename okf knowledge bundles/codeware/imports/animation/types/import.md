---
type: "Import"
title: "Animation Types/Import"
description: "Imported animation types/import types (9 types)."
resource: "codeware/scripts/"
tags: "[imports, import]"
timestamp: 2026-07-01T18:09:02Z
---

# Overview

Imported animation types/import types (9 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animImportFacialCorrectivePoseDesc | struct | — | influencedBy, poses, parentIndices, index, poseType |
| animImportFacialInitialControlsDesc | struct | — | transformIds, transformRegions |
| animImportFacialInitialPoseWeightDesc | struct | — | poseNames |
| animImportFacialMainPoseDesc | struct | — | influencedBy, poses, weights, name, influenceType |
| animImportFacialPoseDesc | struct | — | transforms, transformIds |
| animImportFacialSetupCombinedDesc | struct | — | face, tongue, lipsyncOverrideToMainPosesTracksMapping |
| animImportFacialSetupDesc | struct | — | initialPose, mainPoses, jawAreaTrackIndices, eyesAreaTrackIndices, correctivePoses |
| animImportFacialTransform | struct | — | rotation, scale |
| animImportFacialTransformNoScale | struct | — | rotation |

# Citations

- `codeware/scripts/Base/Imports/animImportFacialCorrectivePoseDesc.reds`
- `codeware/scripts/Base/Imports/animImportFacialInitialControlsDesc.reds`
- `codeware/scripts/Base/Imports/animImportFacialInitialPoseWeightDesc.reds`
- `codeware/scripts/Base/Imports/animImportFacialMainPoseDesc.reds`
- `codeware/scripts/Base/Imports/animImportFacialPoseDesc.reds`
- `codeware/scripts/Base/Imports/animImportFacialSetupCombinedDesc.reds`
- `codeware/scripts/Base/Imports/animImportFacialSetupDesc.reds`
- `codeware/scripts/Base/Imports/animImportFacialTransform.reds`
- `codeware/scripts/Base/Imports/animImportFacialTransformNoScale.reds`
