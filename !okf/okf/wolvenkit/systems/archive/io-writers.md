---
type: "System"
title: "RED4 Archive IO Writers"
description: "Buffer and file writers for RED4 archive data — 20 files."
resource: "WolvenKit.RED4/Archive/IO/AnimFacialSetupBakedDataReader.cs"
tags: [systems, archive, io, writers, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

Buffer and file writers for RED4 archive data — 20 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **51 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| AnimFacialSetupBakedDataReader.cs | 171 | class AnimFacialSetupBakedDataReader |
| AnimFacialSetupBakedDataWriter.cs | 138 | class AnimFacialSetupBakedDataWriter |
| AnimFacialSetupCorrectivePosesDataReader.cs | 89 | class AnimFacialSetupCorrectivePosesDataReader |
| AnimFacialSetupCorrectivePosesDataWriter.cs | 67 | class AnimFacialSetupCorrectivePosesDataWriter |
| AnimFacialSetupMainPosesDataReader.cs | 89 | class AnimFacialSetupMainPosesDataReader |
| AnimFacialSetupMainPosesDataWriter.cs | 67 | class AnimFacialSetupMainPosesDataWriter |
| AnimationReader.cs | 55 | class AnimationReader |
| ArchiveReader.cs | 258 | class ArchiveReader |
| ArchiveWriter.cs | 289 | class ArchiveWriter, record FileInfoEntry |
| CGIDataReader.cs | 198 | class CGIDataReader |
| CR2WListReader.cs | 65 | class CR2WListReader |
| CR2WListWriter.cs | 75 | class CR2WListWriter |
| CR2WReader.File.cs | 330 | class CR2WReader |
| CR2WReader.cs | 246 | class CR2WReader |
| CR2WWrapperReader.cs | 53 | class CR2WWrapperReader |
| CR2WWrapperWriter.cs | 44 | class CR2WWrapperWriter |
| CR2WWriter.File.cs | 326 | class CR2WWriter |
| CR2WWriter.cs | 80 | class CR2WWriter |
| CollisionReader.cs | 207 | class CollisionReader |
| CollisionWriter.cs | 226 | class CollisionWriter |

## Member Types

All **51** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | AnimFacialSetupBakedDataReader.cs |
| 2 | AnimFacialSetupBakedDataWriter.cs |
| 3 | AnimFacialSetupCorrectivePosesDataReader.cs |
| 4 | AnimFacialSetupCorrectivePosesDataWriter.cs |
| 5 | AnimFacialSetupMainPosesDataReader.cs |
| 6 | AnimFacialSetupMainPosesDataWriter.cs |
| 7 | AnimationReader.cs |
| 8 | ArchiveReader.cs |
| 9 | ArchiveWriter.cs |
| 10 | CGIDataReader.cs |
| 11 | CR2WListReader.cs |
| 12 | CR2WListWriter.cs |
| 13 | CR2WReader.File.cs |
| 14 | CR2WReader.cs |
| 15 | CR2WWrapperReader.cs |
| 16 | CR2WWrapperWriter.cs |
| 17 | CR2WWriter.File.cs |
| 18 | CR2WWriter.cs |
| 19 | CollisionReader.cs |
| 20 | CollisionWriter.cs |
| 21 | CookedInstanceTransformsReader.cs |
| 22 | CookedInstanceTransformsWriter.cs |
| 23 | Enums.cs |
| 24 | FoliageReader.cs |
| 25 | FoliageWriter.cs |
| 26 | IBufferReader.cs |
| 27 | IProcessor.cs |
| 28 | ModifiersBufferReader.cs |
| 29 | ModifiersBufferWriter.cs |
| 30 | CMeshPreProcessor.cs |
| 31 | appearanceAppearanceDefinitionPreProcessor.cs |
| 32 | entEntityTemplatePreProcessor.cs |
| 33 | PxCollectionWriter.cs |
| 34 | RazerChromaAnimationBufferReader.cs |
| 35 | RazerChromaAnimationBufferWriter.cs |
| 36 | RedPackageReader.File.cs |
| 37 | RedPackageReader.cs |
| 38 | RedPackageWriter.File.cs |
| 39 | RedPackageWriter.cs |
| 40 | SavedModifierGroupStatTypesBufferReader.cs |
| 41 | SavedModifierGroupStatTypesBufferWriter.cs |
| 42 | ShaderCacheReader.cs |
| 43 | TilesReader.cs |
| 44 | WorldSharedDataBufferReader.cs |
| 45 | WorldTransformsReader.cs |
| 46 | WorldTransformsWriter.cs |
| 47 | appearanceAppearanceDefinitionReader.cs |
| 48 | appearanceAppearanceDefinitionWriter.cs |
| 49 | entEntityTemplateReader.cs |
| 50 | worldNodeDataReader.cs |
| 51 | worldNodeDataWriter.cs |

## Architecture

The analyzed files contain approximately **3726 lines** of code across **30 files** (of 51 total).

### Notable Types

- class AnimFacialSetupBakedDataReader
- class AnimFacialSetupBakedDataWriter
- class AnimFacialSetupCorrectivePosesDataReader
- class AnimFacialSetupCorrectivePosesDataWriter
- class AnimFacialSetupMainPosesDataReader
- class AnimFacialSetupMainPosesDataWriter
- class AnimationReader
- class ArchiveReader
- class ArchiveWriter
- class CGIDataReader
- class CMeshPreProcessor
- class CR2WListReader
- class CR2WListWriter
- class CR2WReader
- class CR2WWrapperReader
- class CR2WWrapperWriter
- class CR2WWriter
- class CollisionReader
- class CollisionWriter
- class CookedInstanceTransformsWriter
- class FoliageReader
- class FoliageWriter
- class ModifiersBufferReader
- class ModifiersBufferWriter
- class WorldSharedDataBufferReader
- enum EFileReadErrorCodes
- enum EHashVersion
- interface IBufferReader
- interface IPreProcessor
- record FileInfoEntry

## Dependencies

- using System.Security.Cryptography
- using System.Text
- using System.Text.RegularExpressions
- using WolvenKit.Common.FNV1A
- using WolvenKit.Common.Services
- using WolvenKit.Core.CRC
- using WolvenKit.Core.Compression
- using WolvenKit.Core.Exceptions
- using WolvenKit.Core.Extensions
- using WolvenKit.Core.Interfaces
- using WolvenKit.RED4.Archive.Buffer
- using WolvenKit.RED4.Archive.CR2W
- using WolvenKit.RED4.IO
- using WolvenKit.RED4.Types
- using WolvenKit.RED4.Types.Exceptions
- using WolvenKit.RED4.Types.Pools

## Citations

[1] Source files under `WolvenKit.RED4/Archive/IO/` in the WolvenKit repository
