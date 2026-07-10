---
type: "Import"
title: "Gpu Types"
description: "Imported game engine types in the gpu domain (12 types)."
resource: "codeware/scripts/"
tags: "[imports, gpu]"
timestamp: 2026-07-01T18:09:15Z
---

# Overview

Imported game engine types in the gpu domain (12 types).

# Member Types

| Type | Kind | Bases | Key Members |
|------|------|-------|-------------|
| GpuApieBufferUsageType | enum | — | BUT_Default, BUT_Immutable, BUT_Readback, BUT_Dynamic_Legacy, BUT_Transient |
| GpuWrapApiBufferGroup | enum | — | System, MeshResource, MeshCustom, AutoSpawner, Debug |
| GpuWrapApiVertexLayoutDesc | struct | — | elements, slotMask |
| GpuWrapApiVertexPackingEStreamType | enum | — | ST_Invalid, ST_PerVertex, ST_PerInstance, ST_Max |
| GpuWrapApiVertexPackingPackingElement | struct | — | type, usageIndex, streamType |
| GpuWrapApiVertexPackingePackingType | enum | — | PT_Invalid, PT_Float1, PT_Float2, PT_Float3, PT_Float4 |
| GpuWrapApiVertexPackingePackingUsage | enum | — | PS_Invalid, PS_SysPosition, PS_Position, PS_Normal, PS_Tangent |
| GpuWrapApieBufferChunkCategory | enum | — | BCC_Staging, BCC_Vertex, BCC_VertexUAV, BCC_Index16Bit, BCC_Index32Bit |
| GpuWrapApieIndexBufferChunkType | enum | — | IBCT_IndexUInt, IBCT_IndexUShort, IBCT_Max |
| GpuWrapApieTextureFormat | enum | — | TEXFMT_A8_Unorm, TEXFMT_R8_Unorm, TEXFMT_L8_Unorm, TEXFMT_R8G8_Unorm, TEXFMT_R8G8B8X8_Unorm |
| GpuWrapApieTextureGroup | enum | — | TEXG_Generic_Color, TEXG_Generic_Grayscale, TEXG_Generic_Normal, TEXG_Generic_Data, TEXG_Generic_UI |
| GpuWrapApieTextureType | enum | — | TEXTYPE_2D, TEXTYPE_CUBE, TEXTYPE_ARRAY, TEXTYPE_3D |

# Citations

- `codeware/scripts/Base/Imports/GpuApieBufferUsageType.reds`
- `codeware/scripts/Base/Imports/GpuWrapApiBufferGroup.reds`
- `codeware/scripts/Base/Imports/GpuWrapApiVertexLayoutDesc.reds`
- `codeware/scripts/Base/Imports/GpuWrapApiVertexPackingEStreamType.reds`
- `codeware/scripts/Base/Imports/GpuWrapApiVertexPackingPackingElement.reds`
- `codeware/scripts/Base/Imports/GpuWrapApiVertexPackingePackingType.reds`
- `codeware/scripts/Base/Imports/GpuWrapApiVertexPackingePackingUsage.reds`
- `codeware/scripts/Base/Imports/GpuWrapApieBufferChunkCategory.reds`
- `codeware/scripts/Base/Imports/GpuWrapApieIndexBufferChunkType.reds`
- `codeware/scripts/Base/Imports/GpuWrapApieTextureFormat.reds`
- ... and 2 more source files
