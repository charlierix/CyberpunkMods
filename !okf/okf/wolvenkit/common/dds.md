---
type: "System"
title: "DDS Texture Processing"
description: "DirectDraw Surface texture processing (BlockCompression, DDSUtils, headers, pixel formats, Texconv native interop) — 10 files."
resource: "WolvenKit.Common/DDS/BlockCompression.cs"
tags: [common, dds, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

DirectDraw Surface texture processing (BlockCompression, DDSUtils, headers, pixel formats, Texconv native interop) — 10 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **10 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| BlockCompression.cs | 155 | class BlockCompression, struct BC4_UNORM, enum BlockCompressionType |
| DDSUtils.cs | 261 | class DDSUtils, class DDSInfo, enum ConvertableFileTypes |
| DDS_ENUMS.cs | 227 | enum TEX_MISC_FLAG, enum TEX_MISC_FLAG2, enum TEX_DIMENSION, enum TEX_ALPHA_MODE, enum DDSFLAGS |
| DDS_HEADER.cs | 81 | struct DDS_HEADER |
| DDS_HEADER_DXT10.cs | 24 | struct DDS_HEADER_DXT10 |
| DDS_Metadata.cs | 111 | struct DDSMetadata |
| DDS_PIXELFORMAT.cs | 33 | struct DDS_PIXELFORMAT |
| MissingFormatException.cs | 28 | class MissingFormatException |
| Texconv.cs | 255 | class Texconv |
| TexconvNative.cs | 152 | class TexconvNative, class ManagedBlob, class Blob, struct TexMetadata, enum ESaveFileTypes |

## Member Types

All **10** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | BlockCompression.cs |
| 2 | DDSUtils.cs |
| 3 | DDS_ENUMS.cs |
| 4 | DDS_HEADER.cs |
| 5 | DDS_HEADER_DXT10.cs |
| 6 | DDS_Metadata.cs |
| 7 | DDS_PIXELFORMAT.cs |
| 8 | MissingFormatException.cs |
| 9 | Texconv.cs |
| 10 | TexconvNative.cs |

## Architecture

The analyzed files contain approximately **1327 lines** of code across **10 files** (of 10 total).

### Notable Types

- class Blob
- class BlockCompression
- class DDSInfo
- class DDSUtils
- class ManagedBlob
- class MissingFormatException
- class Texconv
- class TexconvNative
- enum BlockCompressionType
- enum ConvertableFileTypes
- enum D3D10_RESOURCE_DIMENSION
- enum DDSFLAGS
- enum DXGI_FORMAT
- enum ESaveFileTypes
- enum TEX_ALPHA_MODE
- enum TEX_DIMENSION
- enum TEX_MISC_FLAG
- enum TEX_MISC_FLAG2
- enum TGA_FLAGS
- struct BC4_UNORM
- struct DDSMetadata
- struct DDS_HEADER
- struct DDS_HEADER_DXT10
- struct DDS_PIXELFORMAT
- struct TexMetadata

## Dependencies

- using DirectXTexNet
- using System
- using System.Buffers
- using System.IO
- using System.Runtime.InteropServices
- using System.Runtime.Serialization
- using WolvenKit.Common.Model.Arguments
- using WolvenKit.Core.Extensions
- using WolvenKit.RED4.CR2W
- using WolvenKit.RED4.Types
- using static WolvenKit.Common.DDS.TexconvNative

## Citations

[1] Source files under `WolvenKit.Common/DDS/` in the WolvenKit repository
