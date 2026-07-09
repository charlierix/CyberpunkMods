---
type: "Import"
title: "Misc Types/S"
description: "Imported misc types/s types (9 types)."
resource: "codeware/scripts/"
tags: "[imports, s]"
timestamp: 2026-07-01T18:09:19Z
---

# Overview

Imported misc types/s types (9 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| SAnimationBufferBitwiseCompression | enum | — | ABBC_None, ABBC_24b, ABBC_16b |
| SAnimationBufferBitwiseCompressionPreset | enum | — | ABBCP_Custom, ABBCP_VeryHighQuality, ABBCP_HighQuality, ABBCP_NormalQuality, ABBCP_LowQuality |
| SAnimationBufferOrientationCompressionMethod | enum | — | ABOCM_PackIn64bitsW, ABOCM_PackIn48bitsW, ABOCM_PackIn40bitsW, ABOCM_AsFloat_XYZW, ABOCM_AsFloat_XYZSignedW |
| SAnimationBufferStreamingOption | enum | — | ABSO_NonStreamable, ABSO_PartiallyStreamable, ABSO_FullyStreamable |
| SMeshChunkPacked | struct | — | vertexType, numBonesPerVertex, numIndices, firstIndex, chunkRenderMask |
| SMeshStream | struct | — | type |
| SMeshTopology | struct | — | — |
| SParticleEmitterLODLevel | struct | — | emitterDurationSettings, burstList, sortingMode, isEnabled |
| STextureGroupSetup | struct | — | group, compression, hasMipchain, platformMipBiasPC, allowTextureDowngrade |

# Citations

- `codeware/scripts/Base/Imports/SAnimationBufferBitwiseCompression.reds`
- `codeware/scripts/Base/Imports/SAnimationBufferBitwiseCompressionPreset.reds`
- `codeware/scripts/Base/Imports/SAnimationBufferOrientationCompressionMethod.reds`
- `codeware/scripts/Base/Imports/SAnimationBufferStreamingOption.reds`
- `codeware/scripts/Base/Imports/SMeshChunkPacked.reds`
- `codeware/scripts/Base/Imports/SMeshStream.reds`
- `codeware/scripts/Base/Imports/SMeshTopology.reds`
- `codeware/scripts/Base/Imports/SParticleEmitterLODLevel.reds`
- `codeware/scripts/Base/Imports/STextureGroupSetup.reds`
