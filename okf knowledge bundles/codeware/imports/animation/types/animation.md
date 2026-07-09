---
type: "Import"
title: "Animation Types/Animation"
description: "Imported animation types/animation types (6 types)."
resource: "codeware/scripts/"
tags: "[imports, animation]"
timestamp: 2026-07-01T18:09:02Z
---

# Overview

Imported animation types/animation types (6 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| animAnimation | class | ISerializable | tags, name, duration, animationType, animBuffer |
| animAnimationBufferCompressed | class | animIAnimationBuffer | duration, numFrames, numExtraJoints, numExtraTracks, numJoints |
| animAnimationBufferSimd | class | animIAnimationBuffer | duration, numFrames, numExtraJoints, numExtraTracks, numJoints |
| animAnimationImportInfo | struct | — | AnimationType, CompressionPreset, MotionExtractionCompression |
| animAnimationSetup | struct | — | cinematics, finalAnimSetCollection |
| animAnimationType | enum | — | Normal, AdditiveFromRefPose, AdditiveFromFirstFrame, Additive, AdditiveWithoutFirstFrame |

# Citations

- `codeware/scripts/Base/Imports/animAnimation.reds`
- `codeware/scripts/Base/Imports/animAnimationBufferCompressed.reds`
- `codeware/scripts/Base/Imports/animAnimationBufferSimd.reds`
- `codeware/scripts/Base/Imports/animAnimationImportInfo.reds`
- `codeware/scripts/Base/Imports/animAnimationSetup.reds`
- `codeware/scripts/Base/Imports/animAnimationType.reds`
