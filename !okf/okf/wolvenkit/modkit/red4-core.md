---
type: "System"
title: "Modkit RED4 Core"
description: "RED4 modding toolkit core (ModTools, Build, Export, Import, Pack, Rebuild, RedConverter, RedMod, RedTypeFactory) — 45 files."
resource: "WolvenKit.Modkit/RED4/Build.cs"
tags: [modkit, red4, core, system]
timestamp: 2026-07-11T19:42:50.322902Z
---

## Overview

RED4 modding toolkit core (ModTools, Build, Export, Import, Pack, Rebuild, RedConverter, RedMod, RedTypeFactory) — 45 files.

This is a **core subsystem** essential for functionality.

## Key Source Files

This concept comprises **59 source files** from the WolvenKit codebase.

| File | Lines | Key Declarations |
|------|-------|-----------------|
| Build.cs | 185 | class ModTools |
| Export.cs | 72 | class ModTools |
| Import.cs | 259 | class ModTools |
| ModToolExtensions.cs | 42 | class ModToolExtensions |
| ModTools.Helper.cs | 166 | class ModTools, enum FindFileResult, record FindFileRecord |
| ModTools.Types.cs | 59 | class ModTools |
| ModTools.cs | 37 | class ModTools |
| Pack.cs | 75 | class ModTools |
| Rebuild.cs | 266 | class ModTools |
| RedConverter.cs | 201 | class ModTools |
| RedMod.cs | 60 | class RedMod |
| RedTypeFactory.cs | 158 | class is, class is, class RedTypeFactory |
| Serialization.cs | 276 | class Serialization, class Yaml, class Json |
| TweakDocument.cs | 13 | class TweakDocument |
| CArrayConverter.cs | 86 | class CArrayConverter, class CArrayConverterInner |
| Converters.cs | 220 | class CFloatJsonConverter, class CBoolJsonConverter, class CUint8JsonConverter, class CUint16JsonConverter, class CUint32JsonConverter |
| ITypeConverterWithTypeDiscriminator.cs | 126 | class ITypeConverterWithTypeDiscriminator, interface to |
| IParserExtensions.cs | 49 | class IParserExtensions |
| TweakTypeConverter.cs | 232 | class TweakTypeConverter |
| Models.cs | 56 | class CustomSoundsModel, enum ECustomSoundType |

## Member Types

All **59** member source files assigned to this concept:

| # | Source File |
|---|-------------|
| 1 | Build.cs |
| 2 | Export.cs |
| 3 | Import.cs |
| 4 | ModToolExtensions.cs |
| 5 | ModTools.Helper.cs |
| 6 | ModTools.Types.cs |
| 7 | ModTools.cs |
| 8 | Pack.cs |
| 9 | Rebuild.cs |
| 10 | RedConverter.cs |
| 11 | RedMod.cs |
| 12 | RedTypeFactory.cs |
| 13 | Serialization.cs |
| 14 | TweakDocument.cs |
| 15 | CArrayConverter.cs |
| 16 | Converters.cs |
| 17 | ITypeConverterWithTypeDiscriminator.cs |
| 18 | IParserExtensions.cs |
| 19 | TweakTypeConverter.cs |
| 20 | Models.cs |
| 21 | SoundEvent.cs |
| 22 | SoundEventMetadata.cs |
| 23 | ArchiveTask.cs |
| 24 | BuildTask.cs |
| 25 | ConflictsTask.cs |
| 26 | ConsoleFunctions.cs |
| 27 | Cr2wTask.cs |
| 28 | ExportTask.cs |
| 29 | HashTask.cs |
| 30 | IConsoleFunctions.cs |
| 31 | ImportTask.cs |
| 32 | OodleTask.cs |
| 33 | PackTask.cs |
| 34 | UnbundleTask.cs |
| 35 | UncookTask.cs |
| 36 | WwiseTask.cs |
| 37 | AnimRootMotion.cs |
| 38 | AnimSIMD.cs |
| 39 | AnimSIMDEncoder.cs |
| 40 | AnimSpline.cs |
| 41 | Shared.cs |
| 42 | AnimationTools.cs |
| 43 | GLTFHelper.cs |
| 44 | MaterialExtractor.cs |
| 45 | StructFunctions.cs |
| 46 | Structs.cs |
| 47 | EntityTools.cs |
| 48 | MaterialTools.cs |
| 49 | MeshImportTools.cs |
| 50 | MeshTools.cs |
| 51 | MlmaskImportTools.cs |
| 52 | MlmaskTools.cs |
| 53 | MorphTargetImportTools.cs |
| 54 | MorphTargetTools.cs |
| 55 | OpusInfo.cs |
| 56 | OpusTools.cs |
| 57 | RigTools.cs |
| 58 | Unbundle.cs |
| 59 | Uncook.cs |

## Architecture

The analyzed files contain approximately **3458 lines** of code across **30 files** (of 59 total).

### Notable Types

- class CArrayConverter
- class CArrayConverterInner
- class CBoolJsonConverter
- class CColorJsonConverter
- class CEulerAnglesJsonConverter
- class CFloatJsonConverter
- class CInt16JsonConverter
- class CInt32JsonConverter
- class CInt64JsonConverter
- class CInt8JsonConverter
- class CNameJsonConverter
- class CQuaternionJsonConverter
- class CResourceConverter
- class CResourceConverterFactory
- class CStringJsonConverter
- class CUint16JsonConverter
- class CUint32JsonConverter
- class CUint64JsonConverter
- class CUint8JsonConverter
- class CVector2JsonConverter
- class CVector3JsonConverter
- class ConflictEntry
- class Conflicts
- class ConsoleFunctions
- class CustomSoundsModel
- class IParserExtensions
- class ITypeConverterWithTypeDiscriminator
- class Json
- class ModToolExtensions
- class ModTools
- class RedMod
- class RedTypeFactory
- class ResolvedConflictEntry
- class ResolvedConflicts
- class Serialization
- class SoundEvent
- class SoundEventMetadata
- class TweakDocument
- class TweakTypeConverter
- class Yaml
- class is
- enum ECustomSoundType
- enum FindFileResult
- interface IConsoleFunctions
- interface to
- record ExportTaskOptions
- record FindFileRecord
- record class

## Dependencies

- using DynamicData.Kernel
- using EFileReadErrorCodes = WolvenKit.RED4.Archive.IO.EFileReadErrorCodes
- using System
- using System.Collections.Generic
- using System.Collections.Immutable
- using System.Diagnostics.CodeAnalysis
- using System.IO
- using System.Linq
- using System.Runtime.Serialization
- using System.Text.RegularExpressions
- using System.Threading
- using System.Threading.Tasks
- using WolvenKit.Common
- using WolvenKit.Common.Conversion
- using WolvenKit.Common.Extensions
- using WolvenKit.Common.FNV1A
- using WolvenKit.Common.Interfaces
- using WolvenKit.Common.Model
- using WolvenKit.Common.Model.Arguments
- using WolvenKit.Common.Services

## Citations

[1] Source files under `WolvenKit.Modkit/RED4/` in the WolvenKit repository
