---
type: "Import"
title: "Misc Types/Desc"
description: "Imported misc types/desc types (13 types)."
resource: "codeware/scripts/"
tags: "[imports, desc]"
timestamp: 2026-07-01T18:09:19Z
---

# Overview

Imported misc types/desc types (13 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| PSODescBlendModeDesc | struct | — | numTargets, alphaToCoverage |
| PSODescBlendModeFactor | enum | — | FAC_Zero, FAC_One, FAC_SrcColor, FAC_InvSrcColor, FAC_SrcAlpha |
| PSODescBlendModeOp | enum | — | OP_Add, OP_Subtract, OP_RevSub, OP_Min, OP_Max |
| PSODescBlendModeWriteMask | enum | — | MASK_None, MASK_R, MASK_G, MASK_B, MASK_A |
| PSODescDepthStencilModeComparisonMode | enum | — | COMPARISON_Never, COMPARISON_Less, COMPARISON_Equal, COMPARISON_LessEqual, COMPARISON_Greater |
| PSODescDepthStencilModeDesc | struct | — | depthTestEnable, depthFunc, stencilReadMask, frontFace |
| PSODescDepthStencilModeStencilOpMode | enum | — | STENCILOP_Keep, STENCILOP_Zero, STENCILOP_Replace, STENCILOP_IncreaseSaturate, STENCILOP_DecreaseSaturate |
| PSODescPrimitiveTopologyType | enum | — | Invalid, Point, Line, Triangle, Patch |
| PSODescRasterizerModeCullMode | enum | — | CULL_None, CULL_Front, CULL_Back |
| PSODescRasterizerModeDesc | struct | — | wireframe, cullMode, conservativeRasterization, scissors |
| PSODescRasterizerModeFrontFaceWinding | enum | — | FRONTFACE_CCW, FRONTFACE_CW |
| PSODescRasterizerModeOffsetMode | enum | — | OFFSET_None, OFFSET_NormalBias, OFFSET_ShadowBias, OFFSET_DecalBias |
| PSODescStencilFuncDesc | struct | — | stencilPassOp |

# Citations

- `codeware/scripts/Base/Imports/PSODescBlendModeDesc.reds`
- `codeware/scripts/Base/Imports/PSODescBlendModeFactor.reds`
- `codeware/scripts/Base/Imports/PSODescBlendModeOp.reds`
- `codeware/scripts/Base/Imports/PSODescBlendModeWriteMask.reds`
- `codeware/scripts/Base/Imports/PSODescDepthStencilModeComparisonMode.reds`
- `codeware/scripts/Base/Imports/PSODescDepthStencilModeDesc.reds`
- `codeware/scripts/Base/Imports/PSODescDepthStencilModeStencilOpMode.reds`
- `codeware/scripts/Base/Imports/PSODescPrimitiveTopologyType.reds`
- `codeware/scripts/Base/Imports/PSODescRasterizerModeCullMode.reds`
- `codeware/scripts/Base/Imports/PSODescRasterizerModeDesc.reds`
- ... and 3 more source files
